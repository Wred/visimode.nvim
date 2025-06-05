-- inspired by nvim-tree's config management
-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/lua/nvim-tree.lua
--

local DEFAULT_OPTS = { -- BEGIN_DEFAULT_OPTS
	lighten_by = 0.9,
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
		},
	},
}

local FIELD_SKIP_VALIDATE = {
	open_win_config = true,
}

local ACCEPTED_TYPES = {
	lighten_by = { "number" },
}

local ACCEPTED_STRINGS = {
}

---@param conf table|nil
local function validate_options(conf)
	local msg

	---@param user any
	---@param def any
	---@param strs table
	---@param types table
	---@param prefix string
	local function validate(user, def, strs, types, prefix)
		-- if user's option is not a table there is nothing to do
		if type(user) ~= "table" then
			return
		end

		-- only compare tables with contents that are not integer indexed
		if type(def) ~= "table" or not next(def) or type(next(def)) == "number" then
			-- unless the field can be a table (and is not a table in default config)
			if vim.tbl_contains(types, "table") then
				-- use a dummy default to allow all checks
				def = {}
			else
				return
			end
		end

		for k, v in pairs(user) do
			if not FIELD_SKIP_VALIDATE[k] then
				local invalid

				if def[k] == nil and types[k] == nil then
					-- option does not exist
					invalid = string.format("Unknown option: %s%s", prefix, k)
				elseif type(v) ~= type(def[k]) then
					local expected

					if types[k] and #types[k] > 0 then
						if not vim.tbl_contains(types[k], type(v)) then
							expected = table.concat(types[k], "|")
						end
					else
						expected = type(def[k])
					end

					if expected then
						-- option is of the wrong type
						invalid = string.format("Invalid option: %s%s. Expected %s, got %s", prefix, k, expected, type(v))
					end
				elseif type(v) == "string" and strs[k] and not vim.tbl_contains(strs[k], v) then
					-- option has type `string` but value is not accepted
					invalid = string.format("Invalid value for field %s%s: '%s'", prefix, k, v)
				end

				if invalid then
					if msg then
						msg = string.format("%s\n%s", msg, invalid)
					else
						msg = invalid
					end
					user[k] = nil
				else
					validate(v, def[k], strs[k] or {}, types[k] or {}, prefix .. k .. ".")
				end
			end
		end
	end

	validate(conf, DEFAULT_OPTS, ACCEPTED_STRINGS, ACCEPTED_TYPES, "")

	if msg then
		print (msg .. "\n\nsee :help nvim-tree-opts for available configuration options")
	end
end

local function merge_options(conf)
	return vim.tbl_deep_extend("force", DEFAULT_OPTS, conf or {})
end



local M = {
	opts = {}
}

---@param conf table|nil
function M.setup(conf)
	if vim.fn.has("nvim-0.9") == 0 then
		print ("nvim-tree.lua requires Neovim 0.9 or higher")
		return
	end

	validate_options(conf)
	local opts = merge_options(conf)

	M.opts = opts
end

return M
