<?php
session_start();
require __DIR__ . '/conexion.php';

// 1. Validaciones de seguridad
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_SESSION['user_id']) || $_SESSION['rol'] !== 'admin') {
    header('Location: ../login.php');
    exit;
}

// 2. Recoger datos comunes
$parqueadero_id = filter_input(INPUT_POST, 'parqueadero_id', FILTER_VALIDATE_INT);
$movimiento = $_POST['movimiento'] ?? '';
$status = 'error'; // Por defecto, la operación falla
$msg = 'peticion_invalida';

if ($movimiento === 'ingreso') {
    // 3. Lógica de Ingreso
    $cedula = trim(pg_escape_string($conexion, $_POST['usuario_cedula'] ?? ''));
    $tipo_vehiculo = trim(pg_escape_string($conexion, $_POST['tipo_vehiculo'] ?? ''));
    $placa = ($tipo_vehiculo !== 'bicicleta') ? strtoupper(trim(pg_escape_string($conexion, $_POST['placa'] ?? ''))) : null;

    $sql = "INSERT INTO movimientos (parqueadero_id, usuario_cedula, tipo_vehiculo, placa, ingreso) VALUES ($1, $2, $3, $4, NOW())";
    if (pg_query_params($conexion, $sql, [$parqueadero_id, $cedula, $tipo_vehiculo, $placa])) {
        $status = 'ok';
        $msg = 'ingreso_registrado';
    } else {
        $msg = 'error_ingreso';
    }

} elseif ($movimiento === 'salida') {
    // 4. Lógica de Salida
    $identificador = trim(pg_escape_string($conexion, $_POST['identificador'] ?? ''));
    $cedula_busqueda = null;
    $placa_busqueda = null;

    // LÓGICA DE DISTINCIÓN: Si es puramente numérico y de longitud razonable, es una cédula. Si no, es una placa.
    if (is_numeric($identificador) && strlen($identificador) <= 11) {
        $cedula_busqueda = $identificador;
    } else {
        $placa_busqueda = strtoupper($identificador);
    }

    $find_sql = "SELECT id, ingreso, tipo_vehiculo FROM movimientos 
                 WHERE parqueadero_id = $1 
                   AND (usuario_cedula = $2 OR placa = $3) 
                   AND salida IS NULL 
                 ORDER BY ingreso DESC LIMIT 1";
    $find_res = pg_query_params($conexion, $find_sql, [$parqueadero_id, $cedula_busqueda, $placa_busqueda]);

    if (pg_num_rows($find_res) > 0) {
        $movimiento_abierto = pg_fetch_assoc($find_res);
        $movimiento_id = $movimiento_abierto['id'];
        $tipo_vehiculo_salida = $movimiento_abierto['tipo_vehiculo'];
        
        $tarifa_sql = "SELECT tarifa FROM informacion_parqueadero WHERE parqueadero_id = $1 AND tipo_vehiculo = $2";
        $tarifa_res = pg_query_params($conexion, $tarifa_sql, [$parqueadero_id, $tipo_vehiculo_salida]);
        
        if (pg_num_rows($tarifa_res) > 0) {
            $tarifa_hora = pg_fetch_result($tarifa_res, 0, 'tarifa');
            $ingreso_ts = new DateTime($movimiento_abierto['ingreso']);
            $salida_ts = new DateTime();
            $intervalo = $salida_ts->diff($ingreso_ts);
            
            $horas = $intervalo->h + ($intervalo->days * 24);
            if ($intervalo->i > 5) { // Si pasan más de 5 min de una hora, se cobra la siguiente
                $horas++;
            }
            $costo_calculado = max($horas, 1) * $tarifa_hora; // Mínimo 1 hora
            
            $update_sql = "UPDATE movimientos SET salida = NOW(), costo = $1 WHERE id = $2";
            if(pg_query_params($conexion, $update_sql, [$costo_calculado, $movimiento_id])) {
                $status = 'ok';
                $msg = 'salida_registrada';
            } else {
                $msg = 'error_actualizacion';
            }
        } else {
            $msg = 'sin_tarifa_definida';
        }
    } else {
        $msg = 'vehiculo_no_encontrado';
    }
}

// 5. Redirección final
header("Location: ../admin-parqueadero.php?status={$status}&msg={$msg}");
exit;