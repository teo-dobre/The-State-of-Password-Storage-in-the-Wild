library(ggplot2)
library(plyr)
library(dplyr)
library(data.table)
library(gridExtra)
library(scales)

setwd("C:/Users/Teo/Desktop/COMP4027-Research Project")
leaks <- readxl::read_xlsx("HIBP_leaks.xlsx")

# Create column for year of leak
leaks$Year <- as.numeric(format(leaks$Date, "%Y"))

# Create dataframe without questionable plain text leaks
leaks_no_qpt <- subset(leaks, Questionable_plain_text != 1)

# Create dataframe without leaks tagged as 'multiple' that don't have a known
#distribution of number of passwords per hash
leaks_no_empty_multiple <- leaks_no_qpt
c = nrow(leaks_no_empty_multiple)

i = 1
while(i <= c) {
  if (leaks_no_empty_multiple[i, "Multiple"] == 1) {
    j = i
    while (leaks_no_empty_multiple[j + 1, 'Multiple'] == 1 & leaks_no_empty_multiple[j + 1, 'Leak'] == leaks_no_empty_multiple[i, 'Leak']) {
      j = j + 1
    }
    if (is.na(leaks_no_empty_multiple[j, 'Number_of_Passwords'])) {
      leaks_no_empty_multiple <- leaks_no_empty_multiple[-c(i:j), ]
      i = i - 1
      c = c - (j - i)
    }
  }
  i = i + 1
}

leaks_no_multiple <- leaks

k = nrow(leaks_no_multiple)
i = 1
while(i <= k) {
  if (leaks_no_multiple[i, "Multiple"] == 1) {
    j = i
    while(leaks_no_multiple[j + 1, "Multiple"] == 1 & leaks_no_multiple[j + 1, "Leak"] == leaks_no_multiple[i, "Leak"]) {
      j = j + 1
    }
    i = i + 1
    leaks_no_multiple <- leaks_no_multiple[-c(i:j), ]
    k = nrow(leaks_no_multiple)
    i = i - 1
  }
  i = i + 1
}

# Create list of hashes to be treated as "Other" in graphs due to low frequency
other_hashes <- c("argon2", "base64", "CRC32", "DEScrypt", "IPB", "Magento", 
                  "md5crypt", "MyBB", "MySQL5", "NSLDAPS", "NTLM", "PBKDF2", 
                  "phpBB", "phpBB3", "scrypt", "SHA-1bcrypt CUSTOM", "sha256crypt", 
                  "SMF", "WHMCS", "Wordpress", "XF", "SHA2-384", "vB")

# Create two new dataframes that have "Other" for the less relevant hashes
leaks_no_qpt_other <- leaks_no_qpt %>% 
  mutate(Hashing = if_else(Hashing %in% other_hashes, "Other", Hashing))
leaks_no_empty_multiple_other <- leaks_no_empty_multiple %>% 
  mutate(Hashing = if_else(Hashing %in% other_hashes, "Other", Hashing))
leaks_no_multiple_other <- leaks_no_multiple %>% 
  mutate(Hashing = if_else(Hashing %in% other_hashes, "Other", Hashing))

# Create a dataframe with no plain text leaks, used when analysing salt
leaks_no_plaintext = subset(leaks, Hashing != "plain text")

