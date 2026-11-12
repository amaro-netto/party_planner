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
import 'package:party_planner/screens/home_tab.dart';
import 'package:party_planner/services/app_session.dart';
import 'package:party_planner/theme/app_theme.dart';
import 'package:party_planner/widgets/inner_layout.dart';

/// Categoria de fornecedor.
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
  });

  final String name;
  final SupplierCategory category;
  final double distanceKm;
  final String description;
}

const _comida = SupplierCategory('Comida', Icons.restaurant_outlined);
const _fotos = SupplierCategory('Fotos', Icons.photo_camera_outlined);
const _som = SupplierCategory('Som', Icons.speaker_outlined);
const _decoracao = SupplierCategory('Decoração', Icons.local_florist_outlined);
const _doces = SupplierCategory('Doces', Icons.cake_outlined);

const supplierCategories = [_comida, _fotos, _som, _decoracao, _doces];

const mockSuppliers = [
  Supplier(
    name: 'Sabor & Arte Buffet',
    category: _comida,
    distanceKm: 1.8,
    description: 'Salgados, pratos quentes e garçons. Atende de 30 a 150 pessoas.',
  ),
  Supplier(
    name: 'Ateliê das Flores',
    category: _decoracao,
    distanceKm: 3,
    description: 'Arranjos de mesa, painéis e decoração por tema.',
  ),
  Supplier(
    name: 'Lente Mágica',
    category: _fotos,
    distanceKm: 4.5,
    description: 'Fotos e vídeo do evento, com galeria online em até uma semana.',
  ),
  Supplier(
    name: 'Som na Caixa',
    category: _som,
    distanceKm: 6,
    description: 'DJ, caixas de som e luzes. A seleção de músicas é combinada antes.',
  ),
  Supplier(
    name: 'Açúcar Mascavo Confeitaria',
    category: _doces,
    distanceKm: 2.4,
    description: 'Bolos decorados, docinhos e mesa de sobremesas.',
  ),
];

String distanceLabel(double km) =>
    'a ${km.toStringAsFixed(km.truncateToDouble() == km ? 0 : 1).replaceAll('.', ',')} km';

/// Aba Fornecedores: filtro por categoria e lista.
class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  SupplierCategory? _category;

  void _openSupplier(Supplier supplier) {
    showPartySheet<void>(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(supplier.category.icon, color: AppColors.coral),
              const SizedBox(width: 8),
              Text(
                '${supplier.category.name} · ${distanceLabel(supplier.distanceKm)}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            supplier.name,
            style: const TextStyle(color: AppColors.ground, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(supplier.description, style: const TextStyle(color: Colors.black87, height: 1.5)),
          const SizedBox(height: 16),
          const Text(
            'Fornecedor de exemplo. O contato pelo app chega numa próxima versão.',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = _category == null
        ? mockSuppliers
        : mockSuppliers.where((s) => s.category == _category).toList();

    return PartyPage(
      title: 'Fornecedores',
      onBack: () => AppSession.instance.goTo(AppTab.inicio),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final category in supplierCategories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = _category == category ? null : category),
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.ground,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      avatar: Icon(
                        category.icon,
                        size: 18,
                        color: _category == category ? Colors.white : AppColors.ground,
                      ),
                      label: Text(
                        category.name,
                        style: TextStyle(
                          color: _category == category ? Colors.white : AppColors.ground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, kBottomBarSpace),
              children: [
                for (final supplier in suppliers)
                  PillRow(
                    icon: supplier.category.icon,
                    label: supplier.name,
                    subtitle: '${supplier.category.name} · ${distanceLabel(supplier.distanceKm)}',
                    onTap: () => _openSupplier(supplier),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
