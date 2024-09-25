local commands = require("java-maven-test.commands")

local M = {}

function M.setup()
    commands.register()
end

return M
