class CreateActivityWeekParticipant < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_week_participants do |t|
      t.integer :hours
      t.string :evaluation
      t.references :activity_week, null: false, foreign_key: true
      t.references :participable, polymorphic: true

      t.timestamps
    end
  end
end
