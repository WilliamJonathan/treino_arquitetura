---
name: arquitetura-empresa
description: >-
  Mantém e cria features Flutter no padrão da empresa (Page, Store, Interface,
  Service, Model com Provider, GenericStates e ResultState). Use ao criar
  telas, CRUD, serviços HTTP/SQLite, ou ao editar pastas em lib/app/pages/.
---

# Arquitetura da empresa

## Padrão obrigatório

Espelhe `lib/app/pages/exemplo/`. Não introduza repository, usecase, BLoC, GetX ou outras camadas.

```
lib/app/pages/<feature>/
  <feature>_page.dart
  models/<nome>_model.dart
  interfaces/i_<nome>_services.dart
  services/<nome>_services.dart
  stores/<feature>_page_store.dart
```

## Checklist ao criar feature

1. Model com `fromJson`, `toJson`, `copyWith`
2. Interface abstrata com métodos retornando `ResultState<T>`
3. Service singleton (`_internal`, `factory`, `instance`)
4. Store `extends ChangeNotifier` com getter/setter de `GenericStates` + `notifyListeners`
5. Page com `Consumer` / `Provider.of` e tratamento de `Loading` / `Error` / `Success` / `Empty`
6. Registrar `ChangeNotifierProvider` em `main.dart`
7. Registrar rota em `app_routes.dart`

## Service

```dart
result.fold(
  onSuccess: (data) { ... },
  onError: (message) { ... },
  onEmpty: () { ... },
);
```

Retorne `SuccessResultState`, `ErrorResultState` ou `EmptyResultState`.

## Store

```dart
state = LoadingGenericState();
final result = await _services.index();
result.fold(
  onSuccess: (data) => state = SuccessGenericState(data: data),
  onError: (message) => state = ErrorGenericState(message: message),
  onEmpty: () => state = EmptyGenericState(),
);
```

## Exceções pedagógicas

Ver [ROTEIRO_ESTUDOS.md](../../../ROTEIRO_ESTUDOS.md).

- **Calculadora**: só Page + `setState` (treino de layout)
- **Consultar CEP**: service com `TODO(estagiário)` — não complete sem pedido
- **Clientes**: Service/Model prontos; Store + Page com `TODO(estagiário)` — não complete sem pedido
- Gabarito mentor: `docs/gabarito/cliente/`

## UI

Material 3, componentes simples, textos claros. Evite abstrações de design system novas.
