<?php
// admin.php
session_start();

// Sólo admin puede entrar
if (!isset($_SESSION['user_id']) || $_SESSION['rol'] !== 'admin') {
    header('Location: login.php');
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parking SIG - Panel Administrador</title>
    <link rel="stylesheet" href="css/admin.css" />
</head>

<body>

    <header>
        <div class="header-left">
            <a href="#" onclick="location.reload();">
                <img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img" />
            </a>
        </div>
        <div class="header-right">
            <button class="btn-logout" onclick="location.href='php/logout.php'">
                Cerrar sesión
            </button>
        </div>
    </header>

    <div class="header-border"></div>

    <main class="admin-main">
        <div class="admin-container">
            <h1>Panel Administrador</h1>
            <div class="admin-options">
                <a href="register-parqueadero.php" class="card">
                    ¿Deseas agregar un parqueadero?
                </a>
                <a href="admin-parqueadero.php" class="card">
                    ¡Gestiona tu parqueadero aquí!
                </a>
            </div>
        </div>
    </main>

    <div class="footer-border"></div>
    <footer>
        <p>&copy; 2025 Parking SIG - Todos los derechos están reservados</p>
    </footer>
</body>

</html>