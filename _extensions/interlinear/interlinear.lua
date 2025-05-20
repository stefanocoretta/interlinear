-----------------------------
-- Include Leipzig.js
-----------------------------

function Meta(meta)
    local meta_header_includes = meta["header-includes"]
    local meta_include_after = meta["include-after"]

    if FORMAT:match "html" or FORMAT:match "revealjs" then
        -- Include Leipzig css in header
        meta_header_includes[#meta_header_includes+1] = pandoc.RawBlock("html",
            '<link rel="stylesheet" href="//unpkg.com/leipzig/dist/leipzig.min.css">')

        -- Include Leipzig JS after body
        meta_include_after[#meta_include_after+1] = pandoc.RawBlock("html", '<script src="//unpkg.com/leipzig/dist/leipzig.min.js"></script>')

        -- Include custom abbreviations
        if meta.gloss_abbreviations then
            local abbreviations = meta.gloss_abbreviations

            local abbr_list = {}

            if type(abbreviations) == "table" then
                for abbr, def in pairs(abbreviations) do
                  def_str = pandoc.utils.stringify(def)
          
                  abbr_list[#abbr_list+1] = abbr .. ": '" .. def_str .. "'"
                end
            end

            local abbrs =  table.concat(abbr_list, ", ")

            quarto.log.output(abbrs)

            meta_include_after[#meta_include_after+1] = pandoc.RawBlock("html", [[
<script>
    var newAbbreviations = {
]] .. abbrs .. [[
};
    Leipzig().addAbbreviations(newAbbreviations);
</script>
]])
        end

        -- Activate Leipzig JS after body
        meta_include_after[#meta_include_after+1] = pandoc.RawBlock("html", [[
<script>
document.addEventListener('DOMContentLoaded', function() {
    Leipzig().gloss();
});
</script>
<style>
.gloss__words:first-child, .gloss--glossed li:first-child {
        margin-top: 0em !important
}
</style>
    ]])

    if FORMAT:match "revealjs" then
        meta_header_includes[#meta_header_includes+1] = pandoc.RawBlock("html",
            [[
<style>
/* Import Bootstrap's CSS grid system */
.grid {
    display: grid;
    grid-template-rows: repeat(var(--bs-rows, 1), 1fr);
    grid-template-columns: repeat(var(--bs-columns, 12), 1fr);
    gap: var(--bs-gap, 1.5rem);
  }
  
  /* Column spans */
  .grid .g-col-1 { grid-column: auto/span 1; }
  .grid .g-col-2 { grid-column: auto/span 2; }
  .grid .g-col-3 { grid-column: auto/span 3; }
  .grid .g-col-4 { grid-column: auto/span 4; }
  .grid .g-col-5 { grid-column: auto/span 5; }
  .grid .g-col-6 { grid-column: auto/span 6; }
  .grid .g-col-7 { grid-column: auto/span 7; }
  .grid .g-col-8 { grid-column: auto/span 8; }
  .grid .g-col-9 { grid-column: auto/span 9; }
  .grid .g-col-10 { grid-column: auto/span 10; }
  .grid .g-col-11 { grid-column: auto/span 11; }
  .grid .g-col-12 { grid-column: auto/span 12; }
  
  /* Column starts */
  .grid .g-start-1 { grid-column-start: 1; }
  .grid .g-start-2 { grid-column-start: 2; }
  .grid .g-start-3 { grid-column-start: 3; }
  .grid .g-start-4 { grid-column-start: 4; }
  .grid .g-start-5 { grid-column-start: 5; }
  .grid .g-start-6 { grid-column-start: 6; }
  .grid .g-start-7 { grid-column-start: 7; }
  .grid .g-start-8 { grid-column-start: 8; }
  .grid .g-start-9 { grid-column-start: 9; }
  .grid .g-start-10 { grid-column-start: 10; }
  .grid .g-start-11 { grid-column-start: 11; }
  
  /* Responsive breakpoints: sm */
  @media (min-width: 576px) {
    .grid .g-col-sm-1 { grid-column: auto/span 1; }
    .grid .g-col-sm-2 { grid-column: auto/span 2; }
    .grid .g-col-sm-3 { grid-column: auto/span 3; }
    .grid .g-col-sm-4 { grid-column: auto/span 4; }
    .grid .g-col-sm-5 { grid-column: auto/span 5; }
    .grid .g-col-sm-6 { grid-column: auto/span 6; }
    .grid .g-col-sm-7 { grid-column: auto/span 7; }
    .grid .g-col-sm-8 { grid-column: auto/span 8; }
    .grid .g-col-sm-9 { grid-column: auto/span 9; }
    .grid .g-col-sm-10 { grid-column: auto/span 10; }
    .grid .g-col-sm-11 { grid-column: auto/span 11; }
    .grid .g-col-sm-12 { grid-column: auto/span 12; }
    .grid .g-start-sm-1 { grid-column-start: 1; }
    .grid .g-start-sm-2 { grid-column-start: 2; }
    .grid .g-start-sm-3 { grid-column-start: 3; }
    .grid .g-start-sm-4 { grid-column-start: 4; }
    .grid .g-start-sm-5 { grid-column-start: 5; }
    .grid .g-start-sm-6 { grid-column-start: 6; }
    .grid .g-start-sm-7 { grid-column-start: 7; }
    .grid .g-start-sm-8 { grid-column-start: 8; }
    .grid .g-start-sm-9 { grid-column-start: 9; }
    .grid .g-start-sm-10 { grid-column-start: 10; }
    .grid .g-start-sm-11 { grid-column-start: 11; }
  }
  
  /* md */
  @media (min-width: 768px) {
    .grid .g-col-md-1 { grid-column: auto/span 1; }
    .grid .g-col-md-2 { grid-column: auto/span 2; }
    .grid .g-col-md-3 { grid-column: auto/span 3; }
    .grid .g-col-md-4 { grid-column: auto/span 4; }
    .grid .g-col-md-5 { grid-column: auto/span 5; }
    .grid .g-col-md-6 { grid-column: auto/span 6; }
    .grid .g-col-md-7 { grid-column: auto/span 7; }
    .grid .g-col-md-8 { grid-column: auto/span 8; }
    .grid .g-col-md-9 { grid-column: auto/span 9; }
    .grid .g-col-md-10 { grid-column: auto/span 10; }
    .grid .g-col-md-11 { grid-column: auto/span 11; }
    .grid .g-col-md-12 { grid-column: auto/span 12; }
    .grid .g-start-md-1 { grid-column-start: 1; }
    .grid .g-start-md-2 { grid-column-start: 2; }
    .grid .g-start-md-3 { grid-column-start: 3; }
    .grid .g-start-md-4 { grid-column-start: 4; }
    .grid .g-start-md-5 { grid-column-start: 5; }
    .grid .g-start-md-6 { grid-column-start: 6; }
    .grid .g-start-md-7 { grid-column-start: 7; }
    .grid .g-start-md-8 { grid-column-start: 8; }
    .grid .g-start-md-9 { grid-column-start: 9; }
    .grid .g-start-md-10 { grid-column-start: 10; }
    .grid .g-start-md-11 { grid-column-start: 11; }
  }
  
  /* lg */
  @media (min-width: 992px) {
    .grid .g-col-lg-1 { grid-column: auto/span 1; }
    .grid .g-col-lg-2 { grid-column: auto/span 2; }
    .grid .g-col-lg-3 { grid-column: auto/span 3; }
    .grid .g-col-lg-4 { grid-column: auto/span 4; }
    .grid .g-col-lg-5 { grid-column: auto/span 5; }
    .grid .g-col-lg-6 { grid-column: auto/span 6; }
    .grid .g-col-lg-7 { grid-column: auto/span 7; }
    .grid .g-col-lg-8 { grid-column: auto/span 8; }
    .grid .g-col-lg-9 { grid-column: auto/span 9; }
    .grid .g-col-lg-10 { grid-column: auto/span 10; }
    .grid .g-col-lg-11 { grid-column: auto/span 11; }
    .grid .g-col-lg-12 { grid-column: auto/span 12; }
    .grid .g-start-lg-1 { grid-column-start: 1; }
    .grid .g-start-lg-2 { grid-column-start: 2; }
    .grid .g-start-lg-3 { grid-column-start: 3; }
    .grid .g-start-lg-4 { grid-column-start: 4; }
    .grid .g-start-lg-5 { grid-column-start: 5; }
    .grid .g-start-lg-6 { grid-column-start: 6; }
    .grid .g-start-lg-7 { grid-column-start: 7; }
    .grid .g-start-lg-8 { grid-column-start: 8; }
    .grid .g-start-lg-9 { grid-column-start: 9; }
    .grid .g-start-lg-10 { grid-column-start: 10; }
    .grid .g-start-lg-11 { grid-column-start: 11; }
  }
  
  /* xl */
  @media (min-width: 1200px) {
    .grid .g-col-xl-1 { grid-column: auto/span 1; }
    .grid .g-col-xl-2 { grid-column: auto/span 2; }
    .grid .g-col-xl-3 { grid-column: auto/span 3; }
    .grid .g-col-xl-4 { grid-column: auto/span 4; }
    .grid .g-col-xl-5 { grid-column: auto/span 5; }
    .grid .g-col-xl-6 { grid-column: auto/span 6; }
    .grid .g-col-xl-7 { grid-column: auto/span 7; }
    .grid .g-col-xl-8 { grid-column: auto/span 8; }
    .grid .g-col-xl-9 { grid-column: auto/span 9; }
    .grid .g-col-xl-10 { grid-column: auto/span 10; }
    .grid .g-col-xl-11 { grid-column: auto/span 11; }
    .grid .g-col-xl-12 { grid-column: auto/span 12; }
    .grid .g-start-xl-1 { grid-column-start: 1; }
    .grid .g-start-xl-2 { grid-column-start: 2; }
    .grid .g-start-xl-3 { grid-column-start: 3; }
    .grid .g-start-xl-4 { grid-column-start: 4; }
    .grid .g-start-xl-5 { grid-column-start: 5; }
    .grid .g-start-xl-6 { grid-column-start: 6; }
    .grid .g-start-xl-7 { grid-column-start: 7; }
    .grid .g-start-xl-8 { grid-column-start: 8; }
    .grid .g-start-xl-9 { grid-column-start: 9; }
    .grid .g-start-xl-10 { grid-column-start: 10; }
    .grid .g-start-xl-11 { grid-column-start: 11; }
  }
  
  /* xxl */
  @media (min-width: 1400px) {
    .grid .g-col-xxl-1 { grid-column: auto/span 1; }
    .grid .g-col-xxl-2 { grid-column: auto/span 2; }
    .grid .g-col-xxl-3 { grid-column: auto/span 3; }
    .grid .g-col-xxl-4 { grid-column: auto/span 4; }
    .grid .g-col-xxl-5 { grid-column: auto/span 5; }
    .grid .g-col-xxl-6 { grid-column: auto/span 6; }
    .grid .g-col-xxl-7 { grid-column: auto/span 7; }
    .grid .g-col-xxl-8 { grid-column: auto/span 8; }
    .grid .g-col-xxl-9 { grid-column: auto/span 9; }
    .grid .g-col-xxl-10 { grid-column: auto/span 10; }
    .grid .g-col-xxl-11 { grid-column: auto/span 11; }
    .grid .g-col-xxl-12 { grid-column: auto/span 12; }
    .grid .g-start-xxl-1 { grid-column-start: 1; }
    .grid .g-start-xxl-2 { grid-column-start: 2; }
    .grid .g-start-xxl-3 { grid-column-start: 3; }
    .grid .g-start-xxl-4 { grid-column-start: 4; }
    .grid .g-start-xxl-5 { grid-column-start: 5; }
    .grid .g-start-xxl-6 { grid-column-start: 6; }
    .grid .g-start-xxl-7 { grid-column-start: 7; }
    .grid .g-start-xxl-8 { grid-column-start: 8; }
    .grid .g-start-xxl-9 { grid-column-start: 9; }
    .grid .g-start-xxl-10 { grid-column-start: 10; }
    .grid .g-start-xxl-11 { grid-column-start: 11; }
  }  

/* Deactivate p margin from revealjs css */
.reveal .ex p {
  margin: 0 !important;
}

</style>
        ]])
    end

        return meta
    elseif FORMAT:match "latex" or FORMAT:match "beamer" then

        -- Use package expex
        meta_header_includes[#meta_header_includes + 1] = pandoc.MetaBlocks(pandoc.RawBlock("tex", [[
% Fix compatibility with unicode-math (https://github.com/wspr/unicode-math/issues/379#issuecomment-276079476)
\usepackage{expex}
\let\expexgla\gla
\AtBeginDocument{%
    \let\umgla\gla
    \let\gla\expexgla
}
    ]]))
        meta["header-includes"] = meta_header_includes
        -- quarto.log.output(meta["header-includes"])
        return meta
    end
