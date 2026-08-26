import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app/pages/exemplo/exemplo_page.dart';
import 'package:treino_arquitetura/app/pages/home/home_page.dart';

class AppRoutes {
  // ── Rotas de autenticação ─────────────────────────────────────────────────
  static const String loginPage = '/login';

  // ── Rotas principais ──────────────────────────────────────────────────────
  static const String homePage = '/';

  // ── Rotas de funcionalidades ──────────────────────────────────────────────
  static const String exemploPage = '/exemplo';

  static const String inativoPage = '/inativo';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Home ──────────────────────────────────────────────────────────────
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case exemploPage:
        return MaterialPageRoute(builder: (_) => const ExemploPage());

      // ── Conta inativa ─────────────────────────────────────────────────────
      case inativoPage:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Conta Inativa')),
            body: const Center(
              child: Text(
                'Sua conta está inativa.\nEntre em contato com o suporte.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

      // ── Rota não encontrada ───────────────────────────────────────────────
      default:
        return MaterialPageRoute(
          builder: (_) => const _TelaRotaNaoEncontrada(),
        );
    }
  }
}

/// Tela exibida quando uma rota desconhecida é solicitada.
class _TelaRotaNaoEncontrada extends StatelessWidget {
  const _TelaRotaNaoEncontrada();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: const Center(child: Text('404 — Esta página não existe.')),
    );
  }
}

// Mantido por compatibilidade com código legado que importava NotFoundScreen
typedef NotFoundScreen = _TelaRotaNaoEncontrada;
