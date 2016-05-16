select count(*) from rate_usage where type_id_usg in (620, 621, 623) and 
element_id in (10621,10624,10627,10630,10633,10636,10639,10642,10645,10648,10658,10661,10664,10667,10670)
and Inactive_Dt is not null

; -- Consulta deve retornar 1350 registros.

select count(*) from rate_usage where type_id_usg in (620, 621, 623) and 
element_id in (10621,10624,10627,10630,10633,10636,10639,10642,10645,10648,10658,10661,10664,10667,10670)
and Inactive_Dt is null

; -- Consulta deve retornar 2835 registros.

select count(*) from rate_usage_bands where seqnum in (
select seqnum from rate_usage where type_id_usg in (620, 621, 623) and 
element_id in (10621,10624,10627,10630,10633,10636,10639,10642,10645,10648,10658,10661,10664,10667,10670)
and Inactive_Dt is not null) -- Consulta deve retornar 1350 registros.

select count(*) from rate_usage_bands where seqnum in (
select seqnum from rate_usage where type_id_usg in (620, 621, 623) and 
element_id in (10621,10624,10627,10630,10633,10636,10639,10642,10645,10648,10658,10661,10664,10667,10670)
and Inactive_Dt is null) -- Consulta deve retornar 2835 registros.