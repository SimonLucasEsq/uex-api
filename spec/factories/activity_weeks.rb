FactoryBot.define do
  factory(:activity_week) do
    start_date { Date.today }
    end_date { Date.tomorrow }
    activity { create(:activity) }
  end
end