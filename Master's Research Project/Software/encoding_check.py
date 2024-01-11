import chardet

with open(r'C:\Users\Teo\Desktop\COMP4027-Research Project\Databases to clean\Gamigo.com.txt', 'rb') as f:
    result = chardet.detect(f.read())

print(result['encoding'])
