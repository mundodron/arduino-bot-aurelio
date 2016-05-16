SELECT *
                       FROM service
                      WHERE 1=1 --service.parent_account_no = cmf.account_no
                       -- AND service.service_inactive_dt IS NULL)
                       AND (service.service_inactive_dt is null 
                        --OR (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active)
                       and service.service_active_dt > (sysdate -90 ))