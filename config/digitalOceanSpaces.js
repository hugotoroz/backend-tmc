// config/spaces.config.js
const { S3Client } = require("@aws-sdk/client-s3");
const multer = require("multer");
const {
  region,
  endpoint,
} = require("../constants/digitalOceanSpaces.constant");

// Configurar el cliente S3
const spacesEndpoint = new S3Client({
  endpoint: endpoint,
  region: region,
  credentials: {
    accessKeyId: process.env.DO_ACCESS_KEY,
    secretAccessKey: process.env.DO_SECRET_KEY,
  },
});

// Configurar multer para aceptar solo PDFs
const upload = multer({
  storage: multer.memoryStorage(),
  fileFilter: (req, file, cb) => {
    if (file.mimetype === "application/pdf") {
      cb(null, true);
    } else {
      cb(new Error("Solo se permiten archivos PDF"), false);
    }
  },
  limits: {
    fileSize: 5 * 1024 * 1024, // Límite de 5MB
  },
});

module.exports = {
  spacesClient: spacesEndpoint,
  upload,
};
