/**
 * @project Party Planner
 * @module Sessão e navegação
 * @author amaro-netto / Amaro Amarante da Silva Netto
 * @contact contato@amaronetto.com.br
 * @date 12/11/2026
 *
 * SOBRE OS DIREITOS AUTORAIS:
 * A arquitetura, design estrutural e desenvolvimento deste software foram
 * realizados pelo autor supracitado. Os direitos patrimoniais e de licença
 * de uso pertencem ao próprio autor, Amaro Amarante da Silva Netto.
 *
 * Ficam resguardados os direitos morais do autor original, sendo vedada a
 * remoção deste aviso de autoria do código-fonte (Lei 9.609/1998).
 */

// lib/services/app_session.dart
import 'package:flutter/foundation.dart';
import 'package:party_planner/models/event.dart';

/// Abas da barra inferior, na ordem em que aparecem.
enum AppTab { perfil, fornecedores, inicio, dicas, tarefas }

/// Estado de navegação compartilhado entre as telas internas: aba aberta e
/// evento selecionado. Singleton, como o EventService.
class AppSession {
  AppSession._();
  static final AppSession instance = AppSession._();

  final ValueNotifier<AppTab> tab = ValueNotifier(AppTab.inicio);
  final ValueNotifier<Event?> currentEvent = ValueNotifier(null);

  void goTo(AppTab value) => tab.value = value;

  void openEvent(Event event) {
    currentEvent.value = event;
    tab.value = AppTab.inicio;
  }

  void closeEvent() => currentEvent.value = null;

  void reset() {
    tab.value = AppTab.inicio;
    currentEvent.value = null;
  }
}
