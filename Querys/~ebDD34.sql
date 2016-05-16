select G.external_ID, B.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT,  B.NEW_CHARGES, F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from cmf_balance B,
       gvt_rajadas_bill G,
       bmf f
 where b.account_no = G.account_no
   and b.bill_ref_no = g.bill_ref_no
   and B.ACCOUNT_NO = F.ACCOUNT_NO
   and B.BILL_REF_NO = F.orig_BILL_REF_NO
   and B.BILL_REF_RESETS = F.orig_BILL_REF_RESETS
   and F.DISTRIBUTED_AMOUNT = 0
   and g.status = 777
   and g.account_no is not null
   and new_charges in (select total_paid*-1 from cmf_balance D where d.account_no = B.account_no and bill_ref_no = 0)
   and external_id in ('999983723505','999984163901','999984214222','999984339500','999985172484','999985193362','999985332662','999985394127','999985423709','999985434763','999985614107','999985930765','999986018367','999986046521','999986122827','999986172581','999986225719','999986267525','999986283472','999986344376','999986359422','999986422942','999986499285','999986507082','999986524017','999986660848','999986677109','999986896830','999986968271','999987071276','999987108615','999987298354','999987425289','999987457121','999987622592','999988011271','999988058174','999988303442','999988419551','999988617764','999988781520','999988859757','999989187053','999989576346','999989725076','999991677385','999994977510','999995153807','999987308678','999990322378','999995153807')