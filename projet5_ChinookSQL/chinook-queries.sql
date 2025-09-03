-- 1. Non-American customers
-- Selects all customers whose country is not the USA
-- Concatenates first and last name to get the full name
SELECT "CustomerId",
       "FirstName" || ' ' || "LastName" AS "Fullname",
       "Country"
FROM "Customer"
WHERE "Country" != "USA";

-- 2. Brazilian customers
-- Selects all customers located in Brazil
-- Concatenates first and last name for the full name
SELECT "CustomerId",
       "FirstName" || ' ' || "LastName" AS "Fullname",
       "Country"
FROM "Customer"
WHERE "Country" = "Brazil";

-- 3. Sales agents
-- Retrieves all employees with the title "Sales Support Agent"
-- Useful to identify sales representatives
SELECT "CustomerId",
       "FirstName" || ' ' || "LastName" AS "Fullname",
       "Country"
FROM "Employee"
WHERE "Title" = "Sales Support Agent";

-- 4. Invoices from Brazilian customers
-- Retrieves invoices for customers from Brazil
-- Joins Invoice and Customer tables to get the full customer name
SELECT i."InvoiceId",
       i."InvoiceDate",
       i."BillingCountry",
       c."FirstName" || ' ' || c."LastName" AS "Customer",
       i."Total"
FROM "Invoice" i
JOIN "Customer" c ON i."CustomerId" = c."CustomerId"
WHERE i."BillingCountry" = "Brazil";

-- 5. Unique countries in the invoices
-- Lists all distinct billing countries from invoices
SELECT DISTINCT "BillingCountry" AS "Unique Country"
FROM "Invoice";

-- 6. Invoice details per customer
-- Calculates total sales per customer by summing invoice totals
-- Groups results by customer name
SELECT c."FirstName" || ' ' || c."LastName" AS "Fullname Customer",
       SUM(i."Total") AS "Total Amount",
       c."Country"
FROM "Invoice" i
JOIN "Customer" c ON i."CustomerId" = c."CustomerId"
GROUP BY c."FirstName", c."LastName";

-- 7. Sales by year
-- Aggregates invoices by year
-- Counts number of invoices and sums total sales per year
SELECT strftime('%Y', "InvoiceDate") AS "Year",
       COUNT(*) AS "Number of Invoices",
       SUM("Total") AS "Annual Total"
FROM "Invoice"
GROUP BY strftime('%Y', "InvoiceDate");

-- 8. Items per invoice
-- Counts the number of tracks/items in each invoice
SELECT "InvoiceId" AS "Invoice",
       COUNT("TrackId") AS "Number"
FROM "InvoiceLine"
GROUP BY "InvoiceId";

-- 9. Articles per invoice (with track info)
-- Lists each track associated with an invoice along with its composer
SELECT i."InvoiceId" AS "Invoice",
       t."Composer",
       t."Name" AS "Track"
FROM "InvoiceLine" i
JOIN "Track" t ON i."TrackId" = t."TrackId";

-- 10. Number of invoices by country
-- Counts how many invoices come from each billing country
SELECT "BillingCountry",
       COUNT(*) AS "Number of Invoices"
FROM "Invoice"
GROUP BY "BillingCountry";

-- 11. Playlists: number of tracks
-- Counts how many tracks are in each playlist
SELECT "PlaylistId",
       COUNT("TrackId") AS "Number of Tracks"
FROM "PlaylistTrack"
GROUP BY "PlaylistId";

-- 12. Track details with album, media type, and genre
-- Joins Track with Album, MediaType, and Genre tables to get full track info
SELECT t."Name" AS "Track",
       a."Title" AS "Album",
       m."Name" AS "Media Type",
       g."Name" AS "Genre"
FROM "Track" AS t
JOIN "Album"     AS a ON t."AlbumId"     = a."AlbumId"
JOIN "MediaType" AS m ON t."MediaTypeId" = m."MediaTypeId"
JOIN "Genre"     AS g ON t."GenreId"     = g."GenreId";

-- 13. Number of tracks per invoice
-- Counts the tracks for each invoice
SELECT "InvoiceId", COUNT("TrackId")
FROM "InvoiceLine"
GROUP BY "InvoiceId";

-- 14. Number of invoices per country
-- Counts invoices grouped by billing country
SELECT "BillingCountry", COUNT(*)
FROM "Invoice"
GROUP BY "BillingCountry";

-- 15. Most sold track in 2013
-- Sums quantities sold per track in 2013 and orders by highest quantity
SELECT SUM(il."Quantity") AS "Quantity",
       t."Name" AS "Track Name",
       strftime('%Y', i."InvoiceDate") AS "Year"
FROM "InvoiceLine" AS il
JOIN "Track" AS t ON t."TrackId" = il."TrackId"
JOIN "Invoice" AS i ON i."InvoiceId" = il."InvoiceId"
WHERE strftime('%Y', i."InvoiceDate") = "2013"
GROUP BY t."Name", strftime('%Y', i."InvoiceDate")
ORDER BY SUM(il."Quantity") DESC
LIMIT 1;

-- 16. Top 5 tracks by quantity sold
-- Aggregates total quantity per track and composer, then orders by quantity descending
SELECT SUM(il."Quantity") AS "Quantity",
       t."Name" AS "Track Name",
       t."Composer" AS "Artist"
FROM "InvoiceLine" AS il
JOIN "Track" AS t ON t."TrackId" = il."TrackId"
JOIN "Invoice" AS i ON i."InvoiceId" = il."InvoiceId"
GROUP BY t."Name", t."Composer"
ORDER BY SUM(il."Quantity") DESC
LIMIT 5;

-- 17. Top 4 artists by quantity sold
-- Aggregates quantity sold per composer and orders descending
SELECT SUM(il."Quantity") AS "Quantity",
       t."Composer" AS "Artist"
FROM "InvoiceLine" AS il
JOIN "Track" AS t ON t."TrackId" = il."TrackId"
JOIN "Invoice" AS i ON i."InvoiceId" = il."InvoiceId"
GROUP BY t."Composer"
ORDER BY SUM(il."Quantity") DESC
LIMIT 4;

-- 18. Top 4 media types by quantity sold
-- Aggregates quantity sold per media type (joined through tracks)
-- Note: grouping by composer might be a mistake if we want media type totals
SELECT SUM(il."Quantity") AS "Quantity",
       m."Name" AS "Media"
FROM "InvoiceLine" AS il
JOIN "Track" AS t ON t."TrackId" = il."TrackId"
JOIN "MediaType" AS m ON m."MediaTypeId" = t."MediaTypeId"
JOIN "Invoice" AS i ON i."InvoiceId" = il."InvoiceId"
GROUP BY t."Composer"
ORDER BY SUM(il."Quantity") DESC
LIMIT 4;
