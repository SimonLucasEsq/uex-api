class CreateActivityCareer < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_careers do |t|
      t.references :career, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
