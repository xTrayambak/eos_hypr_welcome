# Package

version       = "0.1.0"
author        = "xTrayambak"
description   = "A \"welcome\" app for EndeavourOS' Hyprland spin!"
license       = "GPL-3.0-only"
srcDir        = "src"
bin           = @["hypr_welcome"]


# Dependencies

requires "nim >= 2.0.2"
requires "colored_logger >= 0.1.0"
requires "owlkettle >= 3.0.0"
requires "ni18n >= 0.1.0"
