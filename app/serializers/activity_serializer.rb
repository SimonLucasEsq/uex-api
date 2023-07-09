class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :activity_type_id, :professor_id, :status, :address, :virtual_participation, :organizing_organization_id,
    :partner_organization_id, :project_link, :hours, :ods_vinculation, :institutional_program, :institutional_extension_line,
    :start_date, :end_date, :evaluation, :approved_at, :resolution_number
    
  belongs_to :beneficiary_detail
  belongs_to :activity_type
  belongs_to :organizing_organization
  belongs_to :partner_organization
  belongs_to :professor
  has_many :activity_careers
  has_many :careers
end
