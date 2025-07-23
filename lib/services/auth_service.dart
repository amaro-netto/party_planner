// lib/services/auth_service.dart
import 'package:flutter/foundation.dart'; // Para usar debugPrint

// Esta classe simula um serviço de autenticação.
// No futuro, aqui estaria a lógica de conexão com Firebase Auth.
class AuthService {
  // Método para simular o registro de um novo usuário.
  Future<bool> registerUser(String email, String password) async {
    debugPrint('Tentando registrar: $email com a senha: $password');
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Usuário $email registrado com sucesso (simulado).');
    return true;
  }

  // Método para simular o login de um usuário existente.
  Future<bool> loginUser(String email, String password) async {
    debugPrint('Tentando login: $email com a senha: $password');
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Usuário $email logado com sucesso (simulado).');
    return true;
  }
}