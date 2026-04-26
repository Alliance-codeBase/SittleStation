import { useState } from 'react';

import {
  Box,
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Lobby = {
  name: string;
  players: number;
  max_players: number;
  map: string;
  playing: BooleanLike;
  /* MASSMETA EDIT ADDITION START (metacoins) */
  entry_fee: number;
  prize_pool: number;
  /* MASSMETA EDIT ADDITION START (metacoins) */
};

type Data = {
  hosting: BooleanLike;
  admin: BooleanLike;
  playing: string;
  lobbies: Lobby[];
};

export function DeathmatchPanel(props) {
  const { act, data } = useBackend<Data>();
  const { hosting } = data;
  /* MASSMETA EDIT ADDITION START (metacoins) */
  const feeOptions = ['0', '30', '50', '60', '80', '100', 'Custom'];
  const [selectedFee, setSelectedFee] = useState('0');
  const [customFee, setCustomFee] = useState(0);
  const customMode = selectedFee === 'Custom';
  const resolvedFee = customMode
    ? Math.min(1000, Math.max(0, Math.round(customFee)))
    : Math.min(1000, Math.max(0, Math.round(Number(selectedFee) || 0)));
  /* MASSMETA EDIT ADDITION START (metacoins) */

  return (
    // MASSMETA EDIT ADDITION START (metacoins)
    //more width and height to fit the icons
    <Window title="Deathmatch Lobbies" width={520} height={420}>
      {/* MASSMETA EDIT ADDITION START (metacoins) */}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <NoticeBox danger>
              If you play, you can still possibly be returned to your body (No
              Guarantees)!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <LobbyPane />
          </Stack.Item>
          <Stack.Item>
            {/* MASSMETA EDIT CHANGE START (metacoins)
            original:
                <Button
                  disabled={!!hosting}
                  fluid
                  textAlign="center"
                  color="good"
                  onClick={() => act('host')}
                 >
                  Create Lobby
                </Button>

                */}
            <Stack>
              <Stack.Item align="center">
                <Box color="label">Entry fee:</Box>
              </Stack.Item>
              <Stack.Item>
                <Dropdown
                  width={12}
                  selected={selectedFee}
                  options={feeOptions}
                  disabled={!!hosting}
                  onSelected={(value) => setSelectedFee(String(value))}
                />
              </Stack.Item>
              {customMode && (
                <Stack.Item grow>
                  <NumberInput
                    width="100%"
                    minValue={0}
                    maxValue={1000}
                    step={1}
                    value={customFee}
                    disabled={!!hosting}
                    onChange={(value) =>
                      setCustomFee(
                        Math.min(1000, Math.max(0, Math.round(value))),
                      )
                    }
                  />
                </Stack.Item>
              )}
              <Stack.Item grow>
                <Button
                  disabled={!!hosting}
                  fluid
                  textAlign="center"
                  color="good"
                  onClick={() =>
                    act('host', {
                      entry_fee: resolvedFee,
                    })
                  }
                >
                  Create Lobby
                </Button>
              </Stack.Item>
            </Stack>
            {/*MASSMETA EDIT CHANGE END (metacoins) */}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

function LobbyPane(props) {
  const { data } = useBackend<Data>();
  const { lobbies = [] } = data;

  return (
    <Section fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell>Host</Table.Cell>
          {/*MASSMETA EDIT ADDITION START (metacoins) */}
          <Table.Cell>Map</Table.Cell>
          <Table.Cell textAlign="right">
            <Tooltip content="Entry fee">
              <Icon name="coins" />
            </Tooltip>
          </Table.Cell>
          <Table.Cell textAlign="center">
            <Tooltip content="Prize pool">
              <Icon name="piggy-bank" />
            </Tooltip>
          </Table.Cell>
          {/* MASSMETA EDIT ADDITION END (metacoins) */}
          <Table.Cell>
            <Tooltip content="Players">
              <Icon name="users" />
            </Tooltip>
          </Table.Cell>
          <Table.Cell align="center">
            <Icon name="hammer" />
          </Table.Cell>
        </Table.Row>

        {lobbies.length === 0 && (
          <Table.Row>
            {/* MASSMETA EDIT ADDITION START (metacoins) */}
            <Table.Cell
              colSpan={6}
              textAlign="center"
              verticalAlign="middle"
              style={{ padding: '0.6rem 0.5rem' }}
            >
              {/* MASSMETA EDIT ADDITION END (metacoins) */}
              <NoticeBox textAlign="center">
                No lobbies found. Start one!
              </NoticeBox>
            </Table.Cell>
          </Table.Row>
        )}

        {lobbies.map((lobby, index) => (
          <LobbyDisplay key={index} lobby={lobby} />
        ))}
      </Table>
    </Section>
  );
}

function LobbyDisplay(props) {
  const { act, data } = useBackend<Data>();
  const { admin, playing, hosting } = data;
  const { lobby } = props;

  const isActive = (!!hosting || !!playing) && playing !== lobby.name;

  return (
    <Table.Row className="candystripe" key={lobby.name}>
      <Table.Cell>
        {!admin ? (
          lobby.name
        ) : (
          <Dropdown
            width={10}
            noChevron
            selected={lobby.name}
            options={['Close', 'View']}
            onSelected={(value) =>
              act('admin', {
                id: lobby.name,
                func: value,
              })
            }
          />
        )}
      </Table.Cell>
      <Table.Cell>{lobby.map}</Table.Cell>
      {/* MASSMETA EDIT ADDITION START (metacoins) */}
      <Table.Cell collapsing textAlign="right">
        {lobby.entry_fee || 0}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {lobby.prize_pool || 0}
      </Table.Cell>
      {/* MASSMETA EDIT ADDITION END (metacoins) */}
      <Table.Cell collapsing>
        {lobby.players}/{lobby.max_players}
      </Table.Cell>
      <Table.Cell collapsing>
        {!lobby.playing ? (
          <Button
            disabled={isActive}
            color="good"
            onClick={() => act('join', { id: lobby.name })}
            width="100%"
            textAlign="center"
          >
            {playing === lobby.name ? 'View' : 'Join'}
          </Button>
        ) : (
          <Button
            disabled={isActive}
            color="good"
            onClick={() => act('spectate', { id: lobby.name })}
          >
            Spectate
          </Button>
        )}
      </Table.Cell>
    </Table.Row>
  );
}
