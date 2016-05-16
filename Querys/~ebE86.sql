select D.BILLING_LEVEL from bill_invoice_detail d

group_by D.BILLING_LEVEL

select * from bill_invoice_detail 

Select SUBTYPE_CODE from g0010388sql.vrc_cdr_cob_zerado_2 group by SUBTYPE_CODE

update bill_invoice_detail bill set bill.SUBTYPE_CODE = 9666 where bill.account_no in  

Select * from g0010388sql.vrc_cdr_cob_zerado_2

Select count(distinct bill_ref_no) from g0010388sql.vrc_cdr_cob_zerado_2

select count(*) 
  from bill_invoice_detail
 where bill_ref_no in (Select bill_ref_no from g0010388sql.vrc_cdr_cob_zerado_2)
   and OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE = 7
   and AMOUNT = 0

Select account_no from g0010388sql.vrc_cdr_cob_zerado_2 order by 1 desc

select account_no from cmf where account_category in (9) and account_no in (10955323,10937401,10928595,10925457,10925457,10924482,10876563,10870160,10865552,10847884,10847884,10844354,10843781,10842154,10842154,10826867,10826042,10820397,10819942,10818504,10805595,10779430,10761895,10750734,10750734,10750734,10750734,10750109,10740667,10740667,10732304,10731691,10730057,10719200,10716931,10716931,10703266,10699238,10699238,10699238,10699238,10699238,10696213,10694574,10670595,10667431,10665588,10661092,10645718,10634111,10633444,10621920,10616348,10609791,10601915,10601915,10601915,10601915,10601915,10599707,10578440,10547692,10547692,10542704,10541035,10538415,10532292,10512436,10512436,10512039,10510689,10507863,10500509,10498374,10496913,10493001,10488961,10473025,10458393,10458393,10452969,10447203,10438358,10434441,10417456,10403973,10398066,10395280,10384206,10383503,10380279,10377238,10375838,10375838,10352076,10346015,10329468,10329468,10329468,10329468,10325671) order by 1 desc


select * from customer_id_acct_map where account_no = 4875008

select * from ARBORGVT_BILLING.GVT_CONTA_INTERNET where bill_ref_no in (Select bill_ref_no from g0010388sql.vrc_cdr_cob_zerado_2)


select * from 


BILL_INVOICE_DETAIL_BK

select * from customer_care where numero_fatura = '314665225'

select * from bill_invoice where bill_ref_no = 314665225

