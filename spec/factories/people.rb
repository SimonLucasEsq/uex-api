FactoryBot.define do
  factory(:person) do
    first_name { "Juan" }
    last_name { "Perez" }
    email { "juan@email.com" }
  end
end