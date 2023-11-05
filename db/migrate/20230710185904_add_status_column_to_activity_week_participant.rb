class AddStatusColumnToActivityWeekParticipant < ActiveRecord::Migration[7.0]
  def change
    add_column :activity_week_participants, :registered_hours, :integer
  end
end
