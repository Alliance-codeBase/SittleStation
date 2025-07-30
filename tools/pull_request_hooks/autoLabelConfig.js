// File Labels
//
// Add a label based on if a file is modified in the diff
//
// You can optionally set add_only to make the label one-way -
// if the edit to the file is removed in a later commit,
// the label will not be removed
export const file_labels = {
  GitHub: {
    filepaths: [".github"],
  },
  SQL: {
    filepaths: ["SQL"],
  },
  "Изменения карт": {
    filepaths: ["_maps"],
  },
  Инструменты: {
    filepaths: ["tools"],
  },
  "Изменение конфигов": {
    filepaths: ["config", "code/controllers/configuration/entries"],
    add_only: true,
  },
  Спрайты: {
    filepaths: ["icons"],
    add_only: true,
  },
  Звуки: {
    filepaths: ["sound"],
    add_only: true,
  },
  UI: {
    filepaths: ["tgui"],
    add_only: true,
  },
  "Модулярная фишка": {
    filepaths: ["modular_meta"],
    add_only: true,
  },
};

// Title Labels
//
// Add a label based on keywords in the title
export const title_labels = {
  Logging: {
    keywords: ["log", "logging"],
  },
  Удаление: {
    keywords: ["убираем", "удаляем"],
  },
  Рефактор: {
    keywords: ["рефактор"],
  },
  "Unit Tests": {
    keywords: ["unit test"],
  },
  "April Fools": {
    keywords: ["[april fools]"],
  },
  "Не мержить": {
    keywords: ["[НМ]", "[не мерджить]", "[не мержить]"],
  },
  "GBP: No Update": {
    keywords: ["[no gbp]"],
  },
  "Только для ТМа": {
    keywords: [
      "[только ТМ]",
      "[только тест мердж]",
      "[только тест мерж]",
      "[ТМ]",
    ],
  },
  "Соединение с Апстримом": {
    keywords: ["[Апстрим]", "[Upstream]"],
  },
};

// Changelog Labels
//
// Adds labels based on keywords in the changelog
// TODO use the existing changelog parser
export const changelog_labels = {
  Чиним: {
    default_text: "Починены некоторые вещи",
    keywords: ["fix", "fixes", "bugfix"],
  },
  "Quality of Life": {
    default_text: "Упростили что-то в использовании",
    keywords: ["qol"],
  },
  Звуки: {
    default_text: "Добавлены/изменены/убраны аудио или звуковые эффекты",
    keywords: ["sound"],
  },
  Фишка: {
    default_text: "Добавлены новые механики",
    keywords: ["add", "adds", "rscadd"],
  },
  Удаление: {
    default_text: "Убраны старые фишки",
    keywords: ["del", "dels", "rscdel"],
  },
  Спрайты: {
    default_text: "Добавлены/изменены/убраны спрайты или картинки",
    keywords: ["image"],
  },
  "Грамматика и правильность написания": {
    default_text: "Исправлено несколько опечаток",
    keywords: ["typo", "spellcheck"],
  },
  Баланс: {
    default_text: "Ребаланс чего-то",
    keywords: ["balance"],
  },
  "Улучшение кода": {
    default_text: "Изменено немного кода",
    keywords: ["code_imp", "code"],
  },
  Рефактор: {
    default_text: "Рефактор кода",
    keywords: ["refactor"],
  },
  "Изменение конфигов": {
    default_text: "Изменено несколько настроек конфига",
    keywords: ["config"],
  },
  Администрация: {
    default_text: "Возня с админскими фишками",
    keywords: ["admin"],
  },
  "Модулярная фишка": {
    default_text:
      "Добавлены модулярные механики которые можно увидеть в вкладке со всеми модульными добавлениями",
    keywords: ["madd"],
  }, //MASSMETA ADDITION (github update)
};
