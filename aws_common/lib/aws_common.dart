/// Common support library for AWS packages.
library aws_common;

export 'src/equatable.dart';
export 'src/json.dart';
export 'src/serializable.dart';

export 'src/platform_file/stub.dart'
    if (dart.library.io) 'src/platform_file/io.dart'
    if (dart.library.html) 'src/platform_file/html.dart';
