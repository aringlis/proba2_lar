;NAME:
; split_series_using_lytaf
;
;PURPOSE:
; procedure to split up an input LYRA timeseries into separate
; sub-series. These subseries are the data regions that are unaffected
; by LYRA pointing anomalies (e.g. LARS). The affected regions of the
; timeseries are discarded.
;
;INPUTS:
; timearray - an input time array in UT format
; data - an input data array of the same length as timearray
;        l - a structure returned by the search_for_lars function,
;            containing the timestamps and indices of LYRA pointing anomalies
;
;OUTPUT:
; series_list - an IDL list of structures, containing the sub-series.
;
;WRITTEN:
; Andrew Inglis - 2013/08/20 - version 1

PRO split_series_using_lytaf,timearray,data,l,series_list,display=display

;l is the structure derived from search_for_lars.pro
n=n_elements(timearray)

mask=fltarr(n)

;good intervals are marked '1'
mask[*]=1

;find 'bad' intervals and mark '0'

for j=0,n_elements(l.start_indices)-1 do begin
   mask[l.start_indices[j]:l.end_indices[j]] = 0
endfor


;mask for the good intervals
g=where(mask eq 1)
;mask for the bad intervals
b=where(mask eq 0)

len=n_elements(g)
;find discontinuous points in the mask. These are the split points.
diffmask=fltarr(len)
for k=0,len-2 do begin
   diffmask[k] = g[k+1] - g[k]
endfor

;d finds the discontinuities
d=where(diffmask gt 1,count)

nd=n_elements(d)
;will have nd+1 timeseries
;

;make the sub-series based on the 'good' data times. save the output
;in an IDL list

for u=0,nd do begin
   IF (u eq 0) THEN BEGIN
      subtimes=timearray[g[0]:g[d[u]]]
      subdata=data[g[0]:g[d[u]]]
      split_series=create_struct('subtimes',subtimes,'subdata',subdata,'counter',u)
      series_list=list(split_series)
   ENDIF ELSE IF (u eq nd) THEN BEGIN
      subtimes=timearray[g[d[u-1]+1]:g[len-1]]
      subdata=data[g[d[u-1]+1]:g[len-1]]
      tmp_struct=create_struct('subtimes',subtimes,'subdata',subdata,'counter',u)
      ;split_series=merge_struct(split_series,tmp_struct)
      series_list.Add,tmp_struct
   ENDIF ELSE BEGIN
      subtimes=timearray[g[d[u-1]+1]:g[d[u]]]
      subdata=data[g[d[u-1]+1]:g[d[u]]]
      tmp_struct=create_struct('subtimes',subtimes,'subdata',subdata,'counter',u)
      ;split_series=merge_struct(split_series,tmp_struct)
      series_list.Add,tmp_struct
   ENDELSE

endfor

;optionally, display the split time series in a plot
IF keyword_set(display) THEN BEGIN
   set_plot,'ps'
   device,encaps=1,color=1,decomposed=0,filename='lar_display.ps'
   device,xsize=16,ysize=10
   loadct,39
   ;window,1
   utplot,timearray,data,charsize=1.2,color=240,ytitle='intensity (arb.)',xthick=3,ythick=3,thick=3,charthick=3
   ;utplot,timearray[b],data[b],charsize=1.2,color=240,ytitle='intensity (arb.)'
   for v=0,nd do begin
      outplot,series_list[v].subtimes,series_list[v].subdata,color=0,thick=3
   endfor

   al_legend,['LAR'],linestyle=[0],color=[240],/top,/right,thick=3
   device,/close
   set_plot,'x'
   loadct,0
ENDIF

END
