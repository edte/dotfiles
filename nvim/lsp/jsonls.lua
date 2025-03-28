return {
    name = "jsonls",
    filetypes = { "json" },
    single_file_support = true,
    root_markers = { '.git', 'Makefile' },
    cmd = { 'vscode-json-language-server', '--stdio' },
    init_options = {
        provideFormatter = true,
    },
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}
