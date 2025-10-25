# Analisis de requerimientos.

    ¿Quien o quienes usaran el sistema ?

    R= los enfermeros y medicos.

    ¿Que acciones realizara el sistema?

    R= Registro de pacientes, control de vacunación, generación de reportes diarios, registro de atenciones médicas.

    ¿Que informacion se debe guardar?

    R= Datos de pacientes, enfermeros, médicos, fichas médicas, vacunas aplicadas, reportes diarios.

    ¿Que hacen los enfermero?

    R= registra a los pacientes, tomando sus datos basicos y dandole un turno.

    ¿Que hacen los medicos?

    R= realizan las consutas, el diagnostico y actualizan el historial clinico.

    ¿Se generaran reportes?

    R= Si, se generaran reportes de manera diaria, semanal, mensual, trimestral y anual.

    ¿Se vacunara a los pacientes?

    R= Si, siempre y cuando el paciente este calificado para ser vacunado y haya disponibilidad del insumo.


## Modelo de negocio.

    1. el paciente llega al ambulatorio.
    2. el enfermero toma sus datos, lo registra y le asigna su turno.
    3. el paciente espera a su turno.
    4. el medico lo atiende y registra la consulta.
    5. si el paciente aplica, el enfermero vacuna al paciente y hace registro del mismo.
    6. al final del turno, se genera el reporte.´
    7. en cualquier momento, siempre y cuando sea necesario se puede generar un reporte segun sea requerido (diario, semanal, mensual, trimestral, anual).

## Formas Normales.

    las formas normales se han utilizado para evitar duplicidad de datos y asegurar que la integridad de la base de datos sea optima.

    la primera norma se cumple, ya que, todas las tablas tienen campos con nombres simples
    la segunda norma se cumple, puesto que, en la tabla consulta_reporte la clave es compuesta y no hay campos que dependan solo de uno de ellos.
    y por ultimo, la tercera norma se cumple ya que no hay dependecias transitivas


## Estructura E/R conceptual.

    ENTIDADES PRINCIPALES:
    - Paciente
    - Historial Clínico
    - Enfermero
    - Médico
    - Consulta
    - Reporte
    - Vacuna
    - Paciente_Vacuna (relación)
    - Consulta_Reporte (relación)
    - Registro_Paciente
    - Documento (polimórfica)

        RELACIONES Y CARDINALIDADES:

        Paciente 1 —— 1 Historial_Clínico

        Paciente 1 —— N Registro_Paciente N —— 1 Enfermero

        Paciente 1 —— N Consulta N —— 1 Médico

        Consulta N —— N Reporte  (mediante tabla Consulta_Reporte)

        Paciente N —— N Vacuna (aplicada por un Enfermero) → tabla Paciente_Vacuna

        Tabla Documentos (Relación polimórfica):
        Documento puede pertenecer a:
        - Paciente
        - Consulta
        - Reporte
        modelo_tipo = 'paciente'/'consulta'/'reporte'
        modelo_id = id de la entidad asociada

## Documentacion de cada tabla.

- tabla pacientes
    esta tabla registra los datos personales de cada paciente.

| Campo            | Tipo      | Descripción            |
| ---------------- | --------- | ---------------------- |
| id_paciente      | INT       | Identificador único    |
| nombre, apellido | VARCHAR   | Datos personales       |
| cedula           | VARCHAR   | Documento de identidad |
| fecha_nacimiento | DATE      | Fecha de nacimiento    |
| genero           | ENUM      | Sexo o identidad       |
| direccion        | VARCHAR   | Lugar de residencia    |
| telefono         | VARCHAR   | Contacto               |
| creado_en        | TIMESTAMP | Fecha de registro      |

- tabla medicos
    esta tabla pertence al personal profesional encargado de consultar, recetar y diagnosticar a los pacientes.

| Campo            | Tipo      | Descripción       |
| ---------------- | --------- | ----------------- |
| id_medico        | INT       | ID de médico      |
| nombre, apellido | VARCHAR   | Datos personales  |
| cedula           | VARCHAR   | Identificación    |
| especialidad     | VARCHAR   | Área médica       |
| telefono, email  | VARCHAR   | Contacto          |
| password         | VARCHAR   | Acceso al sistema |
| creado_en        | TIMESTAMP | Registro          |

