# project_sw
Proyecto Parking Sig

Parking SIG

Parking SIG es una aplicación web geoespacial diseñada para ayudar a los usuarios a encontrar y navegar hacia parqueaderos disponibles en Cali, Colombia. La plataforma permite a los administradores de parqueaderos registrar sus establecimientos y gestionar los movimientos de vehículos, mientras que los usuarios finales pueden buscar destinos, ver parqueaderos cercanos con sus tarifas y horarios, y guardar rutas personalizadas.

Tecnologías Principales

Backend: PHP

Base de Datos: PostgreSQL con la extensión espacial PostGIS

Servidor de Mapas: GeoServer (para capas base como barrios)

Frontend: HTML5, CSS3, JavaScript (ES6+)

Librería de Mapas: Mapbox GL JS

Plugins Adicionales: Mapbox GL Geocoder, Mapbox GL Directions

Estructura del Proyecto

El proyecto está organizado en carpetas para separar las responsabilidades:

/sigweb
|
|-- /assets
|-- /css
|   |-- index.css
|   |-- main.css
|   |-- admin.css
|   |-- ... (otros archivos .css)
|
|-- /js
|   |-- main.js
|   |-- map.js
|   |-- register-logic.js
|
|-- /php
|   |-- conexion.php
|   |-- get_parqueaderos.php
|   |-- guardar_parqueadero.php
|   |-- guardar_ruta.php
|   |-- ... (otros scripts de validación y gestión)
|
|-- admin.php
|-- admin-parqueadero.php
|-- index.php
|-- login.php
|-- main.php
|-- register-parqueadero.php
|-- register.php
|-- ... (otros archivos .php)

Descripción de Componentes Clave

Archivos Principales (Raíz)

index.php: Es el portal de inicio y la cara principal de la aplicación. Su única función es permitir al usuario buscar un destino. Utiliza el Mapbox Geocoder y eventos de clic/geolocalización para capturar coordenadas y redirigir al usuario a main.php.

main.php: La página de resultados. Es el corazón de la experiencia del usuario. Carga un mapa centrado en la ubicación buscada, muestra un marcador de destino y, a través de js/main.js, carga dinámicamente los parqueaderos cercanos.

login.php / register.php: Formularios estándar para el registro e inicio de sesión de usuarios.

admin.php: Panel principal para administradores, desde donde pueden acceder a las funciones de gestión.

register-parqueadero.php: Formulario avanzado para que los administradores registren nuevos parqueaderos. Utiliza Mapbox para la selección de ubicación y JavaScript para la gestión de horarios y tarifas.

admin-parqueadero.php: Interfaz para que los administradores gestionen los ingresos y salidas de vehículos en tiempo real.

Lógica del Backend (/php)

conexion.php: Establece la conexión con la base de datos PostgreSQL. Es requerido por todos los demás scripts que interactúan con la BD.

get_parqueaderos.php: Un endpoint crucial. Recibe coordenadas (longitud, latitud) y ejecuta una consulta espacial a PostGIS (ST_DWithin, ST_Distance) para encontrar los 20 parqueaderos más cercanos en un radio determinado. Devuelve la información completa (incluyendo tarifas y horarios agregados como JSON) para ser consumida por el frontend.

guardar_parqueadero.php: Procesa los datos del formulario register-parqueadero.php. Recibe los datos de horarios y tarifas como strings JSON, los decodifica y realiza múltiples INSERT en las tablas correspondientes dentro de una transacción segura.

guardar_ruta.php: Recibe una geometría de ruta en formato WKT (Well-Known Text) y la guarda en la tabla rutas, asociándola con el usuario que ha iniciado sesión.

registrar_movimiento.php: Maneja la lógica de negocio para registrar el ingreso o la salida de un vehículo en la página de gestión de administradores.

Lógica del Frontend (/js)

main.js: El script más complejo. Gestiona toda la interactividad de la página main.php. Sus responsabilidades incluyen:

Leer los parámetros de la URL.

Inicializar el mapa de Mapbox y el control de direcciones.

Llamar a get_parqueaderos.php para obtener los datos.

Renderizar los marcadores en el mapa y las tarjetas en el panel lateral.

Manejar los eventos de ordenamiento (distancia, precio).

Gestionar la interactividad entre las tarjetas y los marcadores (hover y clic).

Controlar el flujo para crear, visualizar y guardar una ruta.

register-logic.js: Contiene toda la lógica para el formulario dinámico en register-parqueadero.php, permitiendo añadir/quitar filas de horarios y tarifas, y aplicando validaciones complejas en el proceso.

map.js: Script original de Mapbox para la página register-parqueadero.php que maneja la selección de ubicación, geocodificación inversa y la obtención del barrio desde GeoServer.

Flujo de la Aplicación

Flujo del Usuario Final

El usuario llega a index.php.

Busca un destino usando el geocodificador.

Es redirigido a main.php con las coordenadas del destino.

main.php carga el mapa y, a través de main.js, solicita al backend los parqueaderos cercanos.

El usuario ve los parqueaderos en el mapa y en el panel. Puede ordenarlos e interactuar con ellos.

Si ha iniciado sesión, puede hacer clic en "Crear Ruta" en una tarjeta. El mapa muestra la ruta.

El panel cambia para mostrar los detalles del parqueadero y un campo para nombrar y guardar la ruta.

Flujo del Administrador

El administrador inicia sesión a través de login.php.

Es redirigido al panel admin.php.

Desde allí, puede elegir registrar un nuevo parqueadero (yendo a register-parqueadero.php) o gestionar uno existente (yendo a admin-parqueadero.php).

En admin-parqueadero.php, puede ver el aforo y registrar los movimientos de entrada y salida de vehículos.
