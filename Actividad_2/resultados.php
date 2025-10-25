<?php
session_start();

if (!isset($_SESSION['ultimo_usuario'])) {
    header('Location: index.php');
    exit;
}

$usuario = $_SESSION['ultimo_usuario'];
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuario Registrado</title>
</head>

<body>
    <div class="container">
        <header>
            <h1>Usuario Validado Exitosamente</h1>
            <p>Los datos son validos.</p>
        </header>

        <div class="resultado-container">
            <div class="success-card">
                <h2>Datos del Usuario Registrado</h2>

                <div class="user-details">
                    <div class="detail-item">
                        <strong>Nombre:</strong>
                        <span><?php echo htmlspecialchars($usuario['nombre']); ?></span>
                    </div>

                    <div class="detail-item">
                        <strong>Email:</strong>
                        <span><?php echo htmlspecialchars($usuario['email']); ?></span>
                    </div>

                    <div class="detail-item">
                        <strong>Edad:</strong>
                        <span><?php echo $usuario['edad']; ?> años</span>
                    </div>

                    <div class="detail-item">
                        <strong>Fecha de Registro:</strong>
                        <span><?php echo $usuario['fecha_registro']; ?></span>
                    </div>
                </div>

            </div>
        </div>
            </div>
        </div>
    </div>

    <?php
    unset($_SESSION['ultimo_usuario']);
    ?>
</body>

</html>