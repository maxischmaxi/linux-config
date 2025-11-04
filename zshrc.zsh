export GOPATH="$HOME/go"

if [[ "$(uname)" == "Darwin" ]]; then
  export GOROOT="$(brew --prefix golang)/libexec"
  export PATH="$PATH:/Users/max/Library/Python/3.9/bin"
  export PATH="$PATH:/opt/homebrew/bin"
  export PATH="$PATH:/Library/TeX/texbin"
  alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

  # pnpm
  export PNPM_HOME="/Users/max/Library/pnpm"
  case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
  # pnpm end
else
  export GOROOT="/usr/lib/go"
  export PNPM_HOME="$HOME/.local/share/pnpm"
  case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

export GOPRIVATE=github.com/maxischmaxi/*
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$PWD/node_modules/.bin"
export PATH="$PATH:$HOME/emsdk"
export PATH="$PATH:$HOME/emsdk/upstream/emscripten"
export PATH="$PATH:$HOME/depot_tools"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH:$HOME/mongodb/bin"
export PATH="$PATH:$HOME/.config/bin"
export PATH="$PATH:$HOME/.local/bin"

export ENV=development
export ESLINT_USE_FLAT_CONFIG=false
export EDITOR="nvim"

export DYLD_LIBRARY_PATH="/usr/local/lib:$DYLD_LIBRARY_PATH"

source $HOME/.config/git-yolo-install.sh
source $HOME/.config/git-ai-install.sh
source $HOME/.config/.tokens

alias oldvim="vim"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias gs="git status"
alias gc="git commit"
alias ga="git add"
alias gca="git commit -a"
alias ca="calendar-export"
alias python="/opt/homebrew/bin/python3"

if [[ "$(uname)" == "Darwin" ]]; then
    export HOMEBREW_NO_ENV_HINTS=1
    . $HOMEBREW_PREFIX/etc/profile.d/z.sh
fi

[ -f $HOME/.config/fzf.zsh ] && source $HOME/.config/fzf.zsh

if [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi


