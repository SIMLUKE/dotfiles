import sys
from wofi import Wofi

def main() -> int:
    r = Wofi()
    options = ['Red', 'Green', 'Blue', 'White', 'Silver', 'Black', 'Other']
    index, key = r.select('What colour car do you drive?', options)
    return 0

if __name__ == '__main__':
    sys.exit(main())
