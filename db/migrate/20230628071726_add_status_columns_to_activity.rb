class AddStatusColumnsToActivity < ActiveRecord::Migration[7.0]
  def change
    change_column :activities, :status, :integer, using: 'status::integer'
    add_column :activities, :evaluation, :integer
    add_column :activities, :approved_at, :date
    add_column :activities, :resolution_number, :string
  end
end
