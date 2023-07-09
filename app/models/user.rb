class User < ApplicationRecord
  has_secure_password
  validates_presence_of :username, :email, uniqueness: { case_sensitive: false }

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      where("email LIKE :search OR username LIKE :search", search: "%#{text}%")
    end
  end
end
