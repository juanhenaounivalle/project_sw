<?php
// php/get_parqueaderos.php
header('Content-Type: application/json');
require __DIR__ . '/conexion.php';

$lng = filter_input(INPUT_GET, 'lng', FILTER_VALIDATE_FLOAT);
$lat = filter_input(INPUT_GET, 'lat', FILTER_VALIDATE_FLOAT);

if ($lng === false || $lat === false) {
    http_response_code(400);
    echo json_encode(['error' => 'Coordenadas inválidas.']);
    exit;
}

try {
    // ✅ CONSULTA TOTALMENTE REESCRITA CON SUBCONSULTAS PARA MAYOR ROBUSTEZ
    $sql = "
        WITH ranked_parqueaderos AS (
            SELECT
                p.id,
                p.nombre,
                p.geom,
                ST_Distance(p.geom, ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography) as distancia
            FROM 
                parqueaderos p
            ORDER BY
                distancia ASC
            LIMIT 20
        )
        SELECT 
            rp.id, 
            rp.nombre, 
            ST_X(rp.geom) as lng, 
            ST_Y(rp.geom) as lat,
            rp.distancia,
            (
                SELECT json_agg(json_build_object('tipo', ip.tipo_vehiculo, 'tarifa', ip.tarifa))
                FROM informacion_parqueadero ip
                WHERE ip.parqueadero_id = rp.id AND ip.tarifa IS NOT NULL AND ip.tarifa > 0
            ) as tarifas,
            (
                SELECT json_agg(t.*) 
                FROM (
                    SELECT hp.dia_semana as dia, hp.horario_apertura as apertura, hp.horario_cierre as cierre
                    FROM horarios_parqueadero hp
                    WHERE hp.parqueadero_id = rp.id
                    ORDER BY
                        CASE hp.dia_semana
                            WHEN 'Lunes' THEN 1 WHEN 'Martes' THEN 2 WHEN 'Miércoles' THEN 3
                            WHEN 'Jueves' THEN 4 WHEN 'Viernes' THEN 5 WHEN 'Sábado' THEN 6
                            WHEN 'Domingo' THEN 7 ELSE 8
                        END
                ) t
            ) as horarios
        FROM 
            ranked_parqueaderos rp
        ORDER BY
            rp.distancia ASC
    ";

    $result = pg_query_params($conexion, $sql, [$lng, $lat]);
    
    if (!$result) {
        throw new Exception(pg_last_error($conexion));
    }

    $parqueaderos = pg_fetch_all($result) ?: [];

    echo json_encode($parqueaderos);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor.', 'details' => $e->getMessage()]);
}