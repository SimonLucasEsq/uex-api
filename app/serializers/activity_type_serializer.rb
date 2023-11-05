class ActivityTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  has_many :activity_sub_types
end
