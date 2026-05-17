import { useEffect, useMemo, useRef, useState } from 'react';

import {
  Box,
  Button,
  Icon,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ReelSymbol = {
  icon_name: string;
  colour: string;
};

type LastSpin = {
  bet: number;
  lineLength: number;
  payout: number;
  isJackpot: boolean;
  net: number;
  resultState: 'idle' | 'loss' | 'win' | 'jackpot';
};

type HistoryEntry = {
  time: string;
  bet: number;
  lineLength: number;
  payout: number;
  net: number;
  isJackpot: boolean;
};

type Data = {
  isPregame: boolean;
  isObserver: boolean;
  working: boolean;
  balance: number;
  icons: ReelSymbol[];
  state: ReelSymbol[][];
  lastSpin: LastSpin;
  history: HistoryEntry[];
  cooldownLeftDs: number;
  baseBet: number;
  defaultBet: number;
  minBet: number;
  maxBet: number;
  betStep: number;
  quickBets: number[];
  payoutLine3: number;
  payoutLine4: number;
  payoutLine5: number;
  payoutJackpot: number;
};

type IconStripProps = {
  iconPool: ReelSymbol[];
  symbolsNeeded: ReelSymbol[];
  spinning: boolean;
};

type BannerProps = {
  balance: number;
  selectedBet: number;
  topPayout: number;
  cooldownActive: boolean;
  cooldownSeconds: string;
  working: boolean;
  lastSpin: LastSpin | undefined;
};

type ResultView = {
  text: string;
  color: 'label' | 'bad' | 'good' | 'average';
  flashy: boolean;
  jackpot: boolean;
};

const ICON_STRIP_LENGTH = 30;

const BANNER_TEXTS = [
  'SHINY SLOTS',
  'SPIN OF FATE',
  'HEY-Y-Y!',
  "IT'S SPIN TIME!",
  'READY TO WIN?',
  'LUCK LOVES BOLD',
  'ONE MORE SPIN',
  'METACOIN MAYHEM',
  '220% GAMBLERS LEAVE BEFORE THE JACKPOT',
];

const FALLBACK_SYMBOL: ReelSymbol = {
  icon_name: 'question',
  colour: 'white',
};

const pickRandom = <T,>(items: T[]) => {
  return items[Math.floor(Math.random() * items.length)];
};

const pickRandomMany = <T,>(items: T[], count: number) => {
  const values: T[] = [];
  for (let i = 0; i < count; i += 1) {
    values.push(pickRandom(items));
  }
  return values;
};

const toSafeInt = (value: number | undefined, fallback: number) => {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) {
    return fallback;
  }
  return Math.round(parsed);
};

const normalizeBet = (
  value: number,
  minBet: number,
  maxBet: number,
  betStep: number,
  fallbackBet: number,
) => {
  const safeMin = Math.max(1, toSafeInt(minBet, 1));
  const safeStep = Math.max(1, toSafeInt(betStep, 1));
  const safeMax = Math.max(safeMin, toSafeInt(maxBet, safeMin));
  const maxSteps = Math.floor((safeMax - safeMin) / safeStep);

  const fallbackSteps = Math.max(
    0,
    Math.min(
      maxSteps,
      Math.round((toSafeInt(fallbackBet, safeMin) - safeMin) / safeStep),
    ),
  );

  if (!Number.isFinite(value)) {
    return safeMin + fallbackSteps * safeStep;
  }

  const parsedValue = toSafeInt(value, safeMin);
  const parsedSteps = Math.round((parsedValue - safeMin) / safeStep);
  const snappedSteps = Math.max(0, Math.min(maxSteps, parsedSteps));
  return safeMin + snappedSteps * safeStep;
};

const scalePayout = (
  basePayout: number,
  selectedBet: number,
  baseBet: number,
) => {
  const safeBasePayout = toSafeInt(basePayout, 0);
  const safeBaseBet = Math.max(1, toSafeInt(baseBet, 1));
  const safeSelectedBet = Math.max(1, toSafeInt(selectedBet, 1));
  return Math.round((safeBasePayout * safeSelectedBet) / safeBaseBet);
};

