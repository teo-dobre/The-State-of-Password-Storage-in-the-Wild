import pickle

# Create an empty list to store the strings
strings_list = []

# Open the input file for reading
with open(r'P:\COMP4027-Research Project\Databases to clean\emailpass clearvoicesurveys.com.txt', 'r', encoding = "utf8") as input_file:
    # Open the output file for writing
    with open(r'P:\COMP4027-Research Project\Leaked Databases\ClearVoice_Surveys_passwords.txt', 'w', encoding = "utf8") as output_file:
        # Read the input file line by line
        for line_num, line in enumerate(input_file):
            # Skip the first line
            if line_num == 0:
                continue
            
            # Split the line by comma
            parts = line.strip("\n").split(',')
            
            # Check if the second part is empty
            if len(parts) < 2 or not parts[1]:
                continue
            
            # Write the second part to the output file
            output_file.write(parts[1] + '\n')
            
            # Append the 2nd string to the list
            strings_list.append(parts[1])
            
            # Save the list to a pickle file
with open('P:\COMP4027-Research Project\Leaked Databases Pickle\Clearvoice_Surveys_passwords_pickle.pkl', 'wb') as pickle_file:
    pickle.dump(strings_list, pickle_file)
