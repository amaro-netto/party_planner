// lib/services/notification_service.dart
import 'package:flutter/foundation.dart'; // Para usar debugPrint
import 'package:party_planner/models/event.dart'; // Importa o modelo de Evento

// Esta classe simula um serviço de notificações.
// No futuro, aqui estaria a lógica de agendamento e envio de notificações reais
// via Firebase Cloud Messaging (FCM) ou outro serviço.
class NotificationService {
  // Método para simular o agendamento de um lembrete para um evento.
  // Recebe o evento, a mensagem do lembrete e o tempo antes do evento.
  Future<void> scheduleEventReminder(
      Event event, String message, Duration timeBeforeEvent) async {
    // Calcula o tempo até o lembrete.
    final Duration timeUntilReminder = event.date.difference(DateTime.now()) - timeBeforeEvent;

    if (timeUntilReminder.isNegative) {
      debugPrint('Lembrete para "${event.title}" no passado. Não agendado.');
      return;
    }

    debugPrint(
        'Simulando agendamento de lembrete para "${event.title}": "$message" '
        'para daqui a ${timeUntilReminder.inSeconds} segundos '
        '(originalmente ${timeBeforeEvent.inDays} dias/horas antes do evento).');

    // Simula o atraso até o "envio" do lembrete.
    // Em um app real, o agendamento seria feito no servidor ou com notificações locais.
    await Future.delayed(timeUntilReminder);

    debugPrint(
        'Lembrete SIMULADO "🔔 ${message}" enviado para o evento "${event.title}"!');
    // Futuramente, aqui você chamaria um serviço de notificação local ou push.
  }

  // Método para simular o cancelamento de lembretes para um evento.
  Future<void> cancelEventReminders(String eventId) async {
    debugPrint('Simulando cancelamento de lembretes para o evento $eventId.');
    // No futuro, aqui estaria a lógica para cancelar notificações agendadas.
  }

  // Método para simular o envio imediato de um alerta (visível apenas no console).
  void sendInstantAlert(String message) {
    debugPrint('ALERTA INSTANTÂNEO: $message');
    // Para um alerta real, você usaria um sistema de Snackbar, Dialog ou Push Notification.
  }
}