
PRO update_lytaf,dir=dir,sort_only=sort_only

default,dir,''

IF NOT keyword_set(sort_only) THEN BEGIN
   spawn,'curl http://proba2.oma.be/lyra/data/lytaf/annotation_ppt.db -o annotation_ppt.db'
   spawn,'sqlite3 annotation_ppt.db < read_db_commands.sql'
ENDIF

l=read_csv('lytaf_temp.txt')

ind=sort(l.field2)

insertion_times=anytim(l.field1[ind],fiducial='sys')
start_times=anytim(l.field2[ind],fiducial='sys')
reference_times=anytim(l.field3[ind],fiducial='sys')
end_times=anytim(l.field4[ind],fiducial='sys')
event_type=l.field5[ind]

lytaf=create_struct('insertion_times',insertion_times,'start_times',start_times,'reference_times',reference_times,'end_times',end_times,'event_type',event_type)
SAVE,lytaf,filename='lytaf_sorted.sav'
print,'Output file written: lytaf_sorted.sav'
print,'Output directory: ', dir


END
