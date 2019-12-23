# file_scaffold
Takes any directory structure, and creates modified copies of that structure using tokens for replacement.
This allows you to easily create components for your projects, be it similar skeletons or completely different types.

# Command-line usage

You can install this package either globally or locally in your package and use the command line tools for configs.

    pub global activate file_scaffold

You can access the command-line usage args using `pub global run file_scaffold -h`:

    -n, --name                                     Name of this scaffold, to be used in folder name (if
                                                  --create-subfolder is used) and file templates.

    -o, --output-dir                               Directory to output the template files to. They will
                                                   maintain their original directory structure.

    -C, --[no-]create-subfolder                    Create subfolder at the output directory, using the
                                                   scaffold's name.

    -t, --templates=<path/to/templates/**.json>    List of templates to get files from. You may supply a
                                                   glob string to include only files using that pattern.

    -l, --locals=<key="value" [, ...]>             List of key-value mappings of locals to pass to the
                                                   scaffold.

    -h, --help                                     Display this help message.

