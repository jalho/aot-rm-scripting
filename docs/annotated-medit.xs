/*
* ANNOTATED MEDITERRANEAN from
*  C:\Program Files (x86)\Microsoft Games\Age of Mythology\docs\aom random map help file.rtf
*/

/*
* Main entry point for random map script. All scripts need to void out all previous commands, so
* always start with a void.
*/
void main(void)
{

  /*
  * Text. The status text is useful only in displaying the progress bar. You can also provide
  * information inside the quotations, such as “generating seas.”
  */
  rmSetStatusText("", 0.01);

  /*
  * Set size. This map defaults to placing 7500 tiles per player. If the map is generated as a
  * large map by the user, then it uses 9750 tiles instead. The integer for size is just converting
  * tiles to square meters and then reporting how large the map is.
  */
  int playerTiles = 7500;
  if (cMapSize == 1)
  {
    playerTiles = 9750;
    rmEchoInfo("Large map");
  }
  int size = 2.0 * sqrt(cNumberNonGaiaPlayers * playerTiles / 0.9);
  rmEchoInfo("Map size=" + size + "m x " + size + "m");
  rmSetMapSize(size, size);

  // Set up default water. We want the water level to be at 0 meters.
  rmSetSeaLevel(0.0);

  /*
  * Init map. We want the base water type to be Mediterranean Sea, but want the base texture that
  * is placed on the map to be not water, but land, using grassDirt25. If nothing else was done in
  * this script, we would have a large square of grassDirt25.
  */
  rmSetSeaType("mediterranean sea");
  rmTerrainInitialize("GrassDirt25");

  /*
  * Define some classes. Most of these classes will be used later for constraints, but keeping
  * them all in one location will make them easier to find later. Some are defined as integers, as
  * a shortcut for those cases where we reference the classes a lot, but classes can be done
  * either way.
  */
  int classPlayer = rmDefineClass("player");
  int classPlayerCore = rmDefineClass("player core");
  rmDefineClass("corner");
  rmDefineClass("classHill");
  rmDefineClass("center");
  rmDefineClass("starting settlement");

  /*
  * -------------Define constraints.
  *
  * We’re done with the basics and ready to get into placing areas and objects. I broke this
  * section out with the ----- marks just so it is easier to find when scrolling through a large
  * file. Next, we will set up the constraints. Again, keeping them all in one place makes it
  * easier to see what has been defined and if there are any constraints that can serve double
  * duty.
  */

  /*
  * Create a edge of map constraint. This constraint is necessary on many maps. It sets up a box
  * around the edge of the map, in this case 4m from the edges. Player areas and many objects will
  * use this constraint to keep from being placed to close to the map edge. Other areas, such as
  * forests, will NOT use this constraint, or else there would be a pathable strip all the way
  * around the edge of the map, which makes attacking too easy.
  */
  int edgeConstraint = rmCreateBoxConstraint(
      "edge of map",
      rmXTilesToFraction(4),
      rmZTilesToFraction(4),
      1.0 - rmXTilesToFraction(4),
      1.0 - rmZTilesToFraction(4));

  /*
  * The player constraints are used to tell players and other objects to keep away from players.
  * Remember that player areas can be quite large-on some maps there is no land but player areas,
  * so you may need to use object constraints from the player’s Town Center on some maps rather
  * than just avoiding a player area completely. Note that you can have multiple constraints that
  * do similar things (in this case avoid player areas) as long as they have different string names
  * (“stay away from players” and “stay away from players a lot.”) The content of the strings don’t
  * matter, but naming them something you’ll remember makes it easier.
  */
  int playerConstraint = rmCreateClassDistanceConstraint(
      "stay away from players",
      classPlayer,
      30.0);
  int smallMapPlayerConstraint = rmCreateClassDistanceConstraint(
      "stay away from players a lot",
      classPlayer,
      70.0);

  /*
  * Center constraint. Because we want a large ocean in the center, we want to make sure player
  * areas don’t get too close to the center. We don’t have anything in classID(“center”) yet, but
  * later we will add the central ocean to this class.
  */
  int centerConstraint = rmCreateClassDistanceConstraint(
      "stay away from center",
      rmClassID("center"),
      15.0);
  int wideCenterConstraint = rmCreateClassDistanceConstraint(
      "elevation avoids center",
      rmClassID("center"),
      50.0);

  /*
  * Corner constraint. Because maps are square but players are placed in circles on many maps, it
  * is possible for a lot of objects to get shoved into corners. Corner constraints try and avoid
  * that possibility. These constraints are not actually used for this RMS, but I left them in as
  * an example of the kind of thing you can do.
  */
  int cornerConstraint = rmCreateClassDistanceConstraint(
      "stay away from corner",
      rmClassID("corner"),
      15.0);
  int cornerOverlapConstraint = rmCreateClassDistanceConstraint(
      "don't overlap corner",
      rmClassID("corner"),
      2.0);

  /*
  * Settlement constraints. These are among the most important object constraints, since maps can
  * be unfair if too many good resources are near Settlements, or Settlements are too close to each
  * other. In this map, there are three Settlement constraints, one to avoid by a short distance
  * (20m) a long distance (40m) and a really long distance (60m). Note that the 60m constraint is
  * used only to avoid “starting settlements,” meaning the TC (which always has a Settlement
  * beneath it) that each player starts with. You could defined dozens of Settlement constraints if
  * you needed them.
  */
  int shortAvoidSettlement = rmCreateTypeDistanceConstraint(
      "objects avoid TC by short distance",
      "AbstractSettlement",
      20.0);
  int farAvoidSettlement = rmCreateTypeDistanceConstraint(
      "TCs avoid TCs by long distance",
      "AbstractSettlement",
      40.0);
  int farStartingSettleConstraint = rmCreateClassDistanceConstraint(
      "objects avoid player TCs",
      rmClassID("starting settlement"),
      60.0);

  /*
  * Tower constraint. These constraints are used to make sure the starting towers avoid each other
  * by a reasonable distance. The constraints could be larger, but then there is the risk that a
  * player won’t get all 4 of their towers.
  */
  int avoidTower = rmCreateTypeDistanceConstraint(
      "towers avoid towers",
      "tower",
      20.0);
  int avoidTower2 = rmCreateTypeDistanceConstraint(
      "objects avoid towers",
      "tower",
      22.0);

  /*
  * Gold. Gold isn’t quite as important as Settlements, but you may want to avoid gold being placed
  * too close to other gold, or have super resource piles of gold and good in the same small area.
  */
  int avoidGold = rmCreateTypeDistanceConstraint(
      "avoid gold",
      "gold",
      30.0);
  int shortAvoidGold = rmCreateTypeDistanceConstraint(
      "short avoid gold",
      "gold",
      10.0);

  /*
  * Food. These constraints will mostly be used to make sure all the herd animals and predators
  * aren’t located in one portion of the map.
  */
  int avoidHerdable = rmCreateTypeDistanceConstraint(
      "avoid herdable",
      "herdable",
      30.0);
  int avoidPredator = rmCreateTypeDistanceConstraint(
      "avoid predator",
      "animalPredator",
      20.0);
  int avoidFood = rmCreateTypeDistanceConstraint(
      "avoid other food sources",
      "food",
      6.0);

  /*
  * Avoid impassable land. Constraints that avoid passable or impassable land are very useful for a
  * variety of objects. These constraints will be used to keep everything from hills to trees out
  * of the water.
  */
  int avoidImpassableLand = rmCreateTerrainDistanceConstraint(
      "avoid impassable land",
      "land",
      false,
      10.0);
  int shortHillConstraint = rmCreateClassDistanceConstraint(
      "patches vs. hill",
      rmClassID("classHill"),
      10.0);

  /*
  * -------------Define objects.
  *
  * Okay, we are all done with most of the constraints (there are a few more down below where it
  * just made more sense to keep them with their objects). Now we will define the objects. They
  * don’t actually get placed here, but just defined. Remember that an “object” in this sense could
  * be a single building, like a Settlement, or a pile of rocks that including large and small
  * rocks, grass, or even gold.
  */

  /*
  * Close Objects. Calling objects close, medium or far is just a shorthand note for me to keep
  * them straight. Close objects are those that “belong” to a certain player and are generally used
  * right away. Medium objects are still placed per player, but are far enough away that they might
  * be ignored, missed, or stolen. Far objects are placed randomly on the map, but ignore player
  * areas, and are generally up for grabs. In general, I make close objects more predictable than
  * far objects.
  */

  /*
  * This first object is the Town Center. Note that it has to be called by its protounit name,
  * which is “Settlement Level 1,” not “Town Center.” First, startingSettlementID is defined so I
  * can reference it later. Then, a Settlement Level 1 is added to the object with a distance of
  * 0.0, meaning that it must be in the center. Since there is only one thing added to this object,
  * 0.0 makes sense. The object is then added to the “starting settlement” class. It could be added
  * to any classes as necessary. Then, the min and max distance are both set to 0 to make sure the
  * Town Center is always placed in the exact middle of a players’s area. You could make a map
  * where the Town Centers are anywhere on the map, but without starting resources around the TC,
  * players may not want to play your map.
  */
  int startingSettlementID = rmCreateObjectDef("starting settlement");
  rmAddObjectDefItem(
      startingSettlementID,
      "Settlement Level 1",
      1,
      0.0);
  rmAddObjectDefToClass(startingSettlementID, rmClassID("starting settlement"));
  rmSetObjectDefMinDistance(startingSettlementID, 0.0);
  rmSetObjectDefMaxDistance(startingSettlementID, 0.0);

  /*
  * Towers avoid other towers. Next, we define the starting towers. You can see only 1 tower is
  * defined in startingTowerID, but we will end up placing 4 of them per player. If we changed 0.0
  * to 4.0 then we could place all 4 at once, but they might not avoid each other and the Town
  * Center might be vulnerable on one side. Of course, you don’t have to have starting towers at
  * all, but remember that sometimes a game can be determined in the opening seconds if a player
  * can’t see all his starting resources right away. We also tell the towers to avoid impassable
  * land, which on this map means the center ocean and cliffs. It probably isn’t necessary to
  * include this constraint since player areas avoid impassable land too, but as we get to
  * resources that are placed farther than 28 m from the player’s center, it will become more of a
  * risk.
  */
  int startingTowerID = rmCreateObjectDef("Starting tower");
  rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
  rmSetObjectDefMinDistance(startingTowerID, 22.0);
  rmSetObjectDefMaxDistance(startingTowerID, 28.0);
  rmAddObjectDefConstraint(startingTowerID, avoidTower);
  rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);

  /*
  * Gold avoids gold. By placing the gold so close to the Town Center, I ensure that an early
  * attack won’t completely deny a player of gold.
  */
  int startingGoldID = rmCreateObjectDef("Starting gold");
  rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
  rmSetObjectDefMinDistance(startingGoldID, 20.0);
  rmSetObjectDefMaxDistance(startingGoldID, 25.0);
  rmAddObjectDefConstraint(startingGoldID, avoidGold);
  rmAddObjectDefConstraint(startingGoldID, avoidImpassableLand);

  /*
  * Pigs. Notice that I place a random number of pigs, from 2-4. PigNumber should technically be an
  * integer, but since there is no such thing as 2.3 pigs, the fractions are just dropped. Note
  * also that by defining closePigsID once, we make sure that every player gets the same number of
  * pigs, though that number may be different if the map is played again. If different players on
  * the same map had different numbers of pigs, there might be a serious balance problem.
  */
  float pigNumber = rmRandFloat(2, 4);
  int closePigsID = rmCreateObjectDef("close pigs");
  rmAddObjectDefItem(closePigsID, "pig", pigNumber, 2.0);
  rmSetObjectDefMinDistance(closePigsID, 25.0);
  rmSetObjectDefMaxDistance(closePigsID, 30.0);
  rmAddObjectDefConstraint(closePigsID, avoidImpassableLand);
  rmAddObjectDefConstraint(closePigsID, avoidFood);

  /*
  * Berries and Chickens are often used interchangeably. However, they do provide different levels
  * of Food, so you need to make sure one player doesn’t have more Food than another player. In
  * this case, we determine once whether closeChickensID actually includes chickens (which happens
  * 0.8 of the time) or has berries instead. From 6-10 chickens are placed in a 5m radius, or 4-6
  * berries are placed in a 4m radius. Because pigs are type “Food”, both chickens and berries will
  * avoid them. We could have made an avoidPig constraint just as easily.
  */

  int closeChickensID = rmCreateObjectDef("close Chickens");
  if (rmRandFloat(0, 1) < 0.8)
    rmAddObjectDefItem(closeChickensID, "chicken", rmRandInt(6, 10), 5.0);
  else
    rmAddObjectDefItem(closeChickensID, "berry bush", rmRandInt(4, 6), 4.0);
  rmSetObjectDefMinDistance(closeChickensID, 20.0);
  rmSetObjectDefMaxDistance(closeChickensID, 25.0);
  rmAddObjectDefConstraint(closeChickensID, avoidImpassableLand);
  rmAddObjectDefConstraint(closeChickensID, avoidFood);

  /*
  * Most of the time we get 1-3 Boar, but sometimes we get 1-2 Aurochs instead. Like all of the
  * previous objects, we will place the closeBoarID object once per player, so if one player gets 2
  * Aurochs, every player will get 2 Aurochs. Another, less fair method, would be to do a loop over
  * the number of players and determine the animals every time.
  */
  int closeBoarID = rmCreateObjectDef("close Boar");
  if (rmRandFloat(0, 1) < 0.7)
    rmAddObjectDefItem(closeBoarID, "boar", rmRandInt(1, 3), 4.0);
  else
    rmAddObjectDefItem(closeBoarID, "aurochs", rmRandInt(1, 2), 2.0);
  rmSetObjectDefMinDistance(closeBoarID, 30.0);
  rmSetObjectDefMaxDistance(closeBoarID, 50.0);
  rmAddObjectDefConstraint(closeBoarID, avoidImpassableLand);

  int stragglerTreeID = rmCreateObjectDef("straggler tree");
  rmAddObjectDefItem(stragglerTreeID, "oak tree", 1, 0.0);
  rmSetObjectDefMinDistance(stragglerTreeID, 12.0);
  rmSetObjectDefMaxDistance(stragglerTreeID, 15.0);

  // Medium Objects

  /*
  * Gold avoids gold and Settlements. Notice that this gold mine uses a larger type of gold than
  * the starting gold mine. It not only avoids gold (which includes both the starting gold mine and
  * other medium gold mines) but it avoids Settelments, the starting Settelement (TC), the edge of
  * the map and impassable land (cliffs or water).
  */
  int mediumGoldID = rmCreateObjectDef("medium gold");
  rmAddObjectDefItem(mediumGoldID, "Gold mine", 1, 0.0);
  rmSetObjectDefMinDistance(mediumGoldID, 40.0);
  rmSetObjectDefMaxDistance(mediumGoldID, 60.0);
  rmAddObjectDefConstraint(mediumGoldID, avoidGold);
  rmAddObjectDefConstraint(mediumGoldID, edgeConstraint);
  rmAddObjectDefConstraint(mediumGoldID, shortAvoidSettlement);
  rmAddObjectDefConstraint(mediumGoldID, avoidImpassableLand);
  rmAddObjectDefConstraint(mediumGoldID, farStartingSettleConstraint);

  int mediumPigsID = rmCreateObjectDef("medium pigs");
  rmAddObjectDefItem(mediumPigsID, "pig", 2, 4.0);
  rmSetObjectDefMinDistance(mediumPigsID, 50.0);
  rmSetObjectDefMaxDistance(mediumPigsID, 70.0);
  rmAddObjectDefConstraint(mediumPigsID, avoidImpassableLand);
  rmAddObjectDefConstraint(mediumPigsID, avoidHerdable);
  rmAddObjectDefConstraint(mediumPigsID, farStartingSettleConstraint);

  /*
  * Player fish. We want to make sure every player has some fish close by, so we will place
  * playerFishID for each player. However, we need two new constraints first: one that keeps fish
  * groups away from each other, and one that keeps fish from being placed on top of land. Because
  * fish are harder to place (since they are avoiding land) we allow them to be up to 100m from a
  * player’s center. Remember, this distance includes both the land and water. If a player’s Town
  * Center is 70m from shore, then there is only 30m left to place the fish group in. PlayerFishID
  * is actually a group of 3 mahi mahi, which just makes the water look more interesting.
  */
  int fishVsFishID = rmCreateTypeDistanceConstraint("fish v fish", "fish", 18.0);
  int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);

  int playerFishID = rmCreateObjectDef("owned fish");
  rmAddObjectDefItem(playerFishID, "fish - mahi", 3, 10.0);
  rmSetObjectDefMinDistance(playerFishID, 0.0);
  rmSetObjectDefMaxDistance(playerFishID, 100.0);
  rmAddObjectDefConstraint(playerFishID, fishVsFishID);
  rmAddObjectDefConstraint(playerFishID, fishLand);

  // Far Objects

  /*
  * Gold avoids gold, Settlements and TCs. Far objects are handled differently on this map (and
  * most ES maps) from close and medium objects, but they don’t have to be. The difference comes in
  * how these objects are placed, below. Close and medium objects are placed per player. Some far
  * objects, like gold, are placed per player, but others are just placed randomly across the map,
  * with a few constraints.  It is important to remember that the randomly placed objects will not
  * avoid a player’s starting area by the minDistance. The difference between the minimum and
  * maximum has grown, to account for all the variation in land and water; if the min and max were
  * both 70, farGoldID might fail several times.
  */
  int farGoldID = rmCreateObjectDef("far gold");
  rmAddObjectDefItem(farGoldID, "Gold mine", 1, 0.0);
  rmSetObjectDefMinDistance(farGoldID, 70.0);
  rmSetObjectDefMaxDistance(farGoldID, 160.0);
  rmAddObjectDefConstraint(farGoldID, avoidGold);
  rmAddObjectDefConstraint(farGoldID, avoidImpassableLand);
  rmAddObjectDefConstraint(farGoldID, shortAvoidSettlement);
  rmAddObjectDefConstraint(farGoldID, farStartingSettleConstraint);

  /*
  * Pigs avoid TCs and other herds, since this map places a lot of pigs. Mediterranean is a
  * pig-heavy map, so it needs extra constraints that other maps might not need. It aways places
  * pigs in pairs. You could make a random number of 0-2 pigs; 0 of any object is just ignored.
  */
  int farPigsID = rmCreateObjectDef("far pigs");
  rmAddObjectDefItem(farPigsID, "pig", 2, 4.0);
  rmSetObjectDefMinDistance(farPigsID, 80.0);
  rmSetObjectDefMaxDistance(farPigsID, 150.0);
  rmAddObjectDefConstraint(farPigsID, avoidImpassableLand);
  rmAddObjectDefConstraint(farPigsID, avoidHerdable);
  rmAddObjectDefConstraint(farPigsID, farStartingSettleConstraint);

  /*
  * Pick lions or bears as predators. Placing predators is tricky, because a player with too many
  * predators nearby has an unfair advantage. To make sure this doesn’t happen, we tell predators
  * to avoid starting areas.
  */
  // Avoid TCs
  int farPredatorID = rmCreateObjectDef("far predator");
  float predatorSpecies = rmRandFloat(0, 1);
  if (predatorSpecies < 0.5)
    rmAddObjectDefItem(farPredatorID, "lion", 2, 4.0);
  else
    rmAddObjectDefItem(farPredatorID, "bear", 1, 4.0);
  rmSetObjectDefMinDistance(farPredatorID, 50.0);
  rmSetObjectDefMaxDistance(farPredatorID, 100.0);
  rmAddObjectDefConstraint(farPredatorID, avoidPredator);
  rmAddObjectDefConstraint(farPredatorID, farStartingSettleConstraint);
  rmAddObjectDefConstraint(farPredatorID, avoidImpassableLand);

  // Berries avoid TCs
  int farBerriesID = rmCreateObjectDef("far berries");
  rmAddObjectDefItem(farBerriesID, "berry bush", 10, 4.0);
  rmSetObjectDefMinDistance(farBerriesID, 0.0);
  rmSetObjectDefMaxDistance(farBerriesID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);
  rmAddObjectDefConstraint(farBerriesID, farStartingSettleConstraint);

  /*
  * This map will either use boar or deer as the extra huntable food. We set up two new class
  * constraints to make sure the bonus animals are distributed evenly. Hunted animals are placed
  * randomly, not per player as farGoldID was placed. The difference is that the minDistance of 0
  * below does not mean 0m from a player’s starting area, but 0m from the random location where
  * bonusHundableID was placed. This will make more sense in the placement section below areas.
  */
  int classBonusHuntable = rmDefineClass("bonus huntable");
  int avoidBonusHuntable = rmCreateClassDistanceConstraint(
    "avoid bonus huntable",
    classBonusHuntable,
    40.0);
  int avoidHuntable = rmCreateTypeDistanceConstraint("avoid huntable", "huntable", 20.0);

  // hunted avoids hunted and TCs
  int bonusHuntableID = rmCreateObjectDef("bonus huntable");
  float bonusChance = rmRandFloat(0, 1);
  if (bonusChance < 0.5)
    rmAddObjectDefItem(bonusHuntableID, "boar", rmRandInt(2, 3), 4.0);
  else if (bonusChance < 0.8)
    rmAddObjectDefItem(bonusHuntableID, "deer", rmRandInt(6, 8), 8.0);
  else
    rmAddObjectDefItem(bonusHuntableID, "aurochs", rmRandInt(1, 3), 4.0);
  rmSetObjectDefMinDistance(bonusHuntableID, 0.0);
  rmSetObjectDefMaxDistance(bonusHuntableID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(bonusHuntableID, avoidBonusHuntable);
  rmAddObjectDefConstraint(bonusHuntableID, avoidHuntable);
  rmAddObjectDefToClass(bonusHuntableID, classBonusHuntable);
  rmAddObjectDefConstraint(bonusHuntableID, farStartingSettleConstraint);
  rmAddObjectDefConstraint(bonusHuntableID, avoidImpassableLand);

  int randomTreeID = rmCreateObjectDef("random tree");
  rmAddObjectDefItem(randomTreeID, "oak tree", 1, 0.0);
  rmSetObjectDefMinDistance(randomTreeID, 0.0);
  rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(
    randomTreeID,
    rmCreateTypeDistanceConstraint("random tree", "all", 4.0));
  rmAddObjectDefConstraint(randomTreeID, shortAvoidSettlement);
  rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);

  /*
  * Birds. These don’t have any effect on gameplay, and they move around, so there is no point
  * assigning constraints to them. In fact, we specify that the min distance is 0 and the max
  * distance is half the map, meaning they can be placed anywhere.
  */
  int farhawkID = rmCreateObjectDef("far hawks");
  rmAddObjectDefItem(farhawkID, "hawk", 1, 0.0);
  rmSetObjectDefMinDistance(farhawkID, 0.0);
  rmSetObjectDefMaxDistance(farhawkID, rmXFractionToMeters(0.5));

  // Relics avoid TCs
  int relicID = rmCreateObjectDef("relic");
  rmAddObjectDefItem(relicID, "relic", 1, 0.0);
  rmSetObjectDefMinDistance(relicID, 60.0);
  rmSetObjectDefMaxDistance(relicID, 150.0);
  rmAddObjectDefConstraint(relicID, edgeConstraint);
  rmAddObjectDefConstraint(
    relicID,
    rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
  rmAddObjectDefConstraint(relicID, farStartingSettleConstraint);
  rmAddObjectDefConstraint(relicID, avoidImpassableLand);

  /*
  * -------------Done defining objects. That’s it for objects. Next we will not only define, but
  * place some areas, and then we will add all of the above defined objects to the areas. Then the
  * map will be done.
  */

  // Text
  rmSetStatusText("", 0.20);

  /*
  * Cheesy "circular" placement of players. Through trial and error, we found that when there were
  * fewer than 4 players, the players were too close to the center, which meant the ocean was very
  * small. So, we place players at 0.4 to 0.43 on smaller, 2-3 player maps, and from closer to the
  * center (by a small amount) for larger, 4-12 player maps. Teams are placed slightly closer
  * together than enemies.
  */
  rmSetTeamSpacingModifier(0.75);
  if (cNumberNonGaiaPlayers < 4)
    rmPlacePlayersCircular(0.4, 0.43, rmDegreesToRadians(5.0));
  else
    rmPlacePlayersCircular(0.43, 0.45, rmDegreesToRadians(5.0));

  /*
  * Create a center water area -- the Mediterranean part. This is the first area. It is the central
  * ocean that gives the map its name. We name the area (centerID), pick a size for it (more than a
  * third of the map), place it in the center of the map, specify a water type for it, add it to
  * the center class (since it is the only area in this class, we could have just had areas avoid
  * centerID), give the area a height of 0 so that it is underwater, provide some variation by
  * setting more than 1 blob and letting the blobs move a part a little, smooth the outer perimeter
  * so it looks more like an ocean, add coherence to keep the ocean from looking too much like an
  * amoeba, and then build the area. Building the ocean now is important, because much of the
  * Mediterranean look comes the fact that player areas spill over into the ocean.
  */
  int centerID = rmCreateArea("center");
  rmSetAreaSize(centerID, 0.35, 0.35);
  rmSetAreaLocation(centerID, 0.5, 0.5);
  rmSetAreaWaterType(centerID, "mediterranean sea");
  rmAddAreaToClass(centerID, rmClassID("center"));
  rmSetAreaBaseHeight(centerID, 0.0);
  rmSetAreaMinBlobs(centerID, 8);
  rmSetAreaMaxBlobs(centerID, 10);
  rmSetAreaMinBlobDistance(centerID, 10);
  rmSetAreaMaxBlobDistance(centerID, 20);
  rmSetAreaSmoothDistance(centerID, 50);
  rmSetAreaCoherence(centerID, 0.25);
  rmBuildArea(centerID);

  /*
  * Monkey island. Just to be silly, and to make the map more random, there is a chance of placing
  * a monkey island in the middle. I found that the island connects to other land too often on
  * smaller maps, so there is only a chance to place the island on maps with more than 3 players,
  * and even then there is only a 66% chance.
  */
  float monkeyChance = rmRandFloat(0, 1);
  if (cNumberPlayers > 3)
  {
    if (monkeyChance < 0.66)
    {
      int monkeyIslandID = rmCreateArea("monkeyisland");
      rmSetAreaSize(monkeyIslandID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(300));
      rmSetAreaLocation(monkeyIslandID, 0.5, 0.5);
      rmSetAreaTerrainType(monkeyIslandID, "shorelinemediterraneanb");
      rmSetAreaBaseHeight(monkeyIslandID, 2.0);
      rmSetAreaSmoothDistance(monkeyIslandID, 10);
      rmSetAreaHeightBlend(monkeyIslandID, 2);
      rmSetAreaCoherence(monkeyIslandID, 1.0);
      rmBuildArea(monkeyIslandID);

      /*
      * Here is our first object. Normally, the monkeyID would be defined above with the other
      * objects and placed below with the other objects, but I left it here to indicate that
      * certain things don’t have to go in a certain order. I knew the monkey would not interact
      * much with other objects, since it is placed in the center and many objects avoid the center
      * or avoid water. All the defining is done as above, but notice that 3 different units are
      * added to monkeyID. The final command actually places the monkey at location 0.5, 0.5 which
      * is also where monkey island gets placed. If you stopped the map generating here, you would
      * get a big field of grassDirt25, an ocean, an island in the ocean, and a monkey, palm tree
      * and gold on the island. That’s it.
      */
      int monkeyID = rmCreateObjectDef("monkey");
      rmAddObjectDefItem(monkeyID, "baboon", 1, 2.0);
      rmAddObjectDefItem(monkeyID, "palm", 1, 2.0);
      rmAddObjectDefItem(monkeyID, "gold mine", 1, 8.0);
      rmSetObjectDefMinDistance(monkeyID, 0.0);
      rmSetObjectDefMinDistance(monkeyID, 20.0);
      rmPlaceObjectDefAtLoc(monkeyID, 0, 0.5, 0.5);
    }
  }

  /*
  * Set up player areas. With the center ocean (and ludicrous monkey island out of the way) we set
  * out placing the player areas. Note that the area is set up much like the ocean, except that
  * instead of placing a set fraction, I place a number of tiles per player. I used to place more
  * tiles on smaller maps, but decided that wasn’t necessary and commented it out-instead I add a
  * new constraint on small maps only. Also notice that here is our first loop. We generate an area
  * once for each player in the game, and then call these areas “Player” plus the player number.
  * You have to change the string ID of the area or you will get an error message.
  */
  float playerFraction = rmAreaTilesToFraction(3200);
  /*   if(cNumberNonGaiaPlayers < 4)
  playerFraction=rmAreaTilesToFraction(3000); */

  for (i = 1; < cNumberPlayers)
  {
    // Create the area.
    int id = rmCreateArea("Player" + i);

    /*
    * Assign to the player. Without this, you won’t be able to associate this area with the player
    * location determined above in the player placement section.
    */
    rmSetPlayerArea(i, id);

    // Set the size.
    rmSetAreaSize(id, 0.9 * playerFraction, 1.1 * playerFraction);

    rmAddAreaToClass(id, classPlayer);

    rmSetAreaMinBlobs(id, 4);
    rmSetAreaMaxBlobs(id, 5);
    rmSetAreaWarnFailure(id, false);
    rmSetAreaMinBlobDistance(id, 30.0);
    rmSetAreaMaxBlobDistance(id, 50.0);
    rmSetAreaSmoothDistance(id, 20);
    rmSetAreaCoherence(id, 0.20);
    rmSetAreaBaseHeight(id, 0.0);
    rmSetAreaHeightBlend(id, 2);
    rmAddAreaConstraint(id, playerConstraint);
    if (cNumberNonGaiaPlayers < 4)
      rmAddAreaConstraint(id, smallMapPlayerConstraint);
    rmSetAreaLocPlayer(id, i);
    rmSetAreaTerrainType(id, "grassDirt25");
  }

  /*
  * Build the areas. We already built the ocean and monkey island, so this command will just build
  * all the player areas at once. If buildAreas was inside of the loop, then player 1’s land would
  * get build before other players, and some players might run out of space.
  */
  rmBuildAllAreas();

  /*
  * Because the player areas used the same terrain as the base map (grassDirt25) the map is going
  * to look pretty boring. To remedy this, we add sub-areas. These areas have no effect on
  * gameplay, though they could if we placed certain objects in these areas. This loop just sets up
  * a small patch of GrassDirt50 within each player’s area. Notice that a parentID is specified
  * here-the lands of each player.
  */
  for (i = 1; < cNumberPlayers)
  {
    // Beautification sub area.
    int id2 = rmCreateArea("Player inner" + i, rmAreaID("player" + i));
    rmSetAreaSize(id2, rmAreaTilesToFraction(400), rmAreaTilesToFraction(600));
    rmSetAreaLocPlayer(id2, i);
    rmSetAreaTerrainType(id2, "GrassDirt50");

    rmSetAreaMinBlobs(id2, 1);
    rmSetAreaMaxBlobs(id2, 5);
    rmSetAreaWarnFailure(id2, false);
    rmSetAreaMinBlobDistance(id2, 16.0);
    rmSetAreaMaxBlobDistance(id2, 40.0);
    rmSetAreaCoherence(id2, 0.0);

    rmBuildArea(id2);
  }

  for (i = 1; < cNumberPlayers * 8)
  {
    // Beautification sub area.
    int id3 = rmCreateArea("Grass patch" + i);
    rmSetAreaSize(id3, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
    rmSetAreaTerrainType(id3, "GrassA");
    rmAddAreaConstraint(id3, centerConstraint);
    rmSetAreaMinBlobs(id3, 1);
    rmSetAreaMaxBlobs(id3, 5);
    rmSetAreaWarnFailure(id3, false);
    rmSetAreaMinBlobDistance(id3, 16.0);
    rmSetAreaMaxBlobDistance(id3, 40.0);
    rmSetAreaCoherence(id3, 0.0);

    rmBuildArea(id3);
  }

  /*
  * I defined another object here that I wanted to always place in id4, an object called flowerID
  * that contains flowers and grass. I use a special constraint called an edgeDistanceConstraint to
  * keep the flowerID within the area of id4. I also place the flowerID in id4. The 0 parameter
  * indicates that the object belongs to Gaia-we don’t want the player to own any flowers.
  */
  int flowerID = 0;
  int id4 = 0;
  int stayInPatch = rmCreateEdgeDistanceConstraint("stay in patch", id4, 4.0);
  for (i = 1; < cNumberPlayers * 6)
  {
    // Beautification sub area.
    id4 = rmCreateArea("Grass patch 2" + i);
    rmSetAreaSize(id4, rmAreaTilesToFraction(5), rmAreaTilesToFraction(20));
    rmSetAreaTerrainType(id4, "GrassB");
    rmAddAreaConstraint(id4, centerConstraint);
    rmSetAreaMinBlobs(id4, 1);
    rmSetAreaMaxBlobs(id4, 5);
    rmSetAreaWarnFailure(id4, false);
    rmSetAreaMinBlobDistance(id4, 16.0);
    rmSetAreaMaxBlobDistance(id4, 40.0);
    rmSetAreaCoherence(id4, 0.0);

    rmBuildArea(id4);

    flowerID = rmCreateObjectDef("grass" + i);
    rmAddObjectDefItem(flowerID, "grass", rmRandFloat(2, 4), 5.0);
    rmAddObjectDefItem(flowerID, "flowers", rmRandInt(0, 6), 5.0);
    rmAddObjectDefConstraint(flowerID, stayInPatch);
    rmSetObjectDefMinDistance(flowerID, 0.0);
    rmSetObjectDefMaxDistance(flowerID, 0.0);
    rmPlaceObjectDefInArea(flowerID, 0, rmAreaID("grass patch 2" + i), 1);
  }

  /*
  * We’re done placing areas now, so we can start placing objects. We already defined the player’s
  * own fish, so now we can just place it. The false parameter indicates that these fish are not
  * owned by the player.
  */
  rmPlaceObjectDefPerPlayer(playerFishID, false);

  /*
  * Since we’re placing fish, let’s go ahead and place some extra ones. These two sections place
  * some mahi and some perch. There are 3 groups of 3 mahi per player and 1 group of 2 perch per
  * player. These objects avoid land and other fish, but can otherwise be placed anywhere on the
  * map-the location is set to the center of the map (0.5, 0.5) but the max distance is set at half
  * the map (rmXFractionToMeters(0.5)).
  */
  int fishID = rmCreateObjectDef("fish");
  rmAddObjectDefItem(fishID, "fish - mahi", 3, 9.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmAddObjectDefConstraint(fishID, fishLand);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3 * cNumberNonGaiaPlayers);

  fishID = rmCreateObjectDef("fish2");
  rmAddObjectDefItem(fishID, "fish - perch", 2, 6.0);
  rmSetObjectDefMinDistance(fishID, 0.0);
  rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(fishID, fishVsFishID);
  rmAddObjectDefConstraint(fishID, fishLand);
  rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 1 * cNumberNonGaiaPlayers);

  // Text
  rmSetStatusText("", 0.40);

  /*
  * Sharks and whales have no effect on gameplay, but they look cool. This section randomly chooses
  * either sharks or whales and places 1 for every 2 players.
  */
  int sharkLand = rmCreateTerrainDistanceConstraint("shark land", "land", true, 20.0);
  int sharkVssharkID = rmCreateTypeDistanceConstraint("shark v shark", "shark", 20.0);
  int sharkVssharkID2 = rmCreateTypeDistanceConstraint("shark v orca", "orca", 20.0);
  int sharkVssharkID3 = rmCreateTypeDistanceConstraint("shark v whale", "whale", 20.0);

  // Text
  rmSetStatusText("", 0.42);

  int sharkID = rmCreateObjectDef("shark");
  if (rmRandFloat(0, 1) < 0.5)
    rmAddObjectDefItem(sharkID, "shark", 1, 0.0);
  else
    rmAddObjectDefItem(sharkID, "whale", 1, 0.0);
  rmSetObjectDefMinDistance(sharkID, 0.0);
  rmSetObjectDefMaxDistance(sharkID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(sharkID, sharkVssharkID);
  rmAddObjectDefConstraint(sharkID, sharkVssharkID2);
  rmAddObjectDefConstraint(sharkID, sharkVssharkID3);
  rmAddObjectDefConstraint(sharkID, sharkLand);
  rmPlaceObjectDefAtLoc(sharkID, 0, 0.5, 0.5, cNumberNonGaiaPlayers * 0.5);

  // Place starting settlements.
  // Close things....

  /*
  * TC. The order you place objects in is important. If you place lots of trees, and then tell
  * objects they need to avoid trees, there might not be enough room for anything else. All we have
  * placed so far, however, are fish and the monkey island stuff. So we want to start with the most
  * important objects, the player’s Town Center and Towers. Unlike the fish above, we want these
  * things to be owned by the player, so we set the second parameter to true. Remember we place 4
  * Towers per player since the startingTowerID just has 1 Tower in it.
  */
  rmPlaceObjectDefPerPlayer(startingSettlementID, true);

  // Towers.
  rmPlaceObjectDefPerPlayer(startingTowerID, true, 4);

  /*
  * Even though we just got started placing objects, I take another detour here. If you place
  * objects and then change the elevation, the object might get buried underground! I could tell
  * the elevation to avoid objects, but then I might not get much elevation. Instead, I place
  * elevation now and then just place objects on top of them. This could get crazy if the elevation
  * were extreme, or were unpathable like cliffs. Elevation is placed just like any other area,
  * except that we change the baseHeight, and then add a HeightBlend to make the height variation
  * not so jagged. Also notice that each hill has a 50% chance to change its terrain, otherwise it
  * just uses whatever else is beneath it. Another new concept here is the failCount. Areas don’t
  * always have room to place, and can make a map generate slowly. The loop here counts the number
  * of failures, and when it reaches 20, it just bails, even though it could potentially place 6
  * areas per player number.
  */
  /*
  * Because player areas are so large on this map, elev needs to avoid buildings instead of player
  * areas.
  */
  // Elev.
  int numTries = 6 * cNumberNonGaiaPlayers;
  int avoidBuildings = rmCreateTypeDistanceConstraint("avoid buildings", "Building", 20.0);
  int failCount = 0;
  for (i = 0; < numTries)
  {
    int elevID = rmCreateArea("elev" + i);
    rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
    rmSetAreaWarnFailure(elevID, false);
    rmAddAreaToClass(elevID, rmClassID("classHill"));
    rmAddAreaConstraint(elevID, avoidBuildings);
    rmAddAreaConstraint(elevID, centerConstraint);
    if (rmRandFloat(0.0, 1.0) < 0.5)
      rmSetAreaTerrainType(elevID, "GrassDirt50");
    /*      rmSetAreaTerrainType(elevID, "SnowA"); */
    rmSetAreaBaseHeight(elevID, rmRandFloat(4.0, 7.0));
    rmSetAreaHeightBlend(elevID, 3);
    rmSetAreaMinBlobs(elevID, 1);
    rmSetAreaMaxBlobs(elevID, 5);
    rmSetAreaMinBlobDistance(elevID, 16.0);
    rmSetAreaMaxBlobDistance(elevID, 40.0);
    rmSetAreaCoherence(elevID, 0.0);

    if (rmBuildArea(elevID) == false)
    {
      // Stop trying once we fail 20 times in a row.
      failCount++;
      if (failCount == 20)
        break;
    }
    else
      failCount = 0;
  }

  /*
  * We placed some big hills, but little wrinkles in the terrain add interest, so here I place some
  * more that are more numerous, but smaller and at smaller heights.
  */
  // Slight Elevation
  numTries = 15 * cNumberNonGaiaPlayers;
  failCount = 0;
  for (i = 0; < numTries)
  {
    elevID = rmCreateArea("wrinkle" + i);
    rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(120));
    rmSetAreaWarnFailure(elevID, false);
    rmSetAreaBaseHeight(elevID, rmRandFloat(2.0, 4.0));
    rmSetAreaHeightBlend(elevID, 1);
    rmSetAreaMinBlobs(elevID, 1);
    rmSetAreaMaxBlobs(elevID, 3);
    rmSetAreaMinBlobDistance(elevID, 16.0);
    rmSetAreaMaxBlobDistance(elevID, 20.0);
    rmSetAreaCoherence(elevID, 0.0);
    rmAddAreaConstraint(elevID, avoidBuildings);
    rmAddAreaConstraint(elevID, centerConstraint);
    rmAddAreaConstraint(elevID, shortHillConstraint);

    if (rmBuildArea(elevID) == false)
    {
      // Stop trying once we fail 10 times in a row.
      failCount++;
      if (failCount == 10)
        break;
    }
    else
      failCount = 0;
  }

  // Text
  rmSetStatusText("", 0.60);

  /*
  * Okay, back to the objects. After the Town Center, the most important objects are the
  * Settlements. Settlements are so important, that we use a special object placement function
  * called Fair Locations. Fair Locs are great at forcing objects to be fair, but they are slow, so
  * it is a good idea to only use them for really important things, like Settlements. Here we
  * specify 2 Settlements per player-one that is forward, between a player and his enemies, and
  * another one that is safe behind the player. Other maps do different things, and may have a
  * chance of having both Settlements in safe places.
  */
  // Settlements.
  //rmPlaceObjectDefPerPlayer(farSettlementID, true, 2);
  id = rmAddFairLoc("Settlement", false, true, 60, 80, 40, 10);
  rmAddFairLocConstraint(id, centerConstraint);

  id = rmAddFairLoc("Settlement", true, false, 70, 120, 60, 10);
  rmAddFairLocConstraint(id, centerConstraint);

  if (rmPlaceFairLocs())
  {
    id = rmCreateObjectDef("far settlement2");
    rmAddObjectDefItem(id, "Settlement", 1, 0.0);
    for (i = 1; < cNumberPlayers)
    {
      for (j = 0; < rmGetNumberFairLocs(i))
        rmPlaceObjectDefAtLoc(id, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
    }
  }

  /*
  * Now we can quickly run through all those objects that were generated. The two things that vary
  * in the below commands, aside from the way the objects were defined above, is how many to place
  * (default is 1) and whether the object is owned by the player or not. Trees and gold are not
  * owned, while goats are.
  */

  // Straggler trees.
  rmPlaceObjectDefPerPlayer(stragglerTreeID, false, rmRandInt(2, 6));

  // Gold
  rmPlaceObjectDefPerPlayer(startingGoldID, false);

  // Goats
  rmPlaceObjectDefPerPlayer(closePigsID, true);

  // Chickens or berries.
  rmPlaceObjectDefPerPlayer(closeChickensID, true);

  // Boar.
  rmPlaceObjectDefPerPlayer(closeBoarID, false);

  // Medium things....
  // Gold
  rmPlaceObjectDefPerPlayer(mediumGoldID, false);

  // Pigs

  for (i = 1; < cNumberPlayers)
    rmPlaceObjectDefAtLoc(mediumPigsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 2);

  // Far things.

  // Gold.
  rmPlaceObjectDefPerPlayer(farGoldID, false, 3);

  // Relics
  rmPlaceObjectDefPerPlayer(relicID, false);

  // Hawks
  rmPlaceObjectDefPerPlayer(farhawkID, false, 2);

  /*
  * While many objects are placed per player with PlaceObjectDefPerPlayer, others are placed
  * randomly across the map. Bonus huntables, berries and predators are all placed at the center of
  * the map (0.5,0.5) with a max distance of half the map.
  */
  // Pigs
  for (i = 1; < cNumberPlayers)
    rmPlaceObjectDefAtLoc(farPigsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), 3);

  // Bonus huntable.
  rmPlaceObjectDefAtLoc(bonusHuntableID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

  // Berries.
  rmPlaceObjectDefAtLoc(farBerriesID, 0, 0.5, 0.5, cNumberPlayers);

  // Predators
  rmPlaceObjectDefPerPlayer(farPredatorID, false, 1);

  // Random trees.
  rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 10 * cNumberNonGaiaPlayers);

  /*
  * Forests are placed after objects because they can eat up a bunch of space, and we want to make
  * sure the objects get placed first. Forests are essentially areas, but because they have hard
  * obstructions, care need to be taken that they avoid other forests, and indeed other objects.
  */
  // Forest.
  int classForest = rmDefineClass("forest");
  int forestObjConstraint = rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
  int forestConstraint = rmCreateClassDistanceConstraint(
    "forest v forest",
    rmClassID("forest"),
    20.0);
  int forestSettleConstraint = rmCreateClassDistanceConstraint(
    "forest settle",
    rmClassID("starting settlement"),
    20.0);
  int forestCount = 10 * cNumberNonGaiaPlayers;
  failCount = 0;
  for (i = 0; < forestCount)
  {
    int forestID = rmCreateArea("forest" + i);
    rmSetAreaSize(forestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
    rmSetAreaWarnFailure(forestID, false);
    if (rmRandFloat(0.0, 1.0) < 0.5)
      rmSetAreaForestType(forestID, "oak forest");
    else
      rmSetAreaForestType(forestID, "pine forest");
    rmAddAreaConstraint(forestID, forestSettleConstraint);
    rmAddAreaConstraint(forestID, forestObjConstraint);
    rmAddAreaConstraint(forestID, forestConstraint);
    rmAddAreaConstraint(forestID, avoidImpassableLand);
    rmAddAreaToClass(forestID, classForest);

    rmSetAreaMinBlobs(forestID, 1);
    rmSetAreaMaxBlobs(forestID, 5);
    rmSetAreaMinBlobDistance(forestID, 16.0);
    rmSetAreaMaxBlobDistance(forestID, 40.0);
    rmSetAreaCoherence(forestID, 0.0);

    if (rmBuildArea(forestID) == false)
    {
      // Stop trying once we fail 3 times in a row.
      failCount++;
      if (failCount == 3)
        break;
    }
    else
      failCount = 0;
  }

  // Text
  rmSetStatusText("", 0.80);

  /*
  * The remaining objects are mostly for decoration. They are placed last because it isn’t
  * important if they get placed at all, or where they get placed, but because there are so many of
  * them, and because forests avoid all, it is important to place them after the forest. Even
  * though they are just eye-candy, these objects can slow down map generation, if, for example,
  * you tried to place 2000 grass objects per player instead of 20. Notice that the seaweed uses a
  * constraint like the fish to avoid land, but doesn’t get to far from land.
  */
  // Decoration
  int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
  int deerID = rmCreateObjectDef("lonely deer");
  if (rmRandFloat(0, 1) < 0.5)
    rmAddObjectDefItem(deerID, "deer", rmRandInt(1, 2), 1.0);
  else
    rmAddObjectDefItem(deerID, "aurochs", 1, 0.0);
  rmSetObjectDefMinDistance(deerID, 0.0);
  rmSetObjectDefMaxDistance(deerID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(deerID, avoidAll);
  rmAddObjectDefConstraint(deerID, avoidBuildings);
  rmAddObjectDefConstraint(deerID, avoidImpassableLand);
  rmPlaceObjectDefAtLoc(deerID, 0, 0.5, 0.5, cNumberNonGaiaPlayers);

  int avoidGrass = rmCreateTypeDistanceConstraint("avoid grass", "grass", 12.0);
  int grassID = rmCreateObjectDef("grass");
  rmAddObjectDefItem(grassID, "grass", 3, 4.0);
  rmSetObjectDefMinDistance(grassID, 0.0);
  rmSetObjectDefMaxDistance(grassID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(grassID, avoidGrass);
  rmAddObjectDefConstraint(grassID, avoidAll);
  rmAddObjectDefConstraint(grassID, avoidImpassableLand);
  rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 20 * cNumberNonGaiaPlayers);

  int rockID = rmCreateObjectDef("rock and grass");
  int avoidRock = rmCreateTypeDistanceConstraint("avoid rock", "rock limestone sprite", 8.0);
  rmAddObjectDefItem(rockID, "rock limestone sprite", 1, 1.0);
  rmAddObjectDefItem(rockID, "grass", 2, 1.0);
  rmSetObjectDefMinDistance(rockID, 0.0);
  rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(rockID, avoidAll);
  rmAddObjectDefConstraint(rockID, avoidImpassableLand);
  rmAddObjectDefConstraint(rockID, avoidRock);
  rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15 * cNumberNonGaiaPlayers);

  int rockID2 = rmCreateObjectDef("rock group");
  rmAddObjectDefItem(rockID2, "rock limestone sprite", 3, 2.0);
  rmSetObjectDefMinDistance(rockID2, 0.0);
  rmSetObjectDefMaxDistance(rockID2, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(rockID2, avoidAll);
  rmAddObjectDefConstraint(rockID2, avoidImpassableLand);
  rmAddObjectDefConstraint(rockID2, avoidRock);
  rmPlaceObjectDefAtLoc(rockID2, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

  int nearshore = rmCreateTerrainMaxDistanceConstraint("seaweed near shore", "land", true, 14.0);
  int farshore = rmCreateTerrainDistanceConstraint("seaweed far from shore", "land", true, 10.0);
  int kelpID = rmCreateObjectDef("seaweed");
  rmAddObjectDefItem(kelpID, "seaweed", 12, 6.0);
  rmSetObjectDefMinDistance(kelpID, 0.0);
  rmSetObjectDefMaxDistance(kelpID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(kelpID, avoidAll);
  rmAddObjectDefConstraint(kelpID, nearshore);
  rmAddObjectDefConstraint(kelpID, farshore);
  rmPlaceObjectDefAtLoc(kelpID, 0, 0.5, 0.5, 2 * cNumberNonGaiaPlayers);

  int kelp2ID = rmCreateObjectDef("seaweed 2");
  rmAddObjectDefItem(kelp2ID, "seaweed", 5, 3.0);
  rmSetObjectDefMinDistance(kelp2ID, 0.0);
  rmSetObjectDefMaxDistance(kelp2ID, rmXFractionToMeters(0.5));
  rmAddObjectDefConstraint(kelp2ID, avoidAll);
  rmAddObjectDefConstraint(kelp2ID, nearshore);
  rmAddObjectDefConstraint(kelp2ID, farshore);
  rmPlaceObjectDefAtLoc(kelp2ID, 0, 0.5, 0.5, 6 * cNumberNonGaiaPlayers);

  // Text
  rmSetStatusText("", 1.0);

  /*
  * That’s all there is to it. Places areas and place objects and you have a map. Just remember to
  * try generating many maps of different sizes to make sure they are pretty fair (or work at all)
  * before springing them on an unsuspecting public. It is a good idea to have a friend test them
  * for you. Also make sure to include a name and description in the XML file that has the same
  * name as your map so players know what they are getting into.
  */
}
