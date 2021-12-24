#Read a file from the current directory named envelopes-rewrite.txt and convert it to JSON
from json import dumps

file  = open('brandname-rewrite.txt', 'r')
data = file.readlines()
file.close()

with open('rewrites.json', 'w') as file:
    arr=[]
    for line in data:
        key,value = line.split(',')
        d = {}
        d["key"] = key
        d["value"] = value
        arr.append(d)        
    file.write(dumps(arr))
    file.close()
