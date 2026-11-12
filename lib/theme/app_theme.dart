/**
 * @project Party Planner
 * @module Tema e identidade visual
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

// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Paleta oficial do Party Planner, extraída do layout no Illustrator.
class AppColors {
  AppColors._();

  /// Laranja do topo do degradê.
  static const Color orange = Color(0xFFFF8F0F);

  /// Coral da base do degradê.
  static const Color coral = Color(0xFFFF654D);

  /// Destaque usado no anel do botão "+".
  static const Color accent = Color(0xFFF25D45);

  /// Cinza-escuro da multidão e da faixa inferior.
  static const Color ground = Color(0xFF2F2F2F);

  /// Azul-marinho do contorno da logo.
  static const Color navy = Color(0xFF20263A);

  /// Cinza do quadrado de ícone dos campos.
  static const Color fieldIcon = Color(0xFFCDCDCD);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [orange, coral],
  );

  // ---- Status das tarefas ----
  static const Color taskUrgent = accent;
  static const Color taskTodo = orange;
  static const Color taskDone = Color(0xFF2E7D32);
}

/// Tema central do aplicativo.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      primary: AppColors.orange,
      secondary: AppColors.coral,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: AppColors.orange,
      scaffoldBackgroundColor: const Color(0xFFFFF6EE),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.ground,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ground,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
