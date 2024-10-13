# Endpoints

## USUARIOS

### Obtener datos de una persona

- **Método:** GET
- **Ruta:** /user/data
- **Respuesta:** Datos de una persona.

* **Parámetros (JSON):**

```json
{
  "rut": "12345678-k"
}
```

- **Respuesta (JSON):**

```json
{
  "status": "success",
  "data": {
    "name": "PRIMER_NOMBRE SEGUNDO_NOMBRE",
    "father_lastname": "APELLIDO_PATERNO",
    "mother_lastname": "APELLIDO_MATERNO",
    "date_of_birth": "09-01-2002",
    "age": "EDAD",
    "gender": "GENERO",
    "nationality": "NACIONALIDAD",
    "marital_status": "ESTADO_CIVIL"
  }
}
```
### Validar Número de Documento de una persona.

- **Método:** GET
- **Ruta:** /user/validate
- **Respuesta:** Si Numero de documento es válido y vigencia del carnet.

* **Parámetros (JSON):**

```json
{
  "rut": "12345678-k",
  "numDoc": "123456789"
}
```

- **Respuesta (JSON):**

```json
{
  "status": "success",
  "data": {
    "codigo": "200",
    "status": "OK",
    "caseid": "91526cb4-5480-4289-b7ca-0012231b9674",
    "extranjero": "0",
    "mensaje": "Vigente",
    "value": "1"
  }
}
```

## PACIENTES

### Obtener todos los pacientes

- **Método:** GET
- **Ruta:** /patients
- **Respuesta:** Datos de todos los pacientes.
- **Parámetros:** Auth Bearer Token.

### Obtener un paciente por ID

- **Método:** GET
- **Ruta:** /patients/:id
- **Respuesta:** Datos de un paciente
- **Parámetros:** Auth Bearer Token.

### Crear paciente

- **Método:** POST
- **Ruta:** /patients

* **Parámetros (JSON):**

```json
{
  "RUT": "12345678-k",
  "email": "hugotoro@gmail.com",
  "password": "123",
  "name": "Hugo",
  "patSurName": "Toro",
  "matSurName": "Zúñiga",
  "dateBirth": "2024-01-09",
  "cellphone": "912345678"
}
```

- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.

## DOCTORES

### Obtener todos los doctores

- **Método:** GET
- **Ruta:** /doctors
- **Respuesta:** Datos de todos los doctores.
- **Parámetros:** Auth Bearer Token.

### Obtener un doctor por ID

- **Método:** GET
- **Ruta:** /patients/:id
- **Respuesta:** Datos de un paciente
- **Parámetros:** Auth Bearer Token.

### Crear Doctor