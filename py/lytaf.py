import subprocess
import idlsave
import sqlite3

def update_lytaf():
    #download the latest version of the Proba-2 pointing database from the Proba2 Science Center
    subprocess.call(['curl','http://proba2.oma.be/lyra/data/lytaf/annotation_ppt.db','-o','annotation_ppt.db'])

    #now need to create the lytaf_sorted.sav file
    #involves executing SQLite commands from within python.
    #conn=sqlite3.connect('annotation_ppt.db')
    #c=conn.cursor()

    #c.execute('.mode csv')
    #c.execute('.output lytaf_temp.txt')
    #c.execute('select * from event')

    #can't execute dot sql commands from within Python. Try something else.
    subprocess.call('sqlite3 annotation_ppt.db < read_db_commands.sql',shell=True,executable='/bin/csh')

    #can't create lytaf_sorted.sav the same way in python as in IDL. Call IDL script instead
    subprocess.Popen('sswidl /Users/ainglis/physics/proba2_lar/idl/save_lytaf_in_python.pro',shell=True,executable='/bin/csh')

    print 'LYTAF update completed'



   
    
    
