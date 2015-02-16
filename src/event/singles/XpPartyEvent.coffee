
Event = require "../Event"
MessageCreator = require "../../system/handlers/MessageCreator"
_ = require "lodash"

`/**
 * This event handles both the blessXp and forsakeXp aliases for parties.
 *
 * @name XP
 * @category Party
 * @package Events
 */`
class XpPartyEvent extends Event
  go: ->
    if not @event.remark
      @game.errorHandler.captureException new Error ("XP PARTY EVENT FAILURE"), extra: @event
      return

    return unless @player.party

    rangeManage =
      blessXpParty:
        f: 'max'
        v: 1
      forsakeXpParty:
        f: 'min'
        v: -1

    message = []
    for member in @player.party.players
      boost = member.calcXpGain @calcXpEventGain @event.type, member
      boost = Math[rangeManage[@event.type].f] boost, rangeManage[@event.type].v
      member.gainXp boost

      percent = boost/member.xp.maximum*100

      extra =
        xp: Math.abs boost
        realXp: boost
        percentXp: +(boost/member.xp.maximum*100).toFixed 3

      ##TAG:EVENT_EVENT: blessXpParty   | player, {xp, realXp, percentXp} | Emitted when a player gets some free xp while in a party
      ##TAG:EVENT_EVENT: forsakeXpParty | player, {xp, realXp, percentXp} | Emitted when a player loses xp while in a party
      member.emit "event.#{@event.type}", member, extra

      if @event.type is "blessXpParty"
        message.push "<player.name>#{member.name}</player.name> gained <event.xp>#{Math.abs boost}</event.xp>xp [~<event.xp>#{+(percent).toFixed 3}</event.xp>%]"
      else
        message.push "<player.name>#{member.name}</player.name> lost <event.xp>#{Math.abs boost}</event.xp>xp [~<event.xp>#{+(percent).toFixed 3}</event.xp>%]"

    extra =
      partyName: @player.party.name

    message = "#{MessageCreator.doStringReplace @event.remark, @player, extra} #{_.str.toSentenceSerial message}."

    @game.eventHandler.broadcastEvent {message: message, player: @player, extra: extra, type: 'exp'}

    for member in @player.party.players
      @game.eventHandler.broadcastEvent {message: message, player: member, extra: extra, sendMessage: no, type: 'exp'} if member isnt @player

    @grantRapportForAllPlayers @player.party, 3

module.exports = exports = XpPartyEvent