<?php session_start(); ?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parking SIG - Resultados</title>
    <link rel="stylesheet" href="css/index.css" />
    <link href="https://api.mapbox.com/mapbox-gl-js/v3.2.0/mapbox-gl.css" rel="stylesheet">
    <link rel="stylesheet" href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-directions/v4.3.1/mapbox-gl-directions.css" type="text/css">
    <style>
        .ordenar a.active { font-weight: bold; text-decoration: none; color: #333; }
        .mapboxgl-popup-content h6 { font-size: 1.1em; margin: 5px 0; color: #333; }
        .mapboxgl-popup-content p { margin: 0; font-size: 0.9em; }
        .mapboxgl-popup-content h6.destino { color: #E53E3E; }
        .mapboxgl-ctrl-directions .mapboxgl-ctrl-group { display: none; }
        .card .btn-ruta, .card .btn { background-color: #0b0c42; color: white; border: none; padding: 8px 12px; border-radius: 5px; cursor: pointer; margin-top: 10px; width: 100%; display: block; text-align: center; }
        .card .btn-ruta:hover, .card .btn:hover { background-color: #0056b3; }
        .card input[type="text"] { width: calc(100% - 20px); padding: 8px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
    </style>
</head>
<body>
    <header>
        <div class="header-left">
            <a href="index.php"><img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img" /></a>
        </div>
        <div class="header-right">
            <?php if (isset($_SESSION['user_id'])): ?>
            <a href="php/logout.php">Cerrar sesión</a>
            <a href="reservas.php" class="btn-reservas">Reservas</a>
            <?php else: ?>
            <a href="login.php">Iniciar sesión</a>
            <a href="login.php" class="btn-reservas">Reservas</a>
            <?php endif; ?>
        </div>
    </header>
    <div class="header-border"></div>

    <main class="resultados-container">
        <div class="mapa"><div id="map"></div></div>
        <aside class="panel-resultados">
            <div class="ordenar" id="panel-ordenar">
                Ordenar por: 
                <a href="#" id="ordenar-distancia" class="active">Distancia</a> 
                <a href="#" id="ordenar-precio">Precio</a>
            </div>
            <div id="panel-contenido"><p>Buscando parqueaderos cercanos...</p></div>
        </aside>
    </main>

    <script src="https://api.mapbox.com/mapbox-gl-js/v3.2.0/mapbox-gl.js"></script>
    <script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-directions/v4.3.1/mapbox-gl-directions.js"></script>
    
    <script>
        window.appConfig = {
            isUserLoggedIn: <?php echo isset($_SESSION['user_id']) ? 'true' : 'false'; ?>
        };
    </script>
    
    <script src="js/main.js" defer></script>
</body>
</html>