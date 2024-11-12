# Endpoints

## USUARIOS

### Login

- **Método:** POST
- **Ruta:** /user/login

* **Parámetros (JSON):**

```json
{
  "rut": "12345678-k",
  "password": "123"
}
```

- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.

### Obtener datos de una persona

- **Método:** POST
- **Ruta:** api/user/data
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

- **Método:** POST
- **Ruta:** api/user/validate
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

### Actualizar datos de un Usuario (telefono o mail)

- **Método:** PUT
- **Ruta:** api/user/update
- **Respuesta:** Nuevo Bearer Token con la información actualizada.

* **Parámetros (JSON):**

```json
{
  // Los parámetros pueden ser o el email o el telefono.
  "email": "paciente@tmc.cl",
  "cellphone": "912345678"
}
```

- **Respuesta (JSON):**

```json
{
  "status": "success",
  "message": "Usuario actualizado exitosamente",
  "data": {
    "token": "Bearer Token acá"
  }
}
```

### Activar o desactivar un usuario

- **Método:** PUT
- **Ruta:** api/user/status
- **Respuesta:** Datos del usuario.

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
  "message": "Usuario actualizado exitosamente",
  "data": {
    "rut": "12345678-k",
    "email": "paciente@tmc.cl",
    // Este valor cambiará dependiendo si el usuario se activó o no.
    "is_active": 1
  }
}
```

### Eliminar un usuario

- **Método:** DELETE
- **Ruta:** api/user/delete
- **Respuesta:** Datos del usuario.

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
  "message": "Usuario actualizado exitosamente",
  "data": {
    "rut": "12345678-k",
    "email": "paciente@tmc.cl",
    // Este valor cambiará dependiendo si el usuario se activó o no.
    "is_active": 1
  }
}
```

## PACIENTES

### Obtener todos los pacientes

- **Método:** GET
- **Ruta:** api/patients
- **Respuesta:** Datos de todos los pacientes.
- **Parámetros:** Auth Bearer Token.

### Obtener un paciente por ID

- **Método:** GET
- **Ruta:** api/patients/:id
- **Respuesta:** Datos de un paciente
- **Parámetros:** 
  - Auth Bearer Token.
  - id del paciente

### Obtener las observaciones y documentos de un pacientes

- **Método:** GET
- **Ruta:** api/patients/:id/observations
- **Respuesta:** Datos de un paciente
- **Parámetros:** 
  - Auth Bearer Token.
  - id del paciente.

### Crear paciente

- **Método:** POST
- **Ruta:** api/patients

* **Parámetros (JSON):**

```json
{
  "rut": "12345678-k",
  "email": "hugotoro@gmail.com",
  "password": "123",
  "name": "HUGO ALBERTO",
  "patSurName": "TORO",
  "matSurName": "ZÚÑIGA",
  "genre": "MASCULINO",
  "dateBirth": "2024-01-09",
  "cellphone": "912345678"
}
```

- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.


## CITAS MÉDICAS

### Obtener citas de un doctor

- **Método:** GET
- **Ruta:** api/appointments/doctors.
- **Respuesta:** Todas las citas médicas de un doctor. Independientemente si un paciente la tomó.
- **Parámetros:** Auth Bearer Token.

### Obtener citas de un paciente

- **Método:** GET
- **Ruta:** api/appointments/patients.
- **Respuesta:** Todas las citas médicas de un paciente.
- **Parámetros:** Auth Bearer Token.

### Obtener citas médicas disponibles

- **Método:** GET
- **Ruta:** api/appointments/search
- **Respuesta:** Citas médicas disponibles.
- **Parámetros:**
  - ?speciality=(:id)&doctor=(:id)&date=(fecha).
  - Auth Bearer Token.
- **EJEMPLOS DE USO:**
  - ?speciality=1
  - ?doctor=1
  - ?date=2024-09-11
  - ?doctor=1&speciality=1

### Registrar una cita médica (paciente)

- **Método:** POST
- **Ruta:** api/appointments/patient/create
- **Respuesta:** Datos de la cita médica registrada
- **Parámetros:**
  - ID de la disponibilidad del doctor
  - Auth Bearer Token
- **Parámetros: (JSON)**

```json
{
  "availabilityId": 1
}
```

## DOCTORES

### Obtener todos los doctores

- **Método:** GET
- **Ruta:** api/doctors
- **Respuesta:** Datos de todos los doctores.
- **Parámetros:** Auth Bearer Token.

### Obtener un doctor por ID

- **Método:** GET
- **Ruta:** api/doctors/:id
- **Respuesta:** Datos de un paciente
- **Parámetros:** Auth Bearer Token.

### Obtener especialidades de un doctor

- **Método:** GET
- **Ruta:** api/doctors/specialities.
- **Respuesta:** Especialidades de un doctor.
- **Parámetros:** Auth Bearer Token.

### Crear doctor

- **Método:** POST
- **Ruta:** api/doctors

* **Parámetros (JSON):**

```json
{
  "rut": "87654321-k",
  "email": "torohugo@gmail.com",
  "password": "123",
  "name": "HUGO ALBERTO",
  "patSurName": "TORO",
  "matSurName": "ZUÑIGA",
  "genre": "MASCULINO",
  "dateBirth": "2024-01-09",
  "cellphone": "912345678",
  // Se puede enviar más de una especialidad.
  "specialities": ["1", "2", "3"]
}
```

- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.
