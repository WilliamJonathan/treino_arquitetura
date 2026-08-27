import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Treino de Arquitetura'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.school_outlined, color: colorScheme.primary),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Escolha um desafio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cada tela treina um conceito diferente. Siga a ordem sugerida.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                _DesafioCard(
                  ordem: '01',
                  titulo: 'Calculadora',
                  descricao:
                      'Monte uma calculadora com Column, Row e um display. Foque só em layout e estado local.',
                  icone: Icons.calculate_outlined,
                  cor: colorScheme.primary,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.calculadoraPage),
                ),
                const SizedBox(height: 12),
                _DesafioCard(
                  ordem: '02',
                  titulo: 'Consultar CEP',
                  descricao:
                      'Estrutura pronta no padrão da empresa. Implemente a camada de serviço consumindo a API ViaCEP com http.',
                  icone: Icons.location_on_outlined,
                  cor: colorScheme.tertiary,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.consultarCepPage),
                ),
                const SizedBox(height: 12),
                _DesafioCard(
                  ordem: '03',
                  titulo: 'Cadastro de Clientes',
                  descricao:
                      'CRUD completo (listar, criar, editar, excluir) seguindo a arquitetura, com fake API em SQLite.',
                  icone: Icons.people_outline,
                  cor: colorScheme.secondary,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.clientePage),
                ),
                const SizedBox(height: 12),
                _DesafioCard(
                  ordem: 'REF',
                  titulo: 'Exemplo (referência)',
                  descricao:
                      'Pasta modelo da arquitetura: Page → Store → Interface → Service → Model.',
                  icone: Icons.menu_book_outlined,
                  cor: colorScheme.outline,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.exemploPage),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesafioCard extends StatelessWidget {
  const _DesafioCard({
    required this.ordem,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.onTap,
  });

  final String ordem;
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: cor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ordem,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: cor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            titulo,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      descricao,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
