--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-05 22:55:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


--
-- TOC entry 247 (class 1255 OID 49926)
-- Name: generar_horario_con_intervalo(date, time without time zone, time without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generar_horario_con_intervalo(fecha date, hora_inicio time without time zone, hora_fin time without time zone, especialidad_id integer) RETURNS TABLE(horario_inicio time without time zone, horario_fin time without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
    intervalo_especialidad INT;
    tiempo_separacion INTERVAL := '10 minutes';
    horario_actual TIME;
BEGIN
    -- Obtener el intervalo de la especialidad
    SELECT intervalo INTO intervalo_especialidad FROM especialidad WHERE id = especialidad_id;

    -- Asegurarse de que el intervalo se haya encontrado
    IF intervalo_especialidad IS NULL THEN
        RAISE EXCEPTION 'No se encontró la especialidad con ID %', especialidad_id;
    END IF;

    -- Iniciar el horario actual en la hora de inicio
    horario_actual := hora_inicio;

    -- Generar los bloques de horario
    WHILE horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL <= hora_fin LOOP
        horario_inicio := horario_actual;
        horario_fin := horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL;
        
        -- Regresar el bloque de tiempo como una fila en la tabla de resultados
        RETURN NEXT;
        
        -- Avanzar al siguiente bloque de tiempo incluyendo el tiempo de separación
        horario_actual := horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL + tiempo_separacion;
    END LOOP;
END;
$$;


ALTER FUNCTION public.generar_horario_con_intervalo(fecha date, hora_inicio time without time zone, hora_fin time without time zone, especialidad_id integer) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 49927)
-- Name: generar_horario_mensual(time without time zone, time without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generar_horario_mensual(hora_inicio time without time zone, hora_fin time without time zone, especialidad_id integer) RETURNS TABLE(fecha date, horario_inicio time without time zone, horario_fin time without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
    intervalo_especialidad INT;
    tiempo_separacion INTERVAL := '10 minutes';
    fecha_actual DATE := CURRENT_DATE;
    ultimo_dia_mes DATE := (date_trunc('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
    horario_actual TIME;
BEGIN
    -- Obtener el intervalo de la especialidad
    SELECT intervalo INTO intervalo_especialidad FROM especialidad WHERE id = especialidad_id;

    -- Asegurarse de que el intervalo se haya encontrado
    IF intervalo_especialidad IS NULL THEN
        RAISE EXCEPTION 'No se encontró la especialidad con ID %', especialidad_id;
    END IF;

    -- Iterar desde la fecha actual hasta el último día del mes
    WHILE fecha_actual <= ultimo_dia_mes LOOP
        -- Verificar si el día es de lunes a viernes (1=Lunes, ..., 5=Viernes)
        IF EXTRACT(DOW FROM fecha_actual) BETWEEN 1 AND 5 THEN
            -- Generar bloques de horario para el día
            horario_actual := hora_inicio;
            WHILE horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL <= hora_fin LOOP
                fecha := fecha_actual;
                horario_inicio := horario_actual;
                horario_fin := horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL;
                
                -- Regresar el bloque de tiempo como una fila en la tabla de resultados
                RETURN NEXT;
                
                -- Avanzar al siguiente bloque de tiempo incluyendo el tiempo de separación
                horario_actual := horario_actual + (intervalo_especialidad || ' minutes')::INTERVAL + tiempo_separacion;
            END LOOP;
        END IF;
        
        -- Avanzar al siguiente día
        fecha_actual := fecha_actual + INTERVAL '1 day';
    END LOOP;
END;
$$;


ALTER FUNCTION public.generar_horario_mensual(hora_inicio time without time zone, hora_fin time without time zone, especialidad_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 41734)
-- Name: citas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citas (
    id bigint NOT NULL,
    fecha timestamp without time zone NOT NULL,
    fk_doctor_id bigint NOT NULL,
    fk_paciente_id bigint NOT NULL,
    fk_estado_cita_id bigint NOT NULL
);


ALTER TABLE public.citas OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 41737)
-- Name: citas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.citas ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.citas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 41738)
-- Name: comunas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comunas (
    id bigint NOT NULL,
    nom character varying NOT NULL,
    fk_region_id bigint NOT NULL
);


ALTER TABLE public.comunas OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 41743)
-- Name: comunas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.comunas ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.comunas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 41744)
-- Name: contratos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratos (
    id bigint NOT NULL,
    sueldo integer NOT NULL,
    fec_inicio date NOT NULL,
    fec_fin date,
    is_active integer DEFAULT 1 NOT NULL,
    fk_tipo_contrato bigint NOT NULL,
    fk_usuario_id bigint NOT NULL
);


ALTER TABLE public.contratos OWNER TO postgres;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN contratos.fk_usuario_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.contratos.fk_usuario_id IS 'Este FK es exclusivamente para médicos y empleados.';


--
-- TOC entry 220 (class 1259 OID 41748)
-- Name: contratos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.contratos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contratos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 41749)
-- Name: direcciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.direcciones (
    id bigint NOT NULL,
    direccion character varying NOT NULL,
    is_active integer DEFAULT 1 NOT NULL,
    fk_usuario_id bigint NOT NULL,
    fk_comuna_id bigint
);


ALTER TABLE public.direcciones OWNER TO postgres;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN direcciones.fk_usuario_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.direcciones.fk_usuario_id IS 'Puede estar relacionado a cualquier usuario, independientemente su rol.';


--
-- TOC entry 222 (class 1259 OID 41755)
-- Name: direcciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.direcciones ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.direcciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 41756)
-- Name: disponibilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disponibilidad (
    id bigint NOT NULL,
    fecha date NOT NULL,
    hora_inicio time without time zone,
    hora_fin time without time zone,
    fk_doctor_id bigint NOT NULL
);


