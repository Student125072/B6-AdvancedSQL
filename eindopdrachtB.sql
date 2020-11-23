-- Eerste stored function voor het berekenen van de totale kosten
DELIMITER $$
CREATE FUNCTION berekenKosten(aantal_personen INT, prijs_per_persoon FLOAT) RETURNS DECIMAL(7,2)
BEGIN
	DECLARE kosten DECIMAL(7,2);
    SET kosten = aantal_personen * prijs_per_persoon;
    RETURN kosten;
END$$
DELIMITER ;

-- Tweede stored function voor het berekenen van het nog te betalen bedrag
DELIMITER $$
CREATE FUNCTION nogTeBetalen() RETURNS DECIMAL(7,2)
BEGIN
	DECLARE nogTeBetalen DECIMAL(7,2);
    SET nogTeBetalen = te_betalen - betaald;
	RETURN nogTeBetalen;
END$$
DELIMITER ;



-- Procedure voor een overzicht van alle klanten met de totaalprijs en het bedrag wat er nog betaald moet worden

DELIMITER $$
CREATE PROCEDURE klantenBetalingen()
BEGIN
	SELECT 
		boeking.Boekingnr, 
		Naam, 
		Telefoonnr, 
		boeking.Aantal_volwassenen, 
		reis.Prijs_per_persoon, 
		boeking.Betaald_bedrag, 
		berekenKosten(reis.Prijs_per_persoon, boeking.Aantal_volwassenen) AS totaalprijs, 
		nogTeBetalen(berekenKosten(reis.Prijs_per_persoon, boeking.Aantal_volwassenen), boeking.Betaald_bedrag) AS nog_te_betalen
	FROM klant
	INNER JOIN boeking ON klant.Klantnr = boeking.Klantnr
	INNER JOIN reis ON boeking.Reisnr = reis.Reisnr
END$$
DELIMITER ;

-- deze kan evt ook zo om alleen de klanten te zien die nog iets te betalen hebben.

DELIMITER $$
CREATE PROCEDURE klantenBetalingen()
BEGIN
	SELECT 
		boeking.Boekingnr, 
		Naam, 
		Telefoonnr, 
		boeking.Aantal_volwassenen, 
		reis.Prijs_per_persoon, 
		boeking.Betaald_bedrag, 
		berekenKosten(reis.Prijs_per_persoon, boeking.Aantal_volwassenen) AS totaalprijs, 
		nogTeBetalen(berekenKosten(reis.Prijs_per_persoon, boeking.Aantal_volwassenen), boeking.Betaald_bedrag) AS nog_te_betalen
	FROM klant
	INNER JOIN boeking ON klant.Klantnr = boeking.Klantnr
	INNER JOIN reis ON boeking.Reisnr = reis.Reisnr
	WHERE nogTeBetalen(berekenKosten(reis.Prijs_per_persoon, boeking.Aantal_volwassenen), boeking.Betaald_bedrag) > 0
END$$
DELIMITER ;