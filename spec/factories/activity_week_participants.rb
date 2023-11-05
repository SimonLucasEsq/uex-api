FactoryBot.define do
  factory(:activity_week_participant) do
    hours { 10 }
    evaluation { 10 }
    activity_sub_type { create(:activity_sub_type) }
  end
end
