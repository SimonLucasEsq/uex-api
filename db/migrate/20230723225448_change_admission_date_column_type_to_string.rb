class ChangeAdmissionDateColumnTypeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :students, :admission_year, :string
  end
end
