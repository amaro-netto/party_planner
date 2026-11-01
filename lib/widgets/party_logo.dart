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

// lib/widgets/party_logo.dart
import 'package:flutter/material.dart';

/// Logo oficial "PARTY PLANNER".
class PartyLogo extends StatelessWidget {
  const PartyLogo({super.key, this.width = 260});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/party_planner_logo.png',
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'Party Planner',
    );
  }
}
