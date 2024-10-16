--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-13 13:39:37

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 32829)
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
-- TOC entry 216 (class 1259 OID 32832)
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
-- TOC entry 217 (class 1259 OID 32833)
-- Name: comunas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comunas (
    id bigint NOT NULL,
    nom character varying NOT NULL,
    fk_region_id bigint NOT NULL
);


ALTER TABLE public.comunas OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32838)
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
-- TOC entry 219 (class 1259 OID 32839)
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
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN contratos.fk_usuario_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.contratos.fk_usuario_id IS 'Este FK es exclusivamente para médicos y empleados.';


--
-- TOC entry 220 (class 1259 OID 32843)
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
-- TOC entry 221 (class 1259 OID 32844)
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
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN direcciones.fk_usuario_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.direcciones.fk_usuario_id IS 'Puede estar relacionado a cualquier usuario, independientemente su rol.';


--
-- TOC entry 222 (class 1259 OID 32850)
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
-- TOC entry 223 (class 1259 OID 32851)
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
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE disponibilidad; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.disponibilidad IS 'Para que los médicos puedan gestionar sus horarios.';


--
-- TOC entry 224 (class 1259 OID 32854)
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
-- TOC entry 225 (class 1259 OID 32855)
-- Name: doctor_especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_especialidad (
    id bigint NOT NULL,
    fk_doctor_id bigint NOT NULL,
    fk_especialidad_id bigint NOT NULL
);


ALTER TABLE public.doctor_especialidad OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 32858)
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
-- TOC entry 227 (class 1259 OID 32859)
-- Name: documentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos (
    id bigint NOT NULL,
    fk_cita_id bigint NOT NULL,
    fk_tipo_documento_id bigint NOT NULL
);


ALTER TABLE public.documentos OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 32862)
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
-- TOC entry 229 (class 1259 OID 32863)
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    id bigint NOT NULL,
    nom character varying NOT NULL,
    valor integer NOT NULL
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 32868)
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
-- TOC entry 231 (class 1259 OID 32869)
-- Name: estados_cita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados_cita (
    nombre character varying,
    id bigint NOT NULL
);


ALTER TABLE public.estados_cita OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN estados_cita.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.estados_cita.nombre IS 'Pendiente, Confirmada, Cancelada, Finalizada.';


--
-- TOC entry 232 (class 1259 OID 32874)
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
-- TOC entry 233 (class 1259 OID 32875)
-- Name: observaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observaciones (
    id bigint NOT NULL,
    observacion text NOT NULL,
    fk_cita_id bigint NOT NULL
);


ALTER TABLE public.observaciones OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 32880)
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
-- TOC entry 235 (class 1259 OID 32881)
-- Name: regiones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regiones (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.regiones OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 32886)
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
-- TOC entry 237 (class 1259 OID 32887)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    rol character varying NOT NULL,
    descripcion character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 32892)
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
-- TOC entry 239 (class 1259 OID 32893)
-- Name: tipos_contrato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_contrato (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_contrato OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 32898)
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
-- TOC entry 241 (class 1259 OID 32899)
-- Name: tipos_documento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_documento (
    id bigint NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_documento OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 32904)
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
-- TOC entry 243 (class 1259 OID 32905)
-- Name: usuario_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_rol (
    id bigint NOT NULL,
    fk_usuario_id bigint NOT NULL,
    fk_rol_id bigint NOT NULL
);


