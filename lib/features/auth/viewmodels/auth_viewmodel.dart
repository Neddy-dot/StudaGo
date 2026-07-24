import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> login(String username, String password) async {
    state = AuthState(user: state.user, isLoading: true, error: null);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (username.isEmpty || password.isEmpty) {
      state = AuthState(user: state.user, isLoading: false, error: 'Username and password cannot be empty');
      return;
    }

    // Mock role-based routing
    UserRole role = UserRole.parent;
    if (username.toLowerCase().contains('admin')) {
      role = UserRole.admin;
    } else if (username.toLowerCase().contains('guard')) {
      role = UserRole.guard;
    } else if (username.toLowerCase().contains('driver')) {
      role = UserRole.driver;
    }

    final user = UserModel(id: '123', name: username, role: role);
    state = AuthState(user: user, isLoading: false, error: null);
  }
  
  void logout() {
    state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
