part of '../../../auth.dart';

abstract class AuthApi {
  Future<Response> login({
    required String url,
    required Map<String, dynamic> request,
  });
}

class AuthApiImpl implements AuthApi {
  final ApiGateway _apiGateway;

  AuthApiImpl({
    required ApiGateway apiGateway,
  }) : _apiGateway = apiGateway;

  @override
  Future<Response> login({
    required String url,
    required Map<String, dynamic> request,
  }) {
    return _apiGateway.post(
      url,
      data: request,
    );
  }
}
