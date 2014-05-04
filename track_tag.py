#!/usr/bin/env python
#-*- coding: utf8 -*-

# This script is meant to be used with abcde command.
# By default abcde doesn't tag track numbers and names.
# track_tag program adds these fields to ID3 tag, though
# it doesn't handle umlauts that well.
#
# TODO: Fix umlaut coding

import tagger
import glob
import os
import re
import sys

def globmp3files(argv):
    if argv[len(argv) - 1] != '/':
        fullpath = argv + "/"
    else:
        fullpath = argv
    return glob.glob(fullpath + "*.mp3")

def sanitizefilename(fname):
    """
    @return track number, sanitized filename
    """
    basename = os.path.basename(fname).rstrip(".mp3")
    tracknro, trackname = basename.split(".", 1)
    return tracknro, trackname.replace("_", " ")

def settracknumbername(fname):
    """
    Sets track number and track name into fname
    """
    tracknro, trackname = sanitizefilename(fname)
    mp3file = tagger.ID3v2(fname)

    titleframe = mp3file.new_frame("TIT2")
    titleframe.set_text(trackname)

    tracknroframe = mp3file.new_frame("TRCK")
    tracknroframe.set_text(tracknro)

    mp3file.frames.append(tracknroframe)
    mp3file.frames.append(titleframe)

    mp3file.commit()

def usage():
    print "./track_tag.py MyAlbumDirectory"
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage()

    if not os.path.isdir(sys.argv[1]):
        print "%s is not a directory" % (sys.argv[1])
        sys.exit(1)

    mp3files = globmp3files(sys.argv[1])
    for fname in mp3files:
        settracknumbername(fname)