ALTER TABLE public.disponibilidad OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE disponibilidad; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.disponibilidad IS 'Para que los médicos puedan gestionar sus horarios.';


--
-- TOC entry 224 (class 1259 OID 41759)
-- Name: disponibilidad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.disponibilidad ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.disponibilidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 41760)
-- Name: doctor_especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_especialidad (
    id bigint NOT NULL,
    fk_doctor_id bigint NOT NULL,
    fk_especialidad_id bigint NOT NULL
);


ALTER TABLE public.doctor_especialidad OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 41763)
-- Name: doctor_especialidad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.doctor_especialidad ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.doctor_especialidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 41764)
-- Name: documentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos (
    id bigint NOT NULL,
    fk_cita_id bigint NOT NULL,
    fk_tipo_documento_id bigint NOT NULL
);


ALTER TABLE public.documentos OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 41767)
-- Name: documentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.documentos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.documentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 41768)
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    id bigint NOT NULL,
    nom character varying NOT NULL,
    valor integer NOT NULL,
    intervalo integer
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN especialidad.intervalo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.especialidad.intervalo IS 'Intervalo de tiempo (en minutos) por consulta en base a la especialidad.';


--
-- TOC entry 230 (class 1259 OID 41773)
-- Name: especialidad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.especialidad ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.especialidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 41774)
-- Name: estados_cita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados_cita (
    nombre character varying,
    id bigint NOT NULL
);


ALTER TABLE public.estados_cita OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN estados_cita.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.estados_cita.nombre IS 'Pendiente, Confirmada, Cancelada, Finalizada.';


--
-- TOC entry 232 (class 1259 OID 41779)
-- Name: estados_cita_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.estados_cita ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.estados_cita_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 41780)
-- Name: observaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observaciones (
    id bigint NOT NULL,
    observacion text NOT NULL,
    fk_cita_id bigint NOT NULL
);


ALTER TABLE public.observaciones OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 41785)
-- Name: observaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.observaciones ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.observaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 41786)
-- Name: regiones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regiones (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.regiones OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 41791)
-- Name: regiones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.regiones ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.regiones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 41792)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    rol character varying NOT NULL,
    descripcion character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 41797)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 41798)
-- Name: tipos_contrato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_contrato (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_contrato OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 41803)
-- Name: tipos_contrato_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipos_contrato ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipos_contrato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 41804)
-- Name: tipos_documento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_documento (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_documento OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 41809)
-- Name: tipos_documento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipos_documento ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipos_documento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 41810)
-- Name: usuario_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_rol (
    id bigint NOT NULL,
    fk_usuario_id bigint NOT NULL,
    fk_rol_id bigint NOT NULL
);


ALTER TABLE public.usuario_rol OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 41813)
-- Name: usuario_rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario_rol ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 41814)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    rut character varying NOT NULL,
    clave character varying NOT NULL,
    nom character varying NOT NULL,
    ap_paterno character varying NOT NULL,
    ap_materno character varying NOT NULL,
    fec_nacimiento date NOT NULL,
    telefono integer NOT NULL,
    is_active integer DEFAULT 1,
    email character varying NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 41820)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4964 (class 0 OID 41734)
