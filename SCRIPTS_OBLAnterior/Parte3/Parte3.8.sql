-- Consulta para listar todos los índices generados por Oracle para las tablas
WITH idx AS (
  SELECT 
    ui.table_name,
    ui.index_name,
    ui.index_type,
    ui.uniqueness,
    uc.constraint_type,
    uic.column_name
  FROM user_indexes ui
  LEFT JOIN user_constraints uc
    ON ui.index_name = uc.index_name
  JOIN user_ind_columns uic
    ON ui.index_name = uic.index_name
  WHERE ui.table_name IN (
    -- Lista de todas las tablas a buscar indice
    'JUGADOR','PERSONAJE','HABILIDADES','ENEMIGO','ENEMIGONORMAL',
    'ENEMIGOELITE','ENEMIGOJEFE','ZONA','RECOMPENSA','MISIONES',
    'ITEMS','CARACTERISTICAAFECTADA','ITEM_ARMA','ITEM_ARMADURA',
    'ITEM_CONSUMIBLE','ITEM_MATERIAL','ITEM_RELIQUIA','MAPA',
    'PERSONAJE_POSEE_HABILIDADES','PERSONAJE_POSEE_ITEMS',
    'JEFE_TIENE_HABILIDADES','ENEMIGO_HABITA_EN_ZONA',
    'JEFE_APARECE_EN_MISION','ENEMIGO_DEJA_RECOMPENSA',
    'MISION_DA_RECOMPENSA','RECOMPENSA_POSEE_ITEM',
    'MISION_ES_PREVIA_DE_MISION','MISION_ES_PREVIA_DE_ZONA', 'Mision_Es_Previa_De_Habilidad'
  )
)
SELECT
  table_name,
  index_name,
  column_name,
  index_type        AS oracle_type,
  uniqueness,
  constraint_type,
  CASE
    WHEN constraint_type = 'P' THEN 'Índice primario (no denso)'
    WHEN constraint_type = 'U' THEN 'Índice secundario por clave (denso)'
    WHEN uniqueness = 'NONUNIQUE' THEN 'Índice secundario por no clave (denso)'
    ELSE 'Otro'
  END AS clasificacion
FROM idx
ORDER BY table_name, index_name, column_name;