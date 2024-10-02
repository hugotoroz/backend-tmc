const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const { patientsRouter } = require("./routes/patients.routes.js");

const app = express();
app.use(morgan("dev"));
app.use(express.json());
app.use(cors());

app.use(patientsRouter);

app.use((err, req, res, next) => {
  return res.json({ message: err.message });
});
app.listen(3000);
console.log("Server started on port 3000");
