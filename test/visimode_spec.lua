local function test(name, fn)
	local ok, err = pcall(fn)
	if ok then
		print('PASS: ' .. name)
	else
		print('FAIL: ' .. name .. ' - ' .. tostring(err))
		vim.g.test_failed = true
	end
end

local function assert_eq(expected, actual, msg)
	if expected ~= actual then
		error((msg or 'assertion failed') .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
	end
end

local function assert_truthy(value, msg)
	if not value then
		error((msg or 'assertion failed') .. ': expected truthy value')
	end
end

-- Set up a Normal highlight so Color module can read background
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e1e" })

local visimode = require('visimode')
local config = require('visimode.config')

-- Tests

test('setup with defaults succeeds', function()
	visimode.setup()
end)

test('highlight group is created', function()
	visimode.setup()
	local hl = vim.api.nvim_get_hl(0, { name = 'VisimodeInsert' })
	assert_truthy(hl.bg, 'highlight bg should be set')
end)

test('commands are registered', function()
	visimode.setup()
	local commands = vim.api.nvim_get_commands({})
	assert_truthy(commands.VisimodeEnable, 'VisimodeEnable command should exist')
	assert_truthy(commands.VisimodeDisable, 'VisimodeDisable command should exist')
	assert_truthy(commands.VisimodeToggle, 'VisimodeToggle command should exist')
end)

test('disable function works', function()
	visimode.setup({ enabled = true })
	visimode.disable()
	assert_eq(false, config.opts.enabled, 'enabled should be false after disable')
end)

test('enable function works', function()
	visimode.setup({ enabled = false })
	visimode.enable()
	assert_eq(true, config.opts.enabled, 'enabled should be true after enable')
end)

test('toggle function works', function()
	visimode.setup({ enabled = true })
	visimode.toggle()
	assert_eq(false, config.opts.enabled, 'enabled should be false after first toggle')
	visimode.toggle()
	assert_eq(true, config.opts.enabled, 'enabled should be true after second toggle')
end)

test('custom lighten_by is applied', function()
	visimode.setup({ lighten_by = 0.5 })
	assert_eq(0.5, config.opts.lighten_by, 'lighten_by should be 0.5')
end)

test('setup can be called multiple times without duplicate autocmds', function()
	visimode.setup()
	visimode.setup()
	visimode.setup()
	local autocmds = vim.api.nvim_get_autocmds({ group = 'VisimodeCommands' })
	assert_eq(2, #autocmds, 'should have exactly 2 autocmds')
end)

-- Summary
if vim.g.test_failed then
	print('\nSome tests failed!')
	vim.cmd('cq 1')
else
	print('\nAll tests passed!')
end
