# Description:
#  Morning
#
# Dependencies:
#  None
#
# Configuration:
#  None
#
# Commands:
#  morning - Reply morning
#
# Notes:
#  None
#
# Author:
#  jjm

module.exports = (robot) ->
  robot.hear /^morning$/i, (res) ->
    res.reply "Morning #{res.message.user.name}!"
