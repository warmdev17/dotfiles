if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting
set -U EDITOR nvim
set -U SHELL fish
set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH
set -Ux HOMEBREW_NO_INSTALL_CLEANUP 1
set -Ux HOMEBREW_NO_ENV_HINTS 1
set -gx GTK_IM_MODULE ibus
set -gx QT_IM_MODULE ibus
set -gx XMODIFIERS @im=ibus
set -gx GLFW_IM_MODULE ibus
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

oh-my-posh init fish --config ~/catppuccin_mocha_test.omp.json | source
zoxide init fish | source

# alias
alias vim='nvim'
alias v='nvim'
alias npr='npm run dev'
alias pacman='sudo pacman'
alias reload='exec fish'
alias dev='cd ~/Workspace/'
alias home='cd ~'
alias rm='rm -rf'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
# git alias
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash
        git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

alias shutdown='systemctl poweroff'

alias nc='cd ~/.config/nvim'
# brew
alias bi='brew install'
alias bu='brew upgrade'
alias bui='brew uninstall'
alias bri='brew reinstall'
function lt
    if test (pwd) = $HOME
        eza -a --icons --tree --level=1
    else
        eza -a --icons --tree
    end
end

# tmux quick sessions open
function ta
    tmux attach -t $argv
end

function tn
    tmux new -s $argv
end

function tl
    tmux ls
end

function tk
    tmux kill-session -t $argv
end

function build
    set mode ""
    set file ""

    for arg in $argv
        switch $arg
            case -c
                set mode c
            case -p
                set mode cpp
            case "-*"
                # unknown flag, ignore
            case "*"
                set file $arg
        end
    end

    if test -z "$file" -o -z "$mode"
        echo "❌ Missing arguments. Usage:"
        echo "  build filename -c     # build filename.c with gcc"
        echo "  build filename -p     # build filename.cpp with g++"
        return 1
    end

    set output $file

    # Choose compiler
    if test $mode = c
        gcc $file.c -o $output
    else if test $mode = cpp
        g++ $file.cpp -o $output
    end

    if test $status -ne 0
        echo "❌ Compilation failed."
        return 1
    end

    # Determine how to run
    if string match -q "/*" $output
        set run_cmd $output
    else
        set run_cmd ./$output
    end

    $run_cmd
end

# java build and run
function jbr --description "Compile and run a Java program"
    # Check if an argument was provided
    if test -z "$argv[1]"
        echo "Usage: jbr <YourProgram.java>"
        return 1
    end

    set -l source_file "$argv[1]"

    # Extract the base name (e.g., "YourProgram" from "YourProgram.java")
    # This assumes a standard .java extension
    set -l class_name (basename $source_file .java)

    # Compile the Java file
    # The 'status' variable holds the exit status of the previous command.
    # A status of 0 means success.
    echo "Compiling $source_file..."
    javac $source_file
    if test $status -ne 0
        echo "Compilation failed."
        return 1
    end

    # Run the compiled Java class
    echo "Running $class_name..."
    java $class_name $argv[2..] # Pass any additional arguments to the Java program
end

# g++ build with lib
function buildwl
    g++ -o $argv[1] $argv[2] -l$argv[3] -l$argv[4] -l$argv[5] && ./$argv[1]
end

function yt-dl
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 "$argv[1]"
end

function cd..
    for item in (seq $argv)
        cd ..
    end
end

# Created by `pipx` on 2024-04-15 12:20:04
set PATH $PATH /home/warmdev/.local/bin

# pip install
alias ppm='~/venv/bin/pip'

# Set up fzf key bindings
fzf --fish | source
function cdfzf
    set -l dir (find $argv[1] -type d 2> /dev/null | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
alias fb="fzf --preview 'bat --style=numbers --color=always {}'"
alias fbn="fzf --preview 'bat --style=numbers --color=always {}' | xargs -n 1 nvim"

bind \co accept-autosuggestion
bind \cq exit
bind \ce yy
bind \cl lazygit
bind \cz zox

function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function zox
    set dir (zoxide query -l | fzf --height 40% --reverse --ansi )
    if test -n "$dir"
        cd "$dir"
    end
end

function sdv
    sudo env XDG_CONFIG_HOME=$HOME/.config nvim $argv
end

function livestream
    sudo modprobe v4l2loopback
    scrcpy --video-source=camera --camera-size=1920x1080 --camera-facing=back --v4l2-sink=/dev/video0 --no-audio --no-playback --max-fps=60
end

# alias for sddm debug
function debug
    sddm-greeter --test-mode --theme /usr/share/sddm/themes/citlali
end
