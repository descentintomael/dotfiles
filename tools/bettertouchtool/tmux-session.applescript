-- =============================================================================
-- Tmux Session Manager - BetterTouchTool Action
-- =============================================================================
-- Opens a new iTerm2 tab and launches the tmux session picker.
--
-- Setup in BetterTouchTool:
--   1. Go to Keyboard Shortcuts
--   2. Add new shortcut (e.g., Cmd+Shift+T)
--   3. Action: "Run Apple Script (blocking)"
--   4. Paste this script
--
-- Alternative: Save as .scpt and use "Run Apple Script from path"
-- =============================================================================

tell application "iTerm2"
    activate

    -- Check if there's an existing window
    if (count of windows) = 0 then
        -- Create new window if none exists
        create window with default profile
    else
        -- Use current window
        tell current window
            create tab with default profile
        end tell
    end if

    -- Small delay to ensure tab is ready
    delay 0.1

    -- Run the tmux session picker
    tell current session of current window
        write text "ts"
    end tell
end tell
