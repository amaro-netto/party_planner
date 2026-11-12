/**
 * @project Party Planner
 * @module Dicas
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

// lib/screens/tips_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/screens/home_tab.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Uma dica com ícone e texto completo.
class Tip {
  const Tip(this.title, this.icon, this.text);

  final String title;
  final IconData icon;
  final String text;
}

const planningTips = [
  Tip('Quanto de bebida comprar', Icons.local_drink_outlined,
      'Conte cerca de 1,5 litro por pessoa e tenha sempre água, gelo e opções sem álcool.'),
  Tip('Calcule a comida', Icons.restaurant_outlined,
      'No churrasco, 500 g de carne por adulto. Em festa de salgados, de 12 a 15 unidades por pessoa.'),
  Tip('Organize o cronograma', Icons.schedule,
      'Combine horários de chegada, comida, parabéns e encerramento com os fornecedores.'),
  Tip('Monte a trilha sonora', Icons.music_note_outlined,
      'Músicas mais calmas na chegada e as mais animadas depois que todos comerem.'),
];

const inspirationTips = [
  Tip('Escolha um tema', Icons.palette_outlined,
      'Um tema ajuda a decidir cores, decoração, convite e até o cardápio.'),
  Tip('Decoração feita em casa', Icons.handyman_outlined,
      'Bandeirinhas, painéis de papel e centros de mesa caseiros economizam e deixam a festa com a sua cara.'),
  Tip('Combine o traje', Icons.checkroom_outlined,
      'Avise no convite se a festa tem traje ou tema. Assim ninguém chega deslocado.'),
  Tip('Lembrancinhas simples', Icons.card_giftcard_outlined,
      'Doces embalados, mudas de plantas ou uma foto do dia são lembranças baratas e marcantes.'),
];

/// Aba Dicas.
class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  void _showTip(BuildContext context, Tip tip) {
    showPartySheet<void>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip.icon, color: AppColors.coral, size: 34),
          const SizedBox(height: 10),
          Text(
            tip.title,
            style: const TextStyle(color: AppColors.ground, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(tip.text, style: const TextStyle(color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PartyPage(
      title: 'Dicas',
      onBack: () => AppSession.instance.goTo(AppTab.inicio),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, kBottomBarSpace),
        children: [
          const SectionTitle('Planejamento'),
          for (final tip in planningTips)
            PillRow(icon: tip.icon, label: tip.title, onTap: () => _showTip(context, tip)),
          const SectionTitle('Inspiração'),
          for (final tip in inspirationTips)
            PillRow(icon: tip.icon, label: tip.title, onTap: () => _showTip(context, tip)),
        ],
      ),
    );
  }
}
