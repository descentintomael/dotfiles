# MD2EPUB - Convert clipboard markdown content to epub and pdf
# Using namespace pattern for organization

# Parse arguments and set defaults
md2epub::parse_args() {
    local _title_var=$1
    local _author_var=$2
    local _output_var=$3
    local save_dir="/Users/seantodd/Library/Mobile Documents/com~apple~CloudDocs/Reading List/GPT Research Reports"
    
    # Set defaults
    local _title="Converted Document"
    local _author="OpenAI"
    
    # Parse arguments:
    # $1 = filename (optional)
    # $2 = title (optional)
    # $3 = author (optional)
    
    # Set output filename
    if [ -z "$4" ]; then
        local _output="${save_dir}/clipboard.epub"
    else
        local _output="${save_dir}/$4.epub"
    fi
    
    # Set title if provided
    if [ -n "$5" ]; then
        _title="$5"
    fi
    
    # Set author if provided
    if [ -n "$6" ]; then
        _author="$6"
    fi
    
    # Use eval to assign values back to the calling variables
    eval "$_title_var='$_title'"
    eval "$_author_var='$_author'"
    eval "$_output_var='$_output'"
}

# Create and setup temporary directory
md2epub::setup_temp_dir() {
    # Create a temporary directory and directly return its path
    # We're not using the nameref pattern anymore as it might be causing issues
    local temp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t "md2epub")
    
    # Make sure the directory was actually created
    if [ ! -d "$temp_dir" ] || [ -z "$temp_dir" ]; then
        # Fallback method using a specific location
        tmp_dir="$TMPDIR/md2epub_temp"
        mkdir -p "$tmp_dir"
        
        if [ ! -d "$tmp_dir" ] || [ ! -w "$tmp_dir" ]; then
            echo "CRITICAL ERROR: All attempts to create temporary directory failed!"
            return 1
        fi
    fi
    
    # Ensure we have write permissions
    if [ ! -w "$temp_dir" ]; then
        echo "ERROR: No write permission to temporary directory: $temp_dir"
        return 1
    fi
    # Return the path directly - this avoids pass-by-reference issues
    echo "$temp_dir"
}

# Process markdown content from clipboard
md2epub::process_markdown() {
    local tmp_dir="$1"
    local tmp_md="${tmp_dir}/md2epub.md"
    
    # Process clipboard content - first get content starting from first heading
    pbpaste | awk '/^#/{f=1} f{print}' > "${tmp_dir}/temp_md.md"
    
    # Then remove the numbering from headers (e.g., "# 1. Title" becomes "# Title")
    sed -E 's/^(#+[[:space:]]*)[0-9]+\.[[:space:]]+/\1/g' "${tmp_dir}/temp_md.md" > "$tmp_md"
    
    echo "Processed markdown content"
}

# Process links and move them to References section
md2epub::process_links() {
    local tmp_dir="$1"
    local tmp_md="${tmp_dir}/md2epub.md"
    
    echo "Processing links..."
    
    # Create temporary files
    local processed="${tmp_dir}/processed.md"
    echo '' > "$processed"  # Clear file if it exists
    
    # Start references section
    local references="${tmp_dir}/references.md"
    echo -e "\n## References\n" > "$references"

    # Process links line by line
    local counter=0
    echo "Starting link processing..."
    while IFS= read -r line; do
        # Process all links in the current line
        local modified_line="$line"
        
        # Use a different approach to extract and process links
        while [[ "$modified_line" =~ '\[([^]]+)\]\(([^)]+)\)' ]]; do
            ((counter++))
            
            # Extract matched parts - zsh uses $match array instead of BASH_REMATCH
            local link_text="${match[1]}"
            local link_url="${match[2]}"
            
            # Add to references with underlining and arrow character
            echo "$counter. [<u>$link_text</u> ↗]($link_url)" >> "$references"
            
            # Replace with a special marker that will be easier to find in LaTeX
            # We'll use a unique marker that won't appear in normal text
            modified_line=${modified_line/\[$link_text\]\($link_url\)/SUPERSCRIPT_MARKER${counter}}
        done
        # Write modified line to output
        echo "$modified_line" >> "$processed"
    done < "$tmp_md"
    
    echo "Link processing complete. Total links processed: $counter"
    
    # Append references to the end
    cat "$references" >> "$processed"
    
    # Replace original file
    mv "$processed" "$tmp_md"
    
    echo "Processed $counter links and added references section"
}

