import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:party_planner/main.dart';

void main() {
  testWidgets('Verifica se a tela de Login é exibida corretamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Não tem uma conta? Registre-se aqui.'), findsOneWidget);
  });
}
