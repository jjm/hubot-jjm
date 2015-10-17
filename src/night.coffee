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
#  night - time for bed
#  goodnight - time for bed
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
    @exec = require('child_process').exec
    command = "echo poweroff"
    required_role = "poweroff"

    if robot.auth.hasRole(res.envelope.user, required_role)
      res.reply "Goodight #{res.message.user.name}!"
      res.reply "Now running *#{command}* "   
      @exec command, (error, stdout, stderr) ->
        if error then res.send "Encountered an error :( #{error}"
        if stderr then res.send "STDERR: #{stderr}"
        if stdout then res.send "STDOUT: #{stdout}"
    else 
      res.reply "*DENIED* as you do not have the _#{required_role}_ role!"
