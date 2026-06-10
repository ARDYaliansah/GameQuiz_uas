import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model representing a user account
class UserAccount {
  final String id;
  final String email;
  final String displayName;
  final bool isGuest;
  final DateTime createdAt;

  UserAccount({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isGuest,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'isGuest': isGuest,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'],
        email: json['email'],
        displayName: json['displayName'],
        isGuest: json['isGuest'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

/// Service that handles authentication using SharedPreferences.
/// Stores user accounts and passwords locally.
class AuthService {
  static const String _currentUserKey = 'current_user';
  static const String _registeredUsersKey = 'registered_users';

  /// Get the currently logged in user, or null if not logged in
  Future<UserAccount?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    try {
      return UserAccount.fromJson(jsonDecode(userJson));
    } catch (_) {
      return null;
    }
  }

  /// Check if a user is currently logged in
  Future<bool> isLoggedIn() async {
    return (await getCurrentUser()) != null;
  }

  /// Register a new user with email and password
  Future<({bool success, String message})> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get registered users
    final usersMap = _getRegisteredUsers(prefs);

    // Check if email already exists
    if (usersMap.containsKey(email.toLowerCase())) {
      return (success: false, message: 'Email sudah terdaftar. Silakan login.');
    }

    // Validate
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return (success: false, message: 'Format email tidak valid.');
    }
    if (password.length < 6) {
      return (success: false, message: 'Password minimal 6 karakter.');
    }
    if (displayName.trim().isEmpty) {
      return (success: false, message: 'Nama tidak boleh kosong.');
    }

    // Create user
    final user = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.toLowerCase().trim(),
      displayName: displayName.trim(),
      isGuest: false,
      createdAt: DateTime.now(),
    );

    // Store user data with password
    usersMap[email.toLowerCase().trim()] = {
      'user': user.toJson(),
      'password': _hashPassword(password),
    };

    await prefs.setString(_registeredUsersKey, jsonEncode(usersMap));
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

    return (success: true, message: 'Registrasi berhasil!');
  }

  /// Login with email and password
  Future<({bool success, String message})> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Validate
    if (email.isEmpty || password.isEmpty) {
      return (success: false, message: 'Email dan password harus diisi.');
    }

    final usersMap = _getRegisteredUsers(prefs);
    final userData = usersMap[email.toLowerCase().trim()];

    if (userData == null) {
      return (success: false, message: 'Email tidak ditemukan. Silakan daftar terlebih dahulu.');
    }

    // Check password
    if (userData['password'] != _hashPassword(password)) {
      return (success: false, message: 'Password salah. Silakan coba lagi.');
    }

    // Set current user
    final user = UserAccount.fromJson(userData['user']);
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

    return (success: true, message: 'Login berhasil!');
  }

  /// Login as guest
  Future<UserAccount> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final guestId = DateTime.now().millisecondsSinceEpoch.toString();

    final user = UserAccount(
      id: 'guest_$guestId',
      email: 'guest_$guestId@guest.local',
      displayName: 'Tamu',
      isGuest: true,
      createdAt: DateTime.now(),
    );

    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    return user;
  }

  /// Logout the current user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Delete the current user's account permanently
  Future<({bool success, String message})> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();

    if (currentUser == null) {
      return (success: false, message: 'Tidak ada akun yang login.');
    }

    // If not a guest, remove from registered users
    if (!currentUser.isGuest) {
      final usersMap = _getRegisteredUsers(prefs);
      usersMap.remove(currentUser.email);
      await prefs.setString(_registeredUsersKey, jsonEncode(usersMap));
    }

    // Clear current user session
    await prefs.remove(_currentUserKey);

    // Clear all user-specific data (high scores, etc.)
    await prefs.remove('high_score');

    return (success: true, message: 'Akun berhasil dihapus.');
  }

  /// Simple password hashing (base64 encoding for local storage)
  String _hashPassword(String password) {
    return base64Encode(utf8.encode('quiz_salt_$password'));
  }

  /// Get all registered users from SharedPreferences
  Map<String, dynamic> _getRegisteredUsers(SharedPreferences prefs) {
    final usersJson = prefs.getString(_registeredUsersKey);
    if (usersJson == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(usersJson));
    } catch (_) {
      return {};
    }
  }
}
