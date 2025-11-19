vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("gpapadok.util")
require("gpapadok.config")
require("gpapadok.lazy")
require("gpapadok.options")
require("gpapadok.keymaps")

if os.getenv("LWDEV") == "True" then
  require("gpapadok.lw")
end
