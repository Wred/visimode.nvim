-- Basically the equivalent of:
-- 	hi NormalInsert guibg=gray
-- 	au InsertEnter * setlocal winhighlight=Normal:NormalInsert
-- 	au InsertLeave * setlocal winhighlight=

local config = require("visimode.config")
local Color = require("visimode.import.colors.colors")

---@class visimode.Init
local M = {}

local AUGROUP = "VisimodeCommands"

M.setup = function (opts)
	config.setup(opts)

	local bg_color_original = vim.api.nvim_get_hl(0, {
		name = "Normal",
		create = false,
	}).bg

	local bg_color_new = Color.new(string.format("#%x", bg_color_original))
	bg_color_new = bg_color_new:lighten_by(config.opts.lighten_by)

	-- print ("old color: ", string.format("#%x", bg_color_original), "new color: ", bg_color_new:to_rgb())

	vim.api.nvim_create_augroup(AUGROUP, {clear = true})

	vim.api.nvim_set_hl(0, "NormalInsert", {bg = bg_color_new:to_rgb()})

	vim.api.nvim_create_autocmd('InsertEnter', {
		group = AUGROUP,
		callback = function()
			vim.api.nvim_cmd({
				cmd = "setlocal",
				args = {
					"winhighlight=Normal:NormalInsert"
				},
			},{})
		end
	})

	vim.api.nvim_create_autocmd('InsertLeave', {
		group = AUGROUP,
		callback = function()
			vim.api.nvim_cmd({
				cmd = "setlocal",
				args = {
					"winhighlight="
				},
			},{})
		end
	})

end

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

