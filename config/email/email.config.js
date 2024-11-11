const { Resend } = require('resend');

class EmailService {
  constructor() {
    this.resend = new Resend(process.env.RESEND_API_KEY);
    this.from = 'Typical Medical Center <no-reply@tmcenter.cl>';
  }

  async sendEmail(to, subject, htmlContent) {
    try {
      const { data, error } = await this.resend.emails.send({
        from: this.from,
        to,
        subject,
        html: htmlContent
      });

      if (error) {
        console.error('Error en Resend:', error);
        throw new Error('Error al enviar el correo');
      }

      console.log('Email enviado exitosamente:', data.id);
      return data;
    } catch (error) {
      console.error('Error al enviar email:', error);
      throw new Error('Error al enviar el correo electrónico');
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
      'Confirmación de Cita Médica',
      html
    );
  }
}

// Crear una instancia del servicio de email
const emailService = new EmailService();

module.exports = emailService;