/* Streaming table functions are used when stream data directly from on transformation to the next without the need for 
intermediate staging. This techique is most often used in data warehouses. */

-- usage
INSERT INTO tickers
SELECT * FROM TABLE (doubled(CURSOR(SELECT * FROM stocks)));


-- implementation
TYPE stocks_rc IS REF CURSOR RETURN stocks%ROWTYPE;