{ config, pkgs, ... }:
let
  generateHomepage = name: font: config:
    ''<!DOCTYPE html>
    <html>
    <head>
      <title>Start page</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        body {
            background-color: #000000
        }
      </style>
    </head>
    <body>
    <h1>Hello</h1>
    </body>
    </html>
  '';
in
{

  home.packages = [
    pkgs.qutebrowser
  ];
  # home.sessionVariables = { DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser"; };
  # xdg.mimeApps.defaultApplications = {
  #   "text/html" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
  #   "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  # };
  # home.file.".config/qutebrowser/userscripts/container-open".source = "${(pkgs.callPackage ./qute-containers.nix { dmenuCmd = "fuzzel -d"; })}/bin/container-open";
  # home.file.".config/qutebrowser/userscripts/containers_config".source = "${(pkgs.callPackage ./qute-containers.nix { dmenuCmd = "fuzzel -d"; })}/bin/containers_config";

  programs.qutebrowser.enable = true;
  programs.qutebrowser.extraConfig = ''
import sys
import os.path
secretsExists = False
secretFile = os.path.expanduser("~/.config/qutebrowser/qutesecrets.py")

if (os.path.isfile(secretFile)):
    sys.path.append(os.path.dirname(secretFile))
    import qutesecrets
    secretsExists = True

config.set('scrolling.smooth',True)
config.set('qt.args',['ignore-gpu-blacklist','enable-gpu-rasterization','enable-native-gpu-memory-buffers','num-raster-threads=4'])
config.load_autoconfig(True)

config.set('content.cookies.accept', 'no-3rdparty', 'chrome-devtools://*')
config.set('content.cookies.accept', 'no-3rdparty', 'devtools://*')

config.set('content.headers.user_agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36')
config.set('content.headers.user_agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')

config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

config.set('content.javascript.enabled', True, 'qute://*/*')

c.tabs.favicons.scale = 1.0
c.tabs.last_close = 'close'
c.tabs.position = 'top'
c.tabs.width = '3%'
c.window.transparent = True
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.darkmode.enabled = True

c.url.default_page = str(config.configdir)+'/qute-home.html'
c.url.start_pages = str(config.configdir)+'/qute-home.html'

c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}&ia=web',
                       'dd'      : 'https://duckduckgo.com/?q={}&ia=web',
                       'az'     : 'https://www.amazon.com/s?k={}',
                       'al'     : 'https://allegro.pl/listing?string={}',
                       'nw'     : 'https://nixos.wiki/index.php?search={}&go=Go',
                       'mn'     : 'https://mynixos.com/search?q={}',
                       'np'     : 'https://search.nixos.org/packages?channel=25.05&&query={}',
                       'yt'     : 'https://www.youtube.com/results?search_query={}',
                       'od'     : 'https://odysee.com/$/search?q={}',
                       'gh'     : 'https://github.com/search?q={}&type=repositories',
                       'wk'     : 'https://en.wikipedia.org/w/index.php?fulltext=1&search={}&title=Special%3ASearch&ns0=1',
                      }

config.set('completion.open_categories',["searchengines","quickmarks","bookmarks"])

config.set('downloads.location.directory', '~/Downloads')

config.set('fileselect.handler', 'external')
config.set('fileselect.single_file.command', ['alacritty','-e','ranger','--choosefile={}'])
config.set('fileselect.multiple_files.command', ['alacritty','-e','ranger','--choosefiles={}'])
config.set('fileselect.folder.command', ['alacritty','-e','ranger','--choosedir={}'])

# bindings from doom emacs
config.bind('<Alt-x>', 'cmd-set-text :')
# config.bind('<Space>.', 'cmd-set-text :')
config.bind('<Space>b', 'bookmark-list')
config.bind('<Space>h', 'history')
config.bind('<Space>gh', 'open -t https://github.com')
config.bind('<Space>gl', 'open -t https://gitlab.com')
config.bind('<Space>yt', 'open -t https://youtube.com')
config.bind('<Space>cg', 'open -t https://chatgpt.com')
config.bind('<Space>m', 'open -t https://messenger.com')
if (secretsExists):
    config.bind('<Space>gg', 'open '+qutesecrets.mygiteadomain)
