# BudgetUp

A budget management mobile application built with Flutter and AWS backend.

### setup
add these dependencies
```bash
flutter pub add http
flutter pub add shared_preferences
```
running the app

```bash
flutter pub get
flutter run
```


## auth flow

The app uses JWT-based authentication with AWS Lambda functions. User credentials are sent to AWS API Gateway, which triggers a Lambda function for authentication.

1. login process:
user enter email/password, app validates input, 
LoginRequest object is created and sent to AWS backend via api call
LoginResponse object is recieved with JWT token
user and token data are stared locally using "SharedPreferences"

2. storing toekn
JWT token is stored in local storage, user data is cashed for offline access
token is inside every api request in the ap inside the "AUTHORIZATION" header of the api calls

`Authorization: Bearer <token>` header



### backend notes
setup api gateway

lib/services/api_service.dart
```dart
static const String baseUrl = 'https://your-api-gateway-url.amazonaws.com/prod';
```


# sample endpoints WIP

**POST /auth/login**
- **Purpose:** Authenticate user
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Success Response (200):**
  ```json
  {
    "success": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "user123",
      "email": "user@example.com",
      "name": "John Doe"
    }
  }
  ```
- **Error Response (401):**
  ```json
  {
    "success": false,
    "message": "Invalid email or password"
  }
  ```


#### Making Authenticated API Calls

Example of calling protected endpoints:

```dart
final apiService = ApiService();
final authService = AuthService();

// Get stored token
final token = await authService.getToken();

if (token != null) {
  // Make authenticated request
  final response = await apiService.makeAuthenticatedRequest(
    '/budget/list',
    token,
  );
}
```


### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── auth_models.dart      # LoginRequest, LoginResponse, User models
├── services/
│   ├── api_service.dart      # HTTP client for AWS API calls
│   └── auth_service.dart     # Token and user data management
└── screens/
    └── login_screen.dart     # Login UI
```


