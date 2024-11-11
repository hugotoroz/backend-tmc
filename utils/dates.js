const meses = [
  "", // índice 0 vacío para que coincida con los meses del 1-12
  "enero",
  "febrero",
  "marzo",
  "abril",
  "mayo",
  "junio",
  "julio",
  "agosto",
  "septiembre",
  "octubre",
  "noviembre",
  "diciembre",
];

const formatearFecha = (fecha) => {
  try {
    let dia, mes, año;

    // Si la fecha es un string (formato "YYYY-MM-DD")
    if (typeof fecha === "string") {
      [año, mes, dia] = fecha.split("-");
    }
    // Si la fecha es un objeto Date
    else if (fecha instanceof Date) {
      dia = fecha.getDate().toString();
      mes = (fecha.getMonth() + 1).toString(); // getMonth() retorna 0-11
      año = fecha.getFullYear().toString();
    }
    // Si no es ninguno de los anteriores, lanzar error
    else {
      throw new Error("Formato de fecha no válido");
    }

    // Convertir a números para eliminar ceros a la izquierda
    dia = parseInt(dia, 10);
    mes = parseInt(mes, 10);

    // Validar que los valores sean correctos
    if (
      isNaN(dia) ||
      isNaN(mes) ||
      isNaN(año) ||
      mes < 1 ||
      mes > 12 ||
      dia < 1 ||
      dia > 31
    ) {
      throw new Error("Fecha inválida");
    }

    return `${dia} de ${meses[mes]} de ${año}`;
  } catch (error) {
    console.error("Error al formatear fecha:", error);
    throw new Error(`Error al formatear la fecha: ${error.message}`);
  }
};

module.exports = {
  formatearFecha,
};
