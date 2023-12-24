-- Include Leipzig.js
function Meta(meta)
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
end

function Div(div)
  if FORMAT:match "html" then
    if div.classes:includes("ex") then
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
              -- strip leading "-"
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
          return div
        end
      end
    end
  end
end
