-- 15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
SELECT p.Name, COUNT(pt.PlaylistId) AS "Number of Tracks"
FROM Playlist p
LEFT JOIN PlaylistTrack pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name;

-- 16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT t.Name AS "Track", a.Title AS "Album", g.Name AS "Genre", m.Name AS "Media Type"
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
JOIN Genre g ON t.GenreId = g.GenreId
ORDER BY a.Title, t.Name;

-- 17. invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.InvoiceId AS "Invoice", i.InvoiceDate, i.BillingAddress, i.BillingCity, i.BillingState, i.BillingPostalCode, i.BillingCountry, i.Total, COUNT(l.InvoiceId) AS "Line Items"
FROM Invoice i
JOIN InvoiceLine l ON i.InvoiceId = l.InvoiceId
GROUP BY i.InvoiceId;

-- 18. sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT e.FirstName || " " || e.LastName AS "Sales Agent", printf("%.2f",SUM(i.Total)) AS "Total Sales"
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId 
GROUP BY e.EmployeeId;

-- 19. top_2009_agent.sql: Which sales agent made the most in sales in 2009?
SELECT sub.agent AS "Sales Agent", MAX(sub.top) AS "Top 2009 Sales"
FROM
(SELECT e.FirstName || " " || e.LastName AS agent, SUM(i.Total) AS top 
		FROM Employee e
		JOIN Customer c ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i ON c.CustomerId = i.CustomerId
		AND i.InvoiceDate BETWEEN "2009-01-01" AND "2009-12-31"
		GROUP BY e.EmployeeId) sub;

-- 20. top_agent.sql: Which sales agent made the most in sales over all?
SELECT sub.agent AS "Sales Agent", MAX(sub.top) AS "Top 2009 Sales"
FROM
(SELECT e.FirstName || " " || e.LastName AS agent, printf("%.2f", SUM(i.Total)) AS top 
		FROM Employee e
		JOIN Customer c ON e.EmployeeId = c.SupportRepId
		JOIN Invoice i ON c.CustomerId = i.CustomerId
		GROUP BY e.EmployeeId) sub;

-- 21. sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.
SELECT e.FirstName || " " || e.LastName AS "Sales Agent", COUNT(c.SupportRepId) AS "Customer Count"
FROM Employee e 
JOIN Customer c ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

-- 22. sales_per_country.sql: Provide a query that shows the total sales per country.
SELECT i.BillingCountry AS "Country", SUM(i.Total) AS "Total Sales"
FROM Invoice i
GROUP BY i.BillingCountry;

-- 23. top_country.sql: Which country's customers spent the most?
SELECT sub.country AS "Country", MAX(sub.total) AS "Sales"
FROM 
	(SELECT i.BillingCountry AS country, SUM(i.Total) AS total
	FROM Invoice i
	GROUP BY i.BillingCountry) sub;

SELECT i.BillingCountry AS country, SUM(i.Total) AS total
	FROM Invoice i
	GROUP BY i.BillingCountry
	ORDER BY total DESC
	LIMIT 1;

-- 24. top_2013_track.sql: Provide a query that shows the most purchased track of 2013.
SELECT x.Song AS "Song" , MAX(x.Num) AS "Times Purchased"
FROM 
	(SELECT t.Name AS Song, SUM(il.Quantity) AS Num, i.InvoiceDate
		FROM Invoice i
		JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
		JOIN Track t ON il.TrackId = t.TrackId
		WHERE i.InvoiceDate BETWEEN "2013-01-01" AND "2013-12-31"
		GROUP BY t.Name) x;

-- 25. top_5_tracks.sql: Provide a query that shows the top 5 most purchased songs.
SELECT t.Name AS "Song", SUM(il.Quantity) AS "Times Purchased"
	FROM  InvoiceLine il
	JOIN Track t ON il.TrackId = t.TrackId
	GROUP BY t.Name
	ORDER BY "Times Purchased" DESC
	LIMIT 5;

-- 26. top_3_artists.sql: Provide a query that shows the top 3 best selling artists.
SELECT a.Name, SUM(il.Quantity) AS "Tracks Sold"
FROM Artist a
JOIN Album b ON b.ArtistId = a.ArtistId
JOIN Track t ON t.AlbumId = b.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY a.Name
ORDER BY "Tracks Sold" DESC
LIMIT 3;

-- 27. top_media_type.sql: Provide a query that shows the most purchased Media Type.
SELECT x.media AS "Media Type", MAX(x.num) AS "Amount of Media Sold"
	FROM 
		(SELECT m.Name AS media, SUM(il.Quantity) AS num
		FROM MediaType m
		JOIN Track t ON t.MediaTypeId = m.MediaTypeId
		JOIN InvoiceLine il ON t.TrackId = il.TrackId
		GROUP BY m.Name
		) x;
