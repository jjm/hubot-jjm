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
    POWER_OFF_USERS = [ 'jjm' ]

    @exec = require('child_process').exec
    command = "sudo poweroff"

    res.reply "Goodight #{res.message.user.name}!"
    if res.message.user.name in POWER_OFF_USERS
      res.reply "Now running *#{command}* "   
      @exec command, (error, stdout, stderr) ->
        res.send error
        res.send stdout
        res.send stderr
    else 
      res.reply "Goodnight #{res.message.user.name}, but your not allowed to power me off :-P"

