--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-01 23:47:29

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

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 32845)
-- Name: citas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citas (
    id integer NOT NULL,
    fecha timestamp without time zone NOT NULL
);


ALTER TABLE public.citas OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33014)
-- Name: comunas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comunas (
    id integer NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.comunas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 32914)
-- Name: contratos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratos (
    id integer NOT NULL,
    sueldo integer NOT NULL,
    fec_inicio date NOT NULL,
    fec_fin date,
    is_active integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.contratos OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 32993)
-- Name: direcciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.direcciones (
    id integer NOT NULL,
    direccion character varying NOT NULL,
    is_active integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.direcciones OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 32903)
-- Name: disponibilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disponibilidad (
    id integer NOT NULL,
    fecha date NOT NULL,
    hora_inicio time without time zone,
    hora_fin time without time zone
);


ALTER TABLE public.disponibilidad OWNER TO postgres;

--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE disponibilidad; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.disponibilidad IS 'Para que los médicos puedan gestionar sus horarios.';


--
-- TOC entry 232 (class 1259 OID 33041)
-- Name: doctor_especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_especialidad (
    id integer NOT NULL
);


ALTER TABLE public.doctor_especialidad OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 32848)
-- Name: documentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos (
    id integer NOT NULL
);


ALTER TABLE public.documentos OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33034)
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    id integer NOT NULL,
    nom character varying NOT NULL,
    valor integer NOT NULL
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 32886)
-- Name: estados_cita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados_cita (
    id integer NOT NULL,
    nombre character varying
);


ALTER TABLE public.estados_cita OWNER TO postgres;

--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN estados_cita.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.estados_cita.nombre IS 'Pendiente, Confirmada, Cancelada, Finalizada.';


--
-- TOC entry 224 (class 1259 OID 32937)
-- Name: estados_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados_pago (
    id integer NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.estados_pago OWNER TO postgres;

--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN estados_pago.nom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.estados_pago.nom IS 'Pendiente, Completado, Fallido';


--
-- TOC entry 227 (class 1259 OID 32981)
-- Name: observaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observaciones (
    id integer NOT NULL,
    observacion text NOT NULL
);


ALTER TABLE public.observaciones OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 32944)
-- Name: pagos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagos (
    id integer NOT NULL,
    fecha_pago date NOT NULL
);


ALTER TABLE public.pagos OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33000)
-- Name: regiones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regiones (
    id integer NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.regiones OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 32851)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    rol character varying NOT NULL,
    descripcion character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 32925)
-- Name: tipos_contrato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_contrato (
    id integer NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_contrato OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 32964)
-- Name: tipos_documento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipos_documento (
    id integer NOT NULL,
    nom character varying NOT NULL
);


ALTER TABLE public.tipos_documento OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32856)
-- Name: usuario_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_rol (
    id integer NOT NULL
);


ALTER TABLE public.usuario_rol OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 32859)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    rut character varying NOT NULL,
    clave character varying NOT NULL,
    nom character varying NOT NULL,
    ap_paterno character varying NOT NULL,
    ap_materno character varying NOT NULL,
    fec_nacimiento date NOT NULL,
    telefono integer NOT NULL,
    is_active integer DEFAULT 1
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 4957 (class 0 OID 32845)
-- Dependencies: 215
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citas (id, fecha) FROM stdin;
\.


--
-- TOC entry 4972 (class 0 OID 33014)
-- Dependencies: 230
-- Data for Name: comunas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comunas (id, nom) FROM stdin;
\.


--
-- TOC entry 4964 (class 0 OID 32914)
-- Dependencies: 222
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratos (id, sueldo, fec_inicio, fec_fin, is_active) FROM stdin;
\.


--
-- TOC entry 4970 (class 0 OID 32993)
-- Dependencies: 228
-- Data for Name: direcciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.direcciones (id, direccion, is_active) FROM stdin;
\.


--
-- TOC entry 4963 (class 0 OID 32903)
-- Dependencies: 221
-- Data for Name: disponibilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disponibilidad (id, fecha, hora_inicio, hora_fin) FROM stdin;
\.


--
-- TOC entry 4974 (class 0 OID 33041)
-- Dependencies: 232
-- Data for Name: doctor_especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor_especialidad (id) FROM stdin;
\.


--
-- TOC entry 4958 (class 0 OID 32848)
-- Dependencies: 216
-- Data for Name: documentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documentos (id) FROM stdin;
\.


--
-- TOC entry 4973 (class 0 OID 33034)
-- Dependencies: 231
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidad (id, nom, valor) FROM stdin;
\.


--
-- TOC entry 4962 (class 0 OID 32886)
-- Dependencies: 220
-- Data for Name: estados_cita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_cita (id, nombre) FROM stdin;
\.


--
-- TOC entry 4966 (class 0 OID 32937)
-- Dependencies: 224
-- Data for Name: estados_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados_pago (id, nom) FROM stdin;
\.


--
-- TOC entry 4969 (class 0 OID 32981)
-- Dependencies: 227
-- Data for Name: observaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.observaciones (id, observacion) FROM stdin;
\.


--
-- TOC entry 4967 (class 0 OID 32944)
-- Dependencies: 225
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pagos (id, fecha_pago) FROM stdin;
\.


--
-- TOC entry 4971 (class 0 OID 33000)
-- Dependencies: 229
-- Data for Name: regiones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regiones (id, nom) FROM stdin;
\.


--
-- TOC entry 4959 (class 0 OID 32851)
-- Dependencies: 217
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, rol, descripcion) FROM stdin;
\.


--
-- TOC entry 4965 (class 0 OID 32925)
-- Dependencies: 223
-- Data for Name: tipos_contrato; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipos_contrato (id, nom) FROM stdin;
\.


