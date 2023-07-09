class CreateActivityWeek < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_weeks do |t|
      t.references :activity, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
