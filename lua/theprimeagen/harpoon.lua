
require("harpoon").setup({
    projects = {
        ["C:\\Source\\ConnectBooster\\ConnectBooster.Frontend"] = {
            term = {
                cmds = {
                    "bash -c 'ng s'",
                    "bash -c 'ng t'",
                }
            }
        }
    }
})

