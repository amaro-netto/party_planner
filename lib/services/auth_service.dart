import 'package:flutter/foundation.dart'; // Para usar debugPrint

// Esta classe simula um serviço de autenticação.
// No futuro, aqui estaria a lógica de conexão com Firebase Auth.
class AuthService {
  // Método para simular o registro de um novo usuário.
  // Recebe um email e uma senha.
  // Retorna true se o registro for "bem-sucedido", false caso contrário.
  Future<bool> registerUser(String email, String password) async {
    // Imprime no console de depuração (visível no VS Code)
    debugPrint('Tentando registrar: $email com a senha: $password');
    // Simula um atraso de 2 segundos para representar uma chamada de rede.
    await Future.delayed(const Duration(seconds: 2));

    // Simula um sucesso de registro para qualquer tentativa.
    // Em um app real, haveria validação e comunicação com o backend.
    debugPrint('Usuário $email registrado com sucesso (simulado).');
    return true;
  }

  // Método para simular o login de um usuário existente.
  // Recebe um email e uma senha.
  // Retorna true se o login for "bem-sucedido", false caso contrário.
  Future<bool> loginUser(String email, String password) async {
    debugPrint('Tentando login: $email com a senha: $password');
    await Future.delayed(const Duration(seconds: 2));

    // Simula um sucesso de login para qualquer tentativa.
    // Em um app real, haveria verificação de credenciais com o backend.
    debugPrint('Usuário $email logado com sucesso (simulado).');
    return true;
  }
}