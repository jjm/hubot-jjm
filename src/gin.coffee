# Description:
#  Gin releated hubot interactions
#
# Dependencies:
#  None
#
# Configuration:
#  None
#
# Commands:
#  ! gin me - Time for gin?
#  ! gin all - Time for gin?
#  too early for gin - Annother silly question
#  gin time - Silly question
#
# Notes:
#  None
#
# Author:
#  jjm

module.exports = (robot) ->
  robot.hear /gin time/i, (res) ->
    res.reply "Yes, #{res.message.user.name} it's time for gin."

  robot.hear /too early for gin?/i, (res) ->
    res.reply "It's never too early for gin #{res.message.user.name}!"

  robot.respond /gin me/i, (res) ->
    res.reply "Hands #{res.message.user.name} a gin!"

  robot.respond /gin all/i, (res) ->
    res.reply "Hands <@group> gin's!"
