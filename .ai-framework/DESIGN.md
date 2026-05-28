# Design System

## Direcao Visual

- Projeto usa visual de sistema administrativo simples, limpo, rapido de operar.
- Base visual mistura dois contextos:
  - CRUD interno claro: fundo claro, cards brancos, destaque vinho/vermelho.
  - Dashboard/cardapio escuro: fundo grafite, destaque laranja/ambar.
- Sensacao geral deve remeter a brasa, calor, atendimento rapido e leitura facil.
- Evitar look generico de SaaS azul. Identidade aqui puxa para pedra, brasa, fogo e carne assada.

## Stack de Estilo

- Styling atual usa Tailwind CSS.
- Antes de criar CSS custom, preferir classes utilitarias consistentes com padrao existente.
- Se CSS custom virar necessario, concentrar tokens e estilos base em lugar unico. Nao espalhar overrides soltos.

## Paleta de Cores

### Base clara

- Fundo principal: `bg-stone-50`
- Texto principal: `text-stone-900`
- Borda neutra: `border-stone-200`
- Cabecalho/tabela suave: `bg-stone-100`
- Texto secundario: `text-stone-600` ou `text-stone-500`
- Inputs e bordas sutis: `border-stone-300`

### Base escura

- Fundo principal dashboard: `bg-[#121414]` ou `bg-[#111313]`
- Superficie escura: `bg-stone-900`, `bg-stone-900/70`, `bg-stone-900/80`
- Borda escura: `border-stone-800`
- Texto principal escuro: `text-stone-100`
- Texto secundario escuro: `text-stone-400` ou `text-stone-500`

### Cor de marca e acento

- Primaria CRUD: `bg-red-800`, `text-red-800`, hover `bg-red-900`
- Primaria dashboard: `bg-orange-500`, `text-orange-300`, hover `bg-orange-400`
- Acento secundario dashboard: `bg-amber-300`, `text-amber-200`
- Texto sobre botao quente: `text-stone-950`

### Cores de feedback

- Sucesso claro: `border-emerald-200 bg-emerald-50 text-emerald-800`
- Erro claro: `border-red-200 bg-red-50 text-red-800`
- Badge pronto: `bg-emerald-100 text-emerald-700`
- Badge cancelado: `bg-red-100 text-red-700`
- Badge preparo: `bg-amber-100 text-amber-800`
- Badge confirmado: `bg-blue-100 text-blue-700`
- Badge aberto/default: `bg-slate-100 text-slate-700`

## Regras de Uso de Cor

- CRUD, login, formularios, listagens e telas administrativas comuns: usar tema claro.
- Dashboard inicial, vitrine, cozinha visual e navegacao mobile destacada: podem usar tema escuro.
- Nao misturar vermelho e laranja como primarias na mesma area sem motivo claro.
- Em tela clara, CTA principal deve puxar para vermelho escuro.
- Em tela escura, CTA principal deve puxar para laranja/ambar.
- Verde usar para sucesso e concluido. Vermelho usar para erro, cancelamento ou risco. Ambar usar para preparo/atencao.

## Tipografia

- Sem inventar fonte custom agora. Seguir stack padrao do app via Tailwind.
- Titulos principais:
  - CRUD: `text-2xl` ou `text-3xl` com `font-bold`
  - Dashboard hero: `text-4xl` ou `text-5xl` com `font-bold`
- Subtitulos de secao: `text-lg` ou `text-2xl` com `font-semibold`
- Labels e apoio: `text-sm`
- Microcopy auxiliar: `text-xs` com tracking apenas em labels de resumo ou metricas

## Layout e Estrutura

- Layout padrao app:
  - `body` claro com `bg-stone-50 text-stone-900`
  - header branco com borda inferior `border-stone-200 bg-white`
  - `main` centralizado com `mx-auto max-w-7xl px-5 py-8`
- Conteudo CRUD deve usar largura controlada:
  - formularios pequenos: `max-w-md` ou `max-w-2xl`
  - listagens e dashboards internos: `max-w-7xl`
- Dashboard escuro usa `max-w-6xl`, header fixo e bottom nav fixa.
- Usar grids simples com `gap-4`, `gap-5` ou `gap-6`. Evitar espacamento aleatorio.

## Superficies e Cards

- Card padrao claro: `rounded-lg border bg-white`
- Card claro com destaque leve: adicionar `p-4`, `p-5` ou `p-6`
- Card login: pode usar `shadow-sm`, sempre sutil
- Card dashboard: `rounded-2xl border border-stone-800 bg-stone-900/70` ou `/80`
- Hover no dashboard: preferir mudanca de borda para laranja, nao sombra forte
- Evitar sombras pesadas. Projeto favorece borda, contraste e bloco limpo

