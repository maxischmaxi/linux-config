#! /usr/bin/env bash

DIRECTION=$1
HYPR_DIRECTION=l

case $1 in
    "west")
        PANE_DIRECTION="left"
        DIRECTION_FLAG="-L"
        HYPR_DIRECTION="l"
        ;;
    "south")
        PANE_DIRECTION="bottom"
        DIRECTION_FLAG="-D"
        HYPR_DIRECTION="d"
        ;;
    "north")
        PANE_DIRECTION="top"
        DIRECTION_FLAG="-U"
        HYPR_DIRECTION="u"
        ;;
    "east")
        PANE_DIRECTION="right"
        DIRECTION_FLAG="-R"
        HYPR_DIRECTION="r"
        ;;
esac

if [[ $(tmux display-message -p "#{pane_at_${PANE_DIRECTION}}") == "0" ]]; then
    tmux select-pane ${DIRECTION_FLAG} &>/dev/null
else
    OS=$(uname)
    if [[ "$OS" == "Linux" ]]; then
        if command -v hyprctl &>/dev/null; then
            # it is confusing to be able to move out of tmux but not back in
            # hyprctl dispatch movefocus ${HYPR_DIRECTION} >/dev/null 2>&1 || true
            exit 0
        else
            exit 0
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        yabai -m window --focus ${DIRECTION} >/dev/null 2>&1 || true
    else
        exit 0
    fi
fi
