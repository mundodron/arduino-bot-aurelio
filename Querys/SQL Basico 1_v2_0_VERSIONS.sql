SELECT sal
FROM   emp
WHERE  ename = 'SMITH';

UPDATE emp
SET    sal = 4000
WHERE  ename = 'SMITH';

SELECT sal
FROM   emp
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' MINUTE)
WHERE  ename = 'SMITH';

SELECT sal
FROM   emp
VERSIONS BETWEEN TIMESTAMP
   SYSTIMESTAMP - INTERVAL '20' MINUTE AND
   SYSTIMESTAMP - INTERVAL '1' MINUTE
WHERE  ename = 'SMITH';

SELECT sal,
       VERSIONS_STARTTIME, -- start timestamp of version
       VERSIONS_STARTSCN,  -- start SCN of version
       VERSIONS_ENDTIME,   -- end timestamp of version
       VERSIONS_ENDSCN,    -- end SCN of version
       VERSIONS_XID,       -- transaction ID of version
       VERSIONS_OPERATION  -- operation of version
FROM   emp
VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE
--VERSIONS BETWEEN TIMESTAMP MINVALUE AND MAXVALUE
WHERE  ename = 'SMITH';

UPDATE emp
SET    sal =
       (
         SELECT sal
         FROM   emp
         AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '2' MINUTE)
         WHERE  ename = 'SMITH'
       )
WHERE  ename = 'SMITH';

SELECT sal
FROM   emp
WHERE  ename = 'SMITH';

SELECT xid,
       operation,
       undo_sql
FROM   flashback_transaction_query
WHERE  table_owner = USER
AND    table_name = 'EMP'
ORDER  BY start_timestamp;

SELECT xid, start_scn, commit_scn, operation, logon_user, undo_sql
FROM   flashback_transaction_query
WHERE  xid = HEXTORAW('000200030000002D');

