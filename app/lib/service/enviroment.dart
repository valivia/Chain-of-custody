class EnvironmentConfig {
  static const appName = String.fromEnvironment(
    'COC_APP_NAME',
    defaultValue: 'CoC'
  );
    static const apiUrl = String.fromEnvironment(
    'COC_API_URL',
    defaultValue: 'https://coc.hootsifer.com'
  );
}