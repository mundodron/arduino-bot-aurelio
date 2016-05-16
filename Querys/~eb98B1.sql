    select pd.account_no, pd.bill_period from G0009075SQL.bip_production pd where not EXISTS (select 1 from LEVANTAMENTO_SELECAO X where X.account_no = pd.account_no and X.BILL_PERIOD = pd.BILL_PERIOD) 
     union all
    select pf.account_no, pf.bill_period from G0009075SQL.bip_proforma pf where not EXISTS (select 1 from LEVANTAMENTO_SELECAO Y where Y.account_no = pf.account_no and Y.BILL_PERIOD = pf.BILL_PERIOD) ;
    
    
    
     NOT EXISTS
    (SELECT * 
     FROM Production.ProductSubcategory
     WHERE ProductSubcategoryID = 
            Production.Product.ProductSubcategoryID
        AND Name = 'Wheels')