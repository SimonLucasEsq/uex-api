class AddStatusColumnToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :status, :integer, default: Student.statuses[:insuficient]

    Student.update_all(status: :insuficient)
  end
end
