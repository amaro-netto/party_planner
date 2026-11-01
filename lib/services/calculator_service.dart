/**
 * @project Party Planner
 * @module Calculadoras de consumo
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

// lib/services/calculator_service.dart

// Esta classe oferece métodos para calcular quantidades de itens de festa.
class CalculatorService {
  // Calcula a quantidade estimada de bebida por convidado.
  // Retorna a quantidade de litros estimada.
  double calculateBeveragePerGuest(int numberOfGuests,
      {double consumptionPerGuestLiters = 1.5}) {
    // Consumo médio: 1.5 litros por pessoa (pode variar).
    // Isso pode incluir refrigerante, suco, água, etc.
    return numberOfGuests * consumptionPerGuestLiters;
  }

  // Calcula a quantidade estimada de carne para churrasco por convidado.
  // Retorna a quantidade de carne em quilos (kg).
  double calculateMeatPerGuest(int numberOfGuests,
      {double consumptionPerGuestKg = 0.5}) {
    // Consumo médio: 0.5 kg de carne por pessoa.
    return numberOfGuests * consumptionPerGuestKg;
  }

  // NOVO: Adiciona um método para calcular o total de pessoas (convidados + acompanhantes).
  int calculateTotalAttendees(int confirmedGuests, int totalPlusOnes) {
    return confirmedGuests + totalPlusOnes;
  }
}