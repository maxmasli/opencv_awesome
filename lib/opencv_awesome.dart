import 'dart:async';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'data/methods.dart';
import 'modal/ProcessImage.dart';

class OpencvAwesome {
  static const MethodChannel _channel =
      const MethodChannel('opencv_awesome');
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
 static Future<void> stitch_horizontally(List<String> inputpath, String output_path,
      Function oncompleted) async {
    final port = ReceivePort();
    final args = ProcessImageArguments(inputpath.toString(), output_path);
    Isolate.spawn<ProcessImageArguments>(
        Methods.stitchImageHorizontal,
        args,
        onError: port.sendPort,
        onExit: port.sendPort
    );
    StreamSubscription? sub;
    sub = port.listen((_) async {
      await sub?.cancel();
      oncompleted(output_path);
    });
  }
  static Future<void> stitch_vertically(List<String> inputpath, String output_path,
      Function oncompleted) async {
    final port = ReceivePort();
    final args = ProcessImageArguments(inputpath.toString(), output_path);
    // Spawning an isolate

    Isolate.spawn<ProcessImageArguments>(
        Methods.stitchImageVertical,
        args,
        onError: port.sendPort,
        onExit: port.sendPort
    );
    StreamSubscription? sub;
    sub = port.listen((_) async {
      await sub?.cancel();
      oncompleted(output_path);
    });
  }
}

