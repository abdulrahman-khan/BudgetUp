// API SERVICE FILE CONNECTS TO AWS BACKEND

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class ApiService {
  // TODO:
  static const String baseUrl =
      'https://your-api-gateway-url.amazonaws.com/prod';

  // API endpoints
  static const String loginEndpoint = '/auth/login';

  /// Authenticate user with email and password
  /// Sends POST request to AWS Lambda function via API Gateway
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('$baseUrl$loginEndpoint');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        return LoginResponse(
          success: false,
          message: 'Invalid email or password',
        );
      } else {
        final data = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Example method for authenticated API calls
  /// Include the JWT token in the Authorization header
  Future<http.Response> makeAuthenticatedRequest(
    String endpoint,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
