#!/opt/local/bin/python

# pdf-postprocess.py: post-process HTML files generated by IPython's
# nbconvert program ready for putting into a PDF document.

from postprocessing import *
import sys

source_fn = sys.argv[1]
build_dir = sys.argv[2]

try:
    doc = open_html(source_fn, build_dir)

    remove_extraneous_characters(doc)
    remove_styling(doc)
    remove_scripts(doc)
    rewrite_internotebook_links_flat(doc)
    rewrite_title(doc)
    rewrite_embedded_media(doc)
    # rewrite_embedded_maths(doc)

    write_html(doc)
except Exception as ex:
    print ex
    sys.exit(1)
