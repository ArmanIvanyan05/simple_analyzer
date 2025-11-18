import os
import time
import random

from analyzer import Analyzer
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Application version
__version__ = "v1.0.0"
print(f"Running application version: {__version__}")

# Read config file path from environment variable
config_file = os.environ.get('CONFIG_FILE')

# Read and parse configuration
with open(config_file, 'r') as config:
    lines = config.readlines()
    interval = int(lines[0].split('=')[1].strip())
    sequence_length = int(lines[1].split('=')[1].strip())

print(f"Loaded configuration → interval={interval}, sequence_length={sequence_length}")

# Initialize analyzer with an empty list
numbers = []
analyzer = Analyzer(numbers)

# Main loop
while True:
    # Generate a random number
    num = random.randint(1, 100)
    analyzer.add_number(num)

    # Keep the sequence at the configured length
    if len(analyzer.array) > sequence_length:
        analyzer.array.pop(0)

    # Display diagnostic output
    print(f"\nGenerated number: {num}")
    print(f"Current sequence: {analyzer.array}")
    print(
        f"Even count: {analyzer.even_count()} | "
        f"Odd count: {analyzer.odd_count()} | "
        f"Increasing pairs: {analyzer.increasing_pairs()} | "
        f"Highest value: {analyzer.highest_number()}"
    )

    # Check if we must stop: sequence full + minute boundary
    current_time = time.localtime()
    if len(analyzer.array) >= sequence_length and current_time.tm_sec == 0:
        print("\nStopping program: sequence is full and the current minute reached 00 seconds.")
        break

    # Wait based on interval
    time.sleep(interval)
