import std/osproc

proc copyToClipboard*(msg: string): bool {.inline, discardable.} =
  execCmd("wl-copy \"" & msg & "\"") == 0
