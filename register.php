<?php
// register.php
session_start();
// Si ya hay sesión activa, redirige al inicio
if (isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parking SIG - Registro</title>
    <link rel="stylesheet" href="css/register.css" />
</head>

<body>
    <header>
        <div class="header-left">
            <a href="index.php">
                <img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img" />
            </a>
        </div>
    </header>
    <div class="header-border"></div>

    <!-- Formulario de registro -->
    <main class="login-main">
        <div class="login-container">
            <h1>Parking SIG</h1>
            <h2></h2>
            <form action="php/validar_register.php" method="post">
                <input type="text" name="usuario" placeholder="Usuario" required />
                <input type="email" name="correo" placeholder="Correo electrónico" required />
                <input type="text" name="nombre" placeholder="Nombre" required />
                <input type="text" name="apellidos" placeholder="Apellidos" required />
                <input type="text" name="cedula" placeholder="Cédula" required />
                <input type="password" name="contrasena" placeholder="Contraseña" required />
                <select name="rol" required>
                    <option value="" disabled selected>Selecciona un rol</option>
                    <option value="usuario">Usuario</option>
                    <option value="admin">Administrador</option>
                </select>
                <button type="submit">Registrarse</button>
            </form>
            <p class="login-register">
                ¿Ya tienes cuenta? <a href="login.php">Inicia sesión</a>
            </p>
        </div>
    </main>

    <!-- Footer -->
    <div class="footer-border"></div>
    <footer>
        <p>&copy; 2025 Parking SIG - Todos los derechos están reservados</p>
    </footer>
</body>

</html>