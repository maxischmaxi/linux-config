vim.api.nvim_create_user_command("Studienarbeit", function()
    vim.api.nvim_command('silent !latexmk -pdf studienarbeit.tex -f')
end, {})

