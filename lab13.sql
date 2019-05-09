-- LABORATORIO 13
-- Kevin Macario 17369
-- Esteban Cabrera 17781

-- PARTE 1

-- INCISO A
SELECT * 
FROM d_date

-- INCISO B
SELECT * 
FROM invoiceline il
	INNER JOIN invoice i ON i.invoiceid = il.invoiceid
	INNER JOIN d_date s ON s.date_actual = i.invoicedate;

-- INCISO C
DROP MATERIALIZED VIEW ventas;
CREATE MATERIALIZED VIEW ventas AS
	SELECT i.billingcountry, i.billingcity, s.year_actual, s.quarter_actual, s.month_actual, s.week_of_year, ge.name AS genre, mt.name AS type, SUM(il.quantity * il.unitprice) as montoVenta
	FROM invoice i
		INNER JOIN invoiceline il ON i.invoiceid = il.invoiceid
		INNER JOIN d_date s ON s.date_actual = i.invoicedate
		INNER JOIN track tr ON tr.trackid = il.trackid
		INNER JOIN mediatype mt ON mt.mediatypeid = tr.mediatypeid
		INNER JOIN genre ge ON ge.genreid = tr.genreid
	GROUP BY CUBE(i.billingcountry, i.billingcity, s.year_actual, s.quarter_actual, s.month_actual, s.week_of_year, ge.name, mt.name);
		
SELECT *
FROM ventas

-- INCISO D
-- Ejercicio 1
SELECT ventas.type, ventas.montoventa
FROM ventas
WHERE ventas.type IS NOT null
ORDER BY ventas.montoventa DESC
LIMIT 1;

-- Ejercicio 2
SELECT ventas.genre, ventas.year_actual, ventas.montoventa
FROM ventas
WHERE ventas.genre IS NOT null and ventas.year_actual = 2013
ORDER BY ventas.montoventa DESC
LIMIT 1;

-- Ejercicio 3
SELECT ventas.year_actual, ventas.week_of_year, ventas.montoventa
FROM ventas
WHERE ventas.week_of_year IS NOT null AND ventas.year_actual = 2012 AND ventas.billingcountry IS null AND ventas.billingcity IS null AND ventas.quarter_actual IS null AND ventas.month_actual IS null AND ventas.genre IS null AND ventas.type IS null
ORDER BY week_of_year ASC;

-- Ejercicio 4
SELECT ventas.quarter_actual, ventas.montoventa
FROM ventas
WHERE ventas.quarter_actual IS NOT null
ORDER BY ventas.montoventa DESC
LIMIT 1;

-- Ejercicio 5	

-- SLICE
SELECT ventas.billingcountry, SUM(ventas.montoventa) as 
MontoResultante
FROM ventas
WHERE ventas.billingcountry IS NOT null
GROUP BY ventas.billingcountry
ORDER BY MontoResultante, ventas.billingcountry ASC;

-- ROLL-UP
SELECT ventas.billingcountry, SUM(ventas.montoventa) as MontoResultante
FROM ventas
WHERE ventas.billingcountry IS NOT null 
GROUP BY ROLLUP(ventas.billingcountry)
ORDER BY MontoResultante, ventas.billingcountry ASC;

-- En opinion personal se deberian de enfocar 
-- las ventas en donde han sido poco el monto resultante
-- Los siguientes paises han tenido el mismo monto:
-- Australia, Argentina, Belgica, Polonia, Dinamarca, Italia,  y España.

