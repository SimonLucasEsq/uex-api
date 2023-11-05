FactoryBot.define do
  factory(:activity_sub_type) do
    name { "Charlas educativas de interes social y estudiantil" }
    hours { 0 }
    unlimited_hours { true }
    activity_type { create(:activity_type) }
  end
end