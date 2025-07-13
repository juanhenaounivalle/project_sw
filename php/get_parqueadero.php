<?php
// php/get_parqueadero.php
header('Content-Type: application/json');

$parqueadero_id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$parqueadero_id) {
    echo json_encode(['error' => 'ID de parqueadero inválido']);
    exit;
}

require __DIR__ . '/conexion.php';

// 1. Obtener nombre del parqueadero
$res_nombre = pg_query_params($conexion, "SELECT nombre FROM parqueaderos WHERE id = $1", [$parqueadero_id]);
$nombre = pg_fetch_result($res_nombre, 0, 'nombre') ?? 'No encontrado';

// 2. Obtener la información detallada (tarifa y capacidad)
$sql_info = "SELECT tipo_vehiculo, tarifa, capacidad FROM informacion_parqueadero WHERE parqueadero_id = $1";
$res_info = pg_query_params($conexion, $sql_info, [$parqueadero_id]);
$info_detallada = pg_fetch_all($res_info) ?: [];

// 3. Obtener la ocupación actual por tipo de vehículo
$sql_ocupados = "SELECT tipo_vehiculo, COUNT(*) as ocupados 
                 FROM movimientos 
                 WHERE parqueadero_id = $1 AND salida IS NULL 
                 GROUP BY tipo_vehiculo";
$res_ocupados = pg_query_params($conexion, $sql_ocupados, [$parqueadero_id]);
$ocupacion_actual = pg_fetch_all($res_ocupados) ?: [];

// Unimos los datos para un resultado completo
$aforo_final = [];
foreach ($info_detallada as $info) {
    $tipo = $info['tipo_vehiculo'];
    $ocupados_count = 0;
    foreach ($ocupacion_actual as $ocupado) {
        if ($ocupado['tipo_vehiculo'] === $tipo) {
            $ocupados_count = $ocupado['ocupados'];
            break;
        }
    }
    $aforo_final[$tipo] = [
        'tarifa' => (float) $info['tarifa'],
        'capacidad' => (int) $info['capacidad'],
        'ocupados' => (int) $ocupados_count
    ];
}

$respuesta = [
    'nombre' => $nombre,
    'aforo_detallado' => $aforo_final
];

echo json_encode($respuesta);
exit;