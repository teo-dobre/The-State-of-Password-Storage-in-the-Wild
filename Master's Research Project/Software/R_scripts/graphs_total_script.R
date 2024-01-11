library(ggplot2)
library(plyr)
library(dplyr)
library(data.table)
library(gridExtra)
library(scales)

# Create pdf
pdf("Graphs_total.pdf", onefile = TRUE, width = 14)

##############################################################################################################
# 1) Usage of Hashing Functions
##############################################################################################################

# USES EMPTY MULTIPLE!

# Create new dataframe that has the count of each hash function
hashes_total <- leaks_no_qpt_other %>%
  count(Hashing)

# Create bar plot
ggplot(hashes_total, aes(x = reorder(Hashing, -n), y = n, fill = Hashing)) +
  geom_bar(stat = "identity", width = 0.5, show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 45)) +
  geom_text(aes(label = n), vjust = -0.3, size = 3.5) +
  labs(x = "Hashing Function", y = "Number of leaks it was used in",
       title = "Usage of Hashing Functions")

##############################################################################################################
# 2) Passwords per hashing function
##############################################################################################################

# NO EMPTY MULTIPLE!

# Create new dataframe that has the total number of passwords per hash function
nr_pass_total <- leaks_no_empty_multiple_other %>% 
  group_by(Hashing) %>% 
  summarise(n = sum(Number_of_Passwords))

ggplot(nr_pass_total, aes(x = reorder(Hashing, -n), y = n, fill = Hashing)) +
  geom_bar(stat = "identity", width = 0.5, show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 45)) +
  geom_text(aes(label = comma(n)), vjust = -0.3, size = 3.5) +
  labs(x = "Hashing Function", y = "Number of passwords leaked with hash function", 
       title = "Passwords per hashing function")

##############################################################################################################
# 3) Average Passwords per hashing function
##############################################################################################################

# NO EMPTY MULTIPLE!

# Create new dataframe like in the average graph for "over_time"
hashes_total2 <- leaks_no_empty_multiple_other %>%
  count(Hashing)

# Merge the two previous dataframes and calculate the avg passwords leaked
avg_pass <- hashes_total2 %>%
  inner_join(nr_pass_total, by = "Hashing") %>%
  #filter(!(Hashing == "SHA-1" & Year == 2008)) %>%
  mutate(Average = n.y / n.x)

ggplot(avg_pass, aes(x = reorder(Hashing, -Average), y = Average, fill = Hashing)) +
  geom_bar(stat = "identity", width = 0.5, show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 45)) +
  geom_text(aes(label = comma(Average)), vjust = -0.3, size = 3.5) +
  labs(x = "Hashing Function", y = "Average Number of passwords leaked with hash function",
       title = "Average Passwords per hashing function")

##############################################################################################################
# 4) Box Plot of Number of Passwords per Hashing Function
##############################################################################################################

# NO EMPTY MULTIPLE!

# Create box plot
ggplot(leaks_no_empty_multiple_other, aes(x = Hashing, y = Number_of_Passwords, fill = Hashing)) +
  geom_boxplot() +
  labs(x = "Hashing Function", y = "Number of Passwords",
       title = "Box Plot of Number of Passwords")









dev.off()