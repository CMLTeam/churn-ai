
from settings import DATA_FILE

if __name__ =="__main__":
    with open(DATA_FILE) as f:
        for line in f.readlines():
            print(line)