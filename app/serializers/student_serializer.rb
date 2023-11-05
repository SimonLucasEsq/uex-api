class StudentSerializer < ActiveModel::Serializer
  attributes :id, :hours, :submitted, :admission_year, :career_id, :person, :status
  
  belongs_to :person
  belongs_to :career
end
