class ActivitySubTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :hours, :unlimited_hours, :activity_type_id
end