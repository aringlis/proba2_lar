
from timeseries import TimeSeries
import idlsave
import numpy as np

def search_for_lars(timearray,dir=''):

    lytaf=idlsave.read(dir+'lytaf_sorted.sav')

    t0=timearray[0]
    t1=timearray[-1]

    lytaf_st0= (np.abs(lytaf.lytaf.start_times[0] - t0)).argmin() - 10
    lytaf_st1= (np.abs(lytaf.lytaf.start_times[0] - t1)).argmin() + 10

    lytaf_end0= (np.abs(lytaf.lytaf.end_times[0] - t0)).argmin() - 10
    lytaf_end1= (np.abs(lytaf.lytaf.start_times[0] - t1)).argmin() + 10

    m0=np.min([lytaf_st0,lytaf_end0])
    m1=np.max([lytaf_st0,lytaf_end1])

    a=m1-m0
    mask=np.zeros(a)

    print a
    print m1
    print m0
    

    #want to know if any values of timeseries lie in between the start_ind and the end_ind of any LYTAF event
    selection=[]
    
    for j in range(m0,m1):
        mask=0
        for h in range(0,len(timearray)):
            if ((timearray[h] > lytaf.lytaf.start_times[0][j]) and (timearray[h] < lytaf.lytaf.end_times[0][j])):
                mask=1
        if mask == 1:
            selection.append(j)
                
    print selection

    start_inds=[]
    end_inds=[]
    for s in selection:
        start_inds.append((np.abs(timearray - lytaf.lytaf.start_times[0][s])).argmin())
        end_inds.append((np.abs(timearray - lytaf.lytaf.end_times[0][s])).argmin())
    
    event_type=lytaf.lytaf.event_type[0][selection]
    print event_type
    event_type_info=lytaf_event2string(event_type)
    lar_start_times=lytaf.lytaf.start_times[0][selection]
    lar_end_times=lytaf.lytaf.end_times[0][selection]


    print selection
    print m0
    print m1
    return start_inds,end_inds,lar_start_times,lar_end_times,event_type,event_type_info


def lytaf_event2string(integers):
    n=len(integers)
    out=[]

    for i in integers:
        if i == 1:
            out.append('LAR')
        if i == 2:
            out.append('N/A')
        if i == 3:
            out.append('UV occult.')
        if i == 4:
            out.append('Vis. occult.')
        if i == 5:
            out.append('Offpoint')
        if i == 6:
            out.append('SAA')
        if i == 7:
            out.append('Auroral zone')
        if i == 8:
            out.append('Moon in LYRA')
        if i == 9:
            out.append('Moon in SWAP')
        if i == 10:
            out.append('Venus in LYRA')
        if i == 11:
            out.append('Venus in SWAP')


    return out
