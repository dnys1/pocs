// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@JS()

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import './base.dart';

/// A CrossFile that works on web.
///
/// It wraps the bytes of a selected file.
class XFile extends XFileBase {
  /// Construct a CrossFile object from its ObjectUrl.
  ///
  /// Optionally, this can be initialized with `bytes` and `length`
  /// so no http requests are performed to retrieve files later.
  ///
  /// `name` needs to be passed from the outside, since we only have
  /// access to it while we create the ObjectUrl.
  XFile(
    this.path, {
    this.mimeType,
    String? name,
    int? length,
    Uint8List? bytes,
    DateTime? lastModified,
  })  : _data = bytes,
        _length = length,
        _blob = null,
        _lastModified = lastModified ?? DateTime.fromMillisecondsSinceEpoch(0),
        name = name ?? '',
        super(path);

  /// Construct an CrossFile from its data
  XFile.fromData(
    Uint8List bytes, {
    this.mimeType,
    String? name,
    int? length,
    DateTime? lastModified,
    String? path,
  })  : _data = bytes,
        _blob = (mimeType == null)
            ? Blob(<dynamic>[bytes])
            : Blob(<dynamic>[bytes], mimeType),
        _length = length,
        _lastModified = lastModified ?? DateTime.fromMillisecondsSinceEpoch(0),
        name = name ?? '',
        super(path) {
    if (path == null) {
      this.path = Url.createObjectUrl(_blob);
    } else {
      this.path = path;
    }
  }

  XFile.fromFile(
    File file, {
    this.mimeType,
  })  : _data = null,
        _blob = file,
        _length = file.size,
        _lastModified = file.lastModifiedDate,
        name = file.name,
        super(file.relativePath);

  @override
  final String? mimeType;
  @override
  final String name;
  @override
  late String path;

  final Blob? _blob;
  final Uint8List? _data;
  final int? _length;
  final DateTime? _lastModified;

  @override
  Future<DateTime> lastModified() async =>
      Future<DateTime>.value(_lastModified);

  Future<Uint8List> get _bytes async {
    if (_data != null) {
      return Future<Uint8List>.value(UnmodifiableUint8ListView(_data!));
    }

    // We can force 'response' to be a byte buffer by passing responseType:
    final ByteBuffer? response =
        (await HttpRequest.request(path, responseType: 'arraybuffer')).response;

    return response?.asUint8List() ?? Uint8List(0);
  }

  @override
  Future<int> length() async => _length ?? (await _bytes).length;

  @override
  Future<String> readAsString({Encoding encoding = utf8}) async {
    return encoding.decode(await _bytes);
  }

  @override
  Future<Uint8List> readAsBytes() async =>
      Future<Uint8List>.value(await _bytes);

  @override
  Stream<Uint8List> openRead([int? start, int? end]) async* {
    if (_blob == null) {
      final Uint8List bytes = await _bytes;
      yield bytes.sublist(start ?? 0, end ?? bytes.length);
      return;
    }
    final controller = StreamController<Uint8List>(sync: true);
    final stream = _blob!.stream();
    stream.reader().openRead().listen(controller.add,
        onError: controller.addError,
        onDone: stream.cancel,
        cancelOnError: true);
    yield* controller.stream;
  }

  /// Saves the data of this CrossFile at the location indicated by path.
  /// For the web implementation, the path variable is ignored.
  @override
  Future<void> saveTo(String path) async {
    throw UnimplementedError();
  }
}

extension on Blob {
  ReadableStream stream() => callMethod(this, 'stream', []);
}

@JS()
class ReadableStream {
  external ReadableStreamDefaultReader reader();
}

extension on ReadableStream {
  Future<void> cancel() {
    final promise = callMethod(this, 'cancel', []);
    return promiseToFuture(promise);
  }
}

@JS()
class ReadableStreamDefaultReader {}

@JS()
@anonymous
class ReadableStreamValue {
  external factory ReadableStreamValue({
    Uint8List value,
    bool done,
  });

  external Uint8List get value;
  external bool get done;
}

extension on ReadableStreamDefaultReader {
  Stream<Uint8List> openRead() async* {
    while (true) {
      final chunkPromise = callMethod(this, 'read', []);
      final ReadableStreamValue chunk = await promiseToFuture(chunkPromise);
      if (chunk.done) {
        return;
      }
      yield chunk.value;
    }
  }
}
