# Regras do Projeto

## Contexto Geral

- Projeto = sistema interno da Espetinho Dona Maria, feito em Rails 8.1 com Ruby 3.4.2 e SQLite.
- Objetivo principal = operar atendimento, pedidos, cozinha, clientes, produtos, usuarios e mensagens via WhatsApp.
- Prioridade sempre: fluxo rapido de operacao, clareza visual, baixa friccao para atendente e regras de negocio corretas.

## Stack e Convencoes Tecnicas

- Respeitar stack atual. Nao introduzir dependencias, frameworks JS ou gems sem necessidade real.
- Seguir padrao Rails convencional: controller enxuto, regra de negocio em model/service quando fizer sentido.
- Mudancas de banco devem ser feitas por migration. Nunca editar `db/schema.rb` manualmente.
- Manter compatibilidade com Importmap, ERB e Tailwind/CSS ja existentes no projeto.
- Preferir solucoes simples, server-rendered e idiomaticas para Rails.

## Dominio e Regras de Negocio

- Pedido e entidade central do sistema. Toda alteracao deve preservar calculo de subtotal, taxa de entrega e total.
- `OrderItem` deve copiar preco do produto no momento do pedido e calcular total por quantidade.
- Status de pedido devem continuar coerentes com fluxo atual:
  - `open`
  - `confirmed`
  - `preparing`
  - `ready`
  - `delivered`
  - `canceled`
- Tipos de pedido devem respeitar fluxo atual:
  - `pickup`
  - `table`
  - `delivery`
- Regras condicionais obrigatorias:
  - pedido `table` exige `table_number`
  - pedido `delivery` exige `delivery_address`
  - pedido precisa de ao menos 1 item valido
- Taxa de entrega padrao vem de `Setting.current.default_delivery_fee` quando pedido for entrega.
- Telefones devem continuar normalizados para uso em links `wa.me`.
- Integracoes de WhatsApp deste projeto usam links gerados internamente. Nao acoplar API externa sem pedido explicito.

## Perfis e Permissoes

- Sistema tem pelo menos dois papeis: `admin` e `attendant`.
- Admin gerencia configuracoes, usuarios, categorias e produtos.
- Atendente opera clientes e pedidos.
- Ao criar ou alterar telas/controladores, preservar autenticacao por sessao e restricoes de acesso existentes.
- Nao remover validacoes de `authenticate_user!` e `authorize_admin!` sem motivo funcional claro.

## Convencoes de Interface

- Seguir sempre o padrao visual descrito em `.ai-framework/DESIGN.md`.
- Como o design system ainda esta pouco documentado, inferir o padrao a partir das views existentes e manter consistencia.
- Formularios devem continuar simples, diretos e com labels em portugues.
- Textos da interface devem permanecer em portugues.
- Priorizar legibilidade e velocidade operacional em desktop e mobile.
- Reaproveitar partials existentes como `shared/_errors` quando houver formulario com validacao.
- Evitar interfaces rebuscadas ou componentes desnecessarios para fluxos administrativos.

## Convencoes de Codigo

- Manter nomes de classes, associations, enums e rotas consistentes com estrutura atual do dominio.
- Antes de criar novo service/helper, verificar se ja existe responsabilidade parecida no projeto.
- Preferir metodos pequenos e nomes explicitos.
- Evitar abstracoes prematuras e indirecoes desnecessarias.
- Se uma regra estiver coberta por model callback ou validacao atual, extender com cuidado em vez de duplicar comportamento no controller/view.

## Testes e Seguranca de Mudanca

- Ao alterar regra de negocio, atualizar ou adicionar testes automatizados.
- Dar preferencia a testes que cubram calculo de pedido, enums, normalizacao de telefone e mensagens WhatsApp.
- Nao quebrar fixtures, seeds nem usuarios padrao sem necessidade.
- Preservar fluxo basico descrito no `README.md`: admin configura sistema, atendente registra pedido, cozinha acompanha preparo.

## Guard Rails

- Nao trocar stack principal do projeto.
- Nao adicionar complexidade de frontend desnecessaria.
- Nao mover regra critica de negocio para JavaScript se ela precisar ser confiavel no servidor.
- Nao editar schema manualmente.
- Nao alterar enums, nomes de status ou fluxo de pedido sem revisar impacto em models, views, testes e mensagens.
- Nao introduzir ingles em textos de interface voltados ao usuario final.
- Nao presumir integracao externa paga quando o projeto hoje resolve com recursos nativos e links de WhatsApp.
