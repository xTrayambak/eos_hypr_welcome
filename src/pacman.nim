import std/[logging, osproc]

proc install*(packages: string): bool {.inline.} =
  info "Installing the following packages: " & packages
  execCmd("pkexec pacman -S " & packages) == 0

proc install*(packages: seq[string]): bool {.inline.} =
  var list: string
  for pkg in packages:
    list &= pkg & ' '

  install(list)

proc rateMirrors*(delay: int): tuple[error: string, success: bool] {.inline.} =
  info "Rating mirrors..."

  let phaseOne = execCmdEx("rate-mirrors --save /tmp/mirrorlist arch --max-delay=" & $delay)
  
  if phaseOne.exitCode != 0:
    warn "rate-mirrors failed!"
    return (error: phaseOne.output, success: false)

  info "Rated mirrors."

  (error: "", success: phaseOne.exitCode == 0 and execCmdEx("pkexec cp /tmp/mirrorlist /etc/pacman.d/").exitCode == 0)
