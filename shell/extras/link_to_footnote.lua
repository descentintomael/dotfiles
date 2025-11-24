-- Enhanced pandoc filter to convert links to endnotes

-- Store our links and their corresponding footnote numbers
local link_map = {}
local next_id = 1

-- Process links to convert them to endnotes
function Link(el)
    local url = el.target
    local link_text = ""
    
    -- Get link text safely
    if pandoc.utils and pandoc.utils.stringify then
        link_text = pandoc.utils.stringify(el.content)
    else
        for _, item in ipairs(el.content) do
            if item.text then
                link_text = link_text .. item.text
            end
        end
    end
    
    -- Skip internal/anchor links
    if url:match("^#") then
        return el
    end
    
    -- If we've seen this URL before, use the existing footnote number
    if link_map[url] then
        -- Create a footnote reference using the existing ID
        local footnote_id = link_map[url]
        -- Return the original text with a reference to the existing footnote
        return {
            pandoc.Span(el.content),
            pandoc.RawInline("html", '<a epub:type="noteref" href="#fn' .. footnote_id .. '" id="fnref' .. footnote_id .. '">[' .. footnote_id .. ']</a>')
        }
    end
    
    -- This is a new URL, create a footnote
    local footnote_id = next_id
    link_map[url] = footnote_id
    
    -- Create footnote content with proper formatting
    local note_content = {}
    
    if link_text ~= "" and link_text ~= url then
        table.insert(note_content, pandoc.Str(link_text .. ": "))
    end
    
    -- Add the URL as a proper link
    table.insert(note_content, pandoc.Link(pandoc.Str(url), url))
    
    -- Create a proper footnote with an ID
    local footnote = pandoc.Note(note_content)
    
    -- Increment counter for the next footnote
    next_id = next_id + 1
    
    -- Return the original text with a footnote
    return {
        pandoc.Span(el.content),
        footnote
    }
end

-- Reset our variables for each document
function Meta(meta)
    link_map = {}
    next_id = 1
    return meta
end
