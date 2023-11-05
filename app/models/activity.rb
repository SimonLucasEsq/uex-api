class Activity < ApplicationRecord
  include ActiveModel::Dirty

  enum status: {
    draft: 0,
    evaluated: 1,
    declined: 2,
    sent_to_deanery: 3,
    rejected: 4,
    approved: 5
  }

  STATUS_FLOW = {
    draft: {
      next: [:evaluated, :declined],
      back: []
    },
    evaluated: {
      next: [:sent_to_deanery],
      back: [:draft]
    },
    declined: {
      next: [],
      back: [:draft]
    },
    sent_to_deanery: {
      next: [:approved, :rejected],
      back: [:evaluated]
    },
    rejected: {
      next: [],
      back: [:draft]
    },
    approved: {
      next: [],
      back: []
    }
  }.freeze

  belongs_to :professor
  belongs_to :organizing_organization, class_name: 'Organization', foreign_key: 'organizing_organization_id', optional: true
  belongs_to :partner_organization, class_name: 'Organization', foreign_key: 'partner_organization_id', optional: true
  has_many :activity_careers, dependent: :destroy
  has_many :careers, through: :activity_careers
  has_many :activity_weeks, dependent: :destroy
  has_many :activities_activity_sub_types, dependent: :destroy
  has_many :activity_sub_types, through: :activities_activity_sub_types, dependent: :destroy
  has_one :beneficiary_detail, dependent: :destroy

  validates_uniqueness_of :name
  validates_presence_of :name, :hours, :status
  validate :validate_status_flow, if: :status_changed?

  accepts_nested_attributes_for :activity_weeks
  accepts_nested_attributes_for :activity_careers, allow_destroy: true
  accepts_nested_attributes_for :beneficiary_detail, allow_destroy: true
  accepts_nested_attributes_for :activities_activity_sub_types, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search] if params[:search].present?
      scope = scope.joins(:careers).where(careers: params[:career_id]) if params[:career_id].present?
      scope
    end

    def global_search(text)
      joins(:activity_sub_types, professor: :person)
        .where(
          "activities.name ILIKE :search OR activity_sub_types.name ILIKE :search OR CONCAT_WS(' ', first_name, last_name) ILIKE :search",
          search: "%#{text}%"
        )
    end
  end

  def validate_status_flow
    status_was = self.status_was&.to_sym
    status = self.status.to_sym

    return if status_was == nil && status == :draft
    return if (next_status(status_was).include?(status) || back_status(status_was).include?(status))

    errors.add(:status, I18n.t("activerecord.errors.messages.invalid_status_flow", status_was: status_was, status: status))
  end

  def date_formatted
    "#{start_date} - #{end_date}"
  end

  def next_status(status)
    STATUS_FLOW[status][:next]
  end

  def back_status(status)
    STATUS_FLOW[status][:back]
  end
end
