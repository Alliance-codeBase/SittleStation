import {
  Box,
  Button,
  DmIcon,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Data = {
  dbConnected: boolean;
  balance: number;
  coinIcon: string;
  coinIconState: string;
  roundAwardsApplied: boolean;
  roundAwarded: number;
  roundAwardLog: RewardEntry[];
  canOpenShop: boolean;
};

type RewardEntry = {
  amount: number;
  source: string;
  reason: string;
  time: string;
};

export const MetaCoins = () => {
  const { act, data } = useBackend<Data>();
  const {
    dbConnected,
    balance,
    coinIcon,
    coinIconState,
    roundAwardsApplied,
    roundAwarded,
    roundAwardLog,
    canOpenShop,
  } = data;
  const [activeTab, setActiveTab] = useLocalState<'overview' | 'log'>(
    'metacoinTab',
    'overview',
  );

  return (
    <Window title="Metacoins" width={520} height={460}>
      <Window.Content scrollable>
        {!dbConnected && (
          <NoticeBox danger>
            Database connection is unavailable right now.
          </NoticeBox>
        )}

        <Section fitted>
          <Tabs>
            <Tabs.Tab
              selected={activeTab === 'overview'}
              onClick={() => setActiveTab('overview')}
            >
              Overview
            </Tabs.Tab>
            <Tabs.Tab
              selected={activeTab === 'log'}
              onClick={() => setActiveTab('log')}
            >
              Round Reward Log
            </Tabs.Tab>
          </Tabs>
        </Section>

        {activeTab === 'overview' && (
          <Section
            title="Balance"
            buttons={
              canOpenShop ? (
                <Button icon="shopping-cart" onClick={() => act('open_shop')}>
                  Open Shop
                </Button>
              ) : null
            }
          >
            <Stack align="center">
              <Stack.Item>
                <Box width="80px" height="80px" mt={-0.5}>
                  <DmIcon
                    width="80px"
                    height="80px"
                    icon={coinIcon}
                    icon_state={coinIconState}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item grow>
                <Box fontSize="24px" bold color="good">
                  {balance}
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        )}

        {activeTab === 'log' && (
          <Section
            title="Round reward log"
            buttons={
              <Box color={roundAwardsApplied ? 'good' : 'average'}>
                {roundAwardsApplied
                  ? `Round total: +${roundAwarded}`
                  : 'Round-end rewards are not processed yet'}
              </Box>
            }
          >
            {!roundAwardLog?.length ? (
              <NoticeBox>
                No metacoin rewards were granted in this round yet.
              </NoticeBox>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell collapsing bold>
                    Time
                  </Table.Cell>
                  <Table.Cell bold>Reason</Table.Cell>
                  <Table.Cell collapsing bold textAlign="right">
                    Amount
                  </Table.Cell>
                </Table.Row>
                {roundAwardLog.map((entry, index) => (
                  <Table.Row key={`${entry.time}-${entry.source}-${index}`}>
                    <Table.Cell collapsing>{entry.time || 'N/A'}</Table.Cell>
                    <Table.Cell>
                      {entry.reason || entry.source || 'Unknown'}
                    </Table.Cell>
                    <Table.Cell
                      collapsing
                      textAlign="right"
                      color={entry.amount > 0 ? 'good' : 'bad'}
                    >
                      {entry.amount > 0 ? `+${entry.amount}` : entry.amount}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            )}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
