# Deploy Macmillan's Bookmaker Toolchain

This repository houses the .bat files that configure each implementation of the Bookmaker tool - an automated process for converting manuscripts into PDF and EPUB formats.

## Updating deploy scripts
Do not edit .bat files directly, instead edit:
* _scripts.json_ file for per-.bat changes,
* any .bat files in '_templates_' for changes to headers/footers of all .bats, and
# _compile.rb_ for changes to executables or other global changes to script calls.

Then re-compile all .bats like so:
`ruby compile.rb /path/to/bookmaker_scripts_dir`
where _bookmaker_scripts_dir_ is parent folder of this repository's directory (and presumably other bookmaker repo's).


See the main documentation for more information about bookmaker generally [here: https://github.com/macmillanpublishers/bookmaker](https://github.com/macmillanpublishers/bookmaker).
