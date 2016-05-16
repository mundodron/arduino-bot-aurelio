DROP TRIGGER ARBOR.SERVICE_ADDRESS_ASSOC_AIUTRIG;

CREATE OR REPLACE TRIGGER ARBOR.SERVICE_ADDRESS_ASSOC_AIUTRIG
   AFTER INSERT OR UPDATE
   ON ARBOR.SERVICE_ADDRESS_ASSOC 
DECLARE
    v_ErrorCode        NUMBER;
    v_ErrorText        VARCHAR2(100);
    row_c            NUMBER(10);
    d_display_address_id    SERVICE_KEY.display_address_id%TYPE;
    d_b_end_address_id    SERVICE_KEY.b_end_address_id%TYPE;
    v_address_id        SERVICE_ADDRESS_ASSOC.address_id%TYPE;
    v_b_end_address_id    SERVICE_ADDRESS_ASSOC.address_id%TYPE;
    v_fx_geocode        LOCAL_ADDRESS.fx_geocode%TYPE;
    v_franchise_tax_code    LOCAL_ADDRESS.franchise_tax_code%TYPE;
        v_update_svc        NUMBER(1);
        v_update_bend        NUMBER(1);
BEGIN
IF service_address_assoc_pkg.v_status_update = 0 THEN
   IF service_address_assoc_pkg.trig_tab.LAST IS NOT NULL THEN
      FOR idx IN service_address_assoc_pkg.trig_tab.FIRST .. service_address_assoc_pkg.trig_tab.LAST LOOP
         IF (INSERTING OR UPDATING('association_status')) THEN 
            IF service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT THEN
               /*
               ** Inactivate previous active (current) row
               */
               BEGIN
                  service_address_assoc_pkg.v_status_update := 1;
                  UPDATE SERVICE_ADDRESS_ASSOC
                     SET association_status = view_types.cOLD,
                         inactive_dt = service_address_assoc_pkg.trig_tab(idx).active_dt
                   WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                     AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets
                     AND address_category_id = service_address_assoc_pkg.trig_tab(idx).address_category_id
                     AND service_address_assoc_id != service_address_assoc_pkg.trig_tab(idx).service_address_assoc_id
                     AND association_status = view_types.cCURRENT;
                  service_address_assoc_pkg.v_status_update := 0;
               EXCEPTION
                  WHEN OTHERS THEN
                  service_address_assoc_pkg.v_status_update := 0;
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159119, TRIG: INSERT/UPDATE Failed: Unable to update previous current association to old.');
               END;
            END IF; /* end if inserting or updating assocation_status to current */

            IF service_address_assoc_pkg.trig_tab(idx).association_status IN (view_types.cCURRENT, view_types.cPENDING) THEN
           /* 
               ** There can only be 1 current and 1 pending row for each 
               ** subscr_no, subscr_no_resets, address_category_id combination
               */
               SELECT COUNT(1) into row_c
                 FROM SERVICE_ADDRESS_ASSOC
                WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
              AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets
              AND address_category_id = service_address_assoc_pkg.trig_tab(idx).address_category_id
              AND association_status = service_address_assoc_pkg.trig_tab(idx).association_status;
    
               IF row_c > 1 THEN
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159119, TRIG: INSERT/UPDATE Failed: Only 1 current and 1 pending row for each subscr_no/resets and address_category_id combination.');
               END IF; /* end if duplicate rows exist */
            END IF; /* inserted or updated association_status is current or pending */
         END IF; /* end if inserting or updating association_status */

     /* 
         ** Check for overlapping dates.
         */
       IF (service_address_assoc_pkg.trig_tab(idx).association_status IN (view_types.cCURRENT, view_types.cPENDING) AND
            (service_address_assoc_pkg.trig_tab(idx).inactive_dt IS NULL OR
              service_address_assoc_pkg.trig_tab(idx).active_dt != service_address_assoc_pkg.trig_tab(idx).inactive_dt)) THEN
            SELECT COUNT(1) INTO row_c
          FROM SERVICE_ADDRESS_ASSOC
             WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
           AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets
           AND address_category_id = service_address_assoc_pkg.trig_tab(idx).address_category_id
           AND association_status = service_address_assoc_pkg.trig_tab(idx).association_status
               AND ((service_address_assoc_pkg.trig_tab(idx).active_dt >= active_dt AND
                    (service_address_assoc_pkg.trig_tab(idx).active_dt < inactive_dt OR 
                    inactive_dt IS NULL)) 
                OR (service_address_assoc_pkg.trig_tab(idx).active_dt < active_dt AND
                    (service_address_assoc_pkg.trig_tab(idx).inactive_dt > active_dt OR 
                     service_address_assoc_pkg.trig_tab(idx).inactive_dt IS NULL)));
    
            IF row_c > 1 THEN
               service_address_assoc_pkg.trig_tab.DELETE;
               raise_application_error (-20001, '159119, TRIG: INSERT/UPDATE Failed: Overlapping active/inactive dates among current or pending rows.');
            END IF; /* end if overlap exists */
         END IF; /* check for overlaps */

         v_update_svc := 0;
         v_update_bend := 0;
         IF service_address_assoc_pkg.trig_tab(idx).address_category_id = 1 THEN
            d_display_address_id := NULL;
            BEGIN
           SELECT display_address_id 
                 INTO d_display_address_id
             FROM SERVICE_KEY
                WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                  AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159119, TRIG: INSERT/UPDATE Failed: Unable to find service display address.');
            END;

            IF ((INSERTING AND
                 service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cPENDING AND
                 d_display_address_id IS NULL) OR
                service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_svc := 1;
               v_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('address_category_id') AND 
                   service_address_assoc_pkg.trig_tab(idx).old_address_category_id = 2 AND
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_svc := 1;
               v_update_bend := 1;
               v_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
               v_b_end_address_id := NULL;
            ELSIF (UPDATING('address_id') AND
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_svc := 1;
               v_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('association_status') AND 
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               /* going from pending to current */
               v_update_svc := 1;
               v_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('association_status') AND 
                   (service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCANCELLED OR
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cOLD)) THEN
               /* going from pending to cancelled, or current to old */
               v_update_svc := 1;
               v_address_id := NULL;
            END IF;
         ELSE /* address_category_id is 2 */
            d_b_end_address_id := NULL;
            BEGIN
           SELECT b_end_address_id 
                 INTO d_b_end_address_id
             FROM SERVICE_KEY
                WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                  AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159119, TRIG: INSERT/UPDATE Failed: Unable to find b-end address.');
            END;

            IF ((INSERTING AND
             service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cPENDING AND
                 d_b_end_address_id IS NULL) OR
                 service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_bend := 1;
               v_b_end_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('address_category_id') AND 
                   service_address_assoc_pkg.trig_tab(idx).old_address_category_id = 1 AND
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_svc := 1;
               v_update_bend := 1;
               v_address_id := NULL;
               v_b_end_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('address_id') AND
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               v_update_bend := 1;
               v_b_end_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('association_status') AND 
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCURRENT) THEN
               /* going from pending to current */
               v_update_bend := 1;
               v_b_end_address_id := service_address_assoc_pkg.trig_tab(idx).address_id;
            ELSIF (UPDATING('association_status') AND 
                   (service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cCANCELLED OR
                   service_address_assoc_pkg.trig_tab(idx).association_status = view_types.cOLD)) THEN
               /* going from pending to cancelled, or current to old */
               v_update_bend := 1;
               v_b_end_address_id := NULL;
            END IF;
         END IF;

         IF v_update_svc = 1 THEN
            IF (v_address_id IS NULL AND d_display_address_id IS NOT NULL) THEN
               /*
               ** If a status change from pending to canceled has occured, 
               ** check to see if a current association exists for this
               ** service.  If so, leave the current display_address_id as is
           ** to the address_id of that association.
               */
               BEGIN
                  SELECT address_id INTO v_address_id
                FROM SERVICE_ADDRESS_ASSOC
               WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                     AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets
                     AND address_category_id = 1
                     AND association_status = view_types.cCURRENT;
           EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                 NULL;
              WHEN OTHERS THEN           
                     v_ErrorCode := SQLCODE;
                     v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                     service_address_assoc_pkg.trig_tab.DELETE;
                     raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to get current service address (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
               END;
        END IF; /* end display_address_id */       
   
            IF v_address_id IS NOT NULL THEN
               BEGIN
                  SELECT fx_geocode, franchise_tax_code
                    INTO v_fx_geocode, v_franchise_tax_code
                    FROM ADR_ADDRESS
                   WHERE address_id = v_address_id;
               EXCEPTION
                  WHEN OTHERS THEN           
                     v_ErrorCode := SQLCODE;
                     v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                     service_address_assoc_pkg.trig_tab.DELETE;
                     raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to retrieve geocode and franchise tax code for service address (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
               END;
 
               BEGIN
                 UPDATE SERVICE_KEY
                    SET display_address_id = v_address_id,
                        service_geocode = v_fx_geocode,
                        service_franchise_tax_code = v_franchise_tax_code
                  WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                    AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
           EXCEPTION
             WHEN OTHERS THEN           
                    v_ErrorCode := SQLCODE;
                    v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                    service_address_assoc_pkg.trig_tab.DELETE;
                    raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to update service address information in SERVICE_KEY (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
               END;
            ELSE
               v_fx_geocode := NULL;
               v_franchise_tax_code := NULL;
            END IF;
 
            --BEGIN
            --   UPDATE SERVICE_KEY
            --      SET display_address_id = v_address_id,
            --          service_geocode = v_fx_geocode,
            --          service_franchise_tax_code = v_franchise_tax_code
            --    WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
            --      AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
        --EXCEPTION
        --   WHEN OTHERS THEN           
            --      v_ErrorCode := SQLCODE;
            --      v_ErrorText := SUBSTR(SQLERRM, 1, 100);
            --      service_address_assoc_pkg.trig_tab.DELETE;
            --      raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to update service address information in SERVICE_KEY (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
            --END;
 
            IF service_address_assoc_pkg.trig_tab(idx).inactive_dt IS NULL THEN
                BEGIN
                   UPDATE SERVICE_BILLING
                      SET service_geocode = v_fx_geocode,
                          service_franchise_tax_code = v_franchise_tax_code
                    WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                      AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
                EXCEPTION
                   WHEN OTHERS THEN           
                      v_ErrorCode := SQLCODE;
                      v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                      service_address_assoc_pkg.trig_tab.DELETE;
                      raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to update service geocode and franchise tax code in SERVICE_BILLING (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
                END;
            END IF;
            
         END IF; /* end if v_update_svc */
   
         IF v_update_bend = 1 THEN
            IF (v_b_end_address_id IS NULL AND d_b_end_address_id IS NOT NULL) THEN
               /*
               ** If a status change from pending to canceled has occured, 
               ** check to see if a current association exists for this
               ** service.  If so, leave the current b_end_address_id as is
           ** to the address_id of that association.
               */
               BEGIN
                  SELECT address_id INTO v_b_end_address_id
                FROM SERVICE_ADDRESS_ASSOC
               WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                     AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets
                     AND address_category_id = 2
                     AND association_status = view_types.cCURRENT;
           EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                 v_b_end_address_id := NULL;
              WHEN OTHERS THEN           
                     v_ErrorCode := SQLCODE;
                     v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                     service_address_assoc_pkg.trig_tab.DELETE;
                     raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to get current b-end address (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
               END;
            END IF; /* end b_end_address_id */       
 
            IF v_b_end_address_id IS NOT NULL THEN
               BEGIN
                  SELECT fx_geocode, franchise_tax_code
                    INTO v_fx_geocode, v_franchise_tax_code
                    FROM ADR_ADDRESS
                   WHERE address_id = v_b_end_address_id;
               EXCEPTION
                  WHEN OTHERS THEN           
                     v_ErrorCode := SQLCODE;
                     v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                     service_address_assoc_pkg.trig_tab.DELETE;
                     raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to retrieve geocode and franchise tax code for b-end address (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
               END;
            ELSE
               v_fx_geocode := NULL;
               v_franchise_tax_code := NULL;
            END IF;
 
            BEGIN
               UPDATE SERVICE_KEY
                  SET b_end_address_id = v_b_end_address_id,
                      b_service_geocode = v_fx_geocode,
                      b_service_franchise_tax_code = v_franchise_tax_code
                WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                  AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
            EXCEPTION
               WHEN OTHERS THEN           
                  v_ErrorCode := SQLCODE;
                  v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to update b-end address information in SERVICE_KEY (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
            END;

            BEGIN
               UPDATE SERVICE_BILLING
                  SET b_service_geocode = v_fx_geocode,
                      b_service_franchise_tax_code = v_franchise_tax_code
                WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
                  AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
            EXCEPTION
               WHEN OTHERS THEN           
                  v_ErrorCode := SQLCODE;
                  v_ErrorText := SUBSTR(SQLERRM, 1, 100);
                  service_address_assoc_pkg.trig_tab.DELETE;
                  raise_application_error (-20001, '159111, TRIG: UPDATE Failed: Unable to update b-end geocode and franchise tax code in SERVICE_BILLING (' || v_ErrorCode || ': ' || v_ErrorText || '...).');
            END;
         END IF; /* end v_update_bend */
      END LOOP;

      service_address_assoc_pkg.trig_tab.DELETE;
   END IF; /* package is not null */
END IF; /* v_status_update = 0 */
END;
/

