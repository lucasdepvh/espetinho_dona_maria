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

  def dashboard_category_tone(category_name)
    {
      "Espetos" => "from-orange-500/30 via-orange-400/10 to-transparent text-orange-200 border-orange-400/40",
      "Acompanhamentos" => "from-amber-400/30 via-amber-300/10 to-transparent text-amber-100 border-amber-300/40",
      "Adicionais" => "from-stone-400/25 via-stone-300/10 to-transparent text-stone-100 border-stone-300/30",
      "Bebidas" => "from-cyan-400/30 via-sky-300/10 to-transparent text-sky-100 border-sky-300/40",
      "Combos" => "from-rose-400/30 via-orange-400/10 to-transparent text-rose-100 border-rose-300/40"
    }[category_name] || "from-stone-500/25 via-stone-300/10 to-transparent text-stone-100 border-stone-300/30"
  end

  def dashboard_category_surface(category_name)
    {
      "Espetos" => "bg-orange-500 text-stone-950",
      "Acompanhamentos" => "bg-amber-300 text-stone-950",
      "Adicionais" => "bg-stone-300 text-stone-950",
      "Bebidas" => "bg-sky-300 text-stone-950",
      "Combos" => "bg-rose-300 text-stone-950"
    }[category_name] || "bg-stone-200 text-stone-950"
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

  def dashboard_product_portion(product)
    return "#{product.average_preparation_time} min" if product.average_preparation_time.present?

    product.category.name
  end

  def dashboard_nav_link_class(path = nil, active: false)
    base = "flex min-w-0 flex-col items-center justify-center gap-1 rounded-2xl px-3 py-2 text-xs font-medium transition"
    current = active || (path.present? && current_page?(path))

    current ? "#{base} bg-orange-500 text-stone-950" : "#{base} text-stone-400 hover:text-stone-100"
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

  def dashboard_operation_links(user)
    links = [
      { label: "Pedidos", path: orders_path, emoji: "📋", description: "Abrir pedidos e acompanhar atendimento" },
      { label: "Clientes", path: customers_path, emoji: "👤", description: "Consultar cadastro e historico rapido" },
      { label: "Cozinha", path: kitchen_path, emoji: "🔥", description: "Ver itens em preparo e pendencias" }
    ]

    if user&.admin?
      links << { label: "Produtos", path: products_path, emoji: "🍢", description: "Ajustar cardapio e disponibilidade" }
      links << { label: "Categorias", path: categories_path, emoji: "🏷", description: "Organizar exibicao do cardapio" }
      links << { label: "Configuracoes", path: edit_settings_path, emoji: "⚙", description: "Dados da casa e taxa padrao" }
    end

    links
  end
end
