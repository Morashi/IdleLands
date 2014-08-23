
Spell = require "../../../base/Spell"

class Treatment extends Spell
  name: "treatment"
  @element = Treatment::element = Spell::Element.heal & Spell::Element.buff
  @cost = Treatment::cost = 400
  @restrictions =
    "Generalist": 7

  calcDuration: -> super()+3

  determineTargets: ->
    @targetSomeAllies()

  calcDamage: (player) ->
    Math.floor (player.hp.maximum * 0.07)

  cast: (player) ->
    message = "#{@caster.name} began treating #{player.name}'s wounds with #{@name}!"
    @broadcast message

  uncast: (player) ->
    message = "#{@caster.name} is no longer treating #{player.name} with #{@name}."
    @broadcast message

  tick: (player) ->
    restored = @calcDamage player
    message = "#{@caster.name}'s #{@name} restored #{restored} HP for #{player.name}!"
    @doDamageTo player, -restored
    @broadcastBuffMessage message

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      "combat.self.turn.end": @tick
      doSpellCast: @cast
      doSpellUncast: @uncast

module.exports = exports = Treatment