_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  case "$COMP_CWORD" in
    1)
      COMPREPLY=( $( compgen -W '
      current
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
      ' -- "$cur") )
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
              COMPREPLY=( $( compgen -W 'jvm glr moar all' -- "$cur") )
              ;;
          esac
          ;;
        switch)
          COMPREPLY=( $( compgen -W 'jvm glr moar' -- "$cur") )
          ;;
        nuke)
          COMPREPLY=( $( compgen -W 'jvm glr moar' -- "$cur") )
          ;;
        test)
          COMPREPLY=( $( compgen -W 'jvm glr moar all' -- "$cur") )
          ;;
      esac
      ;;
  esac
}
complete -F _rakudobrew rakudobrew
