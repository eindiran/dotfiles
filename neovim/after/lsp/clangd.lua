-- clangd flags. nvim-lspconfig supplies filetypes and root markers.
return {
    cmd = { "clangd", "--clang-tidy", "--background-index", "--offset-encoding=utf-8" },
}
