///
//  Generated code. Do not modify.
//  source: invite_manager.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $3;
import 'google/protobuf/duration.pb.dart' as $4;

class LoginRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginRequest')
    ..aOS(1, 'username')
    ..aOS(2, 'password')
    ..hasRequiredFields = false
  ;

  LoginRequest._() : super();
  factory LoginRequest() => create();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  static LoginRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginRequest _defaultInstance;

  $core.String get username => $_getS(0, '');
  set username($core.String v) { $_setString(0, v); }
  $core.bool hasUsername() => $_has(0);
  void clearUsername() => clearField(1);

  $core.String get password => $_getS(1, '');
  set password($core.String v) { $_setString(1, v); }
  $core.bool hasPassword() => $_has(1);
  void clearPassword() => clearField(2);
}

class Invite extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Invite')
    ..aOS(1, 'code')
    ..aOS(2, 'description')
    ..aOB(3, 'admin')
    ..a<$3.Timestamp>(4, 'expiration', $pb.PbFieldType.OM, $3.Timestamp.getDefault, $3.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Invite._() : super();
  factory Invite() => create();
  factory Invite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Invite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Invite clone() => Invite()..mergeFromMessage(this);
  Invite copyWith(void Function(Invite) updates) => super.copyWith((message) => updates(message as Invite));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Invite create() => Invite._();
  Invite createEmptyInstance() => create();
  static $pb.PbList<Invite> createRepeated() => $pb.PbList<Invite>();
  static Invite getDefault() => _defaultInstance ??= create()..freeze();
  static Invite _defaultInstance;

  $core.String get code => $_getS(0, '');
  set code($core.String v) { $_setString(0, v); }
  $core.bool hasCode() => $_has(0);
  void clearCode() => clearField(1);

  $core.String get description => $_getS(1, '');
  set description($core.String v) { $_setString(1, v); }
  $core.bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  $core.bool get admin => $_get(2, false);
  set admin($core.bool v) { $_setBool(2, v); }
  $core.bool hasAdmin() => $_has(2);
  void clearAdmin() => clearField(3);

  $3.Timestamp get expiration => $_getN(3);
  set expiration($3.Timestamp v) { setField(4, v); }
  $core.bool hasExpiration() => $_has(3);
  void clearExpiration() => clearField(4);
}

class GenerateInviteRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GenerateInviteRequest')
    ..aOS(1, 'description')
    ..aOB(2, 'admin')
    ..a<$4.Duration>(3, 'expiresAfter', $pb.PbFieldType.OM, $4.Duration.getDefault, $4.Duration.create)
    ..hasRequiredFields = false
  ;

  GenerateInviteRequest._() : super();
  factory GenerateInviteRequest() => create();
  factory GenerateInviteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateInviteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GenerateInviteRequest clone() => GenerateInviteRequest()..mergeFromMessage(this);
  GenerateInviteRequest copyWith(void Function(GenerateInviteRequest) updates) => super.copyWith((message) => updates(message as GenerateInviteRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenerateInviteRequest create() => GenerateInviteRequest._();
  GenerateInviteRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateInviteRequest> createRepeated() => $pb.PbList<GenerateInviteRequest>();
  static GenerateInviteRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GenerateInviteRequest _defaultInstance;

  $core.String get description => $_getS(0, '');
  set description($core.String v) { $_setString(0, v); }
  $core.bool hasDescription() => $_has(0);
  void clearDescription() => clearField(1);

  $core.bool get admin => $_get(1, false);
  set admin($core.bool v) { $_setBool(1, v); }
  $core.bool hasAdmin() => $_has(1);
  void clearAdmin() => clearField(2);

  $4.Duration get expiresAfter => $_getN(2);
  set expiresAfter($4.Duration v) { setField(3, v); }
  $core.bool hasExpiresAfter() => $_has(2);
  void clearExpiresAfter() => clearField(3);
}

class GenerateInviteReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GenerateInviteReply')
    ..a<Invite>(1, 'invite', $pb.PbFieldType.OM, Invite.getDefault, Invite.create)
    ..hasRequiredFields = false
  ;

  GenerateInviteReply._() : super();
  factory GenerateInviteReply() => create();
  factory GenerateInviteReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateInviteReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GenerateInviteReply clone() => GenerateInviteReply()..mergeFromMessage(this);
  GenerateInviteReply copyWith(void Function(GenerateInviteReply) updates) => super.copyWith((message) => updates(message as GenerateInviteReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenerateInviteReply create() => GenerateInviteReply._();
  GenerateInviteReply createEmptyInstance() => create();
  static $pb.PbList<GenerateInviteReply> createRepeated() => $pb.PbList<GenerateInviteReply>();
  static GenerateInviteReply getDefault() => _defaultInstance ??= create()..freeze();
  static GenerateInviteReply _defaultInstance;

  Invite get invite => $_getN(0);
  set invite(Invite v) { setField(1, v); }
  $core.bool hasInvite() => $_has(0);
  void clearInvite() => clearField(1);
}

class RevokeInviteRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RevokeInviteRequest')
    ..aOS(1, 'code')
    ..hasRequiredFields = false
  ;

  RevokeInviteRequest._() : super();
  factory RevokeInviteRequest() => create();
  factory RevokeInviteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RevokeInviteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RevokeInviteRequest clone() => RevokeInviteRequest()..mergeFromMessage(this);
  RevokeInviteRequest copyWith(void Function(RevokeInviteRequest) updates) => super.copyWith((message) => updates(message as RevokeInviteRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RevokeInviteRequest create() => RevokeInviteRequest._();
  RevokeInviteRequest createEmptyInstance() => create();
  static $pb.PbList<RevokeInviteRequest> createRepeated() => $pb.PbList<RevokeInviteRequest>();
  static RevokeInviteRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RevokeInviteRequest _defaultInstance;

  $core.String get code => $_getS(0, '');
  set code($core.String v) { $_setString(0, v); }
  $core.bool hasCode() => $_has(0);
  void clearCode() => clearField(1);
}

class RevokeInviteReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RevokeInviteReply')
    ..hasRequiredFields = false
  ;

  RevokeInviteReply._() : super();
  factory RevokeInviteReply() => create();
  factory RevokeInviteReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RevokeInviteReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RevokeInviteReply clone() => RevokeInviteReply()..mergeFromMessage(this);
  RevokeInviteReply copyWith(void Function(RevokeInviteReply) updates) => super.copyWith((message) => updates(message as RevokeInviteReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RevokeInviteReply create() => RevokeInviteReply._();
  RevokeInviteReply createEmptyInstance() => create();
  static $pb.PbList<RevokeInviteReply> createRepeated() => $pb.PbList<RevokeInviteReply>();
  static RevokeInviteReply getDefault() => _defaultInstance ??= create()..freeze();
  static RevokeInviteReply _defaultInstance;
}

class ListInvitesReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListInvitesReply')
    ..pc<Invite>(1, 'invites', $pb.PbFieldType.PM,Invite.create)
    ..hasRequiredFields = false
  ;

  ListInvitesReply._() : super();
  factory ListInvitesReply() => create();
  factory ListInvitesReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListInvitesReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListInvitesReply clone() => ListInvitesReply()..mergeFromMessage(this);
  ListInvitesReply copyWith(void Function(ListInvitesReply) updates) => super.copyWith((message) => updates(message as ListInvitesReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListInvitesReply create() => ListInvitesReply._();
  ListInvitesReply createEmptyInstance() => create();
  static $pb.PbList<ListInvitesReply> createRepeated() => $pb.PbList<ListInvitesReply>();
  static ListInvitesReply getDefault() => _defaultInstance ??= create()..freeze();
  static ListInvitesReply _defaultInstance;

  $core.List<Invite> get invites => $_getList(0);
}

