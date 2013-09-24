"""
Proba-2 analysis code for splitting up LYRA timeseries around locations where LARs
(and other data events) are observed.
"""

import numpy as np
from timeseries import TimeSeries

def split_series_using_lytaf(timearray,data,lar):
    n=len(timearray)
    mask=np.ones(n)

    el=len(lar[0])

    for j in range(0,el):
        mask[lar[0][j]:lar[1][j]] = 0

    g_tmp=np.where(mask == 1)
    b_tmp=np.where(mask == 0)

    g=g_tmp[0]
    b=b_tmp[0]
    #print g
    #print len(g[0])
    #print len(b[0])
    #print b

    diffmask_tmp=[]
    for k in range(0,len(g)-1):
        diffmask_tmp.append(g[k+1]-g[k])

        #print diffmask

    diffmask=np.array(diffmask_tmp)

    d=np.where(diffmask > 1)
    d=d[0]
    nd=len(d)

    print d
    print nd
    split_series=[]
    #create a list of timeseries objects here
    for u in range(0,nd+1):
        if u == 0:
            subtimes=timearray[g[0]:g[d[u]]]
            subdata=data[g[0]:g[d[u]]]
            ts=TimeSeries(subtimes,subdata)
            split_series.append(ts)
        if u == nd:
            subtimes=timearray[g[d[u-1]+1]:g[len(g)-1]]
            subdata=data[g[d[u-1]+1]:g[len(g)-1]]
            ts=TimeSeries(subtimes,subdata)
            split_series.append(ts)
        if (0 < u < nd):
            subtimes=timearray[g[d[u-1]]:g[d[u]]]
            subdata=data[g[d[u-1]]:g[d[u]]]
            ts=TimeSeries(subtimes,subdata)
            split_series.append(ts)

    return split_series
            

        
    
