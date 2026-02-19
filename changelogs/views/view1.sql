CREATE OR REPLACE VIEW v_cars_summary AS
SELECT
    car_id,
    make,
    model,
    model_year,
    body_type,
    color,
    mileage,
    price,
    CASE
        WHEN mileage < 20000 THEN 'LOW'
        WHEN mileage BETWEEN 20000 AND 80000 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS mileage_category,
    EXTRACT(YEAR FROM SYSTIMESTAMP) - model_year AS vehicle_age_years,
    created_at
FROM cars;