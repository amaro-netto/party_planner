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

/// Crédito de autoria exibido no rodapé da splash.
///
/// Quando a logo atual do autor for adicionada em
/// `assets/images/autor_logo.png`, troque o texto por um `Image.asset`.
class AuthorCredit extends StatelessWidget {
  const AuthorCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Desenvolvido por',
          style: TextStyle(color: Colors.white70, fontSize: 11),
        ),
        SizedBox(height: 2),
        Text(
          'Amaro Netto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
