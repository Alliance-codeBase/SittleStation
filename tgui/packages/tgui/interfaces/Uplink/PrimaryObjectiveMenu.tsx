
//MASSMETA EDIT CHANGE BEGIN (re_traitorsecondary)
/* ORIGINAL:
import { Box, Button, Section, Stack } from 'tgui-core/components';
*/
import { Box, Button, Dimmer, Section, Stack } from 'tgui-core/components';
//MASSMETA EDIT CHANGE END (re_traitorsecondary)
import { useBackend } from '../../backend';
//MASSMETA EDIT CHANGE BEGIN (re_traitorsecondary)
/* ORIGINAL:
import { ObjectiveElement } from './ObjectiveElement';
*/
import { ObjectiveElement } from './ObjectiveMenu';

type PrimaryObjectiveMenuProps = {
  primary_objectives;
  //MASSMETA EDIT ADDITION BEGIN (re_traitorsecondary)
  final_objective;
  //MASSMETA EDIT ADDITION END (re_traitorsecondary)
  can_renegotiate;
};

export const PrimaryObjectiveMenu = (props: PrimaryObjectiveMenuProps) => {
  const { act } = useBackend();
  //MASSMETA EDIT CHANGE BEGIN (re_traitorsecondary)
  /*
  ORIGINAL: const { primary_objectives, can_renegotiate } = props;
  */
  const { primary_objectives, final_objective, can_renegotiate } = props;
  //MASSMETA EDIT CHANGE END (re_traitorsecondary)
  //MASSMETA EDIT ADDITION BEGIN (re_traitorsecondary) Нельзя писать комментарии там где нужно, значит - будет лежать здесь.
   return (
    <Section fill scrollable align="center">
      <Box my={4} bold fontSize={1.2} color="green">
        WELCOME, AGENT.
      </Box>
      <Box my={4} bold fontSize={1.2}>
        Your Primary Objectives are as follows. Complete these at all costs.
      </Box>
      <Box my={4} bold fontSize={1.2}>
        Completing Secondary Objectives may allow you to aquire additional
        equipment.
      </Box>
      {final_objective && (
        <Dimmer>
          <Box
            color="red"
            fontFamily={'Bahnschrift'}
            fontSize={3}
            align={'top'}
            as="span"
          >
            PRIORITY MESSAGE
            <br />
            SOURCE: xxx.xxx.xxx.224:41394
            <br />
            <br />
            \\Debrief in progress.
            <br />
            \\Final Objective confirmed complete. <br />
            \\Your work is done here, agent.
            <br />
            <br />
            CONNECTION CLOSED_
          </Box>
        </Dimmer>
      )}
      <Stack vertical>
        {primary_objectives.map((prim_obj, index) => (
          <Stack.Item key={index}>
            <ObjectiveElement
              key={prim_obj.id}
 //MASSMETA EDIT CHANGE END (re_traitorsecondary)
 //MASSMETA EDIT CHANGE BEGIN (re_traitorsecondary)
 /*
              name={prim_obj.task_name}
              description={prim_obj.task_text}
 */
//MASSMETA EDIT ADDITION BEGIN (re_traitorsecondary)
              name={prim_obj['task_name']}
              description={prim_obj['task_text']}
              dangerLevel={{
                minutesLessThan: 0,
                title: 'none',
                gradient:
                  index === primary_objectives.length - 1
                    ? 'reputation-good'
                    : 'reputation-very-good',
              }}
              telecrystalReward={0}
              telecrystalPenalty={0}
              progressionReward={0}
              originalProgression={0}
              hideTcRep
              canAbort={false}
              grow={false}
              finalObjective={false}
//MASSMETA EDIT ADDITION END (re_traitorsecondary)
            />
          </Stack.Item>
        ))}
      </Stack>
      {!!can_renegotiate && (
        <Box mt={3} mb={5} bold fontSize={1.2} align="center" color="white">
          <Button
            content={'Renegotiate Contract'}
            tooltip={
              'Replace your existing primary objectives with a custom one. This action can only be performed once.'
            }
            onClick={() => act('renegotiate_objectives')}
          />
        </Box>
      )}
      <Box my={4} fontSize={0.8}>
        <Box>SyndOS Version 3.17</Box>
        <Box color="green">Connection Secure</Box>
      </Box>
    </Section>
  );
};
