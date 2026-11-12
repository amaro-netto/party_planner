/**
 * @project Party Planner
 * @module Fornecedores
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

// lib/screens/suppliers_screen.dart
import 'package:flutter/material.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Categoria de fornecedor (ícone e nome).
class SupplierCategory {
  const SupplierCategory(this.name, this.icon);

  final String name;
  final IconData icon;
}

/// Fornecedor de exemplo (dados simulados até existir backend).
class Supplier {
  const Supplier({
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.description,
    required this.color,
  });

  final String name;
  final SupplierCategory category;
  final double distanceKm;
  final String description;
  final Color color;
}

const _buffet = SupplierCategory('Buffet', Icons.room_service_outlined);
const _foto = SupplierCategory('Foto & Vídeo', Icons.photo_camera_outlined);
const _musica = SupplierCategory('Música', Icons.music_note_outlined);
const _decoracao = SupplierCategory('Decoração', Icons.celebration_outlined);
const _doces = SupplierCategory('Bolos & Doces', Icons.cake_outlined);

const supplierCategories = [_buffet, _foto, _musica, _decoracao, _doces];

const mockSuppliers = [
  Supplier(
    name: 'Buffet da Mama',
    category: _buffet,
    distanceKm: 2,
    description: 'Salgados, pratos quentes e equipe de garçons para até 150 pessoas.',
    color: Color(0xFF8D6E63),
  ),
  Supplier(
    name: 'Flores para Festa',
    category: _decoracao,
    distanceKm: 2,
    description: 'Arranjos de mesa, arcos de flores e decoração temática.',
    color: Color(0xFFD81B60),
  ),
  Supplier(
    name: 'Clique Feliz',
    category: _foto,
    distanceKm: 4.5,
    description: 'Fotografia e vídeo do evento, com álbum digital em até 7 dias.',
    color: Color(0xFF455A64),
  ),
  Supplier(
    name: 'DJ Batida Certa',
    category: _musica,
    distanceKm: 6,
    description: 'Som, iluminação e playlist montada junto com o anfitrião.',
    color: Color(0xFF5E35B1),
  ),
  Supplier(
    name: 'Doce Encanto',
    category: _doces,
    distanceKm: 3.2,
    description: 'Bolos decorados, docinhos finos e mesa de sobremesas.',
    color: Color(0xFFF06292),
  ),
];

String _distance(double km) =>
    '${km.toStringAsFixed(km.truncateToDouble() == km ? 0 : 1).replaceAll('.', ',')}km de distância';

/// Aba Fornecedores: banner, categorias e lista dos principais.
class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  SupplierCategory? _category;

  void _openSupplier(Supplier supplier) {
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
            Row(
              children: [
                Icon(supplier.category.icon, color: AppColors.headerCoral),
                const SizedBox(width: 8),
                Text(supplier.category.name, style: const TextStyle(color: AppColors.textSoft)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              supplier.name,
              style: const TextStyle(color: AppColors.headerCoral, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(_distance(supplier.distanceKm), style: const TextStyle(color: AppColors.textSoft)),
            const SizedBox(height: 14),
            Text(supplier.description, style: const TextStyle(color: AppColors.text, height: 1.4)),
            const SizedBox(height: 18),
            const Text(
              'O contato direto com o fornecedor chega numa próxima versão.',
              style: TextStyle(color: AppColors.textSoft, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = _category == null
        ? mockSuppliers
        : mockSuppliers.where((s) => s.category == _category).toList();

    return InnerBackground(
      child: Column(
        children: [
          CoralHeader(
            title: 'Fornecedor',
            icon: Icons.storefront_outlined,
            onBack: () => AppSession.instance.goTo(AppTab.inicio),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                const _Banner(),
                const SectionTitle('Categorias'),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: supplierCategories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = supplierCategories[index];
                      final selected = category == _category;
                      return SizedBox(
                        width: 84,
                        child: SoftCard(
                          padding: const EdgeInsets.all(8),
                          onTap: () => setState(() => _category = selected ? null : category),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(category.icon,
                                  size: 32, color: selected ? AppColors.pending : AppColors.headerCoral),
                              const SizedBox(height: 6),
                              Text(
                                category.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.headerCoral,
                                  fontSize: 11,
                                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SectionTitle(_category == null ? 'Principais' : _category!.name),
                for (final supplier in suppliers) ...[
                  _SupplierCard(supplier: supplier, onTap: () => _openSupplier(supplier)),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFF6B21A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Icon(Icons.handshake_outlined, size: 76, color: Colors.white, semanticLabel: 'Aperto de mãos'),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Encontre os melhores fornecedores para sua festa',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier, required this.onTap});

  final Supplier supplier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 64,
            color: supplier.color,
            child: Icon(supplier.category.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.name,
                  style: const TextStyle(color: AppColors.headerCoral, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _distance(supplier.distanceKm),
                  style: const TextStyle(color: AppColors.textSoft, fontSize: 12),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.chevron_right, color: AppColors.headerCoral),
          ),
        ],
      ),
    );
  }
}
