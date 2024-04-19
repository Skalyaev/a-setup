return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "BufRead",
    cmd = "CopilotChatToggle",
    dependencies = {
        { "github/copilot.vim" },
        { "nvim-lua/plenary.nvim" },
    },
    opts = {
        debug = true,
        window = { layout = "horizontal" },
    },
}
