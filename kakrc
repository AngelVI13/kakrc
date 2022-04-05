# Show number lines relatively.
add-highlighter global/nu number-lines -hlcursor -relative
 
# Update colorscheme
colorscheme gruvbox-dark
set-face global comment "rgb:928374" # disable comment highlight

# yank should go to system clipboard as well as the kakoune register.
hook global NormalKey y|d|c %{ nop %sh{
   printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

# use 'p or 'P to paste from the system clipboard.
map global user P '!xsel --output --clipboard<ret>'
map global user p '<a-!>xsel --output --clipboard<ret>'

# jj instead of escape key
hook global InsertChar j %{ try %{
  exec -draft hH <a-k>jj<ret> d
  exec <esc>
}}

# highlight TODO, FIXME, etc.
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|BUG|DEBUG|TBD|HACK)\b 0:default+rb

# setup pluging manager & plugins
evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}
plug "andreyorst/plug.kak" noload


plug "andreyorst/fzf.kak" config %{
        # map -docstring 'fzf mode' global normal '<c-p>' ': fzf-mode<ret>'
        map global user f %{: fzf-mode<ret>} -docstring "FZF mode"
} 

# Overwrite default fzf parameters for preview & search program
hook global ModuleLoaded fzf %{
        set-option global fzf_highlight_command "bat"
}
hook global ModuleLoaded fzf-file %{
        # Custom file command is used cause sometimes i need to open
	# files which are part of gitignore etc.
        set-option global fzf_file_command 'rg'
}

hook global ModuleLoaded fzf-grep %{
    set-option global fzf_grep_command "rg"
}

# Setup LSP support
eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
hook global WinSetOption filetype=(python|go) %{
        lsp-enable-window
        # NOTE: this is buggy
        # lsp-inlay-diagnostics-enable global
}

# Auto formatting & import organizing on save for Golang files
hook global BufWritePre .*[.]go %{
        try %{ lsp-code-action-sync '^Organize Imports$' }
            lsp-formatting-sync
}

# Add shortcut for lsp mode ,l
map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"