ALTER TABLE public.usuario_rol OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 32908)
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
-- TOC entry 245 (class 1259 OID 32909)
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
-- TOC entry 246 (class 1259 OID 32915)
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
-- TOC entry 4962 (class 0 OID 32829)
-- Dependencies: 215
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4964 (class 0 OID 32833)
-- Dependencies: 217
-- Data for Name: comunas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4966 (class 0 OID 32839)
-- Dependencies: 219
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4968 (class 0 OID 32844)
-- Dependencies: 221
-- Data for Name: direcciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4970 (class 0 OID 32851)
-- Dependencies: 223
-- Data for Name: disponibilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4972 (class 0 OID 32855)
-- Dependencies: 225
-- Data for Name: doctor_especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4974 (class 0 OID 32859)
-- Dependencies: 227
-- Data for Name: documentos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4976 (class 0 OID 32863)
-- Dependencies: 229
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.especialidad VALUES (1, 'Cardiología', 18000);
INSERT INTO public.especialidad VALUES (2, 'Pediatría', 18000);
INSERT INTO public.especialidad VALUES (3, 'Dermatología', 25000);
INSERT INTO public.especialidad VALUES (4, 'Oftalmología', 25500);
INSERT INTO public.especialidad VALUES (5, 'Ginecología', 18100);
INSERT INTO public.especialidad VALUES (6, 'Neurología', 25700);
INSERT INTO public.especialidad VALUES (7, 'Traumatología', 18100);
INSERT INTO public.especialidad VALUES (8, 'Psiquiatría', 44000);
INSERT INTO public.especialidad VALUES (10, 'Medicina General', 14000);
INSERT INTO public.especialidad VALUES (11, 'Kinesiología', 10700);
INSERT INTO public.especialidad VALUES (12, 'Terapia Ocupacional', 9000);
INSERT INTO public.especialidad VALUES (13, 'Nutricionista', 26900);
INSERT INTO public.especialidad VALUES (9, 'Otorrinolaringología', 25700);


--
-- TOC entry 4978 (class 0 OID 32869)
-- Dependencies: 231
-- Data for Name: estados_cita; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4980 (class 0 OID 32875)
-- Dependencies: 233
-- Data for Name: observaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4982 (class 0 OID 32881)
-- Dependencies: 235
-- Data for Name: regiones; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4984 (class 0 OID 32887)
-- Dependencies: 237
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'admin', 'Administrador');
INSERT INTO public.roles VALUES (2, 'doctor', 'Doctor');
INSERT INTO public.roles VALUES (3, 'paciente', 'Paciente');
INSERT INTO public.roles VALUES (4, 'empleado', 'Empleado');


--
-- TOC entry 4986 (class 0 OID 32893)
-- Dependencies: 239
-- Data for Name: tipos_contrato; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4988 (class 0 OID 32899)
-- Dependencies: 241
-- Data for Name: tipos_documento; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4990 (class 0 OID 32905)
-- Dependencies: 243
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4992 (class 0 OID 32909)
-- Dependencies: 245
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 216
-- Name: citas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citas_id_seq', 1, false);


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 218
-- Name: comunas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comunas_id_seq', 1, false);


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 220
-- Name: contratos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contratos_id_seq', 1, false);


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 222
-- Name: direcciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.direcciones_id_seq', 1, false);


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 224
-- Name: disponibilidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disponibilidad_id_seq', 1, false);


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 226
-- Name: doctor_especialidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_especialidad_id_seq', 1, false);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 228
-- Name: documentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documentos_id_seq', 1, false);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 230
-- Name: especialidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidad_id_seq', 13, true);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 232
-- Name: estados_cita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estados_cita_id_seq', 1, false);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 234
-- Name: observaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.observaciones_id_seq', 1, false);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 236
-- Name: regiones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regiones_id_seq', 1, false);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 238
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 240
-- Name: tipos_contrato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipos_contrato_id_seq', 1, false);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 242
-- Name: tipos_documento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipos_documento_id_seq', 1, false);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 244
-- Name: usuario_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_rol_id_seq', 2, true);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 246
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 13, true);


--
-- TOC entry 4767 (class 2606 OID 32917)
-- Name: citas citas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pk PRIMARY KEY (id);


--
-- TOC entry 4769 (class 2606 OID 32919)
-- Name: comunas comunas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_pk PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 32921)
-- Name: contratos contratos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pk PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 32923)
-- Name: direcciones direcciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pk PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 32925)
-- Name: disponibilidad disponibilidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_pk PRIMARY KEY (id);


