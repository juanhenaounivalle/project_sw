// js/map.js

// 1️⃣ Base URL de tu WFS de barrios
const baseWfs =
    'http://34.206.56.11:8080/geoserver/sigweb/ows' +
    '?service=WFS' +
    '&version=1.0.0' +
    '&request=GetFeature' +
    '&typeName=sigweb:barrios' +
    '&outputFormat=application/json' +
    '&maxFeatures=1';

// 2️⃣ Inicializa Mapbox
mapboxgl.accessToken =
    'pk.eyJ1IjoianVhbmhlbmFvMTgiLCJhIjoiY200NjI5bHZnMTd2bjJxcHpzZGdyNGg1biJ9.JZHNuvBh2_B4bCopgZkXTg';
const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v12',
    center: [-76.53, 3.386],
    zoom: 11
});

// Cuando esté cargado, añadimos la capa WMS de barrios
map.on('load', () => {
    map.addSource('barrios-wms', {
        type: 'raster',
        tiles: [
            'http://34.206.56.11:8080/geoserver/sigweb/wms' +
            '?service=WMS' +
            '&version=1.1.0' +
            '&request=GetMap' +
            '&layers=sigweb:barrios' +
            '&styles=' +
            '&format=image/png' +
            '&transparent=true' +
            '&width=256' +
            '&height=256' +
            '&srs=EPSG:3857' +
            '&bbox={bbox-epsg-3857}'
        ],
        tileSize: 256
    });
    map.addLayer({
        id: 'barrios-layer',
        type: 'raster',
        source: 'barrios-wms',
        paint: { 'raster-opacity': 0.3 }
    });
});

// controles nativos
map.addControl(new mapboxgl.FullscreenControl());
const geo = new mapboxgl.GeolocateControl({
    positionOptions: { enableHighAccuracy: true },
    trackUserLocation: true,
    showUserHeading: true
});
map.addControl(geo);

// marcador
const marker = new mapboxgl.Marker();
function setMarker(lngLat) {
    marker.setLngLat(lngLat).addTo(map);
    document.getElementById('geom').value =
        `SRID=4326;POINT(${lngLat.lng} ${lngLat.lat})`;
}

// 3️⃣ Reverse-geocode para la dirección
function reverseGeocode({ lng, lat }) {
    fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/` +
        `${lng},${lat}.json?access_token=${mapboxgl.accessToken}`
    )
        .then((r) => r.json())
        .then((data) => {
            if (!data.features?.length) return;
            document.getElementById('direccion').value =
                data.features[0].place_name;
        });
}

// 4️⃣ Fetch al WFS de barrios con CQL_FILTER
function fetchBarrio({ lng, lat }) {
    // ✅ CORRECCIÓN: Se cambió 'ubicacion' por 'geom' para que coincida con tu nueva capa.
    const cql = `INTERSECTS(geom, POINT(${lng} ${lat}))`;
    const url = baseWfs + '&cql_filter=' + encodeURIComponent(cql);

    fetch(url)
        .then(r => {
            if (!r.ok) throw new Error(`WFS status ${r.status}`);
            return r.json();
        })
        .then(js => {
            const campo = document.getElementById('barrio');
            if (!js.features || !js.features.length) {
                campo.value = '';
            } else {
                campo.value = js.features[0].properties.nombre;
            }
        })
        .catch(err => {
            console.error('Error al obtener barrio:', err);
        });
}

// 5️⃣ Conecta clic y geolocalización a todo
map.on('click', (e) => {
    setMarker(e.lngLat);
    reverseGeocode(e.lngLat);
    fetchBarrio(e.lngLat);
});
geo.on('geolocate', (ev) => {
    const lngLat = {
        lng: ev.coords.longitude,
        lat: ev.coords.latitude
    };
    setMarker(lngLat);
    reverseGeocode(lngLat);
    fetchBarrio(lngLat);
});