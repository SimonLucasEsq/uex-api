class Career < ApplicationRecord
    validates_presence_of :name

    class << self
      def search(params)
        scope = where({})
        scope = global_search(params[:search]) if params[:search]
        scope
      end
  
      def global_search(text)
        where("name ILIKE :search", search: "%#{text}%")
      end
    end
end
