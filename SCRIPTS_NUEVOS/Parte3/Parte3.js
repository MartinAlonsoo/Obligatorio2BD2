//Ejemplo de inserción de un personaje con progreso en MongoDB
db.personajes_progreso.insertOne({
  "_id": "wukong@monkey.com",
  "id_personaje": 1,
  "estadisticas": {
    "enemigos_derrotados": 542,
    "misiones_completadas": 45,
    "muertes_sufridas": 12,
    "horas_jugadas": 112.5,
    "progreso_general": 85.2
  },
  "logros": [
    {
      "nombre_logro": "Despertar del Héroe",
      "descripcion": "Completaste la misión 'Inicio del Viaje'.",
      "tipo": "Historia",
      "xp_otorgada": 100,
      "fecha_alcanzado": ISODate("2025-05-27T10:00:00Z")
    },
    {
      "nombre_logro": "Explorador Incansable",
      "descripcion": "Descubriste la Cueva del Viento.",
      "tipo": "Exploración",
      "xp_otorgada": 150,
      "fecha_alcanzado": ISODate("2025-06-01T15:30:00Z")
    }
  ]
});