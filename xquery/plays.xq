xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace ep = "http://earlyprint.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $col := request:get-parameter("collection", "/db/epdracor-sources/xml")

return array {
  for $tei in collection($col)/tei:TEI
  let $authors := $tei//ep:epHeader/ep:author/normalize-space()
  let $title := $tei//ep:epHeader/ep:title/normalize-space()
  let $dp := $tei//tei:div[@type="dramatis_personae"]
  order by $authors[1], $title[1]
  return map {
    "id": $tei/@xml:id/string(),
    "authors": array { $authors },
    "title": $title,
    "hasDramatisPersonae": if ($dp) then true() else false(),
    "hasWho": if ($tei//tei:sp[@who]) then true() else false ()
  }
}
