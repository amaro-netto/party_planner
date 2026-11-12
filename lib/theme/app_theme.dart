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

  // ---- Telas internas (menu do evento, tarefas, fornecedores, dicas) ----

  /// Creme do topo das telas internas.
  static const Color cream = Color(0xFFFDF1E3);

  /// Pêssego da base das telas internas.
  static const Color peach = Color(0xFFF8D5BA);

  /// Coral do cabeçalho e da barra inferior.
  static const Color headerCoral = Color(0xFFEC6446);

  /// Fundo claro dos cartões.
  static const Color card = Color(0xFFFFFBF6);

  /// Texto principal das telas internas.
  static const Color text = Color(0xFF4A4A4A);

  /// Texto secundário (descrições curtas).
  static const Color textSoft = Color(0xFF8A8A8A);

  /// Status das tarefas, definidos no estudo de usabilidade.
  static const Color urgent = Color(0xFFE5361F);
  static const Color pending = Color(0xFFEDB234);
  static const Color done = Color(0xFF3A8C7E);

  /// Azul-marinho do cartão "ideias".
  static const Color ideas = Color(0xFF2F4F86);

  static const LinearGradient innerBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cream, peach],
  );
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
