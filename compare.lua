#!/usr/bin/lua -e
local lfs = require 'lfs'
local _args = arg[1]
local lua_source = false
if _args then
	local lua_compare_dir_1 = _args:match("dir_1=(%S+)")
	if not lua_compare_dir_1 then
		print("Please set dir_1=directory_1")
		return
	end
	local lua_compare_dir_2 = _args:match("dir_2=(%S+)")
	local lua_compare_mode = _args:match("mode=(%S+)")
	if not lua_compare_mode then
		print("Please set mode=(file|document|whatever)")
		return
	end
	local lua_source_name = _args:match("source=(%S+)")
	if lua_source_name then
		lua_source = require(lua_source_name)
	end
	if not lua_compare_dir_2 and not lua_source then
		print("Please set dir_2=directory_2 or source=lua_file and variable=var_from_lua_file")
		return
	end
	if lua_source then
		local lua_source_var = _args:match("variable=(%S+)")
		if not lua_source_var then
			print("Please, use: variable=name_var.")
			return
		end
		variable_from_source = lua_source[lua_source_var]
		if not variable_from_source then
			print("Variable "..lua_source_var.." not found in file "..lua_source_name)
			return
		end
	elseif lua_compare_dir then

	end
	local first_table = {}
	if lua_compare_mode then
		for file in lfs.dir(lua_compare_dir_1) do
			if lfs.attributes(lua_compare_dir_1.."/"..file, "mode") == lua_compare_mode then
				table.insert(first_table, file)
			end
		end
	else
		for file in lfs.dir(lua_compare_dir_1) do
			table.insert(first_table, file)
		end
	end
	local second_table = {}
	if variable_from_source and type(variable_from_source) == "table" then
		second_table = variable_from_source
	else
		if lua_compare_mode then
			for file in lfs.dir(lua_compare_dir_2) do
				if lfs.attributes(lua_compare_dir_2.."/"..file, "mode") == lua_compare_mode then
					table.insert(second_table, file)
				end
			end
		else
			for file in lfs.dir(lua_compare_dir_2) do
				table.insert(second_table, file)
			end
		end
	end
	for a,b in pairs(first_table) do
		local it_has_file = false
		for c,d in pairs(second_table) do
			if b == d then
				it_has_file = true
			end
		end
		if not it_has_file then
			print(b.."\tnot common.")
		end
	end
end
