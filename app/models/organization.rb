class Organization < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :contact_email
  validates :contact_email, format: {with: URI::MailTo::EMAIL_REGEXP}, if: :contact_email

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      where("name ILIKE :search OR contact_name ILIKE :search OR contact_email ILIKE :search", search: "%#{text}%")
    end
  end
end
