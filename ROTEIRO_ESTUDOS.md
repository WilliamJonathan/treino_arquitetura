# Roteiro de estudos — Treino de Arquitetura

Siga a ordem. Cada desafio aumenta a complexidade.

---

## Git — obrigatório em todo desafio

Antes de codar cada desafio, crie uma **branch** no formato:

```text
seu-nome+nome-do-desafio
```

Exemplos de nome: `jonathan+calculadora`, `jonathan+consultar-cep`, `jonathan+clientes`

### Comandos (fluxo completo)

**1. Atualizar a `main` antes de começar**

```bash
git checkout main
git pull origin main
```

**2. Criar a branch do desafio**

```bash
git checkout -b seu-nome+calculadora
```

Troque o nome conforme o desafio:

```bash
git checkout -b seu-nome+consultar-cep
git checkout -b seu-nome+clientes
```

**3. Ver o que mudou e preparar o commit**

```bash
git status
git diff
git add .
```

(Se quiser adicionar só alguns arquivos: `git add caminho/do/arquivo.dart`)

**4. Commitar**

```bash
git commit -m "feat(calculadora): implementa teclado e operações básicas"
```

Outros exemplos de mensagem:

```bash
git commit -m "feat(cep): implementa ConsultarCepServices com http"
git commit -m "feat(clientes): implementa Store e Page do CRUD"
```

**5. Enviar a branch para o remoto**

Na primeira vez da branch:

```bash
git push -u origin HEAD
```

Nos próximos pushes da mesma branch:

```bash
git push
```

**6. Ao terminar o desafio**

Abra um Pull Request no GitHub/GitLab **ou** avise o mentor com o nome da branch.

**7. Começar o próximo desafio**

```bash
git checkout main
git pull origin main
git checkout -b seu-nome+consultar-cep
```

### Regras

1. **Uma branch por desafio** (não misture desafios na mesma branch)
2. Faça commits pequenos e claros **nessa branch**
3. Não commite direto na `main`
4. Se der conflito, peça ajuda ao mentor antes de forçar push

---

## Antes de começar

1. Rode o app: `flutter pub get` e `flutter run`
2. Abra **Exemplo (REF)** no app e no código: `lib/app/pages/exemplo/`
3. Cadastre, edite e exclua itens — é um CRUD **em memória** completo
4. Entenda o fluxo:

```
Page  →  Store  →  Service (via Interface)  →  dados
 UI       estado      lista em memória           Model
```

- `GenericStates` na Store: Empty / Loading / Error / Success  
- `ResultState` no Service: Success / Error / Empty + `.fold(...)`  
- Service é **singleton** (`instance`)
- Depois de `store` / `update` / `destroy`, a Store chama `index()` de novo

No desafio de **Clientes**, o padrão da Page/Store é o mesmo; só o Service muda (SQLite em vez de lista em memória).

---

## Desafio 01 — Calculadora (Flutter básico)

**Objetivo:** layout e estado local.

| Item | Detalhe |
|------|---------|
| Pasta | `lib/app/pages/calculadora/` |
| O que já existe | Página com display placeholder e instruções |
| O que você faz | Montar teclado (Column + Rows), display e lógica com `setState` |
| O que **não** fazer | Store, Service, Provider |

**Critério de pronto:** números 0–9, + − × ÷, limpar e igual funcionando.

---

## Desafio 02 — Consultar CEP (camada de Service + HTTP)

**Objetivo:** consumir API real com `http`, sem mudar a arquitetura.

| Item | Detalhe |
|------|---------|
| Pasta | `lib/app/pages/consultar_cep/` |
| O que já existe | Model, Interface, Store, Page, rota e Provider |
| O que você faz | Só `services/consultar_cep_services.dart` → método `buscarPorCep` |
| API | `GET https://viacep.com.br/ws/{cep}/json/` |

**Critério de pronto:** digitar CEP, ver loading, endereço na tela (ou erro claro se CEP inválido).

**Dica:** trate `"erro": true` no JSON da ViaCEP como `ErrorResultState`.

---

## Desafio 03 — Clientes (CRUD completo na arquitetura)

**Objetivo:** implementar **Store + Page** consumindo uma fake API já pronta.

| Item | Detalhe |
|------|---------|
| Pasta | `lib/app/pages/cliente/` |
| Pronto (não reescrever) | `models/`, `interfaces/`, `services/` (SQLite = fake API) |
| O que você faz | `stores/cliente_page_store.dart` e `cliente_page.dart` |

### Tarefas da Store
1. `index()` — listar (Loading → Success / Empty / Error)
2. `store()` — criar e depois recarregar a lista
3. `update()` — editar e recarregar
4. `destroy()` — excluir e recarregar

Espelhe `exemplo_page_store.dart` e `consultar_cep_page_store.dart`.

### Tarefas da Page
1. Chamar `index()` no `initState` (via `addPostFrameCallback`)
2. `Consumer` tratando Loading / Error / Empty / Success
3. Lista de clientes
4. Formulário para criar/editar (`nome`, `apelido`)
5. Excluir com confirmação

**Critério de pronto:** CRUD funcionando de ponta a ponta (criar, listar, editar, excluir).

**Gabarito (só depois de tentar):** `docs/gabarito/cliente/`

---

## Resumo: quem implementa o quê?

| Camada | Calculadora | CEP | Clientes |
|--------|-------------|-----|----------|
| Page | você | pronta | **você** |
| Store | — | pronta | **você** |
| Service | — | **você** | pronta (fake API) |
| Model / Interface | — | prontos | prontos |

---

## Checklist final do estagiário

- [ ] Branch `nome+desafio` criada para cada desafio
- [ ] Commits feitos na branch correta e enviados (`git push`)
- [ ] Calculadora operacional
- [ ] CEP consulta ViaCEP via Service
- [ ] Clientes: Store + Page com CRUD
- [ ] Consigo explicar Page → Store → Service em voz alta
- [ ] Não inventei camadas fora do padrão da empresa
