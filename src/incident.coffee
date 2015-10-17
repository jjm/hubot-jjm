# Description:
#   Invoke an incident
#
# Dependencies:
#  hubot-auth
#
# Configuration:
#  None
#
# Commands:
#   ! incident new   - Invloke a incident (requires incident role in hubot-auth).
#   ! incident close - Close the inclident (requires incident role in hubot-auth).
#
# Notes:
#  None
#
# Author:
#  jjm

module.exports = (robot) ->

  robot.respond /incident new (.*)/i, (res) ->
    required_role = 'incident'

    if robot.auth.hasRole(res.envelope.user, required_role)
      if robot.brain.get('IncidentID') != null
        res.reply "Can't start new incident, #{robot.brain.get('IncidentID')} still inprogress"
        return

      year  = new Date().getFullYear()
      month = new Date().getMonth() + 1
      day   = new Date().getDate()

      LastIncidentDate = robot.brain.get('LastIncidentDate')
      LastIncidentID = robot.brain.get('LastIncidentID')

      IncidentDate = "#{year}-#{month}-#{day}"

      if LastIncidentDate is LastIncidentDate
        IncidentID = LastIncidentID + 1
        robot.brain.set 'LastIncidentID', IncidentID
      else
        IncidentID = 1
        robot.brain.set 'LastIncidentDate', LastIncidentDate

      robot.brain.set 'IncidentID', "#{IncidentDate}.#{IncidentID}"
      robot.brain.set 'IncidentName', res.match[1]

      res.reply "Invoking Incident (#{robot.brain.get('IncidentID')}): #{robot.brain.get('IncidentName')}"
    else
      res.reply "*DENIED* #{res.envelope.user.name} not got #{required_role} role"

  robot.respond /incident close/i, (res) ->
    required_role = 'incident'

    if robot.auth.hasRole(res.envelope.user, required_role) 
      if robot.brain.get('IncidentID') != null
        res.reply "Closing Incident (#{robot.brain.get('IncidentID')}): #{robot.brain.get('IncidentName')}"

        robot.brain.set 'IncidentID', null
        robot.brain.set 'IncidentName', null
      else
        res.reply "No incident to close!"
    else 
      res.reply "*DENIED:* You do not have the _#{required_role}_ role"
