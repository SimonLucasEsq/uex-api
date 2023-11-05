class AddActivitySubTypeReferenceToActivityWeekParticipants < ActiveRecord::Migration[7.0]
  def change
    add_reference :activity_week_participants, :activity_sub_type, foreign_key: true, index: true
  end
end
