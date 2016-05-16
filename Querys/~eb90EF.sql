select SERVICE_NUMBER,
       ACTIVE_DATE,
       INACTIVE_DATE,
       1 RANKING,
       DESCRIPTION
 from GVT_INFO.MDTB29_0X00_SERVICES where LAST_UPDATE > sysdate - 190


       NUMBER(12),
      DATE,
  INACTIVE_DT  DATE,
        NUMBER(10),
         VARCHAR2(55 BYTE)