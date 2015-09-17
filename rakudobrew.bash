_rakudobrew() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
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
  elif [ "$COMP_CWORD" -ge 2 ]; then
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
  fi
}
complete -F _rakudobrew rakudobrew
