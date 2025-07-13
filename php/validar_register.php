<?php
// 1) Incluimos la conexión
require __DIR__ . '/conexion.php';

// 2) Sólo aceptamos POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../register.php');
    exit;
}

// 3) Recogemos y escapamos todos los campos
$usuario    = trim(pg_escape_string($conexion, $_POST['usuario']   ?? ''));
$correo     = trim(pg_escape_string($conexion, $_POST['correo']    ?? ''));
$nombre     = trim(pg_escape_string($conexion, $_POST['nombre']    ?? ''));
$apellidos  = trim(pg_escape_string($conexion, $_POST['apellidos'] ?? ''));
$cedula     = trim(pg_escape_string($conexion, $_POST['cedula']    ?? ''));
$contrasena = trim($_POST['contrasena'] ?? ''); // No escapamos la contraseña original aquí
$rol        = trim(pg_escape_string($conexion, $_POST['rol']       ?? ''));

// 4) Validación mínima (puedes ampliarla)
$errores = [];
if ($usuario === '')    $errores[] = 'Usuario vacío';
if ($correo === '')     $errores[] = 'Correo vacío';
if ($contrasena === '') $errores[] = 'Contraseña vacía';
if (!in_array($rol, ['usuario', 'admin'])) $errores[] = 'Rol inválido';

if ($errores) {
    // Para un mejor feedback, podrías redirigir con un mensaje de error
    echo 'Errores: <br>' . implode('<br>', $errores);
    exit;
}

// 5) ✅ ¡AQUÍ LA MEJORA DE SEGURIDAD!
// Creamos un hash seguro de la contraseña
$hash_contrasena = password_hash($contrasena, PASSWORD_DEFAULT);

// 6) Insertamos el hash en la base de datos
// Nota: La columna en la BD se llama 'contraseña', pero le pasamos el HASH.
$sql = "INSERT INTO usuarios 
          (usuario, correo, nombre, apellidos, cedula, contraseña, rol) 
        VALUES
          ('$usuario', '$correo', '$nombre', '$apellidos', '$cedula', '$hash_contrasena', '$rol')";
$res = pg_query($conexion, $sql);

if ($res) {
    // ¡Éxito! Redirigimos al login para que inicie sesión
    header('Location: ../login.php?registro=exitoso');
    exit;
} else {
    // Manejo de error (p. ej., usuario o correo ya existen)
    // En un futuro, es mejor redirigir con un mensaje amigable
    echo "Error al registrar usuario: " . pg_last_error($conexion);
    exit;
}