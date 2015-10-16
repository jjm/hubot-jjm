# Description:
#  Night time 
#
# Dependencies:
#  None
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
    POWER_OFF_USERS = [ 'jjm', 'jon.middleton' ]

    @exec = require('child_process').exec
    command = "echo poweroff"

    res.reply "Goodight #{res.message.user.name}!"
    if res.message.user.name in POWER_OFF_USERS
      res.reply "Now running *#{command}* "   
      @exec command, (error, stdout, stderr) ->
        if error then res.send "Encountered an error :( #{error}"
        if stderr then res.send "STDERR: #{stderr}"
        if stdout then res.send "STDOUT: #{stdout}"
    else 
      res.reply "Goodnight #{res.message.user.name}, but your not allowed to power me off :-P"
