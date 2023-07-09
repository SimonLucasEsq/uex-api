FactoryBot.define do
  factory(:user) do
    email { "user@email.com" }
    password { "password" }
    username { "user" }
  end
end
