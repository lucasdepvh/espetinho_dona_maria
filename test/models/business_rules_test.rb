require "test_helper"

class BusinessRulesTest < ActiveSupport::TestCase
  setup do
    @admin = User.create!(name: "Admin", email: "admin@example.com", password: "password", role: :admin)
    @category = Category.create!(name: "Espetos")
    @product = Product.create!(category: @category, name: "Espeto de carne", price: 10)
    @customer = Customer.create!(name: "Maria", phone: "(69) 99999-0000")
  end

  test "order item copies product price and calculates total" do
    order = Order.new(customer: @customer, user: @admin)
    item = order.order_items.build(product: @product, quantity: 2)

    assert order.valid?
    assert_equal BigDecimal("10.0"), item.unit_price
    assert_equal BigDecimal("20.0"), item.total_price
  end

  test "order calculates subtotal and total" do
    order = Order.create!(
      customer: @customer,
      user: @admin,
      delivery_fee: 5,
      order_items_attributes: {
        "0" => { product_id: @product.id, quantity: 3 }
      }
    )

    assert_equal BigDecimal("30.0"), order.subtotal
    assert_equal BigDecimal("35.0"), order.total
  end

  test "status enum includes expected states" do
    assert_equal %w[open confirmed preparing ready delivered canceled], Order.statuses.keys
  end

  test "customer phone is normalized for whatsapp" do
    assert_equal "5569999990000", @customer.phone
  end

  test "whatsapp customer message includes order data" do
    Setting.current.update!(establishment_name: "Espetinho Dona Maria", kitchen_whatsapp: "69999999999")
    order = Order.create!(
      customer: @customer,
      user: @admin,
      payment_method: :pix,
      order_items_attributes: {
        "0" => { product_id: @product.id, quantity: 2, notes: "bem passado" }
      }
    )

    message = WhatsappMessageBuilder.new(order).customer_message

    assert_includes message, "*Pedido:* ##{order.id}"
    assert_includes message, "2x Espeto de carne - R$ 20,00"
    assert_includes message, "*Pagamento:* Pix"
  end
end
