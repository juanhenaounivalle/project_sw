<?php
// index.php
session_start();
$logged = isset($_SESSION['user_id']);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parking SIG - ¿A dónde vas?</title>
    <link rel="stylesheet" href="css/index.css" />
    <link href="https://api.mapbox.com/mapbox-gl-js/v3.2.0/mapbox-gl.css" rel="stylesheet">
    <link rel="stylesheet" href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v5.0.2/mapbox-gl-geocoder.css" type="text/css">
    <style>
        /* Estilos para centrar y agrandar el buscador */
        #geocoder-container { position: absolute; top: 25%; left: 50%; transform: translate(-50%, -50%); width: 90%; max-width: 600px; z-index: 10; }
        #geocoder-container .mapboxgl-ctrl-geocoder { width: 100%; max-width: none; font-size: 1.2rem; line-height: 1.5; border-radius: 8px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3); }
        #geocoder-container .mapboxgl-ctrl-geocoder--input { height: 55px; padding-left: 55px; }
        #geocoder-container .mapboxgl-ctrl-geocoder--icon-search { top: 15px; left: 15px; width: 25px; height: 25px; }
        #map { filter: brightness(0.7); }
    </style>
</head>
<body>
    <header>
        <div class="header-left">
            <a href="index.php"><img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img" /></a>
        </div>
        <div class="header-right">
            <?php if (!$logged): ?>
                <a href="login.php">Iniciar sesión</a>
            <?php else: ?>
                <a href="php/logout.php">Cerrar sesión</a>
            <?php endif; ?>
            <a href="<?php echo $logged ? 'reservas.php' : 'login.php'; ?>" class="btn-reservas">Reservas</a>
        </div>
    </header>
    <div class="header-border"></div>
    <main>
        <section class="hero">
            <div id="map"></div>
            <div id="geocoder-container"></div>
        </section>
        <section class="promo">
            <div class="promo-text">
                ¿Es usted dueño o administrador de parqueaderos?<br>
                ¿Le gustaría promocionar su parqueadero y llegar a nuevos clientes?
            </div>
            <a href="register.php" class="btn-unirse">Regístrate</a>
        </section>
    </main>
    <div class="footer-border"></div>
    <footer>
        <p>&copy; 2025 Parking SIG - Todos los derechos están reservados</p>
    </footer>

    <script src="https://api.mapbox.com/mapbox-gl-js/v3.2.0/mapbox-gl.js"></script>
    <script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v5.0.2/mapbox-gl-geocoder.min.js"></script>
    <script>
        mapboxgl.accessToken = 'pk.eyJ1IjoibWF1cm9yaW4iLCJhIjoiY2xoZm9zYnY0MXg2bzNwbzcyYTB0ZnNqZCJ9.nf7blIcuWc_NEGKALord3Q';

        // ✅ El mapa ahora es interactivo para permitir clics
        const map = new mapboxgl.Map({
            container: 'map',
            style: 'mapbox://styles/mapbox/streets-v12',
            center: [-76.53, 3.386],
            zoom: 12
        });

        // ✅ Función de ayuda para redirigir
        function redirectToMain(lng, lat, placeName = 'Ubicación seleccionada') {
            const redirectUrl = `main.php?lng=${lng}&lat=${lat}&place_name=${encodeURIComponent(placeName)}`;
            window.location.href = redirectUrl;
        }

        // Geocodificador (lógica sin cambios)
        const geocoder = new MapboxGeocoder({
            accessToken: mapboxgl.accessToken,
            mapboxgl: mapboxgl,
            placeholder: '¿A dónde vas?',
            marker: false,
            language: 'es',
            countries: 'co',
            bbox: [-76.593, 3.339, -76.444, 3.504]
        });
        document.getElementById('geocoder-container').appendChild(geocoder.onAdd(map));
        geocoder.on('result', (e) => {
            redirectToMain(e.result.center[0], e.result.center[1], e.result.place_name);
        });

        // ✅ NUEVO: Añadir el control de Geolocalización
        const geolocate = new mapboxgl.GeolocateControl({
            positionOptions: { enableHighAccuracy: true },
            trackUserLocation: false, // Solo obtener la ubicación una vez
            showUserHeading: true
        });
        map.addControl(geolocate, 'top-left');

        // ✅ NUEVO: Escuchar el evento 'geolocate' para redirigir
        geolocate.on('geolocate', (e) => {
            redirectToMain(e.coords.longitude, e.coords.latitude, 'Mi ubicación actual');
        });

        // ✅ NUEVO: Escuchar el evento 'click' en el mapa para redirigir
        map.on('click', (e) => {
            redirectToMain(e.lngLat.lng, e.lngLat.lat);
        });
    </script>
</body>
</html>