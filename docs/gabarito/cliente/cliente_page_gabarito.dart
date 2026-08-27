import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
import 'package:treino_arquitetura/app/pages/cliente/stores/cliente_page_store.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

/// Gabarito do Desafio 03 — Page.
/// Copie/adapte só depois de tentar sozinho.
///
/// Controllers ficam no widget do bottom sheet (dispose seguro),
/// igual ao padrão corrigido em `exemplo_page.dart`.
class ClientePageGabarito extends StatefulWidget {
  const ClientePageGabarito({super.key});

  @override
  State<ClientePageGabarito> createState() => _ClientePageGabaritoState();
}

class _ClientePageGabaritoState extends State<ClientePageGabarito> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientePageStore>(context, listen: false).index();
    });
  }

  Future<void> _abrirFormulario({ClienteModel? cliente}) async {
    final isEdicao = cliente != null;

    final resultado = await showModalBottomSheet<ClienteModel>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return _ClienteFormSheet(cliente: cliente);
      },
    );

    if (resultado == null || !mounted) return;

    final store = Provider.of<ClientePageStore>(context, listen: false);
    final ok = isEdicao ? await store.update(resultado) : await store.store(resultado);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(store.mensagemAcao ?? (ok ? 'OK' : 'Erro')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmarExclusao(ClienteModel cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir cliente'),
          content: Text('Deseja excluir "${cliente.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    final store = Provider.of<ClientePageStore>(context, listen: false);
    final ok = await store.destroy(cliente.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(store.mensagemAcao ?? (ok ? 'OK' : 'Erro')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: Consumer<ClientePageStore>(
        builder: (context, store, child) {
          if (store.state is LoadingGenericState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Shimmer.fromColors(
                baseColor: colorScheme.surfaceContainerHighest,
                highlightColor: colorScheme.surface,
                child: ListView.separated(
                  itemCount: 6,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, _) => Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            );
          }

          if (store.state is ErrorGenericState) {
            final message = (store.state as ErrorGenericState).message;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: store.index,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (store.state is EmptyGenericState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum cliente cadastrado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque em Novo para criar o primeiro registro.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (store.state is SuccessGenericState) {
            final clientes =
                (store.state as SuccessGenericState).data as List<ClienteModel>;

            return RefreshIndicator(
              onRefresh: store.index,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                itemCount: clientes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.secondaryContainer,
                        foregroundColor: colorScheme.onSecondaryContainer,
                        child: Text(
                          cliente.nome.isNotEmpty
                              ? cliente.nome[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(cliente.nome),
                      subtitle: Text('Apelido: ${cliente.apelido}  ·  #${cliente.id}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'editar') {
                            _abrirFormulario(cliente: cliente);
                          } else if (value == 'excluir') {
                            _confirmarExclusao(cliente);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                        ],
                      ),
                      onTap: () => _abrirFormulario(cliente: cliente),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Formulário do bottom sheet — dono dos controllers (dispose seguro).
class _ClienteFormSheet extends StatefulWidget {
  const _ClienteFormSheet({this.cliente});

  final ClienteModel? cliente;

  @override
  State<_ClienteFormSheet> createState() => _ClienteFormSheetState();
}

class _ClienteFormSheetState extends State<_ClienteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _apelidoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _apelidoController = TextEditingController(text: widget.cliente?.apelido ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(
      context,
      ClienteModel(
        id: widget.cliente?.id ?? 0,
        nome: _nomeController.text,
        apelido: _apelidoController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.cliente != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdicao ? 'Editar cliente' : 'Novo cliente',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _apelidoController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Apelido',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o apelido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _salvar,
              child: Text(isEdicao ? 'Salvar alterações' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
