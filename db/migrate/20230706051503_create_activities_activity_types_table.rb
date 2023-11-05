class CreateActivitiesActivityTypesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :activities_activity_sub_types do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :activity_sub_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