-- Dependencies: 215
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4966 (class 0 OID 41738)
-- Dependencies: 217
-- Data for Name: comunas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.comunas VALUES (1, 'Arica', 1);
INSERT INTO public.comunas VALUES (2, 'Camarones', 1);
INSERT INTO public.comunas VALUES (3, 'Putre', 1);
INSERT INTO public.comunas VALUES (4, 'General Lagos', 1);
INSERT INTO public.comunas VALUES (5, 'Iquique', 2);
INSERT INTO public.comunas VALUES (6, 'Alto Hospicio', 2);
INSERT INTO public.comunas VALUES (7, 'Pozo Almonte', 2);
INSERT INTO public.comunas VALUES (8, 'Camiña', 2);
INSERT INTO public.comunas VALUES (9, 'Colchane', 2);
INSERT INTO public.comunas VALUES (10, 'Huara', 2);
INSERT INTO public.comunas VALUES (11, 'Pica', 2);
INSERT INTO public.comunas VALUES (12, 'Antofagasta', 3);
INSERT INTO public.comunas VALUES (13, 'Mejillones', 3);
INSERT INTO public.comunas VALUES (14, 'Sierra Gorda', 3);
INSERT INTO public.comunas VALUES (15, 'Taltal', 3);
INSERT INTO public.comunas VALUES (16, 'Calama', 3);
INSERT INTO public.comunas VALUES (17, 'Ollagüe', 3);
INSERT INTO public.comunas VALUES (18, 'San Pedro de Atacama', 3);
INSERT INTO public.comunas VALUES (19, 'Tocopilla', 3);
INSERT INTO public.comunas VALUES (20, 'María Elena', 3);
INSERT INTO public.comunas VALUES (21, 'Copiapó', 4);
INSERT INTO public.comunas VALUES (22, 'Caldera', 4);
INSERT INTO public.comunas VALUES (23, 'Tierra Amarilla', 4);
INSERT INTO public.comunas VALUES (24, 'Chañaral', 4);
INSERT INTO public.comunas VALUES (25, 'Diego de Almagro', 4);
INSERT INTO public.comunas VALUES (26, 'Vallenar', 4);
INSERT INTO public.comunas VALUES (27, 'Alto del Carmen', 4);
INSERT INTO public.comunas VALUES (28, 'Freirina', 4);
INSERT INTO public.comunas VALUES (29, 'Huasco', 4);
INSERT INTO public.comunas VALUES (30, 'La Serena', 5);
INSERT INTO public.comunas VALUES (31, 'Coquimbo', 5);
INSERT INTO public.comunas VALUES (32, 'Andacollo', 5);
INSERT INTO public.comunas VALUES (33, 'La Higuera', 5);
INSERT INTO public.comunas VALUES (34, 'Paiguano', 5);
INSERT INTO public.comunas VALUES (35, 'Vicuña', 5);
INSERT INTO public.comunas VALUES (36, 'Illapel', 5);
INSERT INTO public.comunas VALUES (37, 'Canela', 5);
INSERT INTO public.comunas VALUES (38, 'Los Vilos', 5);
INSERT INTO public.comunas VALUES (39, 'Salamanca', 5);
INSERT INTO public.comunas VALUES (40, 'Ovalle', 5);
INSERT INTO public.comunas VALUES (41, 'Combarbalá', 5);
INSERT INTO public.comunas VALUES (42, 'Monte Patria', 5);
INSERT INTO public.comunas VALUES (43, 'Punitaqui', 5);
INSERT INTO public.comunas VALUES (44, 'Río Hurtado', 5);
INSERT INTO public.comunas VALUES (45, 'Valparaíso', 6);
INSERT INTO public.comunas VALUES (46, 'Casablanca', 6);
INSERT INTO public.comunas VALUES (47, 'Concón', 6);
INSERT INTO public.comunas VALUES (48, 'Juan Fernández', 6);
INSERT INTO public.comunas VALUES (49, 'Puchuncaví', 6);
INSERT INTO public.comunas VALUES (50, 'Quintero', 6);
INSERT INTO public.comunas VALUES (51, 'Viña del Mar', 6);
INSERT INTO public.comunas VALUES (52, 'Isla de Pascua', 6);
INSERT INTO public.comunas VALUES (53, 'Los Andes', 6);
INSERT INTO public.comunas VALUES (54, 'Calle Larga', 6);
INSERT INTO public.comunas VALUES (55, 'Rinconada', 6);
INSERT INTO public.comunas VALUES (56, 'San Esteban', 6);
INSERT INTO public.comunas VALUES (57, 'La Ligua', 6);
INSERT INTO public.comunas VALUES (58, 'Cabildo', 6);
INSERT INTO public.comunas VALUES (59, 'Papudo', 6);
INSERT INTO public.comunas VALUES (60, 'Petorca', 6);
INSERT INTO public.comunas VALUES (61, 'Zapallar', 6);
INSERT INTO public.comunas VALUES (62, 'Quillota', 6);
INSERT INTO public.comunas VALUES (63, 'Calera', 6);
INSERT INTO public.comunas VALUES (64, 'Hijuelas', 6);
INSERT INTO public.comunas VALUES (65, 'La Cruz', 6);
INSERT INTO public.comunas VALUES (66, 'Nogales', 6);
INSERT INTO public.comunas VALUES (67, 'San Antonio', 6);
INSERT INTO public.comunas VALUES (68, 'Algarrobo', 6);
INSERT INTO public.comunas VALUES (69, 'Cartagena', 6);
INSERT INTO public.comunas VALUES (70, 'El Quisco', 6);
INSERT INTO public.comunas VALUES (71, 'El Tabo', 6);
INSERT INTO public.comunas VALUES (72, 'Santo Domingo', 6);
INSERT INTO public.comunas VALUES (73, 'San Felipe', 6);
INSERT INTO public.comunas VALUES (74, 'Catemu', 6);
INSERT INTO public.comunas VALUES (75, 'Llaillay', 6);
INSERT INTO public.comunas VALUES (76, 'Panquehue', 6);
INSERT INTO public.comunas VALUES (77, 'Putaendo', 6);
INSERT INTO public.comunas VALUES (78, 'Santa María', 6);
INSERT INTO public.comunas VALUES (79, 'Quilpué', 6);
INSERT INTO public.comunas VALUES (80, 'Limache', 6);
INSERT INTO public.comunas VALUES (81, 'Olmué', 6);
INSERT INTO public.comunas VALUES (82, 'Villa Alemana', 6);
INSERT INTO public.comunas VALUES (83, 'Santiago', 7);
INSERT INTO public.comunas VALUES (84, 'Cerrillos', 7);
INSERT INTO public.comunas VALUES (85, 'Cerro Navia', 7);
INSERT INTO public.comunas VALUES (86, 'Conchalí', 7);
INSERT INTO public.comunas VALUES (87, 'El Bosque', 7);
INSERT INTO public.comunas VALUES (88, 'Estación Central', 7);
INSERT INTO public.comunas VALUES (89, 'Huechuraba', 7);
INSERT INTO public.comunas VALUES (90, 'Independencia', 7);
INSERT INTO public.comunas VALUES (91, 'La Cisterna', 7);
INSERT INTO public.comunas VALUES (92, 'La Florida', 7);
INSERT INTO public.comunas VALUES (93, 'La Granja', 7);
INSERT INTO public.comunas VALUES (94, 'La Pintana', 7);
INSERT INTO public.comunas VALUES (95, 'La Reina', 7);
INSERT INTO public.comunas VALUES (96, 'Las Condes', 7);
INSERT INTO public.comunas VALUES (97, 'Lo Barnechea', 7);
INSERT INTO public.comunas VALUES (98, 'Lo Espejo', 7);
INSERT INTO public.comunas VALUES (99, 'Lo Prado', 7);
INSERT INTO public.comunas VALUES (100, 'Macul', 7);
INSERT INTO public.comunas VALUES (101, 'Maipú', 7);
INSERT INTO public.comunas VALUES (102, 'Ñuñoa', 7);
INSERT INTO public.comunas VALUES (103, 'Pedro Aguirre Cerda', 7);
INSERT INTO public.comunas VALUES (104, 'Peñalolén', 7);
INSERT INTO public.comunas VALUES (105, 'Providencia', 7);
INSERT INTO public.comunas VALUES (106, 'Pudahuel', 7);
INSERT INTO public.comunas VALUES (107, 'Quilicura', 7);
INSERT INTO public.comunas VALUES (108, 'Quinta Normal', 7);
INSERT INTO public.comunas VALUES (109, 'Recoleta', 7);
INSERT INTO public.comunas VALUES (110, 'Renca', 7);
INSERT INTO public.comunas VALUES (111, 'San Joaquín', 7);
INSERT INTO public.comunas VALUES (112, 'San Miguel', 7);
INSERT INTO public.comunas VALUES (113, 'San Ramón', 7);
INSERT INTO public.comunas VALUES (114, 'Vitacura', 7);
INSERT INTO public.comunas VALUES (115, 'Puente Alto', 7);
INSERT INTO public.comunas VALUES (116, 'Pirque', 7);
INSERT INTO public.comunas VALUES (117, 'San José de Maipo', 7);
INSERT INTO public.comunas VALUES (118, 'Colina', 7);
INSERT INTO public.comunas VALUES (119, 'Lampa', 7);
INSERT INTO public.comunas VALUES (120, 'Tiltil', 7);
INSERT INTO public.comunas VALUES (121, 'San Bernardo', 7);
INSERT INTO public.comunas VALUES (122, 'Buin', 7);
INSERT INTO public.comunas VALUES (123, 'Calera de Tango', 7);
INSERT INTO public.comunas VALUES (124, 'Paine', 7);
INSERT INTO public.comunas VALUES (125, 'Melipilla', 7);
INSERT INTO public.comunas VALUES (126, 'Alhué', 7);
INSERT INTO public.comunas VALUES (127, 'Curacaví', 7);
INSERT INTO public.comunas VALUES (128, 'María Pinto', 7);
INSERT INTO public.comunas VALUES (129, 'San Pedro', 7);
INSERT INTO public.comunas VALUES (130, 'Talagante', 7);
INSERT INTO public.comunas VALUES (131, 'El Monte', 7);
INSERT INTO public.comunas VALUES (132, 'Isla de Maipo', 7);
INSERT INTO public.comunas VALUES (133, 'Padre Hurtado', 7);
INSERT INTO public.comunas VALUES (134, 'Peñaflor', 7);
INSERT INTO public.comunas VALUES (135, 'Rancagua', 8);
INSERT INTO public.comunas VALUES (136, 'Codegua', 8);
INSERT INTO public.comunas VALUES (137, 'Coinco', 8);
INSERT INTO public.comunas VALUES (138, 'Coltauco', 8);
INSERT INTO public.comunas VALUES (139, 'Doñihue', 8);
INSERT INTO public.comunas VALUES (140, 'Graneros', 8);
INSERT INTO public.comunas VALUES (141, 'Las Cabras', 8);
INSERT INTO public.comunas VALUES (142, 'Machalí', 8);
INSERT INTO public.comunas VALUES (143, 'Malloa', 8);
INSERT INTO public.comunas VALUES (144, 'Mostazal', 8);
INSERT INTO public.comunas VALUES (145, 'Olivar', 8);
INSERT INTO public.comunas VALUES (146, 'Peumo', 8);
INSERT INTO public.comunas VALUES (147, 'Pichidegua', 8);
INSERT INTO public.comunas VALUES (148, 'Quinta de Tilcoco', 8);
INSERT INTO public.comunas VALUES (149, 'Rengo', 8);
INSERT INTO public.comunas VALUES (150, 'Requínoa', 8);
INSERT INTO public.comunas VALUES (151, 'San Vicente', 8);
INSERT INTO public.comunas VALUES (152, 'Pichilemu', 8);
INSERT INTO public.comunas VALUES (153, 'La Estrella', 8);
INSERT INTO public.comunas VALUES (154, 'Litueche', 8);
INSERT INTO public.comunas VALUES (155, 'Marchihue', 8);
INSERT INTO public.comunas VALUES (156, 'Navidad', 8);
INSERT INTO public.comunas VALUES (157, 'Paredones', 8);
INSERT INTO public.comunas VALUES (158, 'San Fernando', 8);
INSERT INTO public.comunas VALUES (159, 'Chépica', 8);
INSERT INTO public.comunas VALUES (160, 'Chimbarongo', 8);
INSERT INTO public.comunas VALUES (161, 'Lolol', 8);
INSERT INTO public.comunas VALUES (162, 'Nancagua', 8);
INSERT INTO public.comunas VALUES (163, 'Palmilla', 8);
INSERT INTO public.comunas VALUES (164, 'Peralillo', 8);
INSERT INTO public.comunas VALUES (165, 'Placilla', 8);
INSERT INTO public.comunas VALUES (166, 'Pumanque', 8);
INSERT INTO public.comunas VALUES (167, 'Santa Cruz', 8);
INSERT INTO public.comunas VALUES (168, 'Talca', 9);
INSERT INTO public.comunas VALUES (169, 'Constitución', 9);
INSERT INTO public.comunas VALUES (170, 'Curepto', 9);
INSERT INTO public.comunas VALUES (171, 'Empedrado', 9);
INSERT INTO public.comunas VALUES (172, 'Maule', 9);
INSERT INTO public.comunas VALUES (173, 'Pelarco', 9);
INSERT INTO public.comunas VALUES (174, 'Pencahue', 9);
INSERT INTO public.comunas VALUES (175, 'Río Claro', 9);
INSERT INTO public.comunas VALUES (176, 'San Clemente', 9);
INSERT INTO public.comunas VALUES (177, 'San Rafael', 9);
INSERT INTO public.comunas VALUES (178, 'Cauquenes', 9);
INSERT INTO public.comunas VALUES (179, 'Chanco', 9);
INSERT INTO public.comunas VALUES (180, 'Pelluhue', 9);
INSERT INTO public.comunas VALUES (181, 'Curicó', 9);
INSERT INTO public.comunas VALUES (182, 'Hualañé', 9);
INSERT INTO public.comunas VALUES (183, 'Licantén', 9);
INSERT INTO public.comunas VALUES (184, 'Molina', 9);
INSERT INTO public.comunas VALUES (185, 'Rauco', 9);
INSERT INTO public.comunas VALUES (186, 'Romeral', 9);
INSERT INTO public.comunas VALUES (187, 'Sagrada Familia', 9);
INSERT INTO public.comunas VALUES (188, 'Teno', 9);
INSERT INTO public.comunas VALUES (189, 'Vichuquén', 9);
INSERT INTO public.comunas VALUES (190, 'Linares', 9);
INSERT INTO public.comunas VALUES (191, 'Colbún', 9);
INSERT INTO public.comunas VALUES (192, 'Longaví', 9);
INSERT INTO public.comunas VALUES (193, 'Parral', 9);
INSERT INTO public.comunas VALUES (194, 'Retiro', 9);
INSERT INTO public.comunas VALUES (195, 'San Javier', 9);
INSERT INTO public.comunas VALUES (196, 'Villa Alegre', 9);
INSERT INTO public.comunas VALUES (197, 'Yerbas Buenas', 9);
INSERT INTO public.comunas VALUES (198, 'Chillán', 10);
INSERT INTO public.comunas VALUES (199, 'Bulnes', 10);
INSERT INTO public.comunas VALUES (200, 'Chillán Viejo', 10);
INSERT INTO public.comunas VALUES (201, 'El Carmen', 10);
INSERT INTO public.comunas VALUES (202, 'Pemuco', 10);
INSERT INTO public.comunas VALUES (203, 'Pinto', 10);
INSERT INTO public.comunas VALUES (204, 'Quillón', 10);
INSERT INTO public.comunas VALUES (205, 'San Ignacio', 10);
INSERT INTO public.comunas VALUES (206, 'Yungay', 10);
INSERT INTO public.comunas VALUES (207, 'Quirihue', 10);
INSERT INTO public.comunas VALUES (208, 'Cobquecura', 10);
INSERT INTO public.comunas VALUES (209, 'Coelemu', 10);
INSERT INTO public.comunas VALUES (210, 'Ninhue', 10);
INSERT INTO public.comunas VALUES (211, 'Portezuelo', 10);
INSERT INTO public.comunas VALUES (212, 'Ránquil', 10);
INSERT INTO public.comunas VALUES (213, 'Treguaco', 10);
INSERT INTO public.comunas VALUES (214, 'San Carlos', 10);
INSERT INTO public.comunas VALUES (215, 'Coihueco', 10);
INSERT INTO public.comunas VALUES (216, 'Ñiquén', 10);
INSERT INTO public.comunas VALUES (217, 'San Fabián', 10);
INSERT INTO public.comunas VALUES (218, 'San Nicolás', 10);
INSERT INTO public.comunas VALUES (219, 'Concepción', 11);
INSERT INTO public.comunas VALUES (220, 'Coronel', 11);
INSERT INTO public.comunas VALUES (221, 'Chiguayante', 11);
INSERT INTO public.comunas VALUES (222, 'Florida', 11);
INSERT INTO public.comunas VALUES (223, 'Hualqui', 11);
INSERT INTO public.comunas VALUES (224, 'Lota', 11);
INSERT INTO public.comunas VALUES (225, 'Penco', 11);
INSERT INTO public.comunas VALUES (226, 'San Pedro de la Paz', 11);
INSERT INTO public.comunas VALUES (227, 'Santa Juana', 11);
INSERT INTO public.comunas VALUES (228, 'Talcahuano', 11);
INSERT INTO public.comunas VALUES (229, 'Tomé', 11);
INSERT INTO public.comunas VALUES (230, 'Hualpén', 11);
INSERT INTO public.comunas VALUES (231, 'Lebu', 11);
INSERT INTO public.comunas VALUES (232, 'Arauco', 11);
INSERT INTO public.comunas VALUES (233, 'Cañete', 11);
INSERT INTO public.comunas VALUES (234, 'Contulmo', 11);
INSERT INTO public.comunas VALUES (235, 'Curanilahue', 11);
INSERT INTO public.comunas VALUES (236, 'Los Álamos', 11);
INSERT INTO public.comunas VALUES (237, 'Tirúa', 11);
INSERT INTO public.comunas VALUES (238, 'Los Ángeles', 11);
INSERT INTO public.comunas VALUES (239, 'Antuco', 11);
INSERT INTO public.comunas VALUES (240, 'Cabrero', 11);
INSERT INTO public.comunas VALUES (241, 'Laja', 11);
INSERT INTO public.comunas VALUES (242, 'Mulchén', 11);
INSERT INTO public.comunas VALUES (243, 'Nacimiento', 11);
INSERT INTO public.comunas VALUES (244, 'Negrete', 11);
INSERT INTO public.comunas VALUES (245, 'Quilaco', 11);
INSERT INTO public.comunas VALUES (246, 'Quilleco', 11);
INSERT INTO public.comunas VALUES (247, 'San Rosendo', 11);
INSERT INTO public.comunas VALUES (248, 'Santa Bárbara', 11);
INSERT INTO public.comunas VALUES (249, 'Tucapel', 11);
INSERT INTO public.comunas VALUES (250, 'Yumbel', 11);
INSERT INTO public.comunas VALUES (251, 'Alto Biobío', 11);
INSERT INTO public.comunas VALUES (252, 'Temuco', 12);
INSERT INTO public.comunas VALUES (253, 'Carahue', 12);
INSERT INTO public.comunas VALUES (254, 'Cunco', 12);
INSERT INTO public.comunas VALUES (255, 'Curarrehue', 12);
INSERT INTO public.comunas VALUES (256, 'Freire', 12);
INSERT INTO public.comunas VALUES (257, 'Galvarino', 12);
INSERT INTO public.comunas VALUES (258, 'Gorbea', 12);
INSERT INTO public.comunas VALUES (259, 'Lautaro', 12);
INSERT INTO public.comunas VALUES (260, 'Loncoche', 12);
INSERT INTO public.comunas VALUES (261, 'Melipeuco', 12);
INSERT INTO public.comunas VALUES (262, 'Nueva Imperial', 12);
INSERT INTO public.comunas VALUES (263, 'Padre Las Casas', 12);
INSERT INTO public.comunas VALUES (264, 'Perquenco', 12);
INSERT INTO public.comunas VALUES (265, 'Pitrufquén', 12);
INSERT INTO public.comunas VALUES (266, 'Pucón', 12);
INSERT INTO public.comunas VALUES (267, 'Saavedra', 12);
INSERT INTO public.comunas VALUES (268, 'Teodoro Schmidt', 12);
INSERT INTO public.comunas VALUES (269, 'Toltén', 12);
INSERT INTO public.comunas VALUES (270, 'Vilcún', 12);
INSERT INTO public.comunas VALUES (271, 'Villarrica', 12);
INSERT INTO public.comunas VALUES (272, 'Cholchol', 12);
INSERT INTO public.comunas VALUES (273, 'Angol', 12);
INSERT INTO public.comunas VALUES (274, 'Collipulli', 12);
INSERT INTO public.comunas VALUES (275, 'Curacautín', 12);
INSERT INTO public.comunas VALUES (276, 'Ercilla', 12);
INSERT INTO public.comunas VALUES (277, 'Lonquimay', 12);
INSERT INTO public.comunas VALUES (278, 'Los Sauces', 12);
INSERT INTO public.comunas VALUES (279, 'Lumaco', 12);
INSERT INTO public.comunas VALUES (280, 'Purén', 12);
INSERT INTO public.comunas VALUES (281, 'Renaico', 12);
INSERT INTO public.comunas VALUES (282, 'Traiguén', 12);
INSERT INTO public.comunas VALUES (283, 'Victoria', 12);
INSERT INTO public.comunas VALUES (284, 'Valdivia', 13);
INSERT INTO public.comunas VALUES (285, 'Corral', 13);
INSERT INTO public.comunas VALUES (286, 'Lanco', 13);
INSERT INTO public.comunas VALUES (287, 'Los Lagos', 13);
INSERT INTO public.comunas VALUES (288, 'Máfil', 13);
INSERT INTO public.comunas VALUES (289, 'Mariquina', 13);
INSERT INTO public.comunas VALUES (290, 'Paillaco', 13);
INSERT INTO public.comunas VALUES (291, 'Panguipulli', 13);
INSERT INTO public.comunas VALUES (292, 'La Unión', 13);
INSERT INTO public.comunas VALUES (293, 'Futrono', 13);
INSERT INTO public.comunas VALUES (294, 'Lago Ranco', 13);
INSERT INTO public.comunas VALUES (295, 'Río Bueno', 13);
INSERT INTO public.comunas VALUES (296, 'Puerto Montt', 14);
INSERT INTO public.comunas VALUES (297, 'Calbuco', 14);
INSERT INTO public.comunas VALUES (298, 'Cochamó', 14);
INSERT INTO public.comunas VALUES (299, 'Fresia', 14);
INSERT INTO public.comunas VALUES (300, 'Frutillar', 14);
INSERT INTO public.comunas VALUES (301, 'Los Muermos', 14);
INSERT INTO public.comunas VALUES (302, 'Llanquihue', 14);
INSERT INTO public.comunas VALUES (303, 'Maullín', 14);
INSERT INTO public.comunas VALUES (304, 'Puerto Varas', 14);
INSERT INTO public.comunas VALUES (305, 'Castro', 14);
INSERT INTO public.comunas VALUES (306, 'Ancud', 14);
INSERT INTO public.comunas VALUES (307, 'Chonchi', 14);
INSERT INTO public.comunas VALUES (308, 'Curaco de Vélez', 14);
INSERT INTO public.comunas VALUES (309, 'Dalcahue', 14);
INSERT INTO public.comunas VALUES (310, 'Puqueldón', 14);
INSERT INTO public.comunas VALUES (311, 'Queilén', 14);
INSERT INTO public.comunas VALUES (312, 'Quellón', 14);
INSERT INTO public.comunas VALUES (313, 'Quemchi', 14);
INSERT INTO public.comunas VALUES (314, 'Quinchao', 14);
INSERT INTO public.comunas VALUES (315, 'Osorno', 14);
INSERT INTO public.comunas VALUES (316, 'Puerto Octay', 14);
INSERT INTO public.comunas VALUES (317, 'Purranque', 14);
INSERT INTO public.comunas VALUES (318, 'Puyehue', 14);
INSERT INTO public.comunas VALUES (319, 'Río Negro', 14);
INSERT INTO public.comunas VALUES (320, 'San Juan de la Costa', 14);
INSERT INTO public.comunas VALUES (321, 'San Pablo', 14);
INSERT INTO public.comunas VALUES (322, 'Chaitén', 14);
INSERT INTO public.comunas VALUES (323, 'Futaleufú', 14);
INSERT INTO public.comunas VALUES (324, 'Hualaihué', 14);
INSERT INTO public.comunas VALUES (325, 'Palena', 14);
INSERT INTO public.comunas VALUES (326, 'Coihaique', 15);
INSERT INTO public.comunas VALUES (327, 'Lago Verde', 15);
INSERT INTO public.comunas VALUES (328, 'Aysén', 15);
INSERT INTO public.comunas VALUES (329, 'Cisnes', 15);
INSERT INTO public.comunas VALUES (330, 'Guaitecas', 15);
INSERT INTO public.comunas VALUES (331, 'Cochrane', 15);
INSERT INTO public.comunas VALUES (332, 'O''Higgins', 15);
INSERT INTO public.comunas VALUES (333, 'Tortel', 15);
INSERT INTO public.comunas VALUES (334, 'Chile Chico', 15);
INSERT INTO public.comunas VALUES (335, 'Río Ibáñez', 15);
INSERT INTO public.comunas VALUES (336, 'Punta Arenas', 16);
INSERT INTO public.comunas VALUES (337, 'Laguna Blanca', 16);
INSERT INTO public.comunas VALUES (338, 'Río Verde', 16);
INSERT INTO public.comunas VALUES (339, 'San Gregorio', 16);
INSERT INTO public.comunas VALUES (340, 'Cabo de Hornos', 16);
INSERT INTO public.comunas VALUES (341, 'Antártica', 16);
INSERT INTO public.comunas VALUES (342, 'Porvenir', 16);
INSERT INTO public.comunas VALUES (343, 'Primavera', 16);
INSERT INTO public.comunas VALUES (344, 'Timaukel', 16);
INSERT INTO public.comunas VALUES (345, 'Natales', 16);
INSERT INTO public.comunas VALUES (346, 'Torres del Paine', 16);


