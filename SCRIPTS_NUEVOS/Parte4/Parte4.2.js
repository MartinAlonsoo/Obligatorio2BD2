db.personajes_progreso.aggregate([
  // Etapa 1: Filtra personajes con progreso <= 60%
  {
    $match: {
      "estadisticas.progreso_general": { $lte: 60 } 
    }
  },
  // Etapa 2: Ordena por enemigos derrotados de mayor a menor
  {
    $sort: {
      "estadisticas.enemigos_derrotados": -1 
    }
  },
  // Etapa 3: Limita el resultado a los 5 primeros
  {
    $limit: 5
  },
  // Etapa 4: Formatea la salida para que sea clara
  {
    $project: {
      _id: 0,
      email_jugador: "$_id",
      enemigos_derrotados: "$estadisticas.enemigos_derrotados",
      progreso: "$estadisticas.progreso_general"
    }
  }
])