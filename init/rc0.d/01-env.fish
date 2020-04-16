#!/usr/bin/env fish

if not set -q FD_CHECKLIST_HOME
  set -U FD_CHECKLIST_HOME $HOME/.config/checklists
end

if not set -q FD_CHECKLIST_DEFINITIONS_HOME
  set -U FD_CHECKLIST_DEFINITIONS_HOME $FD_CHECKLIST_HOME/checklist-definitions
end

if not set -q FD_CHECKLIST_INSTANCES_HOME
  set -U FD_CHECKLIST_INSTANCES_HOME $FD_CHECKLIST_HOME/active-checklists
end

if not set -q FD_CHECKLIST_ARCHIVE_HOME
  set -U FD_CHECKLIST_ARCHIVE_HOME $FD_CHECKLIST_HOME/inactive-checklists
end

if not set -q FD_CHECKLIST_CURRENT_CHECKLIST
  set -U FD_CHECKLIST_CURRENT_CHECKLIST $FD_CHECKLIST_INSTANCES_HOME/startup.md
  echo -e "# welcome to fishdots checklist\n- [ ] checkout the docs\n" > $FD_CHECKLIST_CURRENT_CHECKLIST
end

if not set -q FD_CHECKLIST_CURRENT_DEFINITION
  set -U FD_CHECKLIST_CURRENT_DEFINITION $FD_CHECKLIST_DEFINITIONS_HOME/my-first-checklist.md
  echo -e "# welcome to fishdots checklists\n- [ ] put your checklist items here\n" > $FD_CHECKLIST_CURRENT_DEFINITION
end

function checklist_greeting --on-event on_fish_greeting
  set -l num_active_lists (find $FD_CHECKLIST_INSTANCES_HOME -iname "*.md" | wc -l)
  echo There are $num_active_lists active checklists currently
end
