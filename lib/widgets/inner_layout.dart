/**
 * @project Party Planner
 * @module Componentes das telas internas
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

// lib/widgets/inner_layout.dart
import 'package:flutter/material.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/party_background.dart';
import 'package:party_planner/widgets/party_logo.dart';

/// Página interna no padrão do Party Planner: o mesmo degradê e a multidão
/// translúcida do dashboard, com a logo pequena e o título em branco.
class PartyPage extends StatelessWidget {
  const PartyPage({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PartyBackground(
      showGround: false,
      crowdColor: Colors.white.withValues(alpha: 0.18),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
            child: Row(
              children: [
                if (onBack != null)
                  IconButton(
                    tooltip: 'Voltar',
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: onBack,
                  )
                else
                  const SizedBox(width: 12),
                const PartyLogo(width: 64),
                const Spacer(),
                ...actions,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Linha branca com o bloco de ícone cinza à esquerda, no mesmo desenho dos
/// campos de Login e Cadastro.
class PillRow extends StatelessWidget {
  const PillRow({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing = const Icon(Icons.chevron_right, color: AppColors.coral),
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: const Color(0x33000000),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 52,
                  constraints: const BoxConstraints(minHeight: 52),
                  color: AppColors.fieldIcon,
                  child: Icon(icon, color: AppColors.ground),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: AppColors.ground,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
                if (trailing != null)
                  Padding(padding: const EdgeInsets.only(right: 8), child: Center(child: trailing)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Título de seção em branco sobre o degradê.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Folha branca de detalhes que sobe da base da tela.
Future<T?> showPartySheet<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: builder(context),
      ),
    ),
  );
}

/// Confirmação antes de excluir. Devolve true só em "EXCLUIR".
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String message = 'Essa ação não pode ser desfeita.',
  String confirmLabel = 'EXCLUIR',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(color: AppColors.ground, fontWeight: FontWeight.w700)),
      content: Text(message, style: const TextStyle(color: Colors.black54)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.ground),
          child: const Text('CANCELAR'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.coral),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Dias que faltam até a data, contando por dia do calendário.
int daysUntil(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  return day.difference(today).inDays;
}

/// Contagem regressiva curta: "em 12 dias", "amanhã", "hoje".
String countdownLabel(DateTime date) {
  final days = daysUntil(date);
  if (days > 1) return 'em $days dias';
  if (days == 1) return 'amanhã';
  if (days == 0) return 'hoje';
  return 'já passou';
}

/// Formata valores em reais sem depender de pacotes externos: R$ 1.234,50.
String formatMoney(double value) {
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final digits = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '-' : ''}R\$ $buffer,${parts[1]}';
}
