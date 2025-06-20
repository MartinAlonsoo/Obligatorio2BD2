
db.personajes_progreso.deleteMany({});


db.personajes_progreso.insertMany([
  {
    
    
    
    "_id": "wukong@monkey.com",
    "id_personaje": 1,
    "estadisticas": {
      "enemigos_derrotados": 542, "misiones_completadas": 45, "muertes_sufridas": 12, "horas_jugadas": 112.5, "progreso_general": 85.2
    },
    "logros": [
      { "nombre_logro": "Explorador Incansable", "descripcion": "Descubriste la Cueva del Viento.", "tipo": "Exploración", "xp_otorgada": 150, "fecha_alcanzado": ISODate("2025-06-01T15:30:00Z") },
      { "nombre_logro": "Cima de la Montaña", "descripcion": "Llegaste al pico más alto.", "tipo": "Exploración", "xp_otorgada": 200, "fecha_alcanzado": ISODate("2025-06-05T11:00:00Z") },
      { "nombre_logro": "Matador de Gigantes", "descripcion": "Derrotaste al Rey Toro.", "tipo": "Jefes", "xp_otorgada": 1000, "fecha_alcanzado": ISODate("2025-06-15T20:00:00Z") }
    ]
  },
  {
    
    "_id": "tripitaka@templo.com",
    "id_personaje": 2,
    "estadisticas": {
      "enemigos_derrotados": 50, "misiones_completadas": 30, "muertes_sufridas": 5, "horas_jugadas": 90.0, "progreso_general": 70.0
    },
    "logros": [
      { "nombre_logro": "Sabiduría Ancestral", "descripcion": "Resolviste el acertijo del templo.", "tipo": "Historia", "xp_otorgada": 300, "fecha_alcanzado": ISODate("2025-06-10T10:00:00Z") }
    ]
  },
  {
    
    
    "_id": "sandy@rio.com",
    "id_personaje": 3,
    "estadisticas": {
      "enemigos_derrotados": 1250, "misiones_completadas": 10, "muertes_sufridas": 20, "horas_jugadas": 9.8, "progreso_general": 35.5
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-18T10:00:00Z") },
      { "nombre_logro": "El primer botín", "descripcion": "Recoge 10 ítems.", "tipo": "Colección", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-18T11:00:00Z") }
    ]
  },
  {
    
    
    "_id": "pigsy@granja.com",
    "id_personaje": 4,
    "estadisticas": {
      "enemigos_derrotados": 1100, "misiones_completadas": 12, "muertes_sufridas": 30, "horas_jugadas": 8.5, "progreso_general": 38.0
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-19T12:00:00Z") },
      { "nombre_logro": "Amigo Fiel", "descripcion": "Completa una misión secundaria.", "tipo": "Misiones", "xp_otorgada": 75, "fecha_alcanzado": ISODate("2025-06-19T14:00:00Z") }
    ]
  },
  {
    
    "_id": "nezha@cielo.com",
    "id_personaje": 5,
    "estadisticas": {
      "enemigos_derrotados": 2500, "misiones_completadas": 50, "muertes_sufridas": 2, "horas_jugadas": 200.0, "progreso_general": 98.0
    },
    "logros": [
      { "nombre_logro": "Deidad de la Guerra", "descripcion": "Alcanza el nivel máximo.", "tipo": "Progreso", "xp_otorgada": 5000, "fecha_alcanzado": ISODate("2025-06-01T01:00:00Z") }
    ]
  },
  {
    
    
    "_id": "baijie@nube.com",
    "id_personaje": 6,
    "estadisticas": {
      "enemigos_derrotados": 950, "misiones_completadas": 8, "muertes_sufridas": 15, "horas_jugadas": 7.2, "progreso_general": 25.0
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-20T10:00:00Z") },
      { "nombre_logro": "El primer botín", "descripcion": "Recoge 10 ítems.", "tipo": "Colección", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-20T11:00:00Z") }
    ]
  },
  {
    
    
    "_id": "sha_wujing@rio.com",
    "id_personaje": 7,
    "estadisticas": {
      "enemigos_derrotados": 900, "misiones_completadas": 9, "muertes_sufridas": 18, "horas_jugadas": 6.9, "progreso_general": 28.0
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-20T13:00:00Z") },
      { "nombre_logro": "Riqueza inicial", "descripcion": "Acumula 1000 monedas.", "tipo": "Economía", "xp_otorgada": 60, "fecha_alcanzado": ISODate("2025-06-20T14:00:00Z") }
    ]
  },
  {
    
    
    "_id": "erlang_shen@templo.com",
    "id_personaje": 8,
    "estadisticas": {
      "enemigos_derrotados": 850, "misiones_completadas": 7, "muertes_sufridas": 13, "horas_jugadas": 5.1, "progreso_general": 22.0
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-20T15:00:00Z") }
    ]
  },
  {
    
    
    "_id": "guanyin@loto.com",
    "id_personaje": 9,
    "estadisticas": {
      "enemigos_derrotados": 100, "misiones_completadas": 20, "muertes_sufridas": 1, "horas_jugadas": 55.0, "progreso_general": 59.9
    },
    "logros": [
      { "nombre_logro": "Primeros Pasos", "descripcion": "Completa el tutorial.", "tipo": "Historia", "xp_otorgada": 50, "fecha_alcanzado": ISODate("2025-06-17T15:00:00Z") }
    ]
  }
]);