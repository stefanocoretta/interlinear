-- Include Leipzig.js
function Meta(meta)
  meta["header-includes"] = pandoc.RawBlock("html", '<link rel="stylesheet" href="//unpkg.com/leipzig/dist/leipzig.min.css">')
  local mia = meta["include-after"]
  table.insert(mia, 2, pandoc.RawBlock("html", '<script src="//unpkg.com/leipzig/dist/leipzig.min.js"></script>'))
  table.insert(mia, 3, pandoc.RawBlock("html", [[
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
      for _, block in ipairs(div.content) do
        if block.t == "LineBlock" then
          local paragraphs = {}
          for _, inline in ipairs(block.content) do
            table.insert(paragraphs, pandoc.Para(inline))
          end
          div = pandoc.Div(paragraphs)
          div.attributes["data-gloss"] = ""
          return div
        end
      end
    end
  end
end
