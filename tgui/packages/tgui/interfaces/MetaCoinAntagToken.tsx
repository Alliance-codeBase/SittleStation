import { Box, Button, Icon, NoticeBox, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type RoleOption = {
  id: string;
  name: string;
  desc: string;
  prefIconClass?: string;
  fallbackIcon?: string;
  available: boolean;
  unavailableReason?: string | null;
  unavailableCode?: string | null;
  minPopCurrent?: number | null;
  minPopRequired?: number | null;
};

type Data = {
  isPregame: boolean;
  balance: number;
  price: number;
  slotsLeft: number;
  alreadyPurchased: boolean | number;
  selectedRoleName?: string | null;
  roles?: RoleOption[] | Record<string, RoleOption | number | null> | null;
  restrictedJobPreferences?: string[] | null;
  restrictedJobWarning?: string | null;
};

export const MetaCoinAntagToken = () => {
  const { act, data } = useBackend<Data>();
  const {
    isPregame,
    balance,
    price,
    slotsLeft,
    alreadyPurchased,
    selectedRoleName,
    roles: rawRoles = [],
    restrictedJobPreferences: rawRestrictedJobPreferences = [],
    restrictedJobWarning,
  } = data;

  const roles = (
    Array.isArray(rawRoles) ? rawRoles : Object.values(rawRoles || {})
  ).filter(
    (role): role is RoleOption =>
      !!role && typeof role === 'object' && 'id' in role,
  );

  const hasPurchasedToken = Boolean(alreadyPurchased);

  const restrictedJobPreferences = Array.isArray(rawRestrictedJobPreferences)
    ? rawRestrictedJobPreferences.filter(
        (job): job is string => !!job && typeof job === 'string',
      )
    : [];

  const restrictedJobsWarningText =
    restrictedJobWarning ||
    (restrictedJobPreferences.length
      ? `Warning: restricted job preferences enabled (${restrictedJobPreferences.join(', ')}). If assigned at roundstart, token will be refunded.`
      : null);

  const canBuyToken =
    isPregame && !hasPurchasedToken && slotsLeft > 0 && balance >= price;

  return (
    <Window title="Metacoin Antag Token" width={1160} height={640}>
      <Window.Content scrollable>
        {!isPregame && (
          <NoticeBox danger>
            Antag token can be purchased only before round start.
          </NoticeBox>
        )}

        <NoticeBox info>
          Press <b>Ready</b> before round start to receive the selected
          antagonist role.
        </NoticeBox>

        <Section title="Status">
          <Box>
            Balance: <b>{balance}</b>
          </Box>
          <Box>
            Token price: <b>{price}</b>
          </Box>
          <Box color={slotsLeft > 0 ? 'average' : 'bad'}>
            Tokens left this round: <b>{slotsLeft}</b>
          </Box>
        </Section>

        {hasPurchasedToken && (
          <NoticeBox success>
            You already purchased an antag token for this round.
            {selectedRoleName ? ` Selected role: ${selectedRoleName}.` : ''}
          </NoticeBox>
        )}

        {!!restrictedJobsWarningText && (
          <NoticeBox danger>{restrictedJobsWarningText}</NoticeBox>
        )}

        <Section title="Choose your guaranteed antagonist role">
          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
              gap: '0.5rem',
              alignItems: 'stretch',
            }}
          >
            {roles.map((role) => {
              const fallbackName = role.fallbackIcon || 'question-circle';
              const fallbackNode = <Icon name={fallbackName} size={4} />;
              const roleDisabled = !canBuyToken || !role.available;
              const unavailableReasonText =
                role.unavailableReason || 'Role is unavailable right now.';
              const statusText = role.available
                ? null
                : role.unavailableCode === 'min_pop'
                  ? `Not enough population (${Number(role.minPopCurrent ?? 0)}/${Number(role.minPopRequired ?? 0)}).`
                  : unavailableReasonText;
              const statusColor = role.available ? 'label' : 'bad';
              const iconBorderColor = roleDisabled
                ? 'var(--color-red)'
                : 'var(--color-green)';

              return (
                <Box
                  key={role.id}
                  style={{
                    height: '100%',
                    display: 'flex',
                    flexDirection: 'column',
                    backgroundColor: 'var(--section-background)',
                    border: '1px solid var(--section-separator-color)',
                    boxSizing: 'border-box',
                  }}
                >
                  <Box
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: '0.5rem',
                      borderBottom:
                        'var(--section-separator-thickness) solid var(--section-separator-color)',
                      gap: '0.5rem',
                    }}
                  >
                    <Box bold>{role.name}</Box>
                    <Button
                      icon="check"
                      compact
                      disabled={roleDisabled}
                      onClick={() =>
                        act('buy_antag_token_role', {
                          roleId: role.id,
                        })
                      }
                    >
                      Choose
                    </Button>
                  </Box>

                  <Box
                    style={{
                      display: 'flex',
                      flexDirection: 'column',
                      flexGrow: 1,
                      padding: '0.75rem 0.5rem',
                      boxSizing: 'border-box',
                    }}
                  >
                    <Box
                      mb={1}
                      style={{
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                        width: '100%',
                      }}
                    >
                      {role.prefIconClass ? (
                        <Box
                          style={{
                            borderStyle: 'solid',
                            borderRadius: '9999px',
                            borderWidth: '3px',
                            borderColor: iconBorderColor,
                            boxSizing: 'content-box',
                            overflow: 'hidden',
                            width: '96px',
                            height: '96px',
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                          }}
                          m="0 auto"
                        >
                          <Box
                            className={classes([
                              'antagonists96x96',
                              role.prefIconClass,
                              'antagonist-icon',
                            ])}
                            style={{
                              borderRadius: '9999px',
                              overflow: 'hidden',
                              imageRendering: 'pixelated',
                              display: 'block',
                            }}
                          />
                        </Box>
                      ) : (
                        <Box
                          style={{
                            width: '96px',
                            height: '96px',
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                          }}
                        >
                          {fallbackNode}
                        </Box>
                      )}
                    </Box>

                    <Box style={{ flexGrow: 1 }}>{role.desc}</Box>

                    <Box
                      style={{
                        minHeight: '2.4em',
                        display: 'flex',
                        alignItems: 'flex-end',
                      }}
                    >
                      {!!statusText && (
                        <Box color={statusColor}>{statusText}</Box>
                      )}
                    </Box>
                  </Box>
                </Box>
              );
            })}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
