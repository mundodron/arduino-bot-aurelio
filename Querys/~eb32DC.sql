    SELECT to_date(substr('2012071911560820120720111727',1,14),'yyyymmddhh24miss') dt_inicial,
        substr('2012071911560820120720111727',15,14) dt_final
    FROM dual;