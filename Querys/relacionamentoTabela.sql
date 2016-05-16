-- Mostra o relacionamento entre tabela filho e tabela pai
SELECT c.owner owner_filho, c.table_name tab_filho, cc.column_name col_filho, cc.position, c.constraint_name constraint_name_filho, c.constraint_type tp_filho,
       cpai.owner owner_pai, cpai.table_name tab_pai, ccpai.column_name col_pai, cpai.constraint_name constraint_name_pai, cpai.constraint_type tp_pai
FROM   all_constraints c
join   all_cons_columns cc on cc.owner = c.owner and cc.constraint_name = c.constraint_name
join   all_constraints cpai on cpai.owner = c.r_owner and cpai.constraint_name = c.r_constraint_name
       AND cpai.table_name = 'PRODUCT_KEY' -- Nome da tabela PAI
join   all_cons_columns ccpai on ccpai.owner = cc.owner and ccpai.constraint_name = cpai.constraint_name AND cc.position = ccpai.position
WHERE  c.table_name = 'PRODUCT' -- Nome da tabela FILHO
--AND    c.owner = 'ARBOR'        -- Owner da tabela FILHO
AND    c.constraint_type = 'R'
ORDER  BY c.table_name, c.constraint_name, cc.position;