--
-- TOC entry 4968 (class 0 OID 32964)
-- Dependencies: 226
-- Data for Name: tipos_documento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipos_documento (id, nom) FROM stdin;
\.


--
-- TOC entry 4960 (class 0 OID 32856)
-- Dependencies: 218
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_rol (id) FROM stdin;
\.


--
-- TOC entry 4961 (class 0 OID 32859)
-- Dependencies: 219
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, rut, clave, nom, ap_paterno, ap_materno, fec_nacimiento, telefono, is_active) FROM stdin;
\.


--
-- TOC entry 4759 (class 2606 OID 32865)
-- Name: citas citas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pk PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 33022)
-- Name: comunas comunas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_pk PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 32919)
-- Name: contratos contratos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pk PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 32999)
-- Name: direcciones direcciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pk PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 32907)
-- Name: disponibilidad disponibilidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_pk PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 33045)
-- Name: doctor_especialidad doctor_especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4761 (class 2606 OID 32867)
-- Name: documentos documentos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_pk PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 33040)
-- Name: especialidad especialidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pk PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 32943)
-- Name: estados_pago estados_pago_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados_pago
    ADD CONSTRAINT estados_pago_pk PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 32892)
-- Name: estados_cita newtable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados_cita
    ADD CONSTRAINT newtable_pk PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 32987)
-- Name: observaciones observaciones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_pk PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 32948)
-- Name: pagos pagos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pk PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 33006)
-- Name: regiones regiones_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regiones
    ADD CONSTRAINT regiones_pk PRIMARY KEY (id);


--
-- TOC entry 4763 (class 2606 OID 32869)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);


--
-- TOC entry 4767 (class 2606 OID 32871)
-- Name: usuarios rut_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT rut_unique UNIQUE (rut);


--
-- TOC entry 4777 (class 2606 OID 32931)
-- Name: tipos_contrato tipos_contrato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_contrato
    ADD CONSTRAINT tipos_contrato_pk PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 32968)
-- Name: tipos_documento tipos_documento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipos_documento
    ADD CONSTRAINT tipos_documento_pk PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 32873)
-- Name: usuario_rol usuario_rol_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_pk PRIMARY KEY (id);


--
-- TOC entry 4769 (class 2606 OID 32875)
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id);


--
-- TOC entry 4796 (class 2606 OID 32959)
-- Name: citas citas_estados_cita_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_estados_cita_fk FOREIGN KEY (id) REFERENCES public.estados_cita(id);


--
-- TOC entry 4811 (class 2606 OID 33029)
-- Name: comunas comunas_regiones_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunas
    ADD CONSTRAINT comunas_regiones_fk FOREIGN KEY (id) REFERENCES public.regiones(id);


--
-- TOC entry 4804 (class 2606 OID 32932)
-- Name: contratos contratos_tipos_contrato_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_tipos_contrato_fk FOREIGN KEY (id) REFERENCES public.tipos_contrato(id);


--
-- TOC entry 4809 (class 2606 OID 33056)
-- Name: direcciones direcciones_comunas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_comunas_fk FOREIGN KEY (id) REFERENCES public.comunas(id);


--
-- TOC entry 4810 (class 2606 OID 33061)
-- Name: direcciones direcciones_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_usuarios_fk FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4812 (class 2606 OID 33051)
-- Name: doctor_especialidad doctor_especialidad_especialidad_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT doctor_especialidad_especialidad_fk FOREIGN KEY (id) REFERENCES public.especialidad(id);


--
-- TOC entry 4799 (class 2606 OID 32969)
-- Name: documentos documentos_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_citas_fk FOREIGN KEY (id) REFERENCES public.citas(id);


--
-- TOC entry 4800 (class 2606 OID 32974)
-- Name: documentos documentos_tipos_documento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos
    ADD CONSTRAINT documentos_tipos_documento_fk FOREIGN KEY (id) REFERENCES public.tipos_documento(id);


--
-- TOC entry 4797 (class 2606 OID 32898)
-- Name: citas id_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT id_medico FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4803 (class 2606 OID 32908)
-- Name: disponibilidad id_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT id_medico FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4813 (class 2606 OID 33046)
-- Name: doctor_especialidad id_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_especialidad
    ADD CONSTRAINT id_medico FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4805 (class 2606 OID 32920)
-- Name: contratos id_medico_empleado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT id_medico_empleado FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4798 (class 2606 OID 32893)
-- Name: citas id_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT id_paciente FOREIGN KEY (id) REFERENCES public.usuarios(id);


--
-- TOC entry 4808 (class 2606 OID 32988)
-- Name: observaciones observaciones_citas_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observaciones
    ADD CONSTRAINT observaciones_citas_fk FOREIGN KEY (id) REFERENCES public.citas(id);


--
-- TOC entry 4806 (class 2606 OID 32949)
-- Name: pagos pagos_contratos_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_contratos_fk FOREIGN KEY (id) REFERENCES public.contratos(id);


--
-- TOC entry 4807 (class 2606 OID 32954)
-- Name: pagos pagos_estados_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_estados_pago_fk FOREIGN KEY (id) REFERENCES public.estados_pago(id);


--
-- TOC entry 4801 (class 2606 OID 32876)
-- Name: usuario_rol usuario_rol_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_roles_fk FOREIGN KEY (id) REFERENCES public.roles(id);


--
-- TOC entry 4802 (class 2606 OID 32881)
-- Name: usuario_rol usuario_rol_usuarios_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_usuarios_fk FOREIGN KEY (id) REFERENCES public.usuarios(id);


-- Completed on 2024-10-01 23:47:29

--
-- PostgreSQL database dump complete
--