--
-- TOC entry 4968 (class 0 OID 41744)
-- Dependencies: 219
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4970 (class 0 OID 41749)
-- Dependencies: 221
-- Data for Name: direcciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4972 (class 0 OID 41756)
-- Dependencies: 223
-- Data for Name: disponibilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4974 (class 0 OID 41760)
-- Dependencies: 225
-- Data for Name: doctor_especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor_especialidad VALUES (1, 15, 1);


--
-- TOC entry 4976 (class 0 OID 41764)
-- Dependencies: 227
-- Data for Name: documentos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4978 (class 0 OID 41768)
-- Dependencies: 229
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.especialidad VALUES (1, 'Cardiología', 18000, 30);
INSERT INTO public.especialidad VALUES (2, 'Pediatría', 18000, 30);
INSERT INTO public.especialidad VALUES (3, 'Dermatología', 25000, 40);
INSERT INTO public.especialidad VALUES (4, 'Oftalmología', 25500, 40);
INSERT INTO public.especialidad VALUES (5, 'Ginecología', 18100, 60);
INSERT INTO public.especialidad VALUES (6, 'Neurología', 25700, 60);
INSERT INTO public.especialidad VALUES (7, 'Traumatología', 18100, 40);
INSERT INTO public.especialidad VALUES (8, 'Psiquiatría', 44000, 60);
INSERT INTO public.especialidad VALUES (10, 'Medicina General', 14000, 30);
INSERT INTO public.especialidad VALUES (11, 'Kinesiología', 10700, 45);
INSERT INTO public.especialidad VALUES (12, 'Terapia Ocupacional', 9000, 45);
INSERT INTO public.especialidad VALUES (13, 'Nutricionista', 26900, 30);
INSERT INTO public.especialidad VALUES (9, 'Otorrinolaringología', 25700, 55);


