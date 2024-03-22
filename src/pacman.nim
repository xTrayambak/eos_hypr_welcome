## Utilities for working with pacman.

import std/[os, logging, osproc]

proc install*(packages: string): bool {.inline.} =
  info "Installing the following packages: " & packages
  execCmd("pkexec pacman -S " & packages) == 0

proc install*(packages: seq[string]): bool {.inline.} =
  var list: string
  for pkg in packages:
    list &= pkg & ' '

  install(list)

type
  RatingProgram* = enum
    rpRateMirrors
    rpReflectorSimple
    rpEosRankMirrors

proc rateMirrors*(program: RatingProgram, delay: uint): tuple[error: string, success: bool] {.inline.} =
  case program
  of rpRateMirrors:
    info "Rating mirrors (rate-mirrors)"

    let phaseOne = execCmdEx("rate-mirrors --save /tmp/mirrorlist arch --max-delay=" & $delay)

    if phaseOne.exitCode != 0:
      warn "rate-mirrors failed!"
      return (error: phaseOne.output, success: false)

    info "Rated mirrors with rate-mirrors. Moving new mirrorlist to /etc/pacman.d/"

    (error: "", success: phaseOne.exitCode == 0 and execCmdEx("pkexec cp /tmp/mirrorlist /etc/pacman.d/").exitCode == 0)
  of rpEosRankMirrors:
    info "Rating mirrors (eos-rankmirrors)"

    let res = execCmdEx("/usr/bin/eos-rankmirrors")

    if res.exitCode != 0:
      warn "eos-rankmirrors failed!"
      return (error: res.output, success: false)

    info "Rated mirrors with eos-rankmirrors."

    (error: "", success: true)
  of rpReflectorSimple:
    info "Rating mirrors (reflector-simple)"
    if fileExists("/usr/bin/reflector-simple"):
      let res = execCmdEx("/usr/bin/reflector-simple")
      
      if res.exitCode != 0:
        warn "reflector-simple failed!"
        return (error: res.output, success: false)

      info "Rated mirrors with reflector-simple!"
      (error: "", success: true)
    else:
      warn "reflector-simple isn't installed!"
      (error: "reflector-simple is not installed!", success: false)

proc findAurHelper*: string {.inline.} =
  info "Finding AUR helper."

  for knownAurHelper in [
    "pakku", "yay", "paru"
  ]: # TODO: add more helpers - these three share pacman's syntax so we support 'em
    let res = findExe(knownAurHelper)

    if res.len > 0:
      info "Found AUR helper: " & knownAurHelper
      return knownAurHelper

  warn "No known AUR helpers found!"

proc eosUpdate*: tuple[error: string, success: bool] {.inline.} =
  var helper = " --aur"

  if findAurHelper().len < 1:
    reset helper

  let res = execCmdEx("pkexec eos-update" & helper)

  if res.exitCode != 0:
    info "eos-update exited with a non-zero exit code!"
    return (error: res.output, success: false)

  info "eos-update exited successfully!"
  (error: "", success: true)
