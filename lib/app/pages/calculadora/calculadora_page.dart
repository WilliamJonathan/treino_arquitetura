import 'package:flutter/material.dart';

/// Desafio 01 — Calculadora
///
/// Objetivo: praticar layout com [Column], [Row] e estado local com [setState].
/// Não use Store/Service aqui — foque só em Flutter básico.
///
/// Tarefas sugeridas:
/// 1. Criar um display no topo mostrando o valor atual
/// 2. Montar o teclado com números 0–9 e as 4 operações (+ − × ÷)
/// 3. Botões de limpar (C) e igual (=)
/// 4. Calcular o resultado ao pressionar =
class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  // TODO(estagiário): variáveis de estado (display, operador, valor anterior…)
  var displayT = '';
  var display = '';
  var operador = '';
  double valor1 = 0.0;
  double valor2 = 0.0;
  double resultado = 0.0;
  
  
  Widget botao(String valor) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        setState(() {
            if (valor == 'C') {
            display = '';
            displayT = '';}
            else if('+-x÷'.contains(valor)){
              valor1 = double.tryParse(display) ?? 0;
              operador = valor;
              display = ''; 
              displayT += valor; 
            } 
            else if (valor == '=') {
              valor2 = double.tryParse(display) ?? 0;
              switch (operador) {
                case '+':
                  resultado = valor1 + valor2;
                  break;
                case '-':
                  resultado = valor1 - valor2;
                  break;
                case 'x':
                  resultado = valor1 * valor2;
                  break;
                case '÷':
                  if (valor2 != 0) {
                    resultado = valor1 / valor2;
                  } else {
                    display = 'Erro';
                    return;
                  }
                  break;
              }
              display = resultado.toString();
            } 
            else {
            displayT += valor;
            display += valor; 
            }

          // adiciona o valor clicado ao display
        });
      },
      child: Text(valor),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desafio de layout',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monte uma calculadora estilo Windows: display + grade de botões '
                        'usando Column e Row. A lógica pode ficar só nesta page com setState.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Display ───────────────────────────────────────────────────
              // TODO(estagiário): substitua este Container pelo display real
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        displayT,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        display,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                  
                ),
              ),
              const SizedBox(height: 16),

              // ── Teclado ───────────────────────────────────────────────────
              // TODO(estagiário): monte as linhas de botões com Row / Column
              // Exemplo de grade sugerida:
              //   C  ÷  ×  −
              //   7  8  9  +
              //   4  5  6
              //   1  2  3  =
              //   0     .

              Row(
                children: [
                  botao('C'),
                  botao('÷'),
                  botao('x'),
                  botao('-'),
                ],
                ),
                Row(
                children: [
                  botao('7'),
                  botao('8'),
                  botao('9'),
                  botao('+'),
                ],
                ),
                 Row(
                children: [
                  botao('4'),
                  botao('5'),
                  botao('6'),
                  botao(''),
                ],
                ),
                 Row(
                children: [
                  botao('1'),
                  botao('2'),
                  botao('3'),
                  botao('.'),
                ],
                ),
                 Row(
                children: [
                  botao('0'),
                  botao('='),
                ],
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
