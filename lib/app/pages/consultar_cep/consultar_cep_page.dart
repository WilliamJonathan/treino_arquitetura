import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/models/endereco_model.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/stores/consultar_cep_page_store.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

class ConsultarCepPage extends StatefulWidget {
  const ConsultarCepPage({super.key});

  @override
  State<ConsultarCepPage> createState() => _ConsultarCepPageState();
}

class _ConsultarCepPageState extends State<ConsultarCepPage> {
  final _cepController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  void _consultar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    Provider.of<ConsultarCepPageStore>(context, listen: false)
        .buscarPorCep(_cepController.text);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Consultar CEP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.35),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Implemente apenas ConsultarCepServices.buscarPorCep usando o pacote http. '
                    'Page e Store já estão prontas no padrão da empresa.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                    hintText: '00000000',
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final cep = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                    if (cep.length != 8) {
                      return 'Informe um CEP com 8 dígitos';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _consultar(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _consultar,
                icon: const Icon(Icons.search),
                label: const Text('Buscar endereço'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<ConsultarCepPageStore>(
                  builder: (context, store, child) {
                    if (store.state is EmptyGenericState) {
                      return Center(
                        child: Text(
                          'Digite um CEP para consultar',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.outline,
                              ),
                        ),
                      );
                    }

                    if (store.state is LoadingGenericState) {
                      return Shimmer.fromColors(
                        baseColor: colorScheme.surfaceContainerHighest,
                        highlightColor: colorScheme.surface,
                        child: Column(
                          children: List.generate(
                            4,
                            (_) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (store.state is ErrorGenericState) {
                      final message = (store.state as ErrorGenericState).message;
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ],
                        ),
                      );
                    }

                    if (store.state is SuccessGenericState) {
                      final endereco =
                          (store.state as SuccessGenericState).data as EnderecoModel;
                      return _EnderecoResultado(endereco: endereco);
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

class _EnderecoResultado extends StatelessWidget {
  const _EnderecoResultado({required this.endereco});

  final EnderecoModel endereco;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _LinhaInfo(label: 'CEP', valor: endereco.cep),
        _LinhaInfo(label: 'Logradouro', valor: endereco.logradouro),
        _LinhaInfo(label: 'Complemento', valor: endereco.complemento),
        _LinhaInfo(label: 'Bairro', valor: endereco.bairro),
        _LinhaInfo(label: 'Cidade', valor: endereco.localidade),
        _LinhaInfo(label: 'UF', valor: endereco.uf),
      ],
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({required this.label, required this.valor});

  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label, style: Theme.of(context).textTheme.labelMedium),
        subtitle: Text(
          valor.isEmpty ? '—' : valor,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
