import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { type Objective, ObjectivePrintout } from './common/Objectives';

type Ability = {
  name: string;
  desc: string;
  cost: number;
  unlocked: boolean;
  ref: string;
};

type Info = {
  fluff: string;
  explain_attack: BooleanLike;
  objectives: Objective[];
  points: number;
  demonsin: string;
  abilities: Ability[];
  next_refresh_in: number;
  can_reroll_sin: boolean;
};

export const AntagInfoSinfulDemon = (props) => {
  const { act, data } = useBackend<Info>();
  const {
    fluff,
    objectives,
    points,
    demonsin,
    abilities,
    next_refresh_in,
    can_reroll_sin,
  } = data;
  const [activeTab, setActiveTab] = useState<'objectives' | 'shop'>(
    'objectives',
  );

  const formatTime = (secs: number) => {
    const m = Math.floor(secs / 60);
    const s = Math.floor(secs % 60);
    return `${m}:${s < 10 ? '0' : ''}${s}`;
  };

  return (
    <Window width={680} height={450} theme="syndicate">
      <Window.Content style={{ backgroundImage: 'none' }}>
        <Stack fill>
          <Stack.Item>
            <DemonRunes />
          </Stack.Item>
          <Stack.Item grow>
            <Stack vertical fill>
              <Stack.Item>
                <Tabs
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    width: '100%',
                  }}
                >
                  <Tabs.Tab
                    selected={activeTab === 'objectives'}
                    onClick={() => setActiveTab('objectives')}
                  >
                    Objectives
                  </Tabs.Tab>
                  <Tabs.Tab
                    selected={activeTab === 'shop'}
                    onClick={() => setActiveTab('shop')}
                  >
                    Infernal Shop ({points} SP)
                  </Tabs.Tab>

                  <div style={{ flexGrow: 1 }} />

                  <Box style={{ marginRight: '5px', paddingBottom: '3px' }}>
                    <Button
                      icon="redo"
                      color={can_reroll_sin ? 'danger' : 'default'}
                      disabled={!can_reroll_sin || points < 666}
                      onClick={() => act('reroll_sin')}
                    >
                      {can_reroll_sin ? 'Reroll Sin (666 SP)' : 'Rerolled'}
                    </Button>
                  </Box>
                </Tabs>
              </Stack.Item>

              <Stack.Item grow>
                {activeTab === 'objectives' && (
                  <Section
                    fill
                    scrollable={objectives.length > 2}
                    title="Your Demonic Duty"
                    buttons={
                      <Box textColor="gray" inline italic fontSize="12px">
                        Rotation In: {formatTime(next_refresh_in)}
                      </Box>
                    }
                  >
                    <Stack vertical fill>
                      <Stack.Item
                        textAlign="center"
                        textColor="red"
                        fontSize="20px"
                      >
                        {fluff}
                      </Stack.Item>
                      <Stack.Item>
                        <ObjectivePrintout
                          titleMessage={`You are a Demon of ${demonsin?.toUpperCase()} and there is your objectives`}
                          objectiveTextSize="18px"
                          objectives={objectives}
                        />
                      </Stack.Item>
                    </Stack>
                  </Section>
                )}

                {activeTab === 'shop' && (
                  <Section
                    fill
                    scrollable
                    title="Purchase Infernal Abilities"
                    buttons={
                      <Box textColor="white" bold fontSize="14px">
                        Balance: {points} SP
                      </Box>
                    }
                  >
                    <Stack vertical>
                      <Stack.Item>
                        <NoticeBox color="red">
                          Earn points passively by staying at full health on the
                          station or completing goals.
                        </NoticeBox>
                      </Stack.Item>
                      {abilities?.map((ability) => (
                        <Stack.Item key={ability.ref}>
                          <Section
                            level={2}
                            title={ability.name}
                            buttons={
                              <Button
                                disabled={
                                  ability.unlocked || points < ability.cost
                                }
                                color={ability.unlocked ? 'green' : 'red'}
                                onClick={() =>
                                  act('buy_ability', { ref: ability.ref })
                                }
                              >
                                {ability.unlocked
                                  ? 'Unlocked'
                                  : `${ability.cost} SP`}
                              </Button>
                            }
                          >
                            <Box textColor="label">{ability.desc}</Box>
                          </Section>
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Section>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <DemonRunes />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const DemonRunes = (props) => {
  return (
    <Section height="102%" mt="-6px" fill>
      {/*
      shoutout to my boy Yuktopus from Crash Bandicoot: Crash of the Titans.
      Damn, that was such a good game.
      */}
      <Box className="HellishRunes__demonrune">
        Y<br />U<br />K<br />T<br />O<br />P<br />U<br />S<br />
        Y<br />U<br />K<br />T<br />O<br />P<br />U<br />S<br />
        Y<br />U<br />K<br />T<br />O<br />P<br />U<br />S<br />
        Y<br />U<br />K<br />T<br />O<br />P<br />U<br />S
      </Box>
    </Section>
  );
};
