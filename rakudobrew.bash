_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local commands='
    current
    list
    list-available
    build
    build-panda
    triple
    rehash
    switch
    nuke
    self-upgrade
    test
    exec
    init
    shell
    local
    global
    version
    versions
    which
    whence
  '
  local backends='
    jvm
    moar
    pre-glr
  '

  case "$COMP_CWORD" in
    1)
      COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
      ;;
    *)
      case "${COMP_WORDS[1]}" in
        build)
          case "$cur" in
            -*)
              COMPREPLY=('--configure-opts=')
              compopt -o nospace
              ;;
            *)
              COMPREPLY=( $(compgen -W "$backends all" -- "$cur") )
              ;;
          esac
          ;;
        switch)
          COMPREPLY=( $(compgen -W "$backends" -- "$cur") )
          ;;
        nuke)
          COMPREPLY=( $(compgen -W "$backends" -- "$cur") )
          ;;
        test)
          COMPREPLY=( $(compgen -W "$backends all" -- "$cur") )
          ;;
        local|global)
          versions="$(rakudobrew versions | cut -c3-)"
          COMPREPLY=( $(compgen -W "$versions" -- "$cur") )
          ;;
        which)
          local version="$(rakudobrew version)"
          local prefix="$(type -P rakudobrew)"; prefix="${prefix%%/bin/*}"
          local paths="
            $([ -d "$prefix/$version/install/bin" ] && ls "$prefix/$version/install/bin")
            $([ -d "$prefix/$version/install/share/perl6/site/bin" ] && ls "$prefix/$version/install/share/perl6/site/bin")
          "
          COMPREPLY=( $(compgen -W "$paths" -- "$cur") )
          ;;
      esac
      ;;
  esac
}
complete -F _rakudobrew rakudobrew
