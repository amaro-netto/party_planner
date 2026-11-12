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
    'Na página do evento, abra "Convidados e convite" e toque em "Gerar e Copiar Link de Convite". Depois é só colar o link no WhatsApp ou no e-mail.'
  ),
  (
    'O convidado pode levar acompanhante?',
    'Sim, se você permitir acompanhantes (+1) ao criar o evento. O convidado diz quantos vai levar quando confirma presença.'
  ),
  (
    'Como os convidados escolhem o que levar?',
    'Ao criar o evento você escolhe se há uma lista pronta, se cada convidado escolhe livremente ou se ninguém precisa levar nada.'
  ),
  (
    'O que significam as cores das tarefas?',
    'Coral é urgente, laranja é a fazer e verde é feita. Os botões no topo filtram a lista.'
  ),
  (
    'Meus dados ficam salvos?',
    'Ainda não. Esta é uma versão de demonstração e os dados ficam só na memória até a página ser recarregada.'
  ),
];

/// Dúvidas frequentes.
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PartyPage(
        title: 'Dúvidas',
        onBack: () => Navigator.of(context).pop(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (final (question, answer) in _faq)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  iconColor: AppColors.coral,
                  collapsedIconColor: AppColors.coral,
                  title: Text(
                    question,
                    style: const TextStyle(color: AppColors.ground, fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(answer, style: const TextStyle(color: Colors.black87, height: 1.4)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
