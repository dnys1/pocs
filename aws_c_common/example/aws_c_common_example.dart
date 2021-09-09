import 'dart:ffi';
import 'dart:io';

import 'package:aws_c_common/aws_c_common.dart';
import 'package:path/path.dart' as path;

void main() async {
  var dylibPath = path.absolute(
    File.fromUri(Platform.script).parent.parent.path,
    'build/libaws-c-common.dylib',
  );
  var dylib = DynamicLibrary.open(dylibPath);
  var awsCommon = AWSCommon(dylib);

  var allocator = awsCommon.aws_default_allocator();
  awsCommon.aws_common_library_init(allocator);

  var isValid = awsCommon.aws_allocator_is_valid(allocator);
  print('is valid: $isValid');

  awsCommon.aws_common_library_clean_up();
}
