## All translations go here.
import ni18n

type
  Locale* = enum
    English
    Hindi
    # Deutsch

i18nInit Locale, true:
  exploreWebsite:
    English = "Explore the Website!"
    Hindi = "वेब्साइट देखे!"

  postInstallTasks:
    English = "Post-Install Tasks"
    Hindi = "पोस्ट-इंस्टॉल कार्य"

  tips:
    English = "Tips"
    Hindi = "सलाह"


