class CreateBeneficiaryDetail < ActiveRecord::Migration[7.0]
  def change
    create_table :beneficiary_details do |t|
      t.references :activity, null: false, foreign_key: true
      t.integer :number_of_men
      t.integer :number_of_women
      t.integer :total

      t.timestamps
    end
  end
end
