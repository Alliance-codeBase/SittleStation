import {
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Slider,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type TelepadData = {
  telepad: boolean;
  power_options: number[];
  efficiency: number;
  crystals: number;
  z_co: number;
  angle: number;
  rotation: number;
  power: number;
  temp_msg: string;
  inserted_gps: string | null;
  teleporting: boolean;
  last_tele_data: boolean;
  src_x: number;
  src_y: number;
  timedata: string;
};

export const TelesciComputer = (_props: any, context: any) => {
  const { act, data } = useBackend<TelepadData>();
  const {
    telepad,
    power_options,
    efficiency,
    crystals,
    z_co,
    angle,
    rotation,
    power,
    temp_msg,
    inserted_gps,
    teleporting,
    last_tele_data,
    src_x,
    src_y,
    timedata,
  } = data;

  return (
    <Window width={380} height={480}>
      {teleporting && (
        <Dimmer fontSize="24px">
          <Icon name="cog" spin={1} />
          {' Wait: '}
          {timedata}
          {' s.'}
        </Dimmer>
      )}

      <Window.Content scrollable>
        {!telepad ? (
          <NoticeBox danger>Telepad not found.</NoticeBox>
        ) : (
          <>
            <Section
              title="Telepad Controls"
              buttons={
                <>
                  <Button
                    icon="eject"
                    tooltip="Eject crystals"
                    onClick={() => act('eject')}
                  />
                  <Button
                    icon="sync"
                    tooltip="Recalibrate"
                    color="yellow"
                    onClick={() => act('recal')}
                  />
                  <Button
                    icon="arrow-up"
                    content="Send"
                    color="green"
                    onClick={() => act('send')}
                  />
                  <Button
                    icon="arrow-down"
                    content="Receive"
                    color="blue"
                    onClick={() => act('receive')}
                  />
                </>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Angle">
                  <Slider
                    value={angle}
                    unit="°"
                    minValue={1}
                    maxValue={90}
                    step={1}
                    stepPixelSize={5}
                    onDrag={(e, value) => act('setangle', { newangle: value })}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Rotation">
                  <Slider
                    value={rotation}
                    unit="°"
                    minValue={0}
                    maxValue={360}
                    step={1}
                    stepPixelSize={1}
                    onDrag={(e, value) =>
                      act('setrotation', { newrotation: value })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Power">
                  {power_options.map((opt) => {
                    const maxAllowedPower = crystals * 5 * efficiency;
                    const isAvailable = opt <= maxAllowedPower;
                    const isSelected = opt === power;
                    const color = !isAvailable
                      ? 'red'
                      : isSelected
                        ? 'green'
                        : undefined;

                    return (
                      <Button
                        key={opt}
                        content={opt.toString()}
                        color={color}
                        onClick={() => act('setpower', { newpower: opt })}
                      />
                    );
                  })}
                </LabeledList.Item>
                <LabeledList.Item label="Sector">
                  <Slider
                    step={1}
                    stepPixelSize={30}
                    value={z_co}
                    minValue={1}
                    maxValue={13}
                    onChange={(e, value) => act('setz', { newz: value })}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>

            {last_tele_data && (
              <Section title="Last Teleport Location">
                <Box fontSize="32px" textAlign="center">
                  X: {src_x} &nbsp; Y: {src_y}
                </Box>
              </Section>
            )}

            {inserted_gps && (
              <Section
                title="Inserted GPS"
                buttons={
                  <Button
                    icon="eject"
                    content="Eject GPS"
                    tooltip="Remove GPS beacon"
                    tooltipPosition="left"
                    onClick={() => act('ejectGPS')}
                  />
                }
              >
                <Box textAlign="center">{inserted_gps}</Box>
              </Section>
            )}

            <Section title="System Message">
              <NoticeBox info>{temp_msg}</NoticeBox>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
