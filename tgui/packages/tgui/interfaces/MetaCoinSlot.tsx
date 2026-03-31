import { useEffect, useMemo, useState } from 'react';

import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ReelSymbol = {
  icon_name: string;
  colour: string;
};

type LastSpin = {
  lineLength: number;
  payout: number;
  isJackpot: boolean;
  net: number;
  resultState: 'idle' | 'loss' | 'win' | 'jackpot';
};

type HistoryEntry = {
  time: string;
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
  cost: number;
  payoutLine3: number;
  payoutLine4: number;
  payoutLine5: number;
  payoutJackpot: number;
};

type ReelProps = {
  reel: ReelSymbol[];
};

type TileProps = {
  symbol: ReelSymbol;
};

const Reel = (props: ReelProps) => {
  const { reel } = props;
  return (
    <Box
      style={{
        display: 'inline-flex',
        flexDirection: 'column',
      }}
    >
      {reel.map((symbol, index) => (
        <Tile key={index} symbol={symbol} />
      ))}
    </Box>
  );
};

const Tile = (props: TileProps) => {
  const { symbol } = props;
  return (
    <Box
      style={{
        textAlign: 'center',
        padding: '0.85rem',
        margin: '0.35rem',
        width: '4.3rem',
        background: 'rgba(62, 97, 137, 1)',
      }}
    >
      <Icon
        className={`color-${symbol.colour}`}
        size={2.2}
        name={symbol.icon_name}
      />
    </Box>
  );
};

