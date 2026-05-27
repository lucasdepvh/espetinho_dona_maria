# Espetinho Dona Maria

Sistema Rails 8 para controle de pedidos, comandas, cozinha, clientes, produtos e envio de mensagens via links `wa.me`.

## Requisitos

- Ruby 3.4.2
- Rails 8.1
- SQLite

## Instalacao

```bash
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## Usuarios padrao

- Admin: `admin@espetaria.com` / `password`
- Atendente: `atendente@espetaria.com` / `password`

## Rodando

```bash
bin/dev
```

Acesse `http://localhost:3000`.

## Testes

```bash
bin/rails test
```

## Fluxo

O admin cadastra categorias, produtos, usuarios e configuracoes. O atendente cria pedidos para retirada, mesa ou entrega, adiciona itens e observacoes, e muda o status conforme o atendimento. A cozinha visualiza pedidos confirmados ou em preparo e marca como em preparo ou pronto. Os links de WhatsApp montam mensagens para cliente e cozinha sem depender de API paga.
