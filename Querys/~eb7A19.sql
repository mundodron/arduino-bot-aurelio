select bank_id, max(seq_numb)
  from file_seqs 
group by bank_id

select * from file_seqs where source_id = 904 order by 4 desc