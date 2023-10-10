#!/usr/bin/env python3

import re
import sys


def main(input_file, output_file):
    with open(input_file, "r") as f:
        lines = f.readlines()

    output = []
    i = 0
    number_of_lines = len(lines)

    while i < number_of_lines:
        line = lines[i].split(",")
        if line[3] or line[7] or line[8]:
            output.append(line[1])
        i += 1

    with open(output_file, "w") as f:
        f.writelines(output)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise IOError("Not enough args.")
    main(sys.argv[1], sys.argv[2])
