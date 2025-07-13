<?php
// php/guardar_parqueadero.php

session_start();

// 1. Validaciones de seguridad y de método
if (!isset($_SESSION['user_id']) || $_SESSION['rol'] !== 'admin') {
    header("Location: ../login.php?error=unauthorized");
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../register-parqueadero.php');
    exit;
}

require __DIR__ . '/conexion.php';

// 2. Inicia una transacción para asegurar atomicidad
pg_query($conexion, "BEGIN");

try {
    // 3. Recogemos datos básicos y saneamos
    $nombre = trim(pg_escape_string($conexion, $_POST['nombre'] ?? ''));
    $geom = trim($_POST['geom'] ?? '');
    $direccion = trim(pg_escape_string($conexion, $_POST['direccion'] ?? ''));
    $barrio_nombre = trim(pg_escape_string($conexion, $_POST['barrio'] ?? ''));
    $telefono = trim(pg_escape_string($conexion, $_POST['telefono'] ?? ''));
    $imgUrl = trim(pg_escape_string($conexion, $_POST['imagenes'] ?? ''));

    // 4. Lógica de subida de la imagen
    $contactoImagenPath = null;
    if (isset($_FILES['contacto_imagen']) && $_FILES['contacto_imagen']['error'] === UPLOAD_ERR_OK) {
        $uploadsDir = __DIR__ . '/../assets/uploads/';
        if (!is_dir($uploadsDir)) {
            mkdir($uploadsDir, 0775, true);
        }
        $safeName = time() . "_" . preg_replace('/[^a-zA-Z0-9_\.-]/', '_', basename($_FILES['contacto_imagen']['name']));
        if (move_uploaded_file($_FILES['contacto_imagen']['tmp_name'], $uploadsDir . $safeName)) {
            $contactoImagenPath = 'assets/uploads/' . $safeName;
        }
    }

    // 5. Buscamos el ID del barrio
    $res_barrio = pg_query_params($conexion, "SELECT id FROM barrios WHERE nombre ILIKE $1 LIMIT 1", [$barrio_nombre]);
    $barrio_id = (pg_num_rows($res_barrio) > 0) ? pg_fetch_result($res_barrio, 0, 'id') : null;

    // 6. Insertamos en la tabla `contactos`
    $res_contacto = pg_query_params($conexion, "INSERT INTO contactos (telefono, imagen_parqueadero) VALUES ($1, $2) RETURNING id", [$telefono, $contactoImagenPath]);
    if (!$res_contacto) throw new Exception('contacto_fail');
    $contacto_id = pg_fetch_result($res_contacto, 0, 'id');

    // 7. Insertamos en la tabla `parqueaderos`
    $sql_parq = "INSERT INTO parqueaderos (nombre, direccion, barrio_id, contacto_id, geom, imagen_url) VALUES ($1, $2, $3, $4, ST_GeomFromEWKT($5), $6) RETURNING id";
    $res_parq = pg_query_params($conexion, $sql_parq, [$nombre, $direccion, $barrio_id, $contacto_id, $geom, $imgUrl]);
    if (!$res_parq) throw new Exception('parqueadero_fail');
    $parqueadero_id = pg_fetch_result($res_parq, 0, 'id');

    // 8. Vinculamos el administrador con el parqueadero
    $res_admin = pg_query_params($conexion, "INSERT INTO administradores_parqueadero (admin_id, parqueadero_id) VALUES ($1, $2)", [$_SESSION['user_id'], $parqueadero_id]);
    if (!$res_admin) throw new Exception('admin_link_fail');

    // 9. Procesar datos desde JSON
    $horarios_data = json_decode($_POST['horarios_json'] ?? '[]', true);
    $info_data = json_decode($_POST['info_json'] ?? '[]', true);

    // 10. Insertar Horarios desde los datos decodificados
    if (is_array($horarios_data)) {
        foreach ($horarios_data as $h) {
            $dia = trim($h['dia_semana']);
            if (empty($dia)) continue;
            
            $apertura = !empty(trim($h['apertura'])) ? trim($h['apertura']) : null;
            $cierre = !empty(trim($h['cierre'])) ? trim($h['cierre']) : null;
            
            $dias_a_procesar = [];
            
            // Si es "Todos", creamos una entrada para cada día de la semana
            if ($dia === 'Todos') {
                $dias_a_procesar = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
                $apertura = '00:00:00';
                $cierre = '23:59:59';
            } 
            // Si es "Dias de semana", creamos una entrada para Lunes a Viernes
            elseif ($dia === 'Dias de semana') {
                $dias_a_procesar = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
            } 
            // Si es un día normal, solo ese día
            else {
                $dias_a_procesar = [$dia];
            }

            foreach ($dias_a_procesar as $dia_final) {
                $sql_horario = "INSERT INTO horarios_parqueadero (parqueadero_id, dia_semana, horario_apertura, horario_cierre) VALUES ($1, $2, $3, $4)";
                if (!pg_query_params($conexion, $sql_horario, [$parqueadero_id, $dia_final, $apertura, $cierre])) {
                    throw new Exception('horario_fail');
                }
            }
        }
    }
    
    // 11. Insertar Tarifas y Capacidades desde los datos decodificados
    if(is_array($info_data)) {
        foreach ($info_data as $info) {
            $tipo = trim($info['tipo_vehiculo']);
            if (!empty($tipo)) {
                $tarifa = is_numeric($info['tarifa']) ? $info['tarifa'] : 0;
                $capacidad = is_numeric($info['capacidad']) ? $info['capacidad'] : 0;
                
                $sql_info = "INSERT INTO informacion_parqueadero (parqueadero_id, tipo_vehiculo, tarifa, capacidad) VALUES ($1, $2, $3, $4)";
                if (!pg_query_params($conexion, $sql_info, [$parqueadero_id, $tipo, $tarifa, $capacidad])) {
                    throw new Exception('info_fail');
                }
            }
        }
    }

    // 12. Si todo fue bien, confirmar la transacción
    pg_query($conexion, "COMMIT");
    header("Location: ../admin.php?status=parqueadero_creado");
    exit;

} catch (Exception $e) {
    // Si algo falla durante el proceso, revertir todos los cambios
    pg_query($conexion, "ROLLBACK");
    header("Location: ../register-parqueadero.php?error=" . $e->getMessage());
    exit;
}