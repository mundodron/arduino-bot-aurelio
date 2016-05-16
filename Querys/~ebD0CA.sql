select * from gvt_rajadas where account_no is not null and status in (2,77)

select * from G0200933SQL.GVT_TEMP_PL0300_LANCTOS_RM5

select TMP_account_no, tmp_conta_contabil, tmp_valor_lancamento, tmp_tipo_lancamento, count(*) from G0200933SQL.GVT_TEMP_PL0300_LANCTOS_RM5 where TMP_COD_BANCO = 8 group by TMP_account_no, tmp_conta_contabil, tmp_valor_lancamento, tmp_tipo_lancamento order by 5 desc


select * from bmf where tracking_id in (62810977,62810978,62810979)




select sum (valor) from gvt_rajadas where account_no is not null and status = 1


select '555',m5.* /*sum (tmp_valor_lancamento)*/ from G0200933SQL.GVT_TEMP_PL0300_LANCTOS_RM555 M5 where M5.TMP_EXTERNAL_ID in (select external_id from G0023421sql.gvt_rajadas where account_no is not null and status = 1)
and M5.TMP_TIPO_LANCAMENTO = 'C' and m5.TMP_BMF_TRANS_TYPE = 90 and tmp_external_id = 999983661852
union
select '5', m5.* /*sum (tmp_valor_lancamento)*/ from G0200933SQL.GVT_TEMP_PL0300_LANCTOS_RM5 M5 where M5.TMP_EXTERNAL_ID in (select external_id from G0023421sql.gvt_rajadas where account_no is not null and status = 1)
and M5.TMP_TIPO_LANCAMENTO = 'C' and m5.TMP_BMF_TRANS_TYPE = 90 and tmp_external_id = 999983661852

select * from all_tables where table_name like '%DACC%' 


select s
  from G0200933SQL.GVT_TEMP_PL0300_LANCTOS_RM5 M5,
       gvt_rajadas R
 where M5.TMP_EXTERNAL_ID = r.external_id
  and  r.account_no is not null
   and r.status = 1
  
  
  16348944
  16411570
  
  
  

 
 
select * from gvt_rajadas_bill

