class ProfessorSerializer < ActiveModel::Serializer
  attributes :id, :person
  
  belongs_to :person
  has_many :professor_careers
end
