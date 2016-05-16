  select trunc(DATA_MOVIMENTO), count(1)
    from gvt_bankslip
   where status = 'B'
   group by trunc(DATA_MOVIMENTO)
   order by trunc(DATA_MOVIMENTO) desc;
   
   
   2122
   1937
   4059