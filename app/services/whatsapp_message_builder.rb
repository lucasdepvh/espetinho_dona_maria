require "erb"

class WhatsappMessageBuilder
  include ERB::Util

  def initialize(order)
    @order = order
    @setting = Setting.current
  end

  def customer_message
    lines = [
      "🔥 *Pedido - #{@setting.establishment_name}*",
      "",
      "*Pedido:* ##{@order.id}",
      "*Cliente:* #{@order.customer.name}",
      "*Telefone:* #{@order.customer.phone}",
      "*Tipo:* #{order_type_label}"
    ]

    lines << "*Mesa:* #{@order.table_number}" if @order.table?
    lines << "*Endereço:* #{@order.delivery_address}" if @order.delivery?
    lines.concat(["", "*Itens:*"])
    @order.order_items.each { |item| append_customer_item(lines, item) }
    lines.concat([
      "",
      "*Subtotal:* #{money(@order.subtotal)}",
      "*Taxa de entrega:* #{money(@order.delivery_fee)}",
      "*Total:* #{money(@order.total)}",
      "",
      "*Pagamento:* #{payment_label}",
      "",
      "*Observação:*",
      @order.notes.presence || "Sem observacao",
      "",
      @setting.default_final_message
    ])

    lines.join("\n")
  end

  def kitchen_message
    lines = [
      "🔥 *Novo pedido*",
      "",
      "*Pedido:* ##{@order.id}",
      "*Tipo:* #{order_type_label}",
      "*Cliente/Mesa:* #{client_or_table}",
      "",
      "*Itens:*"
    ]

    @order.order_items.each { |item| append_kitchen_item(lines, item) }
    lines.concat(["", "*Observação geral:*", @order.notes.presence || "Sem observacao"])
    lines.join("\n")
  end

  def customer_url
    wa_url(@order.customer.phone, customer_message)
  end

  def kitchen_url
    wa_url(@setting.kitchen_whatsapp, kitchen_message)
  end

  private

  def append_customer_item(lines, item)
    lines << "#{item.quantity}x #{item.product.name} - #{money(item.total_price)}"
    lines << "Obs: #{item.notes}" if item.notes.present?
    lines << ""
  end

  def append_kitchen_item(lines, item)
    lines << "#{item.quantity}x #{item.product.name}"
    lines << "Obs: #{item.notes}" if item.notes.present?
    lines << ""
  end

  def wa_url(phone, message)
    "https://wa.me/#{PhoneNormalizer.call(phone)}?text=#{url_encode(message)}"
  end

  def money(value)
    "R$ #{format('%.2f', value.to_d).tr('.', ',')}"
  end

  def order_type_label
    { "pickup" => "Retirada", "table" => "Mesa", "delivery" => "Entrega" }[@order.order_type]
  end

  def payment_label
    { "cash" => "Dinheiro", "pix" => "Pix", "card" => "Cartao", "credit" => "Credito" }[@order.payment_method]
  end

  def client_or_table
    @order.table? ? "Mesa #{@order.table_number}" : @order.customer.name
  end
end
