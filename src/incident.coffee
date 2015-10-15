# Description:
#   Invoke an incident
#
# Commands:
#   hubot incident new   - Invloke a new incident
#   hubot incident close - Close the inclident for the current channel
#
module.exports = (robot) ->
  robot.respond /incident new (.*)/i, (res) ->
    year  = new Date().getFullYear()
    month = new Date().getMonth()
    day   = new Date().getDate()
    mi_id = 1

    res.reply "Invoking Incident (#{year}-#{month}-#{day}_#{mi_id}): #{res.match[1]}"

  robot.respond /incident close/i, (res) ->
    res.reply "Closing MI (#{Date.now()} ): #{res.match[1]}"

