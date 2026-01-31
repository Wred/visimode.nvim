local config = require("visimode.config")
local Color = require("visimode.import.colors.colors")

---@class visimode.Init
local M = {}

local AUGROUP = "VisimodeCommands"
local saved_winhighlight = {}

local function apply_highlight()
	if not config.opts.enabled then
		return
	end
	local win = vim.api.nvim_get_current_win()
	saved_winhighlight[win] = vim.wo[win].winhighlight
	local existing = saved_winhighlight[win]
	if existing and existing ~= "" then
		vim.wo[win].winhighlight = existing .. ",Normal:VisimodeInsert"
	else
		vim.wo[win].winhighlight = "Normal:VisimodeInsert"
	end
end

local function restore_highlight()
	local win = vim.api.nvim_get_current_win()
	if saved_winhighlight[win] ~= nil then
		vim.wo[win].winhighlight = saved_winhighlight[win]
		saved_winhighlight[win] = nil
	end
end

function M.enable()
	config.opts.enabled = true
end

function M.disable()
	config.opts.enabled = false
	restore_highlight()
end

function M.toggle()
	if config.opts.enabled then
		M.disable()
	else
		M.enable()
	end
end

function M.setup(opts)
	config.setup(opts)

	local bg_color_original = vim.api.nvim_get_hl(0, {
		name = "Normal",
		create = false,
	}).bg

	local bg_color_new = Color.new(string.format("#%x", bg_color_original))
	bg_color_new = bg_color_new:lighten_by(config.opts.lighten_by)

	vim.api.nvim_create_augroup(AUGROUP, { clear = true })

	vim.api.nvim_set_hl(0, "VisimodeInsert", { bg = bg_color_new:to_rgb() })

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = AUGROUP,
		callback = apply_highlight,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = AUGROUP,
		callback = restore_highlight,
	})

	vim.api.nvim_create_user_command("VisimodeEnable", M.enable, {})
	vim.api.nvim_create_user_command("VisimodeDisable", M.disable, {})
	vim.api.nvim_create_user_command("VisimodeToggle", M.toggle, {})
end

return M

