#!/usr/bin/env python3

import re
import sys


def main(input_file, output_file):
    with open(input_file, "r") as f:
        lines = f.readlines()

    output = []
    i = 0
    number_of_lines = len(lines)
    output_line = ""
    second_arg = False
    not_first_line = False

    while i < number_of_lines:
        line = lines[i]
        if re.match("^======================================= ", line):
            if not_first_line:
                output.append(output_line + "\n")
            output_line = ""
            second_arg = False
            not_first_line = True
        elif re.match("~~~~~~~~~~~~~~~~~~", line):
            output_line += ","
            second_arg = False
            not_first_line = True
        elif re.match("Results for", line) or re.match("^ =======================================$", line):
            output_line = ""
            second_arg = False
        else:
            if second_arg:
                output_line += " || "
            else:
                second_arg = True
            line_to_keep = line[:-1].split(":")
            output_line += line_to_keep[0] + ":" + line_to_keep[1]
            not_first_line = True
        i += 1

    with open(output_file, "w") as f:
        f.writelines(output)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise IOError("Not enough args.")
    main(sys.argv[1], sys.argv[2])
