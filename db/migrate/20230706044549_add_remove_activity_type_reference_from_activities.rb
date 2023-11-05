class AddRemoveActivityTypeReferenceFromActivities < ActiveRecord::Migration[7.0]
  def change
    remove_reference :activities, :activity_type, index: true, foreign_key: true
  end
end
