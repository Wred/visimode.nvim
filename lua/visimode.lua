local M = {}

M.setup = function ()
	vim.api.nvim_set_hl(0, "NormalInsert", {bg="gray"})
-- 	hi NormalInsert guibg=gray
-- 	au InsertEnter * setlocal winhighlight=Normal:NormalInsert
-- 	au InsertLeave * setlocal winhighlight=
end

vim.api.nvim_create_autocmd('InsertEnter', {
	callback = function()
		vim.api.nvim_cmd({
			cmd = "setlocal",
			args = {
				"winhighlight=Normal:NormalInsert"
			},
		},{})
		-- vim.api.nvim_set_hl(0, "Normal", "NormalInsert")
	end
})

vim.api.nvim_create_autocmd('InsertLeave', {
	callback = function()
		vim.api.nvim_cmd({
			cmd = "setlocal",
			args = {
				"winhighlight="
			},
		},{})
		-- vim.api.nvim_set_hl(0, "Normal", {})
	end
})

-- function M.vim.background_blend(color, strength)
-- 	local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background or "3213215"
-- 	local blend_color = lush.hsl(color)
-- 	return lush.hsl("#" .. string.format("%06x", bg_color)).mix(blend_color, strength).hex
-- end
-- function M.vim.highlight_blend_bg(hl_name, strength, color, full)
-- 	local old_hl = nil
-- 	local fetch_old_hl = function()
-- 		if color == nil then
-- 			local _old_hl = vim.api.nvim_get_hl_by_name(hl_name, true)
-- 			old_hl = _old_hl and _old_hl.background or "3213215"
-- 		end
-- 	end
-- 	if pcall(fetch_old_hl) or color then
-- 		local hl_guibg = M.vim.background_blend(color or ("#" .. string.format("%06x", old_hl)), strength)
-- 		vim.api.nvim_set_hl(0, hl_name, { background = hl_guibg })
-- 	end
-- end 

return M

