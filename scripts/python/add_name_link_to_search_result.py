#!/usr/bin/env python3

import sys


def main(name_file, link_file, search_file, output_file):
    with open(name_file, "r") as f:
        names = f.readlines()

    length = len(names)

    with open(link_file, "r") as f:
        links = f.readlines()

    if len(links) != length:
        raise IOError("Link file does not have the same length as name file.")

    with open(search_file, "r") as f:
        searches = f.readlines()

    if len(searches) != length:
        raise IOError("Search file does not have the same length as name file.")

    output = [names[i][:-1] + "," + links[i][:-1] + ",," + searches[i] for i in range(length)]

    with open(output_file, "w") as f:
        f.writelines(output)


if __name__ == "__main__":
    if len(sys.argv) < 5:
        raise IOError("Not enough args.")
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
