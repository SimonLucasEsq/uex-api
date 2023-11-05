module Persons
  extend ActiveSupport::Concern

  included do
    validate :validates_uniqueness_of_email, :validates_uniqueness_of_id_card
    delegate :first_name, :last_name, :email, :phone_number, :id_card, :address, :sex, to: :person
  end

  class_methods do
    def global_search(text)
      joins(:person).
        where("CONCAT_WS(' ', first_name, last_name) ILIKE :search OR id_card ILIKE :search OR email ILIKE :search OR phone_number ILIKE :search", search: "%#{text}%")
    end
  end

  def validates_uniqueness_of_email
    return unless self.class.joins(:person).where.not(id: id).where(person: {email: email}).exists?

    errors.add(:email, "taken")
  end

  def validates_uniqueness_of_id_card
    return unless self.class.joins(:person).where.not(id: id).where(person: {id_card: id_card}).exists?

    errors.add(:id_card, "taken")
  end

  def full_name
    "#{person.first_name} #{person.last_name}"
  end

  def career_formatter
  end
end