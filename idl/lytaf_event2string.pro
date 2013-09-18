;NAME:
; lytaf_event2string
;
; PURPOSE: 
; converts LYTAF event type integers to string descriptors
;
; INPUT:
; integers - an integer or array of integers to convert
;
; WRITTEN:
;     Andrew Inglis - 2013/08/19

FUNCTION lytaf_event2string,integers

n=n_elements(integers)
out=strarr(n)

for i=0,n_elements(integers)-1 DO BEGIN

   CASE integers[i] of
      1: BEGIN
         s='LAR'
      END
      2: BEGIN
         s='N/A'
      END
      3: BEGIN
         s='UV occult.'
      END
      4: BEGIN
         s='Vis. occult.'
      END
      5: BEGIN
         s='Offpoint'
      END
      6: BEGIN
         s='SAA'
      END
      7: BEGIN
         s='Auroral zone'
      END
      8: BEGIN
         s='Moon in LYRA'
      END
      9: BEGIN
         s='Moon in SWAP'
      END
      10: BEGIN
         s='Venus in LYRA'
      END
      11: BEGIN
         s='Venus in SWAP'
      END

   ENDCASE
   out[i]=s

endfor

return,out

END
