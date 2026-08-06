import {
  Box,
  Button,
  DmIcon,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type VariantOption = {
  id: string;
  name: string;
};

type VariantOptions = Record<string, VariantOption[]>;

type Reward = {
  id: string;
  name: string;
  desc: string;
  icon?: string;
  iconState?: string;
  fallbackIcon?: string;
  enabled: boolean;
  variant?: string | null;
  variantOptions?: VariantOptions | null;
};

type Data = {
  rewards: Reward[];
};

const renderRewardIcon = (reward: Reward) => {
  const fallbackName = reward.fallbackIcon || 'question-circle';
  const fallbackNode = <Icon name={fallbackName} size={2} />;

  if (reward.icon && reward.iconState) {
    return (
      <DmIcon
        icon={reward.icon}
        icon_state={reward.iconState}
        width="42px"
        height="42px"
        fallback={fallbackNode}
      />
    );
  }

  return fallbackNode;
};

const parseVariant = (variant: string | null | undefined) => {
  if (!variant) {
    return {};
  }

  try {
    return JSON.parse(variant) as Record<string, string>;
  } catch {
    return {};
  }
};

export const MetacoinSettings = () => {
  const { act, data } = useBackend<Data>();
  const { rewards = [] } = data;

  return (
    <Window title="Settings" width={560} height={500}>
      <Window.Content scrollable>
        {!rewards.length ? (
          <NoticeBox>No owned persistent rewards.</NoticeBox>
        ) : (
          <Stack vertical>
            {rewards.map((reward) => {
              const enabled = Boolean(reward.enabled);
              const currentVariant = parseVariant(reward.variant);

              return (
                <Stack.Item key={reward.id}>
                  <Section
                    title={reward.name}
                    buttons={
                      <Button
                        icon="cog"
                        selected={enabled}
                        tooltip={
                          enabled
                            ? 'Enabled: click to disable'
                            : 'Disabled: click to enable'
                        }
                        onClick={() =>
                          act('toggle_persistent', {
                            rewardId: reward.id,
                          })
                        }
                      />
                    }
                  >
                    <Stack>
                      <Stack.Item>{renderRewardIcon(reward)}</Stack.Item>
                      <Stack.Item grow>
                        <Box>{reward.desc}</Box>
                        <Box mt={1} color={enabled ? 'good' : 'bad'}>
                          {enabled ? 'Enabled' : 'Disabled'}
                        </Box>

                        {reward.variantOptions &&
                          Object.entries(reward.variantOptions).map(
                            ([groupName, options]) => (
                              <Box key={groupName} mt={1}>
                                <Box color="label">{groupName}</Box>
                                <Stack mt={1}>
                                  {options.map((option) => (
                                    <Stack.Item key={option.id}>
                                      <Button
                                        selected={
                                          currentVariant[groupName] ===
                                          option.id
                                        }
                                        onClick={() =>
                                          act('set_variant', {
                                            rewardId: reward.id,
                                            variant: JSON.stringify({
                                              ...currentVariant,
                                              [groupName]: option.id,
                                            }),
                                          })
                                        }
                                      >
                                        {option.name}
                                      </Button>
                                    </Stack.Item>
                                  ))}
                                </Stack>
                              </Box>
                            ),
                          )}
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              );
            })}
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
