git_prompt() {
    inside_repo="$(git rev-parse --is-inside-work-tree)"
    if [[ "$inside_repo" -eq "true" ]]
    then
        echo "[$(git branch --show-current)]"
    fi
}

export PS1='${PROMPT_START@P}\[\e[${PROMPT_COLOR}${PROMPT_HIGHLIGHT:+;$PROMPT_HIGHLIGHT}m\]$(git_prompt)${PROMPT_USERHOST@P}\[\e[0m\]${PROMPT_SEPARATOR@P}\[\e[${PROMPT_DIR_COLOR-${PROMPT_COLOR}}${PROMPT_HIGHLIGHT:+;$PROMPT_HIGHLIGHT}m\]${PROMPT_DIRECTORY@P}\[\e[0m\]${PROMPT_END@P}\$\[\e[0m\] '
