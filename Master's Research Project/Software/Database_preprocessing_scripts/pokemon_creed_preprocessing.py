import pickle

# Create an empty list to store the strings
strings_list = []

# Open the input file for reading
with open(r'P:\COMP4027-Research Project\Databases to clean\pokemoncreed.net.txt', 'r', encoding="utf8") as input_file:
    # Open the output file for writing
    with open(r'P:\COMP4027-Research Project\Leaked Databases\Pokemon_Creed_passwords.txt', 'w', encoding="utf8") as output_file:
        # Read the input file line by line
        for line in input_file:
            # Split the line into individual strings
            strings = line.strip("\n").split("\t")

            # Write the 4th string from the back to the output file
            output_file.write(strings[-4] + "\n")

            # Append the 4th string from the back to the list
            strings_list.append(strings[-4])

# Save the list to a pickle file
with open('P:\COMP4027-Research Project\Leaked Databases Pickle\Pokemon_Creed_passwords_pickle.pkl', 'wb') as pickle_file:
    pickle.dump(strings_list, pickle_file)

            