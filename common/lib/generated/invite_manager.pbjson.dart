///
//  Generated code. Do not modify.
//  source: invite_manager.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const LoginRequest$json = const {
  '1': 'LoginRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

const Invite$json = const {
  '1': 'Invite',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'admin', '3': 3, '4': 1, '5': 8, '10': 'admin'},
    const {'1': 'expiration', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'expiration'},
  ],
};

const GenerateInviteRequest$json = const {
  '1': 'GenerateInviteRequest',
  '2': const [
    const {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'admin', '3': 2, '4': 1, '5': 8, '10': 'admin'},
    const {'1': 'expires_after', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'expiresAfter'},
  ],
};

const GenerateInviteReply$json = const {
  '1': 'GenerateInviteReply',
  '2': const [
    const {'1': 'invite', '3': 1, '4': 1, '5': 11, '6': '.Invite', '10': 'invite'},
  ],
};

const RevokeInviteRequest$json = const {
  '1': 'RevokeInviteRequest',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

const RevokeInviteReply$json = const {
  '1': 'RevokeInviteReply',
};

const ListInvitesReply$json = const {
  '1': 'ListInvitesReply',
  '2': const [
    const {'1': 'invites', '3': 1, '4': 3, '5': 11, '6': '.Invite', '10': 'invites'},
  ],
};

