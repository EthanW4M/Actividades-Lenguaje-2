<?php

require_once 'validadorUsuarios.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $_SESSION['mensaje'] = 'Método no permitido';
    $_SESSION['tipo_mensaje'] = 'error';
    header('Location: index.php');
    exit;
}

$validador = new ValidadorUsuarios();
$resultado = $validador->procesarUsuario($_POST);

if ($resultado['success']) {
    $_SESSION['ultimo_usuario'] = $resultado['usuario'];
    $_SESSION['mensaje'] = 'Usuario registrado exitosamente';
    $_SESSION['tipo_mensaje'] = 'success';
    
    header('Location: resultados.php');
    exit;
} else {
    $_SESSION['errores_validacion'] = $resultado['errores'];
    $_SESSION['datos_formulario'] = $_POST; 
    $_SESSION['mensaje'] = 'Errores en la validación';
    $_SESSION['tipo_mensaje'] = 'error';
    
    header('Location: index.php');
    exit;
}

?>