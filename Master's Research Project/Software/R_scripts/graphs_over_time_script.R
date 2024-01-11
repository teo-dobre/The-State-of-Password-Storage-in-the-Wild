library(ggplot2)
library(plyr)
library(dplyr)
library(data.table)
library(gridExtra)
library(scales)

# Create pdf
pdf("Graphs_over_time.pdf", onefile = TRUE, width = 14)

##############################################################################################################
# 1) Number of leaks each year
##############################################################################################################

# USES EMPTY MULTIPLE!

# Create new dataframe that has the count of each hash function for each year
leaks_per_year <- leaks_no_multiple_other %>%
  count(Year)

# Create line plot
ggplot(leaks_per_year, aes(x = factor(Year), y = n, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(x = "Year", y = "Count",
       title = "Number of Leaks Each Year")

##############################################################################################################
# 2) Hashing Functions used each year
##############################################################################################################

# USES EMPTY MULTIPLE!

# Create new dataframe that has the count of each hash function for each year
hashes_per_year <- leaks_no_qpt_other %>%
  count(Hashing, Year)

# Create line plot
ggplot(hashes_per_year, aes(x = factor(Year), y = n, group = Hashing, color = Hashing)) +
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Hash Function",
       title = "Hashing Functions used each year")

##############################################################################################################
# 3) Number of Passwords Leaked by Year and Hashing Function
##############################################################################################################

# NO EMPTY MULTIPLE!

# Sum up the number of passwords for each year and each hash function
nr_pass_per_year <- aggregate(Number_of_Passwords ~ Year + Hashing, data = leaks_no_empty_multiple_other, FUN = sum)

# Create line plot
ggplot(nr_pass_per_year, aes(x = factor(Year), y = Number_of_Passwords, group = Hashing, color = Hashing)) + 
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Number of Passwords",
       title = "Number of Passwords Leaked by Year and Hashing Function")

##############################################################################################################
# 4) Average Number of Passwords Leaked by Year and Hashing Function
##############################################################################################################

# NO EMPTY MULTIPLE!

# Create new dataframe like for the first graph but without empty multiples.
# Otherwise, the average would be calculated by dividing the number of passwords,
#including the ones from empty multiples, by the 'n' of leaks with empty multiples
hashes_per_year2 <- leaks_no_empty_multiple_other %>%
  count(Hashing, Year)

# Merge the two previous dataframes and calculate the avg passwords leaked per year
avg_pass_per_year <- hashes_per_year2 %>%
  inner_join(nr_pass_per_year, by = c("Hashing", "Year")) %>%
  filter(!(Hashing == "SHA-1" & Year == 2008)) %>%
  mutate(Average = Number_of_Passwords / n)

# Create line plot
ggplot(avg_pass_per_year, aes(x = factor(Year), y = Average, group = Hashing, color = Hashing)) + 
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Average Number of Passwords",
       title = "Average Number of Passwords Leaked by Year and Hashing Function")

##############################################################################################################
# 5) Percent of passwords out of total (TODO)
##############################################################################################################

perc_pass_per_year <- nr_pass_per_year %>%
  group_by(Year, Hashing) %>%
  summarize(Perc_Passwords = Number_of_Passwords / sum(nr_pass_per_year$Number_of_Passwords) * 100)

ggplot(perc_pass_per_year, aes(x = factor(Year), y = Perc_Passwords, group = Hashing, color = Hashing, fill = Hashing)) +
  geom_area(alpha = .7, linewidth = 1, color = "black") +
  labs(x = "Year", y = "% of passwords", title = "Percentage of passwords by hashing function")

##############################################################################################################
# 6) Percent of passwords out of total for each year (TODO)
##############################################################################################################

# calculate total number of passwords for each year
df_year_total <- nr_pass_per_year %>%
  group_by(Year) %>%
  summarize(total_passwords = sum(Number_of_Passwords))

# calculate percentage of passwords for each hashing function based on the total number of passwords for each year
df_perc <- nr_pass_per_year %>% 
  left_join(df_year_total, by = "Year") %>% 
  mutate(perc_passwords = Number_of_Passwords / total_passwords * 100)

# create line plot of percentage of passwords by year and hashing function
ggplot(df_perc, aes(x = factor(Year), y = perc_passwords, group = Hashing, color = Hashing, fill = Hashing)) +
  geom_area(alpha = .7, linewidth = 1, color = "black") +
  labs(x = "Year", y = "% of passwords", title = "Percentage of passwords by hashing function and year")






dev.off()