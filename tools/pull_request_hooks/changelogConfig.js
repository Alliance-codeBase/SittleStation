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
    ["rscadd", "add", "adds"],
    {
      placeholders: ["Добавлены новые механики"],
    },
  ],

  [
    ["bugfix", "fix", "fixes"],
    {
      placeholders: ["Починены некоторые вещи"],
    },
  ],

  [
    ["rscdel", "del", "dels"],
    {
      placeholders: ["Убраны старые фишки"],
    },
  ],

  [
    ["qol"],
    {
      placeholders: ["Упростили что-то в использовании"],
    },
  ],

  [
    ["sound"],
    {
      placeholders: ["Добавлены/изменены/убраны аудио или звуковые эффекты"],
    },
  ],

  [
    ["image"],
    {
      placeholders: ["Добавлены/изменены/убраны спрайты или картинки"],
    },
  ],

  [
    ["map"],
    {
      placeholders: ["Добавлен/изменён/убран контент карт"],
    },
  ],

  [
    ["spellcheck", "typo"],
    {
      placeholders: ["Исправлено несколько опечаток"],
    },
  ],

  [
    ["balance"],
    {
      placeholders: ["Ребаланс чего-то"],
    },
  ],

  [
    ["code_imp", "code"],
    {
      placeholders: ["Изменено немного кода"],
    },
  ],

  [
    ["refactor"],
    {
      placeholders: ["Рефактор кода"],
    },
  ],

  [
    ["config"],
    {
      placeholders: ["Изменено несколько настроек конфига"],
    },
  ],

  [
    ["admin"],
    {
      placeholders: ["Возня с админскими фишками"],
    },
  ],

  [
    ["server"],
    {
      placeholders: ["Изменено что-то что нужно знать свыше, хосту"],
    },
  ],
]; //MASSMETA ADDITION (github update)

// Valid changelog openers
export const CHANGELOG_OPEN_TAGS = [":cl:", "??"];

// Valid changelog closers
export const CHANGELOG_CLOSE_TAGS = ["/:cl:", "/ :cl:", ":/cl:", "/??", "/ ??"];

// Placeholder value for an author
export const CHANGELOG_AUTHOR_PLACEHOLDER_NAME = "optional name here";
