select * from rate_usage where seqnum in (96075978,96075979,96075980,96075981,96075982,96075983,96075984,96075985,96075986,96075987,96075988,96075989,96075990,96075991,96075992,96075993,96075994,96075995,96075996,96075997,96075998,96075999,96076000,96076001,96076002,96076003,96076004,96076005,96076006,96076007,96076008,96076009,96076010,96076011,96076012,96076013,96076014,96076015,96076016,96076017)

select * from rate_usage_bands where seqnum in (
select seqnum
from rate_usage ru1
where ru1.element_id = 11027
and ru1.type_id_usg = 280
and ru1.inactive_dt = '06/07/2015')

