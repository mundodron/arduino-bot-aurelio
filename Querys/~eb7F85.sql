select account_no, bill_ref_no
 from cmf_balance where bill_ref_no in (156525105,156525705,156522810,159610477,159685557)
 
 
 SET DEFINE OFF;
Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (7522623, 156525105);
Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (7522620, 156525705);
   
   
   
COMMIT;




Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (2867874, 156522810);
Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (2867874, 159610477);
Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (2159103, 159685557);
COMMIT;
