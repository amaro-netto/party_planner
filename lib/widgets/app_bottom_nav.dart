/**
 * @project Party Planner
 * @module Barra de navegação inferior
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

// lib/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';

/// Faixa escura inferior do layout (Prancheta 1): o "+" central e os ícones
/// das abas. O ícone escolhido fica dentro de uma pílula coral.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  static const List<(AppTab, IconData, String)> left = [
    (AppTab.inicio, Icons.celebration_outlined, 'Meus eventos'),
    (AppTab.tarefas, Icons.checklist, 'Tarefas'),
  ];

  static const List<(AppTab, IconData, String)> right = [
    (AppTab.fornecedores, Icons.storefront_outlined, 'Fornecedores'),
    (AppTab.dicas, Icons.tips_and_updates_outlined, 'Dicas'),
  ];

  Widget _button((AppTab, IconData, String) item) {
    final (tab, icon, label) = item;
    final selected = tab == current;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkResponse(
          onTap: () => onSelect(tab),
          radius: 30,
          child: Center(
            // Pílula de seleção: acende no ícone escolhido.
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: selected ? 60 : 44,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 26, color: selected ? Colors.white : Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.ground,
      height: 60,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        children: [
          for (final item in left) Expanded(child: _button(item)),
          const SizedBox(width: 72),
          for (final item in right) Expanded(child: _button(item)),
        ],
      ),
    );
  }
}