# config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
# config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
# config.bind('<Ctrl-p>', 'fake-key <Up>', mode='normal')
# config.bind('<Ctrl-n>', 'fake-key <Down>', mode='normal')
# config.bind('<Ctrl-p>', 'fake-key <Up>', mode='insert')
# config.bind('<Ctrl-n>', 'fake-key <Down>', mode='insert')
# config.bind('<Ctrl-p>', 'fake-key <Up>', mode='passthrough')
# config.bind('<Ctrl-n>', 'fake-key <Down>', mode='passthrough')

# bindings from vimium
config.bind('t', 'open -t')
config.bind('x', 'tab-close')
# config.bind('yf', 'hint links yank')
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev')
config.unbind('J')
config.unbind('K')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')

# passthrough bindings
config.bind('<Shift-Escape>', 'mode-leave', mode='passthrough')
config.bind('<Ctrl-T>', 'open -t', mode='passthrough')
config.bind('<Ctrl-W>', 'tab-close', mode='passthrough')
config.bind('<Ctrl-Tab>', 'tab-next', mode='passthrough')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev', mode='passthrough')
config.bind('<Ctrl-B>', 'cmd-set-text -s :quickmark-load -t', mode='passthrough')
config.bind('<Ctrl-O>', 'cmd-set-text -s :open -t', mode='passthrough')
config.bind('<Ctrl-F>', 'cmd-set-text /', mode='passthrough')
config.bind('<Ctrl-R>', 'reload', mode='passthrough')
config.unbind('<Ctrl-X>')
config.unbind('<Ctrl-A>')
config.unbind('d')

# spawn external programs
config.bind(',m', 'hint links spawn mpv {hint-url}')
config.bind(',co', 'spawn container-open')
config.bind(',cf', 'hint links userscript container-open')

# TODO stylix user CSS
# current_stylesheet_directory = '~/.config/qutebrowser/themes/'
# current_stylesheet = base16_theme+'-all-sites.css'
# current_stylesheet_path = current_stylesheet_directory + current_stylesheet
# config.set('content.user_stylesheets', current_stylesheet_path)
#config.bind(',s', 'set content.user_stylesheets \'\' ')
#config.bind(',S', 'set content.user_stylesheets '+current_stylesheet_path)

