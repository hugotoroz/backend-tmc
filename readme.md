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

- **Método:** GET
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
  "cellphone":"912345678"
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
- **Parámetros:** Auth Bearer Token.

### Crear paciente

- **Método:** POST
- **Ruta:** api/patients

* **Parámetros (JSON):**

```json
{
  "rut": "12345678-k",
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

## CITAS MÉDICAS

### Obtener citas de un doctor
- **Método:** GET
- **Ruta:** api/doctors/appointments.
- **Respuesta:** Todas las citas médicas de un doctor. Independientemente si un paciente la tomó.
- **Parámetros:** Auth Bearer Token.

### Obtener citas de un paciente
- **Método:** GET
- **Ruta:** api/patients/appointments.
- **Respuesta:** Todas las citas médicas de un paciente.
- **Parámetros:** Auth Bearer Token.

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
  "name": "Hugo",
  "patSurName": "Toro",
  "matSurName": "Zúñiga",
  "dateBirth": "2024-01-09",
  "cellphone": "912345678",
  "speciality": "1"
}
```

- **Respuesta:** Bearer Token para manejo de sesiones y acceso a otros Endpoints.
