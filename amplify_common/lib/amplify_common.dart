/// Common support modules for Amplify Dart and Flutter libraries.
library amplify_common;

// API
export 'src/api/api_authorization.dart';

// Auth
export 'src/auth/cognito/user_attribute_key.dart';
export 'src/auth/user_attribute_key.dart';

// Config
export 'src/config/amplify_config.dart';

// -- Analytics
export 'src/config/analytics/analytics_config.dart' show AnalyticsConfig;
export 'src/config/analytics/pinpoint_config.dart';

// -- API
export 'src/config/api/api_config.dart' show ApiConfig;
export 'src/config/api/appsync_config.dart';

// -- Auth
export 'src/config/auth/auth_config.dart';
export 'src/config/auth/cognito_config.dart' show CognitoPluginConfig;

// -- Geo
export 'src/config/geo/amazon_location_services_config.dart';
export 'src/config/geo/geo_config.dart' show GeoConfig;

// -- Storage
export 'src/config/storage/s3_config.dart';
export 'src/config/storage/storage_config.dart' show StorageConfig;

// Utilities
export 'src/util/serializable.dart';
