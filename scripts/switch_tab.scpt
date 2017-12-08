on run argv
  set desiredProfile to item 1 of argv
  set foundProfile to false
  tell application "iTerm"
      tell current window
          repeat with aTab in tabs
              set profName to profile name of current session of aTab
              if profName is desiredProfile then
                  select aTab
                  set foundProfile to true
                  exit repeat
              end if
          end repeat
          if not foundProfile then
              create tab with profile desiredProfile
              select
              tell current session
                  write text "tmux attach"
              end tell
          end if
      end tell
  end tell
end run
