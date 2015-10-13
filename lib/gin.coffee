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
#  hubot gin me - Time for gin?
#  hubot gin all - Time for gin?
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

  robot.respond /gin me/i, (res) ->
    res.reply "Hands #{res.message.user.name} a gin!"

  robot.respond /gin all/i, (res) ->
    res.reply "Hands <@group> gin's!"