--
-- TOC entry 4980 (class 0 OID 41774)
-- Dependencies: 231
-- Data for Name: estados_cita; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4982 (class 0 OID 41780)
-- Dependencies: 233
-- Data for Name: observaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4984 (class 0 OID 41786)
-- Dependencies: 235
-- Data for Name: regiones; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.regiones VALUES (1, 'Arica y Parinacota');
INSERT INTO public.regiones VALUES (2, 'Tarapacá');
INSERT INTO public.regiones VALUES (3, 'Antofagasta');
INSERT INTO public.regiones VALUES (4, 'Atacama');
INSERT INTO public.regiones VALUES (5, 'Coquimbo');
INSERT INTO public.regiones VALUES (6, 'Valparaíso');
INSERT INTO public.regiones VALUES (7, 'Metropolitana de Santiago');
INSERT INTO public.regiones VALUES (8, 'Libertador General Bernardo O''Higgins');
INSERT INTO public.regiones VALUES (9, 'Maule');
INSERT INTO public.regiones VALUES (10, 'Ñuble');
INSERT INTO public.regiones VALUES (11, 'Biobío');
INSERT INTO public.regiones VALUES (12, 'La Araucanía');
INSERT INTO public.regiones VALUES (13, 'Los Ríos');
INSERT INTO public.regiones VALUES (14, 'Los Lagos');
INSERT INTO public.regiones VALUES (15, 'Aysén del General Carlos Ibáñez del Campo');
INSERT INTO public.regiones VALUES (16, 'Magallanes y de la Antártica Chilena');


