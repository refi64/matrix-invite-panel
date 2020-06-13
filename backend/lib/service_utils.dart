import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';

/// A simple helper to wrap GRPC method handlers with better error reporting.
/// In particular, we don't want exact errors leaking out in case they contain
/// sensitive information.
extension ServiceLogger on Logger {
  Future<Reply> wrapHandler<Request, Reply>(ServiceCall call, Request request,
      Future<Reply> Function(ServiceCall, Request) handler) async {
    try {
      return await handler(call, request);
    } on GrpcError catch (ex, stackTrace) {
      e('Grpc error', ex, stackTrace);
      rethrow;
    } catch (ex, stackTrace) {
      e('Internal server error', ex, stackTrace);
      throw GrpcError.internal('Internal server error');
    }
  }
}
