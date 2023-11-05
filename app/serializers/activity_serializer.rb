class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :professor_id, :status, :address, :virtual_participation, :organizing_organization_id,
    :partner_organization_id, :project_link, :hours, :ods_vinculation, :institutional_program, :institutional_extension_line,
    :start_date, :end_date, :evaluation, :approved_at, :resolution_number, :objective

  belongs_to :beneficiary_detail
  belongs_to :organizing_organization
  belongs_to :partner_organization
  belongs_to :professor
  has_many :activity_careers
  has_many :activities_activity_sub_types
  has_many :activity_sub_types

  def start_date
    I18n.l(object.start_date, format: :default)
  end
  def end_date
    I18n.l(object.end_date, format: :default)
  end
end
