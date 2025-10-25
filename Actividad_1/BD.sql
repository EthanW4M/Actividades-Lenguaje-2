-- Crear base de datos
CREATE DATABASE IF NOT EXISTS ambulatorio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ambulatorio;

-- =========================
-- Tabla: Pacientes
-- =========================
CREATE TABLE pacientes (
  id_paciente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  cedula VARCHAR(20),
  fecha_nacimiento DATE,
  genero ENUM('M','F','Otro') DEFAULT 'Otro',
  direccion VARCHAR(200),
  telefono VARCHAR(20),
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Tabla: Médicos
-- =========================
CREATE TABLE medicos (
  id_medico INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  cedula VARCHAR(20),
  especialidad VARCHAR(100),
  telefono VARCHAR(20),
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255),
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Tabla: Enfermeros
-- =========================
CREATE TABLE enfermeros (
  id_enfermero INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  cedula VARCHAR(20),
  turno ENUM('mañana','tarde','noche') DEFAULT 'mañana',
  telefono VARCHAR(20),
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255),
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================
-- Tabla: Historial Clínico (1:1 con paciente)
-- =========================
CREATE TABLE historiales_clinicos (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  antecedentes TEXT,
  alergias TEXT,
  grupo_sanguineo VARCHAR(3),
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historial_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
  CONSTRAINT uq_historial_paciente UNIQUE (id_paciente)
) ENGINE=InnoDB;

-- =========================
-- Tabla: Consultas
-- =========================
CREATE TABLE consultas (
  id_consulta INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_medico INT NULL,  -- Cambio importante para permitir ON DELETE SET NULL
  fecha_hora DATETIME NOT NULL,
  motivo TEXT,
  diagnostico TEXT,
  tratamiento TEXT,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
  CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico) REFERENCES medicos(id_medico) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- Tabla: Reportes
-- =========================
CREATE TABLE reportes (
  id_reporte INT AUTO_INCREMENT PRIMARY KEY,
  tipo ENUM('diario','semanal','mensual','trimestral','anual','rango') NOT NULL,
  fecha_inicio DATE,
  fecha_fin DATE,
  id_enfermero INT,
  descripcion TEXT,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_reporte_enfermero FOREIGN KEY (id_enfermero) REFERENCES enfermeros(id_enfermero) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- Tabla intermedia: Consulta_Reporte (N:N)
-- =========================
CREATE TABLE consulta_reporte (
  id_consulta_reporte INT AUTO_INCREMENT PRIMARY KEY,
  id_consulta INT NOT NULL,
  id_reporte INT NOT NULL,
  CONSTRAINT fk_cr_consulta FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE,
  CONSTRAINT fk_cr_reporte FOREIGN KEY (id_reporte) REFERENCES reportes(id_reporte) ON DELETE CASCADE,
  UNIQUE(id_consulta, id_reporte)
) ENGINE=InnoDB;

-- =========================
-- Tabla: Vacunas
-- =========================
CREATE TABLE vacunas (
  id_vacuna INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT
) ENGINE=InnoDB;

-- =========================
-- Tabla: Paciente_Vacuna (N:N + enfermero que aplica)
-- =========================
CREATE TABLE paciente_vacuna (
  id_paciente_vacuna INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_vacuna INT NOT NULL,
  id_enfermero INT NULL,  -- Debe ser NULL para permitir ON DELETE SET NULL
  fecha_aplicacion DATE NOT NULL,
  dosis VARCHAR(50),
  observaciones TEXT,
  CONSTRAINT fk_pv_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
  CONSTRAINT fk_pv_vacuna FOREIGN KEY (id_vacuna) REFERENCES vacunas(id_vacuna) ON DELETE CASCADE,
  CONSTRAINT fk_pv_enfermero FOREIGN KEY (id_enfermero) REFERENCES enfermeros(id_enfermero) ON DELETE SET NULL,
  UNIQUE(id_paciente, id_vacuna, fecha_aplicacion)
) ENGINE=InnoDB;

-- =========================
-- Tabla: Registro_Paciente (N:N Enfermero-Paciente)
-- =========================
CREATE TABLE registro_paciente (
  id_registro INT AUTO_INCREMENT PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_enfermero INT NOT NULL,
  fecha_hora_registro DATETIME NOT NULL,
  CONSTRAINT fk_rp_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
  CONSTRAINT fk_rp_enfermero FOREIGN KEY (id_enfermero) REFERENCES enfermeros(id_enfermero) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- Tabla: Documentos (polimórfica)
-- =========================
CREATE TABLE documentos (
  id_documento INT AUTO_INCREMENT PRIMARY KEY,
  nombre_archivo VARCHAR(255) NOT NULL,
  ruta VARCHAR(500) NOT NULL,
  tipo_mime VARCHAR(100),
  modelo_tipo VARCHAR(50) NOT NULL, -- 'paciente','consulta','reporte'
  modelo_id INT NOT NULL,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_modelo (modelo_tipo, modelo_id)
) ENGINE=InnoDB;
