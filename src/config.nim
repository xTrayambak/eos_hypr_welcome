## Compile-time configuration + JSON config
import std/[os, options, logging, strutils, strformat, json]

const
  WEBSITE_URL* {.strdefine: "WebsiteUrl".} = "https://endeavouros.com"
  WIKI_URL* {.strdefine: "WikiUrl".} = "https://discovery.endeavouros.com"
  FORUM_URL* {.strdefine: "ForumUrl".} = "https://forum.endeavouros.com"
  NEWS_URL* {.strdefine: "NewsUrl".} = "https://endeavouros.com/news"
  DONATE_URL* {.strdefine: "DonateUrl".} = "https://endeavouros.com/donate"

  LICENSE_FILE* {.strdefine: "LicenseFile".} = "../LICENSE"
  LICENSE_STRING* {.strdefine: "LicenseString".} = staticRead(LICENSE_FILE)
  CONFIG_PATH* {.strdefine: "ConfigPath".} = "/home/$1/.config/welcome_rc.json"

var data: JsonNode
if fileExists(CONFIG_PATH):
  data = parseJson(readFile(CONFIG_PATH % [getEnv("USER")]))
else:
  data = parseJson("""
{
  "general": {
    "persist": true,
    "language": "English"
  },
  "mirror_rank": {
    "delay": 3600,
    "force_aur_helper": ""
  },
  "ux": {
    "page": 0
  }
}
  """)

proc getValue*(key: string): Option[JsonNode] {.inline.} =
  var curr = data

  # Descend down the node hierarchy, split by a dot.
  
  try:
    for val in key.split('.'):
      curr = curr[val]

    some curr
  except CatchableError as exc:
    warn "getValue(): whilst descending to find option key \"" & key & "\": " & exc.msg
    none(JsonNode)

proc setValue*[T](key: string, value: T) {.inline.} =
  var curr = data

  try:
    let splitted = key.split('.')

    for i, val in splitted:
      if i == splitted.len - 1:
        continue
      curr = curr[val]

    curr{splitted[splitted.len - 1]} = %* value
  except CatchableError as exc:
    warn "setValue(): whilst setting key \"" & key & "\" to " & $value & ": " & exc.msg

proc writeSettings* {.inline.} =
  info "Saving settings."
  writeFile(
    CONFIG_PATH % [getEnv("USER")],
    pretty data
  )
