import zxcvbn
import matplotlib.pyplot as plt
import pickle

# Read the plain text password database file and store the passwords in a list
passwords = []
#with open('P:\COMP4027-Research Project\Leaked Databases\ClearVoice_Surveys_passwords.txt', 'r', encoding = 'utf8') as f:
#with open('P:\COMP4027-Research Project\Leaked Databases Pickle\Pokemon_Creed_passwords_pickle.pkl', 'rb') as pickle_file:
with open(r'P:\COMP4027-Research Project\Leaked Databases Pickle\Unico_Campania_passwords_pickle.pkl', 'rb') as pickle_file:   
    passwords = pickle.load(pickle_file)

# Iterate over the passwords list and use the zxcvbn.zxcvbn function to calculate the ZXCVBN score for each password
scores = []
for password in passwords:
    result = zxcvbn.zxcvbn(password)
    score = result['score']
    scores.append(score)

# Create a histogram of the ZXCVBN scores
plt.hist(scores, bins=5, range=(0, 5), align='left')
plt.xticks(range(0, 5))
plt.xlabel('ZXCVBN Score')
plt.ylabel('Frequency')
plt.title('Distribution of ZXCVBN Scores in Password Database')
plt.show()