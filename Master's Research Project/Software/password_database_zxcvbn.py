import pickle
import zxcvbn
import multiprocessing
import time

# Load the list of passwords from the pickle file
with open('P:\COMP4027-Research Project\Leaked Databases Pickle\Pokemon_Creed_passwords_pickle.pkl', 'rb') as pickle_file:
    passwords = pickle.load(pickle_file)

# Define a function to process a single password and return its score
def process_password(password):
    result = zxcvbn.zxcvbn(password)
    return result

if __name__ == '__main__':
    multiprocessing.freeze_support()

    start = time.time()

    # Use multiprocessing.Pool to apply the process_password function to each password in parallel
    pool = multiprocessing.Pool()
    results = pool.map(process_password, passwords)
    
    # Save the scores to a pickle file
    with open('P:\COMP4027-Research Project\ZXCVBN Pickle\Pokemon_Creed_ZXCVBN.pkl', 'wb') as pickle_file:
        pickle.dump(results, pickle_file)