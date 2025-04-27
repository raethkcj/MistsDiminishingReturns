classes <- read.csv("classes.csv", header = TRUE)
options(digits = 10)

for (i in seq_len(nrow(classes))) {
  base_strength <- classes[i, "base_strength"]
  base_agility <- classes[i, "base_agility"]
  base_parry <- classes[i, "base_parry"]
  base_dodge <- classes[i, "base_dodge"]
  stat_data <- read.csv(paste0(classes[i, "class"], ".csv"), header = TRUE)

  dodge_fit <- nls(
    dodge ~ 1 / (1 / C_d + k / (dodgeFromRatingPreDR + dodgePerAgi * agility))
    + base_dodge + base_agility * dodgePerAgi,
    data = stat_data,
    start = list(k = 0.9, dodgePerAgi = 1.0, C_d = 75)
  )
  print(summary(dodge_fit))

  parry_fit <- nls(
    parry ~ 1 / (1 / C_p + k / (parryFromRatingPreDR + parryPerStrength * strength))
	+ base_parry + base_strength * parryPerStrength,
    data = stat_data,
    start = list(k = 0.9, parryPerStrength = 1.0, C_p = 200))
  print(summary(parry_fit))
}