--
-- TOC entry 4986 (class 0 OID 41792)
-- Dependencies: 237
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'admin', 'Administrador');
INSERT INTO public.roles VALUES (2, 'doctor', 'Doctor');
INSERT INTO public.roles VALUES (3, 'paciente', 'Paciente');
INSERT INTO public.roles VALUES (4, 'empleado', 'Empleado');


--
-- TOC entry 4988 (class 0 OID 41798)
-- Dependencies: 239
-- Data for Name: tipos_contrato; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4990 (class 0 OID 41804)
-- Dependencies: 241
-- Data for Name: tipos_documento; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4992 (class 0 OID 41810)
-- Dependencies: 243
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuario_rol VALUES (3, 14, 3);
INSERT INTO public.usuario_rol VALUES (4, 15, 2);


--
-- TOC entry 4994 (class 0 OID 41814)
-- Dependencies: 245
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuarios VALUES (14, '12345678-k', '$2a$10$M8QsSEk5HLVXCMqhhv8rL.nI1CmHNi1r6eXNFsMv7X6.8qX7Y3PuS', 'Paciente', '1', '1', '2024-01-09', 12345678, 1, 'paciente@tmc.cl');
INSERT INTO public.usuarios VALUES (15, '87654321-k', '$2a$10$XPp5KNP9Vr491cLJB4iSjeJtCeTqniwYGbGh80VTipk0eUtPrPv1W', 'Doctor', '1', '1', '2024-01-09', 12345678, 0, 'Doctor@tmc.cl');


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 216
-- Name: citas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citas_id_seq', 1, false);


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 218
-- Name: comunas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comunas_id_seq', 346, true);


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 220
-- Name: contratos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contratos_id_seq', 1, false);


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 222
-- Name: direcciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.direcciones_id_seq', 1, false);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 224
-- Name: disponibilidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disponibilidad_id_seq', 1, false);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 226
-- Name: doctor_especialidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_especialidad_id_seq', 1, true);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 228
-- Name: documentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documentos_id_seq', 1, false);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 230
-- Name: especialidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidad_id_seq', 13, true);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 232
-- Name: estados_cita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estados_cita_id_seq', 1, false);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 234
-- Name: observaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.observaciones_id_seq', 1, false);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 236
-- Name: regiones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regiones_id_seq', 16, true);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 238
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 240
-- Name: tipos_contrato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipos_contrato_id_seq', 1, false);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 242
-- Name: tipos_documento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipos_documento_id_seq', 1, false);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 244
-- Name: usuario_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_rol_id_seq', 4, true);


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 246
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 15, true);


--
-- TOC entry 4769 (class 2606 OID 41822)
-- Name: citas citas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pk PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 41824)
-- Name: comunas comunas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_pk PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 41826)
-- Name: contratos contratos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pk PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 41828)
-- Name: direcciones direcciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pk PRIMARY KEY (id);


--
-- TOC entry 4777 (class 2606 OID 41830)
-- Name: disponibilidad disponibilidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_pk PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 41832)
-- Name: doctor_especialidad doctor_especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 41834)
-- Name: documentos documentos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_pk PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 41836)
-- Name: especialidad especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 41838)
-- Name: estados_cita estados_cita_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados_cita
    ADD CONSTRAINT estados_cita_pk PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 41840)
-- Name: observaciones observaciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_pk PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 41842)
-- Name: regiones regiones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regiones
    ADD CONSTRAINT regiones_pk PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 41844)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 41846)
-- Name: usuarios rut_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT rut_unique UNIQUE (rut);


--
-- TOC entry 4793 (class 2606 OID 41848)
-- Name: tipos_contrato tipos_contrato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_contrato
    ADD CONSTRAINT tipos_contrato_pk PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 41850)
-- Name: tipos_documento tipos_documento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_documento
    ADD CONSTRAINT tipos_documento_pk PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 41852)
