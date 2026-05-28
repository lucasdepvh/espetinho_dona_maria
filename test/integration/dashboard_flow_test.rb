require "test_helper"

class DashboardFlowTest < ActionDispatch::IntegrationTest
  setup do
    Setting.current.update!(
      establishment_name: "Espetinho Dona Maria",
      address: "Rua da Brasa, 123",
      default_delivery_fee: 5
    )

    @category = Category.create!(name: "Espetos", active: true)
    @product = Product.create!(
      category: @category,
      name: "Espeto de carne",
      description: "Brasa forte e ponto certo",
      price: 12,
      active: true,
      featured: true
    )
    @admin = User.create!(name: "Admin", email: "admin@example.com", password: "password", role: :admin, active: true)
  end

  test "visitor sees client dashboard without internal navigation" do
    get dashboard_path

    assert_response :success
    assert_includes response.body, "Carrinho de Compras"
    assert_includes response.body, "Adicionar"
    assert_includes response.body, "Entrar"
    assert_not_includes response.body, "Pedidos em andamento"
    assert_not_includes response.body, "Clientes"
  end

  test "visitor can add item to cart" do
    post dashboard_cart_items_path(@product)

    assert_redirected_to dashboard_path(cart: "open")
    follow_redirect!

    assert_includes response.body, "adicionado ao carrinho"
    assert_includes response.body, "Espeto de carne"
    assert_includes response.body, "R$ 12,00"
    assert_includes response.body, "translate-x-0"
  end

  test "visitor can request cart on whatsapp" do
    post dashboard_cart_items_path(@product)

    post dashboard_cart_whatsapp_path

    assert_response :redirect
    assert_match %r{\Ahttps://wa\.me/}, response.location
    assert_includes URI.decode_www_form_component(response.location), "Solicitação de pedido"
    assert_includes URI.decode_www_form_component(response.location), "1x Espeto de carne - R$ 12,00"
    assert_includes URI.decode_www_form_component(response.location), "*Total parcial:* R$ 12,00"
  end

  test "visitor cannot request empty cart on whatsapp" do
    post dashboard_cart_whatsapp_path

    assert_redirected_to dashboard_path(anchor: "cardapio")
    follow_redirect!

    assert_includes response.body, "Adicione pelo menos um item ao carrinho."
  end

  test "admin sees operation shortcuts" do
    post login_path, params: { email: @admin.email, password: "password" }

    get dashboard_path

    assert_response :success
    assert_includes response.body, "Painel da operacao"
    assert_includes response.body, "Configuracoes"
    assert_includes response.body, "Pedidos em andamento"
  end
end