## Botoes e CTAs

- Botao principal claro:
  - `rounded-md bg-red-800 px-4 py-2 font-medium text-white hover:bg-red-900`
- Botao principal pedido maior:
  - `rounded-md bg-red-800 px-5 py-2 font-medium text-white hover:bg-red-900`
- Botao secundario claro:
  - `rounded-md border px-4 py-2`
- CTA dashboard:
  - `rounded-xl` ou `rounded-2xl`
  - `bg-orange-500 text-stone-950 hover:bg-orange-400`
- Botoes icone dashboard podem ser circulares ou quadrados com cantos grandes
- Nao criar botao com gradiente, glow forte ou sombra chamativa fora do dashboard

## Formularios

- Todo formulario deve renderizar erros com `shared/_errors` quando usar model validation.
- Labels sempre em portugues e visiveis acima do campo.
- Campos usam:
  - `mt-1`
  - `w-full`
  - `rounded-md`
  - `border-stone-300`
- Agrupar formularios longos em secoes com card branco e titulo:
  - `rounded-lg border bg-white p-5`
- Formularios de cadastro grande usam `space-y-6`
- Formularios simples usam `space-y-4`
- Nao esconder label confiando so em placeholder

## Tabelas e Listagens

- Listagens tabulares usam container:
  - `overflow-x-auto rounded-lg border bg-white`
- Header de tabela:
  - `bg-stone-100`
  - texto alinhado a esquerda
  - tamanho `text-sm`
- Linhas:
  - separacao com `border-t`
  - links principais em `text-red-800`
- Filtros acima da tabela ficam em card branco com borda e `gap-3`

## Badges e Status

- Badge deve ser pequeno, legivel e com `rounded-full px-2 py-1 text-xs`
- Status no CRUD usam helper central para manter cor consistente
- Status no dashboard escuro usam variante com transparencia e `ring`
- Nunca inventar nova cor de status sem atualizar helpers compartilhados

## Navegacao

- Header principal claro:
  - fundo branco
  - links neutros com hover em `bg-stone-100`
  - marca em `text-red-800`
- Acao principal no header: botao vermelho
- Dashboard:
  - header fixo escuro com blur leve
  - bottom nav fixa mobile-first
  - item ativo em `bg-orange-500 text-stone-950`
  - item inativo em `text-stone-400`

## Imagens e Iconografia

- Projeto aceita emoji como recurso visual em dashboard e categorias.
- Em CRUD, preferir texto claro a iconografia excessiva.
- Imagens de produtos no dashboard devem usar `object-cover` e overlay escuro para leitura do texto.
- Se nao houver imagem real, manter placeholder coerente. Nao usar arte aleatoria sem contexto.

## Motion e Interacao

- Animacao deve ser curta e funcional.
- Hover padrao: mudanca de background, borda ou cor. Nada exagerado.
- Dashboard pode usar pequenos efeitos:
  - `transition`
  - `hover:border-orange-400`
  - `hover:rotate-6` em FAB
  - feedback curto de confirmacao
- Evitar animacoes longas, bounce excessivo ou delays que atrapalhem operacao.

## Responsividade

- Pensar mobile primeiro, depois expandir com `sm`, `md`, `lg`.
- Tabelas devem continuar acessiveis com `overflow-x-auto`.
- Formularios longos podem virar grid em `md:grid-cols-2` ou `md:grid-cols-3`.
- Dashboard deve continuar forte em mobile: header fixo, cards largos, bottom nav e CTA flutuante.
- Nao depender de hover para acao essencial.

## Conteudo e Linguagem

- Toda interface em portugues.
- Microcopy curta, direta e operacional.
- Titulos devem dizer exatamente que tela faz: `Pedidos`, `Editar cliente`, `Entrar`, `Configuracoes`.
- Em painel interno, clareza vence marketing.
- Dashboard pode ter tom mais caloroso, mas sem perder objetividade.

## Guard Rails

- Nao usar azul como identidade principal do produto.
- Nao trocar `stone + red/orange/amber` por palette fria ou roxa.
- Nao misturar muitos raios de borda na mesma tela. Claro usa mais `rounded-md` e `rounded-lg`; dashboard usa `rounded-2xl`.
- Nao usar sombras pesadas como base do layout.
- Nao criar telas cheias de componentes diferentes sem necessidade.
- Nao quebrar consistencia entre CRUDs semelhantes.
- Se criar novo helper de estilo de status, manter alinhado com cores ja usadas em `OrdersHelper` e `DashboardHelper`.
