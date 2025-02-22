# epdracor-sources

This repository maintains the selection of documents from the
[EarlyPrint Project](https://earlyprint.org) that serve as the sources of the
[EPDraCor](https://github.com/dracor-org/epdracor) corpus.

The EarlyPrint IDs of the selected documents are maintained in the
[ids.txt](ids.txt) file.

To update the selection from a cloned bitbucket repository or from bitbucket
directly the [update](scripts/update) script can be used:

```sh
./scripts/update --help
./scripts/update --download
./scripts/update --all --copy /path/to/local/repos
```

## How to add or remove plays

1. edit [ids.txt](ids.txt) to add or remove the EP IDs of the respective
  EarlyPrint texts
2. run `./scripts/update --download` to download new documents from the
  EarlyPrint Bitbucket repository and/or remove existing documents from the
  `xml` directory
3. commit the changes

## eXist DB integration

For development purposes this repository provides an eXist DB integration that
makes it easy to upload the TEI files into a local eXist database to make them
available for xqueries you might want to run for analysis.

To set this up copy the (`.env.sample`)[.env.sample] file to `.env` and adjust
the environment variables to your local eXist setup. (The defaults should work
with a vanilla eXist DB installation on most systems.) Then run the
[init script](scripts/init) to create and configure the database collection and
upload xquery files:

```sh
cp .env.sample .env
# adjust .env
./scripts/init
```

Now you can upload either individual TEI files or the entire xml directory using
the [load](scripts/load) script:

```sh
# load all files in xml/
./scripts/load
# load individual files
./scripts/load xml/A015*.xml
# usage
./scripts/load --help
```

Finally an uploaded query can conveniently be executed with the query script:

```sh
./scripts/query plays.xq
./scripts/query 'speeches.xq?id=A36645'
```

### .existdb.json

To support the integration with editor plugins for
[Atom](https://github.com/eXist-db/atom-existdb) or
[Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode)
we also provide a
[template for an `.existdb.json` configuration file](.existdb.json.sample). The
`.existdb.json` gets created when running the init script with the `-j` option:

```sh
./scripts/init -j
```