-- Name: usuario_rol usuario_rol_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_pk PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 41854)
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 41856)
-- Name: usuarios usuarios_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_unique UNIQUE (rut);


--
-- TOC entry 4800 (class 1259 OID 41857)
-- Name: usuarios_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX usuarios_email_idx ON public.usuarios USING btree (email);


--
-- TOC entry 4805 (class 2606 OID 41858)
-- Name: citas citas_estados_cita_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_estados_cita_fk FOREIGN KEY (fk_estado_cita_id) REFERENCES public.estados_cita(id);


--
-- TOC entry 4808 (class 2606 OID 41863)
-- Name: comunas comunas_regiones_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_regiones_fk FOREIGN KEY (fk_region_id) REFERENCES public.regiones(id);


--
-- TOC entry 4809 (class 2606 OID 41868)
-- Name: contratos contratos_tipos_contrato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_tipos_contrato_fk FOREIGN KEY (fk_tipo_contrato) REFERENCES public.tipos_contrato(id);


--
-- TOC entry 4810 (class 2606 OID 41873)
-- Name: contratos contratos_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4811 (class 2606 OID 41878)
-- Name: direcciones direcciones_comunas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_comunas_fk FOREIGN KEY (fk_comuna_id) REFERENCES public.comunas(id);


--
-- TOC entry 4812 (class 2606 OID 41883)
-- Name: direcciones direcciones_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4814 (class 2606 OID 41888)
-- Name: doctor_especialidad doctor_especialidad_especialidad_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_especialidad_fk FOREIGN KEY (fk_especialidad_id) REFERENCES public.especialidad(id);


--
-- TOC entry 4806 (class 2606 OID 41893)
-- Name: citas doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4813 (class 2606 OID 41898)
-- Name: disponibilidad doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4815 (class 2606 OID 41903)
-- Name: doctor_especialidad doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4816 (class 2606 OID 41908)
-- Name: documentos documentos_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_citas_fk FOREIGN KEY (fk_cita_id) REFERENCES public.citas(id);


--
-- TOC entry 4817 (class 2606 OID 41913)
-- Name: documentos documentos_tipos_documento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_tipos_documento_fk FOREIGN KEY (fk_tipo_documento_id) REFERENCES public.tipos_documento(id);


--
-- TOC entry 4818 (class 2606 OID 41918)
-- Name: observaciones observaciones_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_citas_fk FOREIGN KEY (fk_cita_id) REFERENCES public.citas(id);


--
-- TOC entry 4807 (class 2606 OID 41923)
-- Name: citas paciente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT paciente_id FOREIGN KEY (fk_paciente_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4819 (class 2606 OID 41928)
-- Name: usuario_rol usuario_rol_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_roles_fk FOREIGN KEY (fk_rol_id) REFERENCES public.roles(id);


--
-- TOC entry 4820 (class 2606 OID 41933)
-- Name: usuario_rol usuario_rol_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


-- Completed on 2024-11-05 22:55:18

--
-- PostgreSQL database dump complete
--

