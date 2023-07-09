class Person < ApplicationRecord
  enum sex: {
    male: 0,
    female: 1
  }

  has_one :student
  has_one :professor

  validates_presence_of :email, :id_card, :first_name, :last_name, :sex
  validates_uniqueness_of :id_card, :email
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  def merge_errors(model_object)
    return if errors.any?

    model_object.errors.to_a.each do |error|
      self.errors.add(:base, error)
    end
  end
end
