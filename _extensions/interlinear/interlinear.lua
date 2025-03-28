-- Include Leipzig.js
function Meta(meta)
  local meta_header_includes = meta["header-includes"]
  if FORMAT:match "html" then
    meta["header-includes"] = pandoc.RawBlock("html", '<link rel="stylesheet" href="//unpkg.com/leipzig/dist/leipzig.min.css">')
    local meta_include_after = meta["include-after"]
    table.insert(meta_include_after, 2, pandoc.RawBlock("html", '<script src="//unpkg.com/leipzig/dist/leipzig.min.js"></script>'))
    table.insert(meta_include_after, 3, pandoc.RawBlock("html", [[
<script>
document.addEventListener('DOMContentLoaded', function() {
  Leipzig().gloss();
});
</script>
  ]]))
    return meta
  elseif FORMAT:match "latex" or FORMAT:match "beamer" then
    -- read existing header-includes
    meta_header_includes[#meta_header_includes+1] = pandoc.MetaBlocks(pandoc.RawBlock("tex", [[
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
local gloss_counter = 0
local gloss_label = {}

function Div(div)
  if div.classes:includes("ex") then
    -- Increment gloss number
    gloss_counter = gloss_counter + 1

    if FORMAT:match "html" then
      -- collect existing identifiers and classes to be added back below
      local div_identifiers = div.identifier
      table.insert(gloss_label, div_identifiers)
      local div_classes = div.classes
      table.insert(div_classes, "g-col-11")

      -- Create a numbered gloss span for HTML
      local gloss_number = pandoc.RawInline("html", '<div class="g-col-1" id="' .. div.identifier .. '">(' .. gloss_counter .. ')</div> ')
      
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
                  {pandoc.RawInline('html', '<p class="gloss__line--original">')}
                  .. para.content ..
                  {pandoc.RawInline('html', '</p>')}
                )
              -- if para is last line, quote it if it's not already quoted
              elseif #para.content > 0 and i == #block.content then
                if para.content[1].t ~= "Quoted" then
                  para.content = pandoc.Quoted('SingleQuote', para.content)
                end
            end

            table.insert(paragraphs, para)
          end

          div = pandoc.Div(paragraphs)
          -- add necessary attribute for leipzig.js to process the div
          div.attributes["data-gloss"] = ""

          -- add back identifiers and classes
          div.identifier = div_identifiers
          div.classes = div_classes
          new_div = pandoc.Div({gloss_number, div})
          new_div.attr = {class = 'grid'}
          return  new_div
        end
      end
    end

    if FORMAT:match "latex" or FORMAT:match "beamer" then
      -- collect existing identifiers and classes to be added back below
      local div_identifiers = div.identifier
      local div_classes = div.classes

      for _, block in ipairs(div.content) do
        if block.t == "LineBlock" then
          local preamble_n = 0
          local paragraphs = {}
          table.insert(paragraphs, pandoc.RawInline('tex', '\\ex\n\\begingl\n'))
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

            -- if para is last line, quote it if it's not already quoted
            elseif para.text ~= "" and i == #block.content then
              para.text = "\\glft `" .. para.text .. "' //\n"
            end

            table.insert(paragraphs, para)
          end
          table.insert(paragraphs, pandoc.RawInline('tex', '\\endgl\n\\xe'))

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