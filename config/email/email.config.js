const { Resend } = require("resend");
// AppError
const { AppError } = require("../../middleware/errors.middleware");

class EmailService {
  constructor() {
    this.resend = new Resend(process.env.RESEND_API_KEY);
    this.from = "Typical Medical Center <no-reply@tmcenter.cl>";
  }

  async sendEmail(to, subject, htmlContent) {
    try {
      const { data, error } = await this.resend.emails.send({
        from: this.from,
        to,
        subject,
        html: htmlContent,
      });

      if (error) {
        console.error("Error en Resend:", error);
        throw new AppError("Error al enviar el correo electrónico", 500);
      }

      console.log("Email enviado exitosamente:", data.id);
      return data;
    } catch (error) {
      console.error("Error al enviar email:", error);
      throw new AppError("Error al enviar el correo electrónico", 500);
    }
  }

  // Método específico para enviar confirmación de cita
  async sendAppointmentConfirmation(appointmentData) {
    const html = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>Confirmación de Cita</title>
        </head>
        <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f6f9fc;">
          <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h2 style="color: #2d3748; margin-bottom: 20px;">Confirmación de Cita Médica</h2>
            
            <p style="color: #4a5568;">Estimado/a ${appointmentData.patientName},</p>
            
            <p style="color: #4a5568;">Su cita ha sido confirmada con los siguientes detalles:</p>
            
            <div style="background-color: #f7fafc; padding: 15px; border-radius: 5px; margin: 20px 0;">
              <p style="margin: 5px 0;"><strong>Fecha:</strong> ${appointmentData.date}</p>
              <p style="margin: 5px 0;"><strong>Hora:</strong> ${appointmentData.time}</p>
              <p style="margin: 5px 0;"><strong>Doctor:</strong> ${appointmentData.doctorName}</p>
              <p style="margin: 5px 0;"><strong>Especialidad:</strong> ${appointmentData.specialty}</p>
            </div>

            <p style="color: #4a5568; margin-top: 20px;">Por favor, recuerde:</p>
            <ul style="color: #4a5568;">
              <li>Llegar 15 minutos antes de su cita</li>
              <li>Traer su identificación</li>
              <li>Usar mascarilla dentro de las instalaciones</li>
            </ul>

            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
              <p style="color: #718096; font-size: 12px;">Este es un correo automático, por favor no responda a este mensaje.</p>
            </div>
          </div>
        </body>
      </html>
    `;

    return await this.sendEmail(
      appointmentData.patientEmail,
      "Confirmación de Cita Médica",
      html
    );
  }
  // Método específico para enviar registro de usuario
  async sendWelcomeEmail(userData) {
    const html = `
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>Bienvenido a Typical Medical Center</title>
      </head>
      <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f6f9fc;">
        <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
          <div style="text-align: center; margin-bottom: 20px;">
            <h1 style="color: #2d3748;">Bienvenido a Typical Medical Center</h1>
            <p style="color: #4a5568; font-size: 16px;">Tu cuenta ha sido creada con éxito</p>
          </div>
          
          <div style="background-color: #f7fafc; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <p style="color: #4a5568; margin: 5px 0;"><strong>RUT:</strong> ${userData.rut}</p>
            <p style="color: #4a5568; margin: 5px 0;"><strong>Nombre:</strong> ${userData.full}</p>
            <p style="color: #4a5568; margin: 5px 0;"><strong>Teléfono:</strong> ${userData.telefono}</p>
          </div>
  
          <div style="color: #4a5568; margin-bottom: 20px;">
            <h3 style="color: #2d3748;">Próximos Pasos</h3>
            <ul style="padding-left: 20px;">
              <li>Completa tu perfil de paciente con tu dirección</li>
              <li>Agenda una consulta</li>
              <li>Explora nuestros servicios médicos</li>
            </ul>
          </div>
  
          <div style="background-color: #e6f2ff; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h3 style="color: #2c5282; margin-top: 0;">Accede a tu Portal de Pacientes</h3>
            <p style="color: #4a5568;">
              Puedes iniciar sesión en nuestro portal web para gestionar tus citas, 
              ver historial médico y más.
            </p>
            <a href="https://tmcenter.cl/login" style="
              display: inline-block;
              background-color: #3182ce;
              color: white;
              padding: 10px 20px;
              text-decoration: none;
              border-radius: 5px;
              margin-top: 10px;
            ">Iniciar Sesión</a>
          </div>
  
          <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0; text-align: center;">
            <p style="color: #718096; font-size: 12px;">
              Si no has creado esta cuenta, por favor contáctanos.
            </p>
            <p style="color: #718096; font-size: 12px;">
              © 2024 Typical Medical Center. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </body>
    </html>
  `;
    return await this.sendEmail(
      userData.email,
      "Bienvenido a Typical Medical Center",
      html
    );
  }
  // Método específico para enviar cancelación de cita por paciente
  async sendAppointmentCancellationByPatient(appointmentData) {
    const html = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>Cancelación de Cita Médica</title>
        </head>
        <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f6f9fc;">
          <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h2 style="color: #2d3748; margin-bottom: 20px; text-align: center;">Cancelación de Cita Médica</h2>
            
            <div style="background-color: #f7fafc; padding: 15px; border-radius: 5px; margin: 20px 0;">
              <p style="color: #4a5568;">Estimado/a ${appointmentData.doctorName},</p>
              
              <p style="color: #4a5568;">El paciente <strong>${appointmentData.patientName}</strong> ha cancelado su cita médica programada.</p>
              
              <div style="background-color: #ffffff; padding: 15px; border-radius: 5px; margin: 20px 0; border: 1px solid #e2e8f0;">
                <p style="margin: 5px 0;"><strong>Fecha:</strong> ${appointmentData.date}</p>
                <p style="margin: 5px 0;"><strong>Hora:</strong> ${appointmentData.time}</p>
                <p style="margin: 5px 0;"><strong>Especialidad:</strong> ${appointmentData.specialty}</p>
              </div>
  
              <p style="color: #4a5568;">Por favor, revisar su agenda para reprogramar o reasignar este espacio.</p>
            </div>
  
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0; text-align: center;">
              <p style="color: #718096; font-size: 12px;">Este es un correo automático de notificación.</p>
              <p style="color: #718096; font-size: 12px;">© 2024 Typical Medical Center. Todos los derechos reservados.</p>
            </div>
          </div>
        </body>
      </html>
    `;

    return await this.sendEmail(
      appointmentData.doctorEmail,
      "Cancelación de Cita Médica por Paciente",
      html
    );
  }
  // Método específico para enviar cancelación de cita por doctor
  async sendAppointmentCancellationByDoctor(appointmentData) {
    const html = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>Cancelación de Cita Médica</title>
        </head>
        <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f6f9fc;">
          <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h2 style="color: #2d3748; margin-bottom: 20px; text-align: center;">Cancelación de Cita Médica</h2>
            
            <div style="background-color: #f7fafc; padding: 15px; border-radius: 5px; margin: 20px 0;">
              <p style="color: #4a5568;">Estimado/a ${
                appointmentData.patientName
              },</p>
              
              <p style="color: #4a5568;">Lamentamos informarle que su cita médica ha sido cancelada.</p>
              
              <div style="background-color: #ffffff; padding: 15px; border-radius: 5px; margin: 20px 0; border: 1px solid #e2e8f0;">
                <p style="margin: 5px 0;"><strong>Fecha:</strong> ${
                  appointmentData.date
                }</p>
                <p style="margin: 5px 0;"><strong>Hora:</strong> ${
                  appointmentData.time
                }</p>
                <p style="margin: 5px 0;"><strong>Doctor:</strong> ${
                  appointmentData.doctorName
                }</p>
                <p style="margin: 5px 0;"><strong>Especialidad:</strong> ${
                  appointmentData.specialty
                }</p>
              </div>
  
              <p style="color: #4a5568;">Razón de la cancelación: ${
                appointmentData.cancellationReason ||
                "No se proporcionó una razón específica"
              }</p>
  
              <div style="background-color: #e6f2ff; padding: 15px; border-radius: 5px; margin: 20px 0;">
                <h3 style="color: #2c5282; margin-top: 0;">Próximos Pasos</h3>
                <p style="color: #4a5568;">
                  Por favor, comuníquese con nuestra recepción para reprogramar su cita o para más información.
                </p>
                <a href="https://tmcenter.cl/aboutUs" style="
                  display: inline-block;
                  background-color: #3182ce;
                  color: white;
                  padding: 10px 20px;
                  text-decoration: none;
                  border-radius: 5px;
                  margin-top: 10px;
                ">Contactar Recepción</a>
              </div>
            </div>
  
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e2e8f0; text-align: center;">
              <p style="color: #718096; font-size: 12px;">Nos disculpamos por cualquier inconveniente.</p>
              <p style="color: #718096; font-size: 12px;">© 2024 Typical Medical Center. Todos los derechos reservados.</p>
            </div>
          </div>
        </body>
      </html>
    `;

    return await this.sendEmail(
      appointmentData.patientEmail,
      "Cancelación de Cita Médica",
      html
    );
  }
}

// Crear una instancia del servicio de email
const emailService = new EmailService();

module.exports = emailService;
