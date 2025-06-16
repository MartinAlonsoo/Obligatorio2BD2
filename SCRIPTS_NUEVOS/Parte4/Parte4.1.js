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
      _id: "$_id", // Agrupa por el email del jugador
      cantidad_logros_exploracion: { $sum: 1 } // Suma 1 por cada logro encontrado
    }
  },
  // Etapa 4: Limpia el formato de salida
  {
    $project: {
      _id: 0, // Oculta el campo _id original
      email_jugador: "$_id", // Renombra _id a email_jugador
      cantidad: "$cantidad_logros_exploracion"
    }
  }
])