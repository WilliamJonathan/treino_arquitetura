import 'dart:convert';

import 'package:treino_arquitetura/app/pages/consultar_cep/interfaces/i_consultar_cep_services.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/models/endereco_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';
import 'package:http/http.dart' as http;

/// Desafio 02 — implementar consumo HTTP da ViaCEP.
///
/// Dicas:
/// 1. Importe `package:http/http.dart` como `http`
/// 2. Faça GET em `https://viacep.com.br/ws/$cep/json/`
/// 3. Remova hífen/espaços do CEP antes de chamar a API
/// 4. Se o JSON vier com `"erro": true`, retorne [ErrorResultState]
/// 5. Em sucesso, use [EnderecoModel.fromJson] e retorne [SuccessResultState]
/// 6. Em falha de rede/parse, retorne [ErrorResultState] com mensagem clara 

  
 

class ConsultarCepServices implements IConsultarCepServices {
  static final ConsultarCepServices _instance = ConsultarCepServices._internal();

  factory ConsultarCepServices() => _instance;

  static ConsultarCepServices get instance => _instance;

  ConsultarCepServices._internal();



  @override
  Future<ResultState<EnderecoModel>> buscarPorCep(String cep) async {
    // TODO(estagiário): implementar chamada HTTP com o pacote `http`
     //variavel cepLimpo para remover caracteres não numéricos do CEP
     final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');
     //variavel response para armazenar a resposta da requisição HTTP
     final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'));
    //verifica se a resposta da requisição HTTP foi bem sucedida
      if(response.statusCode != 200){
        return ErrorResultState(message: 'Erro ao buscar o CEP.');
      }
      //jsonData converte a variavel response.body para um objeto JSON
      final jsonData = json.decode(response.body);
      return SuccessResultState(result: EnderecoModel.fromJson(jsonData));
    }
  }

