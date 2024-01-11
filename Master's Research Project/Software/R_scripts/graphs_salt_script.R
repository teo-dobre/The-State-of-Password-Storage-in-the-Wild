library(ggplot2)
library(plyr)
library(dplyr)
library(data.table)
library(gridExtra)
library(scales)

# Create pdf
pdf("Graphs_salt.pdf", onefile = TRUE, width = 14)

##############################################################################################################
# 1) Salt Used
##############################################################################################################

# Create new dataframe with the count for each Salt value
salt_used <- leaks_no_plaintext %>%
  count(Salt)

# Create pie chart
ggplot(salt_used, aes(x = "", y = n, fill = Salt)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = n),
            position = position_stack(vjust = 0.5)) +
  theme_void() +
  labs(title = "Salt Used")

##############################################################################################################
# 2) Salt through years
##############################################################################################################

# Create a stacked bar chart
ggplot(leaks_no_plaintext, aes(x = factor(Year), fill = Salt)) +
  geom_bar() +
  labs(x = "Year", y = "Number of Leaks", 
       title = "Salt usage by years")

##############################################################################################################
# 3) Salt Used MD5
##############################################################################################################

# Create new dataframe with salt usage only for leaks with MD5 hashing 
md5_salt = subset(leaks, Hashing == "MD5")
salt_used_md5 <- md5_salt %>%
  count(Salt)

# Create pie chart
ggplot(salt_used_md5, aes(x = "", y = n, fill = Salt)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = n),
            position = position_stack(vjust = 0.5)) +
  theme_void() +
  labs(title = "Salt Used MD5")





dev.off()