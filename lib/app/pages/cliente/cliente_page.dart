import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
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

  final nomeController = TextEditingController();
  final apelidoController = TextEditingController();
  final cpfController = TextEditingController();


  
  

 Future<void> _abrirFormulario({ClienteModel? cliente}) async {
  final bool edicao = cliente != null;

  if (edicao) {
    nomeController.text = cliente.nome;
    apelidoController.text = cliente.apelido;
    cpfController.text = cliente.cpf;
  } else {
    nomeController.clear();
    apelidoController.clear();
    cpfController.clear();
  }

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          edicao ? 'Editar Cliente' : 'Novo Cliente',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: apelidoController,
              decoration: const InputDecoration(
                labelText: 'Apelido',
              ),
            ),
            TextField(
              controller: cpfController,
              keyboardType: TextInputType.number,
              inputFormatters:[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                labelText: 'CPF',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final clienteFormulario = ClienteModel(
                id: edicao ? cliente.id : 0,
                nome: nomeController.text,
                apelido: apelidoController.text,
                cpf: cpfController.text,
              );

              final store = Provider.of<ClientePageStore>(
                context,
                listen: false,
              );

              if (edicao) {
                final sucesso = await store.update(clienteFormulario);
                if (context.mounted) {
                  if (sucesso) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.mensagemAcao),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } else {
                final sucesso = await store.store(clienteFormulario);

                if (context.mounted) {
                  if (sucesso) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.mensagemAcao),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}

  String formatarCpf(String cpf) {
    if (cpf.length != 11) {
      return cpf; // Retorna o CPF sem formatação se não tiver 11 dígitos
    }
    final parte1 = cpf.substring(0, 3);
    final parte2 = cpf.substring(3, 6);
    final parte3 = cpf.substring(6, 9);
    final parte4 = cpf.substring(9, 11);
    return '$parte1.$parte2.$parte3-$parte4';
  }

  @override
  void initState() {
    super.initState();
    // TODO(estagiário): após o primeiro frame, chamar
    // Provider.of<ClientePageStore>(context, listen: false).index();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientePageStore>(context, listen: false).index();
    });
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
              FloatingActionButton.extended(
                onPressed: () {
                  _abrirFormulario();
                },
                label: const Text('Novo Cliente',
                style: TextStyle(color: Color.fromARGB(255, 112, 207, 3))),
                icon: const Icon(Icons.add, color: Color.fromARGB(255, 112, 207, 3)),
                backgroundColor: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<ClientePageStore>(
                  builder: (context, store, child) {
                    // TODO(estagiário): tratar GenericStates como em consultar_cep_page.dart
                    // - LoadingGenericState → indicador / shimmer
                    if (store.state is LoadingGenericState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // - ErrorGenericState → mensagem + botão tentar de novo
                    if (store.state is ErrorGenericState){
                      final state = store.state as ErrorGenericState;
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                store.index();
                              },
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }
                    // - EmptyGenericState → "nenhum cliente"
                    if(store.state is EmptyGenericState){
                      return const Center(
                        child: Text('Nenhum cliente encontrado'),
                      );
                    }
                    // - SuccessGenericState → ListView de ClienteModel
                    if (store.state is SuccessGenericState) {
                      final state = store.state as SuccessGenericState;

                      final clientes = state.data;

                      return ListView.builder(
                        itemCount: clientes.length,
                        itemBuilder: (context, index){
                          final cliente = clientes[index];

                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(cliente.id.toString()),
                            ),
                            title: Text(cliente.nome),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cliente.apelido),
                                Text('CPF: ${formatarCpf(cliente.cpf)}'),
                              ],
                            ),
                            

                            onTap: () {
                              _abrirFormulario(cliente: cliente);
                            },

                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                               color: Colors.red ),
                              onPressed: () async{
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: const Text('Excluir Cliente'),
                                      content: const Text('Tem certeza que deseja excluir este cliente?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  }
                                );
                                if (confirmar == true){
                                  final store = Provider.of<ClientePageStore>(
                                    context,
                                    listen: false,
                                  );
                                  await store.destroy(cliente.id);
                                }
                              }
                            )
                          );
                        });
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
