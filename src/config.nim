const
  WEBSITE_URL* {.strdefine: "WebsiteUrl".} = "https://endeavouros.com"
  WIKI_URL* {.strdefine: "WikiUrl".} = "https://discovery.endeavouros.com"
  FORUM_URL* {.strdefine: "ForumUrl".} = "https://forum.endeavouros.com"
  NEWS_URL* {.strdefine: "NewsUrl".} = "https://endeavouros.com/news"
  DONATE_URL* {.strdefine: "DonateUrl".} = "https://endeavouros.com/donate"

  LICENSE_FILE* {.strdefine: "LicenseFile".} = "../LICENSE"
  LICENSE_STRING* {.strdefine: "LicenseString".} = staticRead(LICENSE_FILE)
