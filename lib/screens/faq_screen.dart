/**
 * @project Party Planner
 * @module Dúvidas frequentes
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

// lib/screens/faq_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

const _faq = [
  (
    'Como convido as pessoas?',
    'No menu do evento, abra Convidados e toque em "Gerar e Copiar Link de Convite". Envie o link por WhatsApp ou e-mail.'
  ),
  (
    'O convidado pode levar acompanhante?',
    'Sim, se você permitir acompanhantes (+1) ao criar o evento. O convidado informa quantos vai levar ao confirmar presença.'
  ),
  (
    'Como os convidados escolhem o que levar?',
    'Ao criar o evento você define se há uma lista pronta, se o convidado escolhe livremente ou se ninguém precisa levar nada.'
  ),
  (
    'Para que servem as cores das tarefas?',
    'Vermelho é urgente, amarelo é pendente e verde é concluída. Use os botões do topo para filtrar.'
  ),
  (
    'Meus dados ficam salvos?',
    'Ainda não. Esta é uma versão de demonstração e os dados ficam só na memória até a página ser recarregada.'
  ),
];

/// Tela Dúvidas frequentes.
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.peach,
      body: InnerBackground(
        child: Column(
          children: [
            CoralHeader(
              title: 'Dúvidas frequentes',
              icon: Icons.help_outline,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  for (final (question, answer) in _faq)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        padding: EdgeInsets.zero,
                        child: ExpansionTile(
                          shape: const Border(),
                          collapsedShape: const Border(),
                          iconColor: AppColors.headerCoral,
                          collapsedIconColor: AppColors.headerCoral,
                          title: Text(
                            question,
                            style: const TextStyle(color: AppColors.headerCoral, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: [
                            Text(answer, style: const TextStyle(color: AppColors.text, height: 1.4)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
