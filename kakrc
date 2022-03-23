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

# Update colorscheme
colorscheme gruvbox-dark
set-face global comment "rgb:928374" # disable comment highlight

# Overwrite default fzf parameters for preview & search program
hook global ModuleLoaded fzf %{
        set-option global fzf_highlight_command "bat"
}
hook global ModuleLoaded fzf-file %{
        set-option global fzf_file_command 'rg'
}

hook global ModuleLoaded fzf-grep %{
    set-option global fzf_grep_command "rg"
}

# Setup LSP support
eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
hook global WinSetOption filetype=(python|go) %{
        lsp-enable-window
}

set-option global lsp_config %{
        [language.python.settings._]
        "pyls.configurationSources" = ["flake8"]
}

# Auto formatting & import organizing on save for Golang files
hook global BufWritePre .*[.]go %{
        try %{ lsp-code-action-sync '^Organize Imports$' }
            lsp-formatting-sync
}

# Add shortcut for lsp mode ,l
map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"

