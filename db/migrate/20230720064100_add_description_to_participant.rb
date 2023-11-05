class AddDescriptionToParticipant < ActiveRecord::Migration[7.0]
  def change
    add_column :activity_week_participants, :description, :string
  end
end
