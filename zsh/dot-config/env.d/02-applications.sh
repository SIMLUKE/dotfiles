#!/bin/bash
# Default application configuration

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Browser
export BROWSER='zen-browser'

# Terminal
export TERMINAL='kitty'

# Other application settings
export CHROME_EXECUTABLE="$(which chromium 2>/dev/null || echo '')"
export QT_QPA_PLATFORM='xcb'
export RANGER_LOAD_DEFAULT_RC='FALSE'
