const { pool } = require("../config/database.js");
const { encryptPassword } = require("../config/password");

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
    // 1. Obtener todas las citas con sus observaciones
    const appointments = await pool.query(`
      SELECT 
        cm.id_cita,
        cm.fecha,
        o.observacion
      FROM citas_medicas cm 
      JOIN observaciones o ON cm.id_cita = o.fk_cita_id 
      WHERE id_paciente = $1
      ORDER BY cm.fecha DESC
    `, [req.params.id]);

    // 2. Obtener todos los documentos de todas las citas en una sola consulta
    const allDocuments = await pool.query(`
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
    `, [req.params.id]);

    // 3. Crear un mapa de documentos por id_cita
    const documentsByAppointment = allDocuments.rows.reduce((acc, doc) => {
      if (!acc[doc.id_cita]) {
        acc[doc.id_cita] = [];
      }
      acc[doc.id_cita].push(doc);
      return acc;
    }, {});

    // 4. Asignar los documentos a cada cita
    const appointmentsWithDocs = appointments.rows.map(appointment => ({
      ...appointment,
      documents: documentsByAppointment[appointment.id_cita] || []
    }));

    return {
      rows: appointmentsWithDocs
    };
  } catch (error) {
    throw new Error(`Error al obtener las citas y documentos: ${error.message}`);
  }
  
};
const create = async (patient) => {
  // Encrypt the password
  const hashedPassword = await encryptPassword(patient.password);
  // Look the RUT in the database
  const rutExist = await pool.query("SELECT * FROM usuarios WHERE rut = $1", [
    patient.rut,
  ]);
  if (rutExist.rows.length > 0) {
    return { status: "error", message: "El RUT ya está registrado" };
  }
  // Look the email in the database
  const emailExist = await pool.query(
    "SELECT * FROM usuarios WHERE email = $1",
    [patient.email]
  );
  if (emailExist.rows.length > 0) {
    return { status: "error", message: "El correo ya está registrado" };
  }
  // Insert the patient into the database
  const insertPatient = await pool.query(
    "INSERT INTO usuarios (rut, email, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, genero, is_active, is_row) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 1, 1) RETURNING id,rut, email, CONCAT(nom ,' ', ap_paterno,' ', ap_materno) AS full",
    [
      patient.rut,
      patient.email,
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
  const { id, rut, email, full } = insertPatient.rows[0];
  // Insert the patient role
  await pool.query(
    "INSERT INTO usuario_rol (fk_usuario_id, fk_rol_id) VALUES ($1, $2)",
    [id, 3]
  );

  // Return the patient data
  return { id, rut, email, full, role: "paciente" };
};

module.exports = { getAll, getOne,getAllObservations, create };
