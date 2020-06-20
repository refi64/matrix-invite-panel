# Contributing notes

- All code must be formatted using dartfmt.
- To regenerate the gRPC service protos, go to the `common` folder and run
  `pub get` and `pub run grinder built-protos`. Note that *the path to the system protos is
  hardcoded* in `tool/grinder.dart`; you'll have to edit that by hand to adjust the paths for your
  system.
