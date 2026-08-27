import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treino_arquitetura/app/pages/cliente/stores/cliente_page_store.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

/// Desafio 03 — implemente a Page do CRUD de clientes.
///
/// A fake API já está pronta em `ClienteServices` (SQLite).
/// Espelhe: `consultar_cep_page.dart` (Consumer + GenericStates) e o roteiro.
///
/// Tarefas:
/// 1. No initState, chamar store.index()
/// 2. Consumer com Loading / Error / Empty / Success
/// 3. ListView dos clientes
/// 4. FAB ou botão para criar (nome + apelido)
/// 5. Editar e excluir
class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  @override
  void initState() {
    super.initState();
    // TODO(estagiário): após o primeiro frame, chamar
    // Provider.of<ClientePageStore>(context, listen: false).index();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      // TODO(estagiário): FloatingActionButton para abrir formulário de novo cliente
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.35),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Desafio 03: implemente ClientePageStore e esta Page. '
                    'Model, Interface e ClienteServices (fake API SQLite) já estão prontos. '
                    'Veja ROTEIRO_ESTUDOS.md.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<ClientePageStore>(
                  builder: (context, store, child) {
                    // TODO(estagiário): tratar GenericStates como em consultar_cep_page.dart
                    // - LoadingGenericState → indicador / shimmer
                    // - ErrorGenericState → mensagem + botão tentar de novo
                    // - EmptyGenericState → "nenhum cliente"
                    // - SuccessGenericState → ListView de ClienteModel
                    if (store.state is EmptyGenericState) {
                      return Center(
                        child: Text(
                          'Implemente a Store (index) e a lista aqui',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.outline,
                              ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
