
import re, os

def mailpasswd(machine, login, port):
    lookup_string = "machine %s login %s port %s password ([^ ]*)" % (machine, login, port)
    phrase = re.compile(lookup_string)
    authinfo = os.popen("gpg -q --no-tty -d ~/.authinfo.gpg").read()
    return phrase.search(authinfo).group(1)