enum AppLanguage { English, Mon }

/// Returns enum value name without enum class name.
String enumName(AppLanguage anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appLanguageData = {
  AppLanguage.English: {"value": "en", "name": "English"},
  AppLanguage.Mon: {"value": "mon", "name": "Mon"},
};
