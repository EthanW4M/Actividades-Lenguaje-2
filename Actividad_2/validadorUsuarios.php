<?php
session_start();

class ValidadorUsuarios
{
    private $usuariosValidos = [];
    private $errores = [];

    public function __construct()
    {
        $this->usuariosValidos = [];
        $this->errores = [];
        $this->cargarUsuarios();
    }

    /**
     * Carga los usuarios registrados previamente desde la sesión
     */
    private function cargarUsuarios()
    {
        if (isset($_SESSION['usuarios_registrados']) && is_array($_SESSION['usuarios_registrados'])) {
            $this->usuariosValidos = $_SESSION['usuarios_registrados'];
        } else {
            $this->usuariosValidos = [];
        }
    }

    /**
     * Sanitiza nombres eliminando caracteres peligrosos
     */
    public function sanitizarNombre($nombre)
    {
        if (empty(trim($nombre))) {
            return ['success' => false, 'error' => 'El nombre no puede estar vacío'];
        }

        $nombreLimpio = trim($nombre);

        $caracteresPeligrosos = [';', '"', "'", '--', '<', '>', '(', ')', '\\', '/', '&', '|'];
        $nombreLimpio = str_replace($caracteresPeligrosos, '', $nombreLimpio);

        if (empty($nombreLimpio)) {
            return ['success' => false, 'error' => 'El nombre contiene caracteres peligrosos'];
        }

        if (strlen($nombreLimpio) > 50) {
            $nombreLimpio = substr($nombreLimpio, 0, 50);
        }

        return ['success' => true, 'data' => $nombreLimpio];
    }

    /**
     * Valida y sanitiza email
     */
    public function validarEmail($email)
    {
        if (empty(trim($email))) {
            return ['success' => false, 'error' => 'El email no puede estar vacío'];
        }

        $emailLimpio = trim(strtolower($email));

        if (!filter_var($emailLimpio, FILTER_VALIDATE_EMAIL)) {
            return ['success' => false, 'error' => 'Formato de email inválido'];
        }

        $dominiosPermitidos = ['gmail.com', 'hotmail.com', 'yahoo.com', 'outlook.com'];
        $partes = explode('@', $emailLimpio);
        $dominio = $partes[1] ?? '';

        if (!in_array($dominio, $dominiosPermitidos)) {
            return ['success' => false, 'error' => 'Dominio de email no permitido'];
        }

        return ['success' => true, 'data' => $emailLimpio];
    }

    /**
     * Valida edad
     */
    public function validarEdad($edad)
    {
        if (empty(trim($edad))) {
            return ['success' => false, 'error' => 'La edad no puede estar vacía'];
        }

        if (!is_numeric($edad)) {
            return ['success' => false, 'error' => 'La edad debe ser un número'];
        }

        $edadNumero = (int)$edad;

        if ($edadNumero < 18) {
            return ['success' => false, 'error' => 'Debe ser mayor de 18 años'];
        }

        if ($edadNumero > 120) {
            return ['success' => false, 'error' => 'La edad no puede ser mayor a 120 años'];
        }

        return ['success' => true, 'data' => $edadNumero];
    }

    /**
     * Procesa un usuario individual
     */
    public function procesarUsuario($datosUsuario)
    {
        $errores = [];

        $nombreResult = $this->sanitizarNombre($datosUsuario['nombre'] ?? '');
        $emailResult = $this->validarEmail($datosUsuario['email'] ?? '');
        $edadResult = $this->validarEdad($datosUsuario['edad'] ?? '');

        if (!$nombreResult['success']) $errores[] = $nombreResult['error'];
        if (!$emailResult['success']) $errores[] = $emailResult['error'];
        if (!$edadResult['success']) $errores[] = $edadResult['error'];

        // Si no hay errores, usuario válido
        if (empty($errores)) {
            $usuarioValido = [
                'nombre' => $nombreResult['data'],
                'email' => $emailResult['data'],
                'edad' => $edadResult['data'],
                'fecha_registro' => date('Y-m-d H:i:s')
            ];

            $this->usuariosValidos[] = $usuarioValido;
            return [
                'success' => true,
                'usuario' => $usuarioValido,
                'mensaje' => 'Usuario validado correctamente'
            ];
        } else {
            $this->errores[] = [
                'datos_originales' => $datosUsuario,
                'errores' => $errores
            ];

            return [
                'success' => false,
                'errores' => $errores
            ];
        }
    }

    // Getters para obtener resultados
    public function getUsuariosValidos()
    {
        return $this->usuariosValidos;
    }

    public function getErrores()
    {
        return $this->errores;
    }
}