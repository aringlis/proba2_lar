;NAME:
; search_for_lars
;
;PURPOSE:
; function to find instances of anomalous LYRA events, such as
; large-angle rotations (LARs), during a timeseries.
;
;PREREQUISITES:
; lytaf_sorted.sav, a file containing the LYRA pointing anomaly
; information.
; 
; lytaf_event2string.pro - a function that converts LYRA event
;                          integers to string descriptors
;
;INPUTS:
; timearray - an input time array in UT format
;
;KEYWORDS:
; dir - directory within which to search for the lytaf_sorted.sav file.
;
;OUTPUT:
; returns a structure containing the instances of anomalous LYRA
; events and their type.
;
;WRITTEN:
;      Andrew Inglis - 2013/08/19
;      Andrew Inglis - 2013/08/20 - v2. Changed search method. Now
;                      look for whether any value in timearray lies in
;                      between LYTAF event start and end times. IF so,
;                      include that LYTAF event. Now, will always return both
;                      a start and end time for a LYTAF event even if
;                      the start or the end is outside the bounds of
;                      the timeseries.
;      Andrew Inglis - 2013/10/24 - now returns -1 if no pointing
;                      events are found within the specified time
;                      interval.
;                      - print an error message and return -1 if
;                        timearray is input as a scalar. 
;

FUNCTION search_for_lars,timearray,dir=dir

default,dir,''

;search for instances of 
restore,dir+'lytaf_sorted.sav',/verbose

;find the entries in the LYTAF that occur within the given
;time array. Want to trim the lytaf first
n=n_elements(timearray)

IF (n eq 1) THEN BEGIN
   print,'Input time must be a vector. Returning -1.'
   return,-1
ENDIF

t0=timearray[0]
t1=timearray[n-1]

lytaf_st0=value_locate(lytaf.start_times,t0) - 10
lytaf_st1=value_locate(lytaf.start_times,t1) + 10

lytaf_end0=value_locate(lytaf.end_times,t0) - 10
lytaf_end1=value_locate(lytaf.end_times,t1) + 10

m0=min([lytaf_st0,lytaf_end0])
m1=max([lytaf_st1,lytaf_end1])

a=m1-m0
mask=fltarr(a)

;try again. Just want to know if any values of timeseries lie in
;between the start_ind and the end_ind of any LYTAF event. If so,
;include this event in the output.

mask[*]=0
for j=0, a-1 do begin
   for h=0,n-1 do begin
      IF (timearray[h] gt lytaf.start_times[m0+j]) AND (timearray[h] lt lytaf.end_times[m0+j]) THEN BEGIN
         mask[j]=1
      ENDIF
   endfor
endfor


selection=findgen(a) + m0
ind=where(mask eq 1)
IF (ind eq -1) THEN BEGIN
   print,'No pointing events found during specified time interval. Returning -1.'
   return,-1
ENDIF

selection=selection[where(mask eq 1)]

;find the indices which denote the LAR start and end times within timeseries
start_indices=value_locate(timearray,lytaf.start_times[selection])
end_indices=value_locate(timearray,lytaf.end_times[selection])

;replace -1 indices with 0
for d=0,n_elements(start_indices)-1 do begin
   IF (start_indices[d] eq -1) THEN BEGIN
      start_indices[d] = 0
   ENDIF
endfor

event_type=lytaf.event_type[selection]
;event_type_ends=lytaf.event_type[selection]

;p0=[where((start_indices_tmp gt -1) AND (start_indices_tmp lt n-1),count_start)]
;p1=[where((end_indices_tmp gt -1) AND (end_indices_tmp lt n-1),count_end)]

;start_indices=start_indices_tmp
;end_indices=end_indices_tmp

;start_type=event_type_starts[p0]
;end_type=event_type_ends[p1]

event_type_info=lytaf_event2string(event_type)


lar_start_times=lytaf.start_times[selection]
lar_end_times=lytaf.end_times[selection]

lars=create_struct('start_indices',start_indices,'end_indices',end_indices,'lar_start_times',lar_start_times,'lar_end_times',lar_end_times,$
'event_type',event_type,'event_type_info',event_type_info)
;stop
return,lars

END
