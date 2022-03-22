# setup pluging manager
evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}
plug "andreyorst/plug.kak" noload


plug "andreyorst/fzf.kak" config %{
        map -docstring 'fzf mode' global normal '<c-p>' ': fzf-mode<ret>'
} 

colorscheme gruvbox-dark
set-face global comment "rgb:928374" # disable comment highlight

hook global ModuleLoaded fzf %{
        set-option global fzf_highlight_command "bat"
}
hook global ModuleLoaded fzf-file %{
        set-option global fzf_file_command 'rg --files'
}

hook global ModuleLoaded fzf-grep %{
    set-option global fzf_grep_command "rg"
}

