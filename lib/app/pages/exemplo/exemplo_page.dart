import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:treino_arquitetura/app/pages/exemplo/models/exemplo_model.dart';
import 'package:treino_arquitetura/app/pages/exemplo/stores/exemplo_page_store.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

/// Página de referência com CRUD em memória.
///
/// Use como base para a tela de Clientes (desafio 03):
/// form de cadastro, lista e exclusão — mesmos GenericStates / Consumer.
class ExemploPage extends StatefulWidget {
  const ExemploPage({super.key});

  @override
  State<ExemploPage> createState() => _ExemploPageState();
}

class _ExemploPageState extends State<ExemploPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExemploPageStore>(context, listen: false).index();
    });
  }

  Future<void> _abrirFormulario({ExemploModel? item}) async {
    final tituloController = TextEditingController(text: item?.titulo ?? '');
    final descricaoController = TextEditingController(text: item?.descricao ?? '');
    final formKey = GlobalKey<FormState>();
    final isEdicao = item != null;

    final salvou = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEdicao ? 'Editar item' : 'Novo item',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tituloController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descricaoController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    Navigator.pop(sheetContext, true);
                  },
                  child: Text(isEdicao ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (salvou != true || !mounted) {
      tituloController.dispose();
      descricaoController.dispose();
      return;
    }

    final store = Provider.of<ExemploPageStore>(context, listen: false);
    final model = ExemploModel(
      id: item?.id ?? 0,
      titulo: tituloController.text,
      descricao: descricaoController.text,
    );

    tituloController.dispose();
    descricaoController.dispose();

    final ok = isEdicao ? await store.update(model) : await store.store(model);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(store.mensagemAcao ?? (ok ? 'OK' : 'Erro')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmarExclusao(ExemploModel item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir item'),
          content: Text('Deseja excluir "${item.titulo}"?'),
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

    final store = Provider.of<ExemploPageStore>(context, listen: false);
    final ok = await store.destroy(item.id);
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
      appBar: AppBar(title: const Text('Exemplo — CRUD em memória')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Card(
              color: colorScheme.primaryContainer.withValues(alpha: 0.35),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Referência completa: Page + Store + Service em memória. '
                  'Use este fluxo como base para o desafio de Clientes (SQLite).',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ExemploPageStore>(
              builder: (context, store, child) {
                if (store.state is LoadingGenericState) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Shimmer.fromColors(
                      baseColor: colorScheme.surfaceContainerHighest,
                      highlightColor: colorScheme.surface,
                      child: ListView.separated(
                        itemCount: 5,
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
                          Icon(Icons.inbox_outlined, size: 64, color: colorScheme.outline),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhum item cadastrado',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toque em Novo para cadastrar o primeiro.',
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
                  final itens =
                      (store.state as SuccessGenericState).data as List<ExemploModel>;

                  return RefreshIndicator(
                    onRefresh: store.index,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      itemCount: itens.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                              child: Text('${item.id}'),
                            ),
                            title: Text(item.titulo),
                            subtitle: Text(item.descricao),
                            trailing: IconButton(
                              tooltip: 'Excluir',
                              icon: Icon(Icons.delete_outline, color: colorScheme.error),
                              onPressed: () => _confirmarExclusao(item),
                            ),
                            onTap: () => _abrirFormulario(item: item),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
