

# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew (Apple Silicon)
if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Your own scripts
export PATH="$HOME/bin:$PATH"
