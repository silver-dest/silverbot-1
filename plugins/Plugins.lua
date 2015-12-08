do

local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  return false
end

local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end

local function list_all_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    local status = '❌'
    nsum = nsum+1
    nact = 0
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      v = string.match (v, "(.*)%.lua")
      text = text..nsum..'. '..v..'  '..status..'\n'
    end
  end
  local text = text..'\nAll Plugins: '..nsum..' \nEnabled Plugins: '..nact..' \nDisabled Plugins: '..nsum-nact
  return text
end

local function list_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    local status = '❌'
    nsum = nsum+1
    nact = 0
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      v = string.match (v, "(.*)%.lua")
      text = text..v..'  '..status..'\n'
    end
  end
  local text = text..'\nAll Plugins: '..nsum..' \nEnabled Plugins: '..nact
  return text
end

local function reload_plugins( )
  plugins = {}
  load_plugins()
  return list_plugins(true)
end


local function enable_plugin( plugin_name )
  print('checking if '..plugin_name..' exists')
  if plugin_enabled(plugin_name) then
    return 'Plugin '..plugin_name..' is Enable'
  end
  if plugin_exists(plugin_name) then
    table.insert(_config.enabled_plugins, plugin_name)
    print(plugin_name..' added to _config table')
    save_config()
    return reload_plugins( )
  else
    return 'Can Not Find '..plugin_name..' Plugin'
  end
end

local function disable_plugin( name, chat )
  if not plugin_exists(name) then
    return 'Can Not Find '..name..' Plugin'
  end
  local k = plugin_enabled(name)
  if not k then
    return 'Plugin '..name..' is Not Enabled'
  end
  table.remove(_config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true)    
end

local function disable_plugin_on_chat(receiver, plugin)
  if not plugin_exists(plugin) then
    return "Plugin Does Not Exists"
  end

  if not _config.disabled_plugin_on_chat then
    _config.disabled_plugin_on_chat = {}
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    _config.disabled_plugin_on_chat[receiver] = {}
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  return 'Plugin '..plugin..' Disabled in Group'
end

local function reenable_plugin_on_chat(receiver, plugin)
  if not _config.disabled_plugin_on_chat then
    return 'There Are Not Any Disabled Plugins'
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    return 'There Are Not Any Disabled Plugins For This Group'
  end

  if not _config.disabled_plugin_on_chat[receiver][plugin] then
    return 'This Plugin is Not Disabled'
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  return 'Plugin '..plugin..' Re-Enabled'
end

local function run(msg, matches)
  if matches[1] == '!plugins' and is_sudo(msg) then
    return list_all_plugins()
  end

  if matches[1] == '+' and matches[3] == 'gp' then
    local receiver = get_receiver(msg)
    local plugin = matches[2]
    print("Plugin "..plugin..' Enabled in Group')
    return reenable_plugin_on_chat(receiver, plugin)
  end

  if matches[1] == '+' and is_sudo(msg) then
    local plugin_name = matches[2]
    print("enable: "..matches[2])
    return enable_plugin(plugin_name)
  end

  if matches[1] == '-' and matches[3] == 'gp' then
    local plugin = matches[2]
    local receiver = get_receiver(msg)
    print("disable "..plugin..' on this chat')
    return disable_plugin_on_chat(receiver, plugin)
  end

  if matches[1] == '-' and is_sudo(msg) then
    if matches[2] == 'plugins' then
    	return 'Can Not Disabled This Plugin'
    end
    print("disable: "..matches[2])
    return disable_plugin(matches[2])
  end

  if matches[1] == 'reload' and is_sudo(msg) then
    return reload_plugins(true)
  end
end

return {
  description = "Robot and Group Plugin Manager", 
  usage = {
      moderator = {
          "!plugins - <Name> gp : Disable Plugin in Group",
          "!plugins + <Name> gp : Enable Plugin in Group",
          },
      sudo = {
		  "!plugins : Plugins List",
		  "!plugins reload : Reload Robot Plugins",
		  "!plugins - <Name> : Disable Plugin in Robot",
          "!plugins + <Name> : Enable Plugin in Robot",
          },
  patterns = {
    "^!plugins$",
    "^!plugins? (+) ([%w_%.%-]+)$",
    "^!plugins? (-) ([%w_%.%-]+)$",
    "^!plugins? (+) ([%w_%.%-]+) (gp)",
    "^!plugins? (-) ([%w_%.%-]+) (gp)",
    "^!plugins? (reload)$" },
  run = run,
  moderated = true,
}

end
