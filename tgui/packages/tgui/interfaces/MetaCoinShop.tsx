import {
  Box,
  Button,
  DmIcon,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type ShopItem = {
  id: string;
  kind?: 'item' | 'antag_token';
  name: string;
  desc: string;
  price: number;
  icon?: string;
  iconState?: string;
  fallbackIcon?: string;
  owned: boolean;
  canAfford: boolean;
  tokensLeft?: number;
  selectedRoleName?: string | null;
};

type Data = {
  isPregame: boolean;
  balance: number;
  antagTokenSlotsLeft: number;
  preroundItems: ShopItem[];
  persistentItems: ShopItem[];
};

// MASSMETA EDIT ADDITION START (metacoins)
const renderListingIcon = (item: ShopItem) => {
  const fallbackName = item.fallbackIcon || 'question-circle';
  const fallbackNode = <Icon name={fallbackName} size={2} />;

  if (item.icon && item.iconState) {
    return (
      <DmIcon
        icon={item.icon}
        icon_state={item.iconState}
        width="42px"
        height="42px"
        fallback={fallbackNode}
      />
    );
  }

  return fallbackNode;
};
// MASSMETA EDIT ADDITION END (metacoins)

export const MetaCoinShop = () => {
  const { act, data } = useBackend<Data>();
  const { isPregame, balance, preroundItems = [] } = data;

  const [activeTab, setActiveTab] = useLocalState<'preround' | 'persistent'>(
    'metacoinShopTab',
    'preround',
  );

  return (
    <Window title="Metacoin Shop" width={560} height={500}>
      <Window.Content scrollable>
        <Section
          title="Balance"
          buttons={
            <Button icon="dice" onClick={() => act('open_slots')}>
              Open Slot Machine
            </Button>
          }
        >
          <Box fontSize="20px" bold color="good">
            {balance}
          </Box>
        </Section>

        <Section fitted>
          <Tabs>
            <Tabs.Tab
              selected={activeTab === 'preround'}
              onClick={() => setActiveTab('preround')}
            >
              Preround shop
            </Tabs.Tab>
            <Tabs.Tab
              selected={activeTab === 'persistent'}
              onClick={() => setActiveTab('persistent')}
            >
              Persistent rewards
            </Tabs.Tab>
          </Tabs>
        </Section>

        {activeTab === 'preround' && (
          <Section
            title="Preround shop"
            buttons={
              <Box color={isPregame ? 'good' : 'bad'}>
                {isPregame
                  ? 'Purchases are open (pregame)'
                  : 'Purchases are closed'}
              </Box>
            }
          >
            {!preroundItems.length ? (
              <NoticeBox>No items available.</NoticeBox>
            ) : (
              <Stack vertical>
                {preroundItems.map((item) => (
                  <Stack.Item key={item.id}>
                    {(() => {
                      const isAntagToken = item.kind === 'antag_token';
                      const owned = Boolean(item.owned);
                      const canAfford = Boolean(item.canAfford);
                      const tokensLeft = Number(item.tokensLeft || 0);
                      const tokenSoldOut = isAntagToken && tokensLeft <= 0;

                      const buttonDisabled = isAntagToken
                        ? !isPregame || owned || !canAfford || tokenSoldOut
                        : !isPregame || owned || !canAfford;

                      const buttonText = isAntagToken
                        ? `Choose Role (${item.price})`
                        : `Buy (${item.price})`;

                      const buttonAction = () => {
                        if (isAntagToken) {
                          act('open_antag_token');
                          return;
                        }

                        act('buy_preround', {
                          itemId: item.id,
                        });
                      };

                      return (
                        <Section
                          title={item.name}
                          buttons={
                            <Button
                              icon={
                                isAntagToken ? 'user-secret' : 'shopping-cart'
                              }
                              disabled={buttonDisabled}
                              onClick={buttonAction}
                            >
                              {buttonText}
                            </Button>
                          }
                        >
                          <Stack>
                            <Stack.Item>{renderListingIcon(item)}</Stack.Item>
                            <Stack.Item grow>
                              <Box>{item.desc}</Box>
                              <Box mt={1} color="label">
                                Price: {item.price}
                              </Box>

                              {isAntagToken && (
                                <Box
                                  mt={1}
                                  color={tokensLeft > 0 ? 'average' : 'bad'}
                                >
                                  Tokens left this round: {tokensLeft}
                                </Box>
                              )}

                              {isAntagToken &&
                                item.selectedRoleName &&
                                owned && (
                                  <Box mt={1} color="good">
                                    Reserved role: {item.selectedRoleName}
                                  </Box>
                                )}

                              {owned && !isAntagToken && (
                                <Box mt={1} color="good">
                                  Already purchased for this round.
                                </Box>
                              )}

                              {owned && isAntagToken && (
                                <Box mt={1} color="good">
                                  Antag token already purchased for this round.
                                </Box>
                              )}

                              {!canAfford && !owned && (
                                <Box mt={1} color="bad">
                                  Not enough metacoins.
                                </Box>
                              )}

                              {tokenSoldOut && !owned && (
                                <Box mt={1} color="bad">
                                  No antag tokens left this round.
                                </Box>
                              )}
                            </Stack.Item>
                          </Stack>
                        </Section>
                      );
                    })()}
                  </Stack.Item>
                ))}
              </Stack>
            )}
          </Section>
        )}

        {activeTab === 'persistent' && (
          <Section title="Persistent rewards">
            <NoticeBox>Persistent rewards are not implemented yet.</NoticeBox>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
