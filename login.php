<?php
// login.php
session_start();
// Si ya está logueado, redirige al index
if (isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parking SIG - Iniciar Sesión</title>
    <link rel="stylesheet" href="css/login.css">
</head>

<body>
    
    <header>
        <div class="header-left">
            <a href="index.php">
                <img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img">
            </a>
        </div>
    </header>

    <div class="header-border"></div>

    <main class="login-main">
        <div class="login-container">
            <h1>Parking SIG</h1>
            <h2>Iniciar Sesión</h2>
            <form id="loginForm" action="php/validar_login.php" method="post">
                <input type="text" name="usuario" placeholder="Usuario o correo" required>
                <input type="password" name="contrasena" placeholder="Contraseña" required>
                <button type="submit">Entrar</button>
            </form>
            <p class="login-register">
                ¿No tienes cuenta? <a href="register.php">Regístrate</a>
            </p>
        </div>
    </main>

    <!-- Línea verde inferior -->
    <div class="footer-border"></div>
    <footer>
        <p>&copy; 2025 Parking SIG - Todos los derechos están reservados</p>
    </footer>
</body>

</html>