--
-- TOC entry 4777 (class 2606 OID 32927)
-- Name: doctor_especialidad doctor_especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 32929)
-- Name: documentos documentos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_pk PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 32931)
-- Name: especialidad especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 32933)
-- Name: estados_cita estados_cita_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados_cita
    ADD CONSTRAINT estados_cita_pk PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 32935)
-- Name: observaciones observaciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_pk PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 32937)
-- Name: regiones regiones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regiones
    ADD CONSTRAINT regiones_pk PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 32939)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 32941)
-- Name: usuarios rut_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT rut_unique UNIQUE (rut);


--
-- TOC entry 4791 (class 2606 OID 32943)
-- Name: tipos_contrato tipos_contrato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_contrato
    ADD CONSTRAINT tipos_contrato_pk PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 32945)
-- Name: tipos_documento tipos_documento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_documento
    ADD CONSTRAINT tipos_documento_pk PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 32947)
-- Name: usuario_rol usuario_rol_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_pk PRIMARY KEY (id);


--
-- TOC entry 4800 (class 2606 OID 32949)
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 33079)
-- Name: usuarios usuarios_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_unique UNIQUE (rut);


--
-- TOC entry 4798 (class 1259 OID 33080)
-- Name: usuarios_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX usuarios_email_idx ON public.usuarios USING btree (email);


--
-- TOC entry 4803 (class 2606 OID 32950)
-- Name: citas citas_estados_cita_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_estados_cita_fk FOREIGN KEY (fk_estado_cita_id) REFERENCES public.estados_cita(id);


--
-- TOC entry 4806 (class 2606 OID 32955)
-- Name: comunas comunas_regiones_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_regiones_fk FOREIGN KEY (fk_region_id) REFERENCES public.regiones(id);


--
-- TOC entry 4807 (class 2606 OID 32960)
-- Name: contratos contratos_tipos_contrato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_tipos_contrato_fk FOREIGN KEY (fk_tipo_contrato) REFERENCES public.tipos_contrato(id);


--
-- TOC entry 4808 (class 2606 OID 32965)
-- Name: contratos contratos_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4809 (class 2606 OID 32970)
-- Name: direcciones direcciones_comunas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_comunas_fk FOREIGN KEY (fk_comuna_id) REFERENCES public.comunas(id);


--
-- TOC entry 4810 (class 2606 OID 32975)
-- Name: direcciones direcciones_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4812 (class 2606 OID 32980)
-- Name: doctor_especialidad doctor_especialidad_especialidad_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_especialidad_fk FOREIGN KEY (fk_especialidad_id) REFERENCES public.especialidad(id);


--
-- TOC entry 4804 (class 2606 OID 32985)
-- Name: citas doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4811 (class 2606 OID 32990)
-- Name: disponibilidad doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4813 (class 2606 OID 32995)
-- Name: doctor_especialidad doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_id FOREIGN KEY (fk_doctor_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4814 (class 2606 OID 33000)
-- Name: documentos documentos_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_citas_fk FOREIGN KEY (fk_cita_id) REFERENCES public.citas(id);


--
-- TOC entry 4815 (class 2606 OID 33005)
-- Name: documentos documentos_tipos_documento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_tipos_documento_fk FOREIGN KEY (fk_tipo_documento_id) REFERENCES public.tipos_documento(id);


--
-- TOC entry 4816 (class 2606 OID 33010)
-- Name: observaciones observaciones_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_citas_fk FOREIGN KEY (fk_cita_id) REFERENCES public.citas(id);


--
-- TOC entry 4805 (class 2606 OID 33015)
-- Name: citas paciente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT paciente_id FOREIGN KEY (fk_paciente_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4817 (class 2606 OID 33020)
-- Name: usuario_rol usuario_rol_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_roles_fk FOREIGN KEY (fk_rol_id) REFERENCES public.roles(id);


--
-- TOC entry 4818 (class 2606 OID 33025)
-- Name: usuario_rol usuario_rol_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_usuarios_fk FOREIGN KEY (fk_usuario_id) REFERENCES public.usuarios(id);


-- Completed on 2024-10-13 13:39:37

--
-- PostgreSQL database dump complete
--

