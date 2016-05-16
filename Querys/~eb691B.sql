declare

begin

if not exists (select * from GVT_DURATION_USG_VARIABLE where ELEMENT_ID = 11783 and TYPE_ID_USG = 360) then

 Insert into GVT_DURATION_USG_VARIABLE
   (TYPE_ID_USG, ELEMENT_ID, ACCT_CATEGORY, USG_MIN_RATE_VARIABLE, USG_CADENCE_2, SET_UNITS_2)
 Values
   (360, 11783, 0, 30, 6, 'S')

end if

end;
