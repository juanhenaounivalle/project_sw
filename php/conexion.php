<?php
// php/conexion.php
$host     = 'localhost';
$dbname   = 'project_sw';
$user     = 'postgres';
$password = 'p';

// Conectamos y comprobamos
$conexion = pg_connect("host={$host} dbname={$dbname} user={$user} password={$password}");
if (!$conexion) {
    die("Error al conectar a la base de datos: " . pg_last_error());
}
