class BeneficiaryDetailSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :number_of_men, :number_of_women, :total
end
