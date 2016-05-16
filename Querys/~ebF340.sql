select  TO_CHAR(MAX(JNL_COMPLETION_DT), 'YYYYMMDDHH24MISS')
       FROM JNL_RUNS_STATUS
       WHERE JNL_TYPE = 4
       AND RUN_STATUS = 1
       AND TO_CHAR(JNL_RUN_DT,'DD') <> '01';
       

       SELECT TO_CHAR(MAX(JNL_COMPLETION_DT), 'YYYYMMDDHH24MISS')
       FROM JNL_RUNS_STATUS
       WHERE JNL_TYPE = 4
       AND RUN_STATUS = 1
       AND TO_CHAR(JNL_RUN_DT,'DD') <> '01'
       AND  JNL_RUN_DT < (
                          SELECT  MAX(JNL_RUN_DT)
                          FROM JNL_RUNS_STATUS
                          WHERE JNL_TYPE = 4
                          AND RUN_STATUS = 1
                          AND TO_CHAR(JNL_RUN_DT,'DD') <> '01'
                         );
                         
                         
                         
select * from JNL_RUNS_STATUS


2013 09 12 10:31:27

2013 09 06 13:17:01


select * from GVT_PL_CONTA_DETALHADA