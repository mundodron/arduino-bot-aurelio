delete from file_seqs  where source_id in ('008','070','104')
and sequential_no in (2109,2025,3098)
and counter_type='G'
and DATE_ENTERED >= to_date ('30/04/2013 00:00:00','DD/MM/YYYY HH24:MI:SS');

commit;

select * from file_seqs  where source_id in ('104','341','041','399')
and sequential_no in (3025,4935,2602,2970)
and counter_type='BF'
and DATE_ENTERED >= to_date ('30/04/2013 00:00:00','DD/MM/YYYY HH24:MI:SS');

Commit;

select * from file_seqs where SEQUENTIAL_NO in (3098)