- tabla enfermeros
    encargados de registrar a los pacientes, realizar vacunacion y generar reportes.

    | Campo            | Tipo                           |
| ---------------- | ------------------------------ |
| id_enfermero     | INT                            |
| nombre, apellido | VARCHAR                        |
| cedula           | VARCHAR                        |
| turno            | ENUM('mañana','tarde','noche') |
| telefono, email  | VARCHAR                        |
| password         | VARCHAR                        |
| creado_en        | TIMESTAMP                      |

- tabla historiales_clinicos
    tabla donde se almacena el historial clinico de cada paciente

| Campo           | Descripción            |
| --------------- | ---------------------- |
| id_historial    | Identificador          |
| id_paciente     | FK a paciente          |
| antecedentes    | Enfermedades previas   |
| alergias        | Sustancias que afectan |
| grupo_sanguineo | Tipo de sangre         |

- tabla consultas
    un paciente puede tener muchas consultas y a su vez un medico puede hacer muchas consultas, en esta tabla se lleva ese registro

| Campo       | Descripción             |
| ----------- | ----------------------- |
| id_consulta | ID                      |
| id_paciente | Paciente atendido       |
| id_medico   | Médico que atendió      |
| fecha_hora  | Fecha consulta          |
| motivo      | Síntoma                 |
| diagnostico | Resultado médico        |
| tratamiento | Medicación o indicación |
| creado_en   | Timestamp               |

- tabla reportes
    tabla asignada al registro de los reportes generados por los enfermeros

| Campo                   | Descripción          |
| ----------------------- | -------------------- |
| id_reporte              | ID                   |
| tipo                    | Diario, semanal, etc |
| fecha_inicio, fecha_fin | Periodo              |
| id_enfermero            | Quién lo genera      |
| descripcion             | Resumen              |
| creado_en               | Registro             |

- tabla consulta_reporte 
    tabla que permite que una consulte este en varios reportes y que un reporte contenga varias consultas.

- tabla vacunas
    donde se registran las vacunas disponibles.

| Campo       | Descripción |
| ----------- | ----------- |
| id_vacuna   | ID          |
| nombre      | Tipo vacuna |
| descripcion | Detalle     |

- tabla paciente_vacuna
    tabla que relaciona 3 entidades

| Campo            | Explicación  |
| ---------------- | ------------ |
| id_paciente      | Quién recibe |
| id_vacuna        | Qué vacuna   |
| id_enfermero     | Quién aplica |
| fecha_aplicacion | Cuándo       |
| dosis            | Cantidad     |
| observaciones    | Extra        |

- tabla registro_paciente
    tabla que guarda que enfermero atendio a que paciente al entrar.

| Campo               | Descripción               |
| ------------------- | ------------------------- |
| id_paciente         | Paciente registrado       |
| id_enfermero        | Enfermero que lo registró |
| fecha_hora_registro | Momento del ingreso       |

- tabla documentos
    tabla polimorfica donde se guardan los documentos

| Campo          | Explicación                       |
| -------------- | --------------------------------- |
| nombre_archivo | Nombre real del archivo           |
| ruta           | Dirección donde está guardado     |
| modelo_tipo    | 'paciente', 'consulta', 'reporte' |
| modelo_id      | ID correspondiente                |


## Documentacion de las relaciones.

| Relación                        | Tipo                     | Justificación                                                                                                                         |
| ------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| Paciente – Historial            | 1:1                      | Cada paciente tiene solo un historial clínico único.                                                                                  |
| Paciente – Consulta – Médico    | 1:N y N:1                | Un paciente puede tener varias consultas; una consulta la realiza solo un médico.                                                     |
| Consulta – Reporte              | N:N                      | Una consulta puede aparecer en varios reportes (diario/semanal) y un reporte contiene múltiples consultas.                            |
| Paciente – Vacuna – Enfermero   | N:N con tabla asociativa | Un paciente puede recibir varias vacunas; cada vacuna puede aplicarse a muchos pacientes; y debe registrarse qué enfermero la aplicó. |
| Paciente – Enfermero (registro) | N:N                      | Distintos enfermeros pueden registrar pacientes en diferentes días.                                                                   |
| Documentos polimórficos         | Polimórfica              | Permite almacenar archivos vinculados a diferentes entidades sin repetir tablas.                                                      |
