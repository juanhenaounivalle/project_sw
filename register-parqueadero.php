<?php
// register-parqueadero.php
session_start();

// Solo administradores pueden entrar
if (!isset($_SESSION['user_id']) || $_SESSION['rol'] !== 'admin') {
    header('Location: login.php');
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>Parking SIG - Nuevo Parqueadero</title>

    <link href="https://api.mapbox.com/mapbox-gl-js/v3.12.0/mapbox-gl.css" rel="stylesheet" />

    <link rel="stylesheet" href="css/register-parqueadero.css" />

</head>

<body>
    <header>
        <div class="header-left">
            <a href="admin.php">
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

    <main class="reg-main">
        <div class="reg-container">
            <h1>Parking SIG</h1>
            <h2>Registro de Parqueadero</h2>
            <form id="formParqueadero" action="php/guardar_parqueadero.php" method="post" enctype="multipart/form-data">
                
                <label for="nombre">Nombre</label>
                <input type="text" id="nombre" name="nombre" placeholder="Nombre del parqueadero" required />

                <label>Ubicación</label>
                <div id="map" class="map"></div>
                <input type="hidden" id="geom" name="geom" />

                <label for="direccion">Dirección</label>
                <input type="text" id="direccion" name="direccion" placeholder="Dirección" readonly required />

                <label for="barrio">Barrio</label>
                <input type="text" id="barrio" name="barrio" placeholder="Barrio" readonly required />

                <label for="telefono">Teléfono de contacto</label>
                <input type="text" id="telefono" name="telefono" placeholder="Teléfono" />

                <label for="contacto_imagen">Foto de parqueadero</label>
                <input type="file" id="contacto_imagen" name="contacto_imagen" accept="image/*" />

                <label for="imagenes">Imagen adicional (URL)</label>
                <input type="text" id="imagenes" name="imagenes" placeholder="https://ejemplo.com" />

                <fieldset class="group-fieldset" id="fieldset-horarios">
                    <legend>Horarios de atención</legend>
                    <div class="group-row">
                        <select name="horario_dia_semana" required>
                            <option value="" disabled selected>- Selecciona día -</option>
                            <option value="Lunes">Lunes</option>
                            <option value="Martes">Martes</option>
                            <option value="Miércoles">Miércoles</option>
                            <option value="Jueves">Jueves</option>
                            <option value="Viernes">Viernes</option>
                            <option value="Sábado">Sábado</option>
                            <option value="Domingo">Domingo</option>
                            <option value="Dias de semana">Días de semana (Lunes a Viernes)</option>
                            <option value="Todos">Todos los días (24/7)</option>
                        </select>
                        <input type="time" name="horario_apertura" />
                        <input type="time" name="horario_cierre" />
                        <button type="button" class="btn-add">Añadir</button>
                    </div>
                </fieldset>

                <fieldset class="group-fieldset" id="fieldset-info">
                    <legend>Tarifas y capacidad</legend>
                    <div class="group-row">
                        <select name="info_tipo_vehiculo" required>
                            <option value="" disabled selected>- Tipo de vehículo -</option>
                            <option value="Carro">Carro</option>
                            <option value="Moto">Moto</option>
                            <option value="Bicicleta">Bicicleta</option>
                        </select>
                        <input type="number" name="info_tarifa" step="0.01" placeholder="Tarifa (hora)" required />
                        <input type="number" name="info_capacidad" placeholder="Capacidad" required />
                        <button type="button" class="btn-add">Añadir</button>
                    </div>
                </fieldset>

                <input type="hidden" name="horarios_json" id="horarios_json">
                <input type="hidden" name="info_json" id="info_json">

                <button type="submit" class="btn-submit">
                    Guardar parqueadero
                </button>
            </form>
        </div>
    </main>

    <div class="footer-border"></div>

    <footer>
        <p>&copy; 2025 Parking SIG - Todos los derechos están reservados</p>
    </footer>

    <script src="https://api.mapbox.com/mapbox-gl-js/v3.12.0/mapbox-gl.js"></script>

    <script src="js/map.js" defer></script>
    <script src="js/register-logic.js" defer></script>

</body>

</html>