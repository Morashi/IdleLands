
GuildBuilding = require "../GuildBuilding"

`/**
 * The GuildHall increases the maximum level of your other guild buildings!
 *
 * @name GuildHall
 * @category Buildings
 * @package Guild
 * @cost {level-up} level*[2500+level/100]
 * @size {lg}
 */`
class GuildHall extends GuildBuilding

  @size = GuildHall::size = "lg"
  @desc = GuildHall::desc = "Upgrade this building to make your other buildings more upgradeable!"
  @levelupCost = GuildHall::levelupCost = (level) -> level * (2500+(1000*Math.floor level/100))

  tiles: [
    0,  0,  0,  0,  0,  0,  0,
    0,  49, 49, 49, 49, 49, 0,
    0,  49, 49, 49, 49, 49, 0,
    0,  49, 49, 49, 49, 49, 0,
    0,  49, 49, 49, 49, 49, 0,
    0,  49, 49, 49, 49, 49, 0,
    0,  0,  0,  0,  0,  0,  0
  ]

module.exports = exports = GuildHall