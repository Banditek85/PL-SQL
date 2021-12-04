CREATE TABLE stocks(
ticker      VARCHAR2(20),
trade_date  DATE,
open_price  NUMBER,
close_price NUMBER);
/

INSERT INTO stocks
SELECT 'stk' || LEVEL,
    sysdate,
    LEVEL,
    LEVEL + 15
    FROM dual
CONNECT BY LEVEL <= 100;
/

-- Object type is needed to be able to return nested table of this type to SQL (cannot use %ROWTYPE in SQL as
-- this attribute is available only in PL/SQL )
CREATE TYPE ticker_ot AUTHID DEFINER IS OBJECT
(
    ticker     VARCHAR2(20),
    pricedate  DATE,
    pricetype  VARCHAR2(1),
    price      NUMBER
);

-- Nested table of above objects type
CREATE TYPE tickers_nt IS TABLE OF ticker_ot;


CREATE OR REPLACE PACKAGE stock_mgr
AUTHID DEFINER
AS
-- strong ref cursor type of the same structure like table function returns
    TYPE stocks_rc IS REF CURSOR RETURN stocks%ROWTYPE;
END stock_mgr;


-- Traditional (non-pipelined) table function
CREATE OR REPLACE FUNCTION non_pipelined(p_rows_in STOCK_MGR.STOCKS_RC)
RETURN tickers_nt
AS
    v_doubled tickers_nt := tickers_nt();
BEGIN
    v_doubled.EXTEND();
    v_doubled(v_doubled.LAST) := new ticker_ot('ticker1', sysdate, 'O', 500);
    RETURN v_doubled;
END;