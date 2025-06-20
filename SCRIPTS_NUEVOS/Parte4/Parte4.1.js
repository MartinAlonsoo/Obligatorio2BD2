db.personajes_progreso.aggregate([
  // Etapa 1: Descomprime el array 'logros'
  {
    $unwind: "$logros"
  },
  // Etapa 2: Filtra para quedarse solo con los logros de tipo 'Exploración'
  {
    $match: {
      "logros.tipo": "Exploración"
    }
  },
  // Etapa 3: Agrupa por el ID del personaje y cuenta los logros
  {
    $group: {
      _id: "$_id", 
      cantidad_logros_exploracion: { $sum: 1 } 
    }
  },
  // Etapa 4: Limpia el formato de salida
  {
    $project: {
      _id: 0, 
      email_jugador: "$_id", 
      cantidad: "$cantidad_logros_exploracion"
    }
  }
])