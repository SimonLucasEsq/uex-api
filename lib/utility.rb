module Utility
  # Remove extra spaces, accents and convert to downcase. Return blank string if value passed is nil
  def self.clean_string(string)
    return "" unless string

    I18n.transliterate(string).squish.downcase
  end
end
