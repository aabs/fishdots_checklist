function checklist
  if test 0 -eq (count $argv)
    checklist_help
    return
  end
  switch $argv[1]
    case home
      cd $FD_CHECKLISTS_HOME
    case ls
      _checklist_find '*.md'
    case tasks
      checklist_tasks
    case edit
      checklist_edit $argv[2]
    case find
      checklist_find $argv[2]
    case search
      checklist_search $argv[2]
    case create
      checklist_create $argv[2]
    case pcreate
      checklist_create_project_checklist $argv[2]
    case save
      checklist_save
    case sync
      checklist_sync
    case move
      checklist_move $argv[2..3]
    case '*'
      checklist_help
  end
end

function checklist_help -d "display usage info"
  echo "Fishdots Checklists Usage"
  echo "===================="
  echo "checklist <command> [options] [args]"
  echo ""
  echo "checklist edit pattern"
  echo "  edit the checklist identified by the path"
  echo ""
  echo "checklist find pattern"
  echo "  find the checklist by searching file names"
  echo ""
  echo "checklist search pattern"
  echo "  perform a full text search for patterns"
  echo ""
  echo "checklist create title"
  echo "  create a new checklist"
  echo ""
  echo "checklist pcreate title"
  echo "  create a new checklist within a project area"
  echo ""
  echo "checklist save"
  echo "  save any new or modified Checklists locally"
  echo ""
  echo "checklist move"
  echo "  explain,,,"
  echo ""
  echo "checklist sync"
  echo "  synchronise Checklists with origin git repo"
  echo ""
  echo "checklist home"
  echo "  cd to the Checklists directory"
  echo ""
  echo "checklist help"
  echo "  EXPL"
end

function checklist_find -a search_pattern -d "file name search for <pattern>, opens selection in default editor"
  set matches (_checklist_find $search_pattern)
  if test 1 -eq (count $matches)
    checklist_instantiate $matches[1]
    return
  end
  set -g dcmd "dialog --stdout --no-tags --menu 'select the file to instantiate' 20 60 20 " 
  set c 1
  for option in $matches
    set l (get_file_relative_path $option)
    set -g dcmd "$dcmd $c '$l'"
    set c (math $c + 1)
  end
  set choice (eval "$dcmd")
  clear
  if test $status -eq 0
    checklist_instantiate $matches[$choice]
  end
end

function _checklist_find -a pattern -d "find note by note name"
    find $FD_CHECKLISTS_HOME/ -iname "*$pattern*"
end

function checklist_instantiate -a name -d "creates and instance of the checklist"
  # get base name of checklist
  set -l checklist_bn (basename $name)
  # create path of instance file in destination folder
  set -l ts (date +"%Y%m%d%H%M")
  set -l target_path "$FD_CHECKLIST_INSTANCES_HOME/$ts-$checklist_bn"
  # copy file with date stamp
  cp "$name" "$target_path"
  # edit instance file
  vim "$target_path"
end
