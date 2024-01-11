import zxcvbn
import multiprocessing
import matplotlib.pyplot as plt
import time
import pickle

# Load the list of passwords from the pickle file
#with open(r'P:\COMP4027-Research Project\Leaked Databases Pickle\ClearVoice_Surveys_passwords_pickle.pkl', 'rb') as pickle_file:
#with open(r'P:\COMP4027-Research Project\Leaked Databases Pickle\Pokemon_Creed_passwords_pickle.pkl', 'rb') as pickle_file:
#with open(r'P:\COMP4027-Research Project\Leaked Databases Pickle\Unico_Campania_passwords_pickle.pkl', 'rb') as pickle_file:   
#with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Leaked Databases Pickle\Gamigo_passwords_pickle.pkl', 'rb') as pickle_file:
with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Leaked Databases Pickle\Warmane_passwords_pickle.pkl', 'rb') as pickle_file:
    passwords = pickle.load(pickle_file)

# Define a function to process a single password and return its score
def process_password(password):
    result = zxcvbn.zxcvbn(password)
    return result['score']

if __name__ == '__main__':
    multiprocessing.freeze_support()

    start = time.time()

    # Use multiprocessing.Pool to apply the process_password function to each password in parallel
    pool = multiprocessing.Pool()
    scores = pool.map(process_password, passwords)

    # Create a histogram of the ZXCVBN scores
    n, bins, patches = plt.hist(scores, bins = 5, range = (0, 5), align = 'left')
    plt.xticks(range(0, 5))
    plt.xlabel('ZXCVBN Score')
    plt.ylabel('Frequency')
    plt.title('Warmane ZXCVBN Scores') # change manually for different leaks

    # Calculate percentage for each bin
    bin_percentages = [100 * (count / len(scores)) for count in n]
    
    # Get maximum height of bars
    max_height = max(n)
    
    # add text to each bin
    for i in range(len(patches)):
        plt.text(x = bins[i], y = n[i] + 0.008 * max_height, s = f"{bin_percentages[i]:.1f}%", ha='center')

    end = time.time()
    print(end - start)

    plt.show()




