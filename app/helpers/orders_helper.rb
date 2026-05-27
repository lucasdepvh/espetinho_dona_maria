module OrdersHelper
  def brl(value)
    number_to_currency(value || 0, unit: "R$ ", separator: ",", delimiter: ".")
  end

  def order_status_label(status)
    {
      "open" => "Aberto",
      "confirmed" => "Confirmado",
      "preparing" => "Em preparo",
      "ready" => "Pronto",
      "delivered" => "Entregue",
      "canceled" => "Cancelado"
    }[status.to_s] || status.to_s
  end

  def order_type_label(type)
    { "pickup" => "Retirada", "table" => "Mesa", "delivery" => "Entrega" }[type.to_s] || type.to_s
  end

  def payment_method_label(method)
    { "cash" => "Dinheiro", "pix" => "Pix", "card" => "Cartao", "credit" => "Credito" }[method.to_s] || method.to_s
  end

  def status_badge_class(status)
    {
      "open" => "bg-slate-100 text-slate-700",
      "confirmed" => "bg-blue-100 text-blue-700",
      "preparing" => "bg-amber-100 text-amber-800",
      "ready" => "bg-emerald-100 text-emerald-700",
      "delivered" => "bg-stone-200 text-stone-700",
      "canceled" => "bg-red-100 text-red-700"
    }[status.to_s] || "bg-slate-100 text-slate-700"
  end
end
