import { Antagonist, Category } from '../base';

export const SINFULDEMON_MECHANICAL_DESCRIPTION = `
      Fulfill an objective based on the sin your demon represents.
      Avoid holy influence and transform into your true form if you need to defend yourself or inflict pain.
   `;

const DemonInfiltration: Antagonist = {
  key: 'demoninfiltration',
  name: 'Demon Infiltration',
  description: [
    `
      Sentience breeds sin. Whether by accident or intent, you have escaped Hell and roam the material universe under a human disguise now.
      Whether it is gluttony or greed, pride or wrath, you will embody your deadly sin. The mortals will give you opportunity.
    `,
  ],
  category: Category.Latejoin,
};

export default DemonInfiltration;
