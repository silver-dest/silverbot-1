do

local function callback(extra, success, result)
  vardump(success)
  vardump(result)
end

local function run(msg, matches)
  local user = matches[2]

  if matches[1] == "" then
    user = string.gsub(user," ","_")
  end
  
  if matches[1] == "id" then
    user = 'user#id'..user
  end
  
  if msg.to.type == 'chat' then
    local chat = 'chat#id'..msg.to.id
    chat_add_user(chat, user, callback, false)
    return "@"..user.." Added"
  else 
    return 'Works in Group'
  end
end

return {
  description = "Invite Member by Username or ID", 
  usage = {
    "!invite <@User> : Invite by Username", 
    "!invite id <ID> : Invite by ID" },
  patterns = {
    "^!invite () (.*)$",
    "^!invite (id) (%d+)$"
  }, 
  run = run,
  moderation = true 
}

end
