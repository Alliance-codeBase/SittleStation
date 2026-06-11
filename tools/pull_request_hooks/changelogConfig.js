/**
 * A map of changelog phrases to meta-information.
 *
 * The first entry in the list is used in the changelog YML file as the key when
 * used, but other than that all entries are equivalent.
 *
 * placeholders - The default messages, if the changelog has this then we pretend it
 * doesn't exist.
 */
export const CHANGELOG_ENTRIES = [
  [
    ['rscadd', 'add', 'adds'],
    {
<<<<<<< HEAD
      placeholders: ["Добавлены новые механики"],
=======
      placeholders: [
        'Added new mechanics or gameplay changes',
        'Added more things',
      ],
>>>>>>> upstream/master
    },
  ],

  [
    ['bugfix', 'fix', 'fixes'],
    {
<<<<<<< HEAD
      placeholders: ["Починены некоторые вещи"],
=======
      placeholders: ['fixed a few things'],
>>>>>>> upstream/master
    },
  ],

  [
    ['rscdel', 'del', 'dels'],
    {
<<<<<<< HEAD
      placeholders: ["Убраны старые фишки"],
=======
      placeholders: ['Removed old things'],
>>>>>>> upstream/master
    },
  ],

  [
    ['qol'],
    {
<<<<<<< HEAD
      placeholders: ["Упростили что-то в использовании"],
=======
      placeholders: ['made something easier to use'],
>>>>>>> upstream/master
    },
  ],

  [
    ['sound'],
    {
<<<<<<< HEAD
      placeholders: ["Добавлены/изменены/убраны аудио или звуковые эффекты"],
=======
      placeholders: ['added/modified/removed audio or sound effects'],
>>>>>>> upstream/master
    },
  ],

  [
    ['image'],
    {
<<<<<<< HEAD
      placeholders: ["Добавлены/изменены/убраны спрайты или картинки"],
=======
      placeholders: ['added/modified/removed some icons or images'],
>>>>>>> upstream/master
    },
  ],

  [
    ['map'],
    {
<<<<<<< HEAD
      placeholders: ["Добавлен/изменён/убран контент карт"],
=======
      placeholders: ['added/modified/removed map content'],
>>>>>>> upstream/master
    },
  ],

  [
    ['spellcheck', 'typo'],
    {
<<<<<<< HEAD
      placeholders: ["Исправлено несколько опечаток"],
=======
      placeholders: ['fixed a few typos'],
>>>>>>> upstream/master
    },
  ],

  [
    ['balance'],
    {
<<<<<<< HEAD
      placeholders: ["Ребаланс чего-то"],
=======
      placeholders: ['rebalanced something'],
>>>>>>> upstream/master
    },
  ],

  [
    ['code_imp', 'code'],
    {
<<<<<<< HEAD
      placeholders: ["Изменено немного кода"],
=======
      placeholders: ['changed some code'],
>>>>>>> upstream/master
    },
  ],

  [
    ['refactor'],
    {
<<<<<<< HEAD
      placeholders: ["Рефактор кода"],
=======
      placeholders: ['refactored some code'],
>>>>>>> upstream/master
    },
  ],

  [
    ['config'],
    {
<<<<<<< HEAD
      placeholders: ["Изменено несколько настроек конфига"],
=======
      placeholders: ['changed some config setting'],
>>>>>>> upstream/master
    },
  ],

  [
    ['admin'],
    {
<<<<<<< HEAD
      placeholders: ["Возня с админскими фишками"],
=======
      placeholders: ['messed with admin stuff'],
>>>>>>> upstream/master
    },
  ],

  [
    ['server'],
    {
<<<<<<< HEAD
      placeholders: ["Изменено что-то что нужно знать свыше, хосту"],
=======
      placeholders: ['something server ops should know'],
>>>>>>> upstream/master
    },
  ],
]; //MASSMETA ADDITION (github update)

// Valid changelog openers
export const CHANGELOG_OPEN_TAGS = [':cl:', '??'];

// Valid changelog closers
export const CHANGELOG_CLOSE_TAGS = ['/:cl:', '/ :cl:', ':/cl:', '/??', '/ ??'];

// Placeholder value for an author
export const CHANGELOG_AUTHOR_PLACEHOLDER_NAME = 'optional name here';
