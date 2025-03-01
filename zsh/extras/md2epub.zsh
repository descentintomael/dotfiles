# Convert pbpaste to an ePub with custom filename, saving to iCloud Drive
md2epub() {
    local save_dir="/Users/seantodd/Library/Mobile Documents/com~apple~CloudDocs/Reading List/GPT Research Reports"
    local title="Converted Document"
    local author="OpenAI"  # Default author is now "OpenAI" instead of empty
    
    # Parse arguments:
    # $1 = filename (optional)
    # $2 = title (optional)
    # $3 = author (optional)
    
    # Set output filename
    if [ -z "$1" ]; then
        output="${save_dir}/clipboard.epub"
    else
        output="${save_dir}/$1.epub"
    fi
    
    # Set title if provided
    if [ -n "$2" ]; then
        title="$2"
    fi
    
    # Set author if provided, otherwise keep the default "OpenAI"
    if [ -n "$3" ]; then
        author="$3"
    fi
    
    # Create a temporary directory and use files inside it
    local tmp_dir=$(mktemp -d)
    local tmp_md="${tmp_dir}/md2epub.md"
    local tmp_epub="${tmp_dir}/md2epub.epub"
    
    echo "Temporary directory created at: $tmp_dir"
    echo "Title: $title"
    echo "Author: $author"  # Now always show author since there's always a value

    # Update cleanup to remove the whole directory
    trap 'rm -rf "$tmp_dir"' EXIT
    
    # Process clipboard content - first get content starting from first heading
    pbpaste | awk '/^#/{f=1} f{print}' > "${tmp_dir}/temp_md.md"
    
    # Then remove the numbering from headers (e.g., "# 1. Title" becomes "# Title")
    sed -E 's/^(#+[[:space:]]*)[0-9]+\.[[:space:]]+/\1/g' "${tmp_dir}/temp_md.md" > "$tmp_md"

    echo "Converting markdown to ePub..."
    
    # Build the pandoc command
    local pandoc_cmd="pandoc -f markdown -t epub3 \
        --metadata title=\"$title\" \
        --metadata author=\"$author\" \
        --css=/Users/seantodd/.dotfiles/zsh/extras/epub.css \
        --lua-filter=/Users/seantodd/.dotfiles/zsh/extras/link_to_footnote.lua \
        --split-level=1 \
        -M reference-location=section \
        -M reference-section-title=\"References and Notes\" \
        --metadata lang=en \
        --toc"
    
    # Complete the command with input and output files
    pandoc_cmd+=" -o \"$tmp_epub\" \"$tmp_md\" 2>&1 | tee \"${tmp_dir}/pandoc_epub_log.txt\""
    
    # Execute the pandoc command
    eval $pandoc_cmd
        
    # Move and open the ePub if successful
    if [ -f "$tmp_epub" ]; then
        mv "$tmp_epub" "$output"
        echo "ePub created successfully at $output"
        open "$output"
    else
        echo "Error creating ePub. Check logs at: ${tmp_dir}/pandoc_epub_log.txt"
        echo "Not removing temporary directory for debugging purposes."
        trap - EXIT  # Cancel the cleanup
        
        # Attempt to open the logs for immediate inspection
        cat "${tmp_dir}/pandoc_epub_log.txt"
    fi
}
