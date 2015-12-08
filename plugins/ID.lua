local function user_print_name(user)
   if user.print_name then
      return user.print_name
   end
   local text = ''
   if user.first_name then
      text = user.last_name..' '
   end
   if user.lastname then
      text = text..user.last_name
   end
   return text
end

local function returnids(cb_extra, success, result)
   local receiver = cb_extra.receiver
   local chat_id = result.id
   local chatname = result.print_name

   local text = 'Group Name & ID: \n > '..chatname..' ('..chat_id..')\n'
      ..result.members_num..' Members in Group'
      ..'\n_________________________\n'
      i = 0
   for k,v in pairs(result.members) do
      i = i+1
      text = text .. i .. "> " .. string.gsub(v.print_name, "_", " ") .. " (" .. v.id .. ")\n"
   end
   send_large_msg(receiver, text)
end

local function username_id(cb_extra, success, result)
   local receiver = cb_extra.receiver
   local qusername = cb_extra.qusername
   local text = 'No @'..qusername..' in Group!'
   for k,v in pairs(result.members) do
      vusername = v.username
      if vusername == qusername then
      	text = 'Username: '..vusername..'\nID: '..v.id
      end
   end
   send_large_msg(receiver, text)
end

local function run(msg, matches)
   local receiver = get_receiver(msg)
   if matches[1] == "!id" then
      local text = 'Your Name : '.. string.gsub(user_print_name(msg.from),'_', ' ') .. '\nYour ID : ' .. msg.from.id
      return text
   elseif matches[1] == "chat" then
      if matches[2] and is_sudo(msg) then
         local chat = 'chat#id'..matches[2]
         chat_info(chat, returnids, {receiver=receiver})
      else
         if not is_chat_msg(msg) then
            return "Works in Group"
         end
         local chat = get_receiver(msg)
         chat_info(chat, returnids, {receiver=receiver})
      end
   else
   	if not is_chat_msg(msg) then
   		return "Works in Group"
   	end
   	local qusername = string.gsub(matches[1], "@", "")
   	local chat = get_receiver(msg)
   	chat_info(chat, username_id, {receiver=receiver, qusername=qusername})
   end
end

local function run(msg, matches)
   local receiver = get_receiver(msg)
   if matches[1] == "!id chat" then
      if is_chat_msg(msg) then
        local text = "Group Name: " .. string.gsub(user_print_name(msg.to), '_', ' ') .. "\nGroup ID: " .. msg.to.id
      else
   	    local text = 'Works in Group'
      end
      return text
   end
end

return {
   description = "Member and Chat IDs Info",
   usage = {
      "!id: Your ID",
      "!id <@User> : @User ID"
	  "!id chat: Group ID",
      "!ids chat: All Member IDs in Group",
      "!ids chat <Group ID>: All Member IDs in Group ID",
   },
   patterns = {
      "^!id$",
      "^!id (.*)$"
      "^!id chat$",
      "^!ids? (chat) (%d+)$",
      "^!ids? (chat)$",
   },
   run = run
}
