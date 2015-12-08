do

function run(msg, matches)
  return 'ZAC Team Robot v1.3'.. [[ 
  Website:
  http://ZAC.shayan-soft.IR
  Channel: @ZACteam
  Sudo: @shayansoft
  Powered by:
  shayan soft Co. Group
  http://shayan-soft.IR
  Engineer Shayan Ahmadi]]
end

return {
  description = "Robot About", 
  usage = "!ver: View Robot About",
  patterns = {
    "^!ver$"
  }, 
  run = run 
}

end
