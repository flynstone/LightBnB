SELECT properties.id, title, cost_per_night, start_date, avg(rating) FROM properties
INNER JOIN property_reviews AS reviews
ON reviews.property_id = properties.id
INNER JOIN reservations AS res
ON res.property_id = reviews.property_id
INNER JOIN users
ON reviews.guest_id = users.id
WHERE res.guest_id = 1
AND end_date < now()::date
GROUP BY properties.id, title, cost_per_night, start_date
ORDER BY start_date
LIMIT 10