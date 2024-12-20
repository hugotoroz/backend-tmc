const { pool } = require("../config/database.js");
const { AppError } = require("../middleware/errors.middleware");
const { APPOINTMENTS_STATUS } = require("../constants/users.constant");
const { encryptPassword } = require("../config/password");
const emailService = require("../config/email/email.config.js");

const getAll = async (req, res, next) => {
  return await pool.query("SELECT * FROM public.pacientes WHERE is_active = 1");
};
const getOne = async (req, res, next) => {
  return await pool.query("SELECT * FROM usuarios WHERE id = $1", [
    req.params.id,
  ]);
};
const getAllObservations = async (req, res, next) => {
  try {
    // 1. Obtener todas las citas, incluyendo las sin observaciones
    const appointments = await pool.query(
      `
      SELECT 
        cm.id_cita,
        cm.fecha,
        o.observacion
      FROM citas_medicas cm 
      LEFT JOIN observaciones o ON cm.id_cita = o.fk_cita_id 
      WHERE cm.id_paciente = $1
      ORDER BY cm.fecha DESC
    `,
      [req.params.id]
    );

    // 2. Obtener todos los documentos de todas las citas en una sola consulta
    const allDocuments = await pool.query(
      `
      SELECT 
        d.id as id_documento,
        d.fk_cita_id as id_cita,
        d.fk_tipo_documento_id as id_tipo_documento,
        td.nom as tipo_documento,
        d.src as src
      FROM documentos d 
      JOIN tipos_documento td ON d.fk_tipo_documento_id = td.id
      WHERE d.fk_cita_id IN (
        SELECT id_cita FROM citas_medicas 
        WHERE id_paciente = $1
      )
    `,
      [req.params.id]
    );

    // 3. Crear un mapa de documentos por id_cita
    const documentsByAppointment = allDocuments.rows.reduce((acc, doc) => {
      if (!acc[doc.id_cita]) {
        acc[doc.id_cita] = [];
      }
      acc[doc.id_cita].push(doc);
      return acc;
    }, {});

    // 4. Asignar los documentos a cada cita
    const appointmentsWithDocs = appointments.rows.map((appointment) => ({
      ...appointment,
      documents: documentsByAppointment[appointment.id_cita] || [],
    }));

    return {
      rows: appointmentsWithDocs,
    };
  } catch (error) {
    throw new Error(
      `Error al obtener las citas y documentos: ${error.message}`
    );
  }
};

// MODEL
const getAllDocuments = async (patientId, filters = {}) => {
  try {
    // Construir la consulta base para las citas
    let appointmentQuery = `
      SELECT DISTINCT
        cm.id_cita,
        cm.fecha,
        cm.nombre_doctor,
        cm.id_especialidad,
        cm.nombre_especialidad
      FROM citas_medicas cm 
      JOIN observaciones o ON cm.id_cita = o.fk_cita_id 
    `;

    // Si hay un filtro de tipo de documento, necesitamos unir con la tabla documentos
    if (filters.id_tipo_documento) {
      appointmentQuery += `
        JOIN documentos d ON cm.id_cita = d.fk_cita_id
        WHERE cm.id_paciente = $1
        AND d.fk_tipo_documento_id = $2
      `;
    } else {
      appointmentQuery += `
        WHERE cm.id_paciente = $1
      `;
    }

    // Array para almacenar los parámetros de la consulta
    const queryParams = [patientId];
    let paramCounter = 2; // Comenzamos desde 2 porque $1 ya está usado

    // Agregar el parámetro de tipo de documento si existe
    if (filters.id_tipo_documento) {
      queryParams.push(filters.id_tipo_documento);
      paramCounter++;
    }

    // Agregar otros filtros a la consulta de citas si existen
    if (filters.fecha) {
      appointmentQuery += ` AND DATE(cm.fecha) = $${paramCounter}`;
      queryParams.push(filters.fecha);
      paramCounter++;
    }

    if (filters.id_especialidad) {
      appointmentQuery += ` AND cm.id_especialidad = $${paramCounter}`;
      queryParams.push(filters.id_especialidad);
      paramCounter++;
    }

    appointmentQuery += ` ORDER BY cm.fecha DESC`;

    // 1. Obtener todas las citas con sus observaciones
    const appointments = await pool.query(appointmentQuery, queryParams);

    // 2. Obtener documentos solo para las citas encontradas
    let documentsQuery = `
      SELECT 
        d.id as id_documento,
        d.fk_cita_id as id_cita,
        d.fk_tipo_documento_id as id_tipo_documento,
        td.nom as tipo_documento,
        d.src as src
      FROM documentos d 
      JOIN tipos_documento td ON d.fk_tipo_documento_id = td.id
      WHERE d.fk_cita_id = ANY($1::int[])
    `;

    const citaIds = appointments.rows.map((app) => app.id_cita);

    // Parámetros para la consulta de documentos
    const documentQueryParams = [citaIds];

    // Agregar filtro de tipo de documento si existe
    if (filters.id_tipo_documento) {
      documentsQuery += ` AND d.fk_tipo_documento_id = $2`;
      documentQueryParams.push(filters.id_tipo_documento);
    }

    const allDocuments = await pool.query(documentsQuery, documentQueryParams);

    // 3. Crear un mapa de documentos por id_cita
    const documentsByAppointment = allDocuments.rows.reduce((acc, doc) => {
      if (!acc[doc.id_cita]) {
        acc[doc.id_cita] = [];
      }
      acc[doc.id_cita].push(doc);
      return acc;
    }, {});

    // 4. Asignar los documentos a cada cita y filtrar las citas sin documentos
    const appointmentsWithDocs = appointments.rows
      .map((appointment) => ({
        ...appointment,
        documents: documentsByAppointment[appointment.id_cita] || [],
      }))
      .filter((appointment) => appointment.documents.length > 0);

    return {
      rows: appointmentsWithDocs,
    };
  } catch (error) {
    throw new Error(
      `Error al obtener las citas y documentos: ${error.message}`
    );
  }
};

