FactoryBot.define do
  factory(:student) do
    hours { 0 }
    status { :insuficient }
    admission_year { "2015" }
    submitted { false }
    person { 
      create(:person, first_name: "Maria", last_name: "Perez", email: "maria@email.com", sex: :female, id_card: 3658884)
    }
    career { create(:career) }
  end
end
