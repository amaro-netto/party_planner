/**
 * @project Party Planner
 * @module Testes
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

// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:party_planner/main.dart';
import 'package:party_planner/models/event.dart';
import 'package:party_planner/screens/login_screen.dart';
import 'package:party_planner/screens/register_screen.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/theme/app_theme.dart';

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

void main() {
  testWidgets('Splash leva à Tela Inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bem Vindo ao'), findsOneWidget);
    expect(find.text('Amaro Netto'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Vamos Começar a Festa!'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('CADASTRAR'), findsOneWidget);
  });

  testWidgets('Tela de Login mostra os campos do layout', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(const LoginScreen()));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
  });

  testWidgets('Cadastro valida campos vazios', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(const RegisterScreen()));

    await tester.ensureVisible(find.text('CADASTRAR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CADASTRAR'));
    await tester.pump();

    expect(find.text('Por favor, preencha todos os campos.'), findsOneWidget);
  });

  test('EventService compartilha os dados entre instâncias', () async {
    final event = Event(
      id: 'teste-compartilhado',
      title: 'Festa de Teste',
      location: 'Casa',
      date: DateTime(2030, 1, 1, 20),
      description: '',
      hostId: 'host',
    );

    await EventService().createEvent(event);
    final events = await EventService().getEvents();

    expect(events.any((e) => e.id == 'teste-compartilhado'), isTrue);
  });
}
