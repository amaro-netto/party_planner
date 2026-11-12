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

/// Barra inferior em pílula coral com as 5 abas do layout:
/// Perfil, Fornecedores, Início, Dicas e Tarefas.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  static const List<(AppTab, IconData, String)> items = [
    (AppTab.perfil, Icons.account_circle, 'Meu perfil'),
    (AppTab.fornecedores, Icons.volunteer_activism, 'Fornecedores'),
    (AppTab.inicio, Icons.home_rounded, 'Início'),
    (AppTab.dicas, Icons.lightbulb_outline, 'Dicas'),
    (AppTab.tarefas, Icons.format_list_bulleted, 'Tarefas'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.headerCoral,
            borderRadius: BorderRadius.circular(29),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final (tab, icon, label) in items)
                _NavButton(
                  icon: icon,
                  label: label,
                  selected: tab == current,
                  onTap: () => onSelect(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.white : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: 28,
              color: selected ? AppColors.headerCoral : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
