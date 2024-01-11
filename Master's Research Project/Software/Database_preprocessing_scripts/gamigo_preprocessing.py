import pickle

# Create an empty list to store the strings
strings_list = []

# Open the input file for reading
with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Databases to clean\Gamigo.com.txt', 'r', encoding="Windows-1252") as input_file:
    # Open the output file for writing
    with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Leaked Databases\Gamigo_passwords.txt', 'w', encoding="utf8") as output_file:
        # Read the input file line by line
        for line in input_file:
            # Split the line into individual strings
            strings = line.strip("\n").split(":", maxsplit = 1)

            if strings[1]:
                # Write the 2nd string to the output file
                output_file.write(strings[1] + "\n")

                # Append the 2nd string to the list
                strings_list.append(strings[1])

# Save the list to a pickle file
with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Leaked Databases Pickle\Gamigo_passwords_pickle.pkl', 'wb') as pickle_file:
    pickle.dump(strings_list, pickle_file)
    