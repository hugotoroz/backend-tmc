# Endpoints

## PACIENTES

- **Método:** GET
- **Ruta:** /patients
- **Respuesta:** Datos de todos los pacientes.
- **Parámetros:** Auth Bearer Token.

- **Método:** GET
- **Ruta:** /patients/:id
- **Respuesta:** Datos de un paciente
- **Parámetros:** Auth Bearer Token.

- **Método:** POST
- **Ruta:** /patients
* **Parámetros (JSON):**
```json
{
  "RUT": "12345678-k",
  "password": "123",
  "name": "Hugo",
  "patSurName": "Toro",
  "matSurName": "Zúñiga",
  "dateBirth": "2024-01-09",
  "cellphone": "912345678",
}
```
- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.

## DOCTORES

- **Método:** GET
- **Ruta:** /doctors
- **Respuesta:** Datos de todos los doctores.
- **Parámetros:** Auth Bearer Token.
