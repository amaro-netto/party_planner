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
import 'package:party_planner/screens/tasks_screen.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/services/event_service.dart';
import 'package:party_planner/services/task_service.dart';
import 'package:party_planner/widgets/app_bottom_nav.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/author_credit.dart';

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

void main() {
  testWidgets('Splash leva à Tela Inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bem Vindo ao'), findsOneWidget);
    expect(find.byType(AuthorCredit), findsOneWidget);

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

  test('TaskService cria o checklist padrão e apaga as concluídas', () {
    final service = TaskService();
    final tasks = service.tasksFor('evento-checklist');

    expect(tasks, isNotEmpty);
    expect(tasks.first.title, 'Fazer lista de convidados');
    expect(tasks.first.urgent, isTrue);

    service.updateTask(tasks.first.copyWith(done: true));
    expect(service.removeDone('evento-checklist'), 1);
    expect(service.tasksFor('evento-checklist').length, tasks.length - 1);
  });

  testWidgets('Barra inferior troca de aba', (WidgetTester tester) async {
    final session = AppSession.instance..reset();
    await tester.pumpWidget(_wrap(
      Scaffold(
        body: ValueListenableBuilder<AppTab>(
          valueListenable: session.tab,
          builder: (context, tab, _) => AppBottomNav(current: tab, onSelect: session.goTo),
        ),
      ),
    ));

    await tester.tap(find.byTooltip('Dicas'));
    await tester.pump();
    expect(session.tab.value, AppTab.dicas);

    await tester.tap(find.byTooltip('Tarefas'));
    await tester.pump();
    expect(session.tab.value, AppTab.tarefas);
  });

  testWidgets('Excluir tarefa pede confirmação', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    AppSession.instance.currentEvent.value = Event(
      id: 'evento-exclusao',
      title: 'Festa',
      location: 'Casa',
      date: DateTime(2030, 1, 1, 20),
      description: '',
      hostId: 'host',
    );
    addTearDown(AppSession.instance.reset);

    await tester.pumpWidget(_wrap(const Scaffold(body: TasksScreen())));
    expect(find.text('Fazer lista de convidados'), findsOneWidget);

    await tester.tap(find.text('Fazer lista de convidados'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir esta tarefa?'), findsOneWidget);

    await tester.tap(find.text('EXCLUIR'));
    await tester.pumpAndSettle();
    expect(find.text('Fazer lista de convidados'), findsNothing);
  });
}
