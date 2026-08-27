# AGENTS.md — Treino de Arquitetura Flutter

App de estudos para estagiários. Ensina Flutter básico e a arquitetura usada na empresa.

## Arquitetura obrigatória (não inventar padrões)

Cada feature em `lib/app/pages/<feature>/` segue o espelho de `exemplo/`:

```
<feature>/
  <feature>_page.dart          # UI (StatefulWidget + Consumer)
  models/<feature>_model.dart  # fromJson / toJson / copyWith
  interfaces/i_<feature>_services.dart
  services/<feature>_services.dart   # singleton + ResultState
  stores/<feature>_page_store.dart   # ChangeNotifier + GenericStates
```

Fluxo: **Page → Store → Interface/Service → Model**

- Store usa `GenericStates` (`Empty`, `Loading`, `Error`, `Success`)
- Service retorna `ResultState` e usa `.fold(onSuccess, onError, onEmpty)`
- Service é singleton (`instance` / `factory`)
- Provider registrado em `main.dart` via `ChangeNotifierProvider`
- Rota em `app_routes.dart`

Referência canônica: `lib/app/pages/exemplo/`

## Desafios do app

| Ordem | Tela | O que o estagiário faz |
|-------|------|-------------------------|
| 01 | Calculadora | Layout com Column/Row + setState (sem Store/Service) |
| 02 | Consultar CEP | Implementar só `ConsultarCepServices` com `http` (ViaCEP) |
| 03 | Clientes | Estudar CRUD completo com fake API SQLite |
| REF | Exemplo | Pasta modelo da arquitetura |

## Regras para o agente

1. **Não mudar a arquitetura** nem criar camadas novas (repository, usecase, bloc, etc.).
2. Novas features devem copiar a estrutura de `exemplo/`.
3. UI simples e legível para júnior: Material 3, widgets padrão, poucos componentes custom.
4. Comentários `TODO(estagiário)` marcam o que o aluno deve completar.
5. Dependências já previstas: `provider`, `http`, `sqflite` / `sqflite_common_ffi`, `shimmer`.

## Comandos úteis

```bash
flutter pub get
flutter run -d windows
flutter analyze
```
