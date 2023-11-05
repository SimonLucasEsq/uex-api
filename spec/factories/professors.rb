FactoryBot.define do
  factory(:professor) do
    person { 
      create(:person, first_name: "Carlos", last_name: "Perez", email: "carlos@email.com", sex: :male, id_card: 5222666)
    }
  end
end