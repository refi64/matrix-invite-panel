import 'package:fixnum/fixnum.dart';

import 'generated/google/protobuf/duration.pb.dart' as proto_duration;
import 'generated/google/protobuf/timestamp.pb.dart' as proto_ts;

/// Helpers to convert between protobuf and native types.

const _nanosPerMicrosecond = 1000;

extension NativeDurationToProto on Duration {
  proto_duration.Duration toProtoDuration() => proto_duration.Duration()
    ..seconds = Int64(inSeconds)
    ..nanos = inMicroseconds.remainder(Duration.microsecondsPerSecond).toInt() *
        _nanosPerMicrosecond;
}

extension ProtoDurationToNative on proto_duration.Duration {
  Duration toNativeDuration() => Duration(
      seconds: seconds.toInt(), microseconds: nanos ~/ _nanosPerMicrosecond);
}

extension NativeDateTimeToProto on DateTime {
  proto_ts.Timestamp toProtoTimestamp() => proto_ts.Timestamp()
    ..seconds = Int64(microsecondsSinceEpoch ~/ Duration.microsecondsPerSecond)
    ..nanos = microsecondsSinceEpoch
            .remainder(Duration.microsecondsPerSecond)
            .toInt() *
        _nanosPerMicrosecond;
}

extension ProtoTimestampToNative on proto_ts.Timestamp {
  DateTime toNativeDateTime() => DateTime.fromMicrosecondsSinceEpoch(
      seconds.toInt() * Duration.microsecondsPerSecond +
          nanos.toInt() ~/ _nanosPerMicrosecond);
}
