_rakudobrew_which() {
  local version="$(rakudobrew version)"
  local prefix="$(type -P rakudobrew | sed 's#/bin/[^/]*$##')"

  local programs="
    $(ls "$prefix/$version/install/bin" 2> /dev/null)
    $(ls "$prefix/$version/install/share/perl6/site/bin" 2> /dev/null)
  "
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
  COMPREPLY=( $(compgen -W "$programs" -- "$cur") )
}

_rakudobrew_commands() {
  local commands="$(
    rakudobrew help |\
    awk '{
      for (i = 1; i <= NF; ++i)
        if ($i == "rakudobrew")
          print $(i + 1);
    }'
  )"
  COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}

_rakudobrew_backends() {
  local all=''
  [ "$1" = '--allow-all' ] && all='all'
  local backends="
    jvm
    moar
    pre-glr
    $all
  "
  COMPREPLY=( $(compgen -W "$backends" -- "$cur") )
}

_rakudobrew_versions() {
  local versions="$(rakudobrew versions | cut -c3-)"
  COMPREPLY=( $(compgen -W "$versions" -- "$cur") )
}

_rakudobrew_build() {
  case "$cur" in
    -*)
      COMPREPLY=('--configure-opts=')
      compopt -o nospace
      ;;
    *)
      _rakudobrew_backends
      ;;
  esac
}

_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  case "$COMP_CWORD" in
    1) _rakudobrew_commands ;;
    *) case "${COMP_WORDS[1]}" in
        build)  _rakudobrew_build ;;
        switch) _rakudobrew_backends ;;
        nuke)   _rakudobrew_backends ;;
        test)   _rakudobrew_backends --allow-all ;;
        local)  _rakudobrew_versions ;;
        global) _rakudobrew_versions ;;
        which)  _rakudobrew_which ;;
        whence) _rakudobrew_whence ;;
      esac ;;
  esac
}
complete -F _rakudobrew rakudobrew
