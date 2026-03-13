import { useState } from 'react';
import {
  Button,
  Dropdown,
  Input,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PunishmentEntry = {
  id: number;
  target_ckey: string;
  admin_ckey: string;
  reason: string;
  mode: string;
  trauma_display: string;
  trauma_count: number;
  created_at: string;
  expires_at: string;
};

type BrainTraumaPunishmentsData = {
  intervals: string[];
  trauma_paths: string[];
  trauma_categories: string[];
  max_reason_length: number;
  max_trauma_count: number;
  create_target_ckey: string;
  create_mode: string;
  create_trauma_path: string;
  create_trauma_category: string;
  create_duration_type: string;
  create_duration_value: number;
  create_interval: string;
  create_reason: string;
  create_trauma_count: number;
  filter_target_ckey: string;
  filter_admin_ckey: string;
  status_message: string;
  status_is_error: BooleanLike;
  entries: PunishmentEntry[];
  total_count: number;
  page: number;
  page_count: number;
};

const EXACT_MODE = 'exact';
const CATEGORY_MODE = 'category';

export const BrainTraumaPunishments = () => {
  const { act, data } = useBackend<BrainTraumaPunishmentsData>();

  const [createTargetCkey, setCreateTargetCkey] = useState(
    data.create_target_ckey || '',
  );
  const [createMode, setCreateMode] = useState(data.create_mode || EXACT_MODE);
  const [createTraumaPath, setCreateTraumaPath] = useState(
    data.create_trauma_path || '',
  );
  const [createTraumaCategory, setCreateTraumaCategory] = useState(
    data.create_trauma_category || '',
  );
  const [createDurationType, setCreateDurationType] = useState(
    data.create_duration_type || 'temporary',
  );
  const [createDurationValue, setCreateDurationValue] = useState(
    data.create_duration_value || 60,
  );
  const [createInterval, setCreateInterval] = useState(
    data.create_interval || 'MINUTE',
  );
  const [createReason, setCreateReason] = useState(data.create_reason || '');
  const [createTraumaCount, setCreateTraumaCount] = useState(
    data.create_trauma_count || 1,
  );

  const [filterTargetCkey, setFilterTargetCkey] = useState(
    data.filter_target_ckey || '',
  );
  const [filterAdminCkey, setFilterAdminCkey] = useState(
    data.filter_admin_ckey || '',
  );

  const maxTraumaCount = data.max_trauma_count || 20;
  const maxReasonLength = data.max_reason_length || 600;
  const intervals = data.intervals || [];
  const traumaPaths = data.trauma_paths || [];
  const traumaCategories = data.trauma_categories || [];

  const isCategoryMode = createMode === CATEGORY_MODE;

  return (
    <Window
      title="Brain Trauma Punishments"
      width={1300}
      height={760}
      theme="admin"
    >
      <Window.Content scrollable>
        <Stack vertical>
          {!!data.status_message && (
            <Stack.Item>
              <NoticeBox danger={!!data.status_is_error}>
                {data.status_message}
              </NoticeBox>
            </Stack.Item>
          )}

          <Stack.Item>
            <Section title="Create punishment">
              <Stack fill>
                <Stack.Item width="33%">
                  <Section title="Target / Duration">
                    <Stack vertical>
                      <Stack.Item>
                        <Input
                          fluid
                          placeholder="Target ckey"
                          value={createTargetCkey}
                          onChange={setCreateTargetCkey}
                        />
                      </Stack.Item>

                      <Stack.Item>
                        <Stack>
                          <Stack.Item>
                            <Button.Checkbox
                              checked={createDurationType === 'temporary'}
                              onClick={() => setCreateDurationType('temporary')}
                            >
                              Temporary
                            </Button.Checkbox>
                          </Stack.Item>
                          <Stack.Item>
                            <Button.Checkbox
                              checked={createDurationType === 'permanent'}
                              onClick={() => setCreateDurationType('permanent')}
                            >
                              Permanent
                            </Button.Checkbox>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>

                      <Stack.Item>
                        <Stack>
                          <Stack.Item grow>
                            <NumberInput
                              fluid
                              minValue={1}
                              maxValue={999999}
                              step={1}
                              value={createDurationValue}
                              disabled={createDurationType !== 'temporary'}
                              onChange={(value) =>
                                setCreateDurationValue(Math.max(1, value))
                              }
                            />
                          </Stack.Item>
                          <Stack.Item grow>
                            <Dropdown
                              width="100%"
                              selected={createInterval}
                              options={intervals}
                              disabled={createDurationType !== 'temporary'}
                              onSelected={(value) => setCreateInterval(value)}
                            />
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>

                <Stack.Item width="33%">
                  <Section title="Trauma selection">
                    <Stack vertical>
                      <Stack.Item>
                        <Stack>
                          <Stack.Item>
                            <Button.Checkbox
                              checked={createMode === EXACT_MODE}
                              onClick={() => setCreateMode(EXACT_MODE)}
                            >
                              Specific trauma
                            </Button.Checkbox>
                          </Stack.Item>
                          <Stack.Item>
                            <Button.Checkbox
                              checked={createMode === CATEGORY_MODE}
                              onClick={() => setCreateMode(CATEGORY_MODE)}
                            >
                              Random by category
                            </Button.Checkbox>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>

                      <Stack.Item>
                        <Dropdown
                          width="100%"
                          selected={createTraumaPath}
                          options={traumaPaths}
                          disabled={isCategoryMode}
                          onSelected={(value) => setCreateTraumaPath(value)}
                        />
                      </Stack.Item>

                      <Stack.Item>
                        <Dropdown
                          width="100%"
                          selected={createTraumaCategory}
                          options={traumaCategories}
                          disabled={!isCategoryMode}
                          onSelected={(value) => setCreateTraumaCategory(value)}
                        />
                      </Stack.Item>

                      <Stack.Item>
                        <NumberInput
                          fluid
                          minValue={1}
                          maxValue={maxTraumaCount}
                          step={1}
                          disabled={!isCategoryMode}
                          value={createTraumaCount}
                          onChange={(value) =>
                            setCreateTraumaCount(clamp(value, 1, maxTraumaCount))
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>

                <Stack.Item width="34%">
                  <Section title="Reason / Create">
                    <Stack vertical>
                      <Stack.Item>
                        <Input
                          fluid
                          maxLength={maxReasonLength}
                          placeholder="Reason"
                          value={createReason}
                          onChange={setCreateReason}
                        />
                      </Stack.Item>

                      <Stack.Item>
                        <Button.Confirm
                          fluid
                          color="red"
                          icon="gavel"
                          onClick={() =>
                            act('create', {
                              target_ckey: createTargetCkey,
                              mode: createMode,
                              trauma_path: createTraumaPath,
                              trauma_category: createTraumaCategory,
                              duration_type: createDurationType,
                              duration_value: createDurationValue,
                              interval: createInterval,
                              reason: createReason,
                              trauma_count: createTraumaCount,
                            })
                          }
                        >
                          Create brain trauma punishment
                        </Button.Confirm>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Active punishments">
              <Stack vertical>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Input
                        fluid
                        placeholder="Filter by target ckey"
                        value={filterTargetCkey}
                        onChange={setFilterTargetCkey}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Input
                        fluid
                        placeholder="Filter by admin ckey"
                        value={filterAdminCkey}
                        onChange={setFilterAdminCkey}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="search"
                        onClick={() =>
                          act('set_filters', {
                            filter_target_ckey: filterTargetCkey,
                            filter_admin_ckey: filterAdminCkey,
                          })
                        }
                      >
                        Search
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>ID</Table.Cell>
                      <Table.Cell>Target</Table.Cell>
                      <Table.Cell>Admin</Table.Cell>
                      <Table.Cell>Mode</Table.Cell>
                      <Table.Cell>Trauma</Table.Cell>
                      <Table.Cell>Count</Table.Cell>
                      <Table.Cell>Created</Table.Cell>
                      <Table.Cell>Expires</Table.Cell>
                      <Table.Cell>Reason</Table.Cell>
                      <Table.Cell>Action</Table.Cell>
                    </Table.Row>

                    {data.entries?.map((entry) => (
                      <Table.Row key={entry.id}>
                        <Table.Cell>{entry.id}</Table.Cell>
                        <Table.Cell>{entry.target_ckey}</Table.Cell>
                        <Table.Cell>{entry.admin_ckey}</Table.Cell>
                        <Table.Cell>{entry.mode}</Table.Cell>
                        <Table.Cell>{entry.trauma_display}</Table.Cell>
                        <Table.Cell>{entry.trauma_count}</Table.Cell>
                        <Table.Cell>{entry.created_at}</Table.Cell>
                        <Table.Cell>{entry.expires_at}</Table.Cell>
                        <Table.Cell>{entry.reason}</Table.Cell>
                        <Table.Cell>
                          <Button.Confirm
                            color="bad"
                            icon="trash"
                            onClick={() =>
                              act('remove', {
                                record_id: entry.id,
                              })
                            }
                          >
                            Remove
                          </Button.Confirm>
                        </Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>

                  {(!data.entries || data.entries.length === 0) && (
                    <NoticeBox>No active brain trauma punishments found.</NoticeBox>
                  )}
                </Stack.Item>

                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <NoticeBox>
                        Total: {data.total_count || 0} | Page {(data.page || 0) + 1}{' '}
                        / {data.page_count || 1}
                      </NoticeBox>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled={(data.page || 0) <= 0}
                        onClick={() =>
                          act('set_page', {
                            page: (data.page || 0) - 1,
                          })
                        }
                      >
                        Prev
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled={(data.page || 0) >= (data.page_count || 1) - 1}
                        onClick={() =>
                          act('set_page', {
                            page: (data.page || 0) + 1,
                          })
                        }
                      >
                        Next
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
