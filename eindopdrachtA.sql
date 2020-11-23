DELIMITER $$
CREATE PROCEDURE boekingenKlant()
BEGIN
	SELECT BoekingNr, klant.Naam, klant.Telefoonnr, reis.Bestemmingcode, bestemming.Land,
	bestemming.Plaats, reis.Vertrekdatum, reis.Aantal_dagen, Aantal_volwassenen, Aantal_kids
	FROM boeking
	INNER JOIN klant ON boeking.Klantnr = klant.Klantnr
	INNER JOIN reis ON boeking.Reisnr = reis.Reisnr
	INNER JOIN bestemming ON reis.Bestemmingcode = bestemming.Bestemmingcode
END$$
DELIMITER ;


START TRANSACTION;
	SAVEPOINT save1;
	
	UPDATE boeking SET Aantal_volwassenen=4 WHERE BoekingNr=1;
	CALL boekingenKlant();
	
	SAVEPOINT save2;
	ROLLBACK TO save1;
	CALL boekingenKlant();
	
COMMIT;

-- In deze transaction doe ik eerst een update, vervolgens roep ik boekingenKlant() aan om te checken of de update uitgevoerd is. 
-- Daarna doe ik een rollback naar het eerste SAVEPOINT zodat alle wijzigingen ongedaan gemaakt worden. 
-- Nogmaals roep ik de procedure aan om te laten zien dat alle wijzigingen weer ongedaan gemaakt zijn.