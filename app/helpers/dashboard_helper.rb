module DashboardHelper
  def dashboard_category_icon(category_name)
    {
      "Espetos" => "🍢",
      "Acompanhamentos" => "🍟",
      "Adicionais" => "🧂",
      "Bebidas" => "🥤",
      "Combos" => "🔥"
    }[category_name] || "🍽"
  end

  def dashboard_category_label(category)
    count = category.products.select(&:active).count
    "#{count} #{'item'.pluralize(count)}"
  end

  def dashboard_product_description(product)
    return product.description if product.description.present?

    parts = [product.category.name]
    if product.average_preparation_time.present?
      parts << "#{product.average_preparation_time} min"
    end
    parts.join(" • ")
  end

  def dashboard_promo_label(product)
    return "MAIS PEDIDO" if product.featured?

    "DESTAQUE"
  end

  def dashboard_nav_link_class(path)
    base = "flex min-w-0 flex-col items-center justify-center gap-1 rounded-2xl px-3 py-2 text-xs font-medium transition"
    current_page?(path) ? "#{base} bg-orange-500 text-stone-950" : "#{base} text-stone-400 hover:text-stone-100"
  end

  def dashboard_status_badge_class(status)
    {
      "open" => "bg-slate-500/15 text-slate-200 ring-1 ring-inset ring-slate-400/30",
      "confirmed" => "bg-blue-500/15 text-blue-200 ring-1 ring-inset ring-blue-400/30",
      "preparing" => "bg-amber-500/15 text-amber-200 ring-1 ring-inset ring-amber-400/30",
      "ready" => "bg-emerald-500/15 text-emerald-200 ring-1 ring-inset ring-emerald-400/30",
      "delivered" => "bg-stone-500/15 text-stone-200 ring-1 ring-inset ring-stone-400/30",
      "canceled" => "bg-red-500/15 text-red-200 ring-1 ring-inset ring-red-400/30"
    }[status.to_s] || "bg-slate-500/15 text-slate-200 ring-1 ring-inset ring-slate-400/30"
  end
end
