#!/usr/bin/env fish

# this depends on the env variable `FD_NOTES_HOME` being set.
# that variable is set in phase 0 of the fishdots_notes plugin
# therefore we initiate these env vars after it has been set (phase 1)

if not set -q FD_CHECKLISTS_HOME
  set -U FD_CHECKLISTS_HOME $FD_NOTES_HOME/0000-meta/01-checklists
end

if not set -q FD_CHECKLIST_INSTANCES_HOME
  set -U FD_CHECKLIST_INSTANCES_HOME $FD_NOTES_HOME/1000-personal/12-active-checklists
end
