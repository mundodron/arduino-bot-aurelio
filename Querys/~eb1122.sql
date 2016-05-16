DECLARE
         temp_geocode          char(15);
         temp_account_no       number(10);
BEGIN


if (NOT INSERTING) AND
   (UPDATING('change_who')) AND (RTRIM(:new.change_who)='CMF_EXEMPT_TRIGGER') AND
   (RTRIM(:new.change_who)='SERVICE_IUTRIG_GEOCODE') AND (UPDATING('fx_geocode')) AND (:new.fx_geocode is NOT NULL)
THEN
        :new.change_who := :old.change_who;

ELSE
     BEGIN

      select distinct account_no
        into temp_account_no
        from service_address_assoc
       where address_id=:new.address_id
         and INACTIVE_DT is null
         and ASSOCIATION_STATUS = 2;

     EXCEPTION
     WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001,
             '190120, TRIG: INSERT/UPDATE Failed: Account nao encontrado' || temp_account_no);
     END;

         generate_geocode (
                   :new.country_code,
                   :new.franchise_tax_code,
                   temp_account_no,
                   temp_geocode);

         :new.fx_geocode := temp_geocode;

         UPDATE SERVICE_BILLING
             SET service_geocode = temp_geocode
             WHERE parent_account_no=temp_account_no;

END IF;

END;


 select * from service_address_assoc
where account_no = '7426812';