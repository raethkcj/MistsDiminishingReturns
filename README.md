## Methods

### Exact Data
Fetched base dodge, base parry, dodge per agi, parry per str using res sickness and linear extrapolation

### Experimental Data
Since the initial belief was that each equation consisted of 3 unknowns (k, C, and Q), we gathered data from as varied points on the surface as possible, maximizing along each axis of base stat (strength or agility) and avoidance stat (parry or dodge). Varied stats using reforges, gems, enchants, limited in some cases when classes have a single primary stat. Each class measured a minimum of 1 baseline point and 3 points for agility, while classes that can parry measured at least 3 additional points for parry, in the following pattern:

1. Baseline (Zero in all input stats)

2. Zero Agility, maximize Dodge Rating
3. Maximize Agility. zero Dodge Rating
4. Maximize diminishable Dodge (full dodge/agi gems+enchants, Windwalk, agi flask/potion)

(Only measured for classes that can Parry, including Enhancement Shaman)
5. Zero Strength, maximize Parry Rating
6. Maximize Strength. zero Parry Rating
7. Maximize diminishable Parry (full parry/str gems+enchants, str flask/potion)

## Analysis
1. dodgePerAgi/parryPerStr left unconstrained as a sanity check
2. Fixed dodgePerAgi/parryPerStr to tighten k-values, improve gradients
3. Fixed k-values to tighten caps
4. Limited final results to 6 significant figures, as this is more than enough precision for any calculations we'll do and it causes the values to converge in several groupings of classes.

Note: Monk has 3% base Parry but 5% from Swift Reflexes
