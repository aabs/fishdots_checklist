#!/usr/bin/env fish

define_command chkl "fishdots plugin for doing useful things with git"

define_subcommand_nonevented chkl archive chkl_archive "select and archive an active instance"
define_subcommand_nonevented chkl archiveall chkl_archiveall "archive all active instances"
define_subcommand_nonevented chkl define chkl_define "create new checklist and open in editor"
define_subcommand_nonevented chkl edit chkl_edit "edit the current checklist instance"
define_subcommand_nonevented chkl editdef chkl_editdef "edit the current checklist definition"
define_subcommand_nonevented chkl find chkl_find "find an active checklist"
define_subcommand_nonevented chkl home chkl_home "change to the checklist definitions folder"
define_subcommand_nonevented chkl ls chkl_ls "list active checklists"
define_subcommand_nonevented chkl lsar chkl_lsar "list inactive checklists"
define_subcommand_nonevented chkl open chkl_open "open for an active checklist for editing"
define_subcommand_nonevented chkl opendef chkl_opendef "open a checklist definition for editing"
define_subcommand_nonevented chkl start chkl_start "select and start checklist and open in editor"
define_subcommand_nonevented chkl tasks chkl_nierr "list next task from active checklists"

function chkl_nierr
    echo "Sorry, that command has not been implemented yet"
end

function chkl_home
    cd $FD_CHECKLIST_DEFINITIONS_HOME
end

function chkl_ls
    fishdots_find $FD_CHECKLIST_INSTANCES_HOME "*.md"
end

function chkl_lsar
    fishdots_find $FD_CHECKLIST_ARCHIVE_HOME "*.md"
end

function chkl_find -a name_pattern
    fishdots_find_select $FD_CHECKLIST_INSTANCES_HOME $name_pattern
end

function chkl_search -a pattern
    fishdots_search_select $FD_CHECKLIST_INSTANCES_HOME $pattern
end

function chkl_open -a search_pattern -d "find active checklist matching <pattern>, and edit"
    fd_file_selector $FD_CHECKLIST_INSTANCES_HOME "*.md"
    if set -q fd_selected_item
        _chkl_select_inst $fd_selected_item
        chkl_edit
    end
end

function chkl_start -a search_pattern -d "find checklist definition matching <pattern>, spawn a new instance and edit"
    fd_file_selector $FD_CHECKLIST_DEFINITIONS_HOME "*.md"
    if set -q fd_selected_item
        chkl_spawn $fd_selected_item
    end
end

function chkl_opendef -a search_pattern -d "file name search for a definition matching <pattern>, opens selection in default editor"
    fd_file_selector $FD_CHECKLIST_DEFINITIONS_HOME "*.md"
    if set -q fd_selected_item
        _chkl_select_def $fd_selected_item
        chkl_editdef
    end
end

function chkl_edit -d "edit the current checklist instance"
    if set -q EDITOR
        eval '$EDITOR "'$FD_CHECKLIST_CURRENT_CHECKLIST'"'
    else
        nvim $FD_CHECKLIST_CURRENT_CHECKLIST
    end
end

function chkl_editdef -a file_path -d "edit the current definition"
    if set -q EDITOR
        eval '$EDITOR "'$FD_CHECKLIST_CURRENT_DEFINITION'"'
    else
        nvim $FD_CHECKLIST_CURRENT_DEFINITION
    end
end

function chkl_define -a name -d "creates a new definition of a checklist"
    set -l slug (to_slug $name)
    set -l target_path "$FD_CHECKLIST_DEFINITIONS_HOME/$slug"
    # if the definition already exists, edit that instead
    if test -e $target_path
        set -U FD_CHECKLIST_CURRENT_DEFINITION "$target_path"
    else
        touch $target_path
    end

    chkl_editdef
end

function chkl_spawn -a definition_path -d "creates an instance of the checklist"
    set -l name (basename $definition_path)
    set -l ts (date +"%Y%m%d%H%M")
    set -l slug (to_slug "$ts-$name")
    set -l target_path "$FD_CHECKLIST_INSTANCES_HOME/$slug"

    # if the definition already exists, edit that instead
    if not test -e $target_path
        cp "$definition_path" "$target_path"
    end

    _chkl_select_inst "$target_path"
    chkl_edit $FD_CHECKLIST_CURRENT_CHECKLIST
end

function _chkl_select_inst -a inst_path -d "choose working checklist instance"
  if test -e $inst_path
    set -U FD_CHECKLIST_CURRENT_CHECKLIST $inst_path
  end
end

function _chkl_select_def -a def_path -d "choose working definition"
  if test -e $inst_path
    set -U FD_CHECKLIST_CURRENT_DEFINITION $inst_path
  end
end

function _chkl_archive -a inst_path -d "archive selected file"
    mv $inst_path $FD_CHECKLIST_ARCHIVE_HOME
    echo (basename $inst_path) "archived"
end

function chkl_archive -d "select an active checklist for archival"
    fd_file_selector $FD_CHECKLIST_INSTANCES_HOME "*.md"
    if set -q fd_selected_item
        _chkl_archive $fd_selected_item
    end
end

function chkl_archiveall -d "archive all active checklists"
  for inst in (fishdots_find $FD_CHECKLIST_INSTANCES_HOME "*.md")
    _chkl_archive $inst
  end
end