class AddObjectiveToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :objective, :text
  end
end
