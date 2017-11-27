## Importing the NSRL

The National Software Registry List (NSRL) is a collection of known
software managed by NIST. It is commonly used in forensics to reduce the
scope of analysis of already known software. This is typically done by
whitelisting anything on the NSRL by hash.

GRR has the ability to import the NSRL. This function prepopulates the
GRR datastore with all known hashes and reduces the need for GRR to
collect these from the client systems. This can be done by downloading
the latest quarterly release of the NSRL from
[NIST](http://www.nsrl.nist.gov/Downloads.htm#isos).

1.  Download NSRL from NIST

2.  Expand the zipped file containing hashes

3.  Run "import\_nsrl\_hashes.py" with the appropriate configuration
    options

<!-- end list -->

    ~/grr/tools# python import_nsrl_hashes.py --config /etc/grr/grr-server.yaml --filename /media/<path to expanded NSRL>/NSRLFile.txt
    Imported 5000 hashes
    Imported 10000 hashes
    Imported 15000 hashes
    Imported 20000 hashes
    Imported 25000 hashes