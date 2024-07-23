local M = {}

function M.get_test_methods()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, 'java')
    local tree = parser:parse()[1]

    local query = [[
        (method_declaration
          (modifiers
            (marker_annotation
              (identifier) @annotation (#eq? @annotation "Test")))
          (identifier) @test_name)
    ]]

    local ts_query = vim.treesitter.query.parse("java", query)

    local tests = {}
    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "test_name" then
            local test_name = vim.treesitter.get_node_text(node, bufnr)
            table.insert(tests, test_name)
        end
    end

    return tests
end


function M.get_java_class()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local query = [[
        (class_declaration
          name: (identifier) @class_name
        )
    ]]

    local ts_query = vim.treesitter.query.parse("java", query)

    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "class_name" then
            local class_name = vim.treesitter.get_node_text(node, bufnr)
            return class_name
        end
    end

end

function M.is_test_name_valid(test_name)
    local is_one_word = not string.match(test_name, "%s")
    local contains_test_keyword = string.match(test_name, "%l*test%u*") or string.match(test_name, "%u*Test%l*")

    return is_one_word and contains_test_keyword
end

return M