# theming
# c.colors.completion.fg = base05
# c.colors.completion.odd.bg = base01
# c.colors.completion.even.bg = base00
# c.colors.completion.category.fg = base0A
# c.colors.completion.category.bg = base00
# c.colors.completion.category.border.top = base00
# c.colors.completion.category.border.bottom = base00
# c.colors.completion.item.selected.fg = base05
# c.colors.completion.item.selected.bg = base02
# c.colors.completion.item.selected.border.top = base02
# c.colors.completion.item.selected.border.bottom = base02
# c.colors.completion.item.selected.match.fg = base0B
# c.colors.completion.match.fg = base0B
# c.colors.completion.scrollbar.fg = base05
# c.colors.completion.scrollbar.bg = base00
# c.colors.contextmenu.disabled.bg = base01
# c.colors.contextmenu.disabled.fg = base04
# c.colors.contextmenu.menu.bg = base00
# c.colors.contextmenu.menu.fg =  base05
# c.colors.contextmenu.selected.bg = base02
# c.colors.contextmenu.selected.fg = base05
# c.colors.downloads.bar.bg = base00
# c.colors.downloads.start.fg = base00
# c.colors.downloads.start.bg = base0D
# c.colors.downloads.stop.fg = base00
# c.colors.downloads.stop.bg = base0C
# c.colors.downloads.error.fg = base08
# c.colors.hints.fg = base00
# c.colors.hints.bg = base0A
# c.colors.hints.match.fg = base05
# c.colors.keyhint.fg = base05
# c.colors.keyhint.suffix.fg = base05
# c.colors.keyhint.bg = base00
# c.colors.messages.error.fg = base00
# c.colors.messages.error.bg = base08
# c.colors.messages.error.border = base08
# c.colors.messages.warning.fg = base00
# c.colors.messages.warning.bg = base0E
# c.colors.messages.warning.border = base0E
# c.colors.messages.info.fg = base05
# c.colors.messages.info.bg = base00
# c.colors.messages.info.border = base00
# c.colors.prompts.fg = base05
# c.colors.prompts.border = base00
# c.colors.prompts.bg = base00
# c.colors.prompts.selected.bg = base02
# c.colors.prompts.selected.fg = base05
# c.colors.statusbar.normal.fg = base0B
# c.colors.statusbar.normal.bg = base00
# c.colors.statusbar.insert.fg = base00
# c.colors.statusbar.insert.bg = base0D
# c.colors.statusbar.passthrough.fg = base00
# c.colors.statusbar.passthrough.bg = base0C
# c.colors.statusbar.private.fg = base00
# c.colors.statusbar.private.bg = base01
# c.colors.statusbar.command.fg = base05
# c.colors.statusbar.command.bg = base00
# c.colors.statusbar.command.private.fg = base05
# c.colors.statusbar.command.private.bg = base00
# c.colors.statusbar.caret.fg = base00
# c.colors.statusbar.caret.bg = base0E
# c.colors.statusbar.caret.selection.fg = base00
# c.colors.statusbar.caret.selection.bg = base0D
# c.colors.statusbar.progress.bg = base0D
# c.colors.statusbar.url.fg = base05
# c.colors.statusbar.url.error.fg = base08
# c.colors.statusbar.url.hover.fg = base05
# c.colors.statusbar.url.success.http.fg = base0C
# c.colors.statusbar.url.success.https.fg = base0B
# c.colors.statusbar.url.warn.fg = base0E
# c.colors.tabs.bar.bg = base00
# c.colors.tabs.indicator.start = base0D
# c.colors.tabs.indicator.stop = base0C
# c.colors.tabs.indicator.error = base08
# c.colors.tabs.odd.fg = base05
# c.colors.tabs.odd.bg = base01
# c.colors.tabs.even.fg = base05
# c.colors.tabs.even.bg = base00
# c.colors.tabs.pinned.even.bg = base0C
# c.colors.tabs.pinned.even.fg = base07
# c.colors.tabs.pinned.odd.bg = base0B
# c.colors.tabs.pinned.odd.fg = base07
# c.colors.tabs.pinned.selected.even.bg = base02
# c.colors.tabs.pinned.selected.even.fg = base05
# c.colors.tabs.pinned.selected.odd.bg = base02
# c.colors.tabs.pinned.selected.odd.fg = base05
# c.colors.tabs.selected.odd.fg = base05
# c.colors.tabs.selected.odd.bg = base02
# c.colors.tabs.selected.even.fg = base05
# c.colors.tabs.selected.even.bg = base02

# c.fonts.default_family = font
c.fonts.default_size = '14pt'

# c.fonts.web.family.standard = font
# c.fonts.web.family.serif = font
# c.fonts.web.family.sans_serif = font
# c.fonts.web.family.fixed = font
# c.fonts.web.family.fantasy = font
# c.fonts.web.family.cursive = font
  '';

  #   home.file.".config/qutebrowser/containers".text = ''
  # Teaching
  # Tech
  # Gamedev
  # Bard
  #   '';

  home.file.".config/qutebrowser/qute-home.html".text = generateHomepage "Default" "Roboto" config;
  # home.file.".config/qutebrowser/qute-home.html".text = generateHomepage "Default" userSettings.font config;
  # home.file.".config/qutebrowser/logo.png".source = ./qutebrowser-logo.png;
  # home.file.".browser/Teaching/config/qute-home.html".text = generateHomepage "Teaching" userSettings.font config;
  # home.file.".browser/Teaching/config/logo.png".source = ./qutebrowser-logo.png;
  # home.file.".browser/Tech/config/qute-home.html".text = generateHomepage "Tech" userSettings.font config;
  # home.file.".browser/Tech/config/logo.png".source = ./qutebrowser-logo.png;
  # home.file.".browser/Gaming/config/qute-home.html".text = generateHomepage "Gaming" userSettings.font config;
  # home.file.".browser/Gaming/config/logo.png".source = ./qutebrowser-logo.png;
  # home.file.".browser/Gamedev/config/qute-home.html".text = generateHomepage "Gamedev" userSettings.font config;
  # home.file.".browser/Gamedev/config/logo.png".source = ./qutebrowser-logo.png;
  # home.file.".browser/Bard/config/qute-home.html".text = generateHomepage "Bard" userSettings.font config;
  # home.file.".browser/Bard/config/logo.png".source = ./qutebrowser-logo.png;

}
