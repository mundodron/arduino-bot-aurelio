select B.ACCOUNT_NO, B.BILL_REF_NO, B.CLOSED_DATE CLOSED_DATE_C, D.CLOSED_DATE CLOSED_DATE_D, B.TOTAL_DUE
      from cmf_balance_detail d,
           cmf_balance b
      where D.BILL_REF_NO = B.BILL_REF_NO
      and D.ACCOUNT_NO = B.ACCOUNT_NO
      and D.CLOSED_DATE is not null
      and B.CLOSED_DATE is null
      and D.OPEN_ITEM_ID = 1
      and b.CHG_DATE > to_date ('01/01/2011','dd/mm/rrrr')