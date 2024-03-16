import std/[logging, sets, browsers]
import colored_logger
import owlkettle, owlkettle/[playground, adw, bindings/gtk]

import ./[pacman, style, config, clipboard]

const
  Version {.strdefine: "NimblePkgVersion".} = "???"

type
  AppPage* = enum
    General = 0
    PostInstall = 1
    Tips = 2
    AddMoreApps = 3
    PersonalCommands = 4

viewable App:
  page: int = 0

proc loadImage*(path: string): Pixbuf {.inline.} =
  info "Loading image: " & path
  try:
    return loadPixbuf(path)
  except IOError as exc:
    error "Failed to load image! (" & exc.msg & ')'

proc showErrorMessage(app: AppState, action, error: string) {.inline.} =
  let input = app.open: gui: MessageDialog:
    message = action & '\n' & error

    DialogButton {.addButton.}:
      text = "Continue"
      res = DialogAccept

    DialogButton {.addButton.}:
      text = "Copy error to clipboard"
      res = DialogReject

  if input.res.kind == DialogReject:
    if not copyToClipboard(error):
      # me when recursion
      showErrorMessage(app, "Failed to invoke clipboard copy!", "wl-copy returned a non-zero exit code.")

method view(app: AppState): Widget =
  result = gui:
    AdwWindow:
      defaultSize = (200, 120)

      Box:
        spacing = 4

        Box:
          orient = OrientY
          # Draw main content
          case AppPage(app.page):
            of General:
              Box {.halign: AlignCenter.}:
                Label:
                  style = [StyleClass("header")]
                  text = "<b>Find your way at the EndeavourOS website!</b>"
                  useMarkup = true

              Box {.halign: AlignCenter, valign: AlignCenter.}:
                spacing = 8
                Button:
                  text = "Website"
            
                  proc clicked =
                    info "Opening EndeavourOS website!"
                    openDefaultBrowser(WEBSITE_URL)

                Button:
                  text = "Forums"

                  proc clicked =
                    info "Opening EndeavourOS forum!"
                    openDefaultBrowser(FORUM_URL)

                Button:
                  text = "Wiki"

                  proc clicked =
                    info "Opening EndeavourOS wiki!"
                    openDefaultBrowser(WIKI_URL)

                Button:
                  text = "Donate"

                  proc clicked =
                    info "Opening EndeavourOS donation page!"
                    openDefaultBrowser(DONATE_URL)

                Button:
                  text = "News"

                  proc clicked =
                    info "Opening EndeavourOS news page!"
                    openDefaultBrowser(NEWS_URL)
            of PostInstall:
              Box {.halign: AlignCenter.}:
                Label:
                  text = "<b>Post-Install Tasks</b>"
                  useMarkup = true
                  style = [StyleClass("header")]

              Box {.halign: AlignCenter, valign: AlignCenter.}:
                spacing = 8
                ScrolledWindow:
                  sizeRequest = (600, 400)
                  Box:
                    orient = OrientY
                    Button:
                      text = "Update Mirrors (Arch, reflector-simple)"

                      proc clicked =
                        let res = rateMirrors(0)

                        if not res.success:
                          app.showErrorMessage("Failed to update mirrors!", res.error)

                    Button:
                      text = "Update Mirrors (Arch, rate-mirrors)"

                    Button:
                      text = "Update Mirrors (EndeavourOS)"

                    Button:
                      text = "Update System (yay)"

                    Button:
                      text = "Update System (eos-update --yay)"

                    Button:
                      text = "Package cleanup configuration"
            else: discard
       
        OverlaySplitView:
          enableHideGesture = true
          enableShowGesture = true
          maxSidebarWidth = 300.0
          minSidebarwidth = 250.0
          sensitive = true
          pinSidebar = false
          sizeRequest = (-1, -1)

          ListBox:
            selectionMode = SelectionSingle
            selected = toHashSet([app.page])
            
            Button:
              text = "General"

              proc clicked =
                app.page = General.int

            Button:
              text = "Post-Install"

              proc clicked =
                app.page = PostInstall.int

            Button:
              text = "Tips"

              proc clicked =
                app.page = Tips.int

            Button:
              text = "Add More Apps"

              proc clicked =
                app.page = AddMoreApps.int

            Button:
              text = "Personal Commands"

              proc clicked =
                app.page = PersonalCommands.int

proc setupLogging {.inline.} =
  let logger = newColoredLogger()
  addHandler(logger)

proc main {.inline.} =
  setupLogging()
  info "eos_hypr_welcome@" & Version & " starting up!"
  info "Compiled with Nim@" & NimVersion
  info "Compiled on " & CompileDate & ' ' & CompileTime

  let 
    adwVer = $AdwVersion[0] & '.' & $AdwVersion[1]
    gtkVer = '4' & '.' & $GtkMinor

  info "Compiled with GTK@" & gtkVer 
  info "Compiled with libadwaita@" & adwVer

  adw.brew(
    "com.github.xTrayambak.eos_hypr_welcome",
    gui(App()), 
    stylesheets = [
      newStylesheet(
        mainStylesheet
      )
    ]
  )

  info "Exiting!"

when isMainModule:
  main()