const getResultView = (lastSpin: LastSpin | undefined): ResultView => {
  if (!lastSpin || lastSpin.resultState === 'idle') {
    return {
      text: 'Ready to spin',
      color: 'label',
      flashy: false,
      jackpot: false,
    };
  }

  switch (lastSpin.resultState) {
    case 'jackpot':
      return {
        text: `JACKPOT +${lastSpin.payout}`,
        color: 'good',
        flashy: true,
        jackpot: true,
      };
    case 'win':
      return {
        text: `WIN +${lastSpin.payout}`,
        color: 'good',
        flashy: true,
        jackpot: false,
      };
    case 'loss':
      return {
        text: `LOSS ${lastSpin.net}`,
        color: 'bad',
        flashy: false,
        jackpot: false,
      };
    default:
      return {
        text: 'Ready to spin',
        color: 'label',
        flashy: false,
        jackpot: false,
      };
  }
};

const IconStrip = (props: IconStripProps) => {
  const { iconPool, symbolsNeeded, spinning } = props;

  const poolKey = iconPool
    .map((symbol) => `${symbol.icon_name}:${symbol.colour}`)
    .join('|');
  const neededKey = symbolsNeeded
    .map((symbol) => `${symbol.icon_name}:${symbol.colour}`)
    .join('|');

  const safePool = useMemo(() => {
    return iconPool.length ? iconPool : [FALLBACK_SYMBOL];
  }, [poolKey]);

  const safeNeeded = useMemo(() => {
    return symbolsNeeded.length
      ? symbolsNeeded
      : [FALLBACK_SYMBOL, FALLBACK_SYMBOL, FALLBACK_SYMBOL];
  }, [neededKey]);

  const [drawnSymbols, setDrawnSymbols] = useState<ReelSymbol[]>([
    ...pickRandomMany(safePool, ICON_STRIP_LENGTH - 3),
    ...safeNeeded,
  ]);

  useEffect(() => {
    if (spinning) {
      setDrawnSymbols((previous) => [
        ...previous.slice(-3),
        ...pickRandomMany(safePool, ICON_STRIP_LENGTH - 6),
        ...safeNeeded,
      ]);
      return;
    }

    setDrawnSymbols([
      ...pickRandomMany(safePool, ICON_STRIP_LENGTH - 3),
      ...safeNeeded,
    ]);
  }, [spinning, safePool, safeNeeded]);

  return (
    <div
      className={classes([
        'MetaCoinSlot__IconStrip',
        spinning && 'MetaCoinSlot__IconStrip--spinning',
      ])}
    >
      {drawnSymbols.map((symbol, index) => (
        <div
          key={`${symbol.icon_name}-${index}`}
          className="MetaCoinSlot__Symbol"
        >
          <Icon
            className={classes([
              'MetaCoinSlot__SymbolIcon',
              `color-${symbol.colour}`,
            ])}
            name={symbol.icon_name}
            size={2.2}
          />
        </div>
      ))}
    </div>
  );
};

