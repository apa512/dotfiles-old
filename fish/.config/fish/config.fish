alias ga='git add'
alias gc='git commit'
alias gl='git pull'
alias gp='git push'
alias gco='git checkout'
alias gst='git status'

set -gx PATH $PATH (home_path 'bin')
set -gx VISUAL 'vim'

set -gx PATH $PATH (home_path '.gem/ruby/2.6.0/bin')

source (home_path '.config/fish/includes/secrets.fish')

eval (direnv hook fish)