# Convert markdown to ePub
md2epub::create_epub() {
    local tmp_dir="$1"
    local title="$2"
    local author="$3"
    local tmp_md="${tmp_dir}/md2epub.md"
    local tmp_epub="${tmp_dir}/md2epub.epub"
    
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
        --toc \
        --metadata date=\"$(date +'%Y-%m-%d')\""
    
    # Complete the command with input and output files
    pandoc_cmd+=" -o \"$tmp_epub\" \"$tmp_md\" 2>&1 | tee \"${tmp_dir}/pandoc_epub_log.txt\""
    
    # Execute the pandoc command
    eval $pandoc_cmd
}

# Create LaTeX preamble
md2epub::create_latex_preamble() {
    local tmp_dir="$1"
    
    cat > "${tmp_dir}/preamble.tex" << 'EOF'
\documentclass{article}
\usepackage{fontspec}
\setmainfont{Baskerville}
\setsansfont{Gill Sans}
\setmonofont{Andale Mono}
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=olive,
    filecolor=olive,
    urlcolor=olive,
    citecolor=olive
}
\usepackage{endnotes}
\usepackage{url}
\usepackage{xeCJK}
\usepackage{unicode-math}

\newcommand{\linktoendnote}[2]{\href{#1}{#2}\endnotetext{URL: \url{#1}}}
\let\oldfootnote=\footnote
\renewcommand{\footnote}[1]{\endnotetext{#1}}
\setlength{\parindent}{0pt}
\setlength{\parskip}{1em}

% Handle common subscripts and special characters
\newcommand{\specialchar}[1]{#1}

\begin{document}
EOF
}

# Convert markdown to LaTeX and PDF
md2epub::create_latex_pdf() {
    local tmp_dir="$1"
    local tmp_md="${tmp_dir}/md2epub.md"
    local tmp_latex="${tmp_dir}/md2epub.tex"
    
    echo "Converting markdown to LaTeX..."
    
    # Create LaTeX preamble
    md2epub::create_latex_preamble "$tmp_dir"
    
    # Convert markdown to LaTeX body
    pandoc -f markdown -t latex "$tmp_md" -o "${tmp_dir}/body.tex" 2>&1 | tee "${tmp_dir}/pandoc_latex_log.txt"
    
    # Process the LaTeX body to replace href with linktoendnote
    sed -i '' 's/\\href{\([^}]*\)}{\([^}]*\)}/\\linktoendnote{\1}{\2}/g' "${tmp_dir}/body.tex"
    
    # Replace the SUPERSCRIPT_MARKER with proper LaTeX superscripts
    sed -i '' 's/SUPERSCRIPT\\_MARKER\([0-9][0-9]*\)/\\textsuperscript{\1}/g' "${tmp_dir}/body.tex"
    
    # Remove parentheses around textsuperscript commands - improved pattern for multiple matches
    sed -i '' 's/\([^(]*\)(\\textsuperscript{\([0-9][0-9]*\)})/\1\\textsuperscript{\2}/g' "${tmp_dir}/body.tex"
    
    # Replace common subscripts with LaTeX math notation
    sed -i '' 's/₂/$_2$/g' "${tmp_dir}/body.tex"
    sed -i '' 's/₁/$_1$/g' "${tmp_dir}/body.tex"
    sed -i '' 's/₃/$_3$/g' "${tmp_dir}/body.tex"
    sed -i '' 's/₄/$_4$/g' "${tmp_dir}/body.tex"
    
    # Combine the files to create a complete LaTeX document
    cat "${tmp_dir}/preamble.tex" "${tmp_dir}/body.tex" > "$tmp_latex"
    
    # Add endnotes and document end
    cat >> "$tmp_latex" << 'EOF2'
\theendnotes
\end{document}
EOF2
    
    # Save the contents of tmp_latex to a temporary latex file
    cat "$tmp_latex" > "${tmp_dir}/md2epub_temp.tex"
    
    # Generate PDF
    md2epub::generate_pdf "$tmp_dir"
}

# Generate PDF from LaTeX
md2epub::generate_pdf() {
    local tmp_dir="$1"
    local tmp_pdf="${tmp_dir}/md2epub.pdf"
    
    echo "Converting LaTeX to PDF..."
    
    # Run xelatex twice to resolve references properly
    xelatex -interaction=nonstopmode -output-directory="$tmp_dir" "${tmp_dir}/md2epub_temp.tex" > "${tmp_dir}/xelatex_log.txt" 2>&1
    xelatex -interaction=nonstopmode -output-directory="$tmp_dir" "${tmp_dir}/md2epub_temp.tex" >> "${tmp_dir}/xelatex_log.txt" 2>&1

    # Ensure the PDF is correctly named
    if [ -f "${tmp_dir}/md2epub_temp.pdf" ] && [ ! -f "${tmp_dir}/md2epub.pdf" ]; then
        mv "${tmp_dir}/md2epub_temp.pdf" "${tmp_dir}/md2epub.pdf"
    fi
    
    # Check if PDF generation was successful
    if [ ! -f "$tmp_pdf" ]; then
        echo "Error creating PDF. Check logs at: ${tmp_dir}/xelatex_log.txt"
        # subl "${tmp_dir}/xelatex_log.txt"
        return 1
    fi
    
    return 0
}

# Handle output files and cleanup
md2epub::handle_output() {
    local tmp_dir="$1"
    local output="$2"
    local tmp_epub="${tmp_dir}/md2epub.epub"
    local tmp_pdf="${tmp_dir}/md2epub.pdf"
    
    # Handle PDF output
    if [ -f "$tmp_pdf" ]; then
        pdf_output="${output%.epub}.pdf"
        cp "$tmp_pdf" "$pdf_output"
        echo "PDF created successfully at $pdf_output"
        open "$pdf_output"
    fi
    
    # Handle ePub output
    if [ -f "$tmp_epub" ]; then
        mv "$tmp_epub" "$output"
        echo "ePub created successfully at $output"
        # open "$output"
    else
        echo "Error creating ePub. Check logs at: ${tmp_dir}/pandoc_epub_log.txt"
        echo "Not removing temporary directory for debugging purposes."
        trap - EXIT  # Cancel the cleanup
        
        # Attempt to open the logs for immediate inspection
        cat "${tmp_dir}/pandoc_epub_log.txt"
        return 1
    fi
    
    return 0
}

# Add a debugging function to help troubleshoot
md2epub::debug_paths() {
    local tmp_dir="$1"
    
    echo "==== DEBUG: Verifying paths ===="
    echo "Temporary directory: $tmp_dir"
    echo "Files in temporary directory:"
    ls -la "$tmp_dir" || echo "Cannot list files in $tmp_dir"
    echo "Current directory: $(pwd)"
    echo "Current user: $(whoami)"
}
md2epub() {
    local title author output
    
    # Parse command line arguments
    md2epub::parse_args "title" "author" "output" "$1" "$2" "$3"
    
    # Setup temporary directory - directly capture the output
    local tmp_dir=$(md2epub::setup_temp_dir "md2epub_tmp")
    
    # Debug paths to verify temporary directory is correctly set
    # md2epub::debug_paths "$tmp_dir"
    
    # Setup cleanup trap (can be commented out for debugging)
    trap 'rm -rf "$tmp_dir"' EXIT
    
    # Process markdown from clipboard
    md2epub::process_markdown "$tmp_dir"
    
    # Process links and create references section
    md2epub::process_links "$tmp_dir"
    
    # Verify markdown file was created
    if [ ! -f "${tmp_dir}/md2epub.md" ]; then
        echo "ERROR: Markdown file was not created at ${tmp_dir}/md2epub.md"
        ls -la "$tmp_dir"
        return 1
    fi
    
    # Create ePub file
    md2epub::create_epub "$tmp_dir" "$title" "$author"
    
    # Create LaTeX and PDF files
    md2epub::create_latex_pdf "$tmp_dir"
    
    # Handle output and cleanup
    md2epub::handle_output "$tmp_dir" "$output"
}