const getResultView = (lastSpin: LastSpin | undefined) => {
  if (!lastSpin) {
    return {
      text: 'Ready to spin',
      color: 'label' as const,
    };
  }

  switch (lastSpin.resultState) {
    case 'jackpot':
      return {
        text: `JACKPOT +${lastSpin.payout}`,
        color: 'good' as const,
      };
    case 'win':
      return {
        text: `WIN +${lastSpin.payout}`,
        color: 'good' as const,
      };
    case 'loss':
      return {
        text: `LOSE ${lastSpin.net}`,
        color: 'bad' as const,
      };
    default:
      return {
        text: 'Ready to spin',
        color: 'label' as const,
      };
  }
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
    cost,
    payoutLine3,
    payoutLine4,
    payoutLine5,
    payoutJackpot,
  } = data;

  const history = Array.isArray(historyRaw) ? historyRaw : [];

  const [displayState, setDisplayState] = useState<ReelSymbol[][]>(state);
  const [localRolling, setLocalRolling] = useState(false);
  const [rollMinEndsAtMs, setRollMinEndsAtMs] = useState(0);
  const [cooldownUntilMs, setCooldownUntilMs] = useState(0);
  const [clockMs, setClockMs] = useState(Date.now());
  const [frozenLastSpin, setFrozenLastSpin] = useState<LastSpin | undefined>(
    lastSpin,
  );
  const [frozenHistory, setFrozenHistory] = useState<HistoryEntry[]>(history);

  const iconPool = useMemo(() => {
    if (icons.length) {
      return icons;
    }
    return [
      {
        icon_name: 'question',
        colour: 'white',
      },
    ];
  }, [icons]);

  useEffect(() => {
    if (!localRolling) {
      setDisplayState(state);
    }
  }, [state, localRolling]);

  useEffect(() => {
    if (!cooldownLeftDs) {
      return;
    }

    setCooldownUntilMs(Date.now() + cooldownLeftDs * 100);
  }, [cooldownLeftDs]);

  useEffect(() => {
    const interval = window.setInterval(() => {
      setClockMs(Date.now());
    }, 100);

    return () => window.clearInterval(interval);
  }, []);

  useEffect(() => {
    if (!localRolling) {
      return;
    }

    const interval = window.setInterval(() => {
      if (Date.now() >= rollMinEndsAtMs && !working) {
        setLocalRolling(false);
        setDisplayState(state);
        window.clearInterval(interval);
        return;
      }

      setDisplayState((previous) =>
        previous.map((reel) =>
          reel.map(() => iconPool[Math.floor(Math.random() * iconPool.length)]),
        ),
      );
    }, 70);

    return () => window.clearInterval(interval);
  }, [iconPool, localRolling, rollMinEndsAtMs, state, working]);

  const cooldownMsLeft = Math.max(0, cooldownUntilMs - clockMs);
  const cooldownActive = cooldownMsLeft > 0;
  const cooldownSeconds = (cooldownMsLeft / 1000).toFixed(1);

  const displayedLastSpin = localRolling ? frozenLastSpin : lastSpin;
  const displayedHistory = localRolling ? frozenHistory : history;
  const resultView = getResultView(displayedLastSpin);
  const spinLocked =
    working ||
    localRolling ||
    (!isPregame && !isObserver) ||
    balance < cost ||
    cooldownActive;

  const handleSpin = () => {
    if (spinLocked) {
      return;
    }

    setFrozenLastSpin(lastSpin);
    setFrozenHistory(history);
    setRollMinEndsAtMs(Date.now() + 500);
    setLocalRolling(true);
    act('spin');
  };

  return (
    <Window title="Metacoin Slot Machine" width={900} height={720}>
      <Window.Content scrollable>
        {!isPregame && !isObserver && (
          <NoticeBox danger>
            Slot machine is available only before round start.
          </NoticeBox>
        )}

        <Section title="Session">
          <Stack>
            <Stack.Item grow>
              <Box>
                Balance: <b>{balance}</b>
              </Box>
              <Box>
                Spin cost: <b>{cost}</b>
              </Box>
              <Box color={cooldownActive ? 'average' : 'good'}>
                {cooldownActive
                  ? `Cooldown: ${cooldownSeconds}s`
                  : 'Spin ready'}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button icon="dice" disabled={spinLocked} onClick={handleSpin}>
                {working || localRolling
                  ? 'Spinning...'
                  : cooldownActive
                    ? `Cooldown ${cooldownSeconds}s`
                    : 'Spin'}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Spin result">
          <Box fontSize="20px" bold color={resultView.color} textAlign="center">
            {resultView.text}
          </Box>
          <Stack mt={1}>
            <Stack.Item grow>
              <Box>
                Line length: <b>{displayedLastSpin?.lineLength || 0}</b>
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Box>
                Payout: <b>{displayedLastSpin?.payout || 0}</b>
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Box color={(displayedLastSpin?.net || 0) >= 0 ? 'good' : 'bad'}>
                Net: <b>{displayedLastSpin?.net || 0}</b>
              </Box>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Payout table">
          <Table>
            <Table.Row header>
              <Table.Cell bold>Condition</Table.Cell>
              <Table.Cell bold textAlign="right">
                Reward
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>3 in a row</Table.Cell>
              <Table.Cell textAlign="right">{payoutLine3}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>4 in a row</Table.Cell>
              <Table.Cell textAlign="right">{payoutLine4}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>5 in a row</Table.Cell>
              <Table.Cell textAlign="right">{payoutLine5}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Jackpot (middle row 7 7 7 7 7)</Table.Cell>
              <Table.Cell textAlign="right">{payoutJackpot}</Table.Cell>
            </Table.Row>
          </Table>
        </Section>

        <Section title="Reels">
          <Box
            style={{
              display: 'flex',
              justifyContent: 'center',
              gap: '0.3rem',
            }}
          >
            {displayState.map((reel, index) => (
              <Reel key={index} reel={reel} />
            ))}
          </Box>
        </Section>

        <Section title="Recent spins">
          {!displayedHistory.length ? (
            <NoticeBox>No spins yet.</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell collapsing bold>
                  Time
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
              {displayedHistory.map((entry, index) => (
                <Table.Row key={`${entry.time}-${index}`}>
                  <Table.Cell collapsing>{entry.time}</Table.Cell>
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
      </Window.Content>
    </Window>
  );
};
