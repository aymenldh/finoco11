library envirement_config;

const bool kReleaseMode =
    bool.fromEnvironment('dart.vm.product', defaultValue: false);
const bool kProfileMode =
    bool.fromEnvironment('dart.vm.profile', defaultValue: false);
const bool kDebugMode = !kReleaseMode && !kProfileMode;

const debugConfig = {
  'baseUrl': 'https://d1s141fbt1.execute-api.us-east-1.amazonaws.com/dev'
};

const preProdConfig = {
  'baseUrl': 'https://api.finoco.tn',
};

const releaseConfig = {
  'baseUrl': 'https://api.finoco.tn',
};

const environment = releaseConfig;
