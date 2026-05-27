Setting.current.update!(
  establishment_name: "Espetinho Dona Maria",
  phone: "69999999999",
  kitchen_whatsapp: "69999999999",
  address: "Rua Principal, 100",
  default_delivery_fee: 0,
  default_final_message: "Obrigado pela preferencia! Seu pedido foi registrado no Espetinho Dona Maria."
)

User.find_or_initialize_by(email: "admin@espetaria.com").tap do |user|
  user.name = "Administrador"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = :admin
  user.active = true
  user.save!
end

User.find_or_initialize_by(email: "atendente@espetaria.com").tap do |user|
  user.name = "Atendente"
  user.password = "password"
  user.password_confirmation = "password"
  user.role = :attendant
  user.active = true
  user.save!
end

categories = {}
["Espetos", "Bebidas", "Acompanhamentos", "Combos", "Adicionais"].each do |name|
  categories[name] = Category.find_or_create_by!(name: name) do |category|
    category.active = true
  end
end

products = [
  ["Espetos", "Espeto de carne", 10.00],
  ["Espetos", "Espeto de frango", 9.00],
  ["Espetos", "Espeto de linguica", 9.00],
  ["Espetos", "Espeto de coracao", 11.00],
  ["Espetos", "Espeto de queijo coalho", 10.00],
  ["Acompanhamentos", "Arroz", 6.00],
  ["Acompanhamentos", "Mandioca", 7.00],
  ["Acompanhamentos", "Vinagrete", 4.00],
  ["Acompanhamentos", "Farofa", 3.00],
  ["Bebidas", "Refrigerante lata", 6.00],
  ["Bebidas", "Agua mineral", 3.00],
  ["Combos", "Combo 3 espetos + acompanhamento", 32.00]
]

products.each do |category_name, name, price|
  Product.find_or_initialize_by(name: name).tap do |product|
    product.category = categories[category_name]
    product.price = price
    product.active = true
    product.featured = category_name.in?(["Espetos", "Combos"])
    product.average_preparation_time ||= 15
    product.save!
  end
end
