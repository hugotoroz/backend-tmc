const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const { patientsRouter } = require("./routes/patients.routes.js");
const { doctorsRouter } = require("./routes/doctors.routes.js");
const { usersRouter } = require("./routes/users.routes.js");

const app = express();
app.use(morgan("dev"));
app.use(express.json());
app.use(cors());

// Routes
app.use(patientsRouter);
app.use(usersRouter);
app.use(doctorsRouter);

// Error handling
app.use((err, req, res, next) => {
  // Log the error
  console.error(err.stack);
  // Return a 500 status code and the error message
  res.status(500).json({ status: "error", data: err.message });
});

// Iniciar el servidor
app.listen(process.env.PORT, () => {
  console.log("Server started on port " + process.env.PORT);
});
