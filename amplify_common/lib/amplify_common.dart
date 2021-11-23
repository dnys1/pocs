/// Common support modules for Amplify Dart and Flutter libraries.
library amplify_common;

// Config
export 'src/config/amplify_config.dart';

// API
export 'src/api/api_authorization.dart';
export 'src/config/api/api_config.dart' show ApiConfig;
export 'src/config/api/appsync_config.dart';

// Auth
export 'src/config/auth/auth_config.dart';
export 'src/config/auth/cognito_config.dart' show CognitoPluginConfig;

// Geo
export 'src/config/geo/amazon_location_services_config.dart'
    show
        AmazonLocationServicesPluginConfig,
        AmazonLocationServicesMap,
        AmazonLocationServicesMaps;

// Storage
export 'src/config/storage/s3_config.dart';
export 'src/config/storage/storage_config.dart' show StorageConfig;

// Utilities
export 'src/util/serializable.dart';