const Banner = (props: BannerProps) => {
  const {
    balance,
    selectedBet,
    topPayout,
    cooldownActive,
    cooldownSeconds,
    working,
    lastSpin,
  } = props;

  const [page, setPage] = useState(0);
  const defaultTitle = useRef(pickRandom(BANNER_TEXTS));

  useEffect(() => {
    const interval = window.setInterval(() => {
      setPage((current) => (current + 1) % 4);
    }, 4500);
    return () => window.clearInterval(interval);
  }, []);

  let title = defaultTitle.current;
  let subtitle = `Set your bet and chase up to ${topPayout} metacoins.`;
  let flashy = false;
  let jackpot = false;

  if (working) {
    title = 'REELS SPINNING';
    subtitle = 'Settlement lands after the reveal.';
  } else if (lastSpin?.resultState === 'jackpot') {
    title = `JACKPOT +${lastSpin.payout}`;
    subtitle = 'Five 7s on center line.';
    flashy = true;
    jackpot = true;
  } else if (lastSpin?.resultState === 'win') {
    title = `WIN +${lastSpin.payout}`;
    subtitle = `Line ${lastSpin.lineLength} at bet ${lastSpin.bet}.`;
    flashy = true;
  } else {
    switch (page) {
      case 0:
        title = defaultTitle.current;
        subtitle = `Current stake: ${selectedBet}`;
        break;
      case 1:
        title = `BALANCE ${balance}`;
        subtitle = `Each spin costs your selected bet.`;
        break;
      case 2:
        title = cooldownActive ? `COOLDOWN ${cooldownSeconds}s` : 'SPIN READY';
        subtitle = cooldownActive
          ? 'Spin unlocks when timer ends.'
          : 'Press spin to roll all reels.';
        break;
      default:
        title = `TOP PRIZE ${topPayout}`;
        subtitle = 'Hit 7 7 7 7 7 on center line.';
    }
  }

  return (
    <Section
      className={classes([
        'MetaCoinSlot__Banner',
        flashy && 'MetaCoinSlot__Banner--winning',
        jackpot && 'MetaCoinSlot__Banner--jackpot',
      ])}
    >
      <div className="MetaCoinSlot__BannerTitle">{title}</div>
      <div className="MetaCoinSlot__BannerText">{subtitle}</div>
    </Section>
  );
};

