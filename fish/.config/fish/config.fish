source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

if [ -z $WAYLAND_DISPLAY ] && [ $XDG_VTNR -eq 1 ]
    niri-session -l
end

set -U fish_color_normal "#b9b1bc" # default color
set -U fish_color_command "#c488fb" # commands like echo
set -U fish_color_keyword "#c488fb" # keywords like if - this falls back on the command color if unset
set -U fish_color_quote "#00fbfd" # quoted text like "abc"
set -U fish_color_redirection "#f9f972" # IO redirections like >/dev/null
set -U fish_color_end "#f9f972" # process separators like ';' and '&'
set -U fish_color_error "#e60a70" # syntax errors
set -U fish_color_param "#f2f2e3" # ordinary command parameters
set -U fish_color_comment "#7f7094" # comments like '# important'
set -U fish_color_selection normal # selected text in vi visual mode
set -U fish_color_operator "#f9f972" # parameter expansion operators like '*' and '~'
set -U fish_color_escape "#00b0b1" # character escapes like 'n' and 'x70'
set -U fish_color_autosuggestion "#b9b1bc" # autosuggestions (the proposed rest of a command)
set -U fish_color_cwd normal # the current working directory in the default prompt
set -U fish_color_user normal # the username in the default prompt
set -U fish_color_host normal # the hostname in the default prompt
set -U fish_color_host_remote normal # the hostname in the default prompt for remote sessions (like ssh)
set -U fish_color_cancel normal # the '^C' indicator on a canceled command
set -U fish_color_search_match normal # history search matches and selected pager items (background only)
set -U fish_pager_color_progress normal # the progress bar at the bottom left corner
set -U fish_pager_color_background --background=normal # the background color of a line
set -U fish_pager_color_prefix "#f2f2e3" --underline # the prefix string, i.e. the string that is to be completed
set -U fish_pager_color_completion "#b9b1bc" # the completion itself, i.e. the proposed rest of the string
set -U fish_pager_color_description "#b9b1bc" # the completion description
set -U fish_pager_color_selected_background --background=normal # background of the selected completion
set -U fish_pager_color_selected_prefix "#0ae4a4" --bold --underline # prefix of the selected completion
set -U fish_pager_color_selected_completion "#0ae4a4" # suffix of the selected completion
set -U fish_pager_color_selected_description "#f2f2e3" # description of the selected completion
set -U fish_pager_color_secondary_background normal # background of every second unselected completion
set -U fish_pager_color_secondary_prefix "#f2f2e3" --underline # prefix of every second unselected completion
set -U fish_pager_color_secondary_completion "#b9b1bc" # suffix of every second unselected completion
set -U fish_pager_color_secondary_description "#b9b1bc" # description of every second unselected completion

# EDITOR
set -gx EDITOR code
#EDITOR end

# Starship
starship init fish | source
# Starship end

# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
# yazi end

# fzf
fzf --fish | source
# fzf end

# fnm
fnm env --use-on-cd --shell fish | source
set -gx PATH /run/user/1000/fnm_multishells/40311_1760717545792/bin $PATH
set -gx FNM_MULTISHELL_PATH /run/user/1000/fnm_multishells/40311_1760717545792
set -gx FNM_VERSION_FILE_STRATEGY local
set -gx FNM_DIR "~/.local/share/fnm"
set -gx FNM_LOGLEVEL info
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
set -gx FNM_COREPACK_ENABLED false
set -gx FNM_RESOLVE_ENGINES true
set -gx FNM_ARCH x64
# fnm end

# pnpm
set -gx PNPM_HOME "~/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# zoxide
zoxide init --cmd cd fish | source
# zoxide end

# aliases
alias pp=pnpm
alias ppx=pnpx
alias nmi=nmcli
alias wp=wpctl
