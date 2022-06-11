xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace ep = "http://earlyprint.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $col := request:get-parameter("collection", "/db/epdracor-sources/xml")
let $id := request:get-parameter("id", "")

return if (not($id)) then (
  response:set-status-code(400),
  map {
    "error": "missing query parameter 'id'"
  }
) else
  let $tei := collection($col)/tei:TEI[@xml:id = $id]
  let $authors := $tei//ep:epHeader/ep:author/normalize-space()
  let $title := $tei//ep:epHeader/ep:title/normalize-space()
  let $dp := $tei//tei:div[@type="dramatis_personae"]
  return map {
    "id": $tei/@xml:id/string(),
    "authors": array { $authors },
    "title": $title,
    "dramatisPersonae": map {
      "id": $dp/@xml:id/string(),
      "pb": $dp/(
        tei:*[1][local-name()='pb'] | preceding::tei:pb[1]
      )[1]/@xml:id/string(),
      "items": array {
        if (count($dp//tei:list[tei:label]) > 0) then
          for $label in $dp//tei:list/tei:label
          return array {(
            normalize-space($label),
            normalize-space($label/following-sibling::tei:item[1])
          )}
        else if (count($dp//tei:list) > 0) then
          for $item in $dp//tei:list/tei:item
          return array { (replace(normalize-space($item), ' ([.,:])', '$1')) }
        else if (count($dp//tei:table) > 0) then
          for $row in $dp//tei:table/tei:row
          return array { (normalize-space($row/tei:cell[1]), normalize-space($row)) }
        else
          for $p in $dp/tei:p
          return normalize-space($p)
      }
    },
    "speeches": array {
      for $sp in $tei//tei:sp[tei:speaker]
      return map:merge((
        map {
          "id": $sp/@xml:id/string(),
          "pb": $sp/preceding::tei:pb[1]/@xml:id/string(),
          "speaker": $sp/tei:speaker/normalize-space()
        },
        if ($sp/@who) then map:entry("who", $sp/@who/string()) else ()
      ))
    }
  }
