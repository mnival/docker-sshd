import sys
import json

if __name__ == "__main__":
    secrets = json.loads(sys.argv[1])
    for key, value in secrets.items():
        print(f"::add-mask::{value}")