export const MetaCoinSlot = () => {
  const { act, data } = useBackend<Data>();
  const {
    isPregame,
    isObserver,
    working,
    balance,
    icons = [],
    state = [],
    lastSpin,
    history: historyRaw = [],
    cooldownLeftDs,
    baseBet,
    defaultBet,
    minBet,
    maxBet,
    betStep,
    quickBets: quickBetsRaw = [],
    payoutLine3,
    payoutLine4,
    payoutLine5,
    payoutJackpot,
  } = data;

  const safeMinBet = Math.max(1, toSafeInt(minBet, 1));
  const safeStep = Math.max(1, toSafeInt(betStep, 1));
  const safeMaxBet = Math.max(safeMinBet, toSafeInt(maxBet, safeMinBet));
  const safeDefaultBet = normalizeBet(
    toSafeInt(defaultBet, safeMinBet),
    safeMinBet,
    safeMaxBet,
    safeStep,
    safeMinBet,
  );
  const safeBaseBet = Math.max(1, toSafeInt(baseBet, safeDefaultBet));

  const iconPool = useMemo(() => {
    return icons.length ? icons : [FALLBACK_SYMBOL];
  }, [icons]);

  const reels = useMemo(() => {
    if (state.length) {
      return state;
    }
    const filler = pickRandomMany(iconPool, 3);
    return [filler, filler, filler, filler, filler];
  }, [state, iconPool]);

  const history = Array.isArray(historyRaw) ? historyRaw : [];

  const [selectedBet, setSelectedBet] = useState(safeDefaultBet);
  const [cooldownUntilMs, setCooldownUntilMs] = useState(0);
  const [clockMs, setClockMs] = useState(Date.now());

  useEffect(() => {
    setSelectedBet((current) =>
      normalizeBet(current, safeMinBet, safeMaxBet, safeStep, safeDefaultBet),
    );
  }, [safeMinBet, safeMaxBet, safeStep, safeDefaultBet]);

  useEffect(() => {
    if (cooldownLeftDs > 0) {
      setCooldownUntilMs(Date.now() + cooldownLeftDs * 100);
      return;
    }
    setCooldownUntilMs(0);
  }, [cooldownLeftDs]);

  useEffect(() => {
    const interval = window.setInterval(() => {
      setClockMs(Date.now());
    }, 100);
    return () => window.clearInterval(interval);
  }, []);

  const quickBets = useMemo(() => {
    const result: number[] = [];
    const seen = new Set<number>();

    for (const rawBet of quickBetsRaw) {
      const bet = normalizeBet(
        Number(rawBet),
        safeMinBet,
        safeMaxBet,
        safeStep,
        safeDefaultBet,
      );
      if (seen.has(bet)) {
        continue;
      }
      seen.add(bet);
      result.push(bet);
    }

    if (result.length) {
      return result.slice(0, 4);
    }

    for (const fallbackBet of [safeMinBet, safeDefaultBet, safeMaxBet]) {
      if (seen.has(fallbackBet)) {
        continue;
      }
      seen.add(fallbackBet);
      result.push(fallbackBet);
    }

    return result.slice(0, 4);
  }, [quickBetsRaw, safeMinBet, safeMaxBet, safeStep, safeDefaultBet]);

  const cooldownMsLeft = Math.max(0, cooldownUntilMs - clockMs);
  const cooldownActive = cooldownMsLeft > 0;
  const cooldownSeconds = (cooldownMsLeft / 1000).toFixed(1);

  const scaledLine3 = scalePayout(payoutLine3, selectedBet, safeBaseBet);
  const scaledLine4 = scalePayout(payoutLine4, selectedBet, safeBaseBet);
  const scaledLine5 = scalePayout(payoutLine5, selectedBet, safeBaseBet);
  const scaledJackpot = scalePayout(payoutJackpot, selectedBet, safeBaseBet);

  const resultView = getResultView(lastSpin);
  const spinLocked =
    working ||
    cooldownActive ||
    (!isPregame && !isObserver) ||
    balance < selectedBet;

  const handleSpin = () => {
    if (spinLocked) {
      return;
    }
    act('spin', {
      bet: selectedBet,
    });
  };

  return (
    <Window title="Metacoin Slot Machine" width={950} height={760}>
      <Window.Content scrollable>
        <div className="MetaCoinSlot">
          {!isPregame && !isObserver && (
            <NoticeBox danger>
              Slot machine is available only before round start.
            </NoticeBox>
          )}

          <Banner
            balance={balance}
            selectedBet={selectedBet}
            topPayout={scaledJackpot}
            cooldownActive={cooldownActive}
            cooldownSeconds={cooldownSeconds}
            working={working}
            lastSpin={lastSpin}
          />

          <Stack>
            <Stack.Item grow={2}>
              <Section title="Reels" className="MetaCoinSlot__ReelsSection">
                <div className="MetaCoinSlot__Reels">
                  {reels.map((reel, index) => (
                    <div key={index} className="MetaCoinSlot__Reel">
                      <IconStrip
                        iconPool={iconPool}
                        symbolsNeeded={reel}
                        spinning={working}
                      />
                    </div>
                  ))}
                </div>
              </Section>

              <Section
                title="Spin Result"
                className="MetaCoinSlot__ResultSection"
              >
                <Box
                  className={classes([
                    'MetaCoinSlot__ResultBadge',
                    resultView.flashy && 'MetaCoinSlot__ResultBadge--flashy',
                    resultView.jackpot && 'MetaCoinSlot__ResultBadge--jackpot',
                  ])}
                  color={resultView.color}
                  bold
                  textAlign="center"
                >
                  {resultView.text}
                </Box>

                <Stack mt={1}>
                  <Stack.Item grow>
                    <Box>
                      Bet: <b>{lastSpin?.bet ?? selectedBet}</b>
                    </Box>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box>
                      Line: <b>{lastSpin?.lineLength ?? 0}</b>
                    </Box>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box>
                      Payout: <b>{lastSpin?.payout ?? 0}</b>
                    </Box>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box color={(lastSpin?.net ?? 0) >= 0 ? 'good' : 'bad'}>
                      Net: <b>{lastSpin?.net ?? 0}</b>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>

            <Stack.Item grow>
              <Section title="Session" className="MetaCoinSlot__SessionSection">
                <Box>
                  Balance: <b>{balance}</b>
                </Box>
                <Box mt={0.5}>
                  Base bet: <b>{safeBaseBet}</b>
                </Box>
                <Box mt={0.5} color={cooldownActive ? 'average' : 'good'}>
                  {cooldownActive
                    ? `Cooldown: ${cooldownSeconds}s`
                    : 'Spin ready'}
                </Box>

                <Box mt={1} mb={0.5} bold>
                  Bet
                </Box>
                <NumberInput
                  width="100%"
                  minValue={safeMinBet}
                  maxValue={safeMaxBet}
                  step={safeStep}
                  value={selectedBet}
                  disabled={working}
                  onChange={(value) =>
                    setSelectedBet(
                      normalizeBet(
                        value,
                        safeMinBet,
                        safeMaxBet,
                        safeStep,
                        safeDefaultBet,
                      ),
                    )
                  }
                />

                <div className="MetaCoinSlot__QuickBets">
                  {quickBets.map((bet) => (
                    <Button
                      key={bet}
                      className="MetaCoinSlot__QuickBet"
                      selected={bet === selectedBet}
                      color={bet === selectedBet ? 'good' : undefined}
                      disabled={working}
                      onClick={() => setSelectedBet(bet)}
                    >
                      {bet}
                    </Button>
                  ))}
                </div>

                <Box mt={1}>
                  <Button
                    fluid
                    icon="dice"
                    color="green"
                    disabled={spinLocked}
                    onClick={handleSpin}
                  >
                    {working
                      ? 'Spinning...'
                      : cooldownActive
                        ? `Cooldown ${cooldownSeconds}s`
                        : `Spin ${selectedBet}`}
                  </Button>
                </Box>
              </Section>

              <Section
                title="Payout Table"
                className="MetaCoinSlot__PayoutSection"
              >
                <Box mb={0.5} color="label">
                  Values scale with bet <b>{selectedBet}</b>.
                </Box>
                <Table>
                  <Table.Row header>
                    <Table.Cell bold>Condition</Table.Cell>
                    <Table.Cell bold textAlign="right">
                      Reward
                    </Table.Cell>
                  </Table.Row>
                  <Table.Row>
                    <Table.Cell>3 in a row</Table.Cell>
                    <Table.Cell textAlign="right">{scaledLine3}</Table.Cell>
                  </Table.Row>
                  <Table.Row>
                    <Table.Cell>4 in a row</Table.Cell>
                    <Table.Cell textAlign="right">{scaledLine4}</Table.Cell>
                  </Table.Row>
                  <Table.Row>
                    <Table.Cell>5 in a row</Table.Cell>
                    <Table.Cell textAlign="right">{scaledLine5}</Table.Cell>
                  </Table.Row>
                  <Table.Row>
                    <Table.Cell>Jackpot (center 7 7 7 7 7)</Table.Cell>
                    <Table.Cell textAlign="right">{scaledJackpot}</Table.Cell>
                  </Table.Row>
                </Table>
              </Section>
            </Stack.Item>
          </Stack>

          <Section
            title="Recent Spins"
            className="MetaCoinSlot__HistorySection"
          >
            {!history.length ? (
              <NoticeBox>No spins yet.</NoticeBox>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell collapsing bold>
                    Time
                  </Table.Cell>
                  <Table.Cell collapsing bold textAlign="right">
                    Bet
                  </Table.Cell>
                  <Table.Cell collapsing bold textAlign="right">
                    Line
                  </Table.Cell>
                  <Table.Cell collapsing bold textAlign="right">
                    Payout
                  </Table.Cell>
                  <Table.Cell collapsing bold textAlign="right">
                    Net
                  </Table.Cell>
                </Table.Row>
                {history.map((entry, index) => (
                  <Table.Row key={`${entry.time}-${index}`}>
                    <Table.Cell collapsing>{entry.time}</Table.Cell>
                    <Table.Cell collapsing textAlign="right">
                      {entry.bet}
                    </Table.Cell>
                    <Table.Cell collapsing textAlign="right">
                      {entry.lineLength}
                    </Table.Cell>
                    <Table.Cell collapsing textAlign="right">
                      {entry.payout}
                    </Table.Cell>
                    <Table.Cell
                      collapsing
                      textAlign="right"
                      color={entry.net >= 0 ? 'good' : 'bad'}
                    >
                      {entry.net}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            )}
          </Section>
        </div>
      </Window.Content>
    </Window>
  );
};
