const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const path = require('path');
const { patientsRouter } = require("./routes/patients.routes.js");
const { doctorsRouter } = require("./routes/doctors.routes.js");
const { usersRouter } = require("./routes/users.routes.js");
const { appointmentsRouter } = require("./routes/appointments.routes.js");
const {
  globalErrorHandler,
  notFound,
} = require("./middleware/errors.middleware.js");

const app = express();

// Middleware globales
app.use(morgan("dev"));
app.use(express.json());
app.use(cors());
app.use(express.static('assets'));
// Routes
app.use("/api/patients", patientsRouter);
app.use("/api/user", usersRouter);
app.use("/api/doctors", doctorsRouter);
app.use("/api/appointments", appointmentsRouter);

// Health check
app.get("/api", (req, res) => {
  res.sendFile(path.join(__dirname, 'assets', 'index.html'));
});

// Manejo de rutas no encontradas
app.use(notFound);

// Manejo global de errores
app.use(globalErrorHandler);

// Iniciar el servidor
app.listen(process.env.PORT, () => {
  console.log("Server started on port " + process.env.PORT);
});
