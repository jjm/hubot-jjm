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
    res.reply "Goodight #{res.message.user.name}!"

  robot.hear /goodnight/i, (res) ->
    res.reply "Goodight #{res.message.user.name}!"
