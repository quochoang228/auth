part of '../../../auth.dart';

class User {
  final int? exp;
  final int? iat;
  final String? jti;
  final String? iss;
  final String? aud;
  final String? sub;
  final String? typ;
  final String? azp;
  final String? sessionState;
  final String? acr;
  final List<String>? allowedOrigins;
  final RealmAccess? realmAccess;
  final ResourceAccess? resourceAccess;
  final String? scope;
  final String? sid;
  final bool? emailVerified;
  final String? preferredUsername;
  final String? email;

  User({
    this.exp,
    this.iat,
    this.jti,
    this.iss,
    this.aud,
    this.sub,
    this.typ,
    this.azp,
    this.sessionState,
    this.acr,
    this.allowedOrigins,
    this.realmAccess,
    this.resourceAccess,
    this.scope,
    this.sid,
    this.emailVerified,
    this.preferredUsername,
    this.email,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    exp: json["exp"],
    iat: json["iat"],
    jti: json["jti"],
    iss: json["iss"],
    aud: json["aud"],
    sub: json["sub"],
    typ: json["typ"],
    azp: json["azp"],
    sessionState: json["session_state"],
    acr: json["acr"],
    allowedOrigins: json["allowed-origins"] == null ? [] : List<String>.from(json["allowed-origins"]!.map((x) => x)),
    realmAccess: json["realm_access"] == null ? null : RealmAccess.fromJson(json["realm_access"]),
    resourceAccess: json["resource_access"] == null ? null : ResourceAccess.fromJson(json["resource_access"]),
    scope: json["scope"],
    sid: json["sid"],
    emailVerified: json["email_verified"],
    preferredUsername: json["preferred_username"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "exp": exp,
    "iat": iat,
    "jti": jti,
    "iss": iss,
    "aud": aud,
    "sub": sub,
    "typ": typ,
    "azp": azp,
    "session_state": sessionState,
    "acr": acr,
    "allowed-origins": allowedOrigins == null ? [] : List<dynamic>.from(allowedOrigins!.map((x) => x)),
    "realm_access": realmAccess?.toJson(),
    "resource_access": resourceAccess?.toJson(),
    "scope": scope,
    "sid": sid,
    "email_verified": emailVerified,
    "preferred_username": preferredUsername,
    "email": email,
  };
}

class RealmAccess {
  final List<String>? roles;

  RealmAccess({
    this.roles,
  });

  factory RealmAccess.fromRawJson(String str) => RealmAccess.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RealmAccess.fromJson(Map<String, dynamic> json) => RealmAccess(
    roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
  };
}

class ResourceAccess {
  final RealmAccess? account;
  final RealmAccess? iocClient;

  ResourceAccess({
    this.account,
    this.iocClient,
  });

  factory ResourceAccess.fromRawJson(String str) => ResourceAccess.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResourceAccess.fromJson(Map<String, dynamic> json) => ResourceAccess(
    account: json["account"] == null ? null : RealmAccess.fromJson(json["account"]),
    iocClient: json["ioc_client"] == null ? null : RealmAccess.fromJson(json["ioc_client"]),
  );

  Map<String, dynamic> toJson() => {
    "account": account?.toJson(),
    "ioc_client": iocClient?.toJson(),
  };
}


