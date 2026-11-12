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

/// Fundo creme→pêssego das telas internas.
class InnerBackground extends StatelessWidget {
  const InnerBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.innerBackground),
      child: child,
    );
  }
}

/// Cabeçalho coral com cantos inferiores arredondados: voltar, ícone, título
/// e o envelope de mensagens à direita.
class CoralHeader extends StatelessWidget {
  const CoralHeader({
    super.key,
    required this.title,
    this.icon,
    this.onBack,
    this.showMail = true,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onBack;
  final bool showMail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.headerCoral,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  tooltip: 'Voltar',
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: onBack,
                )
              else
                const SizedBox(width: 16),
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showMail)
                IconButton(
                  tooltip: 'Mensagens',
                  icon: const Icon(Icons.mail_outline, color: Colors.white),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As mensagens chegam numa próxima versão.')),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cartão claro arredondado usado nas listas e no menu do evento.
class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      elevation: 1.5,
      shadowColor: const Color(0x33000000),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Título de seção ("Categorias", "Principais", "Dicas"...).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.color = AppColors.text});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Botão "+" amarelo das listas (tarefas, orçamento).
class AddFab extends StatelessWidget {
  const AddFab({super.key, required this.onPressed, required this.tooltip});

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tooltip,
      tooltip: tooltip,
      onPressed: onPressed,
      backgroundColor: AppColors.pending,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 34),
    );
  }
}

/// Mostra a confirmação coral do estudo de usabilidade ("Não" / "SIM").
/// Devolve true só quando a pessoa toca em SIM.
Future<bool> showConfirmDialog(BuildContext context, String message) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: AppColors.headerCoral,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(foregroundColor: AppColors.text),
                    child: const Text('Não'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pending,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('SIM'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

/// Texto "Faltam X dias!" do layout.
String daysLeftLabel(DateTime date) {
  final days = daysUntil(date);
  if (days > 1) return 'Faltam $days dias!';
  if (days == 1) return 'É amanhã!';
  if (days == 0) return 'É hoje!';
  return 'Já aconteceu';
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
