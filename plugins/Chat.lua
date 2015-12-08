do

function run(msg, matches)
  return "Hi Back " .. matches[1] .. " :)"
end

return {
  description = "Chat With Robot", 
  usage = "Chat With Robot, Only English",
  patterns = {
    "^Hi (.*)$",
    "^hi (.*)$"
  }, 
  run = run 
}

end