end

-- Counter to track gloss numbers
local ex_counter = 0
local exi_counter = 0
local this_ex_counter = ex_counter
local ex_label = {}

function Div(div)
    if FORMAT:match "html" or FORMAT:match "revealjs" then
        if div.classes:includes("ex") then
            -- quarto.log.output(div)
            -- Increment gloss number
            ex_counter = ex_counter + 1

            local div_identifiers = div.identifier
            table.insert(ex_label, div_identifiers)

            -- Create a numbered gloss span for HTML
            local ex_number = pandoc.RawInline("html",
                '<div class="g-col-1" id="' .. div.identifier .. '">(' .. ex_counter .. ')</div> <div class="g-col-11">')
            local close_div = pandoc.RawInline("html", '</div>')

            table.insert(div.content, 1, { ex_number })
            table.insert(div.content, { close_div })

            local div_classes = div.classes
            table.insert(div_classes, "grid")

            return div
        end

        if div.classes:includes("exi") then
            if ex_counter > this_ex_counter then
                exi_counter = 0
            end

            -- Increment gloss number
            exi_counter = exi_counter + 1
            exi_letter = get_letter(exi_counter)

            local div_identifiers = div.identifier
            table.insert(ex_label, div_identifiers)

            -- Create a numbered gloss span for HTML
            local exi_number = pandoc.RawInline("html",
                '<div class="g-col-1" id="' ..
                div.identifier .. '">' .. exi_letter .. '.</div> <div style="grid-column: span 17;">')
            local close_div = pandoc.RawInline("html", '</div>')

            table.insert(div.content, 1, { exi_number })
            table.insert(div.content, { close_div })

            local div_classes = div.classes
            table.insert(div_classes, "grid")
            table.insert(div.attributes, { "style", "--bs-columns: 18; --bs-gap: 0rem;" })

            this_ex_counter = ex_counter

            return div
        end

        if div.classes:includes("gl") then
            -- collect existing identifiers and classes to be added back below
            local div_identifiers = div.identifier
            local div_classes = div.classes

            for _, block in ipairs(div.content) do
                if block.t == "LineBlock" then
                    local paragraphs = {}

                    for i, inline in ipairs(block.content) do
                        local para = pandoc.Para(inline)
                        -- quarto.log.output(para)
                        -- top lines marked with "-" are original gloss lines
                        -- a bottom line with only "-" creates a gloss without free translation
                        -- TODO: strip empty <p> when there is no free translation
                        -- #para.content > 0 needed for empty LineBlock lines
                        if #para.content > 0 and pandoc.utils.stringify(para.content[1]) == "-" then
                            -- strip leading "-" and " "
                            table.remove(para.content, 1)
                            table.remove(para.content, 1)
                            -- Element Para cannot have classes, so we use a Plain element
                            para = pandoc.Plain(
                                { pandoc.RawInline('html', '<p class="gloss__line--original">') }
                                .. para.content ..
                                { pandoc.RawInline('html', '</p>') }
                            )
                        -- DO NOT QUOTE to allow for comments
                        -- PREVIOUSLY: if para is last line, quote it if it's not already quoted
                        -- elseif #para.content > 0 and i == #block.content then
                        --     if para.content[1].t ~= "Quoted" then
                        --         para.content = pandoc.Quoted('SingleQuote', para.content)
                        --     end
                        end

                        table.insert(paragraphs, para)
                    end

                    div = pandoc.Div(paragraphs)
                    -- add necessary attribute for leipzig.js to process the div
                    div.attributes["data-gloss"] = ""

                    -- add back identifiers and classes
                    div.identifier = div_identifiers
                    div.classes = div_classes

                    return div
                end
            end
        end
    end

    if FORMAT:match "latex" or FORMAT:match "beamer" then
        if div.classes:includes("ex") then
            local ex_begin = pandoc.RawInline("tex", '\\pex\n')
            local ex_end = pandoc.RawInline("tex", '\n\\xe')

            if div.content[1].t == "Div" then
                table.insert(div.content[1].content[1].content, 1, ex_begin)
                table.insert(div.content[#div.content].content[#div.content[1].content].content, ex_end)
            else
                table.insert(div.content[1].content, 1, ex_begin)
                table.insert(div.content[#div.content].content, ex_end)
            end

            -- quarto.log.output(div.content)
            return div
        end

        -- Subexamples
        if div.classes:includes("exi") then
            local ex_begin = pandoc.RawInline("tex", '\\a ')

            if div.content[1].t == "Div" then
                table.insert(div.content[1].content[1].content, 1, ex_begin)
            else
                table.insert(div.content[1].content, 1, ex_begin)
            end

            return div
        end

        if div.classes:includes("gl") then
            -- collect existing identifiers and classes to be added back below
            local div_identifiers = div.identifier
            local div_classes = div.classes

            for _, block in ipairs(div.content) do
                if block.t == "LineBlock" then
                    local preamble_n = 0
                    local paragraphs = {}
                    table.insert(paragraphs, pandoc.RawInline('tex', '\\begingl\n'))
                    for i, inline in ipairs(block.content) do
                        local para = pandoc.RawInline('tex', pandoc.utils.stringify(inline))
                        -- top lines marked with "-" are original gloss lines
                        -- a bottom line with only "-" creates a gloss without free translation
                        -- TODO: strip empty <p> when there is no free translation
                        -- #para.content > 0 needed for empty LineBlock lines
                        if para.text ~= "" and string.sub(para.text, 1, 1) == "-" then
                            preamble_n = preamble_n + 1
                            -- strip leading "-"
                            para.text = string.gsub(para.text, "^-", "")
                            if para.text ~= "" then
                                para.text = "\\glpreamble " .. para.text .. " //\n"
                            end
                        elseif i == preamble_n + 1 then
                            para.text = "\\gla " .. para.text .. " //\n"
                        elseif i > preamble_n + 1 and i ~= #block.content then
                            para.text = "\\glb " .. para.text .. " //\n"

                        -- DO NOT QUOTE to allow for comments (PREVIOUSLY if para is last line, quote it if it's not already quoted)
                        elseif para.text ~= "" and i == #block.content then
                            para.text = "\\glft " .. para.text .. " //\n"
                        end

                        table.insert(paragraphs, para)
                    end
                    table.insert(paragraphs, pandoc.RawInline('tex', '\\endgl'))

                    local concatenated_text = ""
                    for _, inline in ipairs(paragraphs) do
                        concatenated_text = concatenated_text .. pandoc.utils.stringify(inline.text)
                    end

                    -- Create a new Para block with the concatenated text
                    local paragraphs_cat = pandoc.RawInline("tex", concatenated_text)

                    div = pandoc.Div(paragraphs_cat)
                    -- quarto.log.output(paragraphs_cat)

                    -- add back identifiers and classes
                    div.identifier = div_identifiers
                    div.classes = div_classes

                    return div
                end
            end
        end
    end
end

-- Function to generate a letter sequence based on the counter
function get_letter(n)
    local result = ""
    n = n - 1
    -- Generate letter sequence using base-26 logic
    repeat
        local remainder = n % 26
        result = string.char(97 + remainder) .. result -- 97 is ASCII for 'a'
        n = math.floor(n / 26) - 1
    until n < 0
    return result
end
