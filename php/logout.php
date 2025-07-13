<?php
// php/logout.php
session_start();
// Vacía todas las variables de sesión
$_SESSION = [];
// Si quieres también borrar la cookie de sesión:
if (ini_get("session.use_cookies")) {
    setcookie(session_name(), '', time() - 3600, '/');
}
// Destruye la sesión
session_destroy();
// Redirige al índice público
header('Location: ../index.php');
exit;
