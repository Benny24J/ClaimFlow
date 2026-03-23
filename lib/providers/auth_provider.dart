import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:claimflow_africa/services/api_service.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _apiService.signIn(email, password);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e, stackTrace) {
      print('SIGNIN ERROR: $e');
      print('STACK: $stackTrace');
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _apiService.signUp(name, email, password);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e, stackTrace) {
      print('SIGNUP ERROR: $e');
      print('STACK: $stackTrace');
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  void reset() {
    state = AuthState();
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});