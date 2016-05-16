DROP TRIGGER ARBOR.CMF_BALANCE_RTRIG;

CREATE OR REPLACE TRIGGER ARBOR.cmf_balance_Rtrig
    BEFORE INSERT OR UPDATE 
    OF total_paid, new_charges, total_adj, dispute_amt, 
       balance_due, closed_date, bill_ref_no, account_no,
       new_charge_credits
    ON ARBOR.CMF_BALANCE     FOR EACH ROW
DECLARE
    lx            BINARY_INTEGER;
BEGIN

/* CAMqa89369 */
IF :new.total_adj > 0 THEN
   IF (:new.total_adj + :new.dispute_amt) > ABS(:new.new_charge_credits) THEN
      raise_application_error (-20001, '147002, TRIG: INSERT/UPDATE Failed: Total debit adjustments may not be greater than new charge credits.');
   END IF;
END IF;

IF :new.total_adj < 0 THEN
   IF ABS(:new.total_adj + :new.dispute_amt) > (:new.new_charges + :new.new_charge_credits) THEN
    raise_application_error (-20001, '147001, TRIG: INSERT/UPDATE Failed: Total credit adjustments may not be greater than new charges + new charge credits.');
   END IF;
END IF;

/* since new_charges, total_adj, or total_paid is changing (due to the "OF" **
** clause above) always update the balance_due field.                       
** CAMqa89369: include new_charge_credits */

:new.balance_due := :new.new_charges + :new.new_charge_credits + :new.total_adj + :new.total_paid;

/* DENqa80696: balance_due cannot be < 0 for non-zero invoices */
IF INSERTING THEN
   IF (:new.bill_ref_no != 0 AND :new.balance_due < 0) THEN
      raise_application_error (-20001, '147003, TRIG: INSERT Failed: balance_due cannot be negative for non-zero invoices.');
   END IF;

ELSIF UPDATING THEN
   IF (:new.bill_ref_no != 0 AND
       :new.balance_due < 0 AND :old.balance_due >= 0) THEN
      raise_application_error (-20001, '147004, TRIG: UPDATE Failed: balance_due cannot be negative for non-zero invoices.');
   END IF;
END IF;

/* END DENqa80696 */

/* check to make sure the closed date has the appropriate value.  
   If not then update it.  */
IF
    :new.closed_date IS NULL AND 
    :new.balance_due = 0 AND
    :new.dispute_amt = 0 AND
    :new.bill_ref_no != 0
THEN
    :new.closed_date := SYSDATE;
ELSIF
    :new.closed_date IS NOT NULL AND 
    (:new.balance_due != 0 OR 
     :new.dispute_amt != 0)
THEN
    :new.closed_date := NULL;
END IF;

/* Set the gl_amount to the new_charges 
** CAMqa89369: include new_charge_credits */

:new.gl_amount := :new.new_charges + :new.new_charge_credits;

END;
/

