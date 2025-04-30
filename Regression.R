classes <- read.csv("classes.csv", header = TRUE)
options(digits = 10)

for (i in seq_len(nrow(classes))) {
  class <- classes[i, "class"]
  print(class)

  base_strength <- classes[i, "base_strength"]
  base_agility <- classes[i, "base_agility"]
  base_parry <- classes[i, "base_parry"]
  base_dodge <- classes[i, "base_dodge"]
  parry_per_strength <- classes[i, "parry_per_strength"]
  dodge_per_agi <- classes[i, "dodge_per_agi"]
  k <- classes[i, "k"]
  base_block <- classes[i, "base_block"]
  block_per_mastery <- classes[i, "block_per_mastery"]

  stat_data <- read.csv(paste0(class, ".csv"), header = TRUE)

  tryCatch ({
    dodge_fit <- nls(
      dodge ~ 1 / (1 / C_d + k / (dodgeFromRatingPreDR + dodge_per_agi * agility))
        + base_dodge + base_agility * dodge_per_agi,
      data = stat_data,
      start = list(C_d = 75)
    )
    print(summary(dodge_fit))
  }, error = function(e) {
    print(paste0("Failed to fit dodge for ", class, ": ", e))
  })

  if (base_parry > 0) {
    tryCatch ({
      parry_fit <- nls(
        parry ~ 1 / (1 / C_p + k / (parryFromRatingPreDR + parry_per_strength * strength))
          + base_parry + base_strength * parry_per_strength,
        data = stat_data,
        start = list(C_p = 200))
      print(summary(parry_fit))
    }, error = function(e) {
      print(paste0("Failed to fit parry for ", class, ": ", e))
    })
  }

  if (base_block > 0) {
    block_data <- read.csv(paste0(class, "_block.csv"), header = TRUE)

    tryCatch ({
      block_fit <- nls(
        block ~ 1 / (1 / C_b + k / (round(block_per_mastery * 128 * mastery)/128))
          + base_block,
        data = block_data,
        start = list(C_b = 200))
      print(summary(block_fit))
    }, error = function(e) {
      print(paste0("Failed to fit block for ", class, ": ", e))
    })
  }
}
