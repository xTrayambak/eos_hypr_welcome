import std/[os, logging, osproc]

proc copyToClipboard*(msg: string): bool {.inline, discardable.} =
  info "Copying content: \"" & msg & "\" to clipboard, if available."
  
  case getEnv("XDG_SESSION_TYPE")
  of "wayland": 
    info "Using wl-copy as clipboard provider."
    execCmd("wl-copy \"" & msg & "\"") == 0
  else:
    info "Using xclip as clipboard provider."
    execCmd("echo \"" & msg & "\" | xclip -selection clipboard") == 0
