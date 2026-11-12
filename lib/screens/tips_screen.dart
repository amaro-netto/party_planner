/**
 * @project Party Planner
 * @module Dicas e ideias
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
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Uma dica ou ideia, com ícone e texto completo.
class Tip {
  const Tip(this.title, this.icon, this.colors, this.text);

  final String title;
  final IconData icon;
  final List<Color> colors;
  final String text;
}

const tips = [
  Tip('As melhores bebidas de festa', Icons.local_bar, [Color(0xFF6D4C41), Color(0xFFBCAAA4)],
      'Calcule cerca de 1,5 litro de bebida por pessoa. Tenha sempre opções sem álcool, água e gelo de sobra.'),
  Tip('Playlist por gênero', Icons.queue_music, [Color(0xFF311B92), Color(0xFF7C4DFF)],
      'Comece com músicas mais calmas na recepção e deixe as mais animadas para depois do jantar.'),
  Tip('Monte um cronograma', Icons.event_note, [Color(0xFF00695C), Color(0xFF4DB6AC)],
      'Defina horários para recepção, comida, parabéns e encerramento. Isso ajuda fornecedores e convidados.'),
  Tip('Calcule a comida', Icons.restaurant, [Color(0xFFBF360C), Color(0xFFFF8A65)],
      'Para churrasco, conte 500 g de carne por adulto. Para salgados, de 12 a 15 unidades por pessoa.'),
];

const ideas = [
  Tip('Faça você mesmo', Icons.content_cut, [Color(0xFFC62828), Color(0xFFFF8A80)],
      'Painéis de papel, bandeirinhas e centros de mesa caseiros deixam a festa com a sua cara e economizam no orçamento.'),
  Tip('Qual roupa usar?', Icons.checkroom, [Color(0xFF455A64), Color(0xFFB0BEC5)],
      'Indique um traje no convite. Festas temáticas ficam mais divertidas quando todo mundo entra na brincadeira.'),
  Tip('Temas em alta', Icons.palette, [Color(0xFFAD1457), Color(0xFFF48FB1)],
      'Anos 80, tropical, boteco e festa à fantasia estão entre os temas mais pedidos.'),
  Tip('Lembrancinhas', Icons.card_giftcard, [Color(0xFF2E7D32), Color(0xFF81C784)],
      'Mudas de plantas, doces personalizados e mini kits são lembranças simples que os convidados gostam.'),
];

void _showTip(BuildContext context, Tip tip) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.cream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip.icon, color: AppColors.headerCoral, size: 36),
          const SizedBox(height: 10),
          Text(
            tip.title,
            style: const TextStyle(color: AppColors.headerCoral, fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(tip.text, style: const TextStyle(color: AppColors.text, height: 1.5)),
        ],
      ),
    ),
  );
}

/// Aba Dicas & Ideias.
class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final _scrollController = ScrollController();
  final _ideasKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIdeas() {
    final target = _ideasKey.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 400));
    }
  }

  void _scrollToTips() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return InnerBackground(
      child: Column(
        children: [
          CoralHeader(
            title: 'Dicas & Ideias',
            onBack: () => AppSession.instance.goTo(AppTab.inicio),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        title: 'Dicas de ouro que vão te ajudar',
                        icon: Icons.emoji_events,
                        color: AppColors.done,
                        onTap: _scrollToTips,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        title: 'As melhores ideias para sua festa',
                        icon: Icons.lightbulb,
                        color: AppColors.ideas,
                        onTap: _scrollToIdeas,
                      ),
                    ),
                  ],
                ),
                const SectionTitle('Dicas', color: AppColors.headerCoral),
                _TipGrid(items: tips),
                SectionTitle('Ideias', key: _ideasKey, color: AppColors.headerCoral),
                _TipGrid(items: ideas),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.title, required this.icon, required this.color, required this.onTap});

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const Spacer(),
                Icon(icon, size: 58, color: const Color(0xFFFFC928)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipGrid extends StatelessWidget {
  const _TipGrid({required this.items});

  final List<Tip> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        for (final tip in items)
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _showTip(context, tip),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: tip.colors,
                      ),
                    ),
                    child: Icon(tip.icon, color: Colors.white, size: 44, semanticLabel: tip.title),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.text, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