const create = async (patient) => {
  try {
    // Encrypt the password
    const hashedPassword = await encryptPassword(patient.password);
    // Look the RUT in the database
    const rutExist = await pool.query("SELECT * FROM usuarios WHERE rut = $1", [
      patient.rut.toLowerCase(),
    ]);
    if (rutExist.rows.length > 0) {
      throw new AppError("El RUT ya está registrado", 400);
    }
    // Look the email in the database
    const emailExist = await pool.query(
      "SELECT * FROM usuarios WHERE email = $1",
      [patient.email.toLowerCase()]
    );
    if (emailExist.rows.length > 0) {
      throw new AppError("El email ya está registrado", 400);
    }
    // Insert the patient into the database
    const insertPatient = await pool.query(
      "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, genero, is_active, is_row) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 1, 1) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS full, telefono, fec_nacimiento",
      [
        patient.rut.toLowerCase(),
        patient.email.toLowerCase(),
        hashedPassword,
        patient.name,
        patient.patSurName,
        patient.matSurName,
        patient.dateBirth,
        patient.cellphone,
        patient.genre,
      ]
    );
    // Return the patient data
    const { id, rut, email, full, telefono, fec_nacimiento } =
      insertPatient.rows[0];
    // Insert the patient role
    await pool.query(
      "INSERT INTO usuario_rol (fk_usuario_id, fk_rol_id) VALUES ($1, $2)",
      [id, 3]
    );
    const json = { rut: rut, full: full, telefono: telefono, email: email };
    console.log(json);
    // Send the email
    emailService.sendWelcomeEmail(json);

    // Return the patient data
    return { id, rut, email, full, roleId: 3, telefono, fec_nacimiento };
  } catch (error) {
    throw new AppError(error.message, error.statusCode);
  }
};

const saveDocument = async (patient, url) => {
  try {
    const { appointmentId, documentTypeId } = patient;
    const insertDocument = await pool.query(
      "INSERT INTO documentos (fk_cita_id, fk_tipo_documento_id, src) VALUES ($1, $2, $3) RETURNING fk_cita_id, fk_tipo_documento_id, src",
      [appointmentId, documentTypeId, url]
    );
    return insertDocument.rows[0];
  } catch (error) {
    throw new AppError(error.message, error.statusCode);
  }
};

const cancelAppointment = async (appointment) => {
  try {
    // Buscar la cita
    const appointmentExist = await pool.query(
      "SELECT * FROM citas WHERE id = $1",
      [appointment.appointmentId]
    );
    // Validar que la cita exista
    if (appointmentExist.rows.length === 0) {
      throw new AppError("La cita no existe", 404);
    }
    // Obtener fk_estado_cita_id
    const appointmentStatus = appointmentExist.rows[0].fk_estado_cita_id;
    // Validar que la cita no haya sido cancelada por el doctor o por el paciente
    if (
      appointmentStatus == APPOINTMENTS_STATUS.CANCELLED_BY_DOCTOR ||
      appointmentStatus == APPOINTMENTS_STATUS.CANCELLED_BY_PATIENT
    ) {
      throw new AppError("La cita ya fue cancelada", 400);
    }
    // Validar que una cita completada o en curso no pueda ser cancelada
    if (
      appointmentStatus == APPOINTMENTS_STATUS.COMPLETED ||
      appointmentStatus == APPOINTMENTS_STATUS.IN_PROGRESS
    ) {
      throw new AppError(
        "La cita no puede ser cancelada porque está completada o en progreso",
        400
      );
    }
    // Cancelar la cita
    await pool.query(
      "UPDATE citas SET fk_estado_cita_id = $1 WHERE id = $2",
      [APPOINTMENTS_STATUS.CANCELLED_BY_PATIENT, appointment.appointmentId]
    );

    return { status: "success", message: "Cita cancelada exitosamente" };
  } catch (error) {
    throw new AppError(error.message, 500);
  }
};

module.exports = {
  getAll,
  getOne,
  getAllObservations,
  getAllDocuments,
  create,
  saveDocument,
  cancelAppointment,
};
