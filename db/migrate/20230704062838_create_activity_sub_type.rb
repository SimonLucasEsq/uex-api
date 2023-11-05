class CreateActivitySubType < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_sub_types do |t|
      t.references :activity_type, null: false, foreign_key: true
      t.boolean :unlimited_hours
      t.string :name
      t.integer :hours

      t.timestamps
    end
  end
end
