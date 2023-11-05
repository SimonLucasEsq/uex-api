FactoryBot.define do
  factory(:activity) do
    name { "Tesape'a 2023" }
    status { :draft }
    professor { create(:professor) }
    start_date { Date.today }
    end_date { Date.tomorrow }
    hours { 10 }
  end
end