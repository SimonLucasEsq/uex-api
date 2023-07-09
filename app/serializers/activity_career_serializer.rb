class ActivityCareerSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :career_id
    
  belongs_to :career
end
