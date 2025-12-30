-- =============================================================================
-- Tmux Named Session - BetterTouchTool Action
-- =============================================================================
-- Opens a new iTerm2 tab and prompts for a session name,
-- then attaches to or creates that session.
--
-- This variant prompts for a name first, useful when you know
-- exactly what session you want.
--
-- Setup in BetterTouchTool:
--   1. Go to Keyboard Shortcuts
--   2. Add new shortcut (e.g., Cmd+Shift+Option+T)
--   3. Action: "Run Apple Script (blocking)"
--   4. Paste this script
-- =============================================================================

-- Prompt for session name
set sessionName to text returned of (display dialog "Tmux session name:" default answer "" with title "New/Attach Session" buttons {"Cancel", "Go"} default button "Go")

-- Validate input
if sessionName is "" then
    return
end if

tell application "iTerm2"
    activate

    -- Check if there's an existing window
    if (count of windows) = 0 then
        create window with default profile
    else
        tell current window
            create tab with default profile
        end tell
    end if

    delay 0.1

    -- Run ts with the session name
    tell current session of current window
        write text "ts " & quoted form of sessionName
    end tell
end tell
