DROP TABLE IF EXISTS "trip";
CREATE TABLE IF NOT EXISTS public."trip" (
	"trip_id" SERIAL PRIMARY KEY,
	"name" VARCHAR(30) NOT NULL,
	"city" VARCHAR(25) NOT NULL,
	"per_diem" DECIMAL(8, 2) NOT NULL,
	"date_first" DATE NOT NULL,
	"date_last" DATE NOT NULL
);