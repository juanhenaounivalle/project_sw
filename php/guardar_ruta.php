<?php
// php/guardar_ruta.php
session_start();
require __DIR__ . '/conexion.php';

// Solo usuarios logueados pueden guardar rutas
if (!isset($_SESSION['user_id'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Debes iniciar sesión para guardar una ruta.']);
    exit;
}

// Recibir los datos en formato JSON desde el frontend
$json_data = file_get_contents('php://input');
$data = json_decode($json_data);

$nombre_ruta = !empty($data->nombre) ? trim(pg_escape_string($conexion, $data->nombre)) : "Ruta sin nombre";
$wkt_ruta = trim(pg_escape_string($conexion, $data->wkt ?? ''));
$id_usuario = $_SESSION['user_id'];

if (empty($wkt_ruta)) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos de la ruta inválidos.']);
    exit;
}

try {
    // Usamos ST_GeomFromText para convertir el formato WKT a tipo GEOMETRY de PostGIS
    $sql = "INSERT INTO rutas (id_usuario, nombre, geom) VALUES ($1, $2, ST_GeomFromText($3, 4326))";
    $result = pg_query_params($conexion, $sql, [$id_usuario, $nombre_ruta, $wkt_ruta]);

    if ($result) {
        header('Content-Type: application/json');
        echo json_encode(['success' => 'Ruta guardada exitosamente.']);
    } else {
        throw new Exception('No se pudo guardar la ruta en la base de datos.');
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}