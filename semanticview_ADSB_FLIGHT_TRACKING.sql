create or replace semantic view DEMO.DEMO.ADSB_FLIGHT_TRACKING
	tables (
		DEMO.DEMO.ADSB primary key (UUID) comment='ADS-B flight tracking data with real-time aircraft positions and telemetry'
	)
	facts (
		ADSB.ALTITUDE_BAROMETRIC as TRY_CAST(ALTBARO AS NUMBER),
		ADSB.ALTITUDE_GEOMETRIC as TRY_CAST(ALTGEOM AS NUMBER),
		ADSB.GROUND_SPEED as TRY_CAST(GS AS NUMBER) comment='Ground speed in knots',
		ADSB.LATITUDE_VALUE as TRY_CAST(LATITUDE AS NUMBER) comment='Latitude coordinate',
		ADSB.LONGITUDE_VALUE as TRY_CAST(LONGITUDE AS NUMBER) comment='Longitude coordinate',
		ADSB.MESSAGE_COUNT as TRY_CAST(MESSAGES AS NUMBER) comment='Number of messages received',
		ADSB.RSSI_VALUE as TRY_CAST(RSSI AS NUMBER) comment='Received signal strength indicator',
		ADSB.TRACK_ANGLE as TRY_CAST(TRACK AS NUMBER) comment='Track angle in degrees',
		ADSB.VERTICAL_RATE as TRY_CAST(BARORATE AS NUMBER) comment='Barometric vertical rate'
	)
	dimensions (
		ADSB.AIRCRAFT_CATEGORY as CATEGORY with synonyms=('category','aircraft type') comment='Aircraft category code',
		ADSB.EMERGENCY_STATUS as EMERGENCY with synonyms=('emergency') comment='Emergency status indicator',
		ADSB.FLIGHT_NUMBER as TRIM(FLIGHT) with synonyms=('flight','flight id','callsign') comment='Flight number or callsign',
		ADSB.PLANE_IDENTIFIER as PLANEID with synonyms=('aircraft id','plane id','icao address') comment='Aircraft identifier (ICAO address)',
		ADSB.SQUAWK_CODE as SQUAWK with synonyms=('transponder code') comment='Squawk transponder code',
		ADSB.TIMESTAMP as TRY_CAST(TS AS TIMESTAMP) with synonyms=('time','timestamp','observation time') comment='Timestamp of the observation'
	)
	metrics (
		ADSB.AVG_ALTITUDE as AVG(TRY_CAST(ALTBARO AS NUMBER)) comment='Average barometric altitude',
		ADSB.AVG_GROUND_SPEED as AVG(TRY_CAST(GS AS NUMBER)) comment='Average ground speed in knots',
		ADSB.MAX_ALTITUDE as MAX(TRY_CAST(ALTBARO AS NUMBER)) comment='Maximum altitude observed',
		ADSB.TOTAL_AIRCRAFT as COUNT(DISTINCT PLANEID) comment='Total number of distinct aircraft',
		ADSB.TOTAL_FLIGHTS as COUNT(DISTINCT TRIM(FLIGHT)) comment='Total number of distinct flights',
		ADSB.TOTAL_OBSERVATIONS as COUNT(*) comment='Total number of observations'
	)
	comment='Semantic view for ADS-B flight tracking analysis';
