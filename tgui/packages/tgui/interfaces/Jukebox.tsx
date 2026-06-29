import { sortBy } from 'es-toolkit';
import {
  Box,
  Button,
  Dropdown,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Song = {
  name: string;
  length: number | string; //MASSMETA EDIT ORIGINAL: length: number;
  beat: number;
  is_custom?: boolean; //MASSMETA ADDITION
  url?: string; //MASSMETA ADDITION
};

type Data = {
  active: BooleanLike;
  looping: BooleanLike;
  volume: number;
  track_selected: string | null;
  songs: Song[];
  internet_sound_enabled: boolean; //MASSMETA ADDITION
};

export const Jukebox = () => {
  const { act, data } = useBackend<Data>();
  const { active, looping, track_selected, volume, songs, internet_sound_enabled } = data;

  const songs_sorted: Song[] = sortBy(songs, [(song: Song) => song.name]);
  const song_selected: Song | undefined = songs.find(
    (song) => song.name === track_selected,
  );

  return (
    <Window width={370} height={380} //MASSMETA EDIT ORIGINAL: Window width={370} height={313}
    >
      <Window.Content>
        <Section
          title="Song Player"
          buttons={
            <>
              <Button
                icon={active ? 'pause' : 'play'}
                content={active ? 'Stop' : 'Play'}
                selected={active}
                onClick={() => act('toggle')}
              />
              <Button.Checkbox
                icon={'arrow-rotate-left'}
                content="Repeat"
                disabled={active}
                checked={looping}
                onClick={() => act('loop', { looping: !looping })}
              />
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Track Selected">
              <Dropdown
                width="240px"
                options={songs_sorted.map((song) => song.name)}
                disabled={!!active}
                selected={song_selected?.name || 'Select a Track'}
                onSelected={(value) =>
                  act('select_track', {
                    track: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Track Length">
              {song_selected?.length || 'No Track Selected'}
            </LabeledList.Item>
            <LabeledList.Item label="Track Beat">
              {song_selected?.is_custom ? 'N/A' : (song_selected?.beat || 'No Track Selected')}
              {!song_selected?.is_custom && song_selected?.beat ? (song_selected.beat === 1 ? ' beat' : ' beats') : ''}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Machine Settings">
          <LabeledControls justify="center">
            <LabeledControls.Item label="Volume">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={volume >= 25 ? 'red' : 'green'}
                  value={volume}
                  unit="%"
                  minValue={0}
                  maxValue={50}
                  step={1}
                  stepPixelSize={1}
                  onChange={(e, value) =>
                    act('set_volume', {
                      volume: value,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'min',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'max',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'reset',
                    })
                  }
                />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        {//MASSMETA ADDITION
        }
        <Section title="Internet Song Player">
          <Button
            fluid
            icon="globe"
            disabled={!internet_sound_enabled}
            content={internet_sound_enabled ? "Play Internet Song" : "Disabled by Host"}
            onClick={() => act('request_internet_track')}
          />
        </Section>
        {//MASSMETA ADDITION END
        }
      </Window.Content>
    </Window>
  );
};
