import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';

/// Manages authentication state across the app
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserAccount? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserAccount? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isGuest => _currentUser?.isGuest ?? false;
  String? get errorMessage => _errorMessage;
  String get displayName => _currentUser?.displayName ?? 'User';
  String get email => _currentUser?.email ?? '';

  /// Check if user is already logged in (called on app start)
  Future<void> checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authService.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  /// Register a new account with email
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.success) {
      _currentUser = await _authService.getCurrentUser();
    } else {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return result.success;
  }

  /// Login with email and password
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    if (result.success) {
      _currentUser = await _authService.getCurrentUser();
    } else {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return result.success;
  }

  /// Login as a guest user
  Future<void> loginAsGuest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _currentUser = await _authService.loginAsGuest();

    _isLoading = false;
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  /// Delete account permanently
  Future<bool> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.deleteAccount();

    if (result.success) {
      _currentUser = null;
    } else {
      _errorMessage = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return result.success;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
