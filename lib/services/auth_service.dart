/**
 * @project Party Planner
 * @module Autenticação
 * @author amaro-netto / Amaro Amarante da Silva Netto
 * @contact contato@amaronetto.com.br
 * @date 01/11/2026
 *
 * SOBRE OS DIREITOS AUTORAIS:
 * A arquitetura, design estrutural e desenvolvimento deste software foram
 * realizados pelo autor supracitado. Os direitos patrimoniais e de licença
 * de uso pertencem ao próprio autor, Amaro Amarante da Silva Netto.
 *
 * Ficam resguardados os direitos morais do autor original, sendo vedada a
 * remoção deste aviso de autoria do código-fonte (Lei 9.609/1998).
 */

// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';

/// Serviço de autenticação simulado.
/// No futuro, aqui estará a integração com o Firebase Auth.
///
/// É um singleton para que todas as telas compartilhem a mesma sessão.
class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  String? _currentUserEmail;
  String? _currentUserName;

  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserName => _currentUserName;

  /// Simula o cadastro de um novo usuário.
  Future<bool> registerUser(String email, String password, {String? name}) async {
    debugPrint('Registrando usuário: $email (simulado).');
    await Future.delayed(const Duration(seconds: 1));
    _currentUserName = name;
    return true;
  }

  /// Simula o login de um usuário existente.
  Future<bool> loginUser(String email, String password) async {
    debugPrint('Login: $email (simulado).');
    await Future.delayed(const Duration(seconds: 1));
    _currentUserEmail = email;
    return true;
  }

  /// Simula o logout do usuário.
  Future<void> logout() async {
    debugPrint('Logout (simulado).');
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUserEmail = null;
  }
}
