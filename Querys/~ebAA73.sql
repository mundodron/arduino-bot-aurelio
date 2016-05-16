SELECT DISTINCT EIAM.EXTERNAL_ID
  FROM EXTERNAL_ID_ACCT_MAP EIAM ,
       EXTERNAL_ID_EQUIP_MAP EIEM
  WHERE EIAM.ACCOUNT_NO       = EIEM.ACCOUNT_NO
    AND EIAM.EXTERNAL_ID_TYPE = 1
    AND EIAM.SERVER_ID        = EIEM.SERVER_ID
    AND EIEM.EXTERNAL_ID_TYPE = 1
    AND EIEM.INACTIVE_DATE   IS NULL
    AND EIAM.EXTERNAL_ID     IN ('999982715012' ,'999984520596' ,'999984420014' ,'777777713675' ,'999981400669' ,'999981062354' ,'777777751182');
