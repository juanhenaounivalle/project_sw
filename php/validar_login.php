<?php
// 1) Arrancamos la sesión
session_start();

// 2) Incluimos la conexión
require __DIR__ . '/conexion.php';

// 3) Sólo aceptamos POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../login.php');
    exit;
}

// 4) Recogemos los datos del formulario
// Usaremos pg_query_params, por lo que no es estrictamente necesario escapar aquí, pero no hace daño.
$usuario    = trim(pg_escape_string($conexion, $_POST['usuario'] ?? ''));
$contrasena = trim($_POST['contrasena'] ?? ''); // La contraseña NUNCA se escapa

// 5) Validación mínima
if (empty($usuario) || empty($contrasena)) {
    header('Location: ../login.php?error=campos_vacios');
    exit;
}

// 6) ✅ MEJORA 1: Usamos una consulta parametrizada para seguridad
$sql = "SELECT id, rol, contraseña AS hashpass
        FROM usuarios
        WHERE usuario = $1 OR correo = $1";
$result = pg_query_params($conexion, $sql, [$usuario]);

// 7) Verificamos si el usuario existe
if ($result && pg_num_rows($result) === 1) {
    $fila = pg_fetch_assoc($result);

    // 8) ✅ MEJORA 2: Verificamos el hash de la contraseña
    if (password_verify($contrasena, $fila['hashpass'])) {
        // ¡Contraseña correcta!
        // Guardamos en sesión
        $_SESSION['user_id'] = $fila['id'];
        $_SESSION['rol']     = $fila['rol'];

        // Redirigimos según rol
        if ($fila['rol'] === 'admin') {
            header('Location: ../admin.php');
        } else {
            header('Location: ../main.php');
        }
        exit;
    }
}

// 9) Si el usuario no existe o la contraseña es incorrecta, redirigimos
header('Location: ../login.php?error=credenciales_invalidas');
exit;