import 'package:angular/angular.dart';
import 'package:grpc/grpc_web.dart';

import '../../config.dart';

GrpcWebClientChannel channelFactory(Config config) =>
    GrpcWebClientChannel.xhr(Uri.parse(config.backend));

const channelProvider =
    FactoryProvider<GrpcWebClientChannel>(GrpcWebClientChannel, channelFactory);
