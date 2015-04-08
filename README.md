# MaterialDoc

## Tutorial

To use it simply generate the ddoc documentation using dmd and generate an index.json using the
`-XfdocFolder/index.json` switch for dmd. Then just put that folder where the exe is and run the
exe with `--df=docFolder/` as argument

Then the output html files will generate to out/

### Dub usage

For generating an index.json in dub just add `"dflags": ["-XfdocFolder/index.json"]` to the dub.json.

Then do the above.

## Console Arguments

| Argument | Description
| --- | ---
| df | Input directory where ddoc files are.
| of | Output directory of the documentation
| index | index.json file from -Xf switch (Relative to .exe or to docFolder/)
| replaceColors | Automatically replace <font color> with <font class>
| css | Specifies the stylesheet.css location (Relative to .exe)
| forceRemove | Removes the output directory before generating

## Screenshots
![Example Screenshot](http://i.webfreak.org/8FA200.png)
