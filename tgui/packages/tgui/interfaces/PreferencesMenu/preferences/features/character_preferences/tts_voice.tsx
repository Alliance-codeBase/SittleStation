import { useBackend } from 'tgui/backend';
//MASSMETA EDIT START (ntts && tgtts)
//original: import { Button, Stack } from 'tgui-core/components';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';
//MASSMETA EDIT START (ntts && tgtts)

import {
  type FeatureChoiced,
  type FeatureChoicedServerData,
  type FeatureNumeric,
  FeatureSliderInput,
  type FeatureValueProps,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

function FeatureTTSDropdownInput(
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) {
  const { act } = useBackend();
  //MASSMETA EDIT START (ntts && tgtts)
  const { non_contextual } = props.character_preferences;
  const blipBase = String(non_contextual.tts_blip_base);
  const blipNumber = String(non_contextual.tts_blip_number);
  //MASSMETA EDIT END (ntts && tgtts)


  //MASSMETA EDIT REMOVAL START (ntts && tgtts)
  /* ORIGINAL:
          onClick={() => {
            act('play_voice');
          }}
          icon="play"
          width="100%"
          height="100%"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_voice_robot');
          }}
          icon="robot"
          width="100%"
          height="100%"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            act('play_blips');
          }}
          icon="leaf"
          width="100%"
          height="100%"
        />
  */
   //MASSMETA EDIT REMOVAL END (ntts && tgtts)

     //MASSMETA EDIT START (ntts && tgtts)
  return (
    <Stack align="center">
      <Stack.Item grow>
        <Box color="label">Current TTS voice</Box>
        <Box bold>{props.value}</Box>
        <LabeledList>
          <LabeledList.Item label="Pitch">
            {String(non_contextual.tts_voice_pitch)}
          </LabeledList.Item>
          <LabeledList.Item label="Blip base">{blipBase}</LabeledList.Item>
          <LabeledList.Item label="Blip variant">
            {blipBase} {blipNumber}
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="exchange-alt"
          onClick={() => act('open_tts_voice_picker')}
        >
          Change Voice
        </Button>
  {/*MASSMETA EDIT END (ntts && tgtts) */}
      </Stack.Item>
    </Stack>
  );
}

export const tts_voice: FeatureChoiced = {
  name: 'Voice',
  component: FeatureTTSDropdownInput,
};

export const tts_voice_pitch: FeatureNumeric = {
  name: 'Voice Pitch Adjustment',
  component: FeatureSliderInput,
};

export const tts_blip_base: FeatureChoiced = {
  name: 'Voice Blip Base',
  component: FeatureDropdownInput,
};

export const tts_blip_number: FeatureNumeric = {
  name: 'Voice Blip Variant',
  component: FeatureSliderInput,
};
