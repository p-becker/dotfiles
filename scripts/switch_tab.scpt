on run argv
  set dotfilesPath to item 1 of argv
  set desiredProfile to item 2 of argv
  set sessionFile to dotfilesPath & "/vim/Session.vim"
  set vimrc to dotfilesPath & "/vim/.vimrc"
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
          end if
          tell current session
              write text "VIMUSER=" & desiredProfile & " nvim -S " & sessionFile & " -u " & vimrc
          end tell
      end tell
  end tell
end run
