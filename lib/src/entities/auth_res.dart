part of '../../../auth.dart';

class AuthResponse {
  final String? token;
  final int? status;
  final String? message;
  final bool? success;

  AuthResponse({
    this.token,
    this.status,
    this.message,
    this.success,
  });

  factory AuthResponse.fromRawJson(String str) => AuthResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json["token"],
        status: json["status"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "status": status,
        "message": message,
        "success": success,
      };
}
