/**
 * @project Party Planner
 * @module Componentes visuais
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

// lib/widgets/author_credit.dart
import 'package:flutter/material.dart';

/// Crédito de autoria exibido no rodapé da splash: logo atual
/// "Amaro Netto - Soluções em TI" sobre um selo claro, para manter o contraste
/// em cima da multidão escura.
class AuthorCredit extends StatelessWidget {
  const AuthorCredit({super.key, this.width = 170});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        'assets/images/autor_logo.png',
        width: width,
        fit: BoxFit.contain,
        semanticLabel: 'Desenvolvido por Amaro Netto - Soluções em TI',
      ),
    );
  }
}
