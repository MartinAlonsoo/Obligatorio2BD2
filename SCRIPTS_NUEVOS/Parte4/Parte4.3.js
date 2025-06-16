//Supuesto de que el usuario tiene que tener menos de 10horas

db.personajes_progreso.aggregate([
  // Etapa 1: Filtra personajes que han jugado 10 horas o menos
  {
    $match: {
      "estadisticas.horas_jugadas": { $lte: 10 }
    }
  },
  // Etapa 2: Descomprime el array de logros
  {
    $unwind: "$logros"
  },
  // Etapa 3: Agrupa por el nombre del logro y cuenta las ocurrencias
  {
    $group: {
      _id: "$logros.nombre_logro",
      cantidad: { $sum: 1 }
    }
  },
  // Etapa 4: Ordena por cantidad de mayor a menor
  {
    $sort: {
      cantidad: -1
    }
  },
  // Etapa 5: Limita a los 5 logros más comunes
  {
    $limit: 5
  },
  // Etapa 6: Formatea la salida
  {
    $project: {
      _id: 0,
      nombre_logro: "$_id",
      veces_obtenido: "$cantidad"
    }
  }
])