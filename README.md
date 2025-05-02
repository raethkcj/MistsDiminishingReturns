## Goal

Verify that the behavior of Avoidance Diminishing Returns in Mists of Pandaria Classic matches the observations from the original release of Mists of Pandaria observed in this series of blog posts: https://sacreddutydotnet.wordpress.com/2012/09/14/avoidance-diminishing-returns-in-mop-followup-2

## Methods

### Exact Data
Because avoidance from base stats is excluded from diminishing returns, we can directly measure Base Dodge & Base Parry for each class, and Dodge per Agi and Parry per Str for a given class & level:
1. Remove any sources of bonus strength or agility (gear, buffs, etc.)
2. `/dump UnitStat("player", LE_UNIT_STAT_AGILITY), GetDodgeChance()`
3. Die and take Resurrection Sickness to reduce your stats
4. Run the macro again
5. Plot the line between the two points; the slope is the conversion rate (Q), and the y-intercept is the base avoidance.

### Experimental Data
Since the initial belief was that each equation consisted of 3 unknowns (k, C, and Q), we gathered data from as varied points on the surface as possible, maximizing along each axis of base stat (strength or agility) and avoidance stat (parry or dodge). We varied stats using reforges, gems, enchants, limited in some cases when classes have a single primary stat (e.g. it's difficult to reforge a large amount of Dodge Rating on a hunter without equipping any Agility). Each class measured a minimum of 1 baseline (naked) point and 3 points for agility, while classes that can parry measured at least 3 additional points for parry, with the following strategy:
1. Baseline (Zero in all input stats)
2. Zero Agility, maximize Dodge Rating
3. Maximize Agility. zero Dodge Rating
4. Maximize diminishable Dodge (full dodge/agi gems+enchants, Windwalk, agi flask/potion)
6. Zero Strength, maximize Parry Rating
7. Maximize Strength. zero Parry Rating
8. Maximize diminishable Parry (full parry/str gems+enchants, str flask/potion)
#### Macros to print relevant data:
Dodge and Parry:
```
/run print(GetDodgeChance()..","..GetCombatRatingBonus(CR_DODGE)..","..(select(3, UnitStat("player", LE_UNIT_STAT_AGILITY)))..","..GetParryChance()..","..GetCombatRatingBonus(CR_PARRY)..","..(select(3, UnitStat("player", LE_UNIT_STAT_STRENGTH))))
```
Block:
```
/run print(GetCombatRating(CR_MASTERY)..","..GetMastery() .. "," .. GetBlockChance())
```

## Analysis
Ran Regression using R's `nlp` in several steps (visible in commit history)
1. DodgePerAgi/ParryPerStr (Q) left unconstrained as a sanity check
2. Fixed Q to tighten k-values, improve gradients
3. Fixed k-values to tighten caps

The final outputs were limited to 6 significant figures, as this is more than enough precision for any calculations we'll do and it causes the values to converge in several groupings of classes.
| Class       | k     | C_p     | C_d     | Q_s (85) | Q_a (85) | C_b     |
|-------------|-------|---------|---------|----------|----------|---------|
| Warrior     | 0.956 | 237.186 | 90.6425 | 0.004105 | 0.0001   | 150.376 |
| Paladin     | 0.886 | 237.186 | 66.5675 | 0.004105 | 0.0001   | 150.376 |
| Hunter      | 0.988 | 0       | 145.560 | 0        | 0.002273 | 0       |
| Rogue       | 0.988 | 145.560 | 145.560 | 0.0001   | 0.004107 | 0       |
| Priest      | 0.983 | 0       | 150.376 | 0        | 0.0001   | 0       |
| Deathknight | 0.956 | 237.186 | 90.6425 | 0.004105 | 0.0001   | 0       |
| Shaman      | 0.988 | 145.560 | 145.560 | 0.0001   | 0.003289 | 0       |
| Monk        | 1.422 | 90.6425 | 501.253 | 0.0001   | 0.004105 | 0       |
| Mage        | 0.983 | 0       | 150.376 | 0        | 0.0001   | 0       |
| Warlock     | 0.983 | 0       | 150.376 | 0        | 0.0001   | 0       |
| Druid       | 1.222 | 0       | 150.376 | 0        | 0.004105 | 0       |

Notes on base values:
* Monk has 3% base Parry but 5% from Swift Reflexes.
* Paladin and Warrior have 3% base Block but gain 10% from Guarded by the Light and Bastion of Defense, respectively.

