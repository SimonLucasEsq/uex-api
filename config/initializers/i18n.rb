# With this line of code, we can use any folder structure for our
# translations in the config/locales directory
I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml")]

# Locales are supported by our app
I18n.available_locales = %i[en es]

# Our default locale
I18n.default_locale = :es
