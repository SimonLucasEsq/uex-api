class StudentSerializer < ActiveModel::Serializer
  attributes :id, :hours, :submitted, :admission_year, :career_id, :person
  
  belongs_to :person
  belongs_to :career
end
