_rakudobrew_commands() {
  local commands="$(
    rakudobrew help |\
    awk '{
      for (i = 1; i <= NF; ++i)
        if ($i == "rakudobrew")
          print $(i + 1);
    }'
  ) help"
  COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}

_rakudobrew_build() {
  local backends="$(
    rakudobrew help |\
    awk '
      $2 == "build" {
        gsub(/\|/, "\n", $3)
        print($3)
      }
      $2 ~ "build-" {
        gsub(/build-/, "", $2)
        print($2)
      }
    '
  ) --configure-opts="
  COMPREPLY=( $(compgen -W "$backends $*" -- "$cur") )
}

_rakudobrew_versions() {
  local versions="$(rakudobrew versions | cut -c3-)"
  COMPREPLY=( $(compgen -W "$versions $*" -- "$cur") )
}

_rakudobrew_exec() {
  case "$COMP_CWORD" in
    2) _rakudobrew_which ;;
    *) _command_offset 2 ;;
  esac
}

_rakudobrew_which() {
  local version="$(rakudobrew version)"
  local prefix="$(type -P rakudobrew | sed 's#/bin/[^/]*$##')"

  local programs="$(
    ls "$prefix/$version/install/bin" 2> /dev/null
    ls "$prefix/$version/install/share/perl6/site/bin" 2> /dev/null
  )"
  COMPREPLY=( $(compgen -W "$programs" -- "$cur") )
}

_rakudobrew_whence() {
  local versions="$(rakudobrew versions | cut -c3-)"
  local prefix="$(type -P rakudobrew | sed 's#/bin/[^/]*$##')"

  local programs="$(
    for version in $versions; do
      ls "$prefix/$version/install/bin" 2> /dev/null
      ls "$prefix/$version/install/share/perl6/site/bin" 2> /dev/null
    done
  )"
  case "$COMP_CWORD" in
    2) COMPREPLY=( $(compgen -W "$programs --path" -- "$cur") ) ;;
    *) COMPREPLY=( $(compgen -W "$programs" -- "$cur") ) ;;
  esac
}

_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  case "$COMP_CWORD" in
    1) _rakudobrew_commands ;;
    *) case "${COMP_WORDS[1]}" in
         build)  _rakudobrew_build ;;
         switch) _rakudobrew_versions ;;
         nuke)   _rakudobrew_versions ;;
         test)   _rakudobrew_versions 'all' ;;
         exec)   _rakudobrew_exec ;;
         shell)  _rakudobrew_versions '--unset' ;;
         local)  _rakudobrew_versions ;;
         global) _rakudobrew_versions ;;
         which)  _rakudobrew_which ;;
         whence) _rakudobrew_whence ;;
       esac ;;
  esac
  [[ ${COMPREPLY[0]} == *= ]] && compopt -o nospace
}
complete -F _rakudobrew rakudobrew
