from bs4 import BeautifulSoup
import requests
from csv import writer

url = "https://haveibeenpwned.com/PwnedWebsites"
page = requests.get(url)

soup = BeautifulSoup(page.content, 'html.parser')
lists = soup.find_all('div', class_= "col-sm-10")

# Make a list with the compromised data for each leak
datas = []
for list in lists:
    data = list.find('strong', text = "Compromised data:").next_sibling
    datas.append(data)

# Lowercase the text
datas_lowered = []
for i in range (0, len(datas)):
    datas_lowered.append(datas[i].lower())

# Check if the leak included passwords
password_q = [0] * len(datas_lowered)
for i in range(0, len(datas_lowered)):
    if "password" in datas_lowered[i]:
        password_q[i] = 1

# Make a list with only leaks that contain passwords
lists_passwords = []
for i in range (0, len(lists)):
    if password_q[i] == 1:
        lists_passwords.append(lists[i])


# Make lists with the leak names, dates, dates added to HIBP, number of leaked passwords, hashing and salt
names = []
dates = []
dates_hibp = []
passwords_no = []
for list in lists_passwords:
    # Find the names of the leaks
    name = list.find('h3').text.replace('\n','')
    names.append(name)
    
    # Find the dates of the leaks
    date = list.find('strong', text = "Breach date:").next_sibling
    dates.append(date[1:])
    
    # Find the dates the leaks were added to HIBP
    date_hibp = list.find('strong', text = "Date added to HIBP:").next_sibling
    dates_hibp.append(date_hibp[1:])
    
    # Find the number of leaked passwords
    password_no = list.find('strong', text = "Compromised accounts:").next_sibling
    passwords_no.append(password_no[1:])
    
    
leaks_texts = []
for list in lists_passwords:
    leak_text = list.find('p').text.lower()
    leaks_texts.append(leak_text)
    
hashes = [0] * len(lists_passwords)
salts = [0] * len(lists_passwords)
for i in range(0, len(lists_passwords)):
    md5_q = 0
    sha1_q = 0
    sha256_q = 0
    sha512_q = 0
    bcrypt_q = 0
    pbkdf2_q = 0
    argon2_q = 0
    plaintext_q = 0
    
    hash = ""
    
    if "md5" in leaks_texts[i]:
        md5_q = 1
        hash = "MD5"
    if "sha-1" in leaks_texts[i] or "sha1" in leaks_texts[i]:
        sha1_q = 1
        hash = "SHA-1"
    if "sha-256" in leaks_texts[i] or "sha256" in leaks_texts[i]:
        sha256_q = 1
        hash = "SHA-256"
    if "sha-512" in leaks_texts[i] or "sha512" in leaks_texts[i]:
        sha512_q = 1
        hash = "SHA-512"
    if "bcrypt" in leaks_texts[i]:
        bcrypt_q = 1
        hash = "bcrypt"
    if "pbkdf2" in leaks_texts[i]:
        pbkdf2_q = 1
        hash = "PBKDF2"
    if "argon2" in leaks_texts[i]:
        argon2_q = 1
        hash = "argon2"
    if "plain text" in leaks_texts[i]:
        plaintext_q = 1
        hash = "plain text"
        
    if md5_q + sha1_q + sha256_q + sha512_q + bcrypt_q + pbkdf2_q + argon2_q + plaintext_q == 0:
        hash = "!not found!"
    
    if md5_q + sha1_q + sha256_q + sha512_q + bcrypt_q + pbkdf2_q + argon2_q + plaintext_q > 1:
        hash = "!multiple!"
    
    hashes[i] = hash
    
    
    if "unsalt" in leaks_texts[i] or "without a salt" in leaks_texts[i] or "without salt" in leaks_texts[i] or "no salt" in leaks_texts[i] or hash == "plain text":
        salt = 0
    elif "salt" in leaks_texts[i] or hash == "bcrypt" or hash == "PBKDF2" or hash == "argon2":
        salt = 1
    else:
        salt = "Unknown"
        
    salts[i] = salt

# Create the database with all the data
with open ('HIBP_leaks.csv', 'w', encoding = 'utf8', newline = '') as f:
    thewriter = writer(f)
    header = ['Leak', 'Date', 'Date Added to HIBP', 'Number of Passwords', 'Hashing', 'Salt?']
    thewriter.writerow(header)
    
    for i in range (0, len(lists_passwords)):
        info = [names[i], dates[i], dates_hibp[i], passwords_no[i], hashes[i], salts[i]]
        thewriter.writerow(info)


    
    
    
    
    
    
    



