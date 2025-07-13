// js/main.js
document.addEventListener('DOMContentLoaded', async function() {
    const isUserLoggedIn = window.appConfig.isUserLoggedIn || false;
    
    mapboxgl.accessToken = 'pk.eyJ1IjoibWF1cm9yaW4iLCJhIjoiY2xoZm9zYnY0MXg2bzNwbzcyYTB0ZnNqZCJ9.nf7blIcuWc_NEGKALord3Q';
    
    const params = new URLSearchParams(window.location.search);
    const initialLng = params.get('lng') ? parseFloat(params.get('lng')) : -76.53;
    const initialLat = params.get('lat') ? parseFloat(params.get('lat')) : 3.386;
    const initialPlaceName = params.get('place_name');

    const map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v12',
        center: [initialLng, initialLat],
        zoom: 14
    });

    let parqueaderosData = [];
    const markers = {};
    let destinationMarker = null;
    let currentRoute = null;

    const directions = new MapboxDirections({
        accessToken: mapboxgl.accessToken,
        unit: 'metric',
        language: 'es',
        profile: 'mapbox/driving',
        controls: { instructions: true, profileSwitcher: false },
        geometries: 'geojson' // Clave para obtener la geometría completa
    });
    map.addControl(directions, 'top-left');

    const geolocate = new mapboxgl.GeolocateControl({
        positionOptions: { enableHighAccuracy: true },
        trackUserLocation: false,
        showUserHeading: true
    });
    map.addControl(geolocate, 'top-left');

    directions.on('route', (e) => {
        if (e.route && e.route.length > 0) {
            currentRoute = e.route[0];
        }
    });

    async function loadAndDisplayResults(lng, lat, placeName) {
        Object.values(markers).forEach(marker => marker.remove());
        if (destinationMarker) destinationMarker.remove();
        directions.removeRoutes();
        currentRoute = null;
        document.getElementById('panel-ordenar').style.display = 'block';
        const panelContenido = document.getElementById('panel-contenido');
        panelContenido.innerHTML = '<p>Buscando parqueaderos cercanos...</p>';
        map.flyTo({ center: [lng, lat], zoom: 14 });
        destinationMarker = new mapboxgl.Marker({ color: "#FF0000", scale: 1.2 })
            .setLngLat([lng, lat])
            .setPopup(new mapboxgl.Popup().setHTML(`<h6 class="destino">${placeName || 'Ubicación seleccionada'}</h6>`))
            .addTo(map)
            .togglePopup();
        try {
            const response = await fetch(`php/get_parqueaderos.php?lng=${lng}&lat=${lat}`);
            const data = await response.json();
            if (response.status !== 200 || data.error) {
                throw new Error(data.details || 'El servidor devolvió un error.');
            }
            parqueaderosData = data;
            renderParqueaderos(parqueaderosData);
        } catch (error) {
            console.error("Error al cargar parqueaderos:", error);
            panelContenido.innerHTML = `<p>Ocurrió un error al buscar parqueaderos.</p><p style="font-size:0.8em; color:grey;">${error.message}</p>`;
        }
    }

    function renderParqueaderos(parqueaderosArray) {
        const panelContenido = document.getElementById('panel-contenido');
        panelContenido.innerHTML = '';
        if (!parqueaderosArray || parqueaderosArray.length === 0) {
            panelContenido.innerHTML = '<p>No se encontraron parqueaderos cercanos.</p>';
            return;
        }
        parqueaderosArray.forEach(p => {
            const horarios = p.horarios ? JSON.parse(p.horarios) : [];
            let popupHtml = `<h6>${p.nombre}</h6>`;
            const dias = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
            const hoy = dias[new Date().getDay()];
            const horarioDeHoy = horarios.find(h => h.dia === hoy);
            if (horarioDeHoy && horarioDeHoy.dia) {
                popupHtml += `<p>Hoy: ${horarioDeHoy.apertura ? horarioDeHoy.apertura.substring(0,5) + ' - ' + horarioDeHoy.cierre.substring(0,5) : 'Abierto 24 horas'}</p>`;
            } else {
                popupHtml += `<p>Hoy: Cerrado</p>`;
            }
            const popup = new mapboxgl.Popup({ offset: 25, closeButton: false }).setHTML(popupHtml);
            const marker = new mapboxgl.Marker().setLngLat([p.lng, p.lat]).setPopup(popup).addTo(map);
            marker.getElement().addEventListener('mouseenter', () => marker.togglePopup());
            marker.getElement().addEventListener('mouseleave', () => marker.togglePopup());
            markers[p.id] = marker;
            const card = document.createElement('div');
            card.className = 'card';
            card.dataset.parqueaderoId = p.id;
            const tarifas = p.tarifas ? JSON.parse(p.tarifas) : [];
            let tarifasHtml = '<ul>';
            if (tarifas && tarifas.length > 0) {
                tarifas.forEach(t => { tarifasHtml += `<li>${t.tipo}: <strong>$${parseInt(t.tarifa)}</strong>/hora</li>`; });
            } else {
                tarifasHtml += '<li>No hay tarifas definidas.</li>';
            }
            tarifasHtml += '</ul>';
            card.innerHTML = `<strong>${p.nombre}</strong>${tarifasHtml}<p>Distancia: <strong>${Math.round(p.distancia)} metros</strong></p><button class="btn-ruta" data-lng="${p.lng}" data-lat="${p.lat}">Crear Ruta</button>`;
            panelContenido.appendChild(card);
        });
    }

    function renderGuardarRuta(parqueadero) {
        const panelContenido = document.getElementById('panel-contenido');
        document.getElementById('panel-ordenar').style.display = 'none';
        const horarios = parqueadero.horarios ? JSON.parse(parqueadero.horarios) : [];
        let horariosHtml = '<ul>';
        if (horarios && horarios.length > 0 && horarios[0] && horarios[0].dia) {
            horarios.forEach(h => {
                horariosHtml += `<li><strong>${h.dia}:</strong> ${h.apertura ? h.apertura.substring(0,5) + ' - ' + h.cierre.substring(0,5) : '24 horas'}</li>`;
            });
        } else {
            horariosHtml += '<li>No hay horarios definidos.</li>';
        }
        horariosHtml += '</ul>';
        panelContenido.innerHTML = `
            <div class="card active-route">
                <h3>${parqueadero.nombre}</h3>
                <h4>Horarios Completos:</h4>
                ${horariosHtml}
                <hr>
                <label for="nombre-ruta" style="display:block; margin-top:10px;">Nombre para tu ruta:</label>
                <input type="text" id="nombre-ruta" placeholder="Ej: Ruta al trabajo">
                <button id="btn-guardar-ruta" class="btn">Guardar Ruta</button>
                <button id="btn-cancelar-ruta" class="btn">Cancelar</button>
            </div>`;
    }
    
    async function saveRouteToServer(nombre) {
        try {
            // La única fuente de verdad será la ruta dibujada en el mapa
            const source = map.getSource('directions');
            if (!source || !source._data || !source._data.features || source._data.features.length === 0) {
                throw new Error("No se encontró una ruta activa en el mapa para guardar.");
            }
            const coordinates = source._data.features[0].geometry.coordinates;

            if (!Array.isArray(coordinates) || coordinates.length === 0) {
                throw new Error("La geometría de la ruta encontrada es inválida o está vacía.");
            }

            const wkt = 'LINESTRING(' + coordinates.map(coord => coord.join(' ')).join(',') + ')';
            
            const response = await fetch('php/guardar_ruta.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ nombre: nombre, wkt: wkt })
            });
            const result = await response.json();
            if (!response.ok) {
                throw new Error(result.error || 'Error desconocido del servidor.');
            }
            alert(result.success || 'Ruta guardada exitosamente.');
            directions.removeRoutes();
            renderParqueaderos(parqueaderosData);

        } catch (error) {
            alert(`No se pudo guardar la ruta: ${error.message}`);
            console.error("Error en saveRouteToServer:", error);
        }
    }

    geolocate.on('geolocate', (e) => loadAndDisplayResults(e.coords.longitude, e.coords.latitude, 'Mi ubicación actual'));
    map.on('click', (e) => { if (e.originalEvent.target.closest('.mapboxgl-marker')) return; loadAndDisplayResults(e.lngLat.lng, e.lngLat.lat, 'Ubicación seleccionada'); });
    
    document.getElementById('ordenar-distancia').addEventListener('click', function(e) {
        e.preventDefault();
        parqueaderosData.sort((a, b) => a.distancia - b.distancia);
        renderParqueaderos(parqueaderosData);
        this.classList.add('active');
        document.getElementById('ordenar-precio').classList.remove('active');
    });
    
    document.getElementById('ordenar-precio').addEventListener('click', function(e) {
        e.preventDefault();
        parqueaderosData.sort((a, b) => {
            const tarifaA = (a.tarifas && JSON.parse(a.tarifas).length > 0) ? Math.min(...JSON.parse(a.tarifas).map(t => parseFloat(t.tarifa))) : Infinity;
            const tarifaB = (b.tarifas && JSON.parse(b.tarifas).length > 0) ? Math.min(...JSON.parse(b.tarifas).map(t => parseFloat(t.tarifa))) : Infinity;
            return tarifaA - tarifaB;
        });
        renderParqueaderos(parqueaderosData);
        this.classList.add('active');
        document.getElementById('ordenar-distancia').classList.remove('active');
    });
    
    document.getElementById('panel-contenido').addEventListener('click', (e) => {
        const card = e.target.closest('.card');
        if (!card) return;

        if (e.target.matches('.btn-ruta')) {
            if (!isUserLoggedIn) { alert('Debes iniciar sesión para poder crear una ruta.'); window.location.href = 'login.php'; return; }
            const button = e.target;
            const destLng = parseFloat(button.dataset.lng);
            const destLat = parseFloat(button.dataset.lat);
            if (destinationMarker) {
                const originCoords = destinationMarker.getLngLat();
                directions.setOrigin([originCoords.lng, originCoords.lat]);
                directions.setDestination([destLng, destLat]);
                const parqueaderoId = button.closest('.card').dataset.parqueaderoId;
                const pSeleccionado = parqueaderosData.find(p => p.id == parqueaderoId);
                if (pSeleccionado) renderGuardarRuta(pSeleccionado);
            }
        } 
        else if (e.target.matches('#btn-guardar-ruta')) {
            const nombreRuta = document.getElementById('nombre-ruta').value;
            saveRouteToServer(nombreRuta);
        }
        else if (e.target.matches('#btn-cancelar-ruta')) {
            directions.removeRoutes();
            renderParqueaderos(parqueaderosData);
        }
        else if (!e.target.matches('button, input, a')) {
            const id = card.dataset.parqueaderoId;
            const marker = markers[id];
            if (marker) { map.flyTo({ center: marker.getLngLat(), zoom: 16 }); marker.togglePopup(); }
        }
    });

    loadAndDisplayResults(initialLng, initialLat, initialPlaceName);
});