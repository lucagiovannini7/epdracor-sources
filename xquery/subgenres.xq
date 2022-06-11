xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace ep = "http://earlyprint.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

let $col := request:get-parameter("collection", "/db/epdracor-sources/xml")

return array {
  for $subgenre in distinct-values(collection($col)//ep:subgenre)
  order by $subgenre
  return $subgenre
}
