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

// lib/widgets/party_background.dart
import 'package:flutter/material.dart';
import 'package:party_planner/theme/app_theme.dart';

/// Fundo padrão das telas: degradê laranja→coral com a multidão em silhueta.
///
/// [showGround] desenha a faixa escura abaixo da multidão (telas de entrada).
/// [crowdColor] permite usar a multidão escura (entrada) ou translúcida (dashboard).
class PartyBackground extends StatelessWidget {
  const PartyBackground({
    super.key,
    required this.child,
    this.showGround = true,
    this.crowdColor = AppColors.ground,
    this.groundFraction = 0.14,
  });

  final Widget child;
  final bool showGround;
  final Color crowdColor;
  final double groundFraction;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/crowd_silhouette.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                    color: crowdColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  if (showGround)
                    Container(
                      height: height * groundFraction,
                      color: crowdColor,
                    ),
                ],
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
