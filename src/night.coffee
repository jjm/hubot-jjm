# Description:
#  Night time 
#
# Dependencies:
#  hubot-auth
#
# Configuration:
#  None
#
# Commands:
#  ! goodnight - time for bed (requires poweroff role in hubot-auth).
#  night - time for bed
#
# Notes:
#  None
#
# Author:
#  jjm

module.exports = (robot) ->
  robot.hear /night night/i, (res) ->
    res.reply "Goodnight #{res.message.user.name}!"

  robot.respond /goodnight/i, (res) ->
    if robot.auth.hasRole(res.envelope.user, required_role)
      @exec = require('child_process').exec
      command = "echo poweroff"
      required_role = "poweroff"

      res.reply "Goodight #{res.message.user.name}!"
      res.reply "Now running *#{command}* "   

      @exec command, (error, stdout, stderr) ->
        if error then res.send "Encountered an error :( #{error}"
        if stderr then res.send "STDERR: #{stderr}"
        if stdout then res.send "STDOUT: #{stdout}"
    else 
      res.reply "*DENIED* as you do not have the _#{required_role}_ role!"
