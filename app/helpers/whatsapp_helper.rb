module WhatsappHelper
  def whatsapp_customer_url(order)
    WhatsappMessageBuilder.new(order).customer_url
  end

  def whatsapp_kitchen_url(order)
    WhatsappMessageBuilder.new(order).kitchen_url
  end
end
