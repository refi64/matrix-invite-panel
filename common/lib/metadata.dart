/// The GRPC client-to-server metadata key holding the auth token.
const authRpcMetadataKey = 'auth-jwt';

/// The GRPC server-to-client metadata key holding the *new* auth token.
const rotatedRpcMetadataKey = 'rotated-jwt';
