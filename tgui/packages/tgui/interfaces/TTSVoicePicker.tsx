import { useMemo, useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const ALL_CATEGORY = 'all';
const TEST_MESSAGE = 'Привет, это мой голос';

type Data = {
  blip_base: string;
  blip_number: number;
  categories: Record<string, string>;
  pitch: number;
  voice: string;
  voices: string[];
};

type VoiceAction = {
  action: string;
  icon: string;
  tone: string;
  tooltip: string;
};

const VOICE_ACTIONS: VoiceAction[] = [
  {
    action: 'play_voice',
    icon: 'play',
    tone: 'voice',
    tooltip: 'Normal voice preview',
  },
  {
    action: 'play_robot',
    icon: 'robot',
    tone: 'robot',
    tooltip: 'Robot voice preview',
  },
  {
    action: 'play_radio',
    icon: 'broadcast-tower',
    tone: 'radio',
    tooltip: 'Radio preview',
  },
  {
    action: 'play_blips',
    icon: 'leaf',
    tone: 'blips',
    tooltip: 'Blips preview',
  },
  /*
   {
     action: 'play_radio_ion',
    icon: 'bolt',
   tone: 'ion',
   tooltip: 'Ion interference preview',
   },
  */
  {
    action: 'play_gas_mask',
    icon: 'theater-masks',
    tone: 'mask',
    tooltip: 'Gas mask preview',
  },
  {
    action: 'play_sec_hailer',
    icon: 'bullhorn',
    tone: 'hailer',
    tooltip: 'Security hailer preview',
  },
];

function titleize(value: string) {
  if (value === ALL_CATEGORY) {
    return 'All';
  }
  return value.replace(/[_-]/g, ' ');
}

export function TTSVoicePicker(props) {
  const { act, data } = useBackend<Data>();
  const {
    blip_base,
    blip_number,
    categories = {},
    pitch,
    voice,
    voices = [],
  } = data;
  const [category, setCategory] = useState(ALL_CATEGORY);
  const [message, setMessage] = useState(TEST_MESSAGE);
  const [search, setSearch] = useState('');

  const categoryCounts = useMemo(() => {
    const counts: Record<string, number> = {
      [ALL_CATEGORY]: voices.length,
    };
    for (const item of voices) {
      const voiceCategory = categories[item] || 'other';
      counts[voiceCategory] = (counts[voiceCategory] || 0) + 1;
    }
    return counts;
  }, [categories, voices]);

  const categoryList = useMemo(() => {
    return [
      ALL_CATEGORY,
      ...Object.keys(categoryCounts)
        .filter((name) => name !== ALL_CATEGORY)
        .sort((left, right) => left.localeCompare(right)),
    ];
  }, [categoryCounts]);

  const query = search.toLowerCase();
  const shownVoices = useMemo(() => {
    return voices.filter((item) => {
      const voiceCategory = categories[item] || 'other';
      return (
        (category === ALL_CATEGORY || voiceCategory === category) &&
        item.toLowerCase().includes(query)
      );
    });
  }, [categories, category, query, voices]);

  function preview(action: string, previewVoice = voice) {
    act(action, {
      message,
      voice: previewVoice,
    });
  }

  return (
    <Window title="TTS Voice" width={760} height={720}>
      <Window.Content className="TTSVoicePicker">
        <Stack fill>
          <Stack.Item width="180px">
            <Section
              className="TTSVoicePicker__categorySection"
              fill
              scrollable
              title="Categories"
            >
              <Stack vertical g={0.5}>
                {categoryList.map((item) => (
                  <Stack.Item key={item}>
                    <Button
                      className="TTSVoicePicker__categoryButton"
                      fluid
                      selected={category === item}
                      onClick={() => setCategory(item)}
                    >
                      <Stack align="center">
                        <Stack.Item grow>{titleize(item)}</Stack.Item>
                        <Stack.Item>
                          <Box className="TTSVoicePicker__categoryCount">
                            {categoryCounts[item]}
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item>
                <Section className="TTSVoicePicker__summary">
                  <Stack align="center">
                    <Stack.Item grow>
                      <Box className="TTSVoicePicker__currentLabel">
                        Selected voice
                      </Box>
                      <Box className="TTSVoicePicker__currentVoice">
                        {voice || 'None'}
                      </Box>
                      <Box color="label">
                        {titleize(categories[voice] || 'other')}
                      </Box>
                    </Stack.Item>
                    <Stack.Item width="56%">
                      <Input
                        fluid
                        value={message}
                        onChange={setMessage}
                        placeholder="Test phrase"
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section
                  className="TTSVoicePicker__settings"
                  title="Voice settings"
                >
                  <LabeledList>
                    <LabeledList.Item label="pitch">
                      <Slider
                        minValue={-12}
                        maxValue={12}
                        step={1}
                        stepPixelSize={8}
                        value={pitch}
                        onChange={(_, value) => act('set_pitch', { value })}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="blip base">
                      <Dropdown
                        width="100%"
                        selected={blip_base}
                        options={['Masculine', 'Feminine']}
                        onSelected={(value) => act('set_blip_base', { value })}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="blip variant">
                      <Slider
                        minValue={1}
                        maxValue={4}
                        step={1}
                        stepPixelSize={24}
                        value={blip_number}
                        onChange={(_, value) =>
                          act('set_blip_number', { value })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Input
                  fluid
                  placeholder="Search voice"
                  value={search}
                  onChange={setSearch}
                />
              </Stack.Item>

              <Stack.Item grow>
                <Section fill scrollable title="Voices">
                  <Stack vertical g={0.5}>
                    {shownVoices.map((item) => (
                      <Stack.Item key={item}>
                        <Stack
                          align="center"
                          className={
                            item === voice
                              ? 'TTSVoicePicker__voiceRow TTSVoicePicker__voiceRow--selected'
                              : 'TTSVoicePicker__voiceRow'
                          }
                        >
                          <Stack.Item grow>
                            <Box className="TTSVoicePicker__voiceName">
                              {item}
                            </Box>
                            <Box className="TTSVoicePicker__voiceCategory">
                              {titleize(categories[item] || 'other')}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              className="TTSVoicePicker__iconButton TTSVoicePicker__iconButton--select"
                              icon={item === voice ? 'check' : 'plus'}
                              selected={item === voice}
                              tooltip={item === voice ? 'Selected' : 'Select'}
                              tooltipPosition="left"
                              onClick={() => act('set_voice', { value: item })}
                            />
                          </Stack.Item>
                          {VOICE_ACTIONS.map((voiceAction) => (
                            <Stack.Item key={voiceAction.action}>
                              <Button
                                className={`TTSVoicePicker__iconButton TTSVoicePicker__iconButton--${voiceAction.tone}`}
                                icon={voiceAction.icon}
                                tooltip={voiceAction.tooltip}
                                tooltipPosition="left"
                                onClick={() =>
                                  preview(voiceAction.action, item)
                                }
                              />
                            </Stack.Item>
                          ))}
                        </Stack>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
