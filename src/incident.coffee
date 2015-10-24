# Description:
#   Invoke an incident
#
# Dependencies:
#  hubot-auth
#
# Configuration:
#  HUBOT_SLACK_WebAPI_TOKEN - An Slack API test key (it's a work in progress).
#
# Commands:
#   ! incident new   - Invloke a incident (requires incident role in hubot-auth).
#   ! incident close - Close the incident (requires incident role in hubot-auth).
#
# Notes:
#  This is a proof of concept, so it may not always work ;-)
#  It will need to hook into a user permissions to use the Web API in the right
#  manner (I think).
#
# Author:
#  jjm

channel_setPurpose = (res, channel, purpose) ->
  HubotAPIKey = process.env.HUBOT_SLACK_TOKEN
  WebHookAPIKey = process.env.HUBOT_SLACK_WebAPI_TOKEN

  url = "https://slack.com/api/channels.setPurpose?token=#{WebHookAPIKey}&channel=#{channel}&purpose='#{purpose}'"
  #url = "https://slack.com/api/channels.setPurpose?token=#{HubotAPIKey}&channel=#{channel}&purpose='#{purpose}'"

  res.robot.logger.warning "channel_setPurpose: Setting to '#{purpose}' for channel #{channel}"

  res.http(url).get() (error, responce, body) ->
      if error then res.send error

      data = null
      try
        data = JSON.parse(body)
      catch error
        res.send "Ran into error parsing error :-("
        return

      if data.ok
        res.robot.logger.warning "channel_setPurpose: success body '#{body}'"
        res.send "Successuly set purpose"
      else
        res.robot.logger.warning "channel_setPurpose: failed body '#{body}'"
        res.send "ERROR: Could not set purpose"
        false

channel_archive = (res, channel) ->
  HubotAPIKey = process.env.HUBOT_SLACK_TOKEN
  WebHookAPIKey = process.env.HUBOT_SLACK_WebAPI_TOKEN

  url = "https://slack.com/api/channels.archive?token=#{WebHookAPIKey}&channel=#{channel}"

  res.robot.logger.warning "Archiveing channel #{channel}"

  res.http(url).get() (error, responce, body) ->
      if error then res.send error

      data = null
      try
        data = JSON.parse(body)
      catch error
        res.send "Ran into error parsing error :-("
        return

      if data.ok
        res.robot.logger.warning "Successfully archived channel #{channel} - #{body}"
        return true
      else
        res.robot.logger.warning "Failed to archive channel #{channel} - #{body}"
        return false

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

      NewIncidentDate = "#{year}-#{month}-#{day}"

      if NewIncidentDate == LastIncidentDate
        NewIncidentID = LastIncidentID + 1
        robot.logger.warning "IncidentDate is #{NewIncidentDate} == #{LastIncidentDate} - Incident ID: #{NewIncidentID}"
      else
        NewIncidentID = 1
        robot.logger.warning "IncidentDate is #{NewIncidentDate} != #{LastIncidentDate} - Incident ID: #{NewIncidentID}"
        robot.brain.set 'LastIncidentDate', NewIncidentDate

      FullIncidentID = "#{NewIncidentDate}_#{NewIncidentID}"

      robot.brain.set 'LastIncidentID', NewIncidentID
      robot.brain.set 'LastIncidentDate', NewIncidentDate
      robot.brain.set 'IncidentName', res.match[1]
      robot.brain.set 'IncidentID', FullIncidentID

      HubotAPIKey = process.env.HUBOT_SLACK_TOKEN
      WebHookAPIKey = process.env.HUBOT_SLACK_WebAPI_TOKEN
      url = "https://slack.com/api/channels.create?token=#{WebHookAPIKey}&name=inc_#{FullIncidentID}"

      res.robot.http(url)
       .header('Accept', 'application/json')
       .get() (err, response, body) ->

         #if response.getHeader('Content-Type') isnt 'application/json'
         #  res.send 'Did not get back JSON :-('
         #  return

         data = null
         try
           data = JSON.parse(body)
         catch error
           res.send "Ran into error parsing error :-("

         if data.ok
           robot.logger.warning "channel_create - body #{body}"
           robot.logger.warning "channel_create - id #{data.channel.id}"

           robot.brain.set 'IncidentChannelID', data.channel.id

           robot.logger.warning "Incident Channel ID from Brain is: #{robot.brain.get('IncidentChannelID')}"

           res.reply "Invoking <\##{robot.brain.get('IncidentChannelID')}> for *#{robot.brain.get('IncidentName')}*"

           channel_setPurpose res, robot.brain.get('IncidentChannelID'), "Commincation channel for #{robot.brain.get('IncidentName')} Incident"

         else
           res.send "channel_create failed "
    else
      res.reply "*DENIED* #{res.envelope.user.name} not got #{required_role} role"

  robot.respond /incident close/i, (res) ->
    required_role = 'incident'

    if robot.auth.hasRole(res.envelope.user, required_role) 
      if robot.brain.get('IncidentID') != null
        if channel_archive res, "#{robot.brain.get('IncidentChannelID')}"
          res.reply "Closed <\##{robot.brain.get('IncidentChannelID')}> for *#{robot.brain.get('IncidentName')}*"

          robot.brain.set 'IncidentID', null
          robot.brain.set 'IncidentName', null
          robot.brain.set 'IncidentChannelID', null
        else
          # This does not seem to get called...
          res.reply "Failed to close Incident #{robot.brain.get('IncidentID')} (#{robot.brain.get('IncidentChannelID')}): #{robot.brain.get('IncidentName')}"
      else
        res.reply "No incident to close!"
    else 
      res.reply "*DENIED:* You do not have the _#{required_role}_ role"
