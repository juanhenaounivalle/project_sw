<?php
session_start();
if (!isset($_SESSION['user_id']) || $_SESSION['rol'] !== 'admin') {
    header('Location: login.php');
    exit;
}
require __DIR__ . '/php/conexion.php';
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parking SIG - Gestión de Parqueadero</title>
    <link rel="stylesheet" href="css/admin-parqueadero.css" />
</head>
<body>
    <header>
        <div class="header-left">
            <a href="admin.php">
                <img src="assets/logo_parking.png" alt="Logo Parking SIG" class="logo-img" />
            </a>
        </div>
        <div class="header-right">
            <button class="btn-logout" onclick="location.href='php/logout.php'">Cerrar sesión</button>
        </div>
    </header>
    <div class="header-border"></div>

    <main class="parqueadero-main">
        <div class="parqueadero-container">
            <label for="selParq">¿Qué parqueadero deseas gestionar?</label>
            <select id="selParq">
                <option value="" disabled selected>Selecciona uno...</option>
                <?php
                $adminId = $_SESSION['user_id'];
                $res = pg_query_params($conexion, 'SELECT p.id, p.nombre FROM parqueaderos p JOIN administradores_parqueadero ap ON ap.parqueadero_id = p.id WHERE ap.admin_id = $1 ORDER BY p.nombre ASC', [$adminId]);
                $mis_parqueaderos = pg_fetch_all($res) ?: [];
                foreach ($mis_parqueaderos as $p) {
                    echo "<option value=\"{$p['id']}\">" . htmlspecialchars($p['nombre']) . "</option>";
                }
                ?>
            </select>

            <div id="detalleParq" style="display:none;">
                <h2 id="nombreParq"></h2>
                <div id="aforo-detallado" class="capacity-info"></div>

                <div class="movimiento-toggle">
                    <input type="radio" id="radio-ingreso" name="movimiento_tipo" value="ingreso" checked>
                    <label for="radio-ingreso">Registrar Ingreso</label>
                    
                    <input type="radio" id="radio-salida" name="movimiento_tipo" value="salida">
                    <label for="radio-salida">Registrar Salida</label>
                </div>

                <form id="formIngreso" action="php/registrar_movimiento.php" method="post" class="movimiento-form">
                    <input type="hidden" name="parqueadero_id" class="parqueadero_id_hidden" />
                    <input type="hidden" name="movimiento" value="ingreso" />
                    <h3>Registro de Ingreso</h3>
                    
                    <label for="ingreso_cedula">Cédula del usuario</label>
                    <input type="text" id="ingreso_cedula" name="usuario_cedula" placeholder="Ingresa la cédula" required />
                    
                    <label for="ingreso_tipoVeh">Tipo de vehículo</label>
                    <select id="ingreso_tipoVeh" name="tipo_vehiculo" required>
                        <option value="" disabled selected>- Selecciona tipo -</option>
                        <option value="carro">Carro</option>
                        <option value="moto">Moto</option>
                        <option value="bicicleta">Bicicleta</option>
                    </select>
                    
                    <div id="ingreso_grupoPlaca" style="display:none;">
                        <label for="ingreso_placa">Placa</label>
                        <input type="text" id="ingreso_placa" name="placa" placeholder="Ingresa la placa"/>
                    </div>
                    <button type="submit">Registrar Ingreso</button>
                </form>

                <form id="formSalida" action="php/registrar_movimiento.php" method="post" class="movimiento-form" style="display:none;">
                    <input type="hidden" name="parqueadero_id" class="parqueadero_id_hidden" />
                    <input type="hidden" name="movimiento" value="salida" />
                    <h3>Registro de Salida</h3>
                    
                    <label for="salida_identificador">Cédula o Placa del vehículo</label>
                    <input type="text" id="salida_identificador" name="identificador" placeholder="Ingresa la cédula o placa" required />
                    <button type="submit">Registrar Salida</button>
                </form>
            </div>
        </div>
    </main>
    
    <div class="footer-border"></div>
    <footer>
        <p>&copy; 2025 Parking SIG – Todos los derechos están reservados</p>
    </footer>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const selParq = document.getElementById('selParq');
        const detalleParq = document.getElementById('detalleParq');
        const radiosMovimiento = document.querySelectorAll('input[name="movimiento_tipo"]');
        const formIngreso = document.getElementById('formIngreso');
        const formSalida = document.getElementById('formSalida');
        const parqueaderoIdInputs = document.querySelectorAll('.parqueadero_id_hidden');
        const tipoVehSelect = document.getElementById('ingreso_tipoVeh');
        const grupoPlaca = document.getElementById('ingreso_grupoPlaca');
        const placaInput = document.getElementById('ingreso_placa');
        const detalleAforoDiv = document.getElementById('aforo-detallado');

        async function cargarDetallesParqueadero() {
            const id = selParq.value;
            if (!id) {
                detalleParq.style.display = 'none';
                return;
            }
            parqueaderoIdInputs.forEach(input => input.value = id);
            try {
                const res = await fetch(`php/get_parqueadero.php?id=${id}`);
                if (!res.ok) throw new Error('Respuesta del servidor no fue OK');
                const data = await res.json();
                
                document.getElementById('nombreParq').textContent = data.nombre;
                
                detalleAforoDiv.innerHTML = ''; 

                if (Object.keys(data.aforo_detallado).length > 0) {
                    for (const tipo in data.aforo_detallado) {
                        const info = data.aforo_detallado[tipo];
                        const p = document.createElement('p');
                        p.innerHTML = `<strong>${tipo.charAt(0).toUpperCase() + tipo.slice(1)}s:</strong> ${info.ocupados} / ${info.capacidad} <span>(Tarifa: $${info.tarifa})</span>`;
                        detalleAforoDiv.appendChild(p);
                    }
                } else {
                    detalleAforoDiv.innerHTML = '<p>No hay información de aforo definida para este parqueadero.</p>';
                }
                
                detalleParq.style.display = 'block';
            } catch (error) {
                console.error('Error al obtener datos del parqueadero:', error);
                alert('No se pudieron cargar los datos del parqueadero.');
            }
        }

        selParq.addEventListener('change', cargarDetallesParqueadero);

        radiosMovimiento.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'ingreso') {
                    formIngreso.style.display = 'block';
                    formSalida.style.display = 'none';
                } else {
                    formIngreso.style.display = 'none';
                    formSalida.style.display = 'block';
                }
            });
        });

        tipoVehSelect.addEventListener('change', function() {
            if (this.value === 'bicicleta' || this.value === '') {
                grupoPlaca.style.display = 'none';
                placaInput.required = false;
            } else {
                grupoPlaca.style.display = 'block';
                placaInput.required = true;
            }
        });
    });
    </script>
</body>
</html>