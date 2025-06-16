SELECT j1.nombre, j1.email
FROM JUGADOR j1, PERSONAJE p1
WHERE j1.email = p1.email_Jugador
AND EXTRACT(YEAR FROM j1.fecha_registro) = 2024 -- verifica que el año sea 2024
AND j1.nombreRegion = 'AMERICA' -- verifica que la region sea AMERICA
AND p1.especie != 'Humano' -- verifica que la especie sea Humano
AND p1.agilidad >= 50 -- verifica que la agilidad sea mayor a 50
AND p1.resistencia >= 50 -- verifica que la resistencia sea mayor a 50
AND j1.email IN (SELECT p2.EMAIL_JUGADOR
                 FROM HABILIDADES h, Personaje_Posee_Habilidades pph, Personaje p2
                 WHERE p2.EMAIL_JUGADOR = pph.emailJugador
                 AND pph.NOMBREHABILIDAD = h.NOMBRE
                 AND h.CLASIFICACION = 'Magia'
                ) -- verifica que el personaje tenga habilidades de magia
AND j1.email IN (SELECT p3.EMAIL_JUGADOR
                  FROM ITEMS it, Personaje_Posee_Items ppi, Item_Reliquia ir, Personaje p3
                  WhERE p3.EMAIL_JUGADOR = ppi.emailJugador
                  AND ppi.NOMBREITEM = it.NOMBRE
                  AND it.RAREZA = 'Legendaria'
                  AND ir.nombre = it.NOMBRE
                 ); -- verifica que el personaje item reliquia que sea legendario

Select * 
FROM JUGADOR j1, PERSONAJE p1
WHERE j1.email = p1.email_Jugador;
