-- rust-analyzer: run clippy instead of cargo check on save.
return {
    settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
}
