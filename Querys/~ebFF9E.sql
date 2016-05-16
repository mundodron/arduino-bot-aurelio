 select *
  from sincronismo_siebel_kenan_view
 where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5)