class CreateActivity < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :status
      t.string :address
      t.boolean :virtual_participation
      t.references :professor, null: false, foreign_key: true
      t.references :activity_type, null: false, foreign_key: true
      t.references :organizing_organization, null: true, foreign_key: { to_table: :organizations }
      t.references :partner_organization, null: true, foreign_key: { to_table: :organizations }
      t.string :project_link
      t.integer :hours
      t.integer :ods_vinculation
      t.boolean :institutional_program
      t.string :institutional_extension_line
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
