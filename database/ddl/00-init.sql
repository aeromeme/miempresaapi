--
-- PostgreSQL database dump
--

\restrict j4CdfVcWatLk0Nylh4ENNfJbjebyNvGi4Uo65YNbxbN9lHD4DTSWIsTqod0sOwL

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

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
-- Name: ventasdb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE ventasdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE ventasdb OWNER TO postgres;

\unrestrict j4CdfVcWatLk0Nylh4ENNfJbjebyNvGi4Uo65YNbxbN9lHD4DTSWIsTqod0sOwL
\connect ventasdb
\restrict j4CdfVcWatLk0Nylh4ENNfJbjebyNvGi4Uo65YNbxbN9lHD4DTSWIsTqod0sOwL

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT clientes_correo_check CHECK (((correo)::text ~* '^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT clientes_nombre_check CHECK ((length(TRIM(BOTH FROM nombre)) >= 2))
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: TABLE clientes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.clientes IS 'Tabla de clientes del sistema de ventas';


--
-- Name: COLUMN clientes.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clientes.id IS 'Identificador ├║nico del cliente (UUID)';


--
-- Name: COLUMN clientes.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clientes.nombre IS 'Nombre completo del cliente';


--
-- Name: COLUMN clientes.correo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.clientes.correo IS 'Correo electr├│nico ├║nico del cliente';


--
-- Name: lineas_venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lineas_venta (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    venta_id uuid NOT NULL,
    producto_id uuid NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario_valor numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT lineas_venta_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT lineas_venta_precio_unitario_valor_check CHECK ((precio_unitario_valor >= (0)::numeric))
);


ALTER TABLE public.lineas_venta OWNER TO postgres;

--
-- Name: TABLE lineas_venta; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lineas_venta IS 'Tabla de l├¡neas de detalle de cada venta';


--
-- Name: COLUMN lineas_venta.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lineas_venta.id IS 'Identificador ├║nico de la l├¡nea de venta (UUID)';


--
-- Name: COLUMN lineas_venta.venta_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lineas_venta.venta_id IS 'Referencia a la venta';


--
-- Name: COLUMN lineas_venta.producto_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lineas_venta.producto_id IS 'Referencia al producto vendido';


--
-- Name: COLUMN lineas_venta.cantidad; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lineas_venta.cantidad IS 'Cantidad del producto vendido';


--
-- Name: COLUMN lineas_venta.precio_unitario_valor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.lineas_venta.precio_unitario_valor IS 'Precio unitario al momento de la venta';


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    fecha timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cliente_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    estado character(1) DEFAULT 'P'::bpchar NOT NULL,
    CONSTRAINT ventas_estado_check CHECK ((estado = ANY (ARRAY['A'::bpchar, 'C'::bpchar, 'X'::bpchar, 'E'::bpchar])))
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- Name: TABLE ventas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ventas IS 'Tabla de ventas realizadas';


--
-- Name: COLUMN ventas.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ventas.id IS 'Identificador ├║nico de la venta (UUID)';


--
-- Name: COLUMN ventas.fecha; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ventas.fecha IS 'Fecha y hora de la venta';


--
-- Name: COLUMN ventas.cliente_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ventas.cliente_id IS 'Referencia al cliente que realiz├│ la compra';


--
-- Name: COLUMN ventas.estado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ventas.estado IS 'Estado de la venta: A=Activa, C=Cancelada, X=Anulada, V=Vendida';


--
-- Name: cliente_ingresos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cliente_ingresos AS
 SELECT c.id,
    c.nombre,
    c.correo,
    count(DISTINCT v.id) AS total_ventas,
    sum(((lv.cantidad)::numeric * lv.precio_unitario_valor)) AS total_ingresos
   FROM ((public.clientes c
     JOIN public.ventas v ON ((c.id = v.cliente_id)))
     JOIN public.lineas_venta lv ON ((v.id = lv.venta_id)))
  WHERE (v.estado = 'A'::bpchar)
  GROUP BY c.id, c.nombre, c.correo
  ORDER BY (sum(((lv.cantidad)::numeric * lv.precio_unitario_valor))) DESC;


ALTER TABLE public.cliente_ingresos OWNER TO postgres;

--
-- Name: ingresos_mensuales; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ingresos_mensuales AS
 SELECT date_trunc('month'::text, v.fecha) AS periodo,
    EXTRACT(year FROM v.fecha) AS anio,
    EXTRACT(month FROM v.fecha) AS mes,
    count(DISTINCT v.id) AS total_ventas,
    count(DISTINCT v.cliente_id) AS total_clientes,
    sum(((lv.cantidad)::numeric * lv.precio_unitario_valor)) AS ingreso_total
   FROM (public.ventas v
     JOIN public.lineas_venta lv ON ((v.id = lv.venta_id)))
  WHERE (v.estado = 'A'::bpchar)
  GROUP BY (date_trunc('month'::text, v.fecha)), (EXTRACT(year FROM v.fecha)), (EXTRACT(month FROM v.fecha))
  ORDER BY (EXTRACT(year FROM v.fecha)) DESC, (EXTRACT(month FROM v.fecha)) DESC;


ALTER TABLE public.ingresos_mensuales OWNER TO postgres;

--
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(255) NOT NULL,
    precio_valor numeric(19,2) NOT NULL,
    stock integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT productos_nombre_check CHECK ((length(TRIM(BOTH FROM nombre)) > 0)),
    CONSTRAINT productos_precio_valor_check CHECK ((precio_valor >= (0)::numeric)),
    CONSTRAINT productos_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- Name: TABLE productos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.productos IS 'Tabla de productos disponibles para venta';


--
-- Name: COLUMN productos.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.productos.id IS 'Identificador ├║nico del producto (UUID)';


--
-- Name: COLUMN productos.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.productos.nombre IS 'Nombre del producto';


--
-- Name: COLUMN productos.precio_valor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.productos.precio_valor IS 'Valor del precio del producto';


--
-- Name: COLUMN productos.stock; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.productos.stock IS 'Cantidad disponible en inventario';


--
-- Name: top_productos_vendidos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.top_productos_vendidos AS
 SELECT p.id,
    p.nombre,
    sum(lv.cantidad) AS total_vendido,
    sum(((lv.cantidad)::numeric * p.precio_valor)) AS total_ingresos
   FROM ((public.productos p
     JOIN public.lineas_venta lv ON ((p.id = lv.producto_id)))
     JOIN public.ventas v ON ((v.id = lv.venta_id)))
  WHERE (v.estado = 'A'::bpchar)
  GROUP BY p.id, p.nombre
  ORDER BY (sum(lv.cantidad)) DESC;


ALTER TABLE public.top_productos_vendidos OWNER TO postgres;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nombre, correo, created_at, updated_at) FROM stdin;
f92a4f39-5b2f-4af0-8fde-1ca4b52d9f9d	Juan P├⌐rez	juan.perez@email.com	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
2c575013-2273-4990-aa97-cf483161d887	Mar├¡a Gonz├ílez	maria.gonzalez@email.com	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
c4d8443c-4fd3-49f4-8d78-64d1f7fe4cd1	Carlos Rodr├¡guez	carlos.rodriguez@email.com	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
d389ab1c-0bd3-4eed-9a6a-e47a364d1c91	ultrices vel augue vestibulum	bmourbey0@wp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5d1149b0-1ed3-4ea3-a653-0f7db6a0fee6	tincidunt nulla mollis molestie lorem	ginold1@discovery.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
05c5a7c0-ab3a-4795-bf15-c34ef90822de	mollis molestie lorem quisque	tdymocke2@dagondesign.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
af3826b2-6b96-4392-a17b-402572120b59	ut massa quis augue luctus	fsoal3@etsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eac11ec5-afca-4e01-a06c-2cb67a0e82d6	a feugiat et eros vestibulum	hkenvin4@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
26042897-a400-4432-bdc6-b4d8bc8317e0	magna bibendum imperdiet nullam	felwood5@ifeng.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
72a63ba6-e33c-4ac6-8e75-c761b5d3bc69	vulputate justo in blandit ultrices	dandrzej6@pcworld.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8d9583a3-0809-48e6-bbd4-8c6863e790ce	nec condimentum neque sapien	obines7@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
69d2f8b6-033d-473c-b6d3-38019ed25577	ultrices posuere cubilia curae mauris	gromaine8@diigo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0bd09ddf-62b8-44de-a009-120fba345e26	in felis eu sapien cursus	dbubear9@ucoz.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8825c382-85c9-4e6a-9eb8-a67a12825310	lacus at turpis donec posuere	wthomessona@weibo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eeb14492-cad6-4e86-a620-3a912baf9040	quis augue luctus tincidunt nulla	amacgounb@sohu.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
14e4a3e6-2eef-46d0-a1ea-689df5271fb1	iaculis diam erat fermentum justo	nfuttyc@deviantart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
29c006cc-d009-43e5-ae94-d755ea02afd6	mauris laoreet ut rhoncus aliquet	apauntond@state.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
066c259a-2808-4176-aa5d-b2f08cb17b69	phasellus sit amet erat nulla	hkorejse@sciencedirect.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7a7e5390-7077-4387-9935-2c827bdd055a	orci eget orci vehicula	jsimionif@elegantthemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3805c79d-da6e-4d49-bea9-8e9de58f7161	proin at turpis a pede	jpouckg@time.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
668e511c-0112-47a9-8909-5792d53cda46	ut nulla sed accumsan felis	mbonnefinh@goo.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
36192d6d-eac2-405c-82f2-05cbc60424af	natoque penatibus et magnis dis	sgoldai@ow.ly	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a6197552-1912-4f71-8737-7cae5f0d407d	in est risus auctor sed	dhaselwoodj@mozilla.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e24d5d7d-b886-4fee-879f-f2ab1e280f26	interdum in ante vestibulum ante	kcampanyk@so-net.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fdf7c6df-c45b-47fe-a580-66a85928cef7	potenti nullam porttitor lacus	tstangerl@unicef.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f06d0417-820a-4e59-bb78-bc526df00b65	accumsan tellus nisi eu orci	rredsallm@tripadvisor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6838fc01-f619-4f4c-8936-c878444bbfa2	vel pede morbi porttitor lorem	lrothmann@unblog.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
58130040-e9ef-44ee-b384-034586703984	dapibus nulla suscipit ligula in	mrymouro@slate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0886abb4-644c-4fa2-98ed-69ca724b9c9a	felis sed lacus morbi	rarstingallp@dell.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d3455ff3-2101-4ed2-b690-481467c42934	accumsan felis ut at	fgullyq@apache.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
146fd3e5-dac6-4761-8eca-247444ba87bc	in leo maecenas pulvinar lobortis	dridgersr@istockphoto.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
07dcec08-90f3-46ce-8f70-92aa34cd9d7e	nulla tempus vivamus in felis	edownies@wikipedia.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3ddc41b9-282c-4d50-8e34-dff0dedce312	erat id mauris vulputate	aaikmant@nbcnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
88e69b45-ed25-4f5f-a42b-68327238acc0	penatibus et magnis dis	bbascombeu@dmoz.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f9a98114-5664-4b51-a2c3-0de70c2adcc8	praesent blandit nam nulla integer	clathburyv@yahoo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
63a1c9d4-8d95-4c98-8ed0-3c25ec6877ac	et eros vestibulum ac est	cmantzw@sphinn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
13906bdb-89b3-4a5c-a200-58ba9deda27b	vestibulum ante ipsum primis	ncarffx@mit.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
56842b68-9974-4e53-9357-9a0ffedf2859	eu magna vulputate luctus cum	cmitteny@example.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1b99d714-4adf-4bdd-9f8a-1a57eaacf86d	phasellus sit amet erat	yciottiz@vimeo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
019a4403-994d-40f9-b667-497cf68668ec	et magnis dis parturient montes	ccordero10@samsung.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
792241b1-120b-400c-879c-ec62c65a71c2	magna vestibulum aliquet ultrices	agittings11@cyberchimps.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe8f0460-0cbf-42ed-81a2-1c545beaf5d8	magna vulputate luctus cum sociis	sbubbings12@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
77a2d3d7-0c41-4705-b8c8-c1d24b725ca9	nam congue risus semper	cfrance13@weather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3a1a00ec-ef03-467f-a06b-25a5f928b0d8	turpis enim blandit mi in	lmauditt14@nydailynews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa383ea2-80c5-48b4-9f9e-0c9cfb8ae802	sit amet sem fusce	llangmuir15@sfgate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18f93a15-4da2-468f-8ab0-c13f35e700e7	vestibulum velit id pretium	mteather16@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9c5a0b76-938e-444e-b077-e80f7a33726a	curae donec pharetra magna	hdemoreno17@macromedia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a3d339c9-2151-483d-ab2e-3806bccc8142	tristique in tempus sit	afay18@ted.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8a741d8d-aec6-4c43-9076-23da6fea6c8c	sollicitudin ut suscipit a feugiat	ebeams19@sun.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
372b8042-68ea-453a-9e16-65710c234297	purus aliquet at feugiat non	ralthorp1a@fc2.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc28d201-f1a5-4b15-ac09-a459af704e4d	ante vivamus tortor duis	cbointon1b@fotki.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aa2767a1-e713-4e77-b3d7-aaadcf860626	quis odio consequat varius integer	gfenemore1c@csmonitor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d01e1168-2e92-4866-becc-42dc59a467cf	rhoncus mauris enim leo	narmitage1d@about.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c895ce3e-0df2-41f9-927d-4e8aad9db54d	fringilla rhoncus mauris enim	cspinella1e@xing.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a5213291-1279-4d51-96fc-a54adc6447ab	velit donec diam neque vestibulum	bcarlyle1f@barnesandnoble.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fda81b88-f6b9-4993-8867-e4436c27cbc4	morbi quis tortor id	klehrer1g@quantcast.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9ff6d4c6-f6bd-41ba-ae5d-6896f8a99d70	tristique est et tempus semper	vbortolazzi1h@51.la	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
69e73fdb-b025-44ae-af40-c0955924b4c3	mollis molestie lorem quisque ut	cbowsher1i@cornell.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
af12c0b7-cc45-4681-aa3e-1caf8a5d474d	iaculis diam erat fermentum	gstelfax1j@surveymonkey.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ddf73de0-fc75-465f-80b0-797b639369f0	ipsum ac tellus semper interdum	jhindshaw1k@dell.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c487b003-16c9-4a4e-8c7f-2a13f8496672	tortor sollicitudin mi sit amet	nworld1l@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
93872562-3106-45fb-b14b-c3a003f843f6	eget congue eget semper rutrum	ksorley1m@instagram.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9ff0fb20-3515-4455-9d37-2ac4f3355124	amet lobortis sapien sapien non	mmckim1n@clickbank.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
242370db-7796-4be2-8000-587124d31145	in sagittis dui vel nisl	lluca1o@go.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
44af3aa2-1e6f-4159-bec4-422b11427aea	nunc proin at turpis	nbreckenridge1p@discuz.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a3424ee1-8d78-4989-b23c-f48d9d3fd2ed	interdum mauris ullamcorper purus	bkehri1q@upenn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2e1c87ac-dcff-4d4b-a4b7-90e6ca09bdf0	et magnis dis parturient	jgear1r@bigcartel.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cefdd6a2-4270-42fc-a3bf-1a0f13af4659	eu sapien cursus vestibulum proin	gbrailsford1s@acquirethisname.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5a94bd20-6d9b-40f7-913d-b3a369a0edb5	lorem id ligula suspendisse ornare	sdealtry1t@homestead.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8cdd11e4-95be-4cc8-a1d5-49080aabbc8b	molestie lorem quisque ut	mhavard1u@google.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
62da7807-9db2-401f-bfaf-07936196bf39	natoque penatibus et magnis	ofranzel1v@technorati.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
836764ce-2887-44d2-99f3-bea3e4e886e3	sed magna at nunc	rmorganle@chron.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
28c64afa-eeac-4193-ac3e-a408fe8d2f23	gravida sem praesent id massa	gbridel1w@xrea.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0534a80a-064e-483f-8ef3-debadd04b6c7	malesuada in imperdiet et commodo	egass1x@geocities.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7cd9c1eb-84f0-4045-a198-c44f4a7c9fe1	morbi ut odio cras mi	bhatrick1y@prlog.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
071b351f-8fd0-4656-bd37-e218663d1c00	in hac habitasse platea dictumst	emulvenna1z@taobao.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
deed74cc-86f6-4be3-b300-101c1f632ff2	at nulla suspendisse potenti cras	kyellowlee20@networkadvertising.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eff3d0cf-f7e7-40ca-ae62-89fd78c4abd8	ridiculus mus etiam vel	ematiashvili21@usnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aa9e3d14-a591-4268-a01f-de73ce832ac4	malesuada in imperdiet et commodo	vfeaster22@shareasale.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
763f796c-9a03-4934-ae62-061cfe1a4a07	molestie nibh in lectus pellentesque	eclayworth23@example.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5981a9cf-9789-4420-a76b-1850dfd525f4	ipsum integer a nibh in	yhuniwall24@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc7cb9b6-8b8e-4afa-a9a9-c16b719c692d	mollis molestie lorem quisque ut	ddavidavidovics25@sakura.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e785cf69-74ed-4813-ace6-e46ffb7f3875	nulla justo aliquam quis turpis	lsoppit26@merriam-webster.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5013524b-03bb-4c9f-b656-ffd183e55a18	viverra dapibus nulla suscipit	wshepland27@ehow.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3cfad4ce-44dd-4f90-a8b1-e0f185209b91	maecenas rhoncus aliquam lacus morbi	eseyers28@taobao.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
315114b1-9368-4152-b921-025e74146390	felis donec semper sapien a	gortsmann29@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
541ad1d7-98c6-42ba-9252-6dc776da1d71	donec dapibus duis at	cbenech2a@uol.com.br	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
82a74b71-8e30-4e7d-aec6-c0d02867853c	sed magna at nunc commodo	ajoberne2b@wiley.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2776ab75-2cff-4412-b7f5-ae1714bab55e	dapibus augue vel accumsan tellus	rspencley2c@google.es	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e015919b-d953-4922-83e0-f7b0eb02f87f	scelerisque quam turpis adipiscing	asculley2d@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6501ad90-e517-4f91-89c4-f3065ef07a07	consectetuer adipiscing elit proin	ndemschke2e@accuweather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9f72cc06-4bc1-4096-8c9f-0518c37c02f7	morbi non quam nec	vjobbins2f@hao123.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ed4ba2c4-e92b-4b6c-8d52-93d1cf5ef707	volutpat erat quisque erat	kdummett2g@ox.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f287c7f1-0fe4-49d8-bef0-7747c1f17326	convallis tortor risus dapibus augue	rblackborne2h@sitemeter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1ab6eb59-ff73-47a7-a3d2-1b17f92a2656	rutrum rutrum neque aenean	sanstead2i@blinklist.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
576228f6-46da-496d-9847-a0c9aff683da	dictumst aliquam augue quam	thuban2j@discuz.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
76640820-6f79-4d89-8099-e8385b2b7fa4	et magnis dis parturient	aroderham2k@tripadvisor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8c211f53-e599-4f39-9b7e-64f36a414f3b	ligula vehicula consequat morbi	jkeast2l@csmonitor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
48263fe2-0654-47ef-91da-622151305f06	ut nulla sed accumsan felis	eriden2m@scribd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6227095a-eb5d-48c9-8898-73bee512ea4b	tortor duis mattis egestas	dshall2n@wordpress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
522a1913-7cfa-4cb3-807f-466fc5bdd9f9	libero nam dui proin leo	mdeverell2o@amazon.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6b3f607e-1874-46f3-9b8e-204a9ec7f35e	augue a suscipit nulla elit	mmillett2p@salon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0b133972-7744-4701-a411-0b3db31b97e5	in felis eu sapien	rbow2q@multiply.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7d3e50be-a1ed-4c45-baac-904700fb6dd6	adipiscing lorem vitae mattis	comullane2r@senate.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa9826c9-fa14-4318-a4e8-0fc1bae6b366	ullamcorper purus sit amet nulla	ushefton2s@etsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3e12c162-46a8-47b1-9cfb-3fff9501f6a1	ac consequat metus sapien	bduffit2t@fema.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
299ac0b1-7fdf-4ed9-9c26-6843c5dbaf60	elementum eu interdum eu tincidunt	phuffadine2u@is.gd	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0771d7f6-c009-48a9-b8f0-4c4831387f10	magnis dis parturient montes nascetur	khambribe2v@nydailynews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e9ff238c-3c9e-40c0-b970-91f816544406	sit amet eros suspendisse	adesquesnes2w@homestead.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa836956-2503-4361-ad0b-6e6a66e58413	praesent lectus vestibulum quam sapien	tdaw2x@wikia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6bb7d1ce-771b-48b8-9601-1ce04a24fc27	tortor sollicitudin mi sit	ctwydell2y@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0489dac7-df1f-4fb8-9c03-4e57e61a8545	fermentum justo nec condimentum	ssummers2z@google.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9817fc8d-f17c-4eb0-a308-d7b06b081da8	id ligula suspendisse ornare	oferneyhough30@livejournal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
05353d8e-0f9b-4585-87c7-75b1883dceae	sollicitudin mi sit amet lobortis	csarsons31@loc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
20bfa9a4-3a2a-44d4-96e1-0e20ccf2c24a	rutrum neque aenean auctor	bcavet32@bloomberg.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
faeaa0f9-feb6-499d-bb70-6213660577e6	lacus curabitur at ipsum ac	ccattell33@t-online.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c8e83e88-ce78-4377-a36f-be4afd694031	quam suspendisse potenti nullam porttitor	kglassman34@hostgator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5e534def-4117-4667-97cf-40aae09524d7	morbi non lectus aliquam sit	jwoodroofe35@stanford.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fc2a27c-26b8-47f5-b025-ef9219cb4fc4	maecenas rhoncus aliquam lacus morbi	vwomersley36@stanford.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b8fa14d5-7a3d-405d-baa5-fd0247296051	tempor convallis nulla neque libero	silyinski37@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1b1b1e31-7b86-4dd5-b042-0eb38f0d26a0	feugiat non pretium quis lectus	tpolding38@hud.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a76ac4c6-cdb6-496d-86ba-94a98e69f1ba	lacus curabitur at ipsum ac	ggraith39@washingtonpost.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
51182f6b-1aef-494c-b0ab-7b65c1c20f68	nulla suscipit ligula in lacus	zferryn3a@usnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a759f896-2214-46c9-80e6-d6566a1d27ed	ac nibh fusce lacus	gtschersich3b@furl.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f9f4f35d-912d-4a39-ad1a-2d113dde1532	odio justo sollicitudin ut	rbellin3c@csmonitor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
12cf8831-eccf-4fac-9d91-8fc9a30add3e	tincidunt eget tempus vel	demerson3d@blog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
56204045-9ed6-4043-a638-69ce1ac9cab9	at vulputate vitae nisl aenean	mdeldello3e@barnesandnoble.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d872ca1e-887f-44d1-a0a0-bf1621ea6016	volutpat sapien arcu sed augue	hpyer3f@vkontakte.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
85ea2922-d772-48ed-b418-906988e581e1	consequat varius integer ac	adorrell3g@merriam-webster.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
12ac2fff-8f3d-4eb7-9b68-c76fc1fbdad8	nisi eu orci mauris lacinia	jheinsh3h@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5e4a5339-8386-481d-ac34-8f4fce114ced	ipsum ac tellus semper	grummer3i@livejournal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e4a31903-86d5-4004-ab47-9ffafda4f34f	in imperdiet et commodo vulputate	gstitfall3j@sogou.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ad0aca16-80d7-44a9-97dc-a82a04739e81	varius nulla facilisi cras non	jpledger3k@furl.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b87d3047-b836-4bcb-91c3-ed8d93026f4d	vitae ipsum aliquam non mauris	lstratiff3l@paypal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d43eb34a-cfb1-452d-ab5a-3aaf358e898a	odio consequat varius integer ac	ghunnicot3m@slate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1301befe-0a78-4358-9458-b018f26effca	porttitor id consequat in consequat	lgiriardelli3n@prnewswire.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
df6089dc-1d74-4693-b0fe-3822eec1d395	pulvinar nulla pede ullamcorper augue	mcampos3o@yandex.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4918dce9-e477-4029-b77e-c9bd98ed5135	in hac habitasse platea	cnesbit3p@amazon.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2cb01139-09d3-4139-9c63-e99efcd6707e	eros vestibulum ac est	rspalding3q@psu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cae679d2-9b50-4191-8ec2-13f2705c9fa3	pharetra magna vestibulum aliquet	slufkin3r@qq.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
baf1e99f-21f3-41ea-9a3c-d85814df54ad	nunc vestibulum ante ipsum primis	tlarman3s@utexas.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e9a2eb57-88a2-40c1-bf6f-6256ecb75f24	tempor convallis nulla neque	dgrob3t@blogspot.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f2721025-aba2-4ff9-a20b-3c0062edcc1a	sem duis aliquam convallis	cboxen3u@hao123.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
61538f2a-e9dc-4b4a-bc1a-7df39cd2fbe1	consequat dui nec nisi volutpat	dlamlin3v@hatena.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
99ba443f-854e-4ef8-9cf8-871d7578c305	ultrices phasellus id sapien	ggrealy3w@behance.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1d5b427a-1f6a-44dd-8af6-01a71d5f34ed	eu est congue elementum	msimonazzi3x@ovh.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b1f14be8-37b3-4a8c-a164-1eb20c2a96e3	fusce congue diam id	tpollastrino3y@wordpress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
15acf686-50f0-423e-9d2e-5d92fceb9df1	massa donec dapibus duis	jplayfair3z@chronoengine.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cb0907fc-f9bd-449d-b90f-ca101475eaa9	suspendisse ornare consequat lectus in	gspraggon40@omniture.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f981102f-53f8-4b66-be6b-1755a72715e2	bibendum morbi non quam nec	apeevor41@people.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
44a3c1e4-8db5-45e0-a2dd-e2fe44b62c99	nunc purus phasellus in felis	wballendine42@marriott.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
da0b9086-534a-45c8-9bc7-af27d10afd1d	etiam faucibus cursus urna ut	cwing43@uiuc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4155a86d-671c-4f60-a945-a4b6c47d2786	morbi non lectus aliquam sit	cdermott44@ed.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
afd0ca3a-199c-447e-9d18-31f271a34646	consequat ut nulla sed	gcorstan45@theatlantic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
75a72fe4-7dcd-4efe-90e0-6c348ca16f42	nonummy maecenas tincidunt lacus at	blunt46@spotify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cd924776-c70d-4de4-8e88-ec46b25b30ce	etiam vel augue vestibulum	mstedson47@vinaora.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4ef64dec-d232-4495-9b54-939347fe6733	pharetra magna vestibulum aliquet ultrices	orosewarne48@histats.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b377c9fa-eda9-449e-8bd5-6e12405e4959	elit ac nulla sed vel	ndaens49@trellian.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
89532428-15e9-4932-b7ac-0c4f072fc1bf	sapien cum sociis natoque	sbrusby4a@umich.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a6c3fe11-0835-42f2-95e2-ebf47a366b88	nisl venenatis lacinia aenean	nbenoy4b@loc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3ca8c990-2dbe-47d3-baa5-a10630cf3a9c	sit amet sem fusce	phaggart4c@oracle.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
72fd9655-7400-45d8-b227-e4250b0eb0e6	venenatis tristique fusce congue diam	dmaccartair4d@4shared.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0c0cc9c2-beda-422a-8f75-e13b8fb80415	in felis eu sapien	rleverton4e@admin.ch	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8df50aa3-5782-48b0-ab00-a889fa198c32	id nisl venenatis lacinia	lliff4f@telegraph.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
24b22590-f6da-4ab3-9a88-e1c33cc1fec9	ipsum dolor sit amet consectetuer	kconstance4g@yellowpages.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18c8188c-1b7e-4064-8490-8522528ae834	cursus urna ut tellus nulla	dreggler4h@yellowbook.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
306a37d8-c4ee-4495-99c2-741cdde7090d	consequat varius integer ac	camberson4i@home.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4976bd99-4f2e-44a9-8bda-42dc6e9eb2b3	vestibulum eget vulputate ut	gsnelson4j@skype.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b41d64db-11bf-4894-ba33-70feaef7bbf1	vitae nisi nam ultrices libero	gsonger4k@slate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
40cb73d0-6db8-4960-80b2-0325ce2ff084	id mauris vulputate elementum	kreedick4l@cbslocal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
42fa8888-2725-4092-859b-cbd7581c426a	maecenas rhoncus aliquam lacus morbi	eflori4m@myspace.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
46708d58-edb4-4ac8-b84b-2f73222c621c	sit amet consectetuer adipiscing	sfraulo4n@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8eeb8b22-333e-45bb-928c-1e2544f5819b	in faucibus orci luctus	tmortell4o@ucla.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c51146e9-f0c8-495e-8b03-363b24433439	sit amet diam in magna	sscotchmur4p@dropbox.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
95f81659-a717-4419-8525-d18b8276b779	quam pharetra magna ac	wmaiklem4q@lycos.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
46ebea9e-fdcc-4ac0-b547-d9257457b5df	condimentum curabitur in libero ut	vcauderlie4r@apache.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
29393512-1e57-494b-a6ce-ba932e8f31d0	adipiscing elit proin interdum mauris	jgreated4s@nyu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2c75199a-155a-4011-a750-c907c392e3b0	primis in faucibus orci luctus	gseabrooke4t@wp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f1bcbb27-1e36-45d9-8ab5-e7f4cb0a0ddb	ante ipsum primis in	phaddrell4u@umich.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bbfbe44d-14d9-402d-acb5-4e18d5b18afe	ipsum primis in faucibus orci	cpanas4v@msn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
33c59aef-a09c-4b5c-9c02-90dcad4c8ae7	tristique est et tempus semper	wnickless4w@wiley.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c74451a7-d733-4b91-ab34-71dade63fb11	amet justo morbi ut	ybaterip4x@wix.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
de54f438-9c17-472b-b868-797cb315c98d	at feugiat non pretium quis	tnewstead4y@surveymonkey.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6e6f2532-7bf2-48da-93f2-676a3c03818b	sem mauris laoreet ut	adillet4z@fastcompany.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c3b5947d-806e-46b7-87d2-979cdbc65650	orci mauris lacinia sapien	tduckit50@elegantthemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
88788896-9caf-48bf-8960-64f59fd83890	viverra pede ac diam	spimm51@networksolutions.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e6948266-b430-450c-9f9b-4f3b2e2d0996	in purus eu magna	mjirusek52@pbs.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e5b9963a-da6a-4b0b-8caf-23196ac96b2c	adipiscing elit proin interdum	pfouldes53@ibm.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fa5518a-b351-4801-86e8-04a243018420	dignissim vestibulum vestibulum ante	fkinnen54@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1af9fbb5-38c5-4803-8c8b-8f92f419f297	lacus purus aliquet at feugiat	dcoltan55@msn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
443564fd-31da-460b-b7ef-8be8168d4c7b	gravida sem praesent id	agress56@irs.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
48801623-f4d3-41cc-81a8-0acef0884ae7	nulla suspendisse potenti cras	vspurrett57@wired.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b2adee18-1274-4626-9930-a1db0feafde7	platea dictumst etiam faucibus	kadao58@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
36e8e6e5-604b-4471-bebe-73e9f0a8d32c	arcu adipiscing molestie hendrerit	promagosa59@dailymotion.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ce0f8c6d-6945-450d-a131-cfae8be1b12a	sed lacus morbi sem	garnhold5a@jugem.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe6ba5e2-6456-4fc9-91df-601f095f0181	sed vestibulum sit amet	osuddards5b@yellowbook.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7f3953a0-71da-4b96-9b62-f567a513508b	ut erat id mauris vulputate	ielsmore5c@bandcamp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2b98cfe5-b4b4-4984-bf10-ce1a67ed73e1	donec semper sapien a libero	amomford5d@cafepress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
849ecd1c-f071-494c-8ec4-580aff142ea2	mauris vulputate elementum nullam	bjermyn5e@gnu.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6f3a42c5-a91b-4a5a-b9f7-b1de67a0200f	nulla integer pede justo	sclaricoates5f@epa.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
33b35274-80d7-4ba5-901c-ed0e77a82aa5	enim lorem ipsum dolor sit	fdow5g@opensource.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1f274993-8c62-44ee-a5b2-9e90791175bc	ipsum dolor sit amet	dwakelam5h@samsung.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c2f4f8b7-51f1-47d7-8353-f31dfe8ead67	consequat varius integer ac	hclemenson5i@google.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1ad992a0-e8f4-4592-94d7-d3819c22bb7a	in felis eu sapien cursus	rreavell5j@seesaa.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f94442d7-4649-4c4c-a30a-5ff6b0f7d1d4	dictumst maecenas ut massa	acatton5k@barnesandnoble.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d1b29906-858b-405d-8bfc-9d9c688881ba	ac enim in tempor turpis	msebert5l@dropbox.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f3c4c61a-6429-4953-ba77-0e28e3cfc78f	non quam nec dui	vbrumbie5m@smugmug.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bb71d39e-7093-487b-8e6a-2be52b6ec5bd	odio curabitur convallis duis	hessame5n@oakley.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
565f6cea-1e06-4af8-b8e2-f4302d8bbf3b	sapien urna pretium nisl	bknill5o@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4d7d0cf7-88f8-4963-b7a1-7cfbcf2a5050	cursus id turpis integer aliquet	tcottam5p@squarespace.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5cf53c78-69f3-4f8d-831a-de21c9c83541	in hac habitasse platea dictumst	enotton5q@nsw.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb479092-7c5b-4550-90f5-3098b095c2d3	vel augue vestibulum ante	tcollibear5r@engadget.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e828445b-6bbd-4e00-864e-f0bafed8aaad	integer tincidunt ante vel ipsum	rhearle5s@flavors.me	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c0f4b06c-eaa7-41fa-bd27-dc2973da4019	lacinia aenean sit amet justo	cfilipyev5t@ucoz.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bb87f8f2-e257-47d0-b74b-18037adbd2c7	pulvinar sed nisl nunc rhoncus	gsexty5u@opensource.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6537c324-fe4e-489c-a19c-a09615f1ea86	nulla ac enim in tempor	jbruster5v@goo.gl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
57549ff8-deaf-477a-bb6f-e9e9d834e4cf	congue elementum in hac habitasse	kyea5w@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa315bcb-3a30-4bbd-aff7-9a906ecd05ac	donec ut dolor morbi	grodgerson5x@friendfeed.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9b71db32-2e8d-4738-9591-bcdac6dd6d67	tortor quis turpis sed ante	kgronous5y@oaic.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
51c1fc30-ceee-4bd4-b6c0-98d7f345e2df	fringilla rhoncus mauris enim	ehansod5z@jimdo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3a422928-7df3-4ddb-a506-76ee587c1e56	aenean lectus pellentesque eget nunc	jsidaway60@foxnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc744558-fb85-4221-aebb-bf9da4f66cd5	elit proin interdum mauris	mcastan61@hao123.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fab6f7c3-ecca-4897-8176-eb2c46b36575	vel sem sed sagittis	blabbey62@topsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ce136afd-43e4-4194-adea-5ec300a6c463	at turpis donec posuere	oilyushkin63@bigcartel.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c91e2941-1dd8-498d-a089-a9d000406b5d	pulvinar lobortis est phasellus	dmeece64@1und1.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4d4aa4d3-0576-437a-930d-fd2e202f0c8f	volutpat quam pede lobortis	dsproul65@elegantthemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eda495a0-c706-4093-a58e-a4f52c855171	at dolor quis odio	dcompton66@ft.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e0bfb10c-3af5-4a6f-af82-cda81345fee9	accumsan tortor quis turpis	abernardini67@oaic.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0105ffac-e3c6-4c4a-acba-13e8c6633e8b	elementum pellentesque quisque porta volutpat	kbuggs68@ifeng.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4b8b35ef-104d-407f-b415-dc524abae3be	platea dictumst maecenas ut massa	gnorcliffe69@flavors.me	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
16938398-a520-4757-942a-1df8896bbbda	dui vel sem sed sagittis	lstockley6a@amazon.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
afc17e98-e0c8-48da-acf5-eb5216e9b3ab	ut dolor morbi vel	cgulliver6b@accuweather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe78e423-a154-4944-91d5-a855e4b71e49	volutpat quam pede lobortis ligula	tcroxton6c@dailymotion.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a2f1a942-026c-46d9-be43-12b8c76e3e97	augue vestibulum rutrum rutrum neque	karmitt6d@wikispaces.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ba54b19e-bd0e-4c3b-9f6a-7fafd95d4f08	tortor sollicitudin mi sit	smotion6e@wired.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f205e150-ebe7-4dde-a27e-e88060293e4a	eu mi nulla ac enim	ocrallan6f@xrea.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d8157441-11b3-4a3f-81c8-814fabb9804f	congue elementum in hac habitasse	kagate6g@altervista.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5d35d17b-3c48-4cd5-b30a-25d25eb0eb0b	duis ac nibh fusce lacus	snannini6h@hatena.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1cca8b9a-9c38-4eb0-bbee-9555a88f7767	at feugiat non pretium quis	jachurch6i@360.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4ffd6975-e624-4d75-96de-6994ce827ba2	hac habitasse platea dictumst	abyneth6j@csmonitor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
005ea466-2847-44b8-b342-d67094a6c196	eget eleifend luctus ultricies	gleachman6k@last.fm	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
39f6f19a-6a4f-42b1-b30d-352948fdd48d	sem praesent id massa id	ljoder6l@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7141dc68-a75f-4fc4-94b4-a0b9c10068e6	odio justo sollicitudin ut	somalley6m@unblog.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2e1a4a68-cd03-4ba4-8850-d5a048f69545	magnis dis parturient montes	eshergold6n@imgur.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b423998b-d273-4be1-b118-d4c24e12562c	amet turpis elementum ligula	pmobius6o@cbc.ca	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7bfd2933-86a5-4b7d-9f2c-a34afc029ea1	orci vehicula condimentum curabitur in	sbeel6p@nyu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3add90c3-740e-4b6b-83b7-f90a30fe6074	donec diam neque vestibulum eget	gcancellario6q@theglobeandmail.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5da42bea-05ab-4d21-8194-82aedc0d9dba	morbi odio odio elementum eu	aschottli6r@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
608ad1eb-1200-418d-8a7a-267929834fab	neque vestibulum eget vulputate	seastway6s@bbb.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4d78edc6-43bd-49a3-a14d-434fbfe3db61	vestibulum velit id pretium iaculis	jsaunper6t@gravatar.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
255c543f-49b6-4144-b995-1185c1ac7116	enim in tempor turpis	gpencott6u@independent.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2bdd031b-7cd7-4503-8308-cc241509db47	mi pede malesuada in imperdiet	jdumbrill6v@rediff.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a406b8fd-b6f6-4a5b-975d-3274fdc22984	vulputate ut ultrices vel augue	lvanhalle6w@ed.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
36d911da-da21-4724-927d-5f0389b8c155	purus phasellus in felis donec	cfulloway6x@xrea.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
111c1c4a-18f7-4382-815c-68b51830f36a	mauris ullamcorper purus sit	shoyland6y@ed.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6fa38941-311f-442e-9340-13f51d1a4363	leo odio condimentum id luctus	lcrasford6z@hc360.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d865372e-faa3-45de-ab03-90e2c4f4ba00	nibh quisque id justo	squaife70@si.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ab48c3eb-d964-455d-881f-97faf8f1a19d	risus auctor sed tristique	telles71@multiply.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
706197ba-3cba-4c9b-9431-8ec49c4a01c6	porttitor lacus at turpis donec	jfielding72@pagesperso-orange.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b6d4ad4e-695f-4f31-88d8-cca452e3407a	lacus morbi quis tortor	zharrowell73@people.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
daf85c67-5203-4732-982f-8c0e61807d60	eget vulputate ut ultrices	asowersby74@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7a52dd4b-3550-4617-bd7f-043ab2a641b8	sapien cum sociis natoque	mmcgonagle75@ocn.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aa6ff445-dcd1-478e-8e76-6ff1daad2f14	nam nulla integer pede	wkilmurray76@jimdo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0f334aa1-fd3d-44fa-95c1-a5354160f7ca	quis augue luctus tincidunt nulla	ssweed77@privacy.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
acce6966-9917-459c-9285-dae8f366069a	sed vestibulum sit amet	hraselles78@bloomberg.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dc0a6ed5-1baa-431d-9deb-287be9cdad53	mattis odio donec vitae	mjiran79@amazon.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f1835047-2c1a-4b76-afbd-02d26bb6b135	porta volutpat quam pede lobortis	vmacanulty7a@eepurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8b0b8c20-4fa1-439a-90a6-7f5a26d7cbbc	ante vivamus tortor duis mattis	ssmallridge7b@a8.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c9ded4c0-3ea7-47a1-827b-29e14963410f	interdum in ante vestibulum	fcasterton7c@behance.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
04a4a84d-5a87-4223-8c33-7ba39a628aa4	eget orci vehicula condimentum curabitur	kdark7d@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d6a5db0d-2383-4142-872c-0884282363c3	volutpat in congue etiam justo	tmatovic7e@eepurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b6a93203-51df-441d-a4e9-8357dc3c57aa	enim leo rhoncus sed vestibulum	sbatters7f@shutterfly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
582b8d6b-d677-4463-af5b-db4c0194210b	sed augue aliquam erat	ajovasevic7g@accuweather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a5457a35-4f20-4f04-9d9f-0d97e88106d6	felis sed lacus morbi sem	mlynch7h@163.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
114b1b1e-ae05-4770-a6f6-75a97e8704a5	et tempus semper est	kdunican7i@eepurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5ed84390-ec69-4639-9ddf-d77a25061a2f	ornare consequat lectus in	tcholmondeley7j@tiny.cc	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8eaea561-502e-4415-a96a-c9ca8ae11622	nullam orci pede venenatis non	rgradly7k@usatoday.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
091acb41-773f-4d2a-b4fb-d33ffdc137bb	venenatis lacinia aenean sit amet	joffa7l@wisc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
815bca00-5628-4717-82ab-3c5844fcc050	libero ut massa volutpat convallis	dczapla7m@businessinsider.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5d2875de-e7ed-4e31-8eaa-ae8c7c51a573	suscipit nulla elit ac	zcoch7n@japanpost.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1dbedd79-a461-4a51-9cd9-6076290cf0d8	aliquam convallis nunc proin at	wallright7o@lycos.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e699fbd7-339f-4112-a72d-a9020efff067	platea dictumst etiam faucibus	rcowey7p@toplist.cz	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a79148f9-7417-4375-b350-2964486a2d0c	cursus vestibulum proin eu	btrorey7q@ebay.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
742e4942-91e8-4673-a5ac-8ceadf4e4c93	pede malesuada in imperdiet et	jgerrey7r@etsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
74c5401f-f431-4848-88b4-910952b82f25	habitasse platea dictumst maecenas ut	sseymark7s@drupal.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d5be2e70-5ed2-4266-852c-7d7a457438c9	volutpat quam pede lobortis ligula	ntuffield7t@twitter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
134dbdb6-877b-4478-b4c2-c9a06958a33e	erat nulla tempus vivamus in	cchristofol7u@slate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a4f42833-63db-4d30-9f1b-5de562b36809	sed magna at nunc commodo	tcouch7v@hubpages.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6318f4a5-313d-47c9-88c9-3edf06d108c7	nullam porttitor lacus at	ngreet7w@usnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2912c00f-f5ed-4411-ae00-704e32d85555	eleifend quam a odio	aeringey7x@nasa.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e6e8561a-c9d8-45bc-9512-6ca8211b7856	integer non velit donec	otrangmar7y@amazon.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3727e34b-e7ab-44a3-b8a7-b3b1bf971a6d	lectus in quam fringilla rhoncus	jlackeye7z@weibo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
274428cc-fea2-4c89-88aa-6eadc0b1cedb	eget nunc donec quis	lvanderbeken80@newsvine.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ad450c30-79d8-4762-ad7d-3b118533c789	vestibulum quam sapien varius	bmacian81@biglobe.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
31ee4e82-4dc2-44f4-898d-2f2c95330b71	suspendisse potenti cras in	cbroadbere82@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b22e4ddf-a20e-4c85-b3db-c6d389f38be1	lobortis ligula sit amet eleifend	ppudney83@marriott.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4f24319d-db28-41fd-bbca-ba5354063616	orci luctus et ultrices posuere	cmulvagh84@rambler.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
90e464db-5355-4a20-b1bb-8c5d5cf46ad7	tempus semper est quam pharetra	hattwell85@gizmodo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
66110541-23b5-4e19-9515-de22b0829a63	curae duis faucibus accumsan odio	nfolland86@barnesandnoble.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5975a184-36e9-40ed-b4b8-6782199da858	est et tempus semper	jbenbrick87@livejournal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b25b3acb-06fd-4a94-8bce-b77cb46ac2d7	odio justo sollicitudin ut suscipit	rsenyard88@wsj.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c59a8e84-1d0d-437f-96ab-cf5d7f7e3788	quam sapien varius ut blandit	nashmore89@people.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fbef497f-7db1-43a7-a2fb-61465d8291b6	metus sapien ut nunc	draulston8a@nih.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d109c5c0-b88e-47b1-9967-47c19bde3737	vel nulla eget eros	slesurf8b@hatena.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9fe2bfe1-5fd7-4885-b260-f4dfc6c7005f	elementum nullam varius nulla	gdalliwatr8c@bizjournals.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
141d8c14-4a1f-4b3d-8ee7-0292d0490a3b	nullam molestie nibh in lectus	smackaile8d@tamu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dff31a71-9fc7-468a-baea-92e9cb7be8f3	ultricies eu nibh quisque	tyude8e@sphinn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9986f9a4-5027-446c-8b05-df5fa397075b	ac tellus semper interdum	itodarello8f@trellian.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
34f880b3-4ad7-407b-9b13-0849b84e2e32	maecenas leo odio condimentum	eidenden8g@yelp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
39e2f8c6-2e25-43b0-a8ae-259188785fff	vel nulla eget eros	mtebbit8h@examiner.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
24dfe947-70b1-4b0e-911f-1900603e5eac	duis consequat dui nec nisi	gkettel8i@gov.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
80d586e6-b92c-45f2-b7b1-88f6ff63ca75	ac enim in tempor	lbeese8j@rediff.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0c9a896c-29c8-46b7-8469-90ffadc38b3c	turpis elementum ligula vehicula	kwoodroff8k@nasa.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8a1ce967-a245-4fb7-8104-af299d67fa20	integer tincidunt ante vel	nyoselevitch8l@stumbleupon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f0512368-5715-4b6d-a85d-9b12c325d5cb	est congue elementum in	tpaslow8m@dion.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3f1b1834-828a-45e1-94d0-a32f73edd2d0	nulla suspendisse potenti cras	zfaulds8n@engadget.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2cd5a2c2-abed-4a71-a9de-0343622b8bd0	dolor quis odio consequat	mchadwin8o@google.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ed6999ce-8543-41c7-9dda-f5cfea6d5c37	vestibulum ante ipsum primis in	kgladdish8p@paypal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8194ab81-42b3-44e8-91c1-47b887d07ea3	aliquam erat volutpat in	aradmore8q@blogtalkradio.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0ad8c796-e0ff-4509-b1dd-deb37d50ec3e	metus arcu adipiscing molestie hendrerit	wblasl8r@wordpress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c4866330-d51e-4c26-9550-260ade2c4958	amet sem fusce consequat	jgroucock8s@wikia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
73acf395-b113-42e0-9391-57c6143456f4	id lobortis convallis tortor	jgaley8t@cnn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2b6336f7-a67c-496b-89ec-60969da85f11	pulvinar lobortis est phasellus	kpawlicki8u@squarespace.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5394596a-9207-4584-bde1-fd78a915287c	luctus et ultrices posuere cubilia	ebrickett8v@answers.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8057d2e0-52ac-498c-a30f-6157fc6c549d	in ante vestibulum ante	ctimothy8w@4shared.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d1b27565-beeb-4317-8460-e991eff037ed	porta volutpat erat quisque	rmignot8x@google.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9995b4f6-77d2-4c8f-8a76-574653b88232	nulla quisque arcu libero rutrum	stapenden8y@boston.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
849a2133-71a9-4568-81da-669ae2bebbff	primis in faucibus orci luctus	jsiggens8z@youtu.be	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cca17869-45ee-4ab9-938a-77ffe5d391f5	nunc rhoncus dui vel	mcannam90@imageshack.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
80c4adcc-68ec-47c6-9096-420716c1971b	in felis donec semper sapien	gpawlik91@dell.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
129e303f-90dc-481f-bf39-38d25395e3dc	nibh in quis justo	gsmeaton92@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
769d29ed-b7f7-49d0-8ae7-38b40c866fcd	metus aenean fermentum donec ut	btozer93@ucoz.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
60a641df-592e-4688-86b8-d0f5e8fd58f8	turpis a pede posuere	smilham94@cpanel.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
74dd4cc7-946c-4a6c-97c2-4fbd13eaf468	purus sit amet nulla quisque	adefraine95@clickbank.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b01914c2-ad3a-452d-ac92-c30efc0dd10b	varius nulla facilisi cras non	arobottom96@tamu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cc601655-da93-4d86-bee4-51b19294bfed	porttitor lorem id ligula	ariseley97@yahoo.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c66af018-878e-49fc-bad5-f78084884dd4	placerat ante nulla justo	dscowen98@hc360.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9654ff0a-17f8-464d-aa42-a99d01ef3575	enim blandit mi in porttitor	amorgan99@amazon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
44c2a178-1d7d-4793-815c-2b28d04dee81	porttitor id consequat in consequat	lfeben9a@ucla.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a0e1448c-37ee-4e1d-ba5f-7b2a30b021e8	eleifend donec ut dolor morbi	bimloch9b@canalblog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8fe47604-64cb-4478-ab56-ffdb12b68067	eros suspendisse accumsan tortor quis	rcrush9c@dedecms.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8fc34f85-616e-4201-bed2-bfbd9c158a8c	risus dapibus augue vel	hhamil9d@miibeian.gov.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fb10a3b-c475-4a2a-8311-e576e230ca87	suscipit a feugiat et	mcastagnone9e@eepurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
53fd823f-f0b6-4846-a86a-5a6f32b082ed	eu mi nulla ac	rshore9f@wired.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
56a743d4-f5fb-4d75-a5f3-d00876372458	habitasse platea dictumst etiam	djeannesson9g@t.co	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c14ced2d-5be0-43b7-916c-fb32f93eda44	ligula nec sem duis aliquam	pleeves9h@ow.ly	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e236c62c-8fa4-46f7-8afb-2d3a40f8f726	eu massa donec dapibus duis	dcollyns9i@networksolutions.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
98bc4ffa-0f02-4922-acca-7a314a1ca988	sem praesent id massa	njahnisch9j@jigsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9a9bbcb5-5319-4be6-a992-a5b81c9c59fe	maecenas tincidunt lacus at velit	dlivingston9k@dot.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7d13f666-ead3-4e2a-8acf-36a2ff44a80d	montes nascetur ridiculus mus vivamus	jshemilt9l@jalbum.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bbd60c62-2c08-4d75-ad20-672a89ff9cb9	vulputate vitae nisl aenean lectus	lcaffin9m@mlb.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aca3e93c-8139-4e13-b4b6-4c494146e059	id lobortis convallis tortor risus	jcamous9n@va.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c984e9c5-4a0d-4230-8ed8-2ae518f25857	felis fusce posuere felis sed	hmeade9o@shop-pro.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
12b2723e-4f18-46be-a048-04c803213455	hac habitasse platea dictumst	pemm9p@wp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
78847713-061a-4e73-a32d-d2628d9fa33a	sem mauris laoreet ut	landrin9q@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
631ff886-86ce-43c8-95f9-cfb81eba5e92	ante vivamus tortor duis	tcurry9r@stumbleupon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
832ba76c-d38e-4ffa-b09c-bb8eba61db56	ridiculus mus vivamus vestibulum sagittis	lpirkis9s@indiegogo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9200f5eb-da71-4b93-89c6-2b3292b2b16e	augue vestibulum rutrum rutrum neque	hfloyde9t@networkadvertising.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4308d6be-8a4d-46f5-8060-4abc5eb6ac36	venenatis tristique fusce congue diam	kkirman9u@live.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
249e9ce7-3762-42e4-8de8-69ec7efb44af	mattis egestas metus aenean fermentum	rmccutheon9v@amazon.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7c3b7aa7-65ca-4731-bf8c-1a8020fef8e5	nec molestie sed justo	jkibel9w@un.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
adbfc61b-8950-4067-b9f6-5bc167270e8b	orci vehicula condimentum curabitur	wcrunkhurn9x@umn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
724f9c19-ee5a-4d66-8eb6-db30622d7355	venenatis non sodales sed tincidunt	fellwand9y@nps.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
35d4855c-3c42-4d28-9402-34478e73934e	duis at velit eu	mmarrett9z@bravesites.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cd3784d9-57bc-4d1e-8257-a5f6db400f99	mi pede malesuada in	mmcdonella0@last.fm	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1e057d9f-17e1-4f6c-86cb-2861227f7fc0	at diam nam tristique tortor	tgasquoinea1@plala.or.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f399e6e1-0478-4e42-8841-e7ff4704e49f	quam sollicitudin vitae consectetuer eget	agathercoala2@is.gd	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
00b0a830-8f95-4fef-9a4a-2b8f4831ff46	sem fusce consequat nulla	mdillowaya3@livejournal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9e0c053c-2ce3-460d-ba93-c7fe9c535cda	sociis natoque penatibus et magnis	bchastela4@gizmodo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6d75afb0-1a0c-4dac-9f9b-4dcf3abf3607	aliquam quis turpis eget	sdrewella5@imageshack.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ee61a57d-66a3-4326-bd8c-24c2521df62e	suscipit ligula in lacus curabitur	kpenhalluricka6@aol.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7c2e4338-ce32-48a9-beca-122d488cd1d1	in est risus auctor sed	aquarriea7@go.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
07c6e1fd-a960-43fc-bd31-99e5a8b0f217	nunc commodo placerat praesent	aspinnacea8@sbwire.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a6ad0e9a-e753-4d1c-b84d-6fdef86c1df0	lacus morbi quis tortor id	lmatschuka9@infoseek.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9ed7ecde-3644-49d3-bbbe-8c46d8c01ae8	porttitor lorem id ligula	gtraskeaa@deviantart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
08be2e2f-02bf-4ee5-9df3-8610cbf7711f	condimentum id luctus nec	jmableyab@pcworld.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8aca309c-9886-43c8-84cb-1d00a3ceb119	adipiscing elit proin risus praesent	ndennissac@umn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fcac830b-2aa7-4ae0-b255-3cb4feee6590	in lectus pellentesque at	tvanyutinad@cloudflare.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d0066b1d-7cd0-4105-94c8-95506e001818	cum sociis natoque penatibus et	vbenoistae@ucoz.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f6cad355-0112-441f-bc5f-51972d9e6d64	augue aliquam erat volutpat	ssammutaf@seattletimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e7aa4f3a-41d7-41dc-a891-4a077099b814	turpis enim blandit mi in	fgrouseag@gravatar.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bbaa7b94-279e-4ee8-964a-476eaf19093c	tristique tortor eu pede	ecockerillah@deviantart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
19b0f20d-6a07-4c60-ac3d-678788a0e37e	diam id ornare imperdiet sapien	hrilingsai@is.gd	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ca031c40-10b3-4a0a-8f71-cf1b2cd0fb66	lobortis sapien sapien non mi	ablowinaj@ed.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
08bb4766-d2f3-4957-a2d8-d8f64c9aeec5	in faucibus orci luctus	acastelotak@i2i.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6f5149ae-3b41-40b4-8a61-3b191b342ac9	felis ut at dolor quis	pbockmasteral@example.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b2b973d2-469d-4175-9685-e1ffcb2ffda0	pede venenatis non sodales sed	whaselgroveam@state.tx.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3b0ebd84-08e4-4f28-a121-164101511894	bibendum morbi non quam	hlindwasseran@delicious.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c71f0bc4-83a3-483d-9fe3-87632f341bc2	amet cursus id turpis	pdumbreckao@i2i.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0a5af9fb-e5ad-4ec1-842c-e8ff5d96e1a9	ac leo pellentesque ultrices	lpheazeyap@stanford.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
679b540a-afff-4c3b-b1b3-9bee49bc3e34	justo pellentesque viverra pede	ggarleeaq@xing.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8ec59b77-8970-4c3a-b8f6-51555a4897cd	volutpat convallis morbi odio	sfreshwaterar@cbc.ca	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6a796a9d-7f21-4bd6-a732-54983552b220	ultrices enim lorem ipsum dolor	loliffeas@unicef.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f55da3b8-8ed5-4612-995d-c381520fde80	diam in magna bibendum	lmardallat@amazon.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9a388970-fb3b-4b56-875d-c79b0c34a0d4	lacus at velit vivamus vel	rmachargau@jugem.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f7237221-43de-40d1-b74f-14447a3d55ec	rutrum nulla nunc purus	mscoonav@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
79e801f8-4194-4545-a23d-ce58a07d0915	dictumst aliquam augue quam	gbetjesaw@ifeng.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
863defe7-b55c-4bd0-ba45-a54090c0438e	convallis nunc proin at turpis	lpetrelluzziax@1688.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ced0ba6d-91b9-44b5-bbc4-c3fd0258dc75	purus eu magna vulputate luctus	sglyneay@histats.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8bf928eb-e7e4-4c1a-b629-0bd4185e0c3a	pharetra magna ac consequat	mcleveraz@unicef.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cf512c54-a69e-49d5-9303-83123bc9c96e	curae duis faucibus accumsan odio	mespinolab0@elegantthemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
949741f3-d900-4d49-912e-2d5d2700598b	rhoncus aliquam lacus morbi	cpysonb1@va.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc21d5df-dd8d-479d-8081-7997ebcab5ec	pellentesque volutpat dui maecenas tristique	ccourteseb2@geocities.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b452fffe-c150-42d3-928e-8d5482bde098	convallis nulla neque libero	dcallejab3@ucoz.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3b647614-41b5-453f-be8a-46a1fd4435e7	quis augue luctus tincidunt	esergentb4@canalblog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aa3f5457-1c39-4fbe-8c5c-939453ce3b27	ante nulla justo aliquam quis	vwibberleyb5@craigslist.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
76690e7e-acdf-46ae-aba2-eb50a5660a69	pretium nisl ut volutpat sapien	kclaypoolb6@constantcontact.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c96f9ca8-a346-4e59-91f6-1059c5112e1d	interdum eu tincidunt in	hlegatb7@hostgator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
149f71a4-d23c-4513-b5db-f90a166d6cc3	porttitor lorem id ligula	hbaylyb8@g.co	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ff19237b-8724-4e3c-960e-1c6e06aec0c7	donec diam neque vestibulum	lafieldb9@examiner.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cb6f463d-f131-4e24-8fd2-dab5c26b5867	luctus rutrum nulla tellus in	cbodeba@arizona.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
df143d38-5172-45fa-837f-53a5729adce4	condimentum neque sapien placerat ante	amalehambb@imdb.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8dc2c3bc-7216-4053-9a2a-1b98590cf4c6	nulla dapibus dolor vel	dgotobedbc@ameblo.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
636480ff-bca5-477b-9044-caedda809105	ipsum primis in faucibus orci	amcbradybd@accuweather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4457bac3-a86c-47ba-b803-0e636eb2c37d	ultrices posuere cubilia curae mauris	rleakebe@elegantthemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2d515f5f-5c7f-409f-8020-326c03a60bae	vestibulum ante ipsum primis in	gelwoodbf@studiopress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5bed7fb6-ed87-4c31-a5fe-bd5d2aaad67e	quisque id justo sit amet	anawtonbg@ox.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
627738b8-0840-42e9-93aa-c1022dbffcc7	pharetra magna vestibulum aliquet ultrices	ndulakebh@unesco.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18b31370-0f44-400e-ba09-57abe65bb51b	mauris morbi non lectus aliquam	dthewysbi@reuters.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c07d79b8-59c5-47b3-81f3-cc0f3aed6104	nibh fusce lacus purus	bbendleybj@mit.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
711d0189-edd2-40b4-82d4-7cfd08f51075	fusce lacus purus aliquet at	hbroggiobk@hao123.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fb9ce2c4-8da7-46b5-886c-4e76367f5387	ac diam cras pellentesque	aneamesbl@comsenz.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9f8895fd-5483-4389-a866-0c63b4e45d1a	a odio in hac habitasse	aromaynbm@mtv.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
331aa4f6-aa90-4946-a761-d9180179f4ec	curae donec pharetra magna vestibulum	cchelnambn@europa.eu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7c251c4a-70fb-43da-97ab-82f3a7d3becf	molestie lorem quisque ut	lmiskellybo@feedburner.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dc074ec9-d6af-4552-9459-69e3452d3a84	metus aenean fermentum donec	jmatskivbp@bluehost.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7577518f-e010-44ba-ad1a-4093ec0c5c65	a suscipit nulla elit ac	amerfinbq@blogspot.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e7424aa1-9bcb-4080-83c8-e47be320d7ed	vestibulum ante ipsum primis in	spaszekbr@dropbox.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5aeb21eb-16df-4225-b700-dc3c780d6c6f	pretium iaculis diam erat	plechmerebs@opera.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
02e3f24f-0e28-4bda-ab9c-23e622123b56	lacinia erat vestibulum sed magna	ffreegardbt@businessweek.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
28a87ab7-95f6-48c4-a482-ce12968fd792	quis tortor id nulla ultrices	bgealebu@nymag.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ae929c4b-5596-4de5-b153-e3a501be15cc	eget nunc donec quis orci	mleyburnbv@marketwatch.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
014e210d-a79a-4cfc-b5cc-641caffce83a	rutrum nulla nunc purus phasellus	qpylebw@pcworld.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c2f0fc17-173a-422a-9155-9dfb660e277b	justo eu massa donec dapibus	rmaccarterbx@state.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b2bd4de9-8cea-4585-a3b5-9dc669d62d8d	sit amet sem fusce	gdaviesby@bravesites.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a21e647c-01f0-4613-9cc5-3ee1f275474c	libero ut massa volutpat convallis	lschurckebz@un.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
76cb910a-19ab-49fa-94ba-07abc66c9bc0	donec ut dolor morbi	aperinc0@nymag.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
30011d52-eb70-4c4b-ae2e-bbc1d37354b0	posuere felis sed lacus morbi	sgobertc1@devhub.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8a37a235-bdbe-4674-8792-ad8ccec0cb25	enim lorem ipsum dolor sit	emoreingc2@cnet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe5544d2-8d06-4bc4-9de4-4a5e704f8261	sit amet nulla quisque	gpeterac3@about.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0e2dd38f-df65-4421-996b-db966cafed1a	id pretium iaculis diam	mwitherspoonc4@ask.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
71c53a5a-e1b8-4c35-9c49-cc3b45fdf939	nisl ut volutpat sapien arcu	mthickinsc5@businessinsider.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d7325189-61ef-4694-8959-9f38e28e7845	in faucibus orci luctus et	gbatteyc6@stanford.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe67bede-bae5-42fc-b59f-3b5f1af3b73d	nec condimentum neque sapien placerat	tcreamenc7@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cfc9b7c1-5004-463a-80a1-344b2e3d2cb0	auctor gravida sem praesent	ksaggc8@mac.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
27d20c49-545a-42f3-82cc-07dde5b70c90	viverra diam vitae quam suspendisse	rpurvesc9@163.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0cea6f9d-a803-4c9c-af09-51ffbf97604d	nisl duis ac nibh fusce	msherbrookeca@t-online.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3245375d-cca3-4320-b6f4-f8ed7dac5e9a	montes nascetur ridiculus mus	ldifrancecshicb@virginia.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
15a8eef5-b681-4aea-b206-f7b93429138f	sed nisl nunc rhoncus	jfearneleycc@disqus.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
036da2f6-96e5-44b0-b671-12de851acf0f	dui luctus rutrum nulla	whrycekcd@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d24d7ca1-ed85-44a1-a45b-372086471832	cubilia curae nulla dapibus	rvanhovece@tumblr.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
30873731-18c3-42e6-ae26-8c693546973b	ut nulla sed accumsan	abriscowcf@marketwatch.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3d00663a-753e-4dfc-8154-ba240126de68	libero rutrum ac lobortis vel	ooliphantcg@cnet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f25f316f-e286-4d6c-9143-b4e34be9867c	sit amet diam in	spavolinich@bloglovin.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
32b87281-0a68-4fd0-a960-0ab10dd22650	aenean fermentum donec ut	tbauldreyci@jalbum.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4f36d71c-2758-414f-833b-5d058619afd2	est et tempus semper	rprobycj@fastcompany.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eeda8cbf-a9bd-491b-9303-0290fe348a25	pulvinar nulla pede ullamcorper	erubinovitschck@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9b06b669-f340-49da-8d00-6e2e2bf19c62	imperdiet sapien urna pretium nisl	smcpartlincl@hud.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0a48853e-8631-4930-9139-a0ff77d98bfc	ultrices erat tortor sollicitudin mi	dmcglonecm@miitbeian.gov.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b79b6199-e364-471e-9abf-c9bbfea4e70c	id luctus nec molestie sed	abigadikecn@photobucket.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3b7d3bab-063a-4028-933c-14079df90c5e	nulla nisl nunc nisl	jjakubovskyco@cbslocal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc45cfa8-29f9-44fb-94d1-b9214a339992	tristique in tempus sit amet	gdacecp@deviantart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
da39ecd3-4ebd-42af-9b5f-f6266e81e8e4	ut mauris eget massa tempor	rdabneycq@unc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b2354cac-019a-4308-addc-7205f5b4b84f	sapien dignissim vestibulum vestibulum ante	tewencecr@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
19958a9e-3d5c-4c21-bda8-815f9e61d3c9	felis donec semper sapien	dwomersleycs@topsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fae5c4b1-79ab-4eec-88c6-455f15b98cf6	lobortis convallis tortor risus dapibus	ckunesct@marriott.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9cee4f9c-718c-4bd2-b0ba-54b20a53c4ce	sit amet sem fusce	lhultbergcu@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5a8ee2ba-221f-4047-a8b9-964047944ec1	non mattis pulvinar nulla pede	hjoskowiczcv@posterous.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b8a4b932-2cd6-4f88-a0bc-3b667426b9cd	rhoncus aliquet pulvinar sed	amauldencw@oakley.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0582f234-e50b-4d21-9885-f0399c2ba640	id mauris vulputate elementum nullam	bobraddencx@qq.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
05ef92ce-271f-4b68-b067-5d132ebbe397	ut odio cras mi pede	ghibbartcy@diigo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7b965e81-f0bc-4468-9646-f70e5cf74f92	luctus tincidunt nulla mollis molestie	atilfordcz@hatena.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
20db3f7b-52d0-4d04-baa0-a4600b1ef7ae	integer tincidunt ante vel ipsum	rvondracekd0@ehow.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c44130c6-a977-441c-aad4-41b141b2c4aa	morbi porttitor lorem id ligula	apurveyd1@list-manage.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eeeded5f-a5f5-4011-b6be-d2ad02130222	nibh in lectus pellentesque	egreerd2@storify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
815da313-953a-42d7-8349-5ea6f7124dd2	posuere felis sed lacus morbi	bsnalomd3@goo.gl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d7c491c2-00f6-4098-bc21-86a227f9d6c2	sit amet consectetuer adipiscing elit	agerardind4@harvard.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f5db2035-2fb5-4632-81e7-8c0b6cdd9a50	parturient montes nascetur ridiculus mus	bmceloryd5@ucsd.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dd706f8f-3506-46ce-a5e4-b8710f139124	accumsan tellus nisi eu	gcorrd6@latimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
98e8b5cc-683c-4ad9-b2a4-804931ecdd40	libero quis orci nullam molestie	tpinhornd7@nps.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8f6bbddb-8822-44a4-a2fe-a667b43ee76d	amet turpis elementum ligula vehicula	umaccarid8@ox.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ac29ba88-d7a6-41f1-a140-c21625392d58	eleifend quam a odio in	kcolquittd9@edublogs.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d291347b-7fe5-487c-8337-0a5af407f88f	felis sed interdum venenatis turpis	cbangiardda@tmall.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7d058523-aaac-4091-bf37-e80ebc5b2b57	nam nulla integer pede justo	pbullersdb@dailymotion.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
07a1babc-5fc2-4fc5-a5a6-970ba9f8622a	hac habitasse platea dictumst maecenas	lbraysondc@cnbc.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c532d8dc-3acc-4665-ad97-f9ccddf63731	nisi nam ultrices libero	jnoyesdd@yolasite.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a12aa356-6712-4671-8884-4e53ab4eaeca	molestie hendrerit at vulputate vitae	asatchelde@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ae23c60e-eb3f-4397-84ca-b452fcb976f8	tempor turpis nec euismod	emeesedf@issuu.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
025259b4-fc8e-455b-81d3-89a92763522f	luctus ultricies eu nibh quisque	brylettdg@yellowpages.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d62c309b-c263-4566-ad53-19f02b204a76	vel enim sit amet nunc	elintindh@w3.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
73dc43f0-530a-4551-be7e-38bbe39ad9f1	luctus nec molestie sed	ldulydi@eepurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f8bd3e2a-cccc-4bba-9545-624559020110	integer ac neque duis	mhanselmandj@icio.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5ab39e3a-3fa3-4787-bdf1-41f7e7f0c97b	sed tincidunt eu felis fusce	sartzdk@paypal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dc57ebfc-bdf3-4c00-ab2f-294dfaf1ab0d	proin leo odio porttitor	kprattedl@ow.ly	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ed7a6d70-f6fd-413c-9391-f2bcd6ee65eb	porttitor pede justo eu massa	obrogidm@icio.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ce69ebe9-a296-42bb-a597-08c18fbc6c2b	rutrum ac lobortis vel	clogsdaildn@ed.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
83f07b63-df98-472f-959f-e5dda9716569	placerat ante nulla justo	wrorkedo@myspace.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e4ee7182-e152-4e97-94fe-f7816cf99474	in tempus sit amet sem	lrouchdp@rakuten.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
81a65f3f-12b4-4564-b25a-2e07658d2dbd	mauris non ligula pellentesque ultrices	cmacskeaghandq@devhub.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b1beac99-7d83-419a-b0b4-4c6b9d86c5fc	accumsan tortor quis turpis	dmarxsendr@mit.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8aa98f4d-02c0-4d3f-b957-600086098f21	eu interdum eu tincidunt in	hmcgurgands@youtu.be	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0c098fe5-258d-4cb9-9514-a32e53e37ae4	diam erat fermentum justo nec	ksartendt@tinyurl.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1926b123-42d3-4197-882c-926460848c4f	odio in hac habitasse platea	bgregorowiczdu@geocities.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
de9d8c53-93f6-46cc-bd6e-28dee2d70944	odio curabitur convallis duis consequat	lgatemandv@taobao.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5205fc10-9f7e-4ca0-a46e-1e55b8629dc0	lacus at velit vivamus	gwaitondw@jiathis.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
953b55e2-8c6c-4c45-a6d8-7a659bd3a73e	volutpat quam pede lobortis	ssawforddx@multiply.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f19a049f-06c1-476a-a1d8-889f8c318f82	suspendisse potenti nullam porttitor lacus	lcoulthartdy@a8.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
49a25517-3194-43a5-aa36-ec20b6e61295	phasellus in felis donec	pwaszkiewiczdz@dagondesign.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7d8626cd-ce98-4da3-a842-f3030c88da5c	nulla suspendisse potenti cras in	zsparshotte0@loc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d5417458-c0e6-4f1f-8431-efe9a79d17e8	eu massa donec dapibus duis	ggheorghiee1@topsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f7f2d91e-fee7-4793-9daf-91c3b3c64c1e	morbi odio odio elementum eu	ahallihanee2@google.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ff165064-1041-40ea-b106-033f88998ca3	risus dapibus augue vel accumsan	cholmyarde3@wired.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
26cf9196-7178-494c-8048-4452df361e38	morbi ut odio cras	flenaghene4@themeforest.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
658d256c-9145-4838-8956-49a64d60416d	erat nulla tempus vivamus in	epudsalle5@com.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
604d27ec-b6a3-456e-9237-44d5227bbcf8	felis sed interdum venenatis	kfurlongee6@so-net.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa97799a-5940-4bb3-8158-14c68d478cbb	vel lectus in quam	cparmitere7@dailymotion.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
13107b10-6838-41e9-bbab-199b505fd4fe	montes nascetur ridiculus mus	nspafforde8@dailymotion.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
03472538-1ef8-4210-8fe0-28ac154d92b1	nulla tempus vivamus in felis	lmildenhalle9@tripadvisor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5f7e6282-877d-4854-8e8f-73d426a3f57b	ut erat id mauris vulputate	ubrislanea@example.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ccda3335-feea-45aa-8f94-5ebd4d64e07c	scelerisque quam turpis adipiscing lorem	hgreceeb@newsvine.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f4690740-6e73-4f89-a958-8731df6fde7f	sem praesent id massa id	sortsmannec@barnesandnoble.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b02251d9-274f-4780-8a9b-a7926bf0ef2d	luctus tincidunt nulla mollis	sdemorenaed@cmu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
603bbbda-d4fc-40cc-a2b0-579b8d421b1e	donec quis orci eget orci	lsidonee@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c319b518-4a5a-46a7-b341-3c8dc578a699	condimentum curabitur in libero	lnessef@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b28b3c00-f409-485e-acbb-67624a16b612	a feugiat et eros	ylefranceg@last.fm	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f1c51fd8-2df9-48f6-bd98-edd6c249da36	mauris sit amet eros	omcnirlineh@prweb.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cff4744e-fd0e-4d52-a102-814a68f776c9	egestas metus aenean fermentum	afrayei@php.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
03a5cb9a-157c-4b21-8bf8-7054bca18330	lacinia sapien quis libero	crewanej@newsvine.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e73b72b3-9263-4186-8b60-9f05f5ff60fd	placerat ante nulla justo	ohacksbyek@slideshare.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
222ff28b-c0af-4643-ac76-3050c682bdbe	donec dapibus duis at	dpoweleeel@reverbnation.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e0da9539-df45-477b-a165-0c7a8cf26067	quam nec dui luctus	jsitwellem@github.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6ff980eb-e0de-4c18-b443-8966be2ebe0c	mi integer ac neque duis	niglesiaen@dmoz.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
312b0ddb-aa0c-4ccb-8e8c-9aa9dd035391	rhoncus aliquam lacus morbi quis	wchristoforoueo@aboutads.info	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
19f87eb6-c019-49b2-9465-f089996a4884	ut suscipit a feugiat et	bhowlerep@homestead.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
06ddcf3f-c064-4652-8e8b-34186de83544	habitasse platea dictumst aliquam	rhubbereq@mediafire.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1c835e3e-423d-4682-8799-fb8c06005894	duis mattis egestas metus aenean	meouzaner@go.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ffc576c4-8fbd-4bf2-991c-c06c57bdc16f	sit amet consectetuer adipiscing	gbirdfieldes@odnoklassniki.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
240f46f8-bc19-49d8-b0fd-17942fb7ab31	aliquet at feugiat non pretium	stalmadgeet@apple.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dcdd76e7-738e-42c0-9c6d-42dc700e58d7	nisl nunc rhoncus dui vel	pwinchcombeu@miibeian.gov.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dbacd7c3-e4de-4643-b6f7-70f77598e71a	justo aliquam quis turpis	mbinsteadev@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7899b858-3240-4942-b047-955a0380d8b0	vulputate elementum nullam varius	uhawkeridgeew@umn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
283999ef-8c0a-4d54-8b4c-a9ec63b7b3ab	morbi non quam nec	bblowingex@google.es	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
68efa735-1545-40e1-bc6f-59386cb42eec	cubilia curae donec pharetra	abrawsoney@wordpress.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4956e8db-c51a-4ed7-a39d-6f4738a48ca0	nam ultrices libero non	vblindeez@latimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2baad8a0-4246-4130-9565-f1465e21beee	nulla sed accumsan felis ut	pszachf0@yolasite.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4cb63142-d641-417a-8a76-87efbbe4b9d0	primis in faucibus orci luctus	agrisef1@github.io	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
53821ce0-7738-48f2-bccf-2f6379ba46d0	est congue elementum in hac	lwinchurchf2@angelfire.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b94f7e2c-b955-47b8-b4b0-385de80198a1	in purus eu magna	soduanef3@163.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
03849c97-6776-4163-871a-78a9035b6655	eros viverra eget congue eget	ajeannessonf4@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
abfdd646-4ef3-4116-a509-8b98c5795401	pede ac diam cras pellentesque	cistonf5@un.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4b03c778-b0e4-40d0-abaf-21a8fcd54850	leo odio condimentum id	dnewittf6@vinaora.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5c035024-f24a-46f0-be42-2ab2663ace89	suscipit nulla elit ac nulla	kgironef7@freewebs.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
80eb4d8a-dfa0-4a6b-94ed-7d5eb1f8a39a	dolor sit amet consectetuer	jdineenf8@earthlink.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb2d41b6-ea4d-454b-8684-5ecd5274ca40	pellentesque quisque porta volutpat erat	nkennardf9@nasa.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
94d559c9-1703-4539-9a68-62ffffd1a875	proin risus praesent lectus vestibulum	mespyfa@usnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
86081efb-ba1c-4774-aabd-a5c3faceb4d9	vulputate luctus cum sociis natoque	pgreenwayfb@si.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
01fa2974-7657-47e4-ba6d-f9ab2296dd15	convallis duis consequat dui	sdengelfc@nih.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8958fe5e-5e9c-46aa-bf33-8402f8446e37	hac habitasse platea dictumst	aliddiattfd@e-recht24.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18fe56bb-cdf4-4068-9a6d-ba2845509dbd	mauris viverra diam vitae	critellife@google.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
33b10c2c-6158-4452-9d9a-60d39b439101	aenean auctor gravida sem	mcowelyff@cam.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8ae9995d-4425-463a-bfd3-0a7ba52904a4	justo morbi ut odio	gaslottfg@wsj.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0a2938fa-62b8-4a26-9afe-918a486e713c	nec nisi vulputate nonummy	gmounterfh@desdev.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3a7c629f-4837-4f85-9331-09a4237d54d1	platea dictumst maecenas ut	mmcenhillfi@linkedin.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
560f688f-4b1c-42bd-88f4-1a2b769c301c	magnis dis parturient montes nascetur	pmacfadzanfj@wordpress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8d96ebbf-95b8-4beb-8634-214455c1ee16	maecenas leo odio condimentum	lwarrenderfk@indiatimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4195cd31-0737-49f1-916b-748ce7d3344f	donec quis orci eget orci	bcocklefl@netscape.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ba2245e8-219f-4cce-8133-77919112f1ab	non quam nec dui	jmathyfm@nih.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
817d1766-0305-45dd-8519-aadb3127df1b	parturient montes nascetur ridiculus	hedscerfn@indiegogo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fc761b75-f3af-43f5-ac73-a61655426f0d	sapien cum sociis natoque penatibus	eyemmfo@51.la	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2745b4ee-7851-4dfa-b3f4-273b1bf59930	vestibulum ante ipsum primis	cjakobssonfp@flavors.me	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
94c5b780-4ff1-4155-a702-51ddf0c18277	nisi nam ultrices libero non	blongfieldfq@dagondesign.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
91c5c691-df8e-48e9-af2a-20fb71a14cb3	commodo vulputate justo in blandit	cdugdalefr@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f1dd1379-1708-45ef-a3d3-5fdf1fdec5b4	luctus nec molestie sed justo	nvasyuchovfs@e-recht24.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f5468e06-2893-439f-bc21-e72040b44af7	maecenas rhoncus aliquam lacus morbi	lkernleyft@behance.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
70276e6d-19cb-4d88-b511-bc9aea39a987	lorem quisque ut erat curabitur	kseeleyfu@ycombinator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a8d89fcd-8817-4c40-a043-97df72e6fbb3	proin at turpis a	janyenefv@privacy.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fcc4a60d-0cfe-4eee-853e-773af996d4fe	volutpat dui maecenas tristique	ktrenowethfw@discovery.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4722fec9-9361-4eaa-9f0e-db126be63dd5	iaculis congue vivamus metus	kgathwaitefx@wikispaces.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f2e18f17-af35-4d59-a9dc-b1826998dac7	duis consequat dui nec nisi	sknaggesfy@sourceforge.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f9ab2d70-d524-4b9b-a03f-e092812dd498	integer non velit donec	rkettleyfz@who.int	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
809c5542-4ff6-49f3-add4-f909fe2e897f	tortor duis mattis egestas	cmccuddeng0@blogs.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3e9e14e2-71b1-4d8c-b56a-80d2e2e56952	augue quam sollicitudin vitae consectetuer	mcrosfieldg1@illinois.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
807c13d9-65c8-4307-b199-f3bfb66ea0b3	sapien ut nunc vestibulum ante	dreimerg2@businessinsider.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
14aaf64d-cf3e-4ce6-becb-29cf6a5a0ee9	viverra eget congue eget	jteenang3@ca.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
111c6131-f645-4f31-bd44-e036bc7113e7	dictumst etiam faucibus cursus urna	aoraffertyg4@vk.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
69669795-f97c-4442-8f37-3ca83c04120d	cras mi pede malesuada	gsixsmithg5@hugedomains.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
565c3ecd-99c0-42ba-86a4-7bcb6ae4572d	interdum venenatis turpis enim	kjannyg6@qq.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e27bd0f8-5af9-48d6-921d-270a46d31435	at diam nam tristique tortor	zcolbourneg7@gmpg.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
22b26c00-05b1-4e41-b88d-f98ba4a2b38e	eget elit sodales scelerisque	kgravenallg8@pcworld.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f24a9f75-545b-46ec-91a9-db8fce00f815	sed augue aliquam erat	ereemeg9@auda.org.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ee938f3f-c3cb-4591-b579-103165e0a719	enim blandit mi in porttitor	rblownga@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e75128c6-b494-4308-a372-54a4dee0b997	sit amet lobortis sapien	araglesgb@fda.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
901def71-ac5e-4709-8e26-716d2fcb2ea1	nec nisi vulputate nonummy maecenas	sbardnamgc@hostgator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fea308c2-ae69-430c-b0f1-e1a4e82191c8	sapien in sapien iaculis congue	gstonemangd@scribd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5b6f1a78-ddec-4645-8d69-fdc3165c463f	etiam faucibus cursus urna	kloadwickge@free.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
35502b09-d4d6-4633-a826-d8aa6ffdb595	accumsan tortor quis turpis	lbategf@cbslocal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cdbb2e99-03e2-4636-a2e7-66691b9f1ce0	consequat metus sapien ut	anuccigg@paypal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1b70529c-e127-4e1c-a303-4379e0e7a53c	ridiculus mus etiam vel augue	ceccottgh@ezinearticles.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fb8ef9ad-4662-43b4-ab6b-c507758eff6b	non interdum in ante	stomblingsgi@pen.io	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
57b6ba19-9f86-42f4-8780-e3885c21e6be	felis donec semper sapien	lspareygj@de.vu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9b1d2bcd-dd4e-4b17-b5a2-266b9bbc1b68	dui proin leo odio	oshermoregk@yellowpages.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6c784636-dd58-4e3d-b92b-77fb3dafeb65	eget elit sodales scelerisque mauris	aharpurgl@tamu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4ff30265-e89c-40e8-bbc9-c4427b1fefb8	cubilia curae nulla dapibus	meddoesgm@psu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e864e33d-f5ce-4084-9759-7c891e1cd08f	nec molestie sed justo	icarvilgn@e-recht24.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2779b58a-3f53-43b2-9845-c721820aa925	donec semper sapien a libero	mduhamelgo@ycombinator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
232980df-aab0-42cb-8293-38b96604fe49	id nisl venenatis lacinia aenean	wclerygp@list-manage.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d6fa7d44-9ae4-4c5f-8130-ff14035ffed0	sit amet sem fusce consequat	tgeeritzgq@freewebs.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
977580b3-4c8f-42d5-970e-d38a9882d0cd	convallis eget eleifend luctus ultricies	apagongr@sitemeter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
328a9e18-28fc-4d43-bba5-09b6b9b895d0	at velit vivamus vel	pcolcombgs@merriam-webster.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
06d0bd74-fc7e-4081-942b-1cbb3a44d3e8	arcu sed augue aliquam	lsimpergt@unicef.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb21ea89-a4ce-45a2-bb20-4498e5285051	accumsan tortor quis turpis sed	tfersongu@bbc.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c5852aff-ba83-4dfd-baf7-e7066ac62a04	nisl nunc rhoncus dui vel	hpendlingtongv@i2i.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1efe526d-3f5a-4773-ab13-d911535d11b9	nulla pede ullamcorper augue a	nketchasidegw@webmd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e5fe18b5-8648-4534-aa56-378337e19d51	posuere cubilia curae mauris viverra	oclaxtongx@1688.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2fd9a3ae-ccac-46af-b7e5-20be25b7faac	diam in magna bibendum	owhitworthgy@shareasale.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7f9dfa3c-84fb-4590-a7c4-986edba2651b	in faucibus orci luctus	cmelrossgz@delicious.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6d2213ae-6018-43e1-9ca4-ff580b1a8d5c	montes nascetur ridiculus mus etiam	cboxhallh0@noaa.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cea2e898-8071-42bc-ac91-46b963673475	posuere cubilia curae donec pharetra	rcanketth1@soup.io	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f1cc56d6-e150-43bb-9aac-f33a14f67f29	ullamcorper augue a suscipit	adultonh2@dot.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
432c2b4f-1f3a-42f4-962a-9236f4332e52	nulla integer pede justo	hdeernessh3@shareasale.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
311053f7-37e4-4406-81b2-74e5170210fa	lectus vestibulum quam sapien	udorningh4@ovh.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fb109307-618b-4181-822a-659dd9a700c4	velit id pretium iaculis	grackhamh5@unesco.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b47125dd-343e-4672-bd99-2c57b69dc880	diam neque vestibulum eget vulputate	jyeoh6@phpbb.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9d7c849c-8ac6-4054-98e2-e17306976471	a nibh in quis	dwanekh7@mayoclinic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bc5ff5ba-2478-47b9-9455-c1be74a0d457	libero ut massa volutpat	ccarbineh8@themeforest.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
759f9ea8-3c81-4fe8-85c5-5397cc9b832d	nunc viverra dapibus nulla	rdodworthh9@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a8d47bdc-647e-4d2b-9a54-421849b3646b	erat eros viverra eget	jsteptoha@yelp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0abb2520-e650-44a9-8eb5-d9d41e779455	vivamus in felis eu	sbatiehb@typepad.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
138592b4-d113-4740-add6-3ff58ce85611	mauris enim leo rhoncus sed	bdoxseyhc@prlog.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6b841441-dac9-4346-8b08-4a6dff9d2a62	platea dictumst aliquam augue quam	pwayletthd@upenn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
650afd5a-6505-472e-aa5d-9f09fab45ff8	habitasse platea dictumst aliquam augue	aseekingshe@about.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9934a312-7eaf-4ba5-81ae-a5b5a711f09e	felis fusce posuere felis sed	pjeandonhf@mozilla.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c5626bcf-deac-431a-89ae-b2551bd4e096	ligula pellentesque ultrices phasellus	ubeebehg@webmd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dcc75539-24d4-4e64-9fba-2e969c4d6bf0	nisi eu orci mauris	adewintonhh@twitpic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9932d484-80f2-4022-98e0-06951604bfba	vestibulum rutrum rutrum neque aenean	tsokellhi@lycos.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cb766075-1693-4bb8-92b8-bdef0d02dda1	sapien cursus vestibulum proin eu	jgolsbyhj@aboutads.info	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1f8912cc-bf3f-4eb9-a4f3-5d98e9da524f	pellentesque viverra pede ac	rhaydenhk@php.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dfaae53e-b224-4c20-9f9a-4df0df5eb198	venenatis turpis enim blandit mi	tcaseleyhl@slideshare.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
45c2117d-5b42-4671-a1a7-f3bb910938ba	platea dictumst aliquam augue quam	mburchnallhm@unc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8077be9f-ac91-4866-ba59-be672cf3c6de	vel est donec odio justo	dleakhn@liveinternet.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d602e0b5-451b-475d-b6ba-a7633ce2e3e6	sapien dignissim vestibulum vestibulum	mrailtonho@washington.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
00e7d3a7-0eba-4ea0-a569-6e2b6eea02d6	vestibulum quam sapien varius	sluckeshp@tripadvisor.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
58cfac98-7304-4aba-835e-a7f185e2ecb0	morbi sem mauris laoreet	kalcockhq@vistaprint.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c56c08de-7e63-4b8f-bc17-bdbbb7675cd0	in hac habitasse platea dictumst	hgildroyhr@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e99cfc90-807d-4e1f-aa13-29f52dbf8206	laoreet ut rhoncus aliquet pulvinar	cshailerhs@themeforest.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
14539ec4-3cbc-4189-9aa4-6923119677c9	auctor sed tristique in tempus	smcalroyht@simplemachines.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5489dfae-c903-4fd8-831f-dfe175136ab3	in tempus sit amet sem	thiddsleyhu@cloudflare.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c87e6411-01b5-43ab-aa5f-694774ee51aa	eu orci mauris lacinia	omcgradyhv@bloglines.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
032ea2c9-f8f3-44b9-a94a-dcc754f5aa40	quis augue luctus tincidunt	ggrocockhw@xinhuanet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
88b13b15-606c-4992-bc11-6583b7e69175	tellus semper interdum mauris ullamcorper	cbloorhx@ca.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2816c046-f4a5-414d-9128-f4b933a39fe8	venenatis turpis enim blandit mi	ddowleshy@bravesites.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6fa719d3-43ca-4040-a3f2-0a8376bae4da	iaculis justo in hac	strunchionhz@acquirethisname.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5ba56837-aab3-4b54-bdc4-7d8ee296c98e	suscipit nulla elit ac nulla	nrockwilli0@naver.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4c65d79b-9ccb-4511-a3ac-e3744b53226c	gravida nisi at nibh	rcolbourni1@sciencedaily.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c5c89eb7-2dd3-4389-832d-2873e54c0490	pede venenatis non sodales	rberfordi2@hhs.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
24697b4c-15cb-40ec-91da-e059f7efe372	amet nunc viverra dapibus	lboddyi3@rambler.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9483f8af-b652-41fc-9590-d0ce8b5b8329	vel lectus in quam fringilla	mdiantonioi4@ovh.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
37b4284a-8145-4146-ba49-b162c1a3cc11	maecenas pulvinar lobortis est phasellus	kosgoodi5@cnet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
db5548c1-20e8-4616-b9e5-ac63f0769e08	vehicula condimentum curabitur in libero	foveri6@unblog.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
35b7b885-10b1-4543-bcba-a53766695765	congue eget semper rutrum nulla	llampetti7@ucla.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1fd9bad4-35da-40c6-a058-d80baf53e20c	sit amet erat nulla tempus	nkemstoni8@taobao.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
efdbde09-b8ed-4c5d-9634-92918a39aa33	rutrum neque aenean auctor gravida	cmallordi9@wiley.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cfff9d0c-07ea-4bdf-beb8-9b9ac4558433	magna vestibulum aliquet ultrices	mfirksia@yahoo.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7e8ac13e-7b41-4e86-9137-c1d15f64c002	ante ipsum primis in faucibus	cbygreavesib@guardian.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
af19913d-771f-4a42-8051-3c0b0b3c58dc	curae mauris viverra diam	lwoodingic@hp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
00f72e75-16a4-4f83-873d-3431c3318caf	proin at turpis a pede	rdukelowid@mashable.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
56e0ad80-e4b9-4b2d-82a8-593efdbce4a9	orci luctus et ultrices	ewheeltonie@mail.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
da5927b6-c31b-4572-bd0c-579406386e09	ultrices posuere cubilia curae	ewilkennsonif@intel.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
19a4f462-49f5-4e9b-9a01-11a57c531f44	ut odio cras mi pede	gmingaudig@va.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b1446b76-ee02-4fc4-9249-5c0f3f4a64a1	velit id pretium iaculis diam	bcozinsih@upenn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d8425765-1b73-4797-98f7-835cee27ee4f	lacus curabitur at ipsum ac	parnoldiii@un.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f3e50855-6a50-4f24-ac55-7b346820cd48	habitasse platea dictumst etiam	hopdenortij@latimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
feec1296-08bd-4f73-8895-41be49048e18	ac leo pellentesque ultrices	jlaguerreik@skyrock.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9fc29198-4e6b-46cc-8d55-a47f22f8bea3	donec odio justo sollicitudin ut	abidewelil@whitehouse.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8b40747e-2ba0-4129-96df-8473b2bf5ebd	quam pharetra magna ac	aritchieim@omniture.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8ddccfb9-0fb9-42e1-be04-62335859327c	sapien arcu sed augue	gdockertyin@amazon.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
86721efb-f93a-4405-acc2-2eb76a2be5c0	montes nascetur ridiculus mus etiam	docarneyio@stumbleupon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6f63bf7d-83ce-4016-96af-bdedf90292fa	hendrerit at vulputate vitae nisl	chabbijamip@accuweather.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f85af929-1706-47ac-a5f7-7372a42b7db3	ante ipsum primis in	dfiddymentiq@photobucket.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
70d741d2-c618-49c9-8fac-51d40797d0c9	ultrices posuere cubilia curae	mfellmanir@skyrock.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
80393557-fae3-4dc6-9222-aa82c0747848	amet sem fusce consequat nulla	bbeakis@nhs.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b9a90cc4-6f8a-4821-9fe2-43c8bde9c7b4	suspendisse potenti cras in purus	asartinit@columbia.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6ca250f2-5264-440e-8aff-cbf14db83acb	aliquam convallis nunc proin at	cspadeckiu@berkeley.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
37e6fbfc-2087-482a-b815-a4deb720453b	dolor vel est donec odio	kgillingiv@ask.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
762a2ce9-995d-4c50-b6ce-4a79a6ddb522	est phasellus sit amet	gbonnetteiw@blogspot.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b23f9ec1-f087-437f-9e60-a8de6accac26	ut erat id mauris vulputate	icrosenix@usnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5cca3d63-d5a1-4ad3-812a-36cb0f2ea1f5	et ultrices posuere cubilia	fchattersiy@sina.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
789a5ef7-2ce0-41af-ad7a-6bd91bf90a13	non ligula pellentesque ultrices phasellus	jgrzesiz@theglobeandmail.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d6a876ad-3f1f-4d9f-8e20-47f29d22058f	congue etiam justo etiam pretium	kworrillj0@stumbleupon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
98d07833-61d5-4937-b4bf-9d40e69dc188	enim leo rhoncus sed vestibulum	shemberyj1@posterous.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
53e2f53d-c15b-411c-be68-faed55b71724	consectetuer adipiscing elit proin risus	leaclej2@altervista.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9b236446-5dea-4e78-8f6c-ca42df79e486	sed vel enim sit amet	tboornej3@harvard.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe3626b8-3724-4632-a9f8-88c84c217218	potenti nullam porttitor lacus	cviantj4@pagesperso-orange.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d2bec9cb-c8e5-4464-978a-20c32e892604	velit nec nisi vulputate	dygoj5@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
63ee596a-d2dd-4646-9c5b-131bb2e5b7b0	consequat varius integer ac	cdahillj6@independent.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8836b2af-fbaf-4c79-bf1b-3275b22e6d00	rutrum nulla nunc purus	jbroddlej7@telegraph.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d789ec6f-f6f7-4966-8872-32638c25db25	nascetur ridiculus mus etiam vel	smarfieldj8@4shared.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4bb96656-3075-40bc-9d30-061e96a0fbf6	massa volutpat convallis morbi odio	tcockrillj9@artisteer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2e6ac13f-6d93-46c5-91ef-87423e70cdd6	molestie hendrerit at vulputate vitae	taylinja@homestead.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9d3717b4-e7f4-4a56-9eda-ba2e409eeedc	mauris lacinia sapien quis libero	miacovaccijb@chron.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1ec03b8f-6ca6-4280-acfc-1419b584c7f4	nunc viverra dapibus nulla	ariglesfordjc@discuz.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8339e75a-45ea-41db-9246-3ddfe764e1d3	praesent id massa id	mislipjd@ovh.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
150cdb18-fe83-4f3f-9cd8-0373a04c3b47	eget tincidunt eget tempus	ahowlerje@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
71c371cd-541f-414c-990f-c51a913e449b	porta volutpat erat quisque	kblatchfordjf@mysql.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2cac7be4-d123-49bc-a4c1-cb56303f1f1b	augue vestibulum rutrum rutrum	cendricijg@msn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e359c279-7280-4b6c-9656-c2aa594f274d	posuere cubilia curae nulla	siacomijh@washington.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
aff17967-8592-44a2-80d9-cbeb1c02b092	hac habitasse platea dictumst	rreddji@netscape.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
be9ec587-8257-4c63-8919-0f5e6f5a3440	justo sit amet sapien dignissim	mcopinsjj@army.mil	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b9344232-7111-41fc-a717-f10e1273dfe9	mauris laoreet ut rhoncus aliquet	bnewgroshjk@salon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bcd1dcda-41d2-4097-ba51-ff34e6cbb39b	posuere nonummy integer non velit	sfraczakjl@gravatar.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
95ce86a0-7069-42fc-b656-168d3db68b96	ac nulla sed vel	lstookjm@google.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fe8afec-f9b4-497a-84be-6736511ab241	ligula in lacus curabitur	zvanbaarenjn@chicagotribune.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7ffbbbb6-c6ca-4697-95d3-a8d45b9c68e0	donec odio justo sollicitudin	kheskeyjo@cam.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fe7e21bb-c297-4e06-8a3e-764eb307ba9d	felis sed lacus morbi	lstowgilljp@howstuffworks.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1f17477b-92df-42a9-884d-fca57f4126d6	sit amet erat nulla	mdunseathjq@fc2.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e433159d-0b33-4270-b295-5addfb38f011	ante ipsum primis in faucibus	cbaggarleyjr@liveinternet.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4cdcf1fd-abb9-4ecc-a719-6b3927e371a5	ante vivamus tortor duis mattis	wwhysalljs@squidoo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7cd532ba-dc48-4d97-8a8d-d9e43e8adb94	nisi at nibh in hac	esirrjt@disqus.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
75d14e61-db12-4d9a-833a-53a4e3a0e821	rhoncus aliquam lacus morbi quis	mbredburyju@people.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5a1026b0-f27b-4ca5-959a-f149d8c23a07	turpis a pede posuere	ksawyerjv@nature.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
977a10d3-c642-4ca0-9b07-503ac882197e	consequat dui nec nisi	bspringtorpejw@statcounter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
33f4a985-a783-407a-8ad7-10ba3e1ae8ae	amet turpis elementum ligula	sstalleyjx@multiply.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e78f870c-19ba-46b4-afac-f4afcf75c48f	eget eleifend luctus ultricies	srivelesjy@loc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
feb51841-b763-4982-a95b-ba8f6b3e6763	nisl venenatis lacinia aenean sit	nginnjz@weibo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cae39e85-a8cd-4a6f-b3c1-9313038ae2ce	eros viverra eget congue	visoldik0@fema.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5f7ac34f-a6a5-44f4-942f-3dc1f34c9546	nulla nisl nunc nisl	hspurdenk1@unicef.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f93f9664-a320-4ab7-b607-5ea7f9292122	in faucibus orci luctus	bdwightk2@histats.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c6e33231-46b5-480c-a66a-5424bfdc2f6a	blandit non interdum in ante	lseabornk3@youku.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d652e0e1-7fd1-494f-9b64-b4731c006d87	tincidunt lacus at velit vivamus	wdollink4@goodreads.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8dc997d4-ff40-4803-9eb7-2628d123d033	suscipit a feugiat et eros	hbottomleyk5@home.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a1088dab-c465-44d3-8f6f-450fb54d8f7f	nam dui proin leo	vstoreyk6@bloglovin.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
686c3bdd-1bcc-4b7a-9242-076e18abacb2	fringilla rhoncus mauris enim leo	mmacbaink7@github.io	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
31db5d1d-3d7b-4302-9abf-4014e23e4e3a	convallis eget eleifend luctus ultricies	mragbournek8@wikispaces.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f14d56c2-e337-493c-8d66-1ee3bbddcc59	diam vitae quam suspendisse potenti	frubiek9@liveinternet.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eae68c6b-256a-41c4-b7b7-b953f241182f	porta volutpat quam pede	dperagoka@tumblr.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ae41107b-c4a2-49e4-bb95-e3b876e9dfab	nisl nunc rhoncus dui	agarmonskb@zimbio.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2ff9c668-92b1-4a4a-9234-694322ca1cf3	odio cras mi pede malesuada	gdemeridakc@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4de717f0-bbcc-4f3e-ba36-df6b058fa10f	nulla ultrices aliquet maecenas	ibaccupkd@washingtonpost.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1c0c63db-b3e9-4452-aa80-c75864a144f9	quis libero nullam sit amet	sceresake@ucoz.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9cb003ff-97fb-4128-bfc4-278543da3a86	a odio in hac habitasse	jcunninghamkf@amazon.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a41a6f1c-001b-4862-b06a-4979545795aa	purus eu magna vulputate luctus	holivetokg@un.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d26629d6-d040-4cbf-89df-98dabd81f0a7	sed magna at nunc commodo	mayliffekh@gmpg.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7e3b0d50-4551-42e5-bd13-ca8e049101e9	id mauris vulputate elementum nullam	fandrichki@bbb.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a7be77a2-aa7f-48ce-87b6-128f5edff5d0	turpis a pede posuere	sflaritykj@about.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b2158efe-b0d6-4b82-8f1c-df4135645bf9	quisque id justo sit	ileipoldtkk@parallels.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e1fda3ad-6807-45cf-b3f3-20670ba49d7b	sit amet consectetuer adipiscing elit	dstpaulkl@ucsd.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8407589a-6c0a-46a0-ae75-0d1e9210cdfa	lectus suspendisse potenti in	wballsdonkm@europa.eu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c903953b-23ea-4b6f-ab9d-04adc7be16bd	curabitur convallis duis consequat dui	cmacginleykn@blog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a401767b-5db1-4f81-ba46-90d7fd36df5b	quam sapien varius ut blandit	abisetko@scribd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c35579b0-340a-4164-8820-8c08c2fa9133	libero nam dui proin leo	dpetrillokp@home.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d539f9e7-b416-4048-8bab-46f62dcd2c8d	consectetuer adipiscing elit proin interdum	mchritchleykq@time.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
99d660d6-1778-4705-acd2-0d116120259b	venenatis lacinia aenean sit amet	bgrimakr@psu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dd8357b7-7ba5-4ef8-8871-59ba3dd67e5b	nisl nunc rhoncus dui vel	nwheelanks@slideshare.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
427e5bd2-30f5-4ef6-940e-fd17577bc873	donec odio justo sollicitudin	broubertkt@51.la	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f7ec5836-1b98-4f40-9f56-2986e23582e6	magna ac consequat metus	rluckinku@is.gd	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
49ad7bac-16ec-4ea8-8bec-b9bf5c2a68f9	vestibulum quam sapien varius	efinnerankv@facebook.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
81d1ade1-4823-4936-8e33-e4b1bb2fb9a3	cursus urna ut tellus	dboulgerkw@soundcloud.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c23e3c3c-3c78-48d7-babd-606f9c8be8df	turpis a pede posuere	itwyfordkx@e-recht24.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b952397c-66aa-4314-b3cf-da6fba470ca7	consequat lectus in est risus	tbaldwinky@ning.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
82ad4fca-99e7-4732-82dd-657e78128ad9	nisl nunc rhoncus dui	onewallkz@cyberchimps.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0ceeb0dd-3723-487e-9d6e-5f9e2f796249	sodales sed tincidunt eu felis	agianiellol0@dropbox.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f7f74baf-eafb-418a-a84c-bb9fb08d677f	et commodo vulputate justo in	bstotherfieldl1@mysql.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8a8d1620-ffc2-4745-92a9-48ffbcf036e9	sed vel enim sit	cangrickl2@kickstarter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
53f23416-e0e8-41a1-9dc6-b4a034104b25	odio odio elementum eu	aarentsl3@ycombinator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
38ee420c-1308-4e47-9e19-89c4f8d7a78b	sed ante vivamus tortor	cpawlynl4@businessinsider.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
816f9d2f-7e6b-4ed8-9e05-0d5c1e8300ad	sapien ut nunc vestibulum	hketteringhaml5@walmart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bdb89b0f-ba5e-4090-a6ed-d1a92272ea5c	erat nulla tempus vivamus in	wheuglel6@globo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ad1c6c9b-5a05-47a4-a70c-bf6427727fae	vel augue vestibulum ante	jjaqueminetl7@home.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0021827f-5d97-4841-8b89-69aab8ac4812	at dolor quis odio	wjaynel8@patch.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1597792f-dfce-465d-b51c-bd7a760ede1e	in faucibus orci luctus	mbrosell9@zimbio.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ee79a627-0323-4836-a62a-ba5ee417e7be	nisl duis ac nibh fusce	zlymanla@joomla.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
67f3ee12-16ad-428b-812e-929db5411c51	nibh ligula nec sem	emcfeelb@altervista.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4ef26985-e6d1-49a2-a669-428474d58bcd	convallis nulla neque libero convallis	nbirwhistlelc@storify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2a198f23-1efd-4671-abce-ad44f7953334	volutpat dui maecenas tristique	mthumimld@g.co	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2f6e0b16-5aab-44df-ae8d-eb2055856a60	vulputate vitae nisl aenean	ibaudonelf@eventbrite.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6e6c73ba-6ca5-4f70-8a74-88429377ba56	ultrices posuere cubilia curae	cwortonlg@china.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a348b5f6-8332-4486-84f3-577fa86894c7	lobortis ligula sit amet eleifend	jcansfieldlh@cbsnews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cab11031-9e43-4280-ba2d-cdfadb00a19a	orci luctus et ultrices posuere	lcharplingli@mozilla.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
141817f0-d461-456a-b436-d1f0133d62c3	aliquet pulvinar sed nisl nunc	pcawtheraylj@fc2.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dc2665b0-6cdb-4026-8c33-026f11b83e22	neque aenean auctor gravida sem	rjaanlk@nih.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d251066c-1808-4352-b02e-24ea0604a793	imperdiet nullam orci pede	omoncrefell@theglobeandmail.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1808b7e5-4d11-48b0-92f4-fdf8ce0c3ed6	morbi non quam nec dui	woleszczaklm@indiatimes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0b0637ad-aba2-4545-9bf3-4601ab88ce25	tincidunt nulla mollis molestie	gpeaceyln@cdc.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a328bead-5dde-47dc-a974-cd8bca1f6f51	in magna bibendum imperdiet nullam	spieterlo@china.com.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b37b304b-97bc-4576-b728-1bcb1ccd7d85	at ipsum ac tellus semper	rjephsonlp@mozilla.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
01c404de-e6df-43e3-a64e-a00c710b0e23	ultrices posuere cubilia curae mauris	kguerrinlq@sitemeter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b5cd1972-9d97-493c-a5ce-dd7d15df2669	quam pede lobortis ligula sit	fcollisonlr@who.int	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3ab9289b-1ad7-46c8-90cd-5aaeedf422db	volutpat in congue etiam	gklosgesls@etsy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4d70fc72-03f4-49f0-b15a-07cf3ea4e4f8	in quam fringilla rhoncus mauris	aneilsonlt@scribd.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a1582aa4-f7e6-48c9-b2e6-9a1a614a757a	libero rutrum ac lobortis vel	ayellowleelu@techcrunch.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e664c080-593c-407a-8a5f-670d636f9c4d	lobortis convallis tortor risus	lmariclv@narod.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
992fd6c1-f6da-491d-8f30-397d9454ace1	habitasse platea dictumst morbi vestibulum	kpollocklw@mayoclinic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
99b4d42d-d856-441d-b3f8-185a90bc28e1	pretium quis lectus suspendisse	kharridaylx@nydailynews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3dd804e0-12ad-4b2f-ad90-659b73184b4d	nulla integer pede justo	tmacgarveyly@wordpress.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
72e91d97-8862-49bc-8b8d-8eb7849410de	bibendum morbi non quam	nseabornlz@blog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8c2fbf7f-e371-4f6a-bf7b-2b49765545c3	rhoncus dui vel sem	nskellernm0@clickbank.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fc443c78-1a65-487d-b9d7-4c3dd1789a8a	dictumst morbi vestibulum velit	gtanserm1@tamu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
72b26988-ec8f-484e-b6d9-3253de6b1779	mauris eget massa tempor	karrellm2@microsoft.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
252ec150-28ae-4dea-848b-40168a479b9d	commodo placerat praesent blandit nam	jbadgerm3@intel.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6bc5848a-4f5d-466d-bc9c-6883c64ef67c	turpis enim blandit mi in	mwalkdenm4@digg.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
666bfaa7-5d4b-48b4-8903-319a8fad027f	vel est donec odio justo	cbrothersm5@statcounter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d1277f28-967d-4240-bb22-806b9022a1e0	quis orci nullam molestie nibh	gtommasuzzim6@ebay.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
47eb6784-2457-4b01-a85f-a678b5525352	congue diam id ornare	lfydoem7@apple.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c5a6c953-1a3c-4901-ab7b-5efea9db26b0	turpis adipiscing lorem vitae mattis	jgainorm8@blogger.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
06f1fdb4-2b96-4076-a8e4-2ca3cce090e3	sed augue aliquam erat volutpat	rwitherm9@twitter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
46559488-d741-423e-aeb9-4ca82f7b5890	est congue elementum in hac	uspryma@macromedia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ff574694-f7fb-4066-b6f6-636febf39135	in felis eu sapien cursus	adelacostemb@adobe.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
266e6462-6562-4f10-951f-e1325c1872a8	lorem id ligula suspendisse	ajanissonmc@utexas.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3027034b-a033-41de-ac0c-bad351395389	eget massa tempor convallis	dvollethmd@dagondesign.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0035d8a8-84e0-468e-912c-0e15fcbad0c4	sollicitudin mi sit amet lobortis	cstoppeme@google.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e062b82b-0929-4586-92ab-143860bcccfe	ultrices posuere cubilia curae	jjeckellmf@tinypic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f271249a-8054-44ca-a3d2-9c3f2f56d874	vel lectus in quam fringilla	cdorsetmg@google.com.br	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9e6d2375-9da2-4017-9e20-6a1e1c2f447f	lacus purus aliquet at feugiat	lroscampsmh@51.la	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
863e0538-7d77-447b-a3eb-89694fd28291	eu felis fusce posuere felis	mcutforthmi@multiply.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0d3f9a2c-736d-45df-b12f-4a6819528e95	iaculis diam erat fermentum	fboynesmj@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c3b35953-f992-43e8-9a78-b14e3df96e67	morbi porttitor lorem id	acarymk@dell.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
48a960c8-80f1-421d-9058-ae39396310eb	dis parturient montes nascetur	mvaltiml@msu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4c1f6842-a06b-4832-a108-d2059873b8eb	libero rutrum ac lobortis vel	bkobesmm@fotki.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb42d4e2-2d0a-47f6-97de-3428b8191f70	curabitur gravida nisi at nibh	gbilslandmn@vk.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e974f141-ba83-4855-a7f7-fd9ed0800c36	vitae nisi nam ultrices	fmorebymo@ebay.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
420701ed-b5f2-4870-8476-4186e2725881	ornare imperdiet sapien urna	sculbertmp@nyu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f9a57631-2776-452b-ba0a-4528b7119b39	erat nulla tempus vivamus	csamarthmq@alexa.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1b40bb6f-1dbc-472d-9c2e-efafa4594fb8	maecenas tristique est et	lalbanymr@spotify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6f7ed7d8-7f29-44cc-b60f-eda4e5871a62	augue luctus tincidunt nulla mollis	blockyerms@mtv.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
97e7c080-2348-4aff-b869-e11e58668497	sapien urna pretium nisl ut	rlodfordmt@wikia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2ad65f1b-9842-42b3-9718-5d78a99bb3c1	mi in porttitor pede	tcostellmu@google.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
71395ab8-457f-4b6d-b7f6-26bd9b4d31e5	cras non velit nec	chugonnetmv@uol.com.br	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4266b60e-0dde-40ab-85ea-c58acdb11b22	nisi eu orci mauris	ebeafordmw@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
96814097-6193-4005-8428-5e277f00a15a	morbi vel lectus in quam	afauguelmx@comsenz.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5d999a68-658b-4e26-a2d3-058f24af2488	condimentum curabitur in libero ut	sburlandmy@webnode.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4b9cc799-8842-4c9d-9e49-cbac57733156	primis in faucibus orci	osmithymanmz@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
de19579b-cb62-473f-b8aa-52e9b3cd12a2	integer tincidunt ante vel ipsum	clanahann0@sakura.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9b64f8f2-835b-4a40-9e95-581f68342069	curae nulla dapibus dolor vel	cromann1@tumblr.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
40615b2d-0090-4a82-901e-ae6edc7ff65b	mattis egestas metus aenean fermentum	babramskin2@ow.ly	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a2ffd1d7-4916-4223-a8b3-2ad22ae25697	massa id nisl venenatis lacinia	cjollyen3@macromedia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
14617143-ea3d-40c1-a807-59e08157f304	vivamus metus arcu adipiscing	aisakssonn4@homestead.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
42a4c761-851d-441b-a8ac-07b7f4bb979a	rutrum neque aenean auctor	rmembryn5@sogou.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18829563-35b3-4d83-975d-b6d8fdc4ba25	odio donec vitae nisi nam	edeversonn6@domainmarket.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
565e2ce4-25b6-4426-ba3c-0d661811be76	orci luctus et ultrices posuere	rchessilln7@reverbnation.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d254a996-e0d7-486b-a5a0-dafd185cd9c1	erat eros viverra eget	bsidaryn8@baidu.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
294b2b0d-b1fd-4fb1-99f3-c3446e40e492	tempor convallis nulla neque	bantonomoliin9@spotify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f96922cc-14f3-421a-844e-02b7faf42e36	sit amet erat nulla tempus	astickinsna@alibaba.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
85acfff2-7116-4c9d-9577-e3b55e8f36bb	ipsum dolor sit amet	fciccarellonb@t-online.de	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d84e3776-7f43-4ab1-afe3-09313a53fbf3	at velit vivamus vel	jalcidonc@reference.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e8e995e3-f265-4aed-a3f7-8f07b8a8b6d0	non mi integer ac	knewcombend@rediff.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
bdec438b-83cc-4d1e-a6f9-9d69c19301a3	posuere metus vitae ipsum	glowingne@dot.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2dc73dc0-7360-4ce3-bb15-bbd96452282f	eu felis fusce posuere	remerinenf@time.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e5f2e49e-1daa-4052-b5b6-2afd81cb9352	in consequat ut nulla sed	stomsenng@illinois.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fc9cb5dd-6c8b-446c-99a4-dfd6f8b768b9	donec vitae nisi nam ultrices	glorentzennh@ifeng.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb017758-4e57-42f9-8db9-16ed5a3e0705	id pretium iaculis diam	astaddartni@dell.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d62f7501-232f-47e0-9809-ed565f79caff	platea dictumst aliquam augue quam	jhowsleynj@dagondesign.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0c5067ec-99e8-4dd5-9007-b10fd5d38325	integer ac leo pellentesque ultrices	rtynannk@vistaprint.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f97cd263-93d7-45d2-afe2-9beec715f68d	justo nec condimentum neque sapien	tjowlenl@dailymail.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d9c49cc7-2ac5-4929-af0b-349e27ad954e	sapien ut nunc vestibulum ante	ctedmannm@fda.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ee8c078a-f8a2-4635-b226-015ff0eac399	id consequat in consequat	rmcclaynn@shareasale.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8278c051-7a12-441f-9335-7a58a42f2165	nulla integer pede justo lacinia	ringryno@smugmug.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
85fb56b0-ce83-451b-8c53-be8919c14eea	convallis nulla neque libero	ebrandenburgnp@umich.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fc47f40d-a969-42d6-9025-b69a03e3815e	maecenas tristique est et	trydingsnq@shutterfly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9730df42-9c5e-47e1-82e4-7206504e32bf	justo eu massa donec dapibus	ngreedynr@baidu.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8bf24122-a922-430f-bd2c-e44bdbfd8a29	justo etiam pretium iaculis	vbungeyns@yale.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a11cc7e9-18cf-4340-96a1-bcfb22d33ec0	gravida nisi at nibh in	fgiannazzint@nydailynews.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3868d5e0-ddb2-4ae6-9611-2b6b95d9296a	tincidunt nulla mollis molestie lorem	jfentynu@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
00c97b1c-0b26-41b3-abe4-8e79e3a90c80	elementum eu interdum eu	mworsfoldnv@nps.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
19fe68ff-ae9e-42c5-9a99-89a175a530d4	est donec odio justo	vhaymesnw@themeforest.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b9f20451-16df-4d4e-afb6-cea41d77629f	molestie lorem quisque ut erat	cbiagininx@rediff.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2185a335-e328-4c34-812a-ee0b85bb82e4	mattis nibh ligula nec sem	ryanukhinny@uiuc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
609f591a-e2a3-4b9b-bf0e-890d0deaeadf	semper rutrum nulla nunc purus	bdunthornnz@google.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0a1b4bf0-f782-44b4-87c5-28086bb8944e	convallis eget eleifend luctus	aeasumo0@typepad.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6fcad9cb-26e0-4ba3-8516-03c6798856f8	venenatis lacinia aenean sit amet	despinaso1@bravesites.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7f4cdfc3-c956-4f5b-a591-695ea731a908	elit proin interdum mauris	gkeayso2@google.it	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6dc989ed-8368-44e2-acb1-429f2bfb4065	magnis dis parturient montes	pperrinso3@unc.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
924d2339-3bbd-4e39-ac8f-3727a0392e8d	tellus semper interdum mauris ullamcorper	nbreffito4@forbes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
214f606c-08be-41fe-9463-dcc2375df680	at nibh in hac	wpearseo5@google.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
dc6a79f3-6f98-4391-bf28-22af2b763935	curabitur convallis duis consequat	cjoriso6@geocities.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
20e171ff-493f-4cf7-9ab7-3a1489368139	mauris enim leo rhoncus sed	ghaweso7@cnet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3eda5efa-d068-461d-a3c3-7111c14ba7e5	in faucibus orci luctus	mstauntono8@sitemeter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
79c14c6e-09a6-4fc6-8c94-5c3e3852469c	nisl ut volutpat sapien arcu	igarrawayo9@netvibes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e8f4c000-8fbc-43fe-8e64-1063de54e12e	quam sollicitudin vitae consectetuer eget	ccroleyoa@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2e190f2d-8bc8-48d0-b091-b47f6b0432b3	quis libero nullam sit amet	lprickettob@angelfire.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8b334546-6cb6-4d66-a592-a8adebe951ef	arcu sed augue aliquam erat	fthysoc@sun.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
04b6edca-be9a-4c9f-a1a8-95e29ad42b2b	convallis tortor risus dapibus augue	djoannetod@amazon.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
323ea9a7-e396-4b7e-88cc-c297981bbbc8	iaculis diam erat fermentum	wmussardoe@pcworld.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
27664b9d-8ffd-4751-b9e4-1855b86e6afa	suscipit nulla elit ac nulla	aathowof@joomla.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
57ef256f-c5e3-4814-82e8-40c2593ac5ad	lectus aliquam sit amet diam	abutertonog@reuters.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2029bda5-cca1-4d96-aafd-78cd2ed3a3e7	a suscipit nulla elit ac	cablittoh@cbslocal.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
45c78b96-5b70-450a-8e38-c5a1ad9c19e9	proin at turpis a	jjeramsoi@youtube.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e4af7a99-b27d-4562-a86a-c0a6ce8871fb	sit amet eleifend pede	mbrumbyoj@cbc.ca	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
67ffc536-aeb9-4efa-9c3d-7fad132a8856	suspendisse ornare consequat lectus	nrosleok@vinaora.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a1a05fb5-5423-42d3-9d75-6a9a2bc2fdd3	ut erat curabitur gravida nisi	uvannucciniiol@mashable.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8926f0c3-a5cc-4260-9b58-69a1ed1243ae	at ipsum ac tellus	jmckernom@cbc.ca	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
daed70f0-2109-4908-a2b7-73bdf9324939	magna vestibulum aliquet ultrices erat	tglindeon@weebly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c1d933c3-8326-4a08-8b4a-4103c55335b0	luctus et ultrices posuere cubilia	rlambrookoo@51.la	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a21e6dd0-67ed-4e93-a5b0-27412d19b165	sed nisl nunc rhoncus	ekenninghamop@blogtalkradio.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c56c06d1-f595-432f-94ed-0b47142e5e18	pulvinar nulla pede ullamcorper	ksarloq@amazon.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c952633c-bbbf-4687-afac-b6e5881d4191	suscipit a feugiat et	aosborneor@mac.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5275f25b-7dbc-4bc2-bb1f-ae10d8fcbcac	nulla sed vel enim sit	cglentonos@nyu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0c3e51b0-4bac-48db-9c19-48bfbf164c88	ac enim in tempor	cmingardiot@aol.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a46633bb-5b2c-4bf8-afad-512612d8f004	elementum pellentesque quisque porta	jhallou@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8de15ae6-aed2-4233-9462-1f9de7e95a79	viverra eget congue eget semper	rsparkov@typepad.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb16c56e-c0c8-4093-9ca1-392e71498ff7	nec condimentum neque sapien	cmacbarronow@economist.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9bb3f572-2f4e-4e86-bb3f-364c86909bd0	arcu sed augue aliquam	arupertiox@jugem.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9ea4c50a-cd86-4971-87f1-7041c0cc80a2	nulla pede ullamcorper augue a	asnelgaroy@slideshare.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c1475344-55c3-44c9-a4fa-9a94d92b3ad5	in leo maecenas pulvinar lobortis	chawneyoz@nsw.gov.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f077eeb1-390e-4d0d-a484-fc16f2de45fa	vehicula consequat morbi a	efountainep0@paginegialle.it	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b890b579-3e31-4652-91dd-7fa5e777ee3e	laoreet ut rhoncus aliquet	makhurstp1@quantcast.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
43bfd869-ca16-428f-b1ef-395fa1c54584	curae nulla dapibus dolor vel	obockmanp2@goo.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a1884b61-e043-4088-96ea-5d0afbb4f877	tincidunt lacus at velit vivamus	vdalwisp3@statcounter.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7c9a7ed6-812e-4d6b-aa21-22fbe83e2856	etiam pretium iaculis justo in	mohonep4@issuu.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
48b6d90f-a6c9-46af-9d45-e49e4e6967a0	erat eros viverra eget	folubyp5@taobao.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
03a3a9cb-6f9d-4dd7-9d0b-11e79237938a	luctus ultricies eu nibh	kmaywardp6@artisteer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1e39eb7e-f19f-4e72-86a1-d56762197867	eros viverra eget congue	mradbornep7@eventbrite.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
08a33eb3-e615-42d8-8fcf-cc545e772d95	amet erat nulla tempus vivamus	wmacalpinp8@msn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9aa2565b-97bf-4eb1-9d1f-28d6146a20b2	placerat praesent blandit nam	mbosnellp9@umich.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0076efcc-08cd-4885-a8f6-86fd0708f247	nec euismod scelerisque quam turpis	spourvoieurpa@upenn.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b88a8737-db88-406f-b027-e4407c533f41	pede morbi porttitor lorem id	cjosiahpb@blog.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1a7f7ed8-c0a2-4a5b-9648-3627ce7868b2	nulla elit ac nulla sed	rivanchinpc@pinterest.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eb5d6f51-0bad-42fa-82a4-b989e70cf996	et commodo vulputate justo in	apeckettpd@xinhuanet.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7c303f3d-41e2-4cf2-aaf9-2b090af39b77	luctus et ultrices posuere cubilia	ecunniffpe@google.co.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
28f695b2-305a-4330-ba72-37264457717b	amet eros suspendisse accumsan	sjohanssenpf@ihg.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
15e9fef8-4ae8-4082-af4c-0b62ee017e16	orci eget orci vehicula	bgadsbypg@godaddy.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fa414f3-03cf-47c0-988a-756715d394dc	sodales scelerisque mauris sit	ssimanekph@ca.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0043e88e-0302-4149-afbc-5f0c50db8cb7	vitae ipsum aliquam non mauris	bmoattpi@gnu.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
616efa53-179f-4fbc-a4f8-2a2a249b93ac	lacus morbi sem mauris laoreet	mdybaldpj@ox.ac.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
55437d40-f15e-4c1f-ba46-e2a372bb7a3e	ac tellus semper interdum	bnasipk@cpanel.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
58468ce3-aac7-4449-91a5-09bec92ca848	duis bibendum morbi non	gamblerpl@google.es	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
faec943a-afc0-4e0e-9d00-b15817f0bd9f	posuere cubilia curae donec pharetra	bflorencepm@examiner.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d900b466-410d-4bc6-b39e-5472cfab4e16	molestie sed justo pellentesque	abernardinellipn@exblog.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8f8135c0-98c8-49e1-8ca6-cfe514a80013	ornare consequat lectus in	clowethpo@ycombinator.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
59a3f24f-30f9-464c-a30e-7d7299e9fb8f	purus sit amet nulla	bdanatpp@narod.ru	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
56aceaa3-d894-437a-bd97-7b1f4f17870c	nibh in hac habitasse	rtrimblepq@walmart.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7bab34e8-ab7d-4ed0-8c27-6c79e5400c2c	integer ac leo pellentesque	aownsworthpr@google.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
27efc495-12dd-4456-a09b-1d78cde3bc4c	blandit lacinia erat vestibulum	nfontaineps@bbc.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
17bbf64a-b8ab-413b-94c5-c8b61696535c	magna at nunc commodo placerat	cwharrierpt@answers.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
af65d77d-5388-470c-88e7-bb1fd66cc467	maecenas ut massa quis	kpercifullpu@addtoany.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
437825dc-f7b1-4ce3-91a4-fb6d1b0b9ea9	aliquet pulvinar sed nisl nunc	pchecchipv@home.pl	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
db046119-4fd0-4dc6-a878-d13113d4232b	aliquam sit amet diam in	rmulvennapw@fastcompany.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
887cead9-95fa-4a0b-a499-a60e1f0e4ace	ligula in lacus curabitur at	byairpx@ocn.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
5fae77a4-817d-42fe-b790-10ac66b82a21	interdum mauris non ligula	sjantetpy@sphinn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
4ff8e935-8c16-4aff-b409-e6af73ff9806	purus eu magna vulputate	lkabischpz@netscape.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
950ab134-5d2d-4363-a9c8-b354b6c701c2	leo maecenas pulvinar lobortis est	zcookesq0@bloglovin.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e4f48ef6-a61e-48ba-9875-5661cc6371af	duis bibendum morbi non	jpharaohq1@census.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6f603e67-1ae6-4fa3-8e3c-73f6d1b73f01	etiam pretium iaculis justo	lbealeq2@mapquest.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cb90b97f-d12e-4325-9a79-50546bea4677	nam congue risus semper porta	afraczakq3@twitpic.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
9cd320e3-f91b-427e-baeb-91b8e6f2403e	integer tincidunt ante vel	mizakofq4@cpanel.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7f68cfb1-84f6-4174-9c3b-736b205f6255	leo rhoncus sed vestibulum	croughsedgeq5@hexun.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7ced36ba-9965-437c-83b3-549b7e691d2b	integer non velit donec	lgeppq6@craigslist.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6ab38d4c-2b70-43a2-9904-b3f31ba816f0	mauris sit amet eros suspendisse	dpasleyq7@thetimes.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
b841c458-3376-4041-9763-1e0d46a8c1df	dapibus duis at velit	ldawburyq8@flickr.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
905baa6c-bd4b-4750-86af-4c5d319333b6	in porttitor pede justo eu	mlitchfieldq9@printfriendly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2cc8e42d-97b5-4c21-97ef-be062bbca633	integer ac leo pellentesque	wfellibrandqa@alibaba.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2bae522a-41a7-4f77-a4bf-7fcf76191934	adipiscing lorem vitae mattis	dlockhurstqb@wordpress.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f17574e0-8034-49be-9fc7-82edf8599464	quam sollicitudin vitae consectetuer eget	bmushrowqc@abc.net.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d85bb902-0489-4f98-bb36-4eba56527930	rutrum rutrum neque aenean	acastanaresqd@clickbank.net	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ece427b1-caec-44dc-955d-f0cea2261c43	porttitor lorem id ligula	nscholarqe@goodreads.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c7b55a64-e944-4faa-8dfa-92394260a389	ut nunc vestibulum ante ipsum	lbelfittqf@uol.com.br	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f95f05d0-ae09-4b8c-951c-980399fa0574	sem praesent id massa id	pboggesqg@is.gd	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3aa8566f-1c6c-4457-9e56-85f31ffd39d4	penatibus et magnis dis	klorenzettoqh@telegraph.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6756378e-6b18-4bc8-914d-d7594d341e8e	pede lobortis ligula sit	cjoselinqi@cloudflare.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3b71c9b2-71bd-4651-964f-04c62cb44876	in hac habitasse platea dictumst	lpurleqj@squidoo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
3c7646b8-2942-4eac-8454-a4691b45c90b	pede libero quis orci	nmilierqk@webnode.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1d210043-33a1-4c0a-a41e-f0f95a778809	donec vitae nisi nam ultrices	rlegierql@mashable.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
516d7aff-b0ad-48ff-ab6b-28e2b6708b22	scelerisque mauris sit amet	hlyptrattqm@exblog.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cd87bb68-a0f4-4044-a842-d780de9b4813	fermentum donec ut mauris	kyakovqn@nifty.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e806573f-624d-44fa-acee-34fda3f3b541	nisl nunc nisl duis bibendum	ewickinsqo@storify.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f225988b-909b-4ff4-a6e3-41dd8e1bfdcd	tempus vel pede morbi	ashergillqp@jimdo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
864206b2-7168-409c-86ba-1d9e204ca27f	porttitor lacus at turpis donec	aleneyqq@pinterest.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f5d743ff-0e73-46e1-9dfd-5fe6582bea56	sollicitudin vitae consectetuer eget	kpemberqr@meetup.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
608ca06f-82fe-4b83-89e8-f0dd3338b782	ac neque duis bibendum morbi	blightbownqs@friendfeed.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
d87c2d6a-bac5-430f-a994-f07518369719	ipsum ac tellus semper	mtathacottqt@yellowbook.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e56a37e6-0bb6-4a83-b825-f39b06a5f049	commodo placerat praesent blandit nam	cshannqu@techcrunch.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2b4c5160-fd64-45ea-90df-c7134512f0e1	hendrerit at vulputate vitae nisl	fgallerqv@virginia.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
11f3fb15-9e51-4f7c-a4a5-738e33f368b4	at turpis donec posuere metus	jgilbeartqw@tripod.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
fa3536fd-c1e6-4406-96e6-8437dd37cf7b	neque aenean auctor gravida sem	jpeetqx@independent.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
44c9ba4b-f27a-4ecf-b859-e8e0a8ee9e0b	dapibus augue vel accumsan	sarnaoqy@simplemachines.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
1bcbfa69-f081-4b44-b03a-c27c04aa9c15	tempor convallis nulla neque libero	tdonanqz@msn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
eadc3e1b-2cda-4508-9c7a-98a0a6e0e34e	parturient montes nascetur ridiculus mus	gcinor0@sfgate.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
132e75b8-29ec-48a2-babe-7e1ff0ca11dd	eleifend luctus ultricies eu nibh	ccarffr1@instagram.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
293cf87e-ebbb-4bcf-a5b6-f162d82c1638	suspendisse potenti in eleifend quam	ebatesr2@google.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
67d56d1a-a713-45c3-ba53-4946d5bfd632	sapien cursus vestibulum proin eu	tgrangerr3@redcross.org	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
79f3a79b-b035-4089-8995-acbaf3831fb7	aliquam augue quam sollicitudin vitae	thabberghamr4@github.io	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
61eec09e-5579-4ba2-bc92-1b2621b6dbdd	nullam molestie nibh in	mhoyesr5@weibo.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
88d2c7e9-0e1c-46b7-b92f-75a6c8ad26ca	morbi odio odio elementum eu	dsabeyr6@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
18e0f260-5c90-4b75-952e-718986135355	dis parturient montes nascetur	tdundonr7@who.int	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e6bcea08-0272-479d-9a5a-9c21a4f3807b	donec vitae nisi nam	shaggerwoodr8@smh.com.au	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
cfee3350-463c-478f-9f9c-16d3c846a7bd	vestibulum sagittis sapien cum	mswatheridger9@msu.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
ec58aceb-1baf-4912-a970-59cff2ef10f7	in imperdiet et commodo vulputate	fbernhardra@desdev.cn	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
2da1bce2-8ab0-4f10-acad-e471db3b6ddb	lacus at velit vivamus	bivesonrb@fotki.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
a7062a62-7d3b-455d-923a-f8fb26567e31	vitae quam suspendisse potenti nullam	alidsterrc@house.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0df8a564-9b3e-46d5-ac69-18700b8643a9	ante nulla justo aliquam	bbrynsrd@weebly.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f3e49923-f67c-4e7b-a058-216d0b2f2ca7	id ligula suspendisse ornare consequat	mmcgraghre@flavors.me	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
706ffd1f-30d6-4cd4-ad96-836d07462866	id luctus nec molestie	jslynerf@sakura.ne.jp	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
599a826b-b9af-42b0-a9e4-f577a9b186e5	nascetur ridiculus mus vivamus	fblissettrg@reuters.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
c63eea0c-4d63-47cd-aa1d-df1b4083924b	ut dolor morbi vel lectus	jjanuaryrh@amazon.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8322105a-24ca-469c-852e-659adfc972a3	enim leo rhoncus sed vestibulum	ayuryaevri@wikia.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
6be2eeac-fab8-4c9c-8d7a-23ade3ce6e26	mi pede malesuada in imperdiet	rilyuchyovrj@yale.edu	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
8b5f95ac-4189-44a6-b8d6-ec0737ddfbec	elementum nullam varius nulla	fboristonrk@state.tx.us	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
604916c9-f0e5-4cb9-a69b-62df1803e94b	congue diam id ornare imperdiet	jcaddiesrl@sphinn.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
f44d5832-7866-493a-9414-fd61678c6dc8	a nibh in quis justo	mlambournrm@free.fr	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
974d6725-1e47-4761-b93c-9995d808d945	et ultrices posuere cubilia curae	cmckeachiern@woothemes.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
afc1a48a-d533-469f-be3a-2aee03de9bf7	quisque ut erat curabitur	bvillaro@wp.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
e7f3f288-7260-498e-9368-c7e74aeefe92	felis donec semper sapien a	oabbysrp@hhs.gov	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
7ecf49ae-7815-446e-ae4d-f840ddb7695e	est lacinia nisi venenatis tristique	mreddickrq@timesonline.co.uk	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
0fe7fe70-3dd3-4c89-9ea4-3809dd8e1267	sed justo pellentesque viverra pede	hcristofvaorr@springer.com	2025-09-25 04:19:18.97076+00	2025-09-25 04:19:18.97076+00
\.


--
-- Data for Name: lineas_venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lineas_venta (id, venta_id, producto_id, cantidad, precio_unitario_valor, created_at) FROM stdin;
13d65fc0-4503-4c8b-8292-f82cd6b21518	91e34dfa-9d3d-4330-8713-cedf19705c2a	16237e4b-0664-482e-a32f-3d60cc5e6114	2	32.75	2025-09-25 15:49:21.360008+00
851d3e0a-b30d-4cc7-bab2-387c06ab60b6	05639713-2fc1-4653-991a-6e7b6fb6963d	3f697690-af3d-4376-b1c4-8374dd413173	4	327.39	2025-09-25 15:49:21.360008+00
64337f12-6fd6-4978-88cd-d7910dcaebce	94616eca-5069-4a67-a50c-a0e30b58ea7f	8cb7f3af-5fa9-4d37-9dad-e273105d1f21	5	424.88	2025-09-25 15:49:21.360008+00
8ea3c075-97c7-4545-ab1c-2c8190a5874f	94cbcd20-2c3c-4343-812a-e323c45b0111	127f89d8-13b4-449c-8d8c-0503721de511	4	52.28	2025-09-25 15:49:21.360008+00
132c91fb-60f2-4025-a3b7-3656961e0246	3a9ce289-a876-4e46-835a-e120989c8652	752a4864-78f6-4f0a-a899-2df7627aaac1	1	340.29	2025-09-25 15:49:21.360008+00
9d3ca3b1-5fc2-41d4-bf1a-e3ef2756bc42	7856bf5b-2c19-43d8-b299-88d269f0b82d	2a822dd9-fd77-430b-bd12-019d4b26f9b0	1	441.93	2025-09-25 15:49:21.360008+00
3959c44f-4c8c-40cc-a638-163360bbeb55	915e5bc2-8e56-417f-a081-ffeb296d2b35	108eb6a7-0467-4283-a1a8-c73da5f0ce5c	2	102.23	2025-09-25 15:49:21.360008+00
fff6f6e9-dc3c-4682-a636-9cff6947f7eb	7078a458-4849-4d87-8dd1-f705e9d204e9	95fdab27-0aff-4ae3-af8b-3fcfc6220729	4	429.24	2025-09-25 15:49:21.360008+00
f1e380c3-9644-4711-b4e2-bfd1e3d2fae1	d10ee357-d8f1-458e-8484-fcacc5c4ac3a	c0f634d7-4b5b-43e6-8f84-d62622a1576b	5	266.93	2025-09-25 15:49:21.360008+00
96174216-f6ee-4b8f-bafb-c33933955d42	1f5a7650-6543-4791-b064-3290aa6b362c	5537b5cd-974c-4232-9f90-dde2a70619bc	2	471.08	2025-09-25 15:49:21.360008+00
9f3d2a5e-a620-4181-874b-4d5ec7cda6bd	d2b4f687-7bf4-4b65-b058-37c2dad6f887	e72277f0-d084-48ab-93be-36bb4c2f1c9d	1	145.30	2025-09-25 15:49:21.360008+00
a0ca79f9-8d8c-4ae5-a2d3-4b6efe5707fb	7a07cac1-cb16-48cc-a35f-dd7974c78726	a8a11156-1c57-4a4b-8c63-b08f29eac11f	1	39.27	2025-09-25 15:49:21.360008+00
aa260d01-ee80-4f27-8e3b-0d2cfea23215	2f1b8741-8866-4267-90ca-5084ab49e155	ac1d25fd-ea2e-461b-837d-85d1a9222fb2	5	142.12	2025-09-25 15:49:21.360008+00
48e56687-18d5-42d2-87f1-0981eb0bf3e7	6d8773f9-5e39-407d-b9b0-adbce97a9dc5	483a148c-18b9-4e7b-8f6d-48e9db2a12b8	4	441.21	2025-09-25 15:49:21.360008+00
b3ae8617-c293-4332-a53d-63e9e55bba96	75574235-ca38-4468-9173-6c13e625a703	236c0db8-4326-4c16-9d7c-03d2f5c787ad	4	298.73	2025-09-25 15:49:21.360008+00
21103ad8-53ec-4df3-9220-7d414ca594ef	6ae5691a-d04a-4b0c-8233-8ff0f53ffd53	636633c1-3d62-4b6f-9154-4ed3fc8595d5	1	243.60	2025-09-25 15:49:21.360008+00
c091007c-3b2b-430e-9b26-e615d9cd7809	c88dad4d-3293-4c57-b39b-957991bb2f44	430f6e5d-6537-4ebb-96e5-aeb0777827fe	1	278.96	2025-09-25 15:49:21.360008+00
812ce6fc-c87e-4bbe-b524-8f125b555cd2	12d7868e-c1a3-4618-ab63-a56d9efc5c91	be17ba99-47cc-4f1b-89ab-f0ada842f8be	5	494.19	2025-09-25 15:49:21.360008+00
ac256509-29a5-40fe-89e4-35668983381a	260c5ea6-e65c-47e4-b88f-a5345ad86fb9	f4429a7d-1708-4564-afa1-873cc4345c03	5	421.54	2025-09-25 15:49:21.360008+00
15944336-b5e9-4220-991f-6e80ead7b7dc	41af7684-234f-4c36-93d9-550f6dec9dd7	c96f321a-391f-4fe0-b189-23b2294f7466	5	285.09	2025-09-25 15:49:21.360008+00
de8e4a79-f3c6-446c-9e38-5a788d1e737c	d03a1f35-5561-4042-a79b-ce2f6efed426	3ee86da7-002a-43b1-a506-07f151f86be2	3	435.74	2025-09-25 15:49:21.360008+00
7a83b291-a465-4cdb-8260-79f32584cc1b	733f73d3-895f-446e-b37c-58d672899e95	cf7c0140-d018-41ed-b1f3-d84978d66add	1	452.19	2025-09-25 15:49:21.360008+00
bee4c3ad-e1cb-48fc-98bc-916637191e99	f55e497d-80d2-46d4-8ef6-08d5577450e3	07255a53-2da9-4f48-a69d-639507f6118d	4	78.63	2025-09-25 15:49:21.360008+00
2915305a-78cf-4e89-a311-7d49c56a989d	81e3e409-d429-4a1a-b8f3-2e8e517dac57	254f4daa-339b-403a-bd8d-8926449ae5be	3	244.07	2025-09-25 15:49:21.360008+00
706582ac-303f-4418-84c7-3e1e44b00361	c14adf70-0385-4c05-958d-e07e8154e2c7	65c0ab7f-24fb-40bc-87f5-b5829a108a71	2	365.81	2025-09-25 15:49:21.360008+00
5e674568-5c1f-4791-8959-990c8d1e27a5	26f6f110-f310-49d5-a742-3d58af2fdfcf	81fb946c-0924-4f49-b172-7d321746b6a7	2	10.62	2025-09-25 15:49:21.360008+00
6f346246-67b0-48aa-8f57-a0e766c1c183	8b06a691-37b4-4a8c-8a84-e7c5b02f8369	5eb24da8-573f-4682-bbd9-9c03f2eac2a6	3	265.79	2025-09-25 15:49:21.360008+00
68f08463-1dba-4011-8f60-8d969fffd0c8	9aa91f21-3a06-4000-b2ea-006f267cc7c4	263e7942-e285-4939-be57-7f77b2431136	1	124.24	2025-09-25 15:49:21.360008+00
3d6f27e7-5c0b-4c20-88d7-93bd4ad43406	a8f1300e-9928-4a6c-87bb-88e67dc80007	b6359526-55db-4701-ac7d-b51d5bdb2fc6	3	441.68	2025-09-25 15:49:21.360008+00
d67a503d-f2bd-4540-bfb2-34e0501c4283	0cb4d9f1-82ad-44d7-888c-eec2bd84474f	46f455c8-0f16-48a5-81ba-5ec3954da241	4	407.71	2025-09-25 15:49:21.360008+00
c66e4b27-db63-45f1-8e6c-3b674c185358	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	1ab30713-5e7d-46de-b29b-b022a593b830	1	242.02	2025-09-25 15:49:21.360008+00
d83be224-1323-4eec-8b06-0babaa356402	af68737a-6f35-4095-8e08-f693aca5b974	cf28c8b3-fd3d-40d3-9c0c-c9990416d8ab	5	40.04	2025-09-25 15:49:21.360008+00
9a7f0370-181a-4dfd-b5eb-0a7d35831616	cca06839-8936-4474-b9ce-9309b36ff30a	ae58abdb-65e1-4b29-af25-1ec389b777b3	3	488.69	2025-09-25 15:49:21.360008+00
5dc2dc52-e0a2-42a1-b5f9-be253335dc95	a27f5718-7e62-41fa-bcfb-f245f7e6c4f8	ba164ec0-372f-474c-99d5-f1c299711396	5	81.55	2025-09-25 15:49:21.360008+00
cff16fa3-084e-4ec5-850b-24ab0e31f545	84e30ccb-1a2c-4aab-8f51-535fa4b30f24	856d5eca-a8d9-4b7b-bf5b-5503dccb7afd	3	471.39	2025-09-25 15:49:21.360008+00
45b2f5de-06be-481a-a190-30c9a81ff89a	967536eb-8cb9-4eb6-a8f7-77c9d6125463	1d73ab87-99a5-4dfc-ad19-1f06460b414b	5	443.81	2025-09-25 15:49:21.360008+00
c7dca094-8202-47da-af28-37e20fc6acd0	d03d2567-bc3b-46a2-b2ee-11b8b8523357	86eb1621-d103-4562-bb6f-0cfe8c9a4421	1	157.02	2025-09-25 15:49:21.360008+00
80ae28c9-5579-4232-8bfb-19560aa7417e	d4281f72-8512-46ed-b992-e0d67b8f11ec	d8e8cf41-1f50-44d6-be1b-753f999a5fbf	2	305.03	2025-09-25 15:49:21.360008+00
8e7b8dac-fadb-4902-bb4c-a32e6c8c0c67	01d87596-cfd1-4a33-a5a3-afc687b9fc5e	1c0fdf1c-7dd6-4ff2-9bc3-59f2e01f1e28	1	173.41	2025-09-25 15:49:21.360008+00
82dd1cc4-a9ba-4bea-bcde-54c5351b5dff	c1f405d6-dd8a-405d-9218-a37d6970e656	430f6e5d-6537-4ebb-96e5-aeb0777827fe	5	210.74	2025-09-25 15:49:21.360008+00
4f24553f-458a-4350-b3bc-7b2e389c5bed	aa564c03-b89f-4e26-819f-b348be96c1eb	1a747b45-a898-4f93-b6cf-e58f4fd2774d	2	367.25	2025-09-25 15:49:21.360008+00
30ee44e8-6c78-449c-98ff-0a6e1c2fc699	9c349870-4a91-4fac-b1c8-a59c6d9aea49	923c943d-497e-48e3-b9e4-7c33df1370c6	5	445.41	2025-09-25 15:49:21.360008+00
12084a00-d234-4142-af7e-cc6f059aa7c9	68251dab-f3ed-487c-89d2-3bb3ce61cb51	752a4864-78f6-4f0a-a899-2df7627aaac1	1	193.55	2025-09-25 04:45:10.98788+00
aa9abc96-45c8-4d98-94c5-6dcce8a15190	8b1d9977-e8da-490a-8a9f-b67c3df4199a	8423502a-d4b8-43f7-a439-7af92b153814	5	39.48	2025-09-25 04:45:10.98788+00
2f6fa7c2-d026-433a-bd47-7dbdf8cf9d5d	f40f0728-62c1-46df-953f-e17e6e5aa6e8	f28dc1d5-6491-4b43-86fa-00c71eb6ce06	3	305.98	2025-09-25 04:45:10.98788+00
a3c303ad-9acf-4b22-a3af-58d86b92e24b	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	d81476a4-8563-4c32-a7a8-3abfdb5e6968	3	183.63	2025-09-25 04:45:10.98788+00
bb9b0594-edd1-4466-b46f-91df427722b9	62b0727d-68b0-41e2-bf76-5411fa41c964	483a148c-18b9-4e7b-8f6d-48e9db2a12b8	2	236.61	2025-09-25 04:45:10.98788+00
20df00be-330b-4638-9b1a-2423158d7ba0	654b1ef3-ade0-4ed9-854b-2a1172e403e7	bb353bdf-b32e-41ff-b04f-93cd52192837	2	494.26	2025-09-25 04:45:10.98788+00
2e109022-aa13-45fb-ae13-128cbca3dbf8	58732d14-1087-42df-88a1-891062e59216	c089edcb-9113-4eec-8083-c2c56dd4ee24	1	275.41	2025-09-25 04:45:10.98788+00
0626fb3e-038b-4ffa-b2c4-41eeb47526ce	b07c22ad-19c8-49ce-8891-19bb8fad43d9	e7d7d5bd-c4a0-4990-affc-79d875c9bf9f	3	324.99	2025-09-25 04:45:10.98788+00
83ac3a1d-9639-4e24-a122-eef9c64b8c4d	f5ecb52e-02b5-486a-9a46-6d49fc404954	16237e4b-0664-482e-a32f-3d60cc5e6114	2	199.22	2025-09-25 04:45:10.98788+00
7fe31258-7bd1-42f1-8b5f-0121979a0755	dbd346ee-a8e6-4a1e-a24f-fc2daba21fdc	24e41afa-9161-4715-9372-14de21ddfa1f	5	241.80	2025-09-25 04:45:10.98788+00
403e001d-a28f-4bca-81c4-4704be8a3b49	9950f002-d400-4835-97fe-97a61c858a79	c0618cb6-0459-483f-a990-6ceb8852d6da	5	477.94	2025-09-25 04:45:10.98788+00
79c63967-dcca-4318-b79c-bbde63c84d4f	5fbfff3d-7b8d-4de0-8cf7-2aede26c6ebc	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	3	306.98	2025-09-25 04:45:10.98788+00
5f4665cb-f2d6-422f-9828-d3c540ad9a53	524c4a55-37d7-47c5-af46-c34b7a7f253f	329ef81a-ddb7-4583-a1e6-3088e1132d02	3	75.40	2025-09-25 04:45:10.98788+00
a9a475c4-1033-46ac-b0f1-033802d37819	7c190cc8-396b-452c-a86e-9a4b029eaa78	52885168-97b2-4e13-93f8-92bd9dad7faa	5	438.78	2025-09-25 04:45:10.98788+00
58ab5d02-9b9c-411f-9567-2eeb96dd0e4f	90c3d581-e6d0-4778-94d2-4da99a0eb10c	be6e3ada-368c-4173-9e73-fc99f2d5b20e	5	64.15	2025-09-25 04:45:10.98788+00
bfa7fccb-37f1-44a5-b882-9404e701acc4	e9bc0fdc-18c8-4436-98d4-1168a12a093a	f96ccd19-1c60-4ae7-8fea-23ef4ab7894c	2	414.51	2025-09-25 04:45:10.98788+00
efa99177-a521-42f3-a4a1-2cd99c2aeae4	08607ad3-480a-4945-a934-b96d6ea030fd	8dc7fa3a-ab89-4405-b1ad-301b6a89afde	3	451.80	2025-09-25 04:45:10.98788+00
a481e3c2-e74a-483d-a39c-d56ff84c2fed	873132fd-5424-4c58-bf3a-6abe74432ab0	1c0fdf1c-7dd6-4ff2-9bc3-59f2e01f1e28	4	164.75	2025-09-25 04:45:10.98788+00
0d194daf-afbf-432f-8c77-44a74560e439	833ed813-6177-423d-9903-87634724c195	449d5f97-315e-4a4e-af32-df159c3391f7	4	120.12	2025-09-25 04:45:10.98788+00
0367e2e3-32da-430d-9b96-5d8a1bb0b982	c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	d5cb6d47-534e-4b1d-b339-c34315876121	4	157.41	2025-09-25 04:45:10.98788+00
67342c51-0782-4870-8951-7408de3ec750	3ac2a44e-2d7e-4aac-848a-52a503161e85	2cac94f6-f439-4a4c-9f09-75eb1f99f0db	5	310.02	2025-09-25 04:45:10.98788+00
b81cc4df-364e-4eee-a2a5-0fc5bfc75a0b	30285572-1976-472b-97a9-c6d411bb8d0c	ccc4bb9c-f827-4f5b-b7aa-27140781312d	5	476.23	2025-09-25 04:45:10.98788+00
0d43b367-8612-4d68-8f57-7011794f72ad	1d9052a7-123b-4c23-925a-27bb369ebb16	263e7942-e285-4939-be57-7f77b2431136	4	53.88	2025-09-25 04:45:10.98788+00
1858d828-f145-41c5-9712-f0fa80412421	6f88a97d-f175-40d0-b968-273c0dc967f5	4e60b8c4-f146-4be6-8129-816854b5f830	5	311.03	2025-09-25 04:45:10.98788+00
aa4c721d-43ef-4b39-afc8-bde44c3d22ac	335585f6-4bb1-4bb4-b668-b154bafedf8a	a7cff05a-8292-4747-8a9a-9905edf4c651	5	87.57	2025-09-25 04:45:10.98788+00
a7246d3b-4519-4a72-9c12-0348625e00f6	da1a2d3f-7a99-4c79-ae23-495545b71b44	0c131e48-2bf1-402a-a2de-fb03d45a6173	5	136.70	2025-09-25 04:45:10.98788+00
f6ad36c7-42f4-4e1d-9723-5820dde303c5	a40eba37-28eb-40a2-b5e7-fc34abc8d3d5	85e68321-7895-4d1f-9e05-28a2d824c984	4	402.41	2025-09-25 04:45:10.98788+00
9a002b44-a951-4c20-a0f6-150663c3bd41	bceef424-4b29-47c2-8409-f5b9897e681c	f6646719-cad7-44da-9df7-f91b352004f5	2	460.36	2025-09-25 04:45:10.98788+00
1fc40c5f-d5fc-4625-83ba-349cdb67fb75	19645d20-d291-441f-9003-ec78341bad89	0fd70815-cee5-470f-8b7b-37c3fbb1b4fc	2	464.07	2025-09-25 04:45:10.98788+00
f6c133ec-db28-4351-9631-fa92e7935efd	001e1111-8116-4bf1-9eeb-3e46c157897f	96025684-4b0c-41a7-8dc1-96f351c134f9	5	38.24	2025-09-25 04:45:10.98788+00
7753eb8b-776c-4e1e-b5b5-ac434da91867	c9f84933-0b22-471e-bae8-cf205690ad63	36a6c226-7e64-42cc-a129-41e2439fdab8	5	205.03	2025-09-25 04:45:10.98788+00
6c7fb68f-a758-4aa1-986b-fc4d2c2c3696	db1badd8-71cc-4a88-a06d-abebe02ee7fa	be6e3ada-368c-4173-9e73-fc99f2d5b20e	1	62.29	2025-09-25 04:45:10.98788+00
6551649b-fe08-45f5-875a-63f6fd15538b	223005b3-31fa-485f-b021-606d097d451d	7c6ecbf8-6f0d-4946-9d9c-0d99d210458c	5	251.69	2025-09-25 04:45:10.98788+00
457ddc3a-537b-43a7-abd9-a23d5f301582	2a21d19d-fccf-4bb9-8eaf-a5ec16428fc0	e85d3e7e-015a-4c9b-98d3-81e76e653386	3	255.16	2025-09-25 04:45:10.98788+00
e69756fb-955e-4e61-97f6-e64de3c4ba9d	51e85022-111e-4b2f-b141-76d0042ab084	9177a11d-1cef-401d-a853-7448a708bdc7	1	348.01	2025-09-25 04:45:10.98788+00
9a417cbd-99e3-4e28-b493-4a0b995d7891	43fa5db4-cd26-407b-b9df-3d1400eca579	27e2e9a6-1d22-41c0-976d-dc7ffc253d4e	3	271.58	2025-09-25 04:45:10.98788+00
53180d9c-19dd-4355-8242-a09db2df840d	6687abd5-7e8d-4f93-8872-ed7973c82067	7cb3179c-ca2c-4b60-88ce-300066649462	5	411.19	2025-09-25 04:45:10.98788+00
a9620c56-bc1e-4906-8ef5-de22983535cb	59893b10-830f-45ae-ac1f-450959f712b3	b44bed20-df21-4afa-a304-5a70bf1661fe	4	378.61	2025-09-25 04:45:10.98788+00
f0cba450-73f6-4742-824a-548f204ed887	f240e3ce-f856-4de2-803c-b9ed09a26deb	d2e095fc-f2ff-4502-8c47-01b10d503f0d	4	352.69	2025-09-25 04:45:10.98788+00
336949f2-78ed-437d-ac89-05b22141cb9e	6cb6a800-5043-433f-ae41-af18c9863d4d	3c4db21d-9d76-479b-b0d3-b06b75d45bb5	4	366.10	2025-09-25 04:45:10.98788+00
7e6ef9a0-3dfe-47c2-a044-ed3c30f1d37a	1529758e-e2db-4a59-9475-3ee95437d6c6	7f72cfc7-633d-4d9f-a31e-e0424be358fb	1	175.35	2025-09-25 04:45:10.98788+00
396328b7-b995-4fd3-87cd-f81d0d67af65	340d285d-b98b-454b-b371-ac1d89d58318	3f930a17-699a-48b2-9ca2-245e31268823	5	258.01	2025-09-25 04:45:10.98788+00
9c20a1d1-1849-470e-a31f-fef4283dd2c5	9b71b1b1-9175-4e94-8df5-8d99337039f3	9f8a8d90-ea1b-4928-a2fa-135af6cc5301	2	264.57	2025-09-25 04:45:10.98788+00
ce82fc1a-ca36-40f1-9ae6-28b966cbaddf	985f818c-1a1a-4d3e-8bef-69164308c435	3e34ea2b-557e-430f-b6a2-81f8e4c33dea	1	104.63	2025-09-25 04:45:10.98788+00
98d94a6a-8ed9-49df-8747-1f4fbdd6c60b	8c30775c-7387-485e-a1e3-b48311e93820	e75a724b-b522-47e9-8475-f8f74181c1c6	1	66.60	2025-09-25 04:45:10.98788+00
4a22663d-4613-40e0-a1d1-c4466f541b94	84215ee9-c6c5-45fd-9a43-7cc76c8bb7f7	5f031354-7104-4787-8509-9f923d36b792	4	445.61	2025-09-25 04:45:10.98788+00
84d2d920-e678-4fe3-b625-8b3aec24a3cb	9526c4ff-a55b-4e0a-b7a4-b0b58f9c6f6e	e5055dc0-3bbd-438a-8ff5-921d70643ac7	2	489.35	2025-09-25 04:45:10.98788+00
e909eb4b-7b81-403f-ab3a-4a0065140d62	237a8e42-b8be-4a34-9107-99c8c32ce353	46f455c8-0f16-48a5-81ba-5ec3954da241	5	134.70	2025-09-25 04:45:10.98788+00
4cc7f09d-3992-4a56-b04c-05c022e5eba2	e5f30e6c-96b7-42a3-bffc-6d1fc991f36d	e5a34702-df91-4bbb-a7d7-9eaeeac19445	2	76.60	2025-09-25 04:45:10.98788+00
c9e801b2-0c0f-4554-9796-1b99869742e7	abfccf19-05f0-4433-92f2-9a03dec16d06	c7061bac-6800-4837-812b-4259c2eef643	1	378.04	2025-09-25 04:45:10.98788+00
592b07a0-9160-4333-af71-09852739908a	019ea4d1-14af-409d-89ee-fbf3c80454d7	38698efa-0fa4-4a79-9d21-2da2af8008f9	1	342.47	2025-09-25 04:45:10.98788+00
7b721f7d-b54d-487c-b137-9e0dc5d0fc26	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	f3c60162-6f84-46c1-8a02-a4e9649cfc51	4	68.24	2025-09-25 04:45:10.98788+00
66f0a93e-9395-44c2-9486-1615504630e4	6ec08346-23fb-4c08-8fd8-389c0a163beb	5958b536-aaaa-4c7e-baf0-72743dfb953f	4	207.50	2025-09-25 04:45:10.98788+00
db82fa6f-9db3-4be6-b433-a290aa96e1d0	9cea1810-1a51-4ff6-95d0-7b290b81268d	a067a03d-fb3d-4178-986f-3f263a72104f	4	222.80	2025-09-25 04:45:10.98788+00
8bed86f8-8ed0-4d53-acec-b9406143a597	53b43699-f881-46ea-9196-733d65a9f7f6	956a56b9-49f7-4357-8ce6-cf3b7a8d5f1d	2	496.76	2025-09-25 04:45:10.98788+00
af491717-038d-42cd-9942-a0c2174a8789	2e6c84e3-29ac-4202-a0c5-96b9b1861228	f75153fb-81fd-4adc-bd1d-9bc21c5ace09	3	44.28	2025-09-25 04:45:10.98788+00
aae04f66-cd02-439d-9e64-6542905ba80a	d2859681-703f-40dc-8ab7-5792acf0c507	8e4f9281-4de2-4a32-8382-9889f1a24801	5	23.18	2025-09-25 04:45:10.98788+00
be20d2aa-d23d-4351-9797-307a22e37b27	08607ad3-480a-4945-a934-b96d6ea030fd	16237e4b-0664-482e-a32f-3d60cc5e6114	3	404.43	2025-09-25 04:45:10.98788+00
df935e2c-96af-47d1-bb0e-81fdab30f7c4	81c6669e-9f7e-4d7d-b826-3b2032020e7c	af707ecd-ed23-4117-989e-4eeb702dd659	2	34.93	2025-09-25 04:45:10.98788+00
9c2b22aa-f23d-4d57-a46a-c0f4436195ec	74fc3cad-5d31-4f86-96b7-b22859970376	6199b152-5290-426e-9731-ae4cde532bfb	2	262.08	2025-09-25 04:45:10.98788+00
8dfeb1fb-a362-4ac3-96e4-b13a1308824f	84929b25-b2ed-4d34-bc13-3ec73853b06d	841b7e04-50c4-472b-a915-2f0e108cce3d	4	339.60	2025-09-25 04:45:10.98788+00
6c0c5c2c-b07a-4891-b46c-38140d7b8cd4	335585f6-4bb1-4bb4-b668-b154bafedf8a	356dbff0-728f-4cfb-81ca-1aba7a2422f9	1	117.84	2025-09-25 04:45:10.98788+00
1b0c032e-7c8a-4bc3-90d5-e908b0932164	226efa52-93a0-4d6c-b9d6-ea132c4fd535	e75a724b-b522-47e9-8475-f8f74181c1c6	4	299.87	2025-09-25 04:45:10.98788+00
abe20e43-821f-4314-a048-294135c49f65	ef4fce6c-c216-4bf3-a10a-15d6bce77f94	95f40c38-c977-4239-aea7-21df5de3a7ea	1	99.27	2025-09-25 04:45:10.98788+00
5180220c-7b74-41f4-b63c-8ffa985a1358	aea6cca1-ab99-4fb1-9aa5-fc82f54da674	fb0a123e-0eac-43c4-b79f-ebbf6a3e2644	5	297.46	2025-09-25 04:45:10.98788+00
7d8f9f21-d4bc-4e2f-82f0-3a9d438243a9	70661215-9aff-4315-9fc5-027c065db093	27a57e29-9044-4910-8ceb-6e40fe7b52c4	5	439.23	2025-09-25 04:45:10.98788+00
60e2dd18-126c-406d-8ae4-c2a418d10406	4022498b-124e-4e7f-a690-5c227b7ab3c1	b19683b3-ab17-4746-9e07-440b6db949fe	2	424.22	2025-09-25 04:45:10.98788+00
cd2426ee-cb0c-46ed-bdb3-bc46c54b4790	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	675c3505-b139-4155-a162-13f7bcf9c5bb	1	199.72	2025-09-25 04:45:10.98788+00
4b6e04c0-e295-4c86-9e6f-ee8f8ad250a3	1112f024-0107-432c-ad8b-7f9ce6c17f15	2d8a95df-f61e-470b-bc89-6f0d712c896b	2	173.74	2025-09-25 04:45:10.98788+00
33707f9e-be8e-4523-b628-40949cb16562	59893b10-830f-45ae-ac1f-450959f712b3	01fb9db6-a7be-48f5-b979-43865947ef42	5	310.85	2025-09-25 04:45:10.98788+00
6df8b175-3629-41be-a51c-4cb2a35da6c2	b44c9ec4-a6be-4749-bf87-a6b12b9fa08d	627279d7-1ca7-47ca-9af8-06b27bff9d10	2	286.74	2025-09-25 04:45:10.98788+00
adbe08f1-c7b7-4997-9f3b-bc93c460704a	b4f566c2-f04f-40f7-b853-308708b8c173	2c6361bf-9542-4b38-b6dd-fc0720e4bc65	4	325.90	2025-09-25 04:45:10.98788+00
73eb5065-6300-42b7-8fe5-a06b73931d15	0d3087db-c025-4035-b7bd-899b8247bcd4	a78bcf16-ef7c-4b5e-a7cc-b77d0c780c2a	1	296.30	2025-09-25 04:45:10.98788+00
e5e47a92-14c7-4f16-8292-05105a38891c	137e01ef-bf96-4a2b-9ed4-c69197e8d93c	c51d890d-f207-44ea-9d04-c039cf3d6dd5	3	109.62	2025-09-25 04:45:10.98788+00
e6710640-43fb-41bf-977d-0044d09bb990	16147c77-08e8-44da-87a5-8d30d54115fb	99cbee9d-abd8-48fc-a7a9-1dd7ceb5a94e	5	218.93	2025-09-25 04:45:10.98788+00
05210ebb-814c-46af-a120-bf98d27297c4	dde289e8-65f3-48d7-81b9-fb0cfc69583c	8d6905a1-7ef7-4e8a-bf52-59493aa817f8	5	444.50	2025-09-25 04:45:10.98788+00
75eed6b9-1494-4430-a91d-2af1a553c955	5eeea7cb-6bdf-405b-9708-8191fc4424b5	dc995feb-0c4b-46dd-83ee-bedda7f27956	2	233.76	2025-09-25 04:45:10.98788+00
fd623e09-3af5-412c-bc15-bcfdcccd8fd9	c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	36131294-16e8-40fa-94f5-5fcc003336f8	1	84.47	2025-09-25 04:45:10.98788+00
97eee396-4577-427f-bcde-86d69fdda027	eaccc436-9b93-4748-bf78-de7e26546665	32438594-d5e2-4e96-964d-6b747e805315	5	393.95	2025-09-25 04:45:10.98788+00
96f25442-dd09-4d11-86b5-aea8260a2baa	4c168f8e-9007-4772-959b-d039729ead3c	685e0f0a-4d1e-4ea9-8a74-58f6156117b6	5	32.14	2025-09-25 04:45:10.98788+00
6e7748fb-cac3-476c-856f-e2ca804f0092	af23ff0a-f05e-4a77-a6e8-747d1aac6b18	fd91f3dc-8855-4ec0-882a-a26e8ccc83a7	2	177.94	2025-09-25 04:45:10.98788+00
2f7ecd38-5f24-42b1-bf87-a76faea6120c	97d16adc-06c5-4662-b6b4-631198caed60	0ddcc716-22b8-4b71-8deb-24ad5844df78	5	51.30	2025-09-25 04:45:10.98788+00
5e96fa5f-31a3-43c9-b32e-1adfdeb26dd7	32ac1773-f123-4af8-ad67-bf7d7d2df925	f4429a7d-1708-4564-afa1-873cc4345c03	2	345.94	2025-09-25 04:45:10.98788+00
91ae6dd1-503d-4404-a46e-0c9ad1d82799	c21b52f0-431a-4470-a6f7-4b44be6d4c9e	b40df738-023f-45b3-8b08-7f8f9f66f600	4	298.68	2025-09-25 04:45:10.98788+00
7551eaf8-48b0-42e1-a04a-a3ccee796cc4	9c2f5e1d-1c89-4a70-8825-64f52270320f	736e608f-f545-4d28-9da1-146cc3444701	3	186.82	2025-09-25 04:45:10.98788+00
e1adf634-457a-45a6-98a8-4007c0ecb001	f1c21b5c-0aa3-4999-ac25-c8b15ccafad2	7e28a8eb-e0a0-4fcd-9432-4a4142b93364	3	379.04	2025-09-25 04:45:10.98788+00
fb5fe1f5-62ff-4a9e-bb7e-d27486b8c116	bceef424-4b29-47c2-8409-f5b9897e681c	ff7620ed-ed9a-4893-9cd1-10e78696e6c4	2	260.10	2025-09-25 04:45:10.98788+00
25b5842c-f16e-43c0-92ef-ee48f3838ca6	e11e7ed0-f84b-43f0-9471-49694b423953	aac955c0-cf83-4bc5-9707-2cbc8cd5fde3	4	352.47	2025-09-25 04:45:10.98788+00
54e39ddf-fd82-4986-9194-a343ca241807	da954279-0735-46cb-96c6-6b725726f5ac	8f1f4898-74f0-41a2-907a-0e82e0cb2ed6	2	76.52	2025-09-25 04:45:10.98788+00
53018c32-3ec3-4bfa-b7cc-f82980e6c384	b3aab42c-57e3-4688-b683-3f401362cc95	e07fe63a-e903-4360-852d-300a8cd9e1db	5	221.30	2025-09-25 04:45:10.98788+00
424d8870-7257-4c84-bab0-115cb589896e	3f0d00bf-dd48-4b8e-8fc6-bc3ed8c28d0e	a274c297-8cdc-401d-aa87-4c61971c6730	1	317.81	2025-09-25 04:45:10.98788+00
0609533e-f6be-4b1e-9331-e0ef1803be81	58732d14-1087-42df-88a1-891062e59216	b0636ba5-8172-44fa-814e-56fd191ed72c	1	216.53	2025-09-25 04:45:10.98788+00
ba0371a9-3fdb-4126-b8ce-a05590eac2d2	340d285d-b98b-454b-b371-ac1d89d58318	bffea342-f08c-4cd3-9343-b093e9437b44	1	237.86	2025-09-25 04:45:10.98788+00
6d3cdc00-4abd-4d75-b9cc-9fa7a02899f9	948cc5b6-87b2-4ce6-9dda-289c7563bc38	74baed34-5bd9-4797-ba16-64c96ea776f4	2	446.39	2025-09-25 04:45:10.98788+00
3a9e545f-1592-4419-8d2c-35937e1fc4ce	9c2f5e1d-1c89-4a70-8825-64f52270320f	a009fa16-adc5-4dff-aef0-33eab2015e8e	5	488.95	2025-09-25 04:45:10.98788+00
3411e793-2a1e-42a2-97e3-c9e5bf8b9abc	616743a4-8c7f-4bdc-9b58-3e546b2bc63a	ce542f08-c868-478f-bde6-5e5db60c20ab	4	260.26	2025-09-25 04:45:10.98788+00
dd285946-a719-4228-910a-8a25c7fe370e	24a95a0d-6617-4dd2-976f-8bf79ff0e903	58d8e644-eeec-4506-a7b2-397b94088d39	1	261.08	2025-09-25 04:45:10.98788+00
9f26fea5-06f2-49b4-9615-bad9647459e3	426b8444-2d7d-4280-87b1-1027ff285c10	4e310021-e795-48f8-95f0-c106494cb015	5	123.42	2025-09-25 04:45:10.98788+00
1db4d971-1f11-4c19-a5c2-0a6f359aee96	486d0262-fa5b-4a73-8fe7-29ef1b57e731	2cd83dca-d805-467d-a87e-1472adf2f656	5	272.59	2025-09-25 04:45:10.98788+00
3fa2f069-5d98-4c7b-9a8b-bb4be7e34ad5	3ac2a44e-2d7e-4aac-848a-52a503161e85	9d108fa9-0eda-4747-847c-2557ebd3e468	5	47.76	2025-09-25 04:45:10.98788+00
cb96d3f7-ae4e-489e-9e79-42a6638ffcf2	696828dc-8af1-4e10-a1b1-85d38f508324	d8e8cf41-1f50-44d6-be1b-753f999a5fbf	2	381.58	2025-09-25 04:45:10.98788+00
8d9f138a-644a-44ec-8836-c0a1ae0a25e4	7b507156-3da2-4384-9c0f-5d53f3922b7a	af2a2d7d-edb0-49b2-ad2a-dfb0d68b822e	1	426.41	2025-09-25 04:45:10.98788+00
c6aabd8a-b185-410d-9a0b-61d996cacdf3	76dfa88b-3479-4d45-87ef-c3922d07a9fe	16caef05-933e-4d78-9ef0-33da5b9f38a0	5	212.26	2025-09-25 04:45:10.98788+00
023dab4d-b918-4f72-bde2-a1e77c05c590	9f244e1c-9b85-4e5f-826f-ef37efe2ad1b	42efecc1-d272-4b66-8b03-4dd82b43ef1c	1	227.44	2025-09-25 04:45:10.98788+00
72694440-48bb-47f1-8866-9ee6b8291e3a	9950f002-d400-4835-97fe-97a61c858a79	0dd1f0be-83c6-4475-b0ad-e139e2fd6562	3	21.08	2025-09-25 04:45:10.98788+00
dae297b4-85b3-4b08-95af-22a60e72360c	4563b92f-05ed-47bd-b381-63564b3df8cd	3a7f861c-b3cc-4086-9e7f-40b7e0e4e2cd	3	498.89	2025-09-25 04:45:10.98788+00
c5c70729-6d43-4658-b747-b1495ca7f80b	3ea59b35-95d6-42fc-8d26-061897e4d2a8	aebf681c-0b04-4393-b847-9142c6e33b9c	3	444.19	2025-09-25 04:45:10.98788+00
41fd6b6b-fa42-4453-b090-06215efca260	4022498b-124e-4e7f-a690-5c227b7ab3c1	66f52fb0-6075-4cf9-b884-caf6c6b13e66	5	7.02	2025-09-25 04:45:10.98788+00
a05cbe06-66de-4519-ad7b-568fec20778c	92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	4ed917e1-6310-41bd-b1f0-4513a3b8c1f8	4	344.46	2025-09-25 04:45:10.98788+00
fc160509-4ffc-4e9f-8bad-7918f14705f6	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	7977b6a4-2f51-462e-b730-66f18785dbdb	5	433.04	2025-09-25 04:45:10.98788+00
9506cf2c-6fff-4fa3-859a-5438171dcccf	df8d6ba7-5a0d-4ceb-961e-e687721e7c20	d0568fad-6695-41ab-b16c-fc9c47ccc21f	5	391.82	2025-09-25 04:45:10.98788+00
b3ec69c1-8940-42d4-84bd-d48ce3d2bf42	68251dab-f3ed-487c-89d2-3bb3ce61cb51	705a8ddf-88f4-4ace-8cac-384c51b77125	2	380.59	2025-09-25 04:45:10.98788+00
02d1cb48-3aeb-4f35-99c8-ff30aae7f234	654b1ef3-ade0-4ed9-854b-2a1172e403e7	a6381a31-5faf-49d1-b719-8c27719667d3	2	151.89	2025-09-25 04:45:10.98788+00
a2ec948e-5ba9-4e44-8d60-4ad6b886d7ae	4e0fc028-5900-4a70-8e05-35ee95745e2e	9e343fbe-d188-43c7-aae5-034b69c48952	2	400.71	2025-09-25 04:45:10.98788+00
92cc5f9f-b985-4e19-b308-51550ec7a3f0	b44c9ec4-a6be-4749-bf87-a6b12b9fa08d	21f89511-0b73-453d-90e5-5259485a5afe	2	254.80	2025-09-25 04:45:10.98788+00
d39ba752-f28e-4a84-bb6c-4d1f0d8b4453	ab57d331-2736-4ca5-9326-3ee0f948c949	7a8bc5cc-632d-45d0-8549-66fe93475acc	5	312.04	2025-09-25 04:45:10.98788+00
24c8b2db-994e-4be1-aaa1-e835082db8cf	4d8f677a-8f36-4f7a-ae53-ebd59735d505	a2f14642-a908-451a-b35b-214b4726122b	4	93.74	2025-09-25 04:45:10.98788+00
388bbfac-2a3b-4569-88dd-2ccbaff576cc	aa571a5a-d2c2-4cfd-b214-badd309a7bce	aac955c0-cf83-4bc5-9707-2cbc8cd5fde3	3	81.27	2025-09-25 04:45:10.98788+00
57639cbd-100f-4787-8663-efc432bce975	8a1fd9fc-2380-47e4-8d86-828b7d36b208	c57dcd86-44c2-475c-a8e2-8fa7ce846554	5	206.81	2025-09-25 04:45:10.98788+00
dcdbd9f5-c7e1-4583-8e36-435deca22b40	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	2	424.31	2025-09-25 04:45:10.98788+00
aea9abc2-3787-4981-abbc-b6fb97d0581a	190dc437-aabb-400c-843c-7ab83c64dae0	94d5fd54-f886-4df1-afe2-7840ea858b5a	4	257.25	2025-09-25 04:45:10.98788+00
8f7f72c0-01b7-4025-8152-37b2992d1dc8	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	82eb95f2-6558-4fcc-b9ce-abdb673d000b	1	373.84	2025-09-25 04:45:10.98788+00
c04f24cf-844c-46c6-937c-039d36cd8b38	ef4fce6c-c216-4bf3-a10a-15d6bce77f94	7d3d4da1-e551-44f6-8f50-c062c0e368a4	2	188.44	2025-09-25 04:45:10.98788+00
e82e7448-ef77-4800-9391-cad02b23bb4e	bba69bcd-4eee-40b5-aa14-769a0d5f71b9	aac955c0-cf83-4bc5-9707-2cbc8cd5fde3	5	449.97	2025-09-25 04:45:10.98788+00
5b2907cb-4ae1-4186-843d-7e46f868063e	16147c77-08e8-44da-87a5-8d30d54115fb	db6614a2-13de-4516-aac9-870bb9ab87f3	2	122.99	2025-09-25 04:45:10.98788+00
a5eaae7d-0999-4a7b-ab11-af5e34e11874	a37b9b0b-eec6-4fcd-89ad-c3f8d00e5983	58d8e644-eeec-4506-a7b2-397b94088d39	3	346.65	2025-09-25 04:45:10.98788+00
89e369a6-9a0f-4321-b64a-83f9fa82d8c1	c2a37430-7f62-4c51-88f2-25655b1f982a	76d7548b-f723-4eda-883a-1b35e77a8718	3	69.35	2025-09-25 04:45:10.98788+00
c896a4c0-f028-471a-9b8f-9c76eaa98e77	5b807691-609a-46a0-83e9-4cebbe15a46f	d82a8dd3-a1f1-42a5-9f01-033cb4a480b0	3	340.37	2025-09-25 04:45:10.98788+00
e4767b18-54f4-4bea-89f0-73a22e9192ad	525e96b1-c61a-49d0-ab04-1603c0ab49fc	bbd343e0-6245-4cd0-965c-0993381a2d72	1	363.93	2025-09-25 04:45:10.98788+00
7a6659d4-d7d4-40f0-9cd9-3419fe7aa064	643042eb-8aa7-4861-b2d8-ea84a8985a0e	52c74d64-e26d-46eb-8767-29af802ecfd4	2	269.78	2025-09-25 04:45:10.98788+00
82f47449-eeff-4f19-b5fb-76ceae54146e	fac46dd0-4c20-4fd2-a743-dde035ca9d5b	280697f2-83ef-479f-a96a-fefcd055b0be	3	20.96	2025-09-25 04:45:10.98788+00
42e58de0-ec25-4685-a56d-1e667949790e	52b2eafb-4738-46ad-bd12-3d59ff910c03	f3c60162-6f84-46c1-8a02-a4e9649cfc51	1	50.56	2025-09-25 04:45:10.98788+00
534abfda-61ac-40d2-be54-c21abf83b61e	53b43699-f881-46ea-9196-733d65a9f7f6	827e4ef4-056e-4a4e-a7b0-dadd7aa95d4a	2	101.50	2025-09-25 04:45:10.98788+00
e1c837f0-5382-44a9-b6c3-2d6eaa28e013	b3675589-9b4e-45e4-9c7d-8b116c83f0c2	c81e40cb-91b9-413b-9af0-c52b27eebc22	4	214.00	2025-09-25 04:45:10.98788+00
1583dcd3-fe57-42be-872f-d12eefa476e2	76dfa88b-3479-4d45-87ef-c3922d07a9fe	52885168-97b2-4e13-93f8-92bd9dad7faa	1	233.02	2025-09-25 04:45:10.98788+00
21f22534-8acc-4f73-9df1-19a1335affa6	c2ef5dbb-e7b5-4988-bf2d-ff91ecace787	65ba3a06-90af-4b70-950b-a7f249aa72e1	2	128.23	2025-09-25 04:45:10.98788+00
e532a45d-d2cf-4815-b967-df5c391ec7e0	9950f002-d400-4835-97fe-97a61c858a79	f5531274-e84d-4232-8062-8f89904b0a9a	2	14.10	2025-09-25 04:45:10.98788+00
715e5ec2-31d5-4049-b986-a9c9cd669aee	4ed80603-7451-47ea-a4f0-cf51d43831b5	8d6905a1-7ef7-4e8a-bf52-59493aa817f8	3	458.14	2025-09-25 04:45:10.98788+00
1a72c4da-b1e8-4897-b767-c70b81e98997	b5e7ba07-b6b5-40ad-bf4d-22815c5079a8	48776d48-3d14-4b31-a4bb-e8adc2d07748	1	190.43	2025-09-25 04:45:10.98788+00
dff8379b-3444-48aa-8a4f-62cf60e0ba05	2e6c84e3-29ac-4202-a0c5-96b9b1861228	9e343fbe-d188-43c7-aae5-034b69c48952	2	182.62	2025-09-25 04:45:10.98788+00
12b3016c-2320-420e-a154-f2fc6b825b7e	09932be4-6bb9-4ebd-a2d2-2fbfb32d308a	0ddcc716-22b8-4b71-8deb-24ad5844df78	4	156.70	2025-09-25 04:45:10.98788+00
2b6f051e-8d28-4016-bc4e-e96195bdbded	ac240e7d-0011-4233-8958-dc5c19352f3b	94ba21a1-56ff-425e-98e3-f431f832566a	3	340.28	2025-09-25 04:45:10.98788+00
87b82912-a574-47e4-aeae-5fbdca2b434a	4a4a14f2-0024-4c6b-8825-a0f0b4e27adf	cf7c0140-d018-41ed-b1f3-d84978d66add	4	242.40	2025-09-25 04:45:10.98788+00
9d60f1dc-744e-4033-8632-8c96d51b5f00	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	fd22ea45-0b26-4d83-9d24-0c09ae8e9a98	5	480.17	2025-09-25 04:45:10.98788+00
e3b65de9-742a-4ffa-bd8a-c8baa4596e02	9b45b796-bb7f-443d-bb83-ab9e99fbc9e2	c242c336-4820-418f-b8c8-c1069bd15327	4	112.28	2025-09-25 04:45:10.98788+00
c188b7b6-3e8e-4014-8b26-d1ae82996204	f68538d9-d585-415e-a966-1e4879e673f6	c42aa557-2ac3-4c8b-b680-45467d38a8ab	3	270.27	2025-09-25 04:45:10.98788+00
7577ecee-0319-4b65-9239-ca1708af22f6	3ec83e75-3a39-4fa9-a28d-02fb91767b3a	f6831c4d-01a8-4471-ac47-b4de6fd26c34	5	313.91	2025-09-25 04:45:10.98788+00
8564a7f8-cc0d-4cf2-91a1-32a3fccd61b4	486d0262-fa5b-4a73-8fe7-29ef1b57e731	301b960f-1b4f-4759-9bb5-5f294838f218	3	381.85	2025-09-25 04:45:10.98788+00
639dc96e-28f8-409f-a46b-cb3cd1b674cb	1546f566-2571-4c5f-8f78-6bba8e0afe9f	8bee181e-b313-4a84-8105-46e07f0cf824	5	292.60	2025-09-25 04:45:10.98788+00
cadcb8f0-f15c-4dbb-b31b-f1b5f318ccf5	7fec9c60-97d1-40ff-af2d-af0f6c31f8a7	16c44ce4-e115-4b39-b307-78c786711eb1	4	34.07	2025-09-25 04:45:10.98788+00
33de851f-008f-4fec-aa61-cfe8f5143b9c	346bd78e-f7c1-4da6-afcc-8cb304916ecf	a256562c-e11f-41d1-baaa-282749528770	2	415.56	2025-09-25 04:45:10.98788+00
96c784de-e7da-4d11-a87a-6f4b38da269c	0acee6b5-430a-464b-97ba-9e6e9f750cee	a1a72c5c-cc81-4a56-bac4-1faf14818022	3	391.63	2025-09-25 04:45:10.98788+00
083b14bf-87ca-4c37-a4ae-e87d9fb40584	84a0b61f-5665-4166-9a16-016ce275479b	a2f14642-a908-451a-b35b-214b4726122b	3	209.32	2025-09-25 04:45:10.98788+00
59266aa9-2f8a-45fa-aefd-62d9f2c40e8d	b771a9e0-f6ad-4817-8a83-791d3b689769	3b876e1c-0a67-4b21-b70f-910f190ea31b	1	254.19	2025-09-25 04:45:10.98788+00
639ad791-1759-4fd1-b338-854bc347aec1	3ec83e75-3a39-4fa9-a28d-02fb91767b3a	75a131a4-f92c-4efe-ae1b-e8ec24c6de21	1	164.45	2025-09-25 04:45:10.98788+00
391cefb4-c28e-4547-a15b-2ca07d093e48	59d3ce40-a157-4ff2-9d4c-bcf6c0a21116	d41c2e97-0aa8-4cde-a49a-97dbbdbdaeca	2	188.96	2025-09-25 04:45:10.98788+00
a370a4d7-1342-4838-9a0f-838835f94a19	a8429b46-b30d-452c-b54a-838f80af17f5	4b3c92b2-b064-45a3-9566-c963f4492abf	2	37.80	2025-09-25 04:45:10.98788+00
a8209ac8-cc5f-401f-8a24-a74f3c72f14c	019ea4d1-14af-409d-89ee-fbf3c80454d7	9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	3	18.70	2025-09-25 04:45:10.98788+00
94ca8d07-d848-4e05-a905-d91e17d40594	2852a240-9b4d-432d-ac95-443b5b17ae34	0a866c4a-8b4b-407b-9eee-d41b65767b6a	2	75.85	2025-09-25 04:45:10.98788+00
0e899ec3-b8a9-4208-88a4-ad704c04c291	98deafff-495a-4fc8-bf3e-5f7961607766	280697f2-83ef-479f-a96a-fefcd055b0be	4	338.17	2025-09-25 04:45:10.98788+00
13429820-dc12-44ce-8d05-3183c084ea03	1bd0dd4c-aaca-4794-8e97-b74ba449fd35	4f33627f-1c0d-4385-b95c-5c2ca24792ad	2	195.44	2025-09-25 04:45:10.98788+00
90808e6b-3086-4c73-99c3-5cf1f0d521b3	86d84a87-7753-4a61-8dc5-ecec33b095f2	5253556c-057f-483c-9381-f6af86bde287	3	291.43	2025-09-25 04:45:10.98788+00
0edc449a-3566-4d01-b059-bf00023cbee2	ab57d331-2736-4ca5-9326-3ee0f948c949	16caef05-933e-4d78-9ef0-33da5b9f38a0	4	488.53	2025-09-25 04:45:10.98788+00
b342de19-e258-4591-87d1-5eb0ed0266d3	8a1fd9fc-2380-47e4-8d86-828b7d36b208	bacacba7-76a9-4d09-ab72-f08a18504d23	1	372.25	2025-09-25 04:45:10.98788+00
905ac71f-6554-44b4-ab07-5d96ffe66da9	5a475899-b907-47a0-9b74-d7a44c28c45d	e033ca53-db4f-42b9-b50b-1bcb17480a5d	5	481.70	2025-09-25 04:45:10.98788+00
c24db560-8a6a-460a-960c-a1c43f538cd6	24a95a0d-6617-4dd2-976f-8bf79ff0e903	78b46b2a-8550-405c-88b0-e2619b3d095a	5	60.38	2025-09-25 04:45:10.98788+00
16ff4980-3e00-44e0-85ea-0eecc5d7886a	8c30775c-7387-485e-a1e3-b48311e93820	c20bb299-4a8b-49fa-b2a5-09b6309c23d4	1	292.21	2025-09-25 04:45:10.98788+00
a69cd180-e6ee-4f3c-94e1-349e93b5a435	9fac23ce-78e4-4547-9122-f8aa6edcc971	06c36a48-6057-499b-879a-97246326daf0	2	148.39	2025-09-25 04:45:10.98788+00
16316ff4-ec71-4e21-81bf-f39a79632a38	ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	c2f4dd5d-7020-46bd-bea6-2865a22a579f	2	152.54	2025-09-25 04:45:10.98788+00
4e38286e-9fe2-4918-8b3e-e30d40b81810	8582c426-c826-42e9-88c8-217c96b432de	08de722c-d87c-4a2a-938d-ede6bc53253c	2	299.94	2025-09-25 04:45:10.98788+00
7b45a20d-f3ee-40db-bce3-fccdfb80e904	4a921fd4-12af-44d6-a149-53dc0eca642c	db8f731a-a258-4ac2-b1c5-477635ea3457	4	53.78	2025-09-25 04:45:10.98788+00
64c2e485-a087-4d47-9fcd-4ad9e985510c	f548ae40-f469-4a98-9ab4-36bbb21b38ee	1c2e1ad8-af4a-43b2-9a7d-2f46905eb890	2	384.99	2025-09-25 04:45:10.98788+00
4c300cef-4c6f-4f98-a28f-35fed4b99773	be27466b-77cb-4dea-9f69-0d9bdcf5bf92	caa6bc73-fb21-4bad-8f74-611730b8ed99	5	242.56	2025-09-25 04:45:10.98788+00
4bd0da87-ac18-4ea5-84d0-243cb1a5f4d3	dfdd0300-e01c-45ca-bd58-194ef077debc	36cff3c5-18e8-4acd-8284-f7a49f6a72a2	1	34.21	2025-09-25 04:45:10.98788+00
69a36305-f92f-48d7-8f91-6a7b6f121f02	e11e7ed0-f84b-43f0-9471-49694b423953	66117f6a-f75b-4b99-9dd8-e4bd3e671b17	1	364.66	2025-09-25 04:45:10.98788+00
e9e85d00-58de-4b80-b045-d3b45be28fe4	4c168f8e-9007-4772-959b-d039729ead3c	f0c4f875-9bb2-49b1-a2a0-ab918196c5a2	2	475.04	2025-09-25 04:45:10.98788+00
2e392d45-b088-4be7-a976-a62adf62df7c	5fbfff3d-7b8d-4de0-8cf7-2aede26c6ebc	52c74d64-e26d-46eb-8767-29af802ecfd4	3	323.97	2025-09-25 04:45:10.98788+00
84ec7642-5746-4a51-b9df-e8a63b39fe53	87758a86-90a7-4859-8155-e3cdc49e8703	4d9c2197-b188-4cc2-9d32-90c74001a4f5	5	251.40	2025-09-25 04:45:10.98788+00
417f59a5-dd08-4eca-b6ea-2aa3b3b59871	2d9d678e-0fee-44c3-a911-351552bd549b	99b4888e-0ed2-4039-9423-661b9705cc63	2	383.98	2025-09-25 04:45:10.98788+00
385aafed-8a46-4d7a-93e9-c968506f52ed	58bb516e-b6ea-434a-a215-e28baf801d47	e715cd7f-f67b-45c2-9d9e-ab1c534f2827	2	458.96	2025-09-25 04:45:10.98788+00
b146cb56-2a1c-4422-aeda-4ebf418a0de3	5063566c-73a5-49b2-9179-c966531ec333	ff45506a-c74c-4d5f-adf6-690a5e0c3b68	2	425.04	2025-09-25 04:45:10.98788+00
86432fe9-109d-4aec-8577-c39303217c47	a2d37279-1651-47c9-8964-bc58ba2f7766	231463d4-4a25-4c91-97eb-a4d51817addd	4	289.51	2025-09-25 04:45:10.98788+00
6a4d3b19-19e1-469f-b9e5-246d3663c516	8f61c253-3137-406f-9f23-1cec641712bc	4f82b81d-f611-449e-b94e-b4b9ea1329ee	3	408.27	2025-09-25 04:45:10.98788+00
334ee636-99c9-4b1e-9b0a-0a357ccca6b7	525d8bea-4e85-468b-b517-b93f48a3ba36	cd6571a9-241c-4ed0-9d0e-e22f63583e41	4	327.68	2025-09-25 04:45:10.98788+00
fdb76cf6-963a-42eb-a08a-dff3cb04635a	55f039e3-7cba-43cb-a899-44f7c7649d77	0f37ed0b-4210-42e3-849f-4ea529319e73	3	367.87	2025-09-25 04:45:10.98788+00
64672f60-e329-41a4-a3d5-6789f18e6c94	e78e96a0-29bf-41e7-82ca-37191ebe6682	687e4d57-6081-4e35-b469-4fa2d93cf1bc	4	104.62	2025-09-25 04:45:10.98788+00
229b7684-7524-4e16-b23f-51e7679f4312	a2d37279-1651-47c9-8964-bc58ba2f7766	752a4864-78f6-4f0a-a899-2df7627aaac1	2	481.33	2025-09-25 04:45:10.98788+00
d3c65dbf-6599-4122-a2f0-cf50b5696dd9	340d285d-b98b-454b-b371-ac1d89d58318	c0e03395-6d27-423d-a275-ba997b04c267	4	497.23	2025-09-25 04:45:10.98788+00
18ec789e-b525-4916-bb30-35935b56f07e	ea2d8bd2-3631-443f-821f-7e6c24e43857	aedd1f54-9ef8-4bae-8650-8be25187046a	3	13.73	2025-09-25 04:45:10.98788+00
c705040e-314f-4e5b-b52d-16b92bf47b28	b3675589-9b4e-45e4-9c7d-8b116c83f0c2	e551bf7e-0257-4ff9-9c5e-c601a29787d1	2	465.14	2025-09-25 04:45:10.98788+00
12c1617b-3667-4bac-b063-4706fc62dddb	9b71b1b1-9175-4e94-8df5-8d99337039f3	e257c30c-24bd-4f7f-ac74-04e3fb863198	2	68.54	2025-09-25 04:45:10.98788+00
36a24dbc-dabb-49b7-92d1-f2f2e757638e	51e85022-111e-4b2f-b141-76d0042ab084	ac9cef94-2751-4f36-9abd-43e045341268	5	196.28	2025-09-25 04:45:10.98788+00
a9c7eaf3-a1ec-43a7-a67a-e0e48d1f52d1	16147c77-08e8-44da-87a5-8d30d54115fb	2bf3df4a-c939-46eb-b584-d52d8b3e1570	3	459.58	2025-09-25 04:45:10.98788+00
58644e8d-5143-4b91-99ed-b031498c141e	2e6c84e3-29ac-4202-a0c5-96b9b1861228	a067a03d-fb3d-4178-986f-3f263a72104f	2	323.41	2025-09-25 04:45:10.98788+00
46b734d3-663f-47cb-8cd7-66c3e4a879c2	ae75b3b4-b870-4754-8880-04e837237db9	096acccc-845a-4f8c-a4c9-4c2ee83dfce4	2	92.86	2025-09-25 04:45:10.98788+00
19a3a4e7-416a-45e9-977f-0ed0c14e3db6	84a0b61f-5665-4166-9a16-016ce275479b	d888f1e9-3e03-4db5-93c2-1f6ae57cb63e	2	202.34	2025-09-25 04:45:10.98788+00
5f1b02e6-2059-4783-acd3-d78caf8f5291	08607ad3-480a-4945-a934-b96d6ea030fd	a7357a6b-eb1f-4536-be65-b678cb076d9f	4	327.20	2025-09-25 04:45:10.98788+00
b8064d3b-3017-4611-a5c5-0a5d10fee1cd	f3c939eb-8f61-49d5-916e-da09ef3fcf4e	e747d9f5-9165-4d7f-a824-2539a1a64b08	5	191.98	2025-09-25 04:45:10.98788+00
bd11d2fe-9073-43e2-a192-181dd623ae63	4462b016-e0b0-4540-9d60-2887e9a5767f	6fb7b197-4beb-4c50-ad29-bc14326db41e	2	35.64	2025-09-25 04:45:10.98788+00
e2f5a6e2-3774-4c21-b8ff-efa3b1096f3e	d69ac389-3833-4684-8f50-5a7e9e00ffda	16c44ce4-e115-4b39-b307-78c786711eb1	5	334.48	2025-09-25 04:45:10.98788+00
caa05015-d55d-4272-ad8b-4452d0f008e5	df8d6ba7-5a0d-4ceb-961e-e687721e7c20	e75a724b-b522-47e9-8475-f8f74181c1c6	4	288.46	2025-09-25 04:45:10.98788+00
ef0c8a94-c61b-43b3-a1a0-7e26d99284cc	22e7a462-e53f-4048-8819-df1c202a992a	e7d7d5bd-c4a0-4990-affc-79d875c9bf9f	5	465.53	2025-09-25 04:45:10.98788+00
62d4f69b-9e73-434f-982d-bb7fff03aa70	833ed813-6177-423d-9903-87634724c195	6559c77c-2a53-4b45-bc03-e0c7a3f2848c	5	74.63	2025-09-25 04:45:10.98788+00
ee121816-9680-4084-a752-d0b98ecd3f72	9950f002-d400-4835-97fe-97a61c858a79	d8e8cf41-1f50-44d6-be1b-753f999a5fbf	5	345.65	2025-09-25 04:45:10.98788+00
1a46e4aa-296d-4793-ae41-27299ac97635	eaccc436-9b93-4748-bf78-de7e26546665	b6c39710-4549-4a52-8cb2-8ab76552fa1e	4	484.26	2025-09-25 04:45:10.98788+00
d8c80b6e-e528-4776-8025-b9bbaa86d8df	f6a00ade-1778-4516-955f-dc8933a5c3cb	f686b3d5-1fce-4c27-91a8-3bd4b6ac3e6a	2	450.99	2025-09-25 04:45:10.98788+00
39ce789e-4fe5-4489-83af-73215ff9766c	0af99923-2595-4550-b08b-94209f0a6342	6ad019da-5023-4083-b0c1-193ed3bec8f1	1	172.24	2025-09-25 04:45:10.98788+00
a530e591-d0d7-4a6b-9a69-adb510cf2a94	c2a37430-7f62-4c51-88f2-25655b1f982a	59d81ac5-ff64-479e-9e48-d294dfeeab56	2	137.16	2025-09-25 04:45:10.98788+00
c418ad06-4359-469d-bfef-39ea1455a05a	08d6ac3f-89dc-42dd-81eb-30cfcced5621	4117ed09-68b5-4cfe-aed2-7e4d8e1b0f12	2	252.20	2025-09-25 04:45:10.98788+00
b74aeef1-cdd4-48cb-b613-61a07c24a7cd	525d8bea-4e85-468b-b517-b93f48a3ba36	2ab41804-1215-4425-8038-eb4dc53c2b58	3	127.26	2025-09-25 04:45:10.98788+00
1171ac50-4830-4448-b66c-7b8095fe4007	38e69936-c671-423e-96bd-150fdc01b57c	f96ccd19-1c60-4ae7-8fea-23ef4ab7894c	3	20.01	2025-09-25 04:45:10.98788+00
dc1ceb79-e8cf-49d6-9504-21e55f8b8049	e4e5df46-295e-44cd-a7ce-bfd92050529d	5cd9a9a1-f212-4606-af53-fca25dd3080e	5	266.88	2025-09-25 04:45:10.98788+00
eb9b8579-9c72-48c5-b6f4-69670fbca00a	30285572-1976-472b-97a9-c6d411bb8d0c	75423bf9-9773-4e43-a7dc-869dd3830e92	4	406.66	2025-09-25 04:45:10.98788+00
83e3297c-c9af-4125-ab03-b1f6a8e5f0ef	da1a2d3f-7a99-4c79-ae23-495545b71b44	e9b4110e-ec56-4506-ba33-e895d567805e	4	83.85	2025-09-25 04:45:10.98788+00
1f0ae2ee-6fc9-4d6f-ab28-2c166c467d20	d68fd55d-4c20-4f1d-9de7-5924e4e30de3	ff7620ed-ed9a-4893-9cd1-10e78696e6c4	5	140.15	2025-09-25 04:45:10.98788+00
a2889317-83a0-46e7-a85e-42f1088e6eaf	237a8e42-b8be-4a34-9107-99c8c32ce353	5aa541f1-2bca-4ec7-bbca-06775a6babb7	3	70.51	2025-09-25 04:45:10.98788+00
a48e0fb5-1a94-4b19-98f6-f1b7c90458a2	b4f566c2-f04f-40f7-b853-308708b8c173	841799a8-7865-4d0f-8067-48fbbd7e5e7e	3	75.91	2025-09-25 04:45:10.98788+00
c1124f16-4b20-4fd3-9377-4a5189db7e83	59893b10-830f-45ae-ac1f-450959f712b3	f686b3d5-1fce-4c27-91a8-3bd4b6ac3e6a	2	38.75	2025-09-25 04:45:10.98788+00
45dce886-3ced-4a99-ad55-8ef5e6fd9c49	dd00c93f-80d8-4575-b3c4-4df3733a2afe	34d2c6d9-e834-4a6b-8969-d25320f48ac2	4	273.72	2025-09-25 04:45:10.98788+00
abb4639c-fdf8-4ffa-beb4-cb8ef31bc7b5	5a475899-b907-47a0-9b74-d7a44c28c45d	07bd80db-59c8-4656-9564-d5f2910712ea	4	163.06	2025-09-25 04:45:10.98788+00
9331427d-9b44-4d7f-8a1d-7765d6767eb9	cffac55d-8d01-4062-80e1-13d4c49696e2	c4d12db2-a825-4a54-a6a2-8d7f1bad5dfd	4	185.21	2025-09-25 04:45:10.98788+00
1e456eb1-7280-4ac1-93bb-35915df355bd	a8429b46-b30d-452c-b54a-838f80af17f5	c0618cb6-0459-483f-a990-6ceb8852d6da	1	384.03	2025-09-25 04:45:10.98788+00
01aa90ae-f344-4177-96ae-fa25230c2e80	223005b3-31fa-485f-b021-606d097d451d	52885168-97b2-4e13-93f8-92bd9dad7faa	3	132.19	2025-09-25 04:45:10.98788+00
76bf6245-3af0-4a24-a729-2042eb144943	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	589f5188-96bc-4404-9cfe-78d6eae50831	3	439.92	2025-09-25 04:45:10.98788+00
da0a7f41-af99-493c-b84d-1363a7e27fb3	f32b1168-47b6-4aa6-8db0-4a813f1f4642	73237e42-2ebf-4f37-9667-c6ccc0b02675	4	340.44	2025-09-25 04:45:10.98788+00
8d93a2d1-c3da-4600-8a1b-a3846dc46b13	45539d45-9787-4efe-a7af-4ccd15da1916	bdcdcd5c-c2b2-47cb-98c8-a12c8bd36fbc	5	105.38	2025-09-25 04:45:10.98788+00
3397f643-77b7-4bdc-b47d-4e0884d79d42	525d8bea-4e85-468b-b517-b93f48a3ba36	5e955770-be3c-4861-a9bd-ce75cf16d612	3	96.42	2025-09-25 04:45:10.98788+00
f0ca4ed4-24f3-4cdd-8c60-39713fae927d	f3c939eb-8f61-49d5-916e-da09ef3fcf4e	a768cfda-4d7b-499e-a7fe-501f68bb8241	4	167.45	2025-09-25 04:45:10.98788+00
57059b3c-7a22-456a-84e3-fd61e0896f9c	09f72230-c54c-451e-b640-69b755f8526c	4f69480a-a24e-445f-be33-571a96e23e13	2	374.09	2025-09-25 04:45:10.98788+00
b64c0b70-88cf-4770-910a-0d3bc88c0c97	682fc0f5-6a01-461f-a358-1eb138eecc40	5835c521-b454-428b-a9ba-bc1b20d8d681	3	455.25	2025-09-25 04:45:10.98788+00
7297448b-0192-4488-9dc9-ed76ce32c1a0	524c4a55-37d7-47c5-af46-c34b7a7f253f	f24f6a07-8c60-46dc-9238-4a71725cb34a	2	83.26	2025-09-25 04:45:10.98788+00
4308d777-0eb8-43a2-a391-d95edc3263d1	b638ee2d-80a6-4ff3-b15f-3ea2dc1e3ac2	a2f14642-a908-451a-b35b-214b4726122b	1	494.22	2025-09-25 04:45:10.98788+00
4c341fc4-542e-4edc-ab8e-1a8738de079e	84215ee9-c6c5-45fd-9a43-7cc76c8bb7f7	4117ed09-68b5-4cfe-aed2-7e4d8e1b0f12	3	381.48	2025-09-25 04:45:10.98788+00
67c08868-d5f4-4a61-8686-96e891de80f1	d68fd55d-4c20-4f1d-9de7-5924e4e30de3	f123ec31-3ce7-408d-87d0-72098804ee24	1	5.58	2025-09-25 04:45:10.98788+00
3df71c7f-5589-4b5e-9c40-5774f8e76c44	9b45b796-bb7f-443d-bb83-ab9e99fbc9e2	4ccc4ba0-062c-4e39-bae5-7c9970cb9945	5	308.91	2025-09-25 04:45:10.98788+00
1a37a9c0-fa41-4a57-84c0-67417ea42a93	bceef424-4b29-47c2-8409-f5b9897e681c	c57dcd86-44c2-475c-a8e2-8fa7ce846554	2	480.30	2025-09-25 04:45:10.98788+00
fc0a2bd2-0790-48ed-bfae-5d520453370f	2092e299-3ede-49dc-baa8-6942bbfbae4c	bae15f80-741c-488a-8c41-d76ab1913368	5	138.32	2025-09-25 04:45:10.98788+00
455c7b71-34ef-42f5-84ec-b8fdd24ee01d	84a0b61f-5665-4166-9a16-016ce275479b	4e60b8c4-f146-4be6-8129-816854b5f830	3	120.60	2025-09-25 04:45:10.98788+00
0c969375-09e4-4041-ad2f-f48529dbf076	87758a86-90a7-4859-8155-e3cdc49e8703	fc6bb273-6c79-4da7-9bbd-902c36847259	3	65.58	2025-09-25 04:45:10.98788+00
4cb35cf5-3d53-4148-831f-25102a54cf55	8b759c5c-7c58-4431-ad99-ac9ba0655a5a	628570d2-cdaf-4cdf-8913-a3c5d230073f	3	460.41	2025-09-25 04:45:10.98788+00
b709ff2e-e278-4816-83d2-d5e994ce2af6	a40eba37-28eb-40a2-b5e7-fc34abc8d3d5	7f72cfc7-633d-4d9f-a31e-e0424be358fb	1	225.34	2025-09-25 04:45:10.98788+00
b0ee981a-13b8-4414-997e-6ec7cc059252	c9f84933-0b22-471e-bae8-cf205690ad63	d55b1e7b-d82c-405f-99bb-267e0d272594	5	26.96	2025-09-25 04:45:10.98788+00
aaa16f49-6fe7-467b-83a8-e9b1ac577ba4	ac240e7d-0011-4233-8958-dc5c19352f3b	449d5f97-315e-4a4e-af32-df159c3391f7	1	97.22	2025-09-25 04:45:10.98788+00
53d8e2f5-23fd-4cd1-8a7c-1ae81e95c9cd	a477e93f-ec62-4192-b72d-237e93649f33	86eb1621-d103-4562-bb6f-0cfe8c9a4421	3	486.04	2025-09-25 04:45:10.98788+00
17dd772a-6d84-4200-b8f0-6548ddec1497	5b0f6a5b-5cda-4e34-b841-92e0f187f042	a6381a31-5faf-49d1-b719-8c27719667d3	5	1.99	2025-09-25 04:45:10.98788+00
c512e9a4-66be-4f51-a7c1-0b382e10640f	4c168f8e-9007-4772-959b-d039729ead3c	caa6bc73-fb21-4bad-8f74-611730b8ed99	2	461.43	2025-09-25 04:45:10.98788+00
893fa4f6-0a4a-4878-a788-d1f4afbf9c37	1186879e-b083-40c7-b51a-d7bf6860b348	f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	3	232.57	2025-09-25 04:45:10.98788+00
d8b83cb0-7759-48d6-b228-810378645695	b3aab42c-57e3-4688-b683-3f401362cc95	5958b536-aaaa-4c7e-baf0-72743dfb953f	5	250.98	2025-09-25 04:45:10.98788+00
10b837f1-6d72-49a2-959a-0a56c2ddf074	58732d14-1087-42df-88a1-891062e59216	13404922-32d4-4b7b-93fe-08f504436a82	1	251.07	2025-09-25 04:45:10.98788+00
fd37faf1-6f0b-4c3e-bcb4-1a27683a9011	5063566c-73a5-49b2-9179-c966531ec333	8ccb0951-19d5-4561-8e69-4c827cc20f60	1	24.49	2025-09-25 04:45:10.98788+00
643bbd18-b53b-4938-af81-3758f8a33874	62b0727d-68b0-41e2-bf76-5411fa41c964	4959ca38-b273-479e-a65f-f1943f0e439f	2	323.27	2025-09-25 04:45:10.98788+00
0afdc3b6-41ad-49cb-a3a1-ec4bb5c8571c	b4f566c2-f04f-40f7-b853-308708b8c173	848831ab-8530-41cf-839b-d9eba748aff7	1	26.67	2025-09-25 04:45:10.98788+00
7f96b7ee-b659-49b5-bc6c-6b7ab26d7e87	16fb54f2-da1c-4d8b-80c6-c3f758af6b8a	6fb7b197-4beb-4c50-ad29-bc14326db41e	2	33.49	2025-09-25 04:45:10.98788+00
28c3bbbb-7e9e-484a-8e20-0bf17f364431	b3675589-9b4e-45e4-9c7d-8b116c83f0c2	628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	5	198.97	2025-09-25 04:45:10.98788+00
7791db1b-1897-4838-affd-04ed50e5292f	68251dab-f3ed-487c-89d2-3bb3ce61cb51	b2df4543-5ce6-47fc-b9d3-38ea3098e39a	4	219.41	2025-09-25 04:45:10.98788+00
addb0141-2558-4f65-8d5a-d3b5fefa76f3	9fb60e99-c303-4b61-99fa-dbabe0298b73	3e34ea2b-557e-430f-b6a2-81f8e4c33dea	1	475.55	2025-09-25 04:45:10.98788+00
67e6b85b-dd6a-496a-9470-67da6d4cec4c	2092e299-3ede-49dc-baa8-6942bbfbae4c	73796226-26fd-4bf4-bf3a-0fe57d1c0765	4	429.03	2025-09-25 04:45:10.98788+00
bdfd8d2b-3720-4beb-8064-a32baf79a9ee	6a97095f-68e7-4605-86ad-ef83593423e8	0262cb3a-42f7-4eb7-89cb-8f5d3372e510	3	1.39	2025-09-25 04:45:10.98788+00
41c0115c-2db3-4336-acb4-01baa865901a	ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	68774402-8cc0-4dfb-bd32-b96048384edc	5	487.09	2025-09-25 04:45:10.98788+00
20a23693-4255-4d08-8f8c-37b8fd9d68b1	9b45b796-bb7f-443d-bb83-ab9e99fbc9e2	b0533cb2-0937-48c8-8e50-6ce525b11874	1	97.83	2025-09-25 04:45:10.98788+00
5d77adff-9f7e-4df7-93d7-658fd980caf4	a40eba37-28eb-40a2-b5e7-fc34abc8d3d5	f6831c4d-01a8-4471-ac47-b4de6fd26c34	4	183.76	2025-09-25 04:45:10.98788+00
91c2ac9f-eaf5-4abe-bbda-b47d101ad50d	36dd238f-16c8-4b6d-805e-0f076a282bc5	0fd70815-cee5-470f-8b7b-37c3fbb1b4fc	1	56.45	2025-09-25 04:45:10.98788+00
8cddc88f-6104-48d6-99df-513535e8486c	5bf7dd46-4047-44bc-9990-7345e0df563a	3f697690-af3d-4376-b1c4-8374dd413173	3	184.69	2025-09-25 04:45:10.98788+00
932fd7d0-939b-40f3-957f-b90bb8353c82	25c1f42e-8be1-44bb-b691-1a5d06a49a76	55913ecd-e237-4052-a117-3551627fa29a	1	446.24	2025-09-25 04:45:10.98788+00
625a598c-a972-408d-9d39-ec34dea9908b	ef4fce6c-c216-4bf3-a10a-15d6bce77f94	af707ecd-ed23-4117-989e-4eeb702dd659	3	483.69	2025-09-25 04:45:10.98788+00
0ec11d7a-4c03-4ad1-ad08-fff8b1e4db69	1112f024-0107-432c-ad8b-7f9ce6c17f15	95062fe6-f332-4c00-9973-cf6230544a8c	3	27.36	2025-09-25 04:45:10.98788+00
694d8316-0efb-49cc-a6ec-ca410d9d8ab1	9f244e1c-9b85-4e5f-826f-ef37efe2ad1b	d4c396bb-72ad-48bc-b57f-ae66c7d8d035	1	182.00	2025-09-25 04:45:10.98788+00
90111ee3-dabc-49d9-addb-daf8d96a9ebf	f035d8f8-e3ca-4fab-9c19-f8dcd1d1013f	d8d4082d-189e-4269-bd4d-b8a3527eaefb	4	350.21	2025-09-25 04:45:10.98788+00
665d4830-4fa5-4724-aeec-2d6598ff1ecf	019ea4d1-14af-409d-89ee-fbf3c80454d7	cd862f44-36df-4ad5-b816-1a941066779c	3	107.38	2025-09-25 04:45:10.98788+00
75a80cd8-3068-4057-aae6-546dadee9701	4e0fc028-5900-4a70-8e05-35ee95745e2e	9d039f27-429a-4d94-95ce-f740a903b200	2	127.20	2025-09-25 04:45:10.98788+00
4997dd38-6e0a-4e8e-b61f-9f86463d1d1e	696828dc-8af1-4e10-a1b1-85d38f508324	b94454e6-f48d-44d2-9e38-6b1df6cd02be	4	173.78	2025-09-25 04:45:10.98788+00
95423f68-ecf5-4cd1-82cd-0a185a0518e4	1186879e-b083-40c7-b51a-d7bf6860b348	436eb316-6fca-43bd-9aa2-345440016680	3	385.98	2025-09-25 04:45:10.98788+00
19fe5b00-6f6f-4e42-b0f8-a2e5a35f9a78	1546f566-2571-4c5f-8f78-6bba8e0afe9f	41f0863c-9837-4832-a26b-d2b73aa5a262	5	119.79	2025-09-25 04:45:10.98788+00
60229f59-7130-4d22-9f24-4eb7db7962b8	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	252cd84f-df50-4c7e-a73f-8f47e7c063e4	3	178.80	2025-09-25 04:45:10.98788+00
92f74de8-abad-4642-9c6a-9eedd0edf054	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	b2c3bbf0-8067-4c0a-8c0d-2cf646c99ee0	2	244.06	2025-09-25 04:45:10.98788+00
b1fc0f52-fb1c-437d-9cb2-f29df7c5421f	2da66b6f-1471-481d-8df6-aece86f2de90	3c796ee1-f3e7-484d-8659-fa9251c5cce2	2	228.31	2025-09-25 04:45:10.98788+00
ff82debe-9c6e-4892-a213-6d0df80c331a	28f7cb6c-a299-4812-bc5a-f10d3e260619	fd48c418-c44d-4293-95bc-1585c54fe71f	2	460.56	2025-09-25 04:45:10.98788+00
b4896afd-6e3c-4a87-9f7e-d2fea3593646	3f0d00bf-dd48-4b8e-8fc6-bc3ed8c28d0e	f36e8299-fc81-49a1-9643-a012f892462f	1	69.90	2025-09-25 04:45:10.98788+00
d36eceb7-4c7d-4635-b9af-93991600ce48	5fbfff3d-7b8d-4de0-8cf7-2aede26c6ebc	316e22ef-56a7-4d64-96c2-70cadb55a1d3	5	221.04	2025-09-25 04:45:10.98788+00
a78b1d29-0f04-40ec-a4f1-aff0a0b37380	30285572-1976-472b-97a9-c6d411bb8d0c	c9fb3074-44be-4f28-a5f0-17cdaf1e5d63	2	29.86	2025-09-25 04:45:10.98788+00
2a662790-c860-468b-8f12-1d1343f8dfcc	52b2eafb-4738-46ad-bd12-3d59ff910c03	69bb44de-94a8-4d30-b00b-0761bd1538e1	1	20.27	2025-09-25 04:45:10.98788+00
7932d717-d748-4bae-a6ce-749befadfa2b	1529758e-e2db-4a59-9475-3ee95437d6c6	02111b10-8e00-43a3-a82a-59b332d3cc77	2	161.77	2025-09-25 04:45:10.98788+00
5fc3cbdb-a16b-4fcc-bc26-f565e776589f	d8c3fbc5-76e6-43eb-9a9d-005674e30afc	db6614a2-13de-4516-aac9-870bb9ab87f3	1	241.72	2025-09-25 04:45:10.98788+00
6842fbc0-6c74-41ae-823d-ee876e8d93be	9950f002-d400-4835-97fe-97a61c858a79	48572d54-e34b-4791-9e17-b95691b67941	5	143.20	2025-09-25 04:45:10.98788+00
685fa780-05d5-4cc0-a48e-325ec0b7f409	22720962-2ff2-444e-8219-348d1d8bd7d5	789cd210-cbd2-46fb-a033-b30fea6e3094	5	231.64	2025-09-25 04:45:10.98788+00
82e9daad-8ceb-4376-999c-fb6b2df0aeaa	e5f30e6c-96b7-42a3-bffc-6d1fc991f36d	e22d5a6e-1385-49b5-837a-daf9c2e25836	4	486.42	2025-09-25 04:45:10.98788+00
6ebfc987-2163-4b3b-b611-335fd4b78e6e	7c190cc8-396b-452c-a86e-9a4b029eaa78	848831ab-8530-41cf-839b-d9eba748aff7	2	447.14	2025-09-25 04:45:10.98788+00
c502a700-9814-43ec-af6c-e91321c0f181	b57a7b71-d56e-413a-a83e-cd07d045446c	e7d7d5bd-c4a0-4990-affc-79d875c9bf9f	2	313.11	2025-09-25 04:45:10.98788+00
fcf7174b-260d-4ada-afaa-e42a5224f2d3	6f88a97d-f175-40d0-b968-273c0dc967f5	5f60a03b-aa48-47e3-8001-58fd01a8c0af	3	333.84	2025-09-25 04:45:10.98788+00
70e0ec22-501b-4a13-8a6c-e9349f839e03	0af99923-2595-4550-b08b-94209f0a6342	a59d762f-97f5-4080-b4f4-9aa9b2b02d36	5	22.14	2025-09-25 04:45:10.98788+00
92094b44-109e-4bef-a4a3-0614793a3477	1112f024-0107-432c-ad8b-7f9ce6c17f15	13404922-32d4-4b7b-93fe-08f504436a82	3	101.49	2025-09-25 04:45:10.98788+00
e2385f1a-0ac3-4894-8f38-78e50600ee78	19645d20-d291-441f-9003-ec78341bad89	7c85c03a-5311-41ce-9f14-f6914502bf68	2	50.30	2025-09-25 04:45:10.98788+00
2dc25516-d595-4d3f-81e0-cf8b3d82df2d	985f818c-1a1a-4d3e-8bef-69164308c435	efa90324-2240-43be-ab36-0a1bc0e32ce2	1	355.09	2025-09-25 04:45:10.98788+00
10db1341-3140-4914-a6b7-2da12cf95a97	137e01ef-bf96-4a2b-9ed4-c69197e8d93c	e85d3e7e-015a-4c9b-98d3-81e76e653386	1	165.48	2025-09-25 04:45:10.98788+00
cd51ea6f-cdce-486d-91b1-30fcbcbf7438	d69ac389-3833-4684-8f50-5a7e9e00ffda	60c95653-221b-4f7b-8e5f-4c1f8eccc11e	4	238.06	2025-09-25 04:45:10.98788+00
098711a2-d8e8-499d-894e-a02b68910d48	b3675589-9b4e-45e4-9c7d-8b116c83f0c2	268710b5-2300-4548-bad1-47513dbf13d0	3	117.59	2025-09-25 04:45:10.98788+00
096d7456-e122-4d64-9951-80db383b9402	223005b3-31fa-485f-b021-606d097d451d	463e721d-3caa-412f-a1e7-78240415f238	3	345.24	2025-09-25 04:45:10.98788+00
7eafbe6c-eeb6-4641-8ca8-5dec16cce7b8	155670e0-b314-4f32-a41e-7f1bd25722de	90f27124-bec5-4f09-9d53-634414404daa	4	413.71	2025-09-25 04:45:10.98788+00
478911fe-92b1-4880-a7d5-66b83235e560	4462b016-e0b0-4540-9d60-2887e9a5767f	3b876e1c-0a67-4b21-b70f-910f190ea31b	3	149.63	2025-09-25 04:45:10.98788+00
28b9f5e3-1fba-4cca-a633-e83a69ffabbc	2e6c84e3-29ac-4202-a0c5-96b9b1861228	e033ca53-db4f-42b9-b50b-1bcb17480a5d	4	205.86	2025-09-25 04:45:10.98788+00
25e78b90-f0e5-4b63-9b12-9893b4232dc5	2da66b6f-1471-481d-8df6-aece86f2de90	24652c3b-5928-4336-9101-22ff1d683c47	4	50.57	2025-09-25 04:45:10.98788+00
1d270f60-fe56-4e95-a3b9-76f7856d257a	f035d8f8-e3ca-4fab-9c19-f8dcd1d1013f	647b0808-e8eb-4167-88e6-106f0af62c7d	1	235.21	2025-09-25 04:45:10.98788+00
17404edc-2bce-4c25-bc9e-130bb08fda8d	53b1bc46-be1f-4a23-8d19-7b034efedf21	dbc90d6d-bd76-4d68-860a-feae43bd1238	4	183.50	2025-09-25 04:45:10.98788+00
56622cab-f7e5-461a-a321-8298c3466771	654b1ef3-ade0-4ed9-854b-2a1172e403e7	1e0921bc-f579-409f-832d-1fe4da09a2fa	1	244.95	2025-09-25 04:45:10.98788+00
5ad5976e-d702-47f4-8dc6-1584c6ca95ab	43807782-c0f1-4d10-adda-45c65b2e535c	6eeb9ad3-c9f5-468b-acb0-3bb6773fabcc	1	380.51	2025-09-25 04:45:10.98788+00
942114cc-38b6-4316-9ad3-afa4ed95fc2e	cc93871a-784b-45f8-9178-4ffe08a18c86	aebf681c-0b04-4393-b847-9142c6e33b9c	2	370.42	2025-09-25 04:45:10.98788+00
e942f89f-73f5-4d7e-87ae-7b96b9233079	525d8bea-4e85-468b-b517-b93f48a3ba36	56a657c0-83d5-4bb0-908f-ac2797e3f43d	4	487.59	2025-09-25 04:45:10.98788+00
48fb0c48-c3e9-4a02-913e-71b7749cd498	4efb1ecb-9666-464a-86c9-8f5d5776d441	2d56540b-b214-4088-b0c5-c4fd2cc266fa	1	307.57	2025-09-25 04:45:10.98788+00
66d383ad-8167-4ef8-abdf-70d8eaacd41e	5a475899-b907-47a0-9b74-d7a44c28c45d	f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	1	18.67	2025-09-25 04:45:10.98788+00
d33222b4-0483-4935-bfec-927d8f07e6d2	6dc3941c-bada-4523-98ba-8c8ff7b8b92a	6511939c-616c-4cdb-8268-d754d2c03d46	2	403.58	2025-09-25 04:45:10.98788+00
212bd568-a804-4b95-9706-e1d185672425	682fc0f5-6a01-461f-a358-1eb138eecc40	5ed6762e-cc7c-447b-935a-7aa018a64ccf	1	178.11	2025-09-25 04:45:10.98788+00
3439156c-f157-4bb6-9860-ff21e4c27b97	9df8a799-2e52-489a-8914-c5a40ffe2506	a4ca9a09-1447-4df1-a3f4-4b5a8cc4321f	1	271.54	2025-09-25 04:45:10.98788+00
577ea637-378a-4df2-bd35-084d0bd71e82	8b759c5c-7c58-4431-ad99-ac9ba0655a5a	636633c1-3d62-4b6f-9154-4ed3fc8595d5	2	190.04	2025-09-25 04:45:10.98788+00
ec6e9d1d-55a3-47e0-a8f6-4bba07777810	cc93871a-784b-45f8-9178-4ffe08a18c86	c242c336-4820-418f-b8c8-c1069bd15327	5	22.23	2025-09-25 04:45:10.98788+00
0af9ed70-092c-4296-9757-655594282d62	237a8e42-b8be-4a34-9107-99c8c32ce353	8a29d493-f190-4d23-b87f-f5a4a87c3cad	2	411.68	2025-09-25 04:45:10.98788+00
920c291c-a118-4be9-a723-75d7a5db4961	99f9ec85-3a72-4110-be59-d9afdefe21d5	36626c9a-a7dc-4179-8027-4c3435f1f2f7	3	104.23	2025-09-25 04:45:10.98788+00
c912038d-3c81-457b-baee-568f8ad72e80	20d5fe53-f541-4e01-83ad-984ceb53702e	117fdc33-7e81-40a4-84f2-e9702ade010c	5	400.99	2025-09-25 04:45:10.98788+00
f620a2bc-3892-4208-82ca-3bc4f92b8666	650c8ab4-804f-4409-bfa5-10b26f8610fb	82eb95f2-6558-4fcc-b9ce-abdb673d000b	5	397.05	2025-09-25 04:45:10.98788+00
e0aa6a8a-48f6-4d09-b19b-6e13f28f0f1f	5dbfe65f-d09f-4de0-ac22-02eb460de7e9	9ef6abea-4257-4f93-b097-4b27a4de5081	1	469.95	2025-09-25 04:45:10.98788+00
36e22ce4-97ba-41dd-b39d-0a73cf40045f	55f039e3-7cba-43cb-a899-44f7c7649d77	7707eedb-41cf-4d16-ae58-84ff56a12124	3	157.92	2025-09-25 04:45:10.98788+00
5a2dd7fc-cdb7-4e97-866a-bf70596e9762	f5ecb52e-02b5-486a-9a46-6d49fc404954	25dbebc1-c41d-4e42-a4c1-fdc78888a14b	4	6.68	2025-09-25 04:45:10.98788+00
9136fdc8-26b9-4752-a980-1a28a7946e89	45539d45-9787-4efe-a7af-4ccd15da1916	3e646ae0-1e23-439d-a83e-a9318a4910c1	1	346.50	2025-09-25 04:45:10.98788+00
6fa9e32c-69f1-4af1-bd5f-deb2a19bd7b2	b638ee2d-80a6-4ff3-b15f-3ea2dc1e3ac2	ffbff3af-ecd6-4d7c-a5e6-a8d511ae2334	1	271.80	2025-09-25 04:45:10.98788+00
3c1ab1f8-13b3-4436-a134-1cce667338c3	16147c77-08e8-44da-87a5-8d30d54115fb	1a99c802-d54f-410e-a2bd-ba389dbd5495	2	124.86	2025-09-25 04:45:10.98788+00
35c3242e-2ea1-4d1e-a303-ec54c0d3aee2	27ff74a6-1a34-4174-9a32-d8de03a71f66	70aa12be-dfd0-4f6d-8f7c-f1cf108a89c1	1	54.29	2025-09-25 04:45:10.98788+00
6eb74433-91ff-408f-8b4d-27e025b1cc9d	760029fb-2348-4c8a-a68a-6a51117954b6	f8ae2130-79d9-42d0-992c-43d9cf1a0688	4	384.26	2025-09-25 04:45:10.98788+00
b0996dd2-96aa-41be-9d9a-1ac60505efb0	13872660-5f31-43e8-b5d2-f6d0cfb6ffda	6254c18f-5485-43a5-98fb-2e85e1a91afe	5	65.16	2025-09-25 04:45:10.98788+00
cc7d8a76-1ff4-4e5b-a09d-e74124e7f3af	da954279-0735-46cb-96c6-6b725726f5ac	1c0fdf1c-7dd6-4ff2-9bc3-59f2e01f1e28	2	475.34	2025-09-25 04:45:10.98788+00
d6e0454e-6dc9-4f7e-884e-e57c3df5ae93	bceef424-4b29-47c2-8409-f5b9897e681c	aabe6af0-655e-4c8e-b995-b30e52c78100	4	54.96	2025-09-25 04:45:10.98788+00
2d929dda-fde7-4e4e-8268-9cc404a96104	2efcb15a-8d88-49ab-970e-1216457514f9	dd96e686-fa93-43ea-8ff4-a2525f0c8f6d	5	346.53	2025-09-25 04:45:10.98788+00
eea5fa9d-6ebc-432e-b629-11be3430f10d	1112f024-0107-432c-ad8b-7f9ce6c17f15	cd862f44-36df-4ad5-b816-1a941066779c	3	463.00	2025-09-25 04:45:10.98788+00
3ddb3161-ec99-42a7-a9d0-047b3dc15ac9	9a0156d7-066c-4adf-ab25-b639d2c85d2b	6dd6c04b-c211-4ce7-b72c-c0761a4e14ee	2	433.13	2025-09-25 04:45:10.98788+00
769bb404-290f-4ab7-a325-3ec93f60a544	acfe7c5f-68ab-475f-8cfc-b9134ff4612f	be77833d-47e2-42d5-baaa-aaaefb069827	3	457.53	2025-09-25 04:45:10.98788+00
03865784-e32a-487b-9271-074a469b337d	f68538d9-d585-415e-a966-1e4879e673f6	6c777294-54b5-4d1c-935d-a79ab27efa74	4	59.61	2025-09-25 04:45:10.98788+00
934b2bf4-438c-40a7-aa54-8fc0baf9db4a	21f96094-3dc8-4573-87ae-01e98c850b79	2138c407-1f02-41ce-8a0b-3d1c0ba645a0	3	393.76	2025-09-25 04:45:10.98788+00
e81bfcaa-46d1-4a2e-8ed2-dd51359a8081	1529758e-e2db-4a59-9475-3ee95437d6c6	5468bad5-508c-4ba9-8820-354efb50b6ec	5	199.02	2025-09-25 04:45:10.98788+00
3af4ea6e-6897-4f5b-ad59-12aed2276410	f240e3ce-f856-4de2-803c-b9ed09a26deb	50e4f74a-a750-4ab6-b4ff-7f680f604249	4	80.60	2025-09-25 04:45:10.98788+00
48ef3e8c-6e5e-44cf-9b47-f7735b9fa44d	16fb54f2-da1c-4d8b-80c6-c3f758af6b8a	4f24bb18-71e4-40fd-af30-bf52d35d0f71	1	493.89	2025-09-25 04:45:10.98788+00
c54b58ee-ea73-45e2-9846-61add15bbdcd	8f61c253-3137-406f-9f23-1cec641712bc	32f7d55d-107c-4f71-96a3-8bd0645b1ebc	1	202.85	2025-09-25 04:45:10.98788+00
07a7c37c-7af0-42ed-bad5-204c32ccb91d	98deafff-495a-4fc8-bf3e-5f7961607766	f33cdff5-133d-48ba-9442-c3f1f0b84bdf	3	348.20	2025-09-25 04:45:10.98788+00
30e3117e-f0fd-4307-8af7-0badf2028d99	43807782-c0f1-4d10-adda-45c65b2e535c	21f0cd0b-99e5-4271-9545-9bb8ee47a8d5	3	227.05	2025-09-25 04:45:10.98788+00
f6d83c55-5d0f-45fd-b8fb-b1428fe3dadc	9cea1810-1a51-4ff6-95d0-7b290b81268d	862d4d17-b20e-43c0-b32d-77c7cba5aa2f	5	318.20	2025-09-25 04:45:10.98788+00
dc6e6e9a-594f-4321-9915-d52351c039c9	19645d20-d291-441f-9003-ec78341bad89	439736ae-d847-4c03-b0aa-1d0c018f8ec7	1	244.80	2025-09-25 04:45:10.98788+00
d0c78c22-dbfe-48b9-96fb-cf4bcf43f2d0	600ba42b-aaf3-41b5-9832-5e430c8d5c74	7de85b6c-8a49-46c5-aaed-5f440dad07f2	5	389.32	2025-09-25 04:45:10.98788+00
091f7cdc-435d-4288-baec-9e7728686dba	f40f0728-62c1-46df-953f-e17e6e5aa6e8	65916b3c-9161-4b3f-96b6-40c59d46a652	3	202.62	2025-09-25 04:45:10.98788+00
599b825f-a9d0-472e-8261-5e0e2caa64e1	8316841c-b2c1-4764-9d00-fe876b6f769b	a18f19b4-8d9f-471e-8e85-ab00052d0514	5	90.03	2025-09-25 04:45:10.98788+00
ec0321a4-e205-4938-90db-3ca44000daa9	9950f002-d400-4835-97fe-97a61c858a79	64979d06-6350-48ee-9931-f5e895d3ccfc	4	77.71	2025-09-25 04:45:10.98788+00
ddba1c51-de16-4017-bd4d-af93000734cd	a1a24691-e582-4e5e-ac0c-18a20c4042b2	10c81407-ee15-4728-861c-97322a49036a	4	287.82	2025-09-25 04:45:10.98788+00
bfc49742-ece5-4ffd-8d32-db3bcc7b04a1	1546f566-2571-4c5f-8f78-6bba8e0afe9f	7707eedb-41cf-4d16-ae58-84ff56a12124	5	194.65	2025-09-25 04:45:10.98788+00
9dd286dc-c60e-4a33-bb5e-a54dedc1ed8a	a477e93f-ec62-4192-b72d-237e93649f33	b04eb25b-9fa2-4522-99e9-cdbc0ea05dc2	4	83.57	2025-09-25 04:45:10.98788+00
bad3e13f-accf-41c3-bb6c-449dcc779afe	f4784dfd-3b6a-43e0-ac1c-28ae332c1e50	e0c24143-c277-4e34-a7c8-db1fc9905c89	1	374.70	2025-09-25 04:45:10.98788+00
9dcc16b4-9fd7-4241-9f78-8f93b3b081d6	4c168f8e-9007-4772-959b-d039729ead3c	27a57e29-9044-4910-8ceb-6e40fe7b52c4	4	1.49	2025-09-25 04:45:10.98788+00
1af248fa-1ae3-4d9d-ae77-11900e59170e	14fabcf9-3e3a-4cd1-bf67-7e91c1d422d9	f9b58e17-4322-445e-9b20-d0750b8c09c3	4	194.51	2025-09-25 04:45:10.98788+00
15539646-93d9-4b3a-99ff-fadaf9fdc967	92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	9f8a8d90-ea1b-4928-a2fa-135af6cc5301	3	204.40	2025-09-25 04:45:10.98788+00
f2cca549-bfd9-4192-9622-78b3acacf162	5b0f6a5b-5cda-4e34-b841-92e0f187f042	a249e695-7d78-464f-a3b1-a328a4cf7e38	5	332.89	2025-09-25 04:45:10.98788+00
1618c2e9-3b80-4ecc-be1b-e336937a5835	52b2eafb-4738-46ad-bd12-3d59ff910c03	4f3ea27c-9d55-4fce-adc3-9197e9274c24	1	42.31	2025-09-25 04:45:10.98788+00
ac80d2f0-f031-4167-bbfb-63a26ffb6368	66060674-81bf-4ad2-af73-04a253cd2c4c	b19683b3-ab17-4746-9e07-440b6db949fe	2	212.37	2025-09-25 04:45:10.98788+00
23f31e08-b89b-4747-aff7-cbc84130877d	0acee6b5-430a-464b-97ba-9e6e9f750cee	636633c1-3d62-4b6f-9154-4ed3fc8595d5	4	386.32	2025-09-25 04:45:10.98788+00
552068a9-8da6-4235-a03e-857ad9430a63	abfccf19-05f0-4433-92f2-9a03dec16d06	e842cc93-5510-42fe-999d-bb8d5a25998b	5	4.05	2025-09-25 04:45:10.98788+00
7f42d1b5-0aaa-4a87-948b-69b8994b88b0	b1c19e0e-8a41-4676-9103-2ad593157d5e	1d7ed714-affd-46a7-9ad1-fe88d38e314b	2	405.66	2025-09-25 04:45:10.98788+00
0791486b-e365-41dd-8573-05c054560da9	25c1f42e-8be1-44bb-b691-1a5d06a49a76	adb90a8d-06ab-49f5-8bca-d1197b222f09	4	317.97	2025-09-25 04:45:10.98788+00
f580a9cd-655d-4b41-8fee-c4b9ca2a2a7e	34112ecb-61af-4dce-8e91-ebcfa78948b9	37a371b9-fcc9-4020-92f2-b41636c96079	1	232.92	2025-09-25 04:45:10.98788+00
2377d5ea-f051-4cdf-94f9-1615fa60ca4c	dd00c93f-80d8-4575-b3c4-4df3733a2afe	62da5688-0423-438a-9d5f-5ffedde13ce7	3	345.94	2025-09-25 04:45:10.98788+00
dd118b65-fd41-43db-a0a8-396574ea543c	f32b1168-47b6-4aa6-8db0-4a813f1f4642	dd70b6ff-2461-4a7e-b011-cab3e03d225e	5	192.96	2025-09-25 04:45:10.98788+00
19b7ffeb-fcbd-49ad-8e2a-7e05e2e33a70	2092e299-3ede-49dc-baa8-6942bbfbae4c	a67c21eb-f30b-42c9-8f65-621f50829602	4	364.30	2025-09-25 04:45:10.98788+00
17c4c851-9760-48e2-9536-28228e87f229	d2859681-703f-40dc-8ab7-5792acf0c507	675c3505-b139-4155-a162-13f7bcf9c5bb	2	71.20	2025-09-25 04:45:10.98788+00
7136b7eb-a4c2-491c-9c10-05d123415a07	9e066f71-57dc-4b0f-b198-d4d5c2da6943	feaf2e6c-1ca6-446c-aed0-0ec34cd053c9	4	126.64	2025-09-25 04:45:10.98788+00
056b6fdc-6ab2-41b8-a5b3-98bc878656e0	53b1bc46-be1f-4a23-8d19-7b034efedf21	263e7942-e285-4939-be57-7f77b2431136	5	258.11	2025-09-25 04:45:10.98788+00
0685270b-504c-424b-8d29-235bcef8ae5b	aa571a5a-d2c2-4cfd-b214-badd309a7bce	b7c38c8c-048f-446e-b2a4-093988b2b3f3	5	359.05	2025-09-25 04:45:10.98788+00
fdf34d1b-edcc-47da-9c7e-32a71a866ac4	3ac2a44e-2d7e-4aac-848a-52a503161e85	42e164d2-5b1c-470c-ba3d-f714e0c17aa3	3	499.49	2025-09-25 04:45:10.98788+00
7c24a7b6-17f8-4ff8-9d50-b8cc5a5df200	3ec83e75-3a39-4fa9-a28d-02fb91767b3a	5e955770-be3c-4861-a9bd-ce75cf16d612	5	373.07	2025-09-25 04:45:10.98788+00
dc5cb2cd-f49f-4689-8cbc-3eb904905ef3	16147c77-08e8-44da-87a5-8d30d54115fb	c80893b6-b638-4a83-b6ae-2b95ae123dae	3	131.48	2025-09-25 04:45:10.98788+00
bbb4da9a-35db-4e95-8af8-230894648543	226efa52-93a0-4d6c-b9d6-ea132c4fd535	4f69480a-a24e-445f-be33-571a96e23e13	3	149.37	2025-09-25 04:45:10.98788+00
fb5889e6-4484-47ee-88f2-7f95551abc77	45539d45-9787-4efe-a7af-4ccd15da1916	af707ecd-ed23-4117-989e-4eeb702dd659	2	210.63	2025-09-25 04:45:10.98788+00
287d7db0-de16-4451-a5f7-88bde4526344	43807782-c0f1-4d10-adda-45c65b2e535c	1f9d3a8d-789d-4234-a4fc-babb3f8f1559	2	427.33	2025-09-25 04:45:10.98788+00
c1704c62-5ec5-414d-9a1f-a57dad2143f4	1112f024-0107-432c-ad8b-7f9ce6c17f15	f9b58e17-4322-445e-9b20-d0750b8c09c3	2	24.58	2025-09-25 04:45:10.98788+00
8fcec6a9-fbe7-498f-818e-5f6c4b9efcef	e9d423c3-dad6-43ec-89ab-87021d056af8	ccc4bb9c-f827-4f5b-b7aa-27140781312d	3	180.46	2025-09-25 04:45:10.98788+00
cb0d472b-48ac-46b6-a8c6-47cdfd9da37f	68251dab-f3ed-487c-89d2-3bb3ce61cb51	5f031354-7104-4787-8509-9f923d36b792	3	358.57	2025-09-25 04:45:10.98788+00
aa7d9767-c9ce-48f1-9edf-00c6ad2c92cc	525d8bea-4e85-468b-b517-b93f48a3ba36	94d5fd54-f886-4df1-afe2-7840ea858b5a	1	245.57	2025-09-25 04:45:10.98788+00
b7bc307f-d5fa-4061-b6a4-8ad8a8229955	a37b9b0b-eec6-4fcd-89ad-c3f8d00e5983	f2c97c44-10eb-4bf2-b021-d6806ada9794	3	310.95	2025-09-25 04:45:10.98788+00
7f757eab-d1f5-4cfe-82f9-476b42ddfcdf	14fabcf9-3e3a-4cd1-bf67-7e91c1d422d9	589f5188-96bc-4404-9cfe-78d6eae50831	3	3.35	2025-09-25 04:45:10.98788+00
e595dd4d-0d61-43fd-9269-7eb6a3df2f86	c9f84933-0b22-471e-bae8-cf205690ad63	44db39b5-4967-4538-8af1-1981d6846d0a	3	494.57	2025-09-25 04:45:10.98788+00
4233c8ea-a88e-4fa2-8b8b-d32b56fcc355	190dc437-aabb-400c-843c-7ab83c64dae0	d41c2e97-0aa8-4cde-a49a-97dbbdbdaeca	2	8.37	2025-09-25 04:45:10.98788+00
74a35ef3-9be6-4c3c-9a0a-cd4bdbc5fe55	340d285d-b98b-454b-b371-ac1d89d58318	339eb046-d875-45ae-96ea-c973f19333ef	2	315.76	2025-09-25 04:45:10.98788+00
90c6fb58-04c5-414e-a336-ff63962a194a	0acee6b5-430a-464b-97ba-9e6e9f750cee	d4c396bb-72ad-48bc-b57f-ae66c7d8d035	3	480.99	2025-09-25 04:45:10.98788+00
fd1b183e-28c3-41fa-8422-1c245759096e	335585f6-4bb1-4bb4-b668-b154bafedf8a	ff7620ed-ed9a-4893-9cd1-10e78696e6c4	1	55.29	2025-09-25 04:45:10.98788+00
38351425-34e2-45d7-bd8c-d687313d3c2d	5eeea7cb-6bdf-405b-9708-8191fc4424b5	827e4ef4-056e-4a4e-a7b0-dadd7aa95d4a	5	226.57	2025-09-25 04:45:10.98788+00
3068e552-932f-4777-8772-90182f933914	9c2f5e1d-1c89-4a70-8825-64f52270320f	d2257e19-50a7-4ec5-833b-8fb0c0ab54db	5	479.57	2025-09-25 04:45:10.98788+00
6ba2135d-171a-42aa-adc2-bd380ba57d24	70661215-9aff-4315-9fc5-027c065db093	cff573bd-1ac2-4710-a91a-b86b26f172d7	3	156.55	2025-09-25 04:45:10.98788+00
9b571711-196e-4d67-9d5c-5ba53913eb40	4a4a14f2-0024-4c6b-8825-a0f0b4e27adf	43eda1a7-ba23-4a06-b41d-f95a25e9f91a	3	68.99	2025-09-25 04:45:10.98788+00
6b78cee3-5cbb-4102-93f1-e2008e8d84b5	eaeb2b8e-90c8-4875-9980-9e57f8e2bebf	a0572c7c-e714-4a72-9a96-b6b360bb874e	1	430.44	2025-09-25 04:45:10.98788+00
3ba02279-1e08-425d-8ad9-41da454f9b06	62b0727d-68b0-41e2-bf76-5411fa41c964	65ba3a06-90af-4b70-950b-a7f249aa72e1	3	286.08	2025-09-25 04:45:10.98788+00
109ac4bd-c671-4cee-ae3f-16e0654310d6	33d3b868-0f87-4758-a6ac-7c666e44d5be	fb9508a0-f78d-4958-a132-a0703fc46ab4	2	483.14	2025-09-25 04:45:10.98788+00
6aea46d5-2dde-4eec-991d-f300756721f9	499af625-149a-4241-a03b-aded701ad4d2	7ed809ef-5f5d-4e5a-b537-acc589b4dfdc	2	105.54	2025-09-25 04:45:10.98788+00
59dc48ab-01c7-42e0-bac2-af1691feb603	59d3ce40-a157-4ff2-9d4c-bcf6c0a21116	3f930a17-699a-48b2-9ca2-245e31268823	2	346.55	2025-09-25 04:45:10.98788+00
e227a796-ceac-4673-8ca9-4d6119b775a2	4563b92f-05ed-47bd-b381-63564b3df8cd	c57dcd86-44c2-475c-a8e2-8fa7ce846554	3	125.40	2025-09-25 04:45:10.98788+00
a1444e68-9bf3-4dfe-8ac9-9429fde79632	e4e5df46-295e-44cd-a7ce-bfd92050529d	b472815f-8199-4a3f-9ffd-e41be8e606b9	5	360.65	2025-09-25 04:45:10.98788+00
9cd548d8-157d-4c77-9273-3c196ed485f5	c9f6a6ed-e9fa-4340-8fea-7d04e1cefb97	91dc74ec-7d5f-413d-aabe-aea64403006a	4	399.35	2025-09-25 04:45:10.98788+00
ca428e2d-ad4e-45f1-827f-6d2f1575b5f2	da1a2d3f-7a99-4c79-ae23-495545b71b44	f686b3d5-1fce-4c27-91a8-3bd4b6ac3e6a	1	118.15	2025-09-25 04:45:10.98788+00
9bc66b1d-2664-4cc5-891a-ac1d6b9d2f06	9a0156d7-066c-4adf-ab25-b639d2c85d2b	cf1e1bf1-e189-4e3f-bc2b-e58542713b9b	5	428.33	2025-09-25 04:45:10.98788+00
65c0e0ae-c287-4989-91cb-b67516993ec3	600ba42b-aaf3-41b5-9832-5e430c8d5c74	db6614a2-13de-4516-aac9-870bb9ab87f3	2	405.59	2025-09-25 04:45:10.98788+00
8a75500a-a795-4e9d-8222-5b340cb2eea9	69b95624-5ea7-46b9-bf49-70f8c2204162	9591a7f4-5431-49d8-82d7-54566ddbbcb9	4	130.82	2025-09-25 04:45:10.98788+00
8cb0383d-b1d2-40e0-b03b-8bd954bf7c13	4a4a14f2-0024-4c6b-8825-a0f0b4e27adf	f33cdff5-133d-48ba-9442-c3f1f0b84bdf	1	56.57	2025-09-25 04:45:10.98788+00
07dd5241-f288-49ce-900f-3e5265e161eb	f4784dfd-3b6a-43e0-ac1c-28ae332c1e50	3c9d9922-e12a-4dc1-a5bb-59b17fb77bec	4	122.50	2025-09-25 04:45:10.98788+00
9a5fac96-6ddc-438b-b9b2-db042e78f610	426b8444-2d7d-4280-87b1-1027ff285c10	9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	4	55.24	2025-09-25 04:45:10.98788+00
76e2367a-4cc3-40cf-ba70-a19824a5c125	20ae85e3-8269-496d-8df3-6389013ca41d	dbc90d6d-bd76-4d68-860a-feae43bd1238	3	101.21	2025-09-25 04:45:10.98788+00
bc1afc82-bef6-4e0e-9691-466f445a0fe9	1276fb6d-6b59-42ae-bbf4-b93b6c728ad2	41c1c9b3-5604-4703-a733-3a96b08f1dac	4	448.09	2025-09-25 04:45:10.98788+00
93250e58-d778-42fb-bc53-75e55b99b889	c21b52f0-431a-4470-a6f7-4b44be6d4c9e	75384ea9-6d1f-49c3-8160-2c15639917c5	2	70.09	2025-09-25 04:45:10.98788+00
c91fdab8-729e-4e6d-a903-0fdcb210362e	dfdd0300-e01c-45ca-bd58-194ef077debc	4e310021-e795-48f8-95f0-c106494cb015	4	40.69	2025-09-25 04:45:10.98788+00
0e811fd0-327c-47f2-9b26-de5c88c44daa	7b507156-3da2-4384-9c0f-5d53f3922b7a	9ef6abea-4257-4f93-b097-4b27a4de5081	4	253.90	2025-09-25 04:45:10.98788+00
64105917-19b6-4f8a-8c6e-c9dc92497ef6	525d8bea-4e85-468b-b517-b93f48a3ba36	5e74dad6-6905-4071-9d02-dab19b8d4776	5	144.54	2025-09-25 04:45:10.98788+00
2f800a41-d417-4377-a5e6-89a6cc831e20	b954a6ca-3db3-4b63-84d6-f7fe72c548e8	f24f6a07-8c60-46dc-9238-4a71725cb34a	4	239.02	2025-09-25 04:45:10.98788+00
c03a22b3-6ee9-4df3-b8b9-64b5addeeeb4	4462b016-e0b0-4540-9d60-2887e9a5767f	7cd8aeab-d746-4e22-a331-20f85bc0547b	5	346.42	2025-09-25 04:45:10.98788+00
d952ccab-99f0-4d40-a2ca-e2972c0d6c69	66060674-81bf-4ad2-af73-04a253cd2c4c	6b9edb41-cbae-48d9-bfcd-10b65500fe3e	5	193.09	2025-09-25 04:45:10.98788+00
2251e101-a94a-4eb8-8504-8b89b4a07dfb	ab4d5e03-c2ed-40ce-8340-658781fa652b	8d082510-2d25-45c5-ab63-09578063bd42	5	97.23	2025-09-25 04:45:10.98788+00
0c291e89-354e-4ace-929e-881b166c6bf2	43807782-c0f1-4d10-adda-45c65b2e535c	306e3d9a-47d6-4f1a-bb3c-de7d2a8e9f52	5	196.84	2025-09-25 04:45:10.98788+00
34645954-65ce-46d1-8918-f0d2a41e1992	36dd238f-16c8-4b6d-805e-0f076a282bc5	48776d48-3d14-4b31-a4bb-e8adc2d07748	4	310.78	2025-09-25 04:45:10.98788+00
4b9e9893-30ae-46b3-92e3-d155f6582e4c	2d9d678e-0fee-44c3-a911-351552bd549b	6199b152-5290-426e-9731-ae4cde532bfb	5	66.04	2025-09-25 04:45:10.98788+00
62ea133d-5acb-452e-a966-c334fe5063d1	f1c21b5c-0aa3-4999-ac25-c8b15ccafad2	b94454e6-f48d-44d2-9e38-6b1df6cd02be	1	145.82	2025-09-25 04:45:10.98788+00
2380ee93-c48f-4ccc-b282-f73f23f32772	6cb6a800-5043-433f-ae41-af18c9863d4d	b4ab738a-4c07-419d-b547-152d5a282bd5	2	249.54	2025-09-25 04:45:10.98788+00
c35f15d7-36df-416f-ab46-cc1c02ba1727	9fb60e99-c303-4b61-99fa-dbabe0298b73	6254c18f-5485-43a5-98fb-2e85e1a91afe	4	48.26	2025-09-25 04:45:10.98788+00
f8213808-05ac-4aa0-a74d-74563386a0a7	8f1588ed-8fee-4027-b0a1-e1b5a360dd66	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	1	415.55	2025-09-25 04:45:10.98788+00
da994aa8-da71-4277-80f6-abb4f7a018b2	ec6ec66b-e8ee-495e-8948-2b9be9305307	edaedf56-d5e6-4471-90df-e6cf1e028976	2	294.22	2025-09-25 04:45:10.98788+00
2d25a933-98b8-42ff-97be-d4a211beedd9	fd06bf20-2733-4de1-86f1-aac365c3c0ed	a43f31cd-13fc-46e8-911f-4876ac99098b	4	365.04	2025-09-25 04:45:10.98788+00
d22dfd39-3904-4b63-bd63-0e98de4c9bee	ab57d331-2736-4ca5-9326-3ee0f948c949	f5d8606a-303f-4976-989d-6a670aa41922	5	226.73	2025-09-25 04:45:10.98788+00
57785658-9aab-43c3-b672-882c77f7fec9	137e01ef-bf96-4a2b-9ed4-c69197e8d93c	4678d484-e4a7-4128-b810-9821665cc3ba	1	361.13	2025-09-25 04:45:10.98788+00
d906c8fe-3c98-45e4-96da-3f3fd76a0d15	486d0262-fa5b-4a73-8fe7-29ef1b57e731	d87dd82d-0c97-44fc-9577-ad25303dd28f	5	402.55	2025-09-25 04:45:10.98788+00
4f2ef7f0-dd04-4fb8-8f4e-826e93356c82	27ff74a6-1a34-4174-9a32-d8de03a71f66	34c0124e-60b7-4ffa-ab69-1f879796474f	2	432.02	2025-09-25 04:45:10.98788+00
4d78d496-4274-4d7b-84db-175a5687c9e2	1529758e-e2db-4a59-9475-3ee95437d6c6	7347cf20-6c94-4b73-ab81-2147533a2b91	3	390.18	2025-09-25 04:45:10.98788+00
f6171245-ea6e-4bd9-9855-2f822a4c3c80	c2ef5dbb-e7b5-4988-bf2d-ff91ecace787	13404922-32d4-4b7b-93fe-08f504436a82	4	329.15	2025-09-25 04:45:10.98788+00
bb1419ec-aabf-4649-9f7a-0f3a4dbdc2d7	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	75abba00-6208-40f4-80fd-a914bc24dc12	3	312.30	2025-09-25 04:45:10.98788+00
66640b03-d431-49c6-89b9-28a1e857e882	58bb516e-b6ea-434a-a215-e28baf801d47	21f89511-0b73-453d-90e5-5259485a5afe	2	196.09	2025-09-25 04:45:10.98788+00
284a1b3f-f21f-4f83-91f6-6f7f43f8b270	be27466b-77cb-4dea-9f69-0d9bdcf5bf92	8d83a025-5e63-492f-b4d3-411c4eaa5161	2	493.69	2025-09-25 04:45:10.98788+00
597af44b-adc3-44d4-971e-ada3a8b79952	616743a4-8c7f-4bdc-9b58-3e546b2bc63a	ae92a2db-c36a-45d4-90b8-0fc3c018c814	3	406.02	2025-09-25 04:45:10.98788+00
fa93bd77-4e26-44f5-a343-22afcb4ba333	97d16adc-06c5-4662-b6b4-631198caed60	3470c7b1-d741-413f-858d-d49c2ab0dac2	3	251.84	2025-09-25 04:45:10.98788+00
904e8402-7f26-4777-8787-06348d72560f	be4effb4-85e8-4d38-acb3-d641f0571686	5253556c-057f-483c-9381-f6af86bde287	1	37.17	2025-09-25 04:45:10.98788+00
1570dd45-5b36-479c-9d42-ba6ba7d95b88	52b2eafb-4738-46ad-bd12-3d59ff910c03	cd6571a9-241c-4ed0-9d0e-e22f63583e41	3	291.87	2025-09-25 04:45:10.98788+00
a5ae13e0-6a43-4d99-8145-dc9a6ea5e2c3	b44c9ec4-a6be-4749-bf87-a6b12b9fa08d	ac9cef94-2751-4f36-9abd-43e045341268	5	311.27	2025-09-25 04:45:10.98788+00
b88bc4f0-656a-4a6f-8b05-d40f3f23562d	4a921fd4-12af-44d6-a149-53dc0eca642c	456c24b7-60aa-4ea2-85b3-1e3f7254580c	2	468.96	2025-09-25 04:45:10.98788+00
4eb6d8b1-1cab-4be7-856e-135aab8e5eab	346bd78e-f7c1-4da6-afcc-8cb304916ecf	ba5be328-3e0f-4d8d-982e-a6249718b39a	2	479.96	2025-09-25 04:45:10.98788+00
6e298850-ada1-48c5-bbb4-233df3436194	dfdd0300-e01c-45ca-bd58-194ef077debc	e7f0c539-2930-4377-a02b-ef1af9a49026	2	87.78	2025-09-25 04:45:10.98788+00
17224ece-5b73-4881-aa41-8958b3f9a1d9	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	64010f20-cdc0-4c92-9c66-cc08b8827113	2	324.40	2025-09-25 04:45:10.98788+00
5976a210-b285-4006-9ccc-6028038ce81f	e9a8fa5f-b13a-41c8-ab5f-435092906813	86eb1621-d103-4562-bb6f-0cfe8c9a4421	5	449.89	2025-09-25 04:45:10.98788+00
e2be9573-0b59-4893-83c0-766944109b29	9a0156d7-066c-4adf-ab25-b639d2c85d2b	bd2cc9a2-7c6a-490b-a59e-d539bbb27edf	5	235.49	2025-09-25 04:45:10.98788+00
e537a67c-2695-46fe-8d66-f1bb109e7f0c	ae75b3b4-b870-4754-8880-04e837237db9	a35cbb2e-42ca-4b4d-a270-02668ed8f2bc	2	401.11	2025-09-25 04:45:10.98788+00
39574cfe-b180-4b90-b65c-6fd2174d0514	b2d6eda1-2ce5-4f67-845a-e323428c087d	fa82a48b-d4f4-438b-9b7c-0c710c755d96	5	449.93	2025-09-25 04:45:10.98788+00
5c384740-9f88-457e-9e13-b01fd4510e1b	bba69bcd-4eee-40b5-aa14-769a0d5f71b9	7271e834-4e75-469d-9037-7e8aacd4eb1a	3	388.40	2025-09-25 04:45:10.98788+00
df97653f-95e9-465a-9f91-9d8b1ec4342a	1d9052a7-123b-4c23-925a-27bb369ebb16	f1808efb-d1f3-4add-ab30-cbe3159c644a	4	352.95	2025-09-25 04:45:10.98788+00
4d4f238a-7532-4c1f-b51b-82d6dd68fdf2	486d0262-fa5b-4a73-8fe7-29ef1b57e731	449d5f97-315e-4a4e-af32-df159c3391f7	2	53.58	2025-09-25 04:45:10.98788+00
1dc9d967-c5f7-436b-a9df-74d6aea02f5a	b1c19e0e-8a41-4676-9103-2ad593157d5e	b74ed3cd-03cd-4d1b-8989-9c46bf8a230e	1	202.26	2025-09-25 04:45:10.98788+00
af760ad8-9ef9-48fb-92a0-12eefac77ce4	19645d20-d291-441f-9003-ec78341bad89	07788856-f12d-4ed3-b8a3-23b1df599b28	4	359.68	2025-09-25 04:45:10.98788+00
c4127bf1-5c71-45a3-9caf-a9cd01c0d3ce	643042eb-8aa7-4861-b2d8-ea84a8985a0e	1d0ca8ac-a720-45b6-9fb9-6c7c1c8c4557	1	52.07	2025-09-25 04:45:10.98788+00
2471b95e-d8f7-4c0a-ac36-965e13f8d57a	084cf75b-e856-4d65-977d-3b5739133ce8	76d7548b-f723-4eda-883a-1b35e77a8718	5	54.92	2025-09-25 04:45:10.98788+00
c4e0580b-ea0d-41c2-a956-a74b6104e563	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	2	189.35	2025-09-25 04:45:10.98788+00
141edd9e-fcab-4348-9ec0-f92b56185622	873132fd-5424-4c58-bf3a-6abe74432ab0	bd45195c-2758-4f02-b57a-53fbac8b4cff	3	69.01	2025-09-25 04:45:10.98788+00
e9a9ad2a-7720-4c58-b675-9efcbcdb5dd4	e9d423c3-dad6-43ec-89ab-87021d056af8	dd96e686-fa93-43ea-8ff4-a2525f0c8f6d	4	388.57	2025-09-25 04:45:10.98788+00
549ed112-d38b-4a3d-8eb8-763a9a7b2668	f32b1168-47b6-4aa6-8db0-4a813f1f4642	cf28c8b3-fd3d-40d3-9c0c-c9990416d8ab	1	184.82	2025-09-25 04:45:10.98788+00
c6a0ec07-ac70-4c52-934c-bedcd707ea9a	c2a37430-7f62-4c51-88f2-25655b1f982a	89277d81-2812-4ef4-8b07-f9869603815d	1	287.68	2025-09-25 04:45:10.98788+00
4a1ccbb7-1a46-4927-9855-7412b300461e	2da66b6f-1471-481d-8df6-aece86f2de90	6199b152-5290-426e-9731-ae4cde532bfb	2	448.52	2025-09-25 04:45:10.98788+00
0c4f2ec9-bc39-438e-8713-17d64942381e	74fc3cad-5d31-4f86-96b7-b22859970376	050432f7-2bee-4145-8847-a5426907a9de	3	252.92	2025-09-25 04:45:10.98788+00
4057c84f-6f4c-480b-a4ed-305f91b5bafb	ea2d8bd2-3631-443f-821f-7e6c24e43857	77668721-237f-4e45-8e0b-4e00732fc412	5	35.44	2025-09-25 04:45:10.98788+00
7ecb9ac0-e5d0-4041-bb05-82de19bc60f4	92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	198aea83-e7ef-4117-b08d-87c5f12c28e8	5	27.11	2025-09-25 04:45:10.98788+00
c744dc3d-911b-4d52-a6a6-09408b3d97b2	58bb516e-b6ea-434a-a215-e28baf801d47	7a4e99c7-87df-4c6e-bbb2-2f181600c5b4	3	286.30	2025-09-25 04:45:10.98788+00
eaf09bf7-811e-456f-81c1-6dd7a1715ba9	3115f2cf-6015-4bee-9d03-20bba3f38819	329ef81a-ddb7-4583-a1e6-3088e1132d02	4	344.42	2025-09-25 04:45:10.98788+00
ab9e4195-40f9-49b5-a033-da9ae81f2e88	ef4fce6c-c216-4bf3-a10a-15d6bce77f94	21745193-9c4e-4249-b2a7-c93ff9c5bf58	3	240.91	2025-09-25 04:45:10.98788+00
b72511de-bce0-4b9e-b447-d66c443807cf	ae30053b-e2c9-4893-891c-172cc2df8766	8bc06db5-1714-4c98-8785-6d14c39abbba	1	375.34	2025-09-25 04:45:10.98788+00
fc40d8ae-6473-4ef1-9426-497f9826923a	2e6c84e3-29ac-4202-a0c5-96b9b1861228	b44bed20-df21-4afa-a304-5a70bf1661fe	4	379.35	2025-09-25 04:45:10.98788+00
891daa2d-6f56-4a5b-a675-fdd7ce663c2c	fbf4368e-b376-40ff-8f59-8fae4a89bb25	826cdee7-92cd-4e48-88e0-db637b46543b	5	425.99	2025-09-25 04:45:10.98788+00
d1196e6f-b2a8-4826-8547-919ea6773ec9	30f2e86d-4612-4f51-9107-10c11ec149b0	8e7a5f95-f1e6-4270-a55d-dae16786806b	2	312.13	2025-09-25 04:45:10.98788+00
e048e9de-37a4-491d-8a31-f5f45d79b93a	6a1061ed-9985-4a6b-857f-741033d4b2d6	e3f360dc-ca43-4d24-9063-8c9734ff9178	3	307.25	2025-09-25 04:45:10.98788+00
d2ef1f88-db9e-4a12-a561-e608684c39b4	084cf75b-e856-4d65-977d-3b5739133ce8	41bcbe47-f1e6-4f71-a98e-88bb5beb1f32	5	303.15	2025-09-25 04:45:10.98788+00
f40ddbd8-485f-4935-a83b-cf010744d768	ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	d3ea9f78-f866-4f13-bd3f-3ecdd4c8ad7b	2	46.01	2025-09-25 04:45:10.98788+00
9eaec376-67ea-42fd-9839-6964573bf020	650c8ab4-804f-4409-bfa5-10b26f8610fb	07f80eaf-836d-45bf-9c10-fe69001a2fef	4	369.97	2025-09-25 04:45:10.98788+00
39b8e8f0-2d3b-4aae-9eda-6b70cabbb856	e4e5df46-295e-44cd-a7ce-bfd92050529d	0c9f2c2b-6f6f-4f31-915e-8bddf6ba97f6	3	92.96	2025-09-25 04:45:10.98788+00
7f5b09c9-cc6e-467a-b2e0-942ea8e63d12	36dd238f-16c8-4b6d-805e-0f076a282bc5	83868a37-56a6-4a61-80c8-e0b975371449	4	407.92	2025-09-25 04:45:10.98788+00
04afd88a-dd53-4829-bbc4-95f00dc5ddea	331101e6-e9a5-4b49-8f31-7b10f6879b06	c242c336-4820-418f-b8c8-c1069bd15327	4	101.07	2025-09-25 04:45:10.98788+00
efcc6eec-1028-483b-92f1-81cd715cb91d	0d3087db-c025-4035-b7bd-899b8247bcd4	dd70b6ff-2461-4a7e-b011-cab3e03d225e	1	243.85	2025-09-25 04:45:10.98788+00
05b51d61-f698-4136-8b54-677dd0b7e52d	0af99923-2595-4550-b08b-94209f0a6342	3c3a0c10-ffb2-41b1-b588-db7e4a79936b	3	207.17	2025-09-25 04:45:10.98788+00
231e4f99-8deb-4523-b07d-a5292b6195f5	bdda4657-a1b8-40e4-b255-f78d53dd7125	eab928a2-4744-41ed-8bfe-59a345e2291a	5	190.42	2025-09-25 04:45:10.98788+00
b8f061e9-b4e4-4f92-9406-cc17a3334a64	9ff9f917-e737-4cb1-9c2b-d3fc2a6dbeaa	56a657c0-83d5-4bb0-908f-ac2797e3f43d	3	453.40	2025-09-25 04:45:10.98788+00
273a3ab9-e736-4c95-9d77-c9afb1a92572	d2859681-703f-40dc-8ab7-5792acf0c507	26c9cfd2-87b9-497d-82e3-ec766ece8ea4	5	391.34	2025-09-25 04:45:10.98788+00
2e0662a5-0f9a-4cfa-abd2-9a32646bc525	4022498b-124e-4e7f-a690-5c227b7ab3c1	f5df4c23-eb63-4b9a-9208-0389662dd022	3	478.25	2025-09-25 04:45:10.98788+00
e011e119-2f77-457b-96f9-83ae7d85736e	52b2eafb-4738-46ad-bd12-3d59ff910c03	2cd83dca-d805-467d-a87e-1472adf2f656	2	192.38	2025-09-25 04:45:10.98788+00
c752050f-47b2-4203-875f-c4b73f8c37f5	8582c426-c826-42e9-88c8-217c96b432de	8f1f4898-74f0-41a2-907a-0e82e0cb2ed6	2	465.89	2025-09-25 04:45:10.98788+00
5e71cf10-e664-4547-a5b8-d47ab40efb87	340d285d-b98b-454b-b371-ac1d89d58318	5835c521-b454-428b-a9ba-bc1b20d8d681	5	265.93	2025-09-25 04:45:10.98788+00
a0a46131-51d4-4796-ad87-645bae8700a0	9c2f5e1d-1c89-4a70-8825-64f52270320f	ab9dd606-ca63-4a8f-9891-92ff53c2b29e	5	432.09	2025-09-25 04:45:10.98788+00
087900be-ee98-455e-b91f-3470b83c8d04	c9f84933-0b22-471e-bae8-cf205690ad63	b345b1d6-afda-4064-82a3-8ada5c625990	1	42.42	2025-09-25 04:45:10.98788+00
5190feec-2ab5-44dd-b0b1-00ae49d45811	4a4a14f2-0024-4c6b-8825-a0f0b4e27adf	55adb5e7-144f-46f2-8b39-88d376859a6a	4	290.63	2025-09-25 04:45:10.98788+00
b3ed6d43-ae99-447a-9291-78b36bca0754	effa6386-eb68-4670-abfe-9def4aed1765	3c796ee1-f3e7-484d-8659-fa9251c5cce2	5	342.28	2025-09-25 04:45:10.98788+00
42fa4dfb-6292-461c-b584-1a4cf474f9fd	b771a9e0-f6ad-4817-8a83-791d3b689769	ffe792a1-957c-4a1e-a728-45917cc2213a	3	402.81	2025-09-25 04:45:10.98788+00
92a5c0e0-eb90-4083-9a33-50e970ac4d6f	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	0b86f9b2-2c5d-41c8-96b0-5f0329f2b640	3	383.59	2025-09-25 04:45:10.98788+00
1a96db74-06c8-4fe7-8a71-7f627192e71b	50e45178-6375-40c0-a761-6b0857248d24	7529abdc-8713-4045-8e8d-208fe6c1f879	1	438.88	2025-09-25 04:45:10.98788+00
84704246-709a-41e5-8da1-ee03d36d23ad	2852a240-9b4d-432d-ac95-443b5b17ae34	96025684-4b0c-41a7-8dc1-96f351c134f9	5	384.71	2025-09-25 04:45:10.98788+00
e474de23-3571-4a5c-95b0-87abdfce05a5	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	0262cb3a-42f7-4eb7-89cb-8f5d3372e510	1	252.71	2025-09-25 04:45:10.98788+00
f4597560-126e-4d0d-b078-57c8db5f5f33	48682c5c-53fe-4cf1-ba6a-a8d484288aff	dfe4ce16-3d38-4433-87d9-a7e802c74f40	2	63.43	2025-09-25 04:45:10.98788+00
dbfd5319-6ad7-4f28-99d1-7afd3f3c19b3	b14c0b15-9d1b-4068-a271-3aa127c22c0c	329ef81a-ddb7-4583-a1e6-3088e1132d02	1	332.51	2025-09-25 04:45:10.98788+00
fd5cb864-9a1d-4f57-b4e1-448a91bccce5	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	6199b152-5290-426e-9731-ae4cde532bfb	2	253.18	2025-09-25 04:45:10.98788+00
afa4c083-38a4-40e4-88ab-9ea90f3f5991	84215ee9-c6c5-45fd-9a43-7cc76c8bb7f7	f6831c4d-01a8-4471-ac47-b4de6fd26c34	2	133.11	2025-09-25 04:45:10.98788+00
59ee7404-3285-4c84-bff8-2215f84024d6	44950334-23ad-47ac-8466-4f67d1c04b27	9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	3	59.85	2025-09-25 04:45:10.98788+00
f199d6d4-554f-471b-b982-e575a47caa52	565b0387-3386-402f-a840-08a8b9f80ea2	1e0921bc-f579-409f-832d-1fe4da09a2fa	5	141.87	2025-09-25 04:45:10.98788+00
27220dd8-db26-4f4e-b3d6-5ed82d307b85	69b95624-5ea7-46b9-bf49-70f8c2204162	07bd80db-59c8-4656-9564-d5f2910712ea	1	29.80	2025-09-25 04:45:10.98788+00
165360ca-8687-438f-a3e6-467342af951b	48682c5c-53fe-4cf1-ba6a-a8d484288aff	685e0f0a-4d1e-4ea9-8a74-58f6156117b6	3	104.32	2025-09-25 04:45:10.98788+00
5112ddb2-1ed2-4bc7-9b3b-e45d886e987f	20d5fe53-f541-4e01-83ad-984ceb53702e	abe82c8f-d2c5-47c4-84d9-7bfff4d15ff0	1	452.98	2025-09-25 04:45:10.98788+00
b9d28057-1895-4e16-b861-7bec4f7b456e	d0e67a77-64cc-4d59-81bc-1b5a49fd3cda	8e4f9281-4de2-4a32-8382-9889f1a24801	1	342.78	2025-09-25 04:45:10.98788+00
303fa43b-643d-47bf-bbd8-f18a659fa7f5	a37b9b0b-eec6-4fcd-89ad-c3f8d00e5983	efa90324-2240-43be-ab36-0a1bc0e32ce2	1	350.22	2025-09-25 04:45:10.98788+00
cd5af044-a131-49c8-b777-e7cf421c2b06	f035d8f8-e3ca-4fab-9c19-f8dcd1d1013f	905533f0-1768-4875-af44-c40f2f12fcbf	1	424.86	2025-09-25 04:45:10.98788+00
1d671921-9b73-41e6-af2f-af066acaf59f	525d8bea-4e85-468b-b517-b93f48a3ba36	411be77c-517f-4f2c-89e3-07281888389b	3	410.21	2025-09-25 04:45:10.98788+00
5f64aca7-0623-4035-8aae-a5147196b5ec	30f2e86d-4612-4f51-9107-10c11ec149b0	a7357a6b-eb1f-4536-be65-b678cb076d9f	4	159.07	2025-09-25 04:45:10.98788+00
d7942b20-f7af-4684-8c53-01bcc0eabafa	a2d37279-1651-47c9-8964-bc58ba2f7766	4d3a9cfc-9faa-4cb4-9925-2ef1401088a9	1	370.08	2025-09-25 04:45:10.98788+00
412b600a-8fd2-4069-8bd0-902c45919583	682fc0f5-6a01-461f-a358-1eb138eecc40	9ef6abea-4257-4f93-b097-4b27a4de5081	1	78.66	2025-09-25 04:45:10.98788+00
e1a3fb49-d86d-4949-bee4-683fc6b4980e	90c3d581-e6d0-4778-94d2-4da99a0eb10c	b0636ba5-8172-44fa-814e-56fd191ed72c	5	342.30	2025-09-25 04:45:10.98788+00
c8bd9609-7c5f-4136-83c3-a540097ca10f	9526c4ff-a55b-4e0a-b7a4-b0b58f9c6f6e	623359cd-90ee-44dc-add9-ec00f7428b85	2	445.44	2025-09-25 04:45:10.98788+00
138d18ed-a33b-48fa-8024-ea759964e247	948cc5b6-87b2-4ce6-9dda-289c7563bc38	a0572c7c-e714-4a72-9a96-b6b360bb874e	1	498.70	2025-09-25 04:45:10.98788+00
4e243eed-564c-4198-a82e-0c03e435020f	af0974a1-70cb-4884-980b-f4b4078e936d	89277d81-2812-4ef4-8b07-f9869603815d	1	150.12	2025-09-25 04:45:10.98788+00
1c356c29-754b-4b27-ba80-afa81c76b84b	ac240e7d-0011-4233-8958-dc5c19352f3b	7c3d6049-67fb-4254-b659-40ccf79572fb	5	169.34	2025-09-25 04:45:10.98788+00
4099c7bd-b596-41ab-aa2f-b17a92977951	c2a37430-7f62-4c51-88f2-25655b1f982a	3bc7ded0-4552-4ce6-b0da-4b564392aef0	2	411.62	2025-09-25 04:45:10.98788+00
850d2251-c581-41d6-90f1-d2b9aeda58c3	ab4d5e03-c2ed-40ce-8340-658781fa652b	fde55e8c-2b45-45f1-bfa4-b3acdbb8c716	4	472.03	2025-09-25 04:45:10.98788+00
83d24198-e7b8-41d7-88ce-463f613d6696	4e0fc028-5900-4a70-8e05-35ee95745e2e	60e6f374-032c-4182-85b4-22232ac5a0de	5	236.02	2025-09-25 04:45:10.98788+00
5f1bfdd6-c88a-4c3f-82a8-9c274360e688	979af0fb-584d-44f1-b715-01bbbf2751e3	29831035-def5-427e-b2cf-1b870011f3f9	2	224.83	2025-09-25 04:45:10.98788+00
6c2b922a-ec9c-4b48-ae16-b4db0321d4f8	873132fd-5424-4c58-bf3a-6abe74432ab0	23564ad7-a514-4fdd-9879-bfbd0ea21589	3	490.05	2025-09-25 04:45:10.98788+00
fe6e3b3a-3440-4a63-a2e4-4c892159c2c4	226efa52-93a0-4d6c-b9d6-ea132c4fd535	2eaed555-a3a1-4a7c-ae53-0c6fffbe6f52	1	310.40	2025-09-25 04:45:10.98788+00
e8949fed-2ea1-4936-ae58-540350458e7d	36dd238f-16c8-4b6d-805e-0f076a282bc5	1c2e1ad8-af4a-43b2-9a7d-2f46905eb890	5	245.66	2025-09-25 04:45:10.98788+00
8e9ffb26-1fa7-45b4-8893-7e89c422a0dd	a8429b46-b30d-452c-b54a-838f80af17f5	87f44895-4e30-42ac-bf6d-d4b3b1a7a68e	1	189.76	2025-09-25 04:45:10.98788+00
09b18c57-636b-4336-9185-df461ae03aa4	d69ac389-3833-4684-8f50-5a7e9e00ffda	5537b5cd-974c-4232-9f90-dde2a70619bc	2	347.95	2025-09-25 04:45:10.98788+00
6e3bed1c-0bde-4a98-ac63-4eeddbfa212c	833ed813-6177-423d-9903-87634724c195	6b8bae2b-61ba-4605-89bb-f68d26b660a8	5	182.72	2025-09-25 04:45:10.98788+00
dd673fe5-382f-4ff6-9d90-7b02bd93da49	be27466b-77cb-4dea-9f69-0d9bdcf5bf92	adef93e2-5ebb-4fbe-9be0-8a912003fafe	3	398.88	2025-09-25 04:45:10.98788+00
d235daae-eb91-48b9-a24a-0c99aa52e44a	2da66b6f-1471-481d-8df6-aece86f2de90	905533f0-1768-4875-af44-c40f2f12fcbf	3	403.67	2025-09-25 04:45:10.98788+00
9b183f9d-e297-4ac9-9140-254bf91fcdcd	c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	26ef9482-13ef-447d-8705-626db164f85a	5	354.03	2025-09-25 04:45:10.98788+00
15783766-3bdc-428d-82b1-55f29afdd02a	16fb54f2-da1c-4d8b-80c6-c3f758af6b8a	439736ae-d847-4c03-b0aa-1d0c018f8ec7	5	165.82	2025-09-25 04:45:10.98788+00
91e42422-0dea-4fb8-bc63-729c28364711	340d285d-b98b-454b-b371-ac1d89d58318	32f7d55d-107c-4f71-96a3-8bd0645b1ebc	3	289.05	2025-09-25 04:45:10.98788+00
06255753-c6b3-4ee1-8b3b-cd9ad45b62f0	dbd346ee-a8e6-4a1e-a24f-fc2daba21fdc	736b283a-1808-46e4-85f3-a44cd7ac8a3f	4	459.92	2025-09-25 04:45:10.98788+00
48d36525-861a-456e-8f32-481a80a780fc	ab4d5e03-c2ed-40ce-8340-658781fa652b	da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	1	222.59	2025-09-25 04:45:10.98788+00
5317bbe7-5934-4c71-a44b-a1ba1861c84c	ea2d8bd2-3631-443f-821f-7e6c24e43857	02ed6ab3-2074-4dd9-a6a9-c8160abc4bd0	4	362.20	2025-09-25 04:45:10.98788+00
b00a5771-f3ab-4e65-8e68-b7e4554136c6	78827d48-4c31-4772-9d47-67e60e25d2b9	a6381a31-5faf-49d1-b719-8c27719667d3	4	375.03	2025-09-25 04:45:10.98788+00
a030e729-800c-4cca-931c-60231e4ebb69	76dfa88b-3479-4d45-87ef-c3922d07a9fe	dc650372-e01c-4852-8f0e-42c9da6eee32	4	24.21	2025-09-25 04:45:10.98788+00
9690ea9a-837c-4fe9-81e7-76c074753051	b5e7ba07-b6b5-40ad-bf4d-22815c5079a8	fe6b6e4d-2292-4b2b-b115-c39f1a8783f9	2	317.78	2025-09-25 04:45:10.98788+00
1e24e509-d727-41f7-a65a-0e859eb09a1b	08607ad3-480a-4945-a934-b96d6ea030fd	5cd9a9a1-f212-4606-af53-fca25dd3080e	4	414.02	2025-09-25 04:45:10.98788+00
be0a6f26-69d3-4c72-8c58-a3929ecaa797	5dd960b8-4a7c-4113-82c6-7cb8ebcdda54	f032a584-5abf-47bc-892e-f61dccc60a62	5	244.96	2025-09-25 04:45:10.98788+00
5adb38d8-87c3-4872-b621-2e9a8f7ec582	2efcb15a-8d88-49ab-970e-1216457514f9	050432f7-2bee-4145-8847-a5426907a9de	4	153.55	2025-09-25 04:45:10.98788+00
d6d0ec39-cbcb-4413-808c-0eec489ddf04	833ed813-6177-423d-9903-87634724c195	f2c97c44-10eb-4bf2-b021-d6806ada9794	1	195.14	2025-09-25 04:45:10.98788+00
3856b5aa-d419-47dc-a0be-2cdeafab5d11	525a282d-0f8d-4f23-b0b8-d68235fe2da1	fb417af0-916f-4df8-8522-beb0da87cfc2	3	77.60	2025-09-25 04:45:10.98788+00
11765ae6-8726-4969-9708-9bba97ea8421	d68fd55d-4c20-4f1d-9de7-5924e4e30de3	8b01af50-26a1-487b-8b2c-120b749d30a3	5	499.54	2025-09-25 04:45:10.98788+00
14a11fd0-cdaa-4de9-9ec2-3ea32f557ad6	8c30775c-7387-485e-a1e3-b48311e93820	3e34ea2b-557e-430f-b6a2-81f8e4c33dea	4	449.88	2025-09-25 04:45:10.98788+00
b1e49e67-0592-4829-b32d-7fef29f41044	a477e93f-ec62-4192-b72d-237e93649f33	8534c7b4-3f09-403f-bb45-3b6241ee860a	4	122.25	2025-09-25 04:45:10.98788+00
c945bc50-5b9a-4f78-88cd-8d96c4ff8d12	525e96b1-c61a-49d0-ab04-1603c0ab49fc	59949c43-3538-465d-b575-326cbdf39557	2	88.48	2025-09-25 04:45:10.98788+00
95b84c03-a909-4dc6-826d-c4a19b32ab9a	643042eb-8aa7-4861-b2d8-ea84a8985a0e	800d96a8-b4d6-4a3d-8ace-c0c214669238	5	269.01	2025-09-25 04:45:10.98788+00
f12cca38-b57d-435b-8f3d-197d6d4675ad	019ea4d1-14af-409d-89ee-fbf3c80454d7	e1e9b987-57bb-4fb7-8513-4d1fae8f8f4e	3	443.66	2025-09-25 04:45:10.98788+00
124618a8-d70b-43c1-8398-6b26e9f94e70	effa6386-eb68-4670-abfe-9def4aed1765	625de24b-bb6b-4771-bfdb-19cfbe0bffd6	2	296.13	2025-09-25 04:45:10.98788+00
833fbc73-aa9b-472f-8e81-2b89c6e8e560	c9f84933-0b22-471e-bae8-cf205690ad63	96025684-4b0c-41a7-8dc1-96f351c134f9	5	251.01	2025-09-25 04:45:10.98788+00
ba0e19d5-5ce6-45de-a5e4-70199cc34332	948cc5b6-87b2-4ce6-9dda-289c7563bc38	350afe49-c3e0-4a97-8d8f-310e04a311b0	5	288.70	2025-09-25 04:45:10.98788+00
35f5d421-c1a6-4c2d-b26f-a97fd8387dd5	99f9ec85-3a72-4110-be59-d9afdefe21d5	bee98622-9bd1-490e-ad11-8058c4256166	5	463.89	2025-09-25 04:45:10.98788+00
fc6162fa-3028-4fec-aa69-d2d4fc705235	682fc0f5-6a01-461f-a358-1eb138eecc40	caa6bc73-fb21-4bad-8f74-611730b8ed99	5	460.32	2025-09-25 04:45:10.98788+00
0018beb3-a514-4020-b4b3-8caf0e55e28a	ab0c5c47-42ad-4cd1-ae01-bfedc5e06335	694c7c50-b0e9-4984-8f01-c8a7f4107cd3	1	337.55	2025-09-25 04:45:10.98788+00
afd22e40-b9d2-4a38-9bda-5f1a08f5a3f2	fa43f9b0-bd2a-4888-ba22-afd7b2ea9c3a	c3da0e95-984c-40a5-be8a-19da27e84033	5	322.70	2025-09-25 04:45:10.98788+00
97b94a66-de19-4636-9c63-c5bb71b4c3fc	9526c4ff-a55b-4e0a-b7a4-b0b58f9c6f6e	bb972181-e2dd-445f-a60e-adcdc29a1fb0	4	139.08	2025-09-25 04:45:10.98788+00
0efe56e2-0760-44c1-b214-198e4c6066f7	58bb516e-b6ea-434a-a215-e28baf801d47	118237ca-4fcc-4611-aee1-1b5aa4c094fa	1	405.65	2025-09-25 04:45:10.98788+00
828c1d97-9f5b-4663-a9a9-03521c11b5b5	eaccc436-9b93-4748-bf78-de7e26546665	2f27a396-89d6-4a3b-9b81-de8b4cf74f02	5	165.85	2025-09-25 04:45:10.98788+00
c737fd4b-50df-44ef-84af-80ef486a3d8c	22e7a462-e53f-4048-8819-df1c202a992a	dc995feb-0c4b-46dd-83ee-bedda7f27956	3	406.82	2025-09-25 04:45:10.98788+00
ab74e912-3bf1-4838-969e-d377701ca1e6	20ae85e3-8269-496d-8df3-6389013ca41d	0c131e48-2bf1-402a-a2de-fb03d45a6173	4	384.13	2025-09-25 04:45:10.98788+00
e85d6045-89b3-4131-9b26-10108f26a11b	2c11a5c2-9d3c-4be7-84cc-0155723a7667	5537b5cd-974c-4232-9f90-dde2a70619bc	2	148.96	2025-09-25 04:45:10.98788+00
df53afb1-c988-42c3-831f-edb93b8c251b	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	172f7972-39b2-4182-903a-8ac4660a5478	5	388.33	2025-09-25 04:45:10.98788+00
0d02c48b-3439-4b57-b97b-b6b5cc34c48d	1efaa2bd-8989-499a-aa6c-8a7c21efdd7c	9ccc6ad8-2ff1-4339-9f23-c030c21a5f27	2	176.79	2025-09-25 04:45:10.98788+00
313cf3a2-3a8e-454d-a32d-caad5175ebc6	f6a00ade-1778-4516-955f-dc8933a5c3cb	8a29d493-f190-4d23-b87f-f5a4a87c3cad	1	5.61	2025-09-25 04:45:10.98788+00
caf35196-56f9-4b7f-ac56-97bee6861480	f40f0728-62c1-46df-953f-e17e6e5aa6e8	bee98622-9bd1-490e-ad11-8058c4256166	4	439.36	2025-09-25 04:45:10.98788+00
5a7ac403-f85a-4df0-89a8-d63532debfd8	84b7ec69-3da0-4827-9fbb-3c41ba0a81e8	0ddcc716-22b8-4b71-8deb-24ad5844df78	2	93.61	2025-09-25 04:45:10.98788+00
1ae7f103-c909-41cc-b040-71ef919bbf1e	e5f30e6c-96b7-42a3-bffc-6d1fc991f36d	ffe792a1-957c-4a1e-a728-45917cc2213a	1	270.80	2025-09-25 04:45:10.98788+00
7a7199c7-7a2d-4ed1-9bf2-14b3195ed0ae	e9d423c3-dad6-43ec-89ab-87021d056af8	7c6ecbf8-6f0d-4946-9d9c-0d99d210458c	5	499.58	2025-09-25 04:45:10.98788+00
1d140196-4b2e-4939-bb5a-257938be2530	55f039e3-7cba-43cb-a899-44f7c7649d77	448bc7ba-131c-43e9-9061-b6a3d574e1ad	2	38.53	2025-09-25 04:45:10.98788+00
e33d6b45-d423-436b-9746-d2485c3c447e	22720962-2ff2-444e-8219-348d1d8bd7d5	88bbba47-4ee7-4b40-a9ca-cc189c6567fc	3	25.99	2025-09-25 04:45:10.98788+00
addaaf7f-845f-48db-ae72-d158f9ae9933	7ac3648f-0fad-47e7-b559-704d4eded058	cacd951b-2ee2-45d8-bff8-f3d08498e804	5	92.12	2025-09-25 04:45:10.98788+00
12cce0ab-82f3-41aa-bfe1-d501b7eebe3f	50e45178-6375-40c0-a761-6b0857248d24	d73c1d4b-d02e-4186-97a8-5608995eeffd	4	52.39	2025-09-25 04:45:10.98788+00
3ee3d3db-7dc4-4c4c-8866-7349896089ba	084cf75b-e856-4d65-977d-3b5739133ce8	5d6e3a87-4842-46df-882f-5e662fbccd09	4	479.51	2025-09-25 04:45:10.98788+00
f8101406-935d-4094-9897-9b5ce5f53179	9fb60e99-c303-4b61-99fa-dbabe0298b73	676fcc0d-3c5e-497d-b57f-ee8fabfa95c8	4	275.72	2025-09-25 04:45:10.98788+00
6cfe28c0-659c-46ca-b4bd-77ce0a65d69c	df8d6ba7-5a0d-4ceb-961e-e687721e7c20	78b46b2a-8550-405c-88b0-e2619b3d095a	3	478.28	2025-09-25 04:45:10.98788+00
9d165983-0785-439d-872c-ff2b32f5fa0c	e11e7ed0-f84b-43f0-9471-49694b423953	a009fa16-adc5-4dff-aef0-33eab2015e8e	4	412.37	2025-09-25 04:45:10.98788+00
9e1dd674-572b-45a0-a055-2eff5a9c911b	1186879e-b083-40c7-b51a-d7bf6860b348	c8003c5f-e1a6-4ac8-905b-099a4b728500	2	7.01	2025-09-25 04:45:10.98788+00
99fd15d2-6251-4844-b173-c3b3a3ff8cb7	985f818c-1a1a-4d3e-8bef-69164308c435	7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	1	393.91	2025-09-25 04:45:10.98788+00
0b90f714-d170-4c93-a881-5e55b6b4fbbb	dfdd0300-e01c-45ca-bd58-194ef077debc	e5055dc0-3bbd-438a-8ff5-921d70643ac7	4	214.23	2025-09-25 04:45:10.98788+00
bcb04143-5534-490f-9ace-69837071b251	4ed80603-7451-47ea-a4f0-cf51d43831b5	95fdab27-0aff-4ae3-af8b-3fcfc6220729	5	220.94	2025-09-25 04:45:10.98788+00
f72d536a-a09e-4b92-bfee-6d661806c35a	8316841c-b2c1-4764-9d00-fe876b6f769b	cafef26b-d5fc-467d-8945-8c2c4b3c871f	2	276.16	2025-09-25 04:45:10.98788+00
dcb98e2e-2181-4844-9e43-60ee9ed59683	9b45b796-bb7f-443d-bb83-ab9e99fbc9e2	96f27450-67bb-4291-8154-1500feeb9253	4	350.62	2025-09-25 04:45:10.98788+00
06da6b6f-0509-4ae0-8821-0543df50bc3d	a352ecfc-6105-4f71-a5bb-32a178c1384b	628570d2-cdaf-4cdf-8913-a3c5d230073f	4	350.28	2025-09-25 04:45:10.98788+00
1abe6325-6c7a-4e67-9c88-9da06a18413b	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	e06ca0c3-73d9-49e0-a5c6-d52ebd6153c4	4	6.02	2025-09-25 04:45:10.98788+00
0250e977-1422-4ab8-939e-fff1664bcabc	ef81b2be-c029-42a1-8b4c-ee186a60824c	0a561629-6faa-4571-a7eb-d47ada634332	3	243.23	2025-09-25 04:45:10.98788+00
81ff4e79-3d92-4ba4-a420-9650809ee4cb	16147c77-08e8-44da-87a5-8d30d54115fb	1c16adca-43ef-4fc3-8e3b-115e636fc6b4	1	367.80	2025-09-25 04:45:10.98788+00
0429cce1-e255-4183-a602-626bd407201f	8f61c253-3137-406f-9f23-1cec641712bc	55aa04c2-87e7-462c-b372-7bb308f443ea	4	458.49	2025-09-25 04:45:10.98788+00
fb89032d-aaca-450b-95d2-43e843f40668	833ed813-6177-423d-9903-87634724c195	91184f6c-6283-4075-b03b-ab164a047381	2	274.18	2025-09-25 04:45:10.98788+00
6bc2a16e-7ece-4008-8461-7d91976cc4d2	be4effb4-85e8-4d38-acb3-d641f0571686	8d082510-2d25-45c5-ab63-09578063bd42	2	246.45	2025-09-25 04:45:10.98788+00
1c844528-3c27-456e-807b-19f670ac2319	b14c0b15-9d1b-4068-a271-3aa127c22c0c	356dbff0-728f-4cfb-81ca-1aba7a2422f9	3	359.61	2025-09-25 04:45:10.98788+00
7d9aeb31-93c7-4b5b-8c0d-6a4cd5a4d117	1546f566-2571-4c5f-8f78-6bba8e0afe9f	6a272495-c7b0-446a-ac47-69f5d91e4f26	2	87.39	2025-09-25 04:45:10.98788+00
afa99055-4381-464e-bb32-a749bf9ae568	5a475899-b907-47a0-9b74-d7a44c28c45d	f9b58e17-4322-445e-9b20-d0750b8c09c3	3	484.29	2025-09-25 04:45:10.98788+00
8cae0192-57b4-4a33-a53f-5bb1c401d35b	59893b10-830f-45ae-ac1f-450959f712b3	a67c21eb-f30b-42c9-8f65-621f50829602	2	437.79	2025-09-25 04:45:10.98788+00
10ca590f-85e7-44d8-ad79-486e62db2c4d	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	9e4dc57f-4b97-4742-bfd1-6fdc51803678	1	214.15	2025-09-25 04:45:10.98788+00
2725849d-69f6-4b2a-86f8-bf40e5b00203	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	38bfd2dc-08ec-44ff-a005-76aa7ad2ed61	2	494.45	2025-09-25 04:45:10.98788+00
d06a1ea7-1de8-4d80-b6c4-59ca1ae40ddc	53b1bc46-be1f-4a23-8d19-7b034efedf21	4439085f-d4d6-4458-9e6d-703011ee1376	5	23.85	2025-09-25 04:45:10.98788+00
58dab5d1-1ff6-48f9-b366-fbe81a05f51a	a2d37279-1651-47c9-8964-bc58ba2f7766	a8ae8cf4-1975-4e07-a6d3-104867375a8e	4	26.67	2025-09-25 04:45:10.98788+00
6f729ac4-afff-43e2-99d9-b27981e45e71	c2a37430-7f62-4c51-88f2-25655b1f982a	95062fe6-f332-4c00-9973-cf6230544a8c	3	270.24	2025-09-25 04:45:10.98788+00
dd4815dc-609a-489b-a568-f1492935105d	2092e299-3ede-49dc-baa8-6942bbfbae4c	4511cd81-1f63-408b-884d-24fa6f05b835	5	64.15	2025-09-25 04:45:10.98788+00
33c3314f-cf45-4d68-a084-eddb94618057	db1badd8-71cc-4a88-a06d-abebe02ee7fa	9709631a-d9f4-4c76-bb52-5692284f7495	5	294.07	2025-09-25 04:45:10.98788+00
be3df966-2f13-480c-8e08-f097aa785fc3	499af625-149a-4241-a03b-aded701ad4d2	b9434108-7ef0-42bf-9f20-80d74059c1a0	3	75.73	2025-09-25 04:45:10.98788+00
8fd3be45-462a-44d7-b3a1-d70c636035db	84b7ec69-3da0-4827-9fbb-3c41ba0a81e8	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	4	203.27	2025-09-25 04:45:10.98788+00
07cf583e-fc4f-4538-b444-d18531cfb0d7	25c1f42e-8be1-44bb-b691-1a5d06a49a76	3e095011-5a63-4ee4-8255-e8c5662e4fa5	2	118.34	2025-09-25 04:45:10.98788+00
b8946b93-1e71-4b28-a6c4-c16fe8273b55	57c9f478-0322-4dcc-8934-5d3ed768e1fb	6b9edb41-cbae-48d9-bfcd-10b65500fe3e	5	33.24	2025-09-25 04:45:10.98788+00
cdb3f434-108b-4ba8-a30c-6fc2c0e0b6cc	36dd238f-16c8-4b6d-805e-0f076a282bc5	aafd4c57-d44b-464e-b877-504a4daad1ef	5	112.86	2025-09-25 04:45:10.98788+00
ecd53c7d-691b-4e05-af30-d7d341198393	2c11a5c2-9d3c-4be7-84cc-0155723a7667	244f5fdd-00d4-4ae7-a523-a14b19e3e3fc	1	241.03	2025-09-25 04:45:10.98788+00
4d297ab6-f45c-4b10-88f9-bf9552566a77	3ea59b35-95d6-42fc-8d26-061897e4d2a8	8d42e90f-73e2-46ab-8fa4-0757172c2dd6	1	221.39	2025-09-25 04:45:10.98788+00
581eb09c-845e-4180-b5fd-e4da4ce3bc06	dbd346ee-a8e6-4a1e-a24f-fc2daba21fdc	99cbee9d-abd8-48fc-a7a9-1dd7ceb5a94e	1	236.98	2025-09-25 04:45:10.98788+00
6a27eef0-26c5-48f0-883b-18bb3190f142	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	d55b1e7b-d82c-405f-99bb-267e0d272594	4	121.31	2025-09-25 04:45:10.98788+00
204d078c-559d-4a27-bf7e-69720ecfa4a4	dd00c93f-80d8-4575-b3c4-4df3733a2afe	b885d6a5-df0f-466d-94c1-c2f270550b76	2	54.41	2025-09-25 04:45:10.98788+00
028672ae-f7af-48f9-bfab-78ab9a7495ee	223005b3-31fa-485f-b021-606d097d451d	50e4f74a-a750-4ab6-b4ff-7f680f604249	2	298.88	2025-09-25 04:45:10.98788+00
6d179af0-40c7-4813-88a9-3768210feb12	87758a86-90a7-4859-8155-e3cdc49e8703	e8933d87-8ec8-424b-a393-c3fddbdf36d0	5	323.61	2025-09-25 04:45:10.98788+00
a82687a9-9eb6-4c05-a51b-b4885ee0002c	3be93ddf-24fa-4a11-8b3a-f873bd9fbf7b	51df7af3-1a5f-4802-a9af-7f8255ed2251	2	431.62	2025-09-25 04:45:10.98788+00
5aec5e64-0d83-4674-97b6-e1d8b64980ef	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	867f8537-e019-444c-8ebf-33c3c7267f18	1	220.24	2025-09-25 04:45:10.98788+00
e06331a8-2cb8-44b8-b990-72a37ba69064	2a21d19d-fccf-4bb9-8eaf-a5ec16428fc0	78f65a6b-18c2-48df-8bc0-eb30a0154451	2	12.57	2025-09-25 04:45:10.98788+00
98e32c3f-9fa4-46ec-be57-d6ac1b9e5487	84a0b61f-5665-4166-9a16-016ce275479b	b87cdb86-a8a2-41c0-9330-030ba505895d	1	413.30	2025-09-25 04:45:10.98788+00
2921507e-1a23-499c-8a99-6a20d105edfa	f5ecb52e-02b5-486a-9a46-6d49fc404954	38698efa-0fa4-4a79-9d21-2da2af8008f9	3	426.45	2025-09-25 04:45:10.98788+00
5c0b8574-b0ca-4cb6-832e-d96886d952ef	c1cc4694-d310-488d-8e5d-63847b4c6891	7f72cfc7-633d-4d9f-a31e-e0424be358fb	4	380.87	2025-09-25 04:45:10.98788+00
99ee3cc8-36dd-4e55-bdff-a4f4bd58c499	6a1061ed-9985-4a6b-857f-741033d4b2d6	b5eee025-52d6-4293-853a-e8652daa2961	4	199.50	2025-09-25 04:45:10.98788+00
1fdcc009-eb86-4326-bb1c-bcf971734fe6	acfe7c5f-68ab-475f-8cfc-b9134ff4612f	e5a34702-df91-4bbb-a7d7-9eaeeac19445	4	3.09	2025-09-25 04:45:10.98788+00
c72af179-bb8d-4b0f-b392-019a6d8450eb	9e066f71-57dc-4b0f-b198-d4d5c2da6943	a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	4	23.28	2025-09-25 04:45:10.98788+00
3d88ab92-78b3-4458-8b99-296f61d7dfde	7c190cc8-396b-452c-a86e-9a4b029eaa78	e7d68233-2ea1-4007-a645-58c6906d4ed4	5	310.96	2025-09-25 04:45:10.98788+00
df6eadeb-6b81-42b2-b308-9468857143d7	1d9052a7-123b-4c23-925a-27bb369ebb16	c27b0e96-8a53-4700-b086-8c31ba149823	1	250.81	2025-09-25 04:45:10.98788+00
1ad578e4-51ca-4e27-9890-154212082bd2	f6a00ade-1778-4516-955f-dc8933a5c3cb	10e6b161-8e5d-475c-834b-75d4b52bacc7	4	220.45	2025-09-25 04:45:10.98788+00
e6b9dcbd-59a6-421d-bb1d-e3b4127bc63e	682fc0f5-6a01-461f-a358-1eb138eecc40	6559c77c-2a53-4b45-bc03-e0c7a3f2848c	3	297.03	2025-09-25 04:45:10.98788+00
4d1a3d32-86b8-4c05-9380-3e0849760682	6a97095f-68e7-4605-86ad-ef83593423e8	07788856-f12d-4ed3-b8a3-23b1df599b28	1	345.36	2025-09-25 04:45:10.98788+00
2ad19e20-8dd9-4f71-b05c-d2da08c10456	979af0fb-584d-44f1-b715-01bbbf2751e3	d2e095fc-f2ff-4502-8c47-01b10d503f0d	2	417.33	2025-09-25 04:45:10.98788+00
5c039a94-1089-41b7-b122-bc4a7d3d5ea1	f40f0728-62c1-46df-953f-e17e6e5aa6e8	5b6a34d1-72e2-4afe-9018-72564a2b22d1	2	237.88	2025-09-25 04:45:10.98788+00
a7e515a4-31bc-4d8f-b9c4-1fb20c996346	4022498b-124e-4e7f-a690-5c227b7ab3c1	8534c7b4-3f09-403f-bb45-3b6241ee860a	5	113.34	2025-09-25 04:45:10.98788+00
b9a2a81e-d13b-486b-93cd-b94297af30d8	a2d37279-1651-47c9-8964-bc58ba2f7766	51df7af3-1a5f-4802-a9af-7f8255ed2251	5	309.14	2025-09-25 04:45:10.98788+00
5ecf0921-c60b-4b3d-a91b-82203a367288	833ed813-6177-423d-9903-87634724c195	3ca94801-5e08-4acf-a654-692b8a559db8	2	315.90	2025-09-25 04:45:10.98788+00
3636b04f-ea88-42f3-9146-ddb6b880a15a	62b0727d-68b0-41e2-bf76-5411fa41c964	ccc32aa1-6f22-4243-a460-765f77b1372d	2	351.24	2025-09-25 04:45:10.98788+00
100c741c-63c4-4fe4-a138-8d80389f826e	0bcc7a69-5df9-48de-9a4f-fe430d477914	34d2c6d9-e834-4a6b-8969-d25320f48ac2	4	494.99	2025-09-25 04:45:10.98788+00
1dc8caad-1ddc-4a37-a844-419c0cdaec1f	53b1bc46-be1f-4a23-8d19-7b034efedf21	a0678678-c121-4170-83d4-ee3815ac836e	3	88.09	2025-09-25 04:45:10.98788+00
7cdf2205-da6f-4032-8110-e11e01079bc0	8f61c253-3137-406f-9f23-1cec641712bc	694c7c50-b0e9-4984-8f01-c8a7f4107cd3	3	117.85	2025-09-25 04:45:10.98788+00
381da518-7941-4dae-a58b-836de43541ff	70661215-9aff-4315-9fc5-027c065db093	75a131a4-f92c-4efe-ae1b-e8ec24c6de21	2	253.39	2025-09-25 04:45:10.98788+00
26427548-a5d0-4be4-8e38-051bb995246f	b57a7b71-d56e-413a-a83e-cd07d045446c	b472815f-8199-4a3f-9ffd-e41be8e606b9	3	425.04	2025-09-25 04:45:10.98788+00
b6c92fcd-2048-4d75-83b5-aed4893581d7	650c8ab4-804f-4409-bfa5-10b26f8610fb	7ed809ef-5f5d-4e5a-b537-acc589b4dfdc	1	455.27	2025-09-25 04:45:10.98788+00
5982ca92-8c2f-4728-9b1d-1d45b21b10d0	da1a2d3f-7a99-4c79-ae23-495545b71b44	075b7006-b602-4ea0-a2ee-4b07f65960ed	1	485.37	2025-09-25 04:45:10.98788+00
2308f3cf-b675-45ff-acb3-3e1f979d4b10	e4e5df46-295e-44cd-a7ce-bfd92050529d	b17791e0-ccc4-40a4-85da-6aa6f36bdbd3	4	493.11	2025-09-25 04:45:10.98788+00
06ea8ea5-12b1-43a3-a528-498baa279390	76dfa88b-3479-4d45-87ef-c3922d07a9fe	aabe6af0-655e-4c8e-b995-b30e52c78100	1	233.62	2025-09-25 04:45:10.98788+00
86e17a21-4a6e-4d1a-af72-c642804bd3e9	1efaa2bd-8989-499a-aa6c-8a7c21efdd7c	3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	5	354.37	2025-09-25 04:45:10.98788+00
c62647f1-48be-42ff-8dad-1fc59ba85e0d	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	7cb3179c-ca2c-4b60-88ce-300066649462	2	326.17	2025-09-25 04:45:10.98788+00
5362c89b-868d-4a45-aec4-bf10e019657b	28f7cb6c-a299-4812-bc5a-f10d3e260619	8d082510-2d25-45c5-ab63-09578063bd42	1	246.87	2025-09-25 04:45:10.98788+00
cca2cf88-d5cc-42ae-87b0-20c1a537a66a	eaccc436-9b93-4748-bf78-de7e26546665	456c24b7-60aa-4ea2-85b3-1e3f7254580c	2	342.15	2025-09-25 04:45:10.98788+00
a9c85cad-1afc-415c-b12c-7be2e9de83c2	53b43699-f881-46ea-9196-733d65a9f7f6	e9b4110e-ec56-4506-ba33-e895d567805e	4	484.30	2025-09-25 04:45:10.98788+00
c91d7182-94f9-4360-8d3a-e9c19cca4f9f	5dbfe65f-d09f-4de0-ac22-02eb460de7e9	36131294-16e8-40fa-94f5-5fcc003336f8	5	100.57	2025-09-25 04:45:10.98788+00
d72e564e-9062-4103-a4d6-2ce546c0ae9a	3ac2a44e-2d7e-4aac-848a-52a503161e85	cf28c8b3-fd3d-40d3-9c0c-c9990416d8ab	2	218.68	2025-09-25 04:45:10.98788+00
5066f033-8244-4b79-8bb0-2a5aaa35e4b8	58bb516e-b6ea-434a-a215-e28baf801d47	436eb316-6fca-43bd-9aa2-345440016680	1	350.35	2025-09-25 04:45:10.98788+00
6cfa2d00-ad57-403c-86a5-81b603c36733	22e2a4b7-339e-452d-a5bf-28c30443d691	7d3d4da1-e551-44f6-8f50-c062c0e368a4	4	25.05	2025-09-25 04:45:10.98788+00
e6cc639c-e5bc-4d79-b7fb-d1feb675b016	9c2f5e1d-1c89-4a70-8825-64f52270320f	fa3272e9-1d81-4855-8ec7-605895884f33	3	94.55	2025-09-25 04:45:10.98788+00
fa82a887-b83f-4035-9098-9a8a4565a17b	87758a86-90a7-4859-8155-e3cdc49e8703	890a7bec-aaa0-4a15-887d-23b8465a0605	2	346.50	2025-09-25 04:45:10.98788+00
2c74b1f6-c32a-47ad-83bc-87e8ec2df578	600ba42b-aaf3-41b5-9832-5e430c8d5c74	7a4e99c7-87df-4c6e-bbb2-2f181600c5b4	4	380.81	2025-09-25 04:45:10.98788+00
044f88e5-05f2-4499-8f45-0982c5dbba46	a1a24691-e582-4e5e-ac0c-18a20c4042b2	23117a1b-3b79-4376-aa5a-d428ebf47e2d	3	97.60	2025-09-25 04:45:10.98788+00
b4388b75-bf24-4f7b-836d-7c96f40cd18e	a2d37279-1651-47c9-8964-bc58ba2f7766	448bc7ba-131c-43e9-9061-b6a3d574e1ad	2	450.55	2025-09-25 04:45:10.98788+00
ad4fd882-8744-4bb1-8aa6-a8d9538044bb	e9b759af-dc7b-4a58-bcfc-747a2f9a42d7	c9268f65-058b-4a3d-9e71-0e83e2ad0f15	3	359.67	2025-09-25 04:45:10.98788+00
66888c4c-b262-410d-904d-09be0b8abf58	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	3dfb6349-7d5f-41eb-8139-ef0625f06a40	4	421.78	2025-09-25 04:45:10.98788+00
8553b5cd-e91b-4ef9-a46b-f3b9326b96e4	be4effb4-85e8-4d38-acb3-d641f0571686	eb42357c-8d45-4b4d-a2c3-fb8a9678f4ec	4	336.53	2025-09-25 04:45:10.98788+00
f9200796-19d6-4500-afcb-73e6cf7c93b4	5a475899-b907-47a0-9b74-d7a44c28c45d	eefa4819-2e8e-4277-ba5b-0c53a7f62851	5	245.46	2025-09-25 04:45:10.98788+00
db666bf9-b568-4596-8539-40986f4be3f7	6f88a97d-f175-40d0-b968-273c0dc967f5	fb808fd7-4048-425d-b811-16edd84f5cab	2	64.68	2025-09-25 04:45:10.98788+00
694b0077-2e2c-4427-9fc2-c74c00cf0f19	50e45178-6375-40c0-a761-6b0857248d24	7fbd0972-f9f6-4800-bfca-53cdc4950908	4	157.37	2025-09-25 04:45:10.98788+00
3f8a0900-c5eb-46b8-ac9c-882f8614f958	a37b9b0b-eec6-4fcd-89ad-c3f8d00e5983	dd70b6ff-2461-4a7e-b011-cab3e03d225e	1	98.73	2025-09-25 04:45:10.98788+00
73287973-ae51-495b-ba28-1ec7b401e31d	654b1ef3-ade0-4ed9-854b-2a1172e403e7	c80893b6-b638-4a83-b6ae-2b95ae123dae	3	246.66	2025-09-25 04:45:10.98788+00
86fdce32-c7f7-45f3-9956-6b41d66b2f84	b5e7ba07-b6b5-40ad-bf4d-22815c5079a8	075b7006-b602-4ea0-a2ee-4b07f65960ed	2	446.02	2025-09-25 04:45:10.98788+00
e0940edb-4666-458f-b7e7-6492d3ca8d58	4a921fd4-12af-44d6-a149-53dc0eca642c	9f52e2bc-980b-48d4-a9da-ca34a8a0e9f3	4	21.17	2025-09-25 04:45:10.98788+00
fc10ad5f-9daf-4ae1-9e16-d989fce06cde	9950f002-d400-4835-97fe-97a61c858a79	88bbba47-4ee7-4b40-a9ca-cc189c6567fc	3	239.23	2025-09-25 04:45:10.98788+00
90095fba-3688-4bed-b043-0eb866c69229	486d0262-fa5b-4a73-8fe7-29ef1b57e731	e842cc93-5510-42fe-999d-bb8d5a25998b	4	357.38	2025-09-25 04:45:10.98788+00
fac4490b-31d2-4bb8-be48-4509a9615944	b638ee2d-80a6-4ff3-b15f-3ea2dc1e3ac2	4f3ea27c-9d55-4fce-adc3-9197e9274c24	5	281.88	2025-09-25 04:45:10.98788+00
9ef60be3-e347-4e2a-bd7c-c13b3aeefd84	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	b4c7bf0d-33c0-444b-a161-17722da12c53	4	200.84	2025-09-25 04:45:10.98788+00
28de073f-c211-4614-9fb0-a74222f290e0	33d3b868-0f87-4758-a6ac-7c666e44d5be	4ae15b06-0477-4525-9c78-41e39e1bb3a7	5	3.70	2025-09-25 04:45:10.98788+00
0d1ee60d-252e-423d-9db2-b84ec5c37901	bba69bcd-4eee-40b5-aa14-769a0d5f71b9	ee50a987-173b-4b05-a631-2e8938684d91	4	224.59	2025-09-25 04:45:10.98788+00
32aebd3a-f540-4522-946c-c9ebdabc17cf	43807782-c0f1-4d10-adda-45c65b2e535c	6cde8001-cfd8-4c69-a25b-b5327083ce49	2	349.03	2025-09-25 04:45:10.98788+00
9e070441-281c-49a5-a2ad-f43d66498b19	335585f6-4bb1-4bb4-b668-b154bafedf8a	e6f4d25f-cdd9-44ce-820e-ca525faf879d	2	31.43	2025-09-25 04:45:10.98788+00
76b3c99e-04ea-47a1-8e86-99521778a576	8b759c5c-7c58-4431-ad99-ac9ba0655a5a	736e608f-f545-4d28-9da1-146cc3444701	2	207.14	2025-09-25 04:45:10.98788+00
5ff1936c-07c1-4b35-b13c-d15883705164	3ac2a44e-2d7e-4aac-848a-52a503161e85	6b9edb41-cbae-48d9-bfcd-10b65500fe3e	3	174.98	2025-09-25 04:45:10.98788+00
6c81c6a6-351c-45dc-b59c-f0393e14a227	b2d6eda1-2ce5-4f67-845a-e323428c087d	8cb7f3af-5fa9-4d37-9dad-e273105d1f21	4	325.01	2025-09-25 04:45:10.98788+00
4126eb59-b47e-43ad-8407-743f752bc6fd	5b807691-609a-46a0-83e9-4cebbe15a46f	77ece648-bed2-413f-9a8a-908f0a322192	1	22.38	2025-09-25 04:45:10.98788+00
48380688-dcd6-4c09-8627-dbd42d090351	92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	47d89e50-a931-45b0-82cb-b8323605b5e9	3	262.75	2025-09-25 04:45:10.98788+00
d1464859-0573-4e43-8359-8fc21b773ed9	19645d20-d291-441f-9003-ec78341bad89	254d53f1-8fa1-41e8-9dd2-3e5ad086ddf8	3	437.19	2025-09-25 04:45:10.98788+00
374cd458-875a-49a0-8617-cdc033ea67cc	8c30775c-7387-485e-a1e3-b48311e93820	aebf681c-0b04-4393-b847-9142c6e33b9c	3	405.64	2025-09-25 04:45:10.98788+00
30611635-03f4-4241-91c3-23a19752d733	31307789-e6b0-44ed-b9ce-bd7582743d87	fc54743a-619b-42d8-bd15-b78714ac9b34	2	406.62	2025-09-25 04:45:10.98788+00
b71be46d-92e5-4191-b43f-6feccb321639	0af99923-2595-4550-b08b-94209f0a6342	ab9dd606-ca63-4a8f-9891-92ff53c2b29e	2	360.41	2025-09-25 04:45:10.98788+00
df709381-14ee-4e2e-894d-02f606ce0abf	ae75b3b4-b870-4754-8880-04e837237db9	4022c33a-8863-4bc7-9ea6-7b2b2b830453	5	9.02	2025-09-25 04:45:10.98788+00
69c427c2-6ceb-4fd0-9edb-38bd27c7ceb3	065738ad-d13c-4646-8ee3-1aecc2e81ba7	a71d82ee-1a9b-4b49-acab-6a9345bd41a6	3	288.96	2025-09-25 04:45:10.98788+00
4f78eb3b-b6f5-4241-a2d8-90a1e54b55f1	2c11a5c2-9d3c-4be7-84cc-0155723a7667	3ff42df6-c9fa-4c31-a2f8-6ebe767ea616	3	493.72	2025-09-25 04:45:10.98788+00
01c6aa98-c6bf-4483-bcf8-12ed70452263	eaccc436-9b93-4748-bf78-de7e26546665	509da523-0dcd-4f76-97a1-ec35562b60cd	4	72.27	2025-09-25 04:45:10.98788+00
cfd9c08f-d2fc-495b-9fd6-d6093d88612e	8760072d-6ab9-49aa-94df-f2c7154017a6	b87cdb86-a8a2-41c0-9330-030ba505895d	5	78.92	2025-09-25 04:45:10.98788+00
42162904-b77c-403f-9fd1-2e6e11bfb950	cffac55d-8d01-4062-80e1-13d4c49696e2	c6a7491b-19f9-49df-937e-650f15262690	1	190.56	2025-09-25 04:45:10.98788+00
f5ffaeac-f5ec-4814-88c6-53e2c308ecda	525e96b1-c61a-49d0-ab04-1603c0ab49fc	687e4d57-6081-4e35-b469-4fa2d93cf1bc	1	151.85	2025-09-25 04:45:10.98788+00
2b34b385-2e6f-4d69-a021-1ac7fddc8d3a	acfe7c5f-68ab-475f-8cfc-b9134ff4612f	e747d9f5-9165-4d7f-a824-2539a1a64b08	5	299.07	2025-09-25 04:45:10.98788+00
3e68885f-aab5-4539-b36d-b91219007731	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	82a27f3b-a6c3-4c96-92e0-67949408e931	3	160.63	2025-09-25 04:45:10.98788+00
923dbdcd-1cec-4ea5-9fac-734d265e6edc	be27466b-77cb-4dea-9f69-0d9bdcf5bf92	c4fffe59-53eb-4074-b43e-f6e66f39dd92	1	426.65	2025-09-25 04:45:10.98788+00
7518cc72-44b9-4d65-a6a2-61ae22a0dc9e	3f0d00bf-dd48-4b8e-8fc6-bc3ed8c28d0e	b92b4fe1-631b-49a8-b192-df53ed3394c4	2	212.96	2025-09-25 04:45:10.98788+00
156f1650-b9e6-4d21-9822-f1a454d0850a	237a8e42-b8be-4a34-9107-99c8c32ce353	ea3aaa06-10a3-4c1d-9daa-a973be6ed558	2	102.41	2025-09-25 04:45:10.98788+00
ae0a14b9-9ec3-47ea-8d5c-c02202b978e1	654b1ef3-ade0-4ed9-854b-2a1172e403e7	235995d2-8eef-44fa-b69f-6db5f284b312	1	466.11	2025-09-25 04:45:10.98788+00
dc8253ad-a230-4410-9a32-3e4fd8a08cda	50e45178-6375-40c0-a761-6b0857248d24	f5531274-e84d-4232-8062-8f89904b0a9a	1	381.94	2025-09-25 04:45:10.98788+00
d0f04845-4580-4f94-9010-d81f5963720c	2d9d678e-0fee-44c3-a911-351552bd549b	7ea74fc2-3204-4bb5-a803-c5d2549a0bff	4	226.14	2025-09-25 04:45:10.98788+00
92c8a632-8478-45f3-9f17-c9ab591b91e8	bc21c33d-8668-4e92-aa3d-eea3658f8858	49d33abf-57a4-4c58-bce0-ab6a700fc07c	1	272.85	2025-09-25 04:45:10.98788+00
17e043f3-36a7-4181-9077-91e701cbb8c8	9a0156d7-066c-4adf-ab25-b639d2c85d2b	4f2223d9-a061-49a1-9c99-03119a08763e	2	467.15	2025-09-25 04:45:10.98788+00
1b2d4aac-66a3-4dda-bcb7-74a9246bbc92	81c6669e-9f7e-4d7d-b826-3b2032020e7c	436eb316-6fca-43bd-9aa2-345440016680	3	386.77	2025-09-25 04:45:10.98788+00
a9c047d4-7afd-48d1-8b7c-52f6602b2923	985f818c-1a1a-4d3e-8bef-69164308c435	95f40c38-c977-4239-aea7-21df5de3a7ea	4	201.17	2025-09-25 04:45:10.98788+00
05e91b38-1cad-4dee-bc55-30afd297ff33	16147c77-08e8-44da-87a5-8d30d54115fb	51df7af3-1a5f-4802-a9af-7f8255ed2251	5	420.16	2025-09-25 04:45:10.98788+00
0d666b73-6a88-49dd-8857-eeefb0f92ea1	ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	4df41507-2c3e-46fc-a67c-8c6711ddebda	2	472.89	2025-09-25 04:45:10.98788+00
ced5029f-6911-4ffe-ae9d-3a83ff37b5f7	9fac23ce-78e4-4547-9122-f8aa6edcc971	a52e2f4e-d07d-4aee-b531-714c0ad0d355	1	12.87	2025-09-25 04:45:10.98788+00
20f707b2-98f4-41ff-b753-2361f8c655a7	c9f84933-0b22-471e-bae8-cf205690ad63	fb9508a0-f78d-4958-a132-a0703fc46ab4	2	389.16	2025-09-25 04:45:10.98788+00
27c451c2-327c-413e-94b6-d26f25e95772	1112f024-0107-432c-ad8b-7f9ce6c17f15	9f46816d-e9aa-4dc8-9ce4-4fd5079b4cd6	1	269.75	2025-09-25 04:45:10.98788+00
a2c92ab6-c467-450a-a70d-08bf39edf793	7c190cc8-396b-452c-a86e-9a4b029eaa78	5e74dad6-6905-4071-9d02-dab19b8d4776	2	284.21	2025-09-25 04:45:10.98788+00
434b09cc-e63b-4d2a-b285-32e96efa093b	525a282d-0f8d-4f23-b0b8-d68235fe2da1	27e2e9a6-1d22-41c0-976d-dc7ffc253d4e	1	36.53	2025-09-25 04:45:10.98788+00
bf0525fc-e339-45a8-85b9-4194ed4f6096	2cf249cf-6d5e-41af-8681-77dc129d09ac	9ccc6ad8-2ff1-4339-9f23-c030c21a5f27	1	455.76	2025-09-25 04:45:10.98788+00
6f5e0e8a-12a9-432b-a3c8-ac0f98d7c340	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	99e055ec-e67c-4dac-9f98-2d14cc4b759b	1	389.70	2025-09-25 04:45:10.98788+00
28acd3d2-ce6b-440d-8036-07e9c30044a3	9df8a799-2e52-489a-8914-c5a40ffe2506	339eb046-d875-45ae-96ea-c973f19333ef	4	189.84	2025-09-25 04:45:10.98788+00
57569f8e-17ac-4aa1-a937-5a4199b24136	92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	5468bad5-508c-4ba9-8820-354efb50b6ec	3	319.29	2025-09-25 04:45:10.98788+00
ceaabd7c-bec0-427b-8103-3659cc202d37	1bd0dd4c-aaca-4794-8e97-b74ba449fd35	0c131e48-2bf1-402a-a2de-fb03d45a6173	4	386.82	2025-09-25 04:45:10.98788+00
1278bce4-0cde-4b5a-b430-c608eb52ab8f	1112f024-0107-432c-ad8b-7f9ce6c17f15	91dc74ec-7d5f-413d-aabe-aea64403006a	1	214.79	2025-09-25 04:45:10.98788+00
b3ade349-2e68-42f0-bdd5-46b420784fca	69b95624-5ea7-46b9-bf49-70f8c2204162	94a4b3aa-2cf2-4f79-9bfe-1e59896eacf0	2	20.48	2025-09-25 04:45:10.98788+00
a30bd6e7-7b33-4a61-aada-47144cbc6f7d	5b807691-609a-46a0-83e9-4cebbe15a46f	647b0808-e8eb-4167-88e6-106f0af62c7d	3	350.80	2025-09-25 04:45:10.98788+00
b9997a93-4b36-4c6f-8105-a2678d9688c6	1276fb6d-6b59-42ae-bbf4-b93b6c728ad2	0a866c4a-8b4b-407b-9eee-d41b65767b6a	5	338.33	2025-09-25 04:45:10.98788+00
dd62404c-5f7e-41a5-b227-0568e9d84f62	8f61c253-3137-406f-9f23-1cec641712bc	236c0db8-4326-4c16-9d7c-03d2f5c787ad	4	335.60	2025-09-25 04:45:10.98788+00
1d52c4df-3a1e-4e1e-9310-09a06561f91a	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	b19683b3-ab17-4746-9e07-440b6db949fe	2	171.12	2025-09-25 04:45:10.98788+00
1d90c135-4ae7-47b6-a93f-531e3adc33d7	8b1d9977-e8da-490a-8a9f-b67c3df4199a	37fa7e9d-79bd-4428-8772-04e080033aa4	1	354.29	2025-09-25 04:45:10.98788+00
e8b8358b-f5d2-484f-a82d-d5e15715a87d	19645d20-d291-441f-9003-ec78341bad89	54a4c96d-3ff9-4d8f-9041-7ab5cd9e482f	5	88.77	2025-09-25 04:45:10.98788+00
dd0c1f19-6e5b-4d71-a71f-20b4a9c61378	5dd960b8-4a7c-4113-82c6-7cb8ebcdda54	235995d2-8eef-44fa-b69f-6db5f284b312	5	314.28	2025-09-25 04:45:10.98788+00
9a500826-bfa8-48e4-b2b8-244fec937e6c	be4effb4-85e8-4d38-acb3-d641f0571686	7fbd0972-f9f6-4800-bfca-53cdc4950908	3	260.31	2025-09-25 04:45:10.98788+00
60f9524f-b9ea-47d2-a4f9-14c7f12dfbb2	db1badd8-71cc-4a88-a06d-abebe02ee7fa	e7d7d5bd-c4a0-4990-affc-79d875c9bf9f	5	284.82	2025-09-25 04:45:10.98788+00
f5a1c575-8e9f-42f9-8626-8d1a6f2c2351	190dc437-aabb-400c-843c-7ab83c64dae0	8bc06db5-1714-4c98-8785-6d14c39abbba	4	211.04	2025-09-25 04:45:10.98788+00
06f7b395-b790-4efa-bccf-cab32fc80d06	5dbfe65f-d09f-4de0-ac22-02eb460de7e9	b0636ba5-8172-44fa-814e-56fd191ed72c	1	73.80	2025-09-25 04:45:10.98788+00
050dc70f-5145-47cd-b7dd-c1f86c8af47a	ef4fce6c-c216-4bf3-a10a-15d6bce77f94	af2a2d7d-edb0-49b2-ad2a-dfb0d68b822e	5	211.77	2025-09-25 04:45:10.98788+00
9e4ed34a-c13d-487c-b9f9-4a865efda3dd	50e45178-6375-40c0-a761-6b0857248d24	b2df4543-5ce6-47fc-b9d3-38ea3098e39a	4	253.61	2025-09-25 04:45:10.98788+00
33a28873-fd27-4cc2-b97d-ccf9ac9dc48e	76dfa88b-3479-4d45-87ef-c3922d07a9fe	f6d9030b-fce6-4d21-a869-e7adb7f82cc1	5	347.93	2025-09-25 04:45:10.98788+00
080fee3e-62ac-4b9e-a449-3ceec13bcd3c	dd00c93f-80d8-4575-b3c4-4df3733a2afe	e22d5a6e-1385-49b5-837a-daf9c2e25836	4	160.88	2025-09-25 04:45:10.98788+00
19a6ddf5-80b2-4f14-b6bb-8fba654d7ffd	84929b25-b2ed-4d34-bc13-3ec73853b06d	1d73ab87-99a5-4dfc-ad19-1f06460b414b	5	330.87	2025-09-25 04:45:10.98788+00
674f5572-2226-4ad3-ab13-daa69067344f	e9b759af-dc7b-4a58-bcfc-747a2f9a42d7	8990ec74-9c29-4456-b1bd-9c648276ba1c	3	38.15	2025-09-25 04:45:10.98788+00
6e4a05fe-d943-4a74-85ea-40b39c4af0ca	4efb1ecb-9666-464a-86c9-8f5d5776d441	f676b696-78f3-4a4f-a04e-cfc9d92a2157	2	274.40	2025-09-25 04:45:10.98788+00
c50886e4-980b-4db1-bfd2-d588c081c19c	d2859681-703f-40dc-8ab7-5792acf0c507	cd6571a9-241c-4ed0-9d0e-e22f63583e41	3	465.10	2025-09-25 04:45:10.98788+00
cd4af943-2355-4225-8663-ba98e6d0ddac	a352ecfc-6105-4f71-a5bb-32a178c1384b	13802b08-733c-4d8a-b132-ac684eda7218	1	162.25	2025-09-25 04:45:10.98788+00
974bf3fa-c1da-4c27-81d9-0af5fb1215bd	9f244e1c-9b85-4e5f-826f-ef37efe2ad1b	bf052005-a645-4f23-b7e8-9b4c039e3022	5	440.01	2025-09-25 04:45:10.98788+00
a5b11051-d82e-4c96-acc4-ba89bd550c06	22e2a4b7-339e-452d-a5bf-28c30443d691	b885d6a5-df0f-466d-94c1-c2f270550b76	1	59.91	2025-09-25 04:45:10.98788+00
095a842b-5389-4a44-9e32-55f9db0b78f9	ca2f4b3c-05d7-468d-b840-0460d1a6c950	b0533cb2-0937-48c8-8e50-6ce525b11874	3	339.95	2025-09-25 04:45:10.98788+00
09e6fadb-906f-492c-a99a-54997a25629e	8f1588ed-8fee-4027-b0a1-e1b5a360dd66	0c131e48-2bf1-402a-a2de-fb03d45a6173	4	250.24	2025-09-25 04:45:10.98788+00
efcd5f63-f4c7-4662-9a1b-b6e7bb9b8794	ea2d8bd2-3631-443f-821f-7e6c24e43857	da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	4	349.69	2025-09-25 04:45:10.98788+00
cee4ed10-54a7-48ef-b55f-953085038991	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	c466f5d9-7b18-43d1-bf0f-3a425644e69e	5	83.53	2025-09-25 04:45:10.98788+00
d82c3cdc-aab9-4cbc-a44f-6d2596efd18d	d8c3fbc5-76e6-43eb-9a9d-005674e30afc	923c943d-497e-48e3-b9e4-7c33df1370c6	1	168.86	2025-09-25 04:45:10.98788+00
26588320-c526-4d30-bd97-039ee43c0f9a	f548ae40-f469-4a98-9ab4-36bbb21b38ee	2dd75261-4657-4253-9efa-9623252edc34	3	391.68	2025-09-25 04:45:10.98788+00
c3bc9fd0-8456-4010-b52e-7b18c7935af8	44950334-23ad-47ac-8466-4f67d1c04b27	f6831c4d-01a8-4471-ac47-b4de6fd26c34	4	221.24	2025-09-25 04:45:10.98788+00
5104eea8-3bdd-49ee-8617-9724c32cdfd8	af0974a1-70cb-4884-980b-f4b4078e936d	d0568fad-6695-41ab-b16c-fc9c47ccc21f	1	483.90	2025-09-25 04:45:10.98788+00
e1d7ca70-ac3e-4623-b23e-a173c7ec4357	0acee6b5-430a-464b-97ba-9e6e9f750cee	1c904265-71c1-40c9-8dcf-faa1f9f075e1	2	188.88	2025-09-25 04:45:10.98788+00
89750e70-e995-45b7-bd82-070252f08621	223005b3-31fa-485f-b021-606d097d451d	736b283a-1808-46e4-85f3-a44cd7ac8a3f	2	76.71	2025-09-25 04:45:10.98788+00
a3fc10d8-06d6-4ff1-b7b0-52411032c413	ec6ec66b-e8ee-495e-8948-2b9be9305307	456c24b7-60aa-4ea2-85b3-1e3f7254580c	2	60.04	2025-09-25 04:45:10.98788+00
bdd3fd73-2aad-4092-9599-bdaf04a07d7e	df8d6ba7-5a0d-4ceb-961e-e687721e7c20	f123ec31-3ce7-408d-87d0-72098804ee24	5	362.26	2025-09-25 04:45:10.98788+00
e643ed57-f622-49ec-bb1e-3c2ddacd967e	ac240e7d-0011-4233-8958-dc5c19352f3b	625de24b-bb6b-4771-bfdb-19cfbe0bffd6	4	447.02	2025-09-25 04:45:10.98788+00
141ec132-912c-4da4-bbfc-ba1016c8948e	1bd0dd4c-aaca-4794-8e97-b74ba449fd35	809b63b7-aeaf-4496-bc99-0694fe605c94	2	125.89	2025-09-25 04:45:10.98788+00
cd476adf-0273-43af-aa73-432616e6950a	b57a7b71-d56e-413a-a83e-cd07d045446c	e3f360dc-ca43-4d24-9063-8c9734ff9178	4	452.90	2025-09-25 04:45:10.98788+00
06531158-c578-40d9-a189-c2b45b4fa913	6ec08346-23fb-4c08-8fd8-389c0a163beb	3bc7ded0-4552-4ce6-b0da-4b564392aef0	5	155.08	2025-09-25 04:45:10.98788+00
c3408e7f-f18f-4793-9e11-d18c1a1331cb	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	efa90324-2240-43be-ab36-0a1bc0e32ce2	4	210.02	2025-09-25 04:45:10.98788+00
aa8a66fe-6ae7-46bd-a0a4-3e50f5877e1b	643042eb-8aa7-4861-b2d8-ea84a8985a0e	5beaf691-57aa-4d6e-99b4-fd12a65a6751	3	66.29	2025-09-25 04:45:10.98788+00
63e68692-fed9-4834-83e1-740f6d62201c	696828dc-8af1-4e10-a1b1-85d38f508324	2bf3df4a-c939-46eb-b584-d52d8b3e1570	4	109.29	2025-09-25 04:45:10.98788+00
9dbc1ff5-ecef-4a8c-b9c1-9fe2a1ec3acb	7ac3648f-0fad-47e7-b559-704d4eded058	88a8d5a7-169a-448d-a9df-7e12953611da	3	323.88	2025-09-25 04:45:10.98788+00
ecd981f7-e318-442d-82f5-576787b7b586	98deafff-495a-4fc8-bf3e-5f7961607766	30381c58-d8b1-47f4-a6a4-2c62bb899633	3	135.34	2025-09-25 04:45:10.98788+00
85413edd-d17a-4423-8467-9c6c59b635ec	486d0262-fa5b-4a73-8fe7-29ef1b57e731	e22d5a6e-1385-49b5-837a-daf9c2e25836	1	194.36	2025-09-25 04:45:10.98788+00
6be1067e-5695-4182-bbd7-f1236f12a46d	4c168f8e-9007-4772-959b-d039729ead3c	2c94525c-a26e-44d5-b79e-9a20f90959d6	2	160.88	2025-09-25 04:45:10.98788+00
40087dbb-8397-44de-8de9-3b2714c47d96	1546f566-2571-4c5f-8f78-6bba8e0afe9f	6dbceb74-0c47-4565-bfa3-dcb7d954d612	3	280.02	2025-09-25 04:45:10.98788+00
42a3a848-6717-40e8-9e2a-f350cf60b635	84a0b61f-5665-4166-9a16-016ce275479b	36a6c226-7e64-42cc-a129-41e2439fdab8	5	291.16	2025-09-25 04:45:10.98788+00
ba1a5c12-c601-4dcc-9a2b-d5da281cc8fb	34112ecb-61af-4dce-8e91-ebcfa78948b9	cda83ed8-2806-4857-9275-256a46e498b4	5	488.85	2025-09-25 04:45:10.98788+00
f58b88f7-9b04-41e1-be4e-9e381533d22d	20ae85e3-8269-496d-8df3-6389013ca41d	6631f6a7-c5b2-418a-a2a7-23c2d463ed73	1	447.81	2025-09-25 04:45:10.98788+00
a5fe70eb-8753-4861-96fd-af9f0c4c7d92	aa571a5a-d2c2-4cfd-b214-badd309a7bce	ef112dbd-c95f-4e0e-b1a2-d607ddf164b6	4	71.91	2025-09-25 04:45:10.98788+00
309b78f2-b528-4bae-99c3-e4654ca15f80	c2a37430-7f62-4c51-88f2-25655b1f982a	19df3a58-27fd-4b03-bb58-f2542acecd7e	1	229.93	2025-09-25 04:45:10.98788+00
21088fcd-2f15-4c10-9e77-be3d5f3e13f1	6a97095f-68e7-4605-86ad-ef83593423e8	34d2c6d9-e834-4a6b-8969-d25320f48ac2	3	473.45	2025-09-25 04:45:10.98788+00
f47ee643-790c-4160-abf9-ffd3264403e5	08607ad3-480a-4945-a934-b96d6ea030fd	7271e834-4e75-469d-9037-7e8aacd4eb1a	1	390.69	2025-09-25 04:45:10.98788+00
30a31212-d3a8-4eec-b013-f182103621b2	bceef424-4b29-47c2-8409-f5b9897e681c	37ee20d3-3e40-4763-a4df-162a82d4ea25	5	208.03	2025-09-25 04:45:10.98788+00
144ebdab-c6d0-4f46-9a73-d54f30a475f1	b771a9e0-f6ad-4817-8a83-791d3b689769	5f031354-7104-4787-8509-9f923d36b792	3	447.84	2025-09-25 04:45:10.98788+00
802fa8aa-a8d1-4239-a32e-4f0eca3fc21b	9fb60e99-c303-4b61-99fa-dbabe0298b73	268710b5-2300-4548-bad1-47513dbf13d0	4	323.31	2025-09-25 04:45:10.98788+00
85b88ccc-c0fe-4c39-b68c-93e4774d324d	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	39df2403-7926-436b-b335-1872a3876a90	2	113.45	2025-09-25 04:45:10.98788+00
5d5ee346-68cc-41a8-9482-675422e9a07c	1276fb6d-6b59-42ae-bbf4-b93b6c728ad2	03975248-b6dd-4fd1-a2cf-aea26f94aa36	2	346.37	2025-09-25 04:45:10.98788+00
45abeda9-4cf0-4f39-8945-a160b588e2d3	2da66b6f-1471-481d-8df6-aece86f2de90	eb42357c-8d45-4b4d-a2c3-fb8a9678f4ec	1	72.11	2025-09-25 04:45:10.98788+00
13a14505-d154-4d49-b574-c4143aa45206	db1badd8-71cc-4a88-a06d-abebe02ee7fa	589f5188-96bc-4404-9cfe-78d6eae50831	2	231.41	2025-09-25 04:45:10.98788+00
179ee25f-fff8-4d35-8132-6a4a3cd0f8f4	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	4d3a9cfc-9faa-4cb4-9925-2ef1401088a9	3	338.58	2025-09-25 04:45:10.98788+00
0037040f-62b1-4fdd-bbb0-586782b08355	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	0fd70815-cee5-470f-8b7b-37c3fbb1b4fc	4	92.63	2025-09-25 04:45:10.98788+00
67246fd2-2cad-44fc-bbd7-06aa17da171c	3115f2cf-6015-4bee-9d03-20bba3f38819	b40df738-023f-45b3-8b08-7f8f9f66f600	1	65.46	2025-09-25 04:45:10.98788+00
a7c15882-c634-4c00-99f4-fa5186f2e999	3ec83e75-3a39-4fa9-a28d-02fb91767b3a	00e4225a-d885-4cd7-ae38-e8ab0073616d	2	306.64	2025-09-25 04:45:10.98788+00
aa76b13a-16bd-45ef-a6c8-e5abd6dee9d3	ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	0ddcc716-22b8-4b71-8deb-24ad5844df78	4	322.74	2025-09-25 04:45:10.98788+00
763583f2-2e9f-4e11-844e-3d3e31dc166b	f68538d9-d585-415e-a966-1e4879e673f6	3f697690-af3d-4376-b1c4-8374dd413173	1	339.72	2025-09-25 04:45:10.98788+00
3cc4edd3-5c7b-462f-9e78-cc4fd9cd8dfa	616743a4-8c7f-4bdc-9b58-3e546b2bc63a	7e793ed9-4bb8-4eb1-8ac8-8fe73fe2d288	1	171.95	2025-09-25 04:45:10.98788+00
ce86151d-7ab2-4247-bb07-3478cb801804	d2859681-703f-40dc-8ab7-5792acf0c507	7cbac387-ba27-4696-9b12-08dbbbe2d631	4	15.11	2025-09-25 04:45:10.98788+00
12046d9e-a20b-4da2-a913-a605abd38e4e	5c366199-d746-4aac-877d-e8340442d6c2	6b9edb41-cbae-48d9-bfcd-10b65500fe3e	1	168.27	2025-09-25 04:45:10.98788+00
b7d4e57c-db1a-4a42-a169-d824fab6b29c	90c3d581-e6d0-4778-94d2-4da99a0eb10c	b9fd3dcc-1e9b-4a16-8dd5-741e242f4702	1	310.61	2025-09-25 04:45:10.98788+00
cf399fab-133d-4a70-8eb3-6ba19061b61d	4c168f8e-9007-4772-959b-d039729ead3c	4117ed09-68b5-4cfe-aed2-7e4d8e1b0f12	1	246.52	2025-09-25 04:45:10.98788+00
bf933dc9-5564-40d1-bdbf-eab52d4b9572	59893b10-830f-45ae-ac1f-450959f712b3	ae58abdb-65e1-4b29-af25-1ec389b777b3	4	70.28	2025-09-25 04:45:10.98788+00
767b0373-df55-451a-bb1c-176544c992d9	43807782-c0f1-4d10-adda-45c65b2e535c	7e00c2fc-5dba-44dd-b87b-7aa2e087fedb	5	33.27	2025-09-25 04:45:10.98788+00
c72f6d87-16e4-4311-bd04-69d2ef025e23	9c673189-3650-497c-bb8e-cea432195f24	9e4dc57f-4b97-4742-bfd1-6fdc51803678	5	242.18	2025-09-25 04:45:10.98788+00
a8f1af6d-c4ca-4f8d-be89-e44a33cb520e	e9d423c3-dad6-43ec-89ab-87021d056af8	b74ed3cd-03cd-4d1b-8989-9c46bf8a230e	4	444.75	2025-09-25 04:45:10.98788+00
8c9be1fa-9445-428a-972b-53feb4482c51	06689776-cf7b-49a7-9af2-a1c7e1943392	840d1b24-37df-4652-9293-a94e8844f668	2	401.80	2025-09-25 04:45:10.98788+00
a3acbd8d-3050-4379-b9f6-b1a4314e6cd3	2a21d19d-fccf-4bb9-8eaf-a5ec16428fc0	3fac4767-44ef-4993-ac72-c5381feb5e83	2	136.64	2025-09-25 04:45:10.98788+00
dcee09ad-3e1a-4ec5-8c27-fc9471e820a8	833ed813-6177-423d-9903-87634724c195	cd862f44-36df-4ad5-b816-1a941066779c	1	432.37	2025-09-25 04:45:10.98788+00
9b6e7f5c-28ec-483e-886c-6610628d528f	44950334-23ad-47ac-8466-4f67d1c04b27	d0568fad-6695-41ab-b16c-fc9c47ccc21f	3	156.66	2025-09-25 04:45:10.98788+00
2f5a8f6a-7244-4ec3-851f-b3100debec98	9cea1810-1a51-4ff6-95d0-7b290b81268d	3ab25fee-76a8-4cc0-935a-3f98460ff7d7	5	285.14	2025-09-25 04:45:10.98788+00
08a1dfc2-f0c5-4117-9be3-46e127f91b28	ec6ec66b-e8ee-495e-8948-2b9be9305307	c0c1d570-83c0-4529-b3ae-cf0b55eeee68	2	38.14	2025-09-25 04:45:10.98788+00
3b55bfe9-4852-44c2-90c2-642364a7d29f	2e6c84e3-29ac-4202-a0c5-96b9b1861228	e1e9b987-57bb-4fb7-8513-4d1fae8f8f4e	4	151.27	2025-09-25 04:45:10.98788+00
7a4e1143-3d16-44a7-b98a-1f9cd943429a	84a0b61f-5665-4166-9a16-016ce275479b	751ee4e4-ff8e-4d55-ab7b-05bcd323576a	3	186.72	2025-09-25 04:45:10.98788+00
4c0ce4c7-b787-41e8-b913-06f6a5acb746	b771a9e0-f6ad-4817-8a83-791d3b689769	75423bf9-9773-4e43-a7dc-869dd3830e92	2	312.92	2025-09-25 04:45:10.98788+00
8578e526-793c-4aa7-ad7e-3e71127e2907	21f96094-3dc8-4573-87ae-01e98c850b79	2a822dd9-fd77-430b-bd12-019d4b26f9b0	5	373.65	2025-09-25 04:45:10.98788+00
3028e8d3-a57e-41f5-823f-d4a26a73c76c	64bf5e36-4ca9-4761-a7cd-3794329e2424	430f6e5d-6537-4ebb-96e5-aeb0777827fe	3	254.90	2025-09-25 04:45:10.98788+00
a75d7c7f-4296-421d-8338-7cf7046e0933	99f9ec85-3a72-4110-be59-d9afdefe21d5	8f1f4898-74f0-41a2-907a-0e82e0cb2ed6	2	133.65	2025-09-25 04:45:10.98788+00
68cf5041-18da-4502-b3a8-a4e268b6757e	237a8e42-b8be-4a34-9107-99c8c32ce353	c2ac6955-d1f2-40e5-866b-384d2d77dcf6	2	390.63	2025-09-25 04:45:10.98788+00
0b8ec980-d9c4-4173-9198-ca478241ec3a	ae30053b-e2c9-4893-891c-172cc2df8766	b4ab738a-4c07-419d-b547-152d5a282bd5	4	77.23	2025-09-25 04:45:10.98788+00
04b58728-ee80-462b-8157-613c39cd1f6a	b2d6eda1-2ce5-4f67-845a-e323428c087d	343f5f5d-0ebe-403e-bad7-43caa47b701f	1	295.05	2025-09-25 04:45:10.98788+00
443b9587-14ce-4034-b748-afa5db319246	948cc5b6-87b2-4ce6-9dda-289c7563bc38	841799a8-7865-4d0f-8067-48fbbd7e5e7e	2	151.30	2025-09-25 04:45:10.98788+00
8cf487b6-4825-4887-bbd8-54fab1f76999	08d6ac3f-89dc-42dd-81eb-30cfcced5621	64979d06-6350-48ee-9931-f5e895d3ccfc	2	265.05	2025-09-25 04:45:10.98788+00
4322a529-a56a-4b3c-84f3-53876fbc4501	6687abd5-7e8d-4f93-8872-ed7973c82067	a768cfda-4d7b-499e-a7fe-501f68bb8241	4	160.58	2025-09-25 04:45:10.98788+00
1bd81b51-0286-44c9-a22f-28e261c04831	6ec08346-23fb-4c08-8fd8-389c0a163beb	4e310021-e795-48f8-95f0-c106494cb015	2	27.04	2025-09-25 04:45:10.98788+00
e86622f8-c172-4dd7-8f3e-851242f59549	20ae85e3-8269-496d-8df3-6389013ca41d	6c777294-54b5-4d1c-935d-a79ab27efa74	5	440.03	2025-09-25 04:45:10.98788+00
ca4d91ac-6e4e-4617-8278-1ed9b9100b2a	b3aab42c-57e3-4688-b683-3f401362cc95	2f0aead7-7384-4467-bf56-bc0e7d8ef4d8	4	12.53	2025-09-25 04:45:10.98788+00
d4ae756c-0728-4a1c-a4ac-1e1d8f38308f	55f039e3-7cba-43cb-a899-44f7c7649d77	841b7e04-50c4-472b-a915-2f0e108cce3d	1	331.92	2025-09-25 04:45:10.98788+00
fec2bac2-26fb-46a3-9287-2c68fa25561f	f240e3ce-f856-4de2-803c-b9ed09a26deb	6511939c-616c-4cdb-8268-d754d2c03d46	2	460.98	2025-09-25 04:45:10.98788+00
90581571-aeb3-4c08-9af7-1b085ddf2436	43807782-c0f1-4d10-adda-45c65b2e535c	8bc1489d-cd37-4ab3-ad35-fb2e2565255b	1	160.45	2025-09-25 04:45:10.98788+00
818219c5-9ca5-4be1-bfdf-11662760a1e2	3ac2a44e-2d7e-4aac-848a-52a503161e85	a1a72c5c-cc81-4a56-bac4-1faf14818022	3	87.94	2025-09-25 04:45:10.98788+00
475344b2-279a-4be7-b76d-ac3325b06698	68251dab-f3ed-487c-89d2-3bb3ce61cb51	a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	3	456.68	2025-09-25 04:45:10.98788+00
19bd9c1e-ca48-4c6c-b04e-76b09b8e958c	f1c21b5c-0aa3-4999-ac25-c8b15ccafad2	841f34dc-a86e-4f1a-9c41-0a66ae0b29c0	5	453.53	2025-09-25 04:45:10.98788+00
b073c6ed-ce96-4443-b116-991efb5043f5	b771a9e0-f6ad-4817-8a83-791d3b689769	d4c396bb-72ad-48bc-b57f-ae66c7d8d035	1	119.23	2025-09-25 04:45:10.98788+00
933a992c-95d1-4f7b-ab4d-c0a7d8d177ec	331101e6-e9a5-4b49-8f31-7b10f6879b06	9ea6300d-c39a-4e7e-991c-c5772ee95795	4	439.68	2025-09-25 04:45:10.98788+00
67dbeb5c-b65d-4e3d-883c-b9d97e76b9d1	2092e299-3ede-49dc-baa8-6942bbfbae4c	df9fc1d8-9368-4d8a-9820-493051171d87	4	317.69	2025-09-25 04:45:10.98788+00
08fbcf27-c95b-4fb1-9e6d-4b84605c3100	dfdd0300-e01c-45ca-bd58-194ef077debc	6dbceb74-0c47-4565-bfa3-dcb7d954d612	3	15.77	2025-09-25 04:45:10.98788+00
2cb0a9a1-a141-43b1-b653-15cd87abe6c1	ccfd36b5-9867-4357-918e-775b6a13ae17	fd48c418-c44d-4293-95bc-1585c54fe71f	2	191.49	2025-09-25 04:45:10.98788+00
18008b21-5f32-4dea-8804-b8b7088971d9	985f818c-1a1a-4d3e-8bef-69164308c435	1a99c802-d54f-410e-a2bd-ba389dbd5495	3	400.19	2025-09-25 04:45:10.98788+00
d2351ca6-7c79-47b5-b04b-bac798ed69d3	24a95a0d-6617-4dd2-976f-8bf79ff0e903	ac4cf314-3822-4cad-9489-1c3a4e011cdb	3	474.58	2025-09-25 04:45:10.98788+00
84317ad8-d91f-4055-ba44-68a759518578	59d3ce40-a157-4ff2-9d4c-bcf6c0a21116	d92462f4-d0f9-45cc-a17e-8a0abc992ccf	4	345.17	2025-09-25 04:45:10.98788+00
0c601f1f-4f3a-4fde-823a-97b943d9428c	833ed813-6177-423d-9903-87634724c195	6b5ef984-fc98-49e0-871f-b7186607c3d3	1	429.42	2025-09-25 04:45:10.98788+00
7897c3ee-62dc-4630-bca9-ba085316976b	9ff9f917-e737-4cb1-9c2b-d3fc2a6dbeaa	eea66eac-ec69-41ad-9f09-bda437c36500	5	40.09	2025-09-25 04:45:10.98788+00
7b5f7af4-cc57-4f22-bbc1-4ab595bbba4d	28f7cb6c-a299-4812-bc5a-f10d3e260619	c242c336-4820-418f-b8c8-c1069bd15327	4	298.67	2025-09-25 04:45:10.98788+00
433a14c7-64d3-4fdd-8db5-91f6c38755d3	56982c1e-cb17-46f5-8ba1-bd1dd4e24e28	301b960f-1b4f-4759-9bb5-5f294838f218	2	322.41	2025-09-25 04:45:10.98788+00
4ea4c838-a5aa-40ef-b40d-4a19a8044777	5b807691-609a-46a0-83e9-4cebbe15a46f	6199b152-5290-426e-9731-ae4cde532bfb	2	246.93	2025-09-25 04:45:10.98788+00
e7dec5a4-30a1-4ae1-a413-82538829d469	58bb516e-b6ea-434a-a215-e28baf801d47	37ee20d3-3e40-4763-a4df-162a82d4ea25	3	178.62	2025-09-25 04:45:10.98788+00
c60d3037-7446-4954-9340-d840b56ba3c2	524c4a55-37d7-47c5-af46-c34b7a7f253f	b40df738-023f-45b3-8b08-7f8f9f66f600	4	23.08	2025-09-25 04:45:10.98788+00
8eaafbc0-f76e-4aca-9245-bd9202e59cec	50024ba2-9983-4e14-afaf-00df3f238341	27a57e29-9044-4910-8ceb-6e40fe7b52c4	1	366.66	2025-09-25 04:45:10.98788+00
a40775cc-1e74-4bd1-a624-f94e93ce9066	effa6386-eb68-4670-abfe-9def4aed1765	a249e695-7d78-464f-a3b1-a328a4cf7e38	4	258.54	2025-09-25 04:45:10.98788+00
d039ddf1-c091-40c8-8f6d-acc011162aa7	696828dc-8af1-4e10-a1b1-85d38f508324	24e41afa-9161-4715-9372-14de21ddfa1f	3	454.89	2025-09-25 04:45:10.98788+00
2c2e0c0c-e788-4bc4-b9f3-9ad7e9086404	a40eba37-28eb-40a2-b5e7-fc34abc8d3d5	edaedf56-d5e6-4471-90df-e6cf1e028976	5	7.34	2025-09-25 04:45:10.98788+00
ca3f19d3-b8b7-4c54-8682-813e215e0bee	76dfa88b-3479-4d45-87ef-c3922d07a9fe	ef112dbd-c95f-4e0e-b1a2-d607ddf164b6	5	67.13	2025-09-25 04:45:10.98788+00
7c17bd1f-0843-4b7c-a386-82a85601acc0	f32b1168-47b6-4aa6-8db0-4a813f1f4642	5fb10895-43ae-44c9-8307-fcc6ea017588	2	380.90	2025-09-25 04:45:10.98788+00
63ac7056-4a1e-4055-b827-a544cbbcb55f	fbf4368e-b376-40ff-8f59-8fae4a89bb25	94de5b8b-bf70-4e04-b88f-60fa5052210b	4	492.52	2025-09-25 04:45:10.98788+00
53bcde8d-8f2a-4b34-8b18-c5b6a2b59a5a	db1badd8-71cc-4a88-a06d-abebe02ee7fa	5579eec5-79c5-4572-b6b1-dffcf872bf64	5	406.37	2025-09-25 04:45:10.98788+00
8a26c1a9-0329-479a-b407-c7c818cb817c	74fc3cad-5d31-4f86-96b7-b22859970376	3aa4c585-7e17-4118-b80e-cbee745cd4d6	4	270.76	2025-09-25 04:45:10.98788+00
34a277d3-d8f4-4060-9eb1-211a54abd308	1d9052a7-123b-4c23-925a-27bb369ebb16	841799a8-7865-4d0f-8067-48fbbd7e5e7e	1	299.53	2025-09-25 04:45:10.98788+00
8800dbca-757c-4207-871f-e7661ca9ebb9	c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	43fdac1c-18e0-4126-8bd2-e31c1760f22b	1	41.10	2025-09-25 04:45:10.98788+00
c0797dc9-14bd-4c39-9b05-717961a14684	84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	3ee86da7-002a-43b1-a506-07f151f86be2	3	359.36	2025-09-25 04:45:10.98788+00
5c19e474-8e39-45ef-abaa-87e2078ebed0	70661215-9aff-4315-9fc5-027c065db093	3f930a17-699a-48b2-9ca2-245e31268823	4	321.78	2025-09-25 04:45:10.98788+00
e63d4e22-0dd4-4ab6-819e-1832c1cb3190	b3aab42c-57e3-4688-b683-3f401362cc95	c57dcd86-44c2-475c-a8e2-8fa7ce846554	1	419.03	2025-09-25 04:45:10.98788+00
570c8425-c10f-4f25-b979-212c154d941f	21f96094-3dc8-4573-87ae-01e98c850b79	ee50a987-173b-4b05-a631-2e8938684d91	2	456.82	2025-09-25 04:45:10.98788+00
308c2ae4-c144-4b03-bff6-ac2418116889	87758a86-90a7-4859-8155-e3cdc49e8703	299bbe41-9825-4f28-baa6-a9912151fcbd	3	55.95	2025-09-25 04:45:10.98788+00
7f4c2f72-0698-4ad8-8848-e78d1ac25cf8	1cafacc5-488f-46af-b0fa-7641c2bb1509	5cd9a9a1-f212-4606-af53-fca25dd3080e	3	226.13	2025-09-25 04:45:10.98788+00
7bcb173e-a7a4-4a28-8d98-f88ef9827af6	8b1d9977-e8da-490a-8a9f-b67c3df4199a	eb81f861-2147-4bb2-ada9-caa72cd0cd9d	3	311.67	2025-09-25 04:45:10.98788+00
d7617376-fc56-4d03-a348-f2880f79b917	4fca2ba7-55aa-4bd8-83ed-14a6c274b996	8f5225a6-34f5-4c15-a988-d7a4f55ab035	4	392.43	2025-09-25 04:45:10.98788+00
6a597441-5dcb-454e-8fb2-cab9032cef6e	08607ad3-480a-4945-a934-b96d6ea030fd	3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	1	431.41	2025-09-25 04:45:10.98788+00
f4e13885-1ee4-416a-882a-d074b1e8d0f1	ab4d5e03-c2ed-40ce-8340-658781fa652b	49d33abf-57a4-4c58-bce0-ab6a700fc07c	4	491.72	2025-09-25 04:45:10.98788+00
d8de3ee6-179e-4e59-ba7e-26bc64e4f42c	e9d423c3-dad6-43ec-89ab-87021d056af8	7cb3179c-ca2c-4b60-88ce-300066649462	1	493.91	2025-09-25 04:45:10.98788+00
aed384c6-e1eb-4a97-9ee1-9d1d09e96f93	616743a4-8c7f-4bdc-9b58-3e546b2bc63a	32f7d55d-107c-4f71-96a3-8bd0645b1ebc	4	342.18	2025-09-25 04:45:10.98788+00
96bed863-28e6-4d4f-a9d1-11309860f8a0	4a921fd4-12af-44d6-a149-53dc0eca642c	2a822dd9-fd77-430b-bd12-019d4b26f9b0	3	131.70	2025-09-25 04:45:10.98788+00
3b2b7acd-2ad0-4243-bec8-939b5b914f45	55f039e3-7cba-43cb-a899-44f7c7649d77	d3839398-cd1d-4451-8ceb-c07ffef517b0	3	265.54	2025-09-25 04:45:10.98788+00
bbb672c1-38d6-42c0-91e2-c9115be571de	c3dea71b-bcfb-4178-8ffe-2658d60a91eb	5253556c-057f-483c-9381-f6af86bde287	1	57.10	2025-09-25 04:45:10.98788+00
44b386a1-a53f-454d-889e-1832cbec966b	6687abd5-7e8d-4f93-8872-ed7973c82067	78f65a6b-18c2-48df-8bc0-eb30a0154451	1	430.85	2025-09-25 04:45:10.98788+00
3aa5ed83-4663-42eb-a15a-0b4175ad1ce3	65715f5c-56f8-4953-b5f4-0bc3d8d18eff	a43f31cd-13fc-46e8-911f-4876ac99098b	3	250.49	2025-09-25 04:45:10.98788+00
59fcf370-f9e8-437f-b6d6-d73bb6ba60ba	4c168f8e-9007-4772-959b-d039729ead3c	8e9f7564-7d74-4852-a5fb-24627acc6615	5	71.48	2025-09-25 04:45:10.98788+00
400aa6b0-6833-44aa-89f5-b542bab80342	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	c295d290-a589-4dd1-ab4a-fe7b997567bb	3	157.92	2025-09-25 04:45:10.98788+00
4b244e9b-bf9d-4773-ada8-83c3273f3ee3	696828dc-8af1-4e10-a1b1-85d38f508324	8a29d493-f190-4d23-b87f-f5a4a87c3cad	2	344.10	2025-09-25 04:45:10.98788+00
845b964d-1856-44e1-8b67-02d58eec25f7	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	71021f34-e6fb-48a5-a128-5f9a82263ed0	1	72.05	2025-09-25 04:45:10.98788+00
c09b9606-3947-48ea-9307-58209d1f2932	2efcb15a-8d88-49ab-970e-1216457514f9	c110f3b0-4c75-4fee-a723-118fa839b84e	5	346.75	2025-09-25 04:45:10.98788+00
5019ff14-1226-401d-89cb-e7e0c51de4a0	8760072d-6ab9-49aa-94df-f2c7154017a6	3a1de227-d303-46d6-9e73-1e65ab3d8f94	3	194.37	2025-09-25 04:45:10.98788+00
7a7e166f-0698-4f07-858e-ef03e68e9e18	6ec08346-23fb-4c08-8fd8-389c0a163beb	64979d06-6350-48ee-9931-f5e895d3ccfc	5	400.03	2025-09-25 04:45:10.98788+00
bc663cfb-b503-4bfd-993e-4fdcefd186ab	27ff74a6-1a34-4174-9a32-d8de03a71f66	bdcdcd5c-c2b2-47cb-98c8-a12c8bd36fbc	1	189.22	2025-09-25 04:45:10.98788+00
465b39fe-458d-4013-9687-7cd906bae32b	13872660-5f31-43e8-b5d2-f6d0cfb6ffda	6abb415b-fe4f-4793-ad8d-868a795e32ec	5	179.36	2025-09-25 04:45:10.98788+00
0e395140-c8c1-4f26-9e1a-a00558174bbc	84a0b61f-5665-4166-9a16-016ce275479b	badbf107-01fd-4376-b55b-b1ffc7c8735f	1	40.72	2025-09-25 04:45:10.98788+00
4e4a7469-5af0-4fa1-94a9-48d7b0607dd1	486d0262-fa5b-4a73-8fe7-29ef1b57e731	75a131a4-f92c-4efe-ae1b-e8ec24c6de21	4	258.06	2025-09-25 04:45:10.98788+00
32f5393c-4d5b-48f5-bda8-0d88b29cb059	30285572-1976-472b-97a9-c6d411bb8d0c	f032a584-5abf-47bc-892e-f61dccc60a62	2	377.50	2025-09-25 04:45:10.98788+00
338fdba6-9144-45ad-b091-571a57bbfde5	7ac3648f-0fad-47e7-b559-704d4eded058	f7c6adb9-957f-4ff9-ab19-a8471a6ecc66	1	425.43	2025-09-25 04:45:10.98788+00
75ba294d-edcd-400d-8a31-66e8f129a3c0	b954a6ca-3db3-4b63-84d6-f7fe72c548e8	e7f0c539-2930-4377-a02b-ef1af9a49026	1	383.47	2025-09-25 04:45:10.98788+00
0a019ed9-b4fb-490a-85e8-9288df925985	df8d6ba7-5a0d-4ceb-961e-e687721e7c20	6dbceb74-0c47-4565-bfa3-dcb7d954d612	4	401.75	2025-09-25 04:45:10.98788+00
3dbeb549-5aa4-424e-9dd5-32bd63203626	90c3d581-e6d0-4778-94d2-4da99a0eb10c	813efc28-0838-4fb3-9aba-35a8ec0c9f07	1	1.37	2025-09-25 04:45:10.98788+00
791f8a5b-d60e-4402-b54c-a0710449a855	ab0c5c47-42ad-4cd1-ae01-bfedc5e06335	91184f6c-6283-4075-b03b-ab164a047381	5	384.74	2025-09-25 04:45:10.98788+00
0bda79f2-d776-4a61-a563-5cba440c5468	59a54bf6-277a-4070-a309-a16cdf72e72b	254d53f1-8fa1-41e8-9dd2-3e5ad086ddf8	1	332.09	2025-09-25 04:45:10.98788+00
e54038d4-172b-4024-b9a8-de5d39e674f0	335585f6-4bb1-4bb4-b668-b154bafedf8a	95fdab27-0aff-4ae3-af8b-3fcfc6220729	4	286.53	2025-09-25 04:45:10.98788+00
7b01e573-44b2-42c1-b9b0-cb6c98d5b15c	53b1bc46-be1f-4a23-8d19-7b034efedf21	634d0cde-b191-497a-9977-8bb037147b0b	3	233.07	2025-09-25 04:45:10.98788+00
07c5db6e-7a5a-4bfe-a602-6a95d6b19008	346bd78e-f7c1-4da6-afcc-8cb304916ecf	c9268f65-058b-4a3d-9e71-0e83e2ad0f15	1	142.66	2025-09-25 04:45:10.98788+00
1205782f-a7c3-4f37-8562-11505f551761	565b0387-3386-402f-a840-08a8b9f80ea2	7ea74fc2-3204-4bb5-a803-c5d2549a0bff	5	62.90	2025-09-25 04:45:10.98788+00
74e5025f-b1db-478d-82d7-8479f23ba31e	4563b92f-05ed-47bd-b381-63564b3df8cd	99e055ec-e67c-4dac-9f98-2d14cc4b759b	3	45.78	2025-09-25 04:45:10.98788+00
48cc42c1-b108-4ccc-83b8-1217f72b00ea	b57a7b71-d56e-413a-a83e-cd07d045446c	bd1fa32e-baed-4e76-8f09-488bf794989a	1	73.67	2025-09-25 04:45:10.98788+00
b6a79cd2-ff7f-49c8-8e82-6caeb762de8a	1186879e-b083-40c7-b51a-d7bf6860b348	d33f0594-8bc5-4744-b189-55018e9becc5	3	465.58	2025-09-25 04:45:10.98788+00
08212d7b-8f41-45e4-96ad-0a24a5c7c95c	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	bdd9caba-e55e-4442-a12d-c961baf57333	1	21.83	2025-09-25 04:45:10.98788+00
19a81495-0d43-4797-9ab7-2a6c549cf33a	037c0b2d-f508-4e34-adf3-bce8f5932aee	90f27124-bec5-4f09-9d53-634414404daa	4	10.89	2025-09-25 04:45:10.98788+00
055f945d-7215-4892-8227-04d60d6494d0	e9b759af-dc7b-4a58-bcfc-747a2f9a42d7	77668721-237f-4e45-8e0b-4e00732fc412	5	118.26	2025-09-25 04:45:10.98788+00
09f514e3-2a10-4e93-99a5-05f0cebf5447	86d84a87-7753-4a61-8dc5-ecec33b095f2	c466f5d9-7b18-43d1-bf0f-3a425644e69e	3	26.35	2025-09-25 04:45:10.98788+00
363dd5aa-fe49-423f-834e-df90bb7773ba	7c190cc8-396b-452c-a86e-9a4b029eaa78	06c36a48-6057-499b-879a-97246326daf0	2	337.03	2025-09-25 04:45:10.98788+00
cf85c194-7261-40dc-be1e-f2c0bfc95bcf	6cb6a800-5043-433f-ae41-af18c9863d4d	5dc3359a-848a-41ea-8c69-28e6e255ddc0	3	96.52	2025-09-25 04:45:10.98788+00
9a19f807-9045-46f7-93ee-04d614f6d442	b2d6eda1-2ce5-4f67-845a-e323428c087d	2309e007-c814-4f0a-b5d4-f7a5cb7175b6	2	462.58	2025-09-25 04:45:10.98788+00
f5446128-8e15-485e-9897-a050ff8e3f80	9a0156d7-066c-4adf-ab25-b639d2c85d2b	4826f8ee-9b6c-4fcc-b26c-96542ce2a7ef	4	170.05	2025-09-25 04:45:10.98788+00
3d42cd36-c9f4-4ad1-b505-7d5de03ab4ee	226efa52-93a0-4d6c-b9d6-ea132c4fd535	dbc90d6d-bd76-4d68-860a-feae43bd1238	3	61.53	2025-09-25 04:45:10.98788+00
b04e94ac-82be-469a-a3e8-9610c1470c72	b638ee2d-80a6-4ff3-b15f-3ea2dc1e3ac2	3ab25fee-76a8-4cc0-935a-3f98460ff7d7	4	423.15	2025-09-25 04:45:10.98788+00
fa181183-19aa-49dd-8de9-e0d75d2649b2	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	127f89d8-13b4-449c-8d8c-0503721de511	3	379.37	2025-09-25 04:45:10.98788+00
fbaa9b88-ed02-46f5-8f44-acdad1104e92	70661215-9aff-4315-9fc5-027c065db093	867f8537-e019-444c-8ebf-33c3c7267f18	5	127.00	2025-09-25 04:45:10.98788+00
0d12d019-1f55-4c90-bbcc-eef5a32fcd1c	d0e67a77-64cc-4d59-81bc-1b5a49fd3cda	322d14c9-e270-4d50-a416-af049e62205c	5	182.42	2025-09-25 04:45:10.98788+00
c439bf30-c51b-49ff-bbed-ae0538242e09	3115f2cf-6015-4bee-9d03-20bba3f38819	e24d4035-5902-4b41-b494-da0316041933	2	325.87	2025-09-25 04:45:10.98788+00
53df2785-576e-4a16-81ef-2b8245856905	f548ae40-f469-4a98-9ab4-36bbb21b38ee	fd91f3dc-8855-4ec0-882a-a26e8ccc83a7	4	141.81	2025-09-25 04:45:10.98788+00
be977566-dcf3-4a6f-ab6b-b885c8eef87a	64bf5e36-4ca9-4761-a7cd-3794329e2424	f884e25c-e322-4906-bb12-b409b7b77d8c	3	331.96	2025-09-25 04:45:10.98788+00
aba0147f-7966-46ce-9812-29f50220568d	5063566c-73a5-49b2-9179-c966531ec333	3e095011-5a63-4ee4-8255-e8c5662e4fa5	2	219.08	2025-09-25 04:45:10.98788+00
715e22b6-0b4e-44d1-89e7-4ba678d1c722	aea6cca1-ab99-4fb1-9aa5-fc82f54da674	aebf681c-0b04-4393-b847-9142c6e33b9c	4	466.09	2025-09-25 04:45:10.98788+00
2be6e4c2-1c02-4034-b8a3-2d61bfd67e45	84b7ec69-3da0-4827-9fbb-3c41ba0a81e8	6b9edb41-cbae-48d9-bfcd-10b65500fe3e	4	447.93	2025-09-25 04:45:10.98788+00
f3f38609-b3f6-4f7d-a74c-a393d743cade	81c6669e-9f7e-4d7d-b826-3b2032020e7c	e3f360dc-ca43-4d24-9063-8c9734ff9178	1	315.38	2025-09-25 04:45:10.98788+00
2776c437-4004-42bf-ac91-f87b029e78c3	af0974a1-70cb-4884-980b-f4b4078e936d	4546edd1-0709-49a6-b91c-9fff4df751bf	5	243.56	2025-09-25 04:45:10.98788+00
3a8dfa5f-1339-4be1-95aa-f3d0cd10ed00	43807782-c0f1-4d10-adda-45c65b2e535c	536d23ec-bd5f-49b6-b467-20c4f5fd66a8	4	242.79	2025-09-25 04:45:10.98788+00
7d92db6b-77ee-4a32-b93a-caeb12514b37	833ed813-6177-423d-9903-87634724c195	66f52fb0-6075-4cf9-b884-caf6c6b13e66	4	402.95	2025-09-25 04:45:10.98788+00
117f9831-3886-492e-96ef-6c1a8452d4f6	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	688b8efe-e6d0-4fc8-a0ee-5cefdf5e4173	1	442.06	2025-09-25 04:45:10.98788+00
a0530466-727d-40a9-8aa9-dc1d1028b4b3	bba69bcd-4eee-40b5-aa14-769a0d5f71b9	3ee8aadd-6e7d-4bb5-8378-cc087c6e042f	1	135.18	2025-09-25 04:45:10.98788+00
03ec3a00-df2e-419c-8d69-46071e6b1c9c	af23ff0a-f05e-4a77-a6e8-747d1aac6b18	c57dcd86-44c2-475c-a8e2-8fa7ce846554	4	432.52	2025-09-25 04:45:10.98788+00
8454a0d6-91b8-4021-b668-18e0a8432474	8582c426-c826-42e9-88c8-217c96b432de	841f34dc-a86e-4f1a-9c41-0a66ae0b29c0	3	392.27	2025-09-25 04:45:10.98788+00
288de11b-f9cc-4d08-b0b8-d1ab71822e86	4462b016-e0b0-4540-9d60-2887e9a5767f	6c485af1-c004-471a-a088-07cc4d59b7c6	2	233.58	2025-09-25 04:45:10.98788+00
a34e77cb-0d50-4587-a261-e2cb664f8020	d69ac389-3833-4684-8f50-5a7e9e00ffda	e6f4d25f-cdd9-44ce-820e-ca525faf879d	3	158.09	2025-09-25 04:45:10.98788+00
0f88f9cd-5df5-4851-b6b4-e57fc4b12f3e	32ac1773-f123-4af8-ad67-bf7d7d2df925	34c0124e-60b7-4ffa-ab69-1f879796474f	3	331.67	2025-09-25 04:45:10.98788+00
43f78a87-4950-4c26-9278-2f01db136650	ab0c5c47-42ad-4cd1-ae01-bfedc5e06335	10315f77-07b4-4b7f-91e3-2ad0065106b6	2	482.95	2025-09-25 04:45:10.98788+00
fb51c1d9-086e-4185-8363-f1a156565994	1112f024-0107-432c-ad8b-7f9ce6c17f15	6559c77c-2a53-4b45-bc03-e0c7a3f2848c	3	477.67	2025-09-25 04:45:10.98788+00
5bb45060-bc1b-44d5-9231-18435dd7939f	e9b759af-dc7b-4a58-bcfc-747a2f9a42d7	be6e3ada-368c-4173-9e73-fc99f2d5b20e	3	13.04	2025-09-25 04:45:10.98788+00
ea8db869-f21c-4117-82bc-2bdeccb711f9	b1c19e0e-8a41-4676-9103-2ad593157d5e	474e2fa1-db3a-4a18-9525-ee013d90e4a3	3	22.78	2025-09-25 04:45:10.98788+00
82697f4f-e665-41cf-9319-9a7781c55ba7	36dd238f-16c8-4b6d-805e-0f076a282bc5	807e423e-35e3-4c30-95bc-12beeebc224e	2	125.81	2025-09-25 04:45:10.98788+00
44d9a0c8-c35c-4b43-8cf6-ccb86c75cd82	34112ecb-61af-4dce-8e91-ebcfa78948b9	38698efa-0fa4-4a79-9d21-2da2af8008f9	4	277.93	2025-09-25 04:45:10.98788+00
6ec992ae-160f-44ff-94c2-c383f5aca8d6	f8e6b3ac-4a12-4f9c-a5af-8fe0619422ec	c96f321a-391f-4fe0-b189-23b2294f7466	2	196.06	2025-09-25 04:45:10.98788+00
b146c1fb-2a21-4cba-9fbd-bca1a1e04fbc	8a2cba90-80cb-4577-9bd8-b97c5840496f	1f9d3a8d-789d-4234-a4fc-babb3f8f1559	3	420.80	2025-09-25 04:45:10.98788+00
853359e9-9d8c-41c6-b039-028d527e5f05	fbf4368e-b376-40ff-8f59-8fae4a89bb25	5253556c-057f-483c-9381-f6af86bde287	2	234.91	2025-09-25 04:45:10.98788+00
a58c6819-75af-4044-bd58-29e8cf96c428	3ac2a44e-2d7e-4aac-848a-52a503161e85	9177a11d-1cef-401d-a853-7448a708bdc7	1	193.10	2025-09-25 04:45:10.98788+00
a6e76741-9ac8-4144-9124-af9fc21b6237	6a1061ed-9985-4a6b-857f-741033d4b2d6	ce542f08-c868-478f-bde6-5e5db60c20ab	3	495.89	2025-09-25 04:45:10.98788+00
1b0e7fe3-77af-4858-bb5a-1c46658ac3d5	e11e7ed0-f84b-43f0-9471-49694b423953	af6b0b44-8998-4a55-b5f2-9b9ebc974dcf	3	399.67	2025-09-25 04:45:10.98788+00
5b76cc93-c127-4b43-aebf-c9089d71c6be	65715f5c-56f8-4953-b5f4-0bc3d8d18eff	94a4b3aa-2cf2-4f79-9bfe-1e59896eacf0	1	28.35	2025-09-25 04:45:10.98788+00
c24a2c7d-0925-462c-8bbb-21114e576304	ae75b3b4-b870-4754-8880-04e837237db9	323798a7-0e1f-43ed-ba23-eb07b7853cd4	1	350.23	2025-09-25 04:45:10.98788+00
a8a0d6ad-cef2-4608-a4fe-09b2cce92287	654b1ef3-ade0-4ed9-854b-2a1172e403e7	5537b5cd-974c-4232-9f90-dde2a70619bc	5	1.67	2025-09-25 04:45:10.98788+00
983758ce-f79d-4e1d-a053-1a949e97ee2c	616743a4-8c7f-4bdc-9b58-3e546b2bc63a	f36e8299-fc81-49a1-9643-a012f892462f	2	481.01	2025-09-25 04:45:10.98788+00
76c3fe59-f431-467b-9b18-2aaed4cdce8c	81c6669e-9f7e-4d7d-b826-3b2032020e7c	cd37d7b5-4541-4e4b-8a8c-f3d3404260ca	1	332.08	2025-09-25 04:45:10.98788+00
7813ab09-2036-4acc-8baf-6038ce33b7f4	50e45178-6375-40c0-a761-6b0857248d24	dfe4ce16-3d38-4433-87d9-a7e802c74f40	5	245.18	2025-09-25 04:45:10.98788+00
7b7efff1-ce62-4001-a10d-fca7cdcaec38	4462b016-e0b0-4540-9d60-2887e9a5767f	75cc5b91-f516-41fe-9e91-a1edf47a582b	1	267.36	2025-09-25 04:45:10.98788+00
4a440b16-e25c-416d-abfa-1da03e07b987	3f0d00bf-dd48-4b8e-8fc6-bc3ed8c28d0e	f24f6a07-8c60-46dc-9238-4a71725cb34a	3	9.63	2025-09-25 04:45:10.98788+00
4321acb7-513e-4df0-8d6a-45101ea3d5b4	da1a2d3f-7a99-4c79-ae23-495545b71b44	6abb415b-fe4f-4793-ad8d-868a795e32ec	2	271.28	2025-09-25 04:45:10.98788+00
42d1895d-e0f5-434b-8a72-2eaea2fd17a4	b5e7ba07-b6b5-40ad-bf4d-22815c5079a8	66ad7934-1f5a-47f5-91c8-df3c18c07b79	4	453.27	2025-09-25 04:45:10.98788+00
671d64ee-79a4-4856-8b4d-4a8cc38f835b	019ea4d1-14af-409d-89ee-fbf3c80454d7	8de4438a-27ee-4dee-8b82-48173ae9c8ec	4	450.00	2025-09-25 04:45:10.98788+00
225fe3cc-76a5-41b0-9566-269b505bf3a5	9526c4ff-a55b-4e0a-b7a4-b0b58f9c6f6e	aebf681c-0b04-4393-b847-9142c6e33b9c	2	139.89	2025-09-25 04:45:10.98788+00
62b17945-bc19-4a76-aa4e-71f74b632dd4	c1cc4694-d310-488d-8e5d-63847b4c6891	1445e51c-61bd-4bba-84ee-22b3d6034aa6	3	154.98	2025-09-25 04:45:10.98788+00
5d166ea8-5586-4510-8401-cc97fc2b4be4	a1a24691-e582-4e5e-ac0c-18a20c4042b2	7ea74fc2-3204-4bb5-a803-c5d2549a0bff	2	135.31	2025-09-25 04:45:10.98788+00
4ef6da21-8c95-4518-9c9b-e8361bd63338	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	bd1fa32e-baed-4e76-8f09-488bf794989a	4	245.77	2025-09-25 04:45:10.98788+00
ea55e67f-5d58-4c5d-8767-3a7bfb91b27b	9c673189-3650-497c-bb8e-cea432195f24	8ccb0951-19d5-4561-8e69-4c827cc20f60	2	424.97	2025-09-25 04:45:10.98788+00
da248720-c30f-4cae-9b46-0ee9fd7b9abf	5dd960b8-4a7c-4113-82c6-7cb8ebcdda54	b2c3bbf0-8067-4c0a-8c0d-2cf646c99ee0	5	464.13	2025-09-25 04:45:10.98788+00
0201e77a-f3c6-412d-9952-7afd007dbfe5	4563b92f-05ed-47bd-b381-63564b3df8cd	67cfddcb-98cd-4580-a845-be518779ded0	2	485.48	2025-09-25 04:45:10.98788+00
189421fa-831e-43e1-941b-62dea027c63b	f3c939eb-8f61-49d5-916e-da09ef3fcf4e	8bc1489d-cd37-4ab3-ad35-fb2e2565255b	2	423.34	2025-09-25 04:45:10.98788+00
35a3e980-08ed-42ba-b37a-d3d93165641f	8b1d9977-e8da-490a-8a9f-b67c3df4199a	2a77af69-7b2e-457e-b894-8e07457c8007	2	333.97	2025-09-25 04:45:10.98788+00
6cb3c73f-bce3-41d6-b928-97072588b5e8	bdda4657-a1b8-40e4-b255-f78d53dd7125	0f0ff4ee-abfb-4c21-b535-c5dbe857dc12	4	98.52	2025-09-25 04:45:10.98788+00
091a23c5-bd26-4fa6-9ba6-da8afae04fdd	08607ad3-480a-4945-a934-b96d6ea030fd	f107a70c-1c67-40b2-a55a-9176679df5e2	3	15.77	2025-09-25 04:45:10.98788+00
976e1be4-21e4-4231-b9a0-01e78770f69b	33aa031b-4e8d-457d-b7ad-f0d11295d0c1	a256562c-e11f-41d1-baaa-282749528770	5	33.37	2025-09-25 04:45:10.98788+00
b28fecba-bf87-4faf-b04e-fb4d7b400abb	7c190cc8-396b-452c-a86e-9a4b029eaa78	a89be87a-2d8d-4a07-9ba2-f1a87dbceeab	2	12.67	2025-09-25 04:45:10.98788+00
d56fc8c1-5bcb-4b70-be02-019da979fadd	d68fd55d-4c20-4f1d-9de7-5924e4e30de3	23564ad7-a514-4fdd-9879-bfbd0ea21589	5	494.27	2025-09-25 04:45:10.98788+00
8db2e273-9cd0-451b-bf30-573c5216d354	1efaa2bd-8989-499a-aa6c-8a7c21efdd7c	2753b302-63d5-428f-a8ce-ebffef9b210b	3	135.77	2025-09-25 04:45:10.98788+00
dac58e4c-a33e-46c3-8393-9153f0d07598	b3aab42c-57e3-4688-b683-3f401362cc95	5d6e3a87-4842-46df-882f-5e662fbccd09	1	154.36	2025-09-25 04:45:10.98788+00
ce007b32-46ff-4cde-b85f-cd26a0815e7a	59a54bf6-277a-4070-a309-a16cdf72e72b	65916b3c-9161-4b3f-96b6-40c59d46a652	2	443.81	2025-09-25 04:45:10.98788+00
df2cf515-a273-4147-81f2-98022e40eb8f	84929b25-b2ed-4d34-bc13-3ec73853b06d	4d3a9cfc-9faa-4cb4-9925-2ef1401088a9	1	265.40	2025-09-25 04:45:10.98788+00
4086c931-b247-47b8-a13f-4e01c914a04f	e11e7ed0-f84b-43f0-9471-49694b423953	47d89e50-a931-45b0-82cb-b8323605b5e9	2	85.53	2025-09-25 04:45:10.98788+00
e53527bb-4e36-4df7-b12c-76ec164d4cd7	331101e6-e9a5-4b49-8f31-7b10f6879b06	ff45506a-c74c-4d5f-adf6-690a5e0c3b68	2	17.37	2025-09-25 04:45:10.98788+00
61fcd763-646f-4163-ba99-f127ef5410cb	b954a6ca-3db3-4b63-84d6-f7fe72c548e8	cd862f44-36df-4ad5-b816-1a941066779c	1	380.74	2025-09-25 04:45:10.98788+00
7e437fda-1d0d-4ebd-99dd-c4631e9f3717	55f039e3-7cba-43cb-a899-44f7c7649d77	3aa4c585-7e17-4118-b80e-cbee745cd4d6	1	12.35	2025-09-25 04:45:10.98788+00
33c272b5-63bf-4a75-9c55-0ddf4534f884	6a345b9a-297e-4afc-b3b1-6100af89d749	d81476a4-8563-4c32-a7a8-3abfdb5e6968	3	448.95	2025-09-25 04:45:10.98788+00
988f98fe-17f8-4328-859f-96ea91e71272	5eeea7cb-6bdf-405b-9708-8191fc4424b5	e75a724b-b522-47e9-8475-f8f74181c1c6	2	430.67	2025-09-25 04:45:10.98788+00
69609952-6e24-482c-b9ae-bf889c85eb23	ea2d8bd2-3631-443f-821f-7e6c24e43857	21f89511-0b73-453d-90e5-5259485a5afe	5	295.86	2025-09-25 04:45:10.98788+00
e2f410ce-17e2-4a14-952c-131a9401744d	ac240e7d-0011-4233-8958-dc5c19352f3b	b5472fe6-08a0-4a71-b141-098cb95417c9	3	251.41	2025-09-25 04:45:10.98788+00
6446ba08-2aed-43ad-a4ed-30fc8cd1f763	c9f6a6ed-e9fa-4340-8fea-7d04e1cefb97	841799a8-7865-4d0f-8067-48fbbd7e5e7e	5	428.40	2025-09-25 04:45:10.98788+00
ef91fb51-1be5-4abf-8a13-ff7402ea256e	44950334-23ad-47ac-8466-4f67d1c04b27	c57dcd86-44c2-475c-a8e2-8fa7ce846554	3	236.77	2025-09-25 04:45:10.98788+00
09bd5eb0-ac56-432c-992e-01009079e3ab	e5f30e6c-96b7-42a3-bffc-6d1fc991f36d	3e40bf78-29b5-4a0b-bf2a-d19f1cf071a3	3	385.28	2025-09-25 04:45:10.98788+00
24bfcade-1260-4186-b7b4-1335d3f776b1	9950f002-d400-4835-97fe-97a61c858a79	917a1dd1-02af-4545-b68a-4b134d7bb653	4	14.57	2025-09-25 04:45:10.98788+00
63201d1f-705c-4d4b-b91c-75d8baff9323	7c190cc8-396b-452c-a86e-9a4b029eaa78	c42aa557-2ac3-4c8b-b680-45467d38a8ab	3	452.52	2025-09-25 04:45:10.98788+00
c1f1db06-c4fa-4cff-bb64-1704fe5d9d9c	c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	856d5eca-a8d9-4b7b-bf5b-5503dccb7afd	3	375.15	2025-09-25 04:45:10.98788+00
86e1ce00-37b9-4389-9403-e7c3b93a5dda	1d9052a7-123b-4c23-925a-27bb369ebb16	42a74d33-01c9-42ed-b501-39ffe285d680	1	131.24	2025-09-25 04:45:10.98788+00
1d7c0d4d-06cf-4864-b5a9-f7f3c6f754bf	57c9f478-0322-4dcc-8934-5d3ed768e1fb	3c796ee1-f3e7-484d-8659-fa9251c5cce2	4	45.37	2025-09-25 04:45:10.98788+00
4acd86a6-3e6a-4b01-864b-33670c1ca9ac	760029fb-2348-4c8a-a68a-6a51117954b6	d41c977d-bf05-49a6-b419-0b7496f86f41	3	289.13	2025-09-25 04:45:10.98788+00
c3b1f8d5-714c-4956-a7b0-dfdb3963623c	cc93871a-784b-45f8-9178-4ffe08a18c86	301b960f-1b4f-4759-9bb5-5f294838f218	2	223.83	2025-09-25 04:45:10.98788+00
507000bd-0add-4837-b9f7-57c7895f10b0	b14c0b15-9d1b-4068-a271-3aa127c22c0c	236c0db8-4326-4c16-9d7c-03d2f5c787ad	3	493.31	2025-09-25 04:45:10.98788+00
afa3dfa3-9a5b-4879-a73d-9ef0bf90e0d0	347af1fc-eb17-4ed2-aa1a-0f16c64815e4	cf7c0140-d018-41ed-b1f3-d84978d66add	5	100.98	2025-09-25 04:45:10.98788+00
264d5238-ea6b-4bb6-9fb2-e4f52d528f7e	317b8c5b-78d9-49b3-a4f3-8510d741a9d1	306e3d9a-47d6-4f1a-bb3c-de7d2a8e9f52	4	273.05	2025-09-25 04:45:10.98788+00
da6ec035-fcf4-4f45-80bd-b55eda65f032	16fb54f2-da1c-4d8b-80c6-c3f758af6b8a	3f930a17-699a-48b2-9ca2-245e31268823	1	260.05	2025-09-25 04:45:10.98788+00
ee353bac-53ea-4a98-9152-f22088f2baab	f548ae40-f469-4a98-9ab4-36bbb21b38ee	fe92e40b-77a9-4427-bb39-7b686e50993a	4	407.81	2025-09-25 04:45:10.98788+00
aed0d3ef-39e8-4fc0-afef-de385d3a12c3	8b1d9977-e8da-490a-8a9f-b67c3df4199a	ef4ed276-3f1d-4d7b-aaab-4a06777be9eb	5	344.94	2025-09-25 04:45:10.98788+00
8d7fdd6a-7c7a-4f1c-aa00-817aa6dd1b27	f32b1168-47b6-4aa6-8db0-4a813f1f4642	26a142be-85ca-4609-bd38-3ad3eb7be080	2	5.33	2025-09-25 04:45:10.98788+00
31a77acf-4304-4be0-b287-2a0fe56718a1	8316841c-b2c1-4764-9d00-fe876b6f769b	0dd1f0be-83c6-4475-b0ad-e139e2fd6562	4	373.09	2025-09-25 04:45:10.98788+00
4bdc52e1-de5c-48da-bb25-8f1289b8af26	dfdd0300-e01c-45ca-bd58-194ef077debc	ba5be328-3e0f-4d8d-982e-a6249718b39a	3	482.13	2025-09-25 04:45:10.98788+00
a96014a0-f611-45e1-a764-104930005484	985f818c-1a1a-4d3e-8bef-69164308c435	55913ecd-e237-4052-a117-3551627fa29a	2	490.74	2025-09-25 04:45:10.98788+00
382ef9bf-4617-4bba-b3d8-eb641c5382bc	3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	f6646719-cad7-44da-9df7-f91b352004f5	5	139.49	2025-09-25 04:45:10.98788+00
f9731525-a24c-4f86-b271-74c575f404a8	4efb1ecb-9666-464a-86c9-8f5d5776d441	a0934b97-535d-4536-a286-7debe5ac9988	3	316.23	2025-09-25 04:45:10.98788+00
e8d40bc9-27b6-423c-b160-08143e85cba5	70661215-9aff-4315-9fc5-027c065db093	50d5fe28-104c-4636-a8d3-478901f022be	5	298.21	2025-09-25 04:45:10.98788+00
af14f36d-5ffe-4517-b53c-85b8c9bfc02a	e9a8fa5f-b13a-41c8-ab5f-435092906813	1d7ed714-affd-46a7-9ad1-fe88d38e314b	1	85.65	2025-09-25 04:45:10.98788+00
d627cc1d-4d29-4ba4-8148-22c43f9d3a8b	c9f84933-0b22-471e-bae8-cf205690ad63	ae58abdb-65e1-4b29-af25-1ec389b777b3	1	370.33	2025-09-25 04:45:10.98788+00
d95d349a-0afb-44fd-82a8-e7c737dba14d	a1a24691-e582-4e5e-ac0c-18a20c4042b2	7fbd0972-f9f6-4800-bfca-53cdc4950908	1	72.12	2025-09-25 04:45:10.98788+00
389cc511-faf7-4f0e-bb81-93f019ad36c2	155670e0-b314-4f32-a41e-7f1bd25722de	9b50e867-a6dd-4818-8612-e94612ec4157	3	312.87	2025-09-25 04:45:10.98788+00
3efd3ac4-c3fe-4f82-8b2b-398ad6552b48	98deafff-495a-4fc8-bf3e-5f7961607766	759ac7fe-7f3d-4afd-ac5a-6872e587ea91	1	383.28	2025-09-25 04:45:10.98788+00
c810c81d-dff0-449a-86ad-ada51737a622	5a475899-b907-47a0-9b74-d7a44c28c45d	ffe792a1-957c-4a1e-a728-45917cc2213a	3	227.53	2025-09-25 04:45:10.98788+00
26bd7f0e-e76b-4e2b-9a89-0a12f84d4afb	d68fd55d-4c20-4f1d-9de7-5924e4e30de3	ecf1efc3-4c8b-4dce-a60d-e569c007749f	1	331.77	2025-09-25 04:45:10.98788+00
d7324083-8d8a-4cf4-9be0-75391344d192	f1bd4a4f-9854-4cb6-a266-9ef17f74690a	8423502a-d4b8-43f7-a439-7af92b153814	5	408.81	2025-09-25 04:45:10.98788+00
e8a578fa-54cb-423f-ade9-9a5c915e3691	27ff74a6-1a34-4174-9a32-d8de03a71f66	71021f34-e6fb-48a5-a128-5f9a82263ed0	1	5.67	2025-09-25 04:45:10.98788+00
ef088322-ec6e-4765-9099-bb48af814965	4ed80603-7451-47ea-a4f0-cf51d43831b5	3ac724a6-3c7c-4869-a512-b832457111e8	2	316.43	2025-09-25 04:45:10.98788+00
880f2374-e619-4c80-9b9a-c872f2c13600	2a21d19d-fccf-4bb9-8eaf-a5ec16428fc0	2dd75261-4657-4253-9efa-9623252edc34	1	459.23	2025-09-25 04:45:10.98788+00
c6cba2db-1a91-437a-8fa1-268cd855fa45	9e066f71-57dc-4b0f-b198-d4d5c2da6943	a394c179-ff81-4ac3-b42f-4fa7b4d09ee5	5	376.94	2025-09-25 04:45:10.98788+00
1c41d05d-5661-408a-9b97-046b24b5e271	7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	75423bf9-9773-4e43-a7dc-869dd3830e92	4	349.09	2025-09-25 04:45:10.98788+00
6e87eb3a-0566-47dd-b25b-6336dbf3d1e4	0c5be91b-4cb6-479f-8d5a-d661e3f1446e	be17ba99-47cc-4f1b-89ab-f0ada842f8be	1	31.16	2025-09-25 15:49:21.360008+00
feacb70e-2333-4713-9873-24447e6f3880	e4561b0d-c677-4aa0-8350-5560a9fc3289	ffbff3af-ecd6-4d7c-a5e6-a8d511ae2334	5	250.84	2025-09-25 15:49:21.360008+00
a0030540-ffe7-407d-a3c4-5ac0106b1fd1	86860fb8-6f26-4f28-9be8-276d06c16b8a	52885168-97b2-4e13-93f8-92bd9dad7faa	5	284.86	2025-09-25 15:49:21.360008+00
fd32b071-54e9-42ae-a153-9d75cde5e3d5	987edebe-d35c-419a-b283-24996973dceb	35760cce-90a5-4a54-9300-fde2ac98a9ed	3	26.44	2025-09-25 15:49:21.360008+00
b9a14e9b-1673-4b39-bd35-009fcfc54bb6	7a07cac1-cb16-48cc-a35f-dd7974c78726	b04eb25b-9fa2-4522-99e9-cdbc0ea05dc2	2	139.39	2025-09-25 15:49:21.360008+00
6be92f8a-0595-4b70-a9d1-c73e1fc7fbbc	0fbbd80c-1f78-49a7-a474-06be4c1258fb	b345b1d6-afda-4064-82a3-8ada5c625990	3	480.19	2025-09-25 15:49:21.360008+00
88e63cd0-9c64-4bfd-ba01-71d4683f2aaf	04ba2842-1c75-4c0a-9440-138d32d842bf	75abba00-6208-40f4-80fd-a914bc24dc12	4	227.45	2025-09-25 15:49:21.360008+00
12fd2b2b-56ff-4ca2-9215-673b0001f043	29c44409-4491-4a6a-8843-fff08882f07e	5c12ee9a-d7cf-4f48-9521-746cc1610ca5	2	281.18	2025-09-25 15:49:21.360008+00
21b00a4f-698b-4cdb-87aa-83bbd3c3b2dd	a47099e5-e24f-48ac-b430-227b6dc72c47	a4f81295-eb15-406e-a8fb-d98a93712a53	3	386.81	2025-09-25 15:49:21.360008+00
34e05da9-8e4d-4582-b7bf-380d3e09b2fb	9baa1226-3fce-41c0-9415-863a8770c909	050432f7-2bee-4145-8847-a5426907a9de	1	451.08	2025-09-25 15:49:21.360008+00
15e14118-fd6e-4140-a474-33658a3b72b6	6882d9a4-73a3-4f7f-8fe6-120bb76a1dcb	9382cd8d-9410-4b85-97ca-6288b82a734e	4	354.98	2025-09-25 15:49:21.360008+00
c90f5cc6-6b4d-4fc0-b2dc-2c35959d1d36	b8bd434b-b2d4-4b4a-b989-5dce929672d1	7bb56b0c-494a-4fcc-ba6d-48ba50313e6d	1	224.37	2025-09-25 15:49:21.360008+00
1528bae1-8b4b-4e63-942d-2b7b6594620c	20c128f4-782b-4e22-aae7-8675571d5216	809b63b7-aeaf-4496-bc99-0694fe605c94	5	132.99	2025-09-25 15:49:21.360008+00
c52aea58-c0bd-4de6-baf9-c433b5fd9895	dff49b1c-3584-4537-b0a3-39b63729570a	fba6d988-0239-45ce-9863-9520aef4b3f6	4	168.74	2025-09-25 15:49:21.360008+00
e86c860e-139b-400c-9075-128fadb8e45c	e897f67d-f5e7-45a0-804e-317267bb99e8	7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	4	112.82	2025-09-25 15:49:21.360008+00
3437bb5a-dfbb-467f-afc8-3b9f6fc84030	efdfbab8-034d-42de-97fc-e0807909bb0d	fc6bb273-6c79-4da7-9bbd-902c36847259	1	205.39	2025-09-25 15:49:21.360008+00
a73961e5-de16-4cb1-b160-ffcc28a35af0	9208a3c5-c409-4c66-ac38-5d24f4798a1e	76d7548b-f723-4eda-883a-1b35e77a8718	3	258.35	2025-09-25 15:49:21.360008+00
15ec2c35-5944-4eb2-adc5-b066cd4f02c5	cacf6667-3f07-4dbd-b449-c1286671c667	a249e695-7d78-464f-a3b1-a328a4cf7e38	5	350.54	2025-09-25 15:49:21.360008+00
d70361d5-4789-4145-b185-bb0d777a3939	7078a458-4849-4d87-8dd1-f705e9d204e9	3ca94801-5e08-4acf-a654-692b8a559db8	5	25.24	2025-09-25 15:49:21.360008+00
085d77bf-aa7d-4504-ab13-d2e8a2aaa369	13c1c8f6-ea68-41f8-98cf-bf54740fe3b6	3e211461-ef29-4d16-93b5-65c617abe5ea	3	294.98	2025-09-25 15:49:21.360008+00
c972ee7d-92a3-4eaf-a777-9c3668d8a160	06ec6966-1cbb-4cf9-8f63-482325332370	78b46b2a-8550-405c-88b0-e2619b3d095a	4	155.92	2025-09-25 15:49:21.360008+00
deb77e8e-67ad-44cf-9543-ffb446b9fa4e	41bc1f19-483d-4acd-a210-0fb701278bbe	b166158c-a5be-436c-ab5c-d1f97b0572b6	3	137.24	2025-09-25 15:49:21.360008+00
1e6b416d-251a-47fd-a44b-48529cb2cb56	7a0e8803-b665-46d2-a9f5-79297739c1e6	cd37d7b5-4541-4e4b-8a8c-f3d3404260ca	1	436.90	2025-09-25 15:49:21.360008+00
598c028b-396c-47cd-b916-cd27f6139a2f	13c1c8f6-ea68-41f8-98cf-bf54740fe3b6	254d53f1-8fa1-41e8-9dd2-3e5ad086ddf8	3	30.44	2025-09-25 15:49:21.360008+00
5220af15-7e69-43fc-bf8f-ca231407785a	4e570348-6554-42ca-b80c-f98d2f79b055	85e68321-7895-4d1f-9e05-28a2d824c984	5	484.79	2025-09-25 15:49:21.360008+00
133d533e-efcb-4d52-ba8d-12d6d34d6e47	7ee6fea3-ff9f-42e6-bb41-9367c3fb6a84	a4f81295-eb15-406e-a8fb-d98a93712a53	4	431.40	2025-09-25 15:49:21.360008+00
fa901402-24e6-4a9f-bbaa-08833b1c3a28	4ee52527-2803-491c-be99-3ed35efa903d	7e1bb644-625c-48c5-ab0e-19ba4af3b7ac	1	383.80	2025-09-25 15:49:21.360008+00
951c797d-6375-44bd-9352-c287320b16cc	26d94299-b4a7-48f5-936e-c9975e12dd74	7cb3179c-ca2c-4b60-88ce-300066649462	5	263.03	2025-09-25 15:49:21.360008+00
2dd38744-7d28-4678-ae85-306b4f41f90c	66d5dff5-1fb9-41b1-b15a-dabe2c70fb70	bdcdcd5c-c2b2-47cb-98c8-a12c8bd36fbc	3	188.21	2025-09-25 15:49:21.360008+00
662241a5-d09f-411d-8dd8-0d65a37bd5c9	90e77639-78b7-49b1-897b-12d578024a7b	9a15c0f7-94c8-412c-a653-8fdb151e2eee	2	310.80	2025-09-25 15:49:21.360008+00
c4c2108b-2ee1-4766-9f9a-5ac126b89641	5b7cef35-0333-432c-a41c-3355e75747f2	21f0cd0b-99e5-4271-9545-9bb8ee47a8d5	2	431.32	2025-09-25 15:49:21.360008+00
ebba09c9-88a1-4866-8ef3-b0c89c4ce070	26204835-dcc2-4a79-9c9d-3cd38271fcea	483a148c-18b9-4e7b-8f6d-48e9db2a12b8	1	252.35	2025-09-25 15:49:21.360008+00
e4513a86-d9a7-4019-a541-872d197ac2e0	a55c6aed-e1cd-4ae6-8f53-b37cbb1ab41c	f24f6a07-8c60-46dc-9238-4a71725cb34a	2	358.83	2025-09-25 15:49:21.360008+00
354f597d-314c-4f0c-9305-26c354b7cef5	6910c056-e78e-473f-91be-27421de436b1	3ac724a6-3c7c-4869-a512-b832457111e8	3	99.78	2025-09-25 15:49:21.360008+00
b43fbc52-1263-492e-964d-6b5f849f46fe	35191e52-834b-49ce-ad39-75e35a3cfbee	4f2223d9-a061-49a1-9c99-03119a08763e	2	60.87	2025-09-25 15:49:21.360008+00
33e8517b-745a-4345-8521-46af5aac5717	41af7684-234f-4c36-93d9-550f6dec9dd7	db25a60b-7e10-4a3e-985c-862e305d8d12	3	204.84	2025-09-25 15:49:21.360008+00
a96afafd-a6f6-40e4-9aff-e17a4e0e928b	1f5a7650-6543-4791-b064-3290aa6b362c	ee8b33b7-8db8-4491-8c99-1204dfb9f6fb	4	166.88	2025-09-25 15:49:21.360008+00
f48968f9-7f4a-43db-ab72-c26803f42098	6f3219d0-334c-4813-984d-8a1daace382c	75384ea9-6d1f-49c3-8160-2c15639917c5	2	152.73	2025-09-25 15:49:21.360008+00
0b7c57a0-f749-424f-8e34-6c7d0c997228	81e3e409-d429-4a1a-b8f3-2e8e517dac57	d41c2e97-0aa8-4cde-a49a-97dbbdbdaeca	5	481.11	2025-09-25 15:49:21.360008+00
dc62e003-130f-44a5-b0ca-1a412c3f9450	75574235-ca38-4468-9173-6c13e625a703	27a57e29-9044-4910-8ceb-6e40fe7b52c4	1	12.93	2025-09-25 15:49:21.360008+00
e14cf44d-852b-45e5-a8f7-0cc9352b1b94	bd9572e4-f7f0-4388-948f-735bdb83daf2	f2c97c44-10eb-4bf2-b021-d6806ada9794	1	202.44	2025-09-25 15:49:21.360008+00
ee851765-6b47-4238-8062-14131268f23b	f3c7a23e-eeb7-4cd9-a82e-9b95190bab95	4959ca38-b273-479e-a65f-f1943f0e439f	3	403.83	2025-09-25 15:49:21.360008+00
8dceeab2-23f3-49de-a657-c168127415ed	3a9ce289-a876-4e46-835a-e120989c8652	a3f19f10-0544-435d-998f-ea2b3326a026	3	314.88	2025-09-25 15:49:21.360008+00
58b57849-10c9-4b92-a1c9-76ab4d4376b5	7470174d-b026-4646-a890-96d13435d6a2	07bd80db-59c8-4656-9564-d5f2910712ea	4	209.17	2025-09-25 15:49:21.360008+00
eb793eab-6ead-4be9-a557-3ff3ec2fa24f	17696562-545d-411b-96ac-553be0bd74d6	60e6f374-032c-4182-85b4-22232ac5a0de	2	193.63	2025-09-25 15:49:21.360008+00
0ac5efee-14db-4249-89fd-dbf03fcdc07e	281df8ad-c1e5-46b8-bc29-020b73430fe2	0014e265-84df-400e-8491-66e52724e161	1	399.89	2025-09-25 15:49:21.360008+00
f89168b4-6162-4799-9430-c3359de66aac	d2b4f687-7bf4-4b65-b058-37c2dad6f887	c02cd2ff-f382-4b9e-83ae-c2efb8204954	2	105.01	2025-09-25 15:49:21.360008+00
b4263e63-aea4-4017-af83-1f4dbb146145	d03a1f35-5561-4042-a79b-ce2f6efed426	fc1caf36-2718-44db-bf7c-deea57dde18f	3	313.58	2025-09-25 15:49:21.360008+00
6a44f45e-35d7-4661-b254-7203523a4799	6d8773f9-5e39-407d-b9b0-adbce97a9dc5	301b960f-1b4f-4759-9bb5-5f294838f218	3	411.28	2025-09-25 15:49:21.360008+00
a7f27a8b-a397-4973-a631-43f6930308b3	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	fb417af0-916f-4df8-8522-beb0da87cfc2	4	37.70	2025-09-25 15:49:21.360008+00
175e43f9-34fc-40b6-a0f1-e01dae8c8072	180172de-af0b-4c91-8f84-2568a026fea8	716cb29f-2b54-4eb2-9d2f-82eb248eca72	2	398.61	2025-09-25 15:49:21.360008+00
c858f7d1-f26f-4582-85fc-20d2f86e17ef	a1963124-0e73-4dcf-8487-9e22573e91fe	d92462f4-d0f9-45cc-a17e-8a0abc992ccf	3	483.24	2025-09-25 15:49:21.360008+00
a24ed0fb-b35b-46f1-b76c-953ca7ba68d0	ae7a7873-27e1-459c-920d-91748499d60c	66ad7934-1f5a-47f5-91c8-df3c18c07b79	4	356.32	2025-09-25 15:49:21.360008+00
03b80027-4712-49a9-ad9d-3cee787dd662	967536eb-8cb9-4eb6-a8f7-77c9d6125463	595a5345-7966-4d57-886a-102c21c3eda4	1	299.96	2025-09-25 15:49:21.360008+00
d41624ca-fba4-4839-82ff-a3d3c1c3dbe7	45f0653b-a445-47a4-acc9-e13231abb0b7	00e4225a-d885-4cd7-ae38-e8ab0073616d	3	188.78	2025-09-25 15:49:21.360008+00
9611a2c2-7126-4b01-bfde-9c1bf09610f3	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	866ec54f-443e-4ee7-a605-619c43c6a6ac	2	20.89	2025-09-25 15:49:21.360008+00
6c0037d7-308f-47e9-b455-4994a8a892d5	b0f8fa2c-f1a8-4a95-9fe2-1008c62694e1	719993bf-3a56-4afe-b749-4954fe4ab27f	3	291.96	2025-09-25 15:49:21.360008+00
03639bc6-5194-420b-99c4-5fc5ae7ce3bb	d79f3ce6-cdfb-42f2-bd07-bfe7e69ebe85	8b01af50-26a1-487b-8b2c-120b749d30a3	2	291.45	2025-09-25 15:49:21.360008+00
26c643ad-75a0-45c1-b4fe-c141ce57d55f	6222f2d2-7dca-4536-a261-64aafcb4a1c8	736e608f-f545-4d28-9da1-146cc3444701	5	40.93	2025-09-25 15:49:21.360008+00
7eb30c3c-7b4a-4eee-9f4f-0358020f1ade	2f835276-86b6-4d57-a13f-c8850e3c1655	46f455c8-0f16-48a5-81ba-5ec3954da241	4	398.63	2025-09-25 15:49:21.360008+00
4fe02c76-5733-4405-8ca5-a1f46e5c4d04	88d67c80-cddd-4ebe-ad98-0641b5884be1	d3ea9f78-f866-4f13-bd3f-3ecdd4c8ad7b	1	313.74	2025-09-25 15:49:21.360008+00
d9adb4d6-9dae-4d21-a97c-d3c25b4da71d	4cd05a47-7bfb-45f3-9142-0cb00b39f08f	525c58fe-d14c-467b-90d8-4b5fe605dbde	4	57.68	2025-09-25 15:49:21.360008+00
17ec6802-1631-40fb-8f2e-e42fcebbe310	750e4907-ab47-4e1a-a191-e6356a4962aa	5beaf691-57aa-4d6e-99b4-fd12a65a6751	5	407.67	2025-09-25 15:49:21.360008+00
c897c226-4afa-49a3-9881-0f238382146d	04b226bb-5169-486d-ad2e-26a3f3c277bb	647b0808-e8eb-4167-88e6-106f0af62c7d	1	63.09	2025-09-25 15:49:21.360008+00
e37c1baa-7067-446c-ae17-2e8739bb079f	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	d7707eed-1a6f-4d82-bead-cd182f3541c0	5	492.75	2025-09-25 15:49:21.360008+00
e2a4d64c-298a-43e4-ad59-e011837cdfb3	a47099e5-e24f-48ac-b430-227b6dc72c47	cd862f44-36df-4ad5-b816-1a941066779c	2	94.99	2025-09-25 15:49:21.360008+00
aea4a7b1-ffd0-4b19-bfc6-020f659e007d	84e30ccb-1a2c-4aab-8f51-535fa4b30f24	dc995feb-0c4b-46dd-83ee-bedda7f27956	3	372.45	2025-09-25 15:49:21.360008+00
339af7c2-48e9-486d-b370-06d41bbaf44b	1fc8a267-77bd-4aa5-96c6-4846794fae29	57173183-c9d3-4b5a-a453-7eb01e33ad65	5	115.82	2025-09-25 15:49:21.360008+00
b194ef28-67c9-469a-9cfa-9980a64f9b8b	603c2afb-984b-4c88-91ea-d4d5e379e8a2	bd895a29-ec6a-43e9-b05d-b747bc7c1ac3	2	382.61	2025-09-25 15:49:21.360008+00
490337ec-0254-416b-82e3-d889f2098867	c4a24deb-273d-41a1-8c33-cdb4fe790380	c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	3	385.97	2025-09-25 15:49:21.360008+00
bb839e77-1bdf-4b4b-897f-bc83d96329b9	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	956a56b9-49f7-4357-8ce6-cf3b7a8d5f1d	5	292.17	2025-09-25 15:49:21.360008+00
8040f044-a04f-4fb0-b716-f631b07eb7b1	7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	b9434108-7ef0-42bf-9f20-80d74059c1a0	5	488.11	2025-09-25 15:49:21.360008+00
32a04061-c64b-4761-8ed9-73c1811049fd	d94e1b98-75f7-4be4-8e3a-ef61e09030ea	e24d4035-5902-4b41-b494-da0316041933	5	303.72	2025-09-25 15:49:21.360008+00
5d3134f7-d8cd-4749-aa69-8c5029c94ae8	d03d2567-bc3b-46a2-b2ee-11b8b8523357	7cd8aeab-d746-4e22-a331-20f85bc0547b	2	108.95	2025-09-25 15:49:21.360008+00
3197ecdc-f441-4d92-937e-2856f9cb52b0	c2a449db-0250-418d-bcb4-fb0cf9cea4d5	dfc96061-c9e3-4063-9903-7ad24ceb276c	1	494.29	2025-09-25 15:49:21.360008+00
341de0e8-d9a9-447e-8fc6-c5d92f1da3b6	326e3fff-476a-4842-91b0-53752eb15c7d	46d6876b-b606-4a5b-b369-23280e6c2fe0	2	171.60	2025-09-25 15:49:21.360008+00
5ef234be-731f-443b-a3c1-2c940fe55824	c99c3a55-5a02-4422-8bba-8ac5704961c3	8bd888a9-2d16-4edf-bdf1-4152af85d945	5	198.47	2025-09-25 15:49:21.360008+00
da9efd5b-f3ef-4677-a5f7-552b8b911509	05563c70-d86a-4726-ba56-30fabe6c2764	b44bed20-df21-4afa-a304-5a70bf1661fe	1	479.66	2025-09-25 15:49:21.360008+00
ad8054e1-2118-4011-89a5-58b64bcbb344	915e5bc2-8e56-417f-a081-ffeb296d2b35	8bc1489d-cd37-4ab3-ad35-fb2e2565255b	2	389.56	2025-09-25 15:49:21.360008+00
6ca25339-7a48-4d0e-9177-4c65bad390a3	be15e883-2c37-4a89-9dbb-d77fede72e32	53f1fb75-11ca-4299-858b-372f04dca7fd	4	360.49	2025-09-25 15:49:21.360008+00
f3e7daed-9598-4944-aba4-02a47727c18d	32c57f90-438f-4ff4-8607-c09e53b9ddfe	aac955c0-cf83-4bc5-9707-2cbc8cd5fde3	2	306.41	2025-09-25 15:49:21.360008+00
dd247b10-f728-476b-90f8-e327b85a2a33	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	1bb97fe4-a952-429b-9e82-af0cdfb9d700	5	449.76	2025-09-25 15:49:21.360008+00
7468cda2-ac14-4899-adb1-7e043954d890	b3e0dab7-bb8f-4118-9ffa-bf9eaef8898a	120d6ea9-b9d5-4231-b890-cd4132354f28	5	349.94	2025-09-25 15:49:21.360008+00
7eb4a3fb-f61f-4d5c-8ad7-55bf3f49eb74	104b98ef-d1ca-4281-9cdc-0cccad91ffce	9e6b28df-dc8e-4a28-a237-806f68027afd	4	177.75	2025-09-25 15:49:21.360008+00
c25bd265-d108-4137-83c9-6acca212e6b6	b988dff0-ccd3-4c82-bb61-5e6b2efb6546	77e2a768-b896-47a9-847a-07254252ea0e	4	446.33	2025-09-25 15:49:21.360008+00
3e2c7993-1574-4371-9d8b-0e95f3a86ba0	2f1b8741-8866-4267-90ca-5084ab49e155	bae15f80-741c-488a-8c41-d76ab1913368	2	411.06	2025-09-25 15:49:21.360008+00
7eecdde2-38de-4557-b4e2-024b2e0e1f42	47d04618-8428-4f32-bf9d-b7b282613d88	be8ab051-2528-40c2-a631-76a69ba9586d	3	488.11	2025-09-25 15:49:21.360008+00
6cb7a68e-be2a-4575-adeb-b000b0859080	04b226bb-5169-486d-ad2e-26a3f3c277bb	42a74d33-01c9-42ed-b501-39ffe285d680	3	165.17	2025-09-25 15:49:21.360008+00
bd8d98ab-cad5-4814-a579-08530fbb691b	9ddf866a-c7b1-480c-b2cb-a95cccfa1293	628570d2-cdaf-4cdf-8913-a3c5d230073f	4	181.43	2025-09-25 15:49:21.360008+00
7e9554d7-b2d4-457b-b9f3-5e07290345d8	9c349870-4a91-4fac-b1c8-a59c6d9aea49	49d33abf-57a4-4c58-bce0-ab6a700fc07c	2	135.36	2025-09-25 15:49:21.360008+00
6e8f0b99-f6f3-4692-8960-8208ea96c9b7	1c764e38-cd41-461a-9ec8-d97187982ab7	e8a66c29-6930-45e8-bc04-74979124ced3	2	120.69	2025-09-25 15:49:21.360008+00
cc432c59-bc62-4752-aa35-71a8e51b2b5d	733f73d3-895f-446e-b37c-58d672899e95	9dff09ea-3501-4a2e-a164-627b9e1073c1	5	365.14	2025-09-25 15:49:21.360008+00
6a2d28ed-e841-4fbb-8dc3-19984996ee49	a1a85a8d-8531-4710-9594-d07210cbaaab	f47e35e1-698a-4a8c-9db8-128f82ea6d5d	4	246.08	2025-09-25 15:49:21.360008+00
55a2f2d4-a2b2-4475-a9b1-1d9cf79926f7	3deb824a-cf6b-45b3-b5f9-819dbaeb3eb4	af2a2d7d-edb0-49b2-ad2a-dfb0d68b822e	4	157.21	2025-09-25 15:49:21.360008+00
f369969f-d09a-4714-a695-1cf9853b4192	91e34dfa-9d3d-4330-8713-cedf19705c2a	a229c4d3-5500-41e4-ab2b-36898ec53778	1	351.29	2025-09-25 15:49:21.360008+00
97587ed0-3b2a-4742-b65c-cf4ac178e08a	4d3ee623-2887-492c-9353-2ca117ab3d2e	4439085f-d4d6-4458-9e6d-703011ee1376	3	359.97	2025-09-25 15:49:21.360008+00
de5681ff-64c9-4deb-9bf1-b232ef8a9000	12d7868e-c1a3-4618-ab63-a56d9efc5c91	e22d5a6e-1385-49b5-837a-daf9c2e25836	5	78.84	2025-09-25 15:49:21.360008+00
1f5da8e5-eec2-463d-93f5-f6202a251c91	c9ca0c1e-8436-4524-b7f0-da21423547dd	c6975f71-dc00-421c-8c3c-b52c125afc91	2	471.30	2025-09-25 15:49:21.360008+00
901effee-8756-49ac-b61a-124623bdef0a	c88dad4d-3293-4c57-b39b-957991bb2f44	37a371b9-fcc9-4020-92f2-b41636c96079	2	469.81	2025-09-25 15:49:21.360008+00
a276018a-15bc-4652-8bbd-1f35efd0f466	45f0653b-a445-47a4-acc9-e13231abb0b7	2319c429-263c-43d4-bca0-7f7e22971c3b	1	448.90	2025-09-25 15:49:21.360008+00
3b25f625-7601-4214-ba97-a466d01d2a13	260c5ea6-e65c-47e4-b88f-a5345ad86fb9	764b0075-9267-4393-a044-298cac24410d	5	131.59	2025-09-25 15:49:21.360008+00
152c1748-9607-45a5-b92c-dd2991399e65	772d52f2-8383-43ac-b62b-8265f7d3fbb5	1c904265-71c1-40c9-8dcf-faa1f9f075e1	3	438.68	2025-09-25 15:49:21.360008+00
1d39b49e-af70-4ef6-9994-9b71ec88c0e7	281df8ad-c1e5-46b8-bc29-020b73430fe2	5f031354-7104-4787-8509-9f923d36b792	5	495.27	2025-09-25 15:49:21.360008+00
70e34530-409e-44f9-987f-714c9f0cea67	123c7f5f-6148-4cc1-8fbd-3289c7c15a2e	9b9271e8-4297-4c58-96c1-5197c0eabb7f	5	398.97	2025-09-25 15:49:21.360008+00
f99bcbc6-ba07-4739-be63-6133d47dcd96	a569ad72-ed52-408b-980c-c8dfbb18fe8b	c51d890d-f207-44ea-9d04-c039cf3d6dd5	1	25.54	2025-09-25 15:49:21.360008+00
73ea6ce6-e467-4c58-933d-6a3b2787f6c6	03a68ad5-ad3b-4c06-ad83-9715d026142b	6dd6c04b-c211-4ce7-b72c-c0761a4e14ee	4	181.87	2025-09-25 15:49:21.360008+00
d0c0a58b-a7e3-4f34-8b9f-dc264a051157	7a0e8803-b665-46d2-a9f5-79297739c1e6	c87778b1-dabf-42df-964e-6d6799653018	2	311.41	2025-09-25 15:49:21.360008+00
166b3686-6f42-49be-8071-5163f002bb2f	4b0ec16e-5805-48a6-ad94-28625f3522fa	4e310021-e795-48f8-95f0-c106494cb015	3	93.34	2025-09-25 15:49:21.360008+00
b1030b46-d04d-4561-a5a6-81cc2b7b53c8	503e4f9c-9308-4ebc-afca-553d4b11ecce	75423bf9-9773-4e43-a7dc-869dd3830e92	5	138.42	2025-09-25 15:49:21.360008+00
c034986e-5520-425d-be11-c80e4e78ede3	ae53cb3b-f436-4e76-aa4b-7a8df1809e7a	a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	2	220.91	2025-09-25 15:49:21.360008+00
6c823492-2619-4221-8780-021efd52d0bf	86860fb8-6f26-4f28-9be8-276d06c16b8a	fb808fd7-4048-425d-b811-16edd84f5cab	5	432.89	2025-09-25 15:49:21.360008+00
f5ff8d1c-2fef-4ff8-bb78-975fe2bfb1b3	79dfa4b0-c8eb-4de9-b1df-56832c39e35f	254f4daa-339b-403a-bd8d-8926449ae5be	1	56.35	2025-09-25 15:49:21.360008+00
2b1feb38-b90a-4346-ac40-8641b6d0fa33	1f0966e0-81ed-436c-abb8-a2767d522dd5	0262cb3a-42f7-4eb7-89cb-8f5d3372e510	2	406.61	2025-09-25 15:49:21.360008+00
da3d0e5b-a84c-4d58-8202-8c646a660d00	86517f8b-c37c-4bd9-83b0-d44a59b52fce	cf1e1bf1-e189-4e3f-bc2b-e58542713b9b	3	78.53	2025-09-25 15:49:21.360008+00
c996a409-05ee-45f9-84b7-5ed1d6f83571	0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	94de5b8b-bf70-4e04-b88f-60fa5052210b	4	159.80	2025-09-25 15:49:21.360008+00
a1b41b57-c770-4b87-afc1-36a543db5df9	733f73d3-895f-446e-b37c-58d672899e95	f36e8299-fc81-49a1-9643-a012f892462f	5	324.24	2025-09-25 15:49:21.360008+00
0c33ce63-292d-4530-a288-0b7e5250d7cb	fc8eb1ce-7d4e-4d44-9fc2-94875a65f24a	31870e01-19d5-4b77-aa17-9be9142218d0	3	138.44	2025-09-25 15:49:21.360008+00
51016fd3-cdab-4cdd-963a-57899c794ce9	3deb824a-cf6b-45b3-b5f9-819dbaeb3eb4	f6287873-8e98-4390-b5bf-f71ed8f5a890	4	11.81	2025-09-25 15:49:21.360008+00
f7a0d36f-1862-4e55-b603-ed5a746f4c7e	e897f67d-f5e7-45a0-804e-317267bb99e8	3c9d9922-e12a-4dc1-a5bb-59b17fb77bec	1	494.16	2025-09-25 15:49:21.360008+00
912fe7a4-091b-4064-b2fd-a9bd13ae6c59	c56ca266-c159-4ab6-9f7b-ddb3b2cd04d5	4165ae62-0553-416f-9c9c-41fd14f9f6ff	4	392.14	2025-09-25 15:49:21.360008+00
5bf5fdd6-7767-4503-bad3-1b6893457529	4e570348-6554-42ca-b80c-f98d2f79b055	99cbee9d-abd8-48fc-a7a9-1dd7ceb5a94e	1	262.42	2025-09-25 15:49:21.360008+00
ca48a953-246a-4f70-b51d-d68e444d5816	e9e7ddf6-004d-4f6c-893e-0b261662a06e	7e793ed9-4bb8-4eb1-8ac8-8fe73fe2d288	4	132.07	2025-09-25 15:49:21.360008+00
3f2d8ae2-9329-44cf-94de-f6b0869d1eb4	94616eca-5069-4a67-a50c-a0e30b58ea7f	8e4f9281-4de2-4a32-8382-9889f1a24801	1	92.00	2025-09-25 15:49:21.360008+00
6ff0a667-82bf-4a40-9157-4f9ffaf0f1bd	8193f4c2-47fc-41ff-989b-cd23b36c3374	5eb24da8-573f-4682-bbd9-9c03f2eac2a6	3	395.80	2025-09-25 15:49:21.360008+00
783338c8-f849-43c9-a0c3-20dac90bb83e	967c1496-21ee-4c91-b2b9-b43ed208655f	9fca81b9-db26-4b28-874e-1750710cbf3b	4	162.16	2025-09-25 15:49:21.360008+00
f1be2dc6-c384-4f53-905d-167ebc90a69d	6d8773f9-5e39-407d-b9b0-adbce97a9dc5	3da031bb-133f-4ad8-b643-bd1a5f886aa3	5	470.98	2025-09-25 15:49:21.360008+00
ba84b6b7-5303-41f7-924e-d52c51c88b07	52549fa7-0cbe-42b3-a714-11d46bfad8f4	d3839398-cd1d-4451-8ceb-c07ffef517b0	5	457.94	2025-09-25 15:49:21.360008+00
7ca4fba7-38e2-4bd2-98b5-e497a2511286	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	198aea83-e7ef-4117-b08d-87c5f12c28e8	2	186.97	2025-09-25 15:49:21.360008+00
3f3d8549-66ce-418b-b627-239d98916b08	82d0a438-b64b-434c-b699-3bb958b99683	c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	5	4.83	2025-09-25 15:49:21.360008+00
8f955264-5fa3-4911-97be-5688462a8f02	d4c1ef8a-7751-488e-8f5f-deb7d506d960	d781d9ee-a23a-4bad-aa1f-ec51c7b98b5c	5	451.44	2025-09-25 15:49:21.360008+00
81a66a6e-4d86-4446-bfc3-f109dc80067a	5c773ac9-d046-4afd-8ebd-8b75f756976b	ef112dbd-c95f-4e0e-b1a2-d607ddf164b6	2	115.01	2025-09-25 15:49:21.360008+00
791cf780-91aa-478f-a1a7-6f55724dfb51	ad175f2e-c4bb-4146-8eca-265407645116	30381c58-d8b1-47f4-a6a4-2c62bb899633	1	64.63	2025-09-25 15:49:21.360008+00
074ecc0d-e9fa-4c22-8996-498e6e496dfa	f4f69eda-bc2a-4145-9730-ab4d5cbf4e89	044fd898-06f8-4d48-8929-5acb15442c11	1	348.86	2025-09-25 15:49:21.360008+00
dde5de10-9f83-4509-a9e0-75eb001541dd	123604ff-db0e-49e2-8195-f688783fa74b	3ab25fee-76a8-4cc0-935a-3f98460ff7d7	5	213.06	2025-09-25 15:49:21.360008+00
10292e67-72cd-4366-9d80-6734137464ae	7a1bfb17-b859-4250-bf36-5ff26230b8fc	f7238f11-8292-46d3-9a25-47aa5820cb8c	2	236.28	2025-09-25 15:49:21.360008+00
6edefae4-2fc3-4f31-a769-fabaf0f2f94d	be15e883-2c37-4a89-9dbb-d77fede72e32	56a657c0-83d5-4bb0-908f-ac2797e3f43d	5	113.31	2025-09-25 15:49:21.360008+00
c4abdf16-adaf-41cd-ae7c-54e804ba4835	251661de-8717-434d-b047-add8040b9bf0	13404922-32d4-4b7b-93fe-08f504436a82	3	301.88	2025-09-25 15:49:21.360008+00
cd193e7d-a783-48d0-9d9e-d9f9e7a2023c	9208a3c5-c409-4c66-ac38-5d24f4798a1e	d55b1e7b-d82c-405f-99bb-267e0d272594	3	499.96	2025-09-25 15:49:21.360008+00
e7554baf-25a0-4c39-9fc5-f5fb7708735d	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	e8933d87-8ec8-424b-a393-c3fddbdf36d0	3	333.04	2025-09-25 15:49:21.360008+00
4905ce35-cbdf-4eda-a96f-34d3e905af2f	bd9572e4-f7f0-4388-948f-735bdb83daf2	7cb3179c-ca2c-4b60-88ce-300066649462	3	252.91	2025-09-25 15:49:21.360008+00
284fe20c-7620-400b-a703-b9eab1991b96	efdfbab8-034d-42de-97fc-e0807909bb0d	0014e265-84df-400e-8491-66e52724e161	3	22.27	2025-09-25 15:49:21.360008+00
e5642a82-074f-4b6a-9451-c7a9ff3d4e13	6d7d0f2b-4e86-4b62-bf16-76cb84921825	c089edcb-9113-4eec-8083-c2c56dd4ee24	3	172.93	2025-09-25 15:49:21.360008+00
6d28637e-b641-4e51-bd3e-527f742dd7e3	78ec1831-3694-4677-9a36-284665600143	fc8576b4-05cb-4469-bb22-7286c11c4107	1	240.22	2025-09-25 15:49:21.360008+00
7bb92d8d-11e7-4ccb-892b-bc9b14340621	05563c70-d86a-4726-ba56-30fabe6c2764	8980a61c-d2f5-47c4-802b-3bccd78b85db	2	320.76	2025-09-25 15:49:21.360008+00
c3577ff1-20ad-4181-a930-30526d779031	49a8611c-52f8-4199-9cd9-8147c287f45e	866ec54f-443e-4ee7-a605-619c43c6a6ac	4	60.88	2025-09-25 15:49:21.360008+00
be289a0a-9246-48bd-9ad1-b06f031db49e	d4c1ef8a-7751-488e-8f5f-deb7d506d960	c9268f65-058b-4a3d-9e71-0e83e2ad0f15	5	436.12	2025-09-25 15:49:21.360008+00
0d87b60f-bc8a-4f23-8219-1151ef4798ba	915e5bc2-8e56-417f-a081-ffeb296d2b35	2bf3df4a-c939-46eb-b584-d52d8b3e1570	2	184.39	2025-09-25 15:49:21.360008+00
dd4a374b-49fe-4ba5-9945-edc5d191a1c7	6222f2d2-7dca-4536-a261-64aafcb4a1c8	faa218cd-8b22-43f6-aa0f-df0d8b7993ee	3	90.96	2025-09-25 15:49:21.360008+00
6e97fcbf-6017-4a15-b728-bd4b3a53111a	e0ef9e43-0f15-4514-94bc-47922417f166	5eb24da8-573f-4682-bbd9-9c03f2eac2a6	2	367.22	2025-09-25 15:49:21.360008+00
f617e3f4-a544-49f8-a255-12c2b136e428	01d87596-cfd1-4a33-a5a3-afc687b9fc5e	37fa7e9d-79bd-4428-8772-04e080033aa4	4	369.87	2025-09-25 15:49:21.360008+00
ec58ea8d-597a-4194-b0b0-43d3a58c7952	f4f69eda-bc2a-4145-9730-ab4d5cbf4e89	337faa7d-82fb-4049-bcf1-e0f5ec4bfb68	4	10.85	2025-09-25 15:49:21.360008+00
3aedc4bb-15d6-4de6-bc48-681e5cdc03bb	7470174d-b026-4646-a890-96d13435d6a2	41f0863c-9837-4832-a26b-d2b73aa5a262	2	311.90	2025-09-25 15:49:21.360008+00
beb60f97-c9f0-46f5-8d7b-23505319b4d8	30bbe271-3b24-46e7-8cf9-1b29360fbd83	203d7106-92e4-4183-9ed7-b1c41bd80cdb	3	402.36	2025-09-25 15:49:21.360008+00
25930714-78ba-4913-9699-1519e748f83d	4cd05a47-7bfb-45f3-9142-0cb00b39f08f	36131294-16e8-40fa-94f5-5fcc003336f8	3	347.38	2025-09-25 15:49:21.360008+00
5527ab73-dd39-46d3-a346-1c25125751a0	5067949e-1cad-4b2d-94e1-ff4180e9526e	85c7838c-47a5-432e-b0f3-669d4a929ee1	5	75.55	2025-09-25 15:49:21.360008+00
4b5bdf9c-499e-4e4c-a416-d2bd975ca956	4b0ec16e-5805-48a6-ad94-28625f3522fa	6fb7b197-4beb-4c50-ad29-bc14326db41e	4	34.72	2025-09-25 15:49:21.360008+00
ca29ef57-d668-4126-a599-b68f7d4d9cf0	f5d9a35f-a471-4694-b45d-d24d9c682512	66f52fb0-6075-4cf9-b884-caf6c6b13e66	4	351.36	2025-09-25 15:49:21.360008+00
cd639bca-aede-4d0a-b6fc-85e74c977f72	7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	6254c18f-5485-43a5-98fb-2e85e1a91afe	2	137.04	2025-09-25 15:49:21.360008+00
91ade97a-3c99-4705-b7f2-66882e84209f	9baa1226-3fce-41c0-9415-863a8770c909	2566d6b9-b78f-4390-a3b4-5a334cef5230	4	416.72	2025-09-25 15:49:21.360008+00
61c76b8d-1038-4533-af5c-75197edc64c4	843741b6-d4c1-47a1-a562-cffa5623c317	e221f6ee-14c9-4737-9dd7-049752f4aac6	3	159.15	2025-09-25 15:49:21.360008+00
569793f9-b669-49e6-bad2-902b36149472	d9b325cd-29c7-44e6-a1dc-039aba44e40b	0ffe097b-c049-47ce-a8a2-d2ac648aaff6	3	489.00	2025-09-25 15:49:21.360008+00
1de432dc-8113-40c7-8b74-d870b0eabfbb	76aa7006-dac5-49a4-af4f-13a435e6b008	d2e095fc-f2ff-4502-8c47-01b10d503f0d	2	362.45	2025-09-25 15:49:21.360008+00
509423cb-f3e4-4dcf-8f4c-6e9f90d7f137	443b5fee-ce08-4994-98f5-b6b9c75e74f6	809b63b7-aeaf-4496-bc99-0694fe605c94	5	224.00	2025-09-25 15:49:21.360008+00
7a321b68-61ff-43e4-9835-f481777a850d	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	4ca3c954-9979-4d43-bb0d-5ed8d9f2ceaa	1	315.32	2025-09-25 15:49:21.360008+00
77515d53-1e1a-40bc-8067-238a7d359b7c	c1e0cd9b-4de7-4253-b09c-2fb7299fb30d	9a4e25a4-0a70-4f83-9843-5194af794055	5	371.66	2025-09-25 15:49:21.360008+00
cb353b64-bfb8-4087-8ccc-8b6076a6f7e6	38d8a74c-013c-4027-b2f2-721beb36de14	c80893b6-b638-4a83-b6ae-2b95ae123dae	1	90.24	2025-09-25 15:49:21.360008+00
7252aa35-80f1-46ee-8654-e5e58813a5fe	84e30ccb-1a2c-4aab-8f51-535fa4b30f24	a5dde8fa-5075-4d78-bd8d-a8b0b48456d5	3	377.81	2025-09-25 15:49:21.360008+00
0c48066d-b808-4231-b441-fd2b0c85bc90	a09b2292-9ea4-465b-ba62-d0665ac25f6c	36626c9a-a7dc-4179-8027-4c3435f1f2f7	4	259.75	2025-09-25 15:49:21.360008+00
aa5c31f8-0fa9-4b09-9a62-de9fee0f404c	750e4907-ab47-4e1a-a191-e6356a4962aa	bb353bdf-b32e-41ff-b04f-93cd52192837	5	306.75	2025-09-25 15:49:21.360008+00
e32f53ae-9818-4c6e-8c6e-77a6903b31bb	06507777-7b16-43a7-987e-7f191cb88b6d	59c60900-03b7-4a16-a338-f731470e8ec7	3	408.45	2025-09-25 15:49:21.360008+00
567388cc-76c4-43a8-a29e-860b83305250	47d04618-8428-4f32-bf9d-b7b282613d88	e24d4035-5902-4b41-b494-da0316041933	5	397.61	2025-09-25 15:49:21.360008+00
375a66a8-ce18-4871-ab48-a3c29599769e	de729129-ee71-4d4f-86b1-2b9f6413b383	2fc0cd25-6d9a-44df-9031-779a6b5d4bf9	2	445.31	2025-09-25 15:49:21.360008+00
530be78c-a279-4837-b008-34c11da35284	dfb005cd-0407-45b1-a52c-f9b50f1d1d65	c02e1b6d-eaf5-425f-931b-1a3af2175c32	4	489.13	2025-09-25 15:49:21.360008+00
6b5d74be-cbb0-4fd7-b544-74676ef388a4	e44192ad-6d30-4273-b02c-d05dc9017744	235995d2-8eef-44fa-b69f-6db5f284b312	1	438.35	2025-09-25 15:49:21.360008+00
3c0de257-e3b8-4e2a-9e8e-aa49df39a0dc	80277854-2b1a-4543-b441-c5280a2768c9	96f27450-67bb-4291-8154-1500feeb9253	2	58.95	2025-09-25 15:49:21.360008+00
909a25db-e56f-4b2d-a8fc-c1a8598c1999	81e3e409-d429-4a1a-b8f3-2e8e517dac57	8bc06db5-1714-4c98-8785-6d14c39abbba	3	47.55	2025-09-25 15:49:21.360008+00
21c2be05-2c12-4f7e-a451-a475119a505e	7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	b44bed20-df21-4afa-a304-5a70bf1661fe	3	140.39	2025-09-25 15:49:21.360008+00
015deb84-8cd3-41aa-b2cc-95160db2ca15	09810df9-2d0e-46f7-b38c-8258e166d908	f9801d3d-63f3-4956-898f-40dde6d01e9e	5	498.98	2025-09-25 15:49:21.360008+00
38197341-0734-4b09-889b-646d4f1c580d	80277854-2b1a-4543-b441-c5280a2768c9	3c9d9922-e12a-4dc1-a5bb-59b17fb77bec	1	225.71	2025-09-25 15:49:21.360008+00
08229833-31b3-4fc4-9853-54a421b6842b	26204835-dcc2-4a79-9c9d-3cd38271fcea	34c0124e-60b7-4ffa-ab69-1f879796474f	3	61.50	2025-09-25 15:49:21.360008+00
3e9787bf-0f1a-45da-84c9-9c2469169a4f	05639713-2fc1-4653-991a-6e7b6fb6963d	5dfd9857-fa8f-4524-8b5d-f7d14823b183	2	202.47	2025-09-25 15:49:21.360008+00
2b67c98e-12c7-4139-8069-0b1061f2e93f	38d8a74c-013c-4027-b2f2-721beb36de14	a78bcf16-ef7c-4b5e-a7cc-b77d0c780c2a	5	4.13	2025-09-25 15:49:21.360008+00
38bb9661-afb7-439e-80ef-6e8ed92dfcd2	21712398-44ef-4649-81cb-1d4a791df344	c4fffe59-53eb-4074-b43e-f6e66f39dd92	4	349.60	2025-09-25 15:49:21.360008+00
e98a2ff4-9aa8-4c64-9d7a-08f621e2e644	8b06a691-37b4-4a8c-8a84-e7c5b02f8369	719993bf-3a56-4afe-b749-4954fe4ab27f	2	317.08	2025-09-25 15:49:21.360008+00
b7977133-d58a-4603-ade1-2c00ffaee59f	84e30ccb-1a2c-4aab-8f51-535fa4b30f24	f6c35af7-4715-46bb-8d31-2969763c662d	3	431.67	2025-09-25 15:49:21.360008+00
12ab8f47-5ca4-475f-a542-9e8247880e96	d03d2567-bc3b-46a2-b2ee-11b8b8523357	5d6e3a87-4842-46df-882f-5e662fbccd09	2	146.80	2025-09-25 15:49:21.360008+00
d967a106-1104-48fc-9bb7-3c140b80699d	df5cfbc9-3b7f-4ef7-ad78-7e4479c99a9b	27a57e29-9044-4910-8ceb-6e40fe7b52c4	2	412.05	2025-09-25 15:49:21.360008+00
44973b36-69bb-4f90-a566-7bdbc32be0cb	c9c94223-2df3-4066-86e1-444b6a2ab4ee	a4f81295-eb15-406e-a8fb-d98a93712a53	1	32.91	2025-09-25 15:49:21.360008+00
ac7466d8-c9a9-401a-8971-875e3bb59210	919fe3d6-7154-46b5-bd5f-f3120fee1a0b	9f46816d-e9aa-4dc8-9ce4-4fd5079b4cd6	1	1.07	2025-09-25 15:49:21.360008+00
e55c8f61-8ce3-46f9-9e70-1c53d1266117	8b6a006f-45e5-426b-b53b-83a6496c83d3	694c7c50-b0e9-4984-8f01-c8a7f4107cd3	5	475.03	2025-09-25 15:49:21.360008+00
26154ad4-47b0-4a1a-925f-0f6f7ba9281f	82d0a438-b64b-434c-b699-3bb958b99683	37fa7e9d-79bd-4428-8772-04e080033aa4	5	340.23	2025-09-25 15:49:21.360008+00
22e85ea3-6671-44c0-a4c5-ff9ecf08c0fb	d03a1f35-5561-4042-a79b-ce2f6efed426	a067a03d-fb3d-4178-986f-3f263a72104f	3	192.49	2025-09-25 15:49:21.360008+00
950f0643-538e-48b4-8904-17a51a1c70bb	211ce5a1-1e43-42ee-afd4-5f0de060e8e1	89e83845-49f4-4dcb-be95-746a2504572e	2	175.58	2025-09-25 15:49:21.360008+00
80402673-9266-41cb-a2bf-0d5561263918	826e481e-d428-43a7-8889-ba4cc9ed227e	f86c5cc0-b356-4be4-b4ef-256000244a22	1	313.28	2025-09-25 15:49:21.360008+00
7fe33b14-2d2b-4264-8d22-865e02d3270b	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	c6a7491b-19f9-49df-937e-650f15262690	1	276.91	2025-09-25 15:49:21.360008+00
fb422a6e-0085-4dab-a6c9-4c8342a75177	a55c6aed-e1cd-4ae6-8f53-b37cbb1ab41c	88a8d5a7-169a-448d-a9df-7e12953611da	3	93.78	2025-09-25 15:49:21.360008+00
607d1115-3069-4e00-807a-4b9d0be45a3a	e0ef9e43-0f15-4514-94bc-47922417f166	dc3c4bdb-d9e6-47b0-b642-cd10d9f663ff	4	75.13	2025-09-25 15:49:21.360008+00
05dd3b2f-3b75-4198-b1bb-78044ad4e650	d8bf79f9-672b-4378-93a2-2225b3938f84	a65185d7-00c8-4d26-ae2a-f954adf0ab0f	5	375.43	2025-09-25 15:49:21.360008+00
d4297bda-6835-42bd-8c44-71db3a15e8a2	52549fa7-0cbe-42b3-a714-11d46bfad8f4	c110f3b0-4c75-4fee-a723-118fa839b84e	4	144.46	2025-09-25 15:49:21.360008+00
fa9d49dd-c241-4d55-92e9-3458e5f073c8	a8f1300e-9928-4a6c-87bb-88e67dc80007	fe6b6e4d-2292-4b2b-b115-c39f1a8783f9	1	408.46	2025-09-25 15:49:21.360008+00
dded8700-ea55-410f-bcc8-30e8b8bfea8e	272b6776-dddf-4ab4-ac22-a81e85805712	99b4888e-0ed2-4039-9423-661b9705cc63	2	106.69	2025-09-25 15:49:21.360008+00
36bf153b-9740-4bcc-b39e-5912e33d9be0	bea8c473-528b-41cf-b562-335723212cfc	50e4f74a-a750-4ab6-b4ff-7f680f604249	1	392.09	2025-09-25 15:49:21.360008+00
74671886-f5ac-4370-bc0d-16441fbc3246	ae7a7873-27e1-459c-920d-91748499d60c	0dd1f0be-83c6-4475-b0ad-e139e2fd6562	3	341.11	2025-09-25 15:49:21.360008+00
313d85b6-7681-4830-9290-fd662f53e42b	7078a458-4849-4d87-8dd1-f705e9d204e9	75ad64fb-062d-4f05-a145-5fac4710ecd2	1	485.59	2025-09-25 15:49:21.360008+00
063b7a15-da80-43f1-8164-fa208e4736c5	e4c5f085-7c50-4767-ae55-f27b0095ca5a	8dc7fa3a-ab89-4405-b1ad-301b6a89afde	2	5.46	2025-09-25 15:49:21.360008+00
f9e92dac-e1dd-4b40-a932-5987bd1c2cee	5079071f-a132-45a2-bd5a-34450f07a36c	b2c3bbf0-8067-4c0a-8c0d-2cf646c99ee0	2	370.69	2025-09-25 15:49:21.360008+00
c0424389-f644-4149-972f-55ef9e58a461	b3e3b19b-4095-4ade-ab42-48bcd45a84ad	736b283a-1808-46e4-85f3-a44cd7ac8a3f	5	453.14	2025-09-25 15:49:21.360008+00
90de81ca-6f63-42cf-943f-af39f4f1b1f2	01d87596-cfd1-4a33-a5a3-afc687b9fc5e	ed0e0cee-7afe-4af3-a074-002f8339d094	1	203.77	2025-09-25 15:49:21.360008+00
046a1c47-1c1d-4f20-90c3-caab87e797ee	4942c836-17b6-4f00-b02b-588aed15e9d3	705a8ddf-88f4-4ace-8cac-384c51b77125	4	293.53	2025-09-25 15:49:21.360008+00
952d1bb5-a83f-4e17-be67-c0bf3e857145	e7af09a0-4128-438c-8b0c-fd71bf4172de	9382cd8d-9410-4b85-97ca-6288b82a734e	3	233.94	2025-09-25 15:49:21.360008+00
af4e51be-161e-4776-8241-ab7620ff141d	6d7d0f2b-4e86-4b62-bf16-76cb84921825	430f6e5d-6537-4ebb-96e5-aeb0777827fe	5	55.73	2025-09-25 15:49:21.360008+00
6f32f324-62c5-4d4d-bfc1-afec66252c12	78ec1831-3694-4677-9a36-284665600143	02ed6ab3-2074-4dd9-a6a9-c8160abc4bd0	5	225.39	2025-09-25 15:49:21.360008+00
314956f3-6c62-451d-9236-fc8367c7126d	a3dae141-e372-465c-a11f-cb3972d4649e	6a273237-8b22-41e9-b314-77bac06d3bc0	3	160.18	2025-09-25 15:49:21.360008+00
417442d4-d141-42a1-bb76-7eeee8af6a21	7078a458-4849-4d87-8dd1-f705e9d204e9	5c911ffd-8f0f-4b09-9325-70e6270c87af	5	77.66	2025-09-25 15:49:21.360008+00
9d2b8100-40bb-41c8-bd58-5353a75de50d	443b5fee-ce08-4994-98f5-b6b9c75e74f6	0dd1f0be-83c6-4475-b0ad-e139e2fd6562	3	260.58	2025-09-25 15:49:21.360008+00
4be048ef-a970-443a-86a0-2be3816aa0b4	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	81fb946c-0924-4f49-b172-7d321746b6a7	4	146.92	2025-09-25 15:49:21.360008+00
bf92320e-0f14-4b1c-b116-2be646db0f4c	17696562-545d-411b-96ac-553be0bd74d6	e2f787f5-e9af-445e-82fb-c82755ad983a	4	435.26	2025-09-25 15:49:21.360008+00
5e334ae0-297b-4245-9874-d95e57f869fd	06ec6966-1cbb-4cf9-8f63-482325332370	d55b1e7b-d82c-405f-99bb-267e0d272594	2	293.30	2025-09-25 15:49:21.360008+00
8f00b4bb-5140-48a0-aeb8-f1f56ff143d4	83760171-3ba4-4784-a5b9-989f166356d5	49d33abf-57a4-4c58-bce0-ab6a700fc07c	2	277.32	2025-09-25 15:49:21.360008+00
c56dea17-924d-44ab-82f1-9e21c32ca15d	88208539-9376-4877-ae9b-8071dc1d8d98	f1d31ebf-68df-4473-b61f-bf3c24343c0f	5	386.35	2025-09-25 15:49:21.360008+00
10602a19-5050-42c2-ad13-0294336a6df0	38d8a74c-013c-4027-b2f2-721beb36de14	67cfddcb-98cd-4580-a845-be518779ded0	2	261.24	2025-09-25 15:49:21.360008+00
88d98b21-dcf9-4605-8364-381a7bf6a8dc	06507777-7b16-43a7-987e-7f191cb88b6d	c79544e7-ba7b-4321-9636-7083dfe7fbd6	3	50.80	2025-09-25 15:49:21.360008+00
1584380e-e679-4fd5-b9bd-0c3c0c202986	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	aafd4c57-d44b-464e-b877-504a4daad1ef	3	19.73	2025-09-25 15:49:21.360008+00
afa535c4-9b5e-4823-a6d4-aa728d12f91e	21712398-44ef-4649-81cb-1d4a791df344	521f9a88-417c-4ec7-9451-125b852780b5	2	231.97	2025-09-25 15:49:21.360008+00
ee93a259-4e55-4744-9177-e0da51a6dac4	f4601bba-35a6-4906-9539-9e3678219a62	fd91f3dc-8855-4ec0-882a-a26e8ccc83a7	1	124.37	2025-09-25 15:49:21.360008+00
8601c083-1885-4aca-9c67-46ccc15a3cc2	485de802-4452-4547-8511-26b2526e13ff	2bf3df4a-c939-46eb-b584-d52d8b3e1570	3	378.31	2025-09-25 15:49:21.360008+00
ed546cad-5d9b-47d5-82ff-d6d640d243f2	c3c934db-f8c9-47be-8b8c-fd7ee1156937	89e83845-49f4-4dcb-be95-746a2504572e	1	7.11	2025-09-25 15:49:21.360008+00
18e60d4d-8ff6-406b-b3ad-9d0f81dd5705	05563c70-d86a-4726-ba56-30fabe6c2764	64979d06-6350-48ee-9931-f5e895d3ccfc	2	201.87	2025-09-25 15:49:21.360008+00
7fa3a2a5-e0e2-4dc4-a01c-248080a3bce2	29c44409-4491-4a6a-8843-fff08882f07e	484224b2-0dce-4aa4-9b8e-2943d495564b	1	456.19	2025-09-25 15:49:21.360008+00
b98ec462-4002-4e73-8072-0a22df0c220c	a1963124-0e73-4dcf-8487-9e22573e91fe	cacd951b-2ee2-45d8-bff8-f3d08498e804	1	487.07	2025-09-25 15:49:21.360008+00
bedc23c1-e076-479f-982e-a2a62cb97a01	30bbe271-3b24-46e7-8cf9-1b29360fbd83	63644e2c-a2bb-463c-b38a-f889a9b401c6	1	496.59	2025-09-25 15:49:21.360008+00
e485a9ed-1848-44b9-a68d-df42035863a0	b9e2ae9c-46f9-45ae-944a-955e3f9a4952	69bb44de-94a8-4d30-b00b-0761bd1538e1	1	488.45	2025-09-25 15:49:21.360008+00
4b165c85-9187-4a2f-9a09-c9b3dd4304fa	dff49b1c-3584-4537-b0a3-39b63729570a	48f259b0-8a2c-4258-b06a-907f2f255334	4	443.30	2025-09-25 15:49:21.360008+00
8d61f7a2-85af-4720-82e0-620b8ed82617	cc1c0fe4-871d-42f3-aecd-3606874ffa5d	4ed917e1-6310-41bd-b1f0-4513a3b8c1f8	5	423.13	2025-09-25 15:49:21.360008+00
df931d40-368e-4d93-85b0-d158e9372f11	ad175f2e-c4bb-4146-8eca-265407645116	d8d4082d-189e-4269-bd4d-b8a3527eaefb	1	30.76	2025-09-25 15:49:21.360008+00
ca14a56f-5d5b-474f-a88b-31b2d4f2fdca	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	9fca81b9-db26-4b28-874e-1750710cbf3b	1	211.90	2025-09-25 15:49:21.360008+00
ce63a090-3e76-48c5-82b5-e09988fb5e29	d03a1f35-5561-4042-a79b-ce2f6efed426	0c131e48-2bf1-402a-a2de-fb03d45a6173	4	187.54	2025-09-25 15:49:21.360008+00
474b5c1d-3dbd-40cb-8c67-a24ec957a21a	772d52f2-8383-43ac-b62b-8265f7d3fbb5	03975248-b6dd-4fd1-a2cf-aea26f94aa36	4	225.53	2025-09-25 15:49:21.360008+00
25005153-04d7-4b59-a5da-a9333188623f	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	31b75483-396b-4a98-a51f-63b3e8216865	2	75.37	2025-09-25 15:49:21.360008+00
6691a612-b92b-42f7-84a8-0917e6493ad0	41bc1f19-483d-4acd-a210-0fb701278bbe	628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	4	368.47	2025-09-25 15:49:21.360008+00
0d72d938-9c25-4fe1-9f1b-badde9fd6509	86517f8b-c37c-4bd9-83b0-d44a59b52fce	198cd3a7-9f2a-493a-8d28-781f30037bd0	4	410.61	2025-09-25 15:49:21.360008+00
a86306d6-0751-4397-9507-ec58e4204dec	8ad3c805-448c-4596-a4d3-577c1ef68b79	bb9e8516-b78b-44b5-8554-6118185a0bf0	4	282.17	2025-09-25 15:49:21.360008+00
e8dbc5af-b443-4b23-a73b-078522ce244e	04ba2842-1c75-4c0a-9440-138d32d842bf	e033ca53-db4f-42b9-b50b-1bcb17480a5d	5	323.60	2025-09-25 15:49:21.360008+00
5310bebe-ce8b-4ac0-b53e-6b9fd2b9123f	cc1c0fe4-871d-42f3-aecd-3606874ffa5d	db6614a2-13de-4516-aac9-870bb9ab87f3	1	57.75	2025-09-25 15:49:21.360008+00
644690ba-7828-4765-83d1-e1befa4587a2	7a07cac1-cb16-48cc-a35f-dd7974c78726	2b794777-7b61-4a09-9156-dcf8248bda2a	1	63.06	2025-09-25 15:49:21.360008+00
e18d19c5-dceb-4f9f-acf8-45d4e1b437b5	32c57f90-438f-4ff4-8607-c09e53b9ddfe	c433fb1f-48e5-4b80-80e6-3c01bf2015a2	4	407.42	2025-09-25 15:49:21.360008+00
1a870df1-095f-4ce3-b5be-1284adfac3cc	dfb005cd-0407-45b1-a52c-f9b50f1d1d65	5e955770-be3c-4861-a9bd-ce75cf16d612	1	223.69	2025-09-25 15:49:21.360008+00
b998aebc-7e57-4d28-897e-2b055743b272	7f676a50-1486-44ae-95d3-b223ab0ca9c5	d41c2e97-0aa8-4cde-a49a-97dbbdbdaeca	4	312.20	2025-09-25 15:49:21.360008+00
58ecc707-bb14-436b-8a51-f97197e9ac1a	0fbbd80c-1f78-49a7-a474-06be4c1258fb	39d35def-0cac-4a8b-9ba5-89d172693cc0	3	438.06	2025-09-25 15:49:21.360008+00
595a8e81-7383-47a5-a919-f4cf28b5f899	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	a4f81295-eb15-406e-a8fb-d98a93712a53	1	291.76	2025-09-25 15:49:21.360008+00
ec5ec22c-479d-4304-8d2d-83eb1ab0d4b6	c1cd7c6d-9072-4172-8c7d-bdcb86d702f4	dd96e686-fa93-43ea-8ff4-a2525f0c8f6d	4	430.67	2025-09-25 15:49:21.360008+00
64c3d4d8-a79d-43e5-b579-f7d3cab3f0c7	c4a24deb-273d-41a1-8c33-cdb4fe790380	a5c886bb-dda2-447a-bcff-dd304e8e85f7	4	429.16	2025-09-25 15:49:21.360008+00
bc05e917-715c-4247-b11e-8110ae429378	91b0003f-07e6-45b7-a193-7741a96fe39c	36131294-16e8-40fa-94f5-5fcc003336f8	5	217.16	2025-09-25 15:49:21.360008+00
dcb78972-7c76-41af-b437-bf81363ed7a9	a3dae141-e372-465c-a11f-cb3972d4649e	f4429a7d-1708-4564-afa1-873cc4345c03	3	444.55	2025-09-25 15:49:21.360008+00
1ab8e4f0-78a6-47f4-9198-706ce9338699	94cbcd20-2c3c-4343-812a-e323c45b0111	d62ca090-da75-414d-bc20-2aec5141f470	4	305.11	2025-09-25 15:49:21.360008+00
1a73c60f-630f-4a47-8ae4-dada76e42f74	f3c7a23e-eeb7-4cd9-a82e-9b95190bab95	a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	1	257.14	2025-09-25 15:49:21.360008+00
794b3bfb-f4f7-402d-83b2-9122a166cecc	dd1f1551-f4d3-40b3-9887-780273c7d8c4	240219a6-3502-4dd0-b3b6-7589050f2b81	2	193.79	2025-09-25 15:49:21.360008+00
6f1e9479-20c9-4a54-85f9-ba1dc051cd5f	9baa1226-3fce-41c0-9415-863a8770c909	f36e8299-fc81-49a1-9643-a012f892462f	5	255.46	2025-09-25 15:49:21.360008+00
442f8742-8399-460e-a082-8dec97d90a99	d94e1b98-75f7-4be4-8e3a-ef61e09030ea	0ffff1c4-87a2-4beb-b40e-40395ceedad5	2	341.14	2025-09-25 15:49:21.360008+00
a8881c8d-8ccc-4a47-bc97-53096cf2625e	25b251ee-fa6c-452f-b0eb-a3f90e9403d0	7fbd0972-f9f6-4800-bfca-53cdc4950908	3	113.85	2025-09-25 15:49:21.360008+00
de925462-74ea-4b74-873a-e1e990bad6c1	6aaf8114-6b7e-433d-a650-c54005da2285	172f7972-39b2-4182-903a-8ac4660a5478	3	286.79	2025-09-25 15:49:21.360008+00
d0b2315d-2031-4166-a367-6f919180db38	88208539-9376-4877-ae9b-8071dc1d8d98	9d108fa9-0eda-4747-847c-2557ebd3e468	3	285.22	2025-09-25 15:49:21.360008+00
78f33626-63de-4e96-aca1-b3dbae8f0b03	f0fd942b-8398-4ecc-8c53-eb8ae30b5908	6511939c-616c-4cdb-8268-d754d2c03d46	5	263.83	2025-09-25 15:49:21.360008+00
30ee12b6-b3ea-49ce-9e23-731123da443d	3b72660b-c141-4949-9a58-1991db90bf7d	fb808fd7-4048-425d-b811-16edd84f5cab	4	393.77	2025-09-25 15:49:21.360008+00
e3f321fa-10b9-42b1-bef2-a9d3e4224c05	20c128f4-782b-4e22-aae7-8675571d5216	4ca3c954-9979-4d43-bb0d-5ed8d9f2ceaa	1	235.50	2025-09-25 15:49:21.360008+00
1b212838-a621-4d74-a520-9e945ade1258	4942c836-17b6-4f00-b02b-588aed15e9d3	a8ae8cf4-1975-4e07-a6d3-104867375a8e	2	417.30	2025-09-25 15:49:21.360008+00
f32534ed-5039-4859-b233-dcce7d43197e	45a00a80-5f66-4221-aa82-5a7d75d997b9	ffbd23bb-fb48-4f33-b711-932063f46416	4	416.49	2025-09-25 15:49:21.360008+00
98f17b20-e1ef-44e5-a0e1-a949c6983114	a55c6aed-e1cd-4ae6-8f53-b37cbb1ab41c	db25a60b-7e10-4a3e-985c-862e305d8d12	4	494.64	2025-09-25 15:49:21.360008+00
53e388de-4577-46f1-8e8b-f74c071040ab	41af7684-234f-4c36-93d9-550f6dec9dd7	861a0ba1-2b5c-4a44-8421-ea507e016cc9	4	211.42	2025-09-25 15:49:21.360008+00
5759d6dc-7464-4873-b18a-fd858407bfc1	79dfa4b0-c8eb-4de9-b1df-56832c39e35f	5b2376e3-ced5-47e6-b110-771f51287033	4	291.80	2025-09-25 15:49:21.360008+00
bf6a1b8e-0895-4f25-81d6-a6db28defffe	24c6a1e6-b633-4ba9-88c6-5c6563dbc936	c1746368-b8da-4994-ab96-1d008bd54718	5	282.48	2025-09-25 15:49:21.360008+00
30f8f0c4-d9eb-4285-bea9-57a80a3f8861	44bfddf1-9b55-4e7a-bab3-974805d20e1c	0a561629-6faa-4571-a7eb-d47ada634332	1	222.64	2025-09-25 15:49:21.360008+00
b1d33cd2-d997-4067-9e49-aade2d6a4571	12f7f9b0-31c6-41cf-98b5-88aae39e68b2	25dbebc1-c41d-4e42-a4c1-fdc78888a14b	1	4.71	2025-09-25 15:49:21.360008+00
21760d91-aa20-44cd-8ff3-3044af7c6ea9	3b72660b-c141-4949-9a58-1991db90bf7d	884e381f-f04b-4179-a918-804407cdc849	1	166.11	2025-09-25 15:49:21.360008+00
44c665db-a2a5-460c-8007-a5958c3994dd	a1a85a8d-8531-4710-9594-d07210cbaaab	6abb415b-fe4f-4793-ad8d-868a795e32ec	1	400.49	2025-09-25 15:49:21.360008+00
fbaf82de-0595-4598-b9bb-b4fc4c5df952	1f0966e0-81ed-436c-abb8-a2767d522dd5	096acccc-845a-4f8c-a4c9-4c2ee83dfce4	1	104.71	2025-09-25 15:49:21.360008+00
6d6a72e0-068d-414d-b2b8-a23cb9b6dafb	123604ff-db0e-49e2-8195-f688783fa74b	75f7715c-75c0-4a2a-b649-b0c6e49d2294	2	396.33	2025-09-25 15:49:21.360008+00
ece73026-2fcd-4349-aacd-1bf1dbdc5cfe	e1377f75-64b9-426b-87e8-d40f511170c2	94de5b8b-bf70-4e04-b88f-60fa5052210b	1	72.48	2025-09-25 15:49:21.360008+00
15ce0764-cdfa-4bf5-8b9c-e284be810bb0	7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	bd895a29-ec6a-43e9-b05d-b747bc7c1ac3	2	233.18	2025-09-25 15:49:21.360008+00
39f2cc8d-0fb1-4276-b977-44d6dae7305e	b2de3ca3-8b8e-4329-bc10-05b361d10901	7e1bb644-625c-48c5-ab0e-19ba4af3b7ac	3	382.15	2025-09-25 15:49:21.360008+00
81d02582-eff0-41d9-a657-73a647e5cbd2	251661de-8717-434d-b047-add8040b9bf0	7f72cfc7-633d-4d9f-a31e-e0424be358fb	1	325.18	2025-09-25 15:49:21.360008+00
91480e11-7c65-467c-b306-a3f5d07c1be9	326e3fff-476a-4842-91b0-53752eb15c7d	a249e695-7d78-464f-a3b1-a328a4cf7e38	4	246.36	2025-09-25 15:49:21.360008+00
fb198943-814a-4e28-9f53-720d7db9acce	6fc62102-14fa-46c8-be9b-cf3935b4f0ae	4826f8ee-9b6c-4fcc-b26c-96542ce2a7ef	3	52.36	2025-09-25 15:49:21.360008+00
957b5972-f57b-428b-b4b7-a7077f215b95	e0ef9e43-0f15-4514-94bc-47922417f166	d8cc973b-ce87-4abb-b851-b83ef3c6939e	5	441.96	2025-09-25 15:49:21.360008+00
a3fb4b88-5fb4-4b24-99a7-c93408a4fe81	188ba3fb-b338-4cc0-b018-e1fe625804b2	7ed809ef-5f5d-4e5a-b537-acc589b4dfdc	3	94.74	2025-09-25 15:49:21.360008+00
23b2ca8e-8eef-412b-937a-bd1f29e4062b	3deb824a-cf6b-45b3-b5f9-819dbaeb3eb4	c96f321a-391f-4fe0-b189-23b2294f7466	1	256.59	2025-09-25 15:49:21.360008+00
b0d10dbc-c9b6-415a-864e-1468dd51c17b	180172de-af0b-4c91-8f84-2568a026fea8	50d5fe28-104c-4636-a8d3-478901f022be	4	360.88	2025-09-25 15:49:21.360008+00
4483a1c3-b6af-4c64-ad61-8f308b77e4b0	0671af9d-ac83-4eee-82fb-e686ea253334	3fac4767-44ef-4993-ac72-c5381feb5e83	1	314.54	2025-09-25 15:49:21.360008+00
b4d8a7b1-f220-46be-847e-6845f82a604a	826e481e-d428-43a7-8889-ba4cc9ed227e	430f6e5d-6537-4ebb-96e5-aeb0777827fe	2	495.53	2025-09-25 15:49:21.360008+00
902a124b-adba-4ca4-bcf8-0ff164e834ad	f3c7a23e-eeb7-4cd9-a82e-9b95190bab95	59949c43-3538-465d-b575-326cbdf39557	4	356.74	2025-09-25 15:49:21.360008+00
7e98cefc-f349-48e7-aae0-123b577ea495	6be97509-6f0b-4c4f-8e6a-b27529c67133	c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	1	233.32	2025-09-25 15:49:21.360008+00
20aacdbf-5b73-4a5f-8299-c4a6a378d4c1	09810df9-2d0e-46f7-b38c-8258e166d908	f6c35af7-4715-46bb-8d31-2969763c662d	2	211.18	2025-09-25 15:49:21.360008+00
9374ac52-ea0e-4f44-898d-9906429efc26	8bb9b9aa-1719-4a93-892f-307d85090bb4	74baed34-5bd9-4797-ba16-64c96ea776f4	2	385.92	2025-09-25 15:49:21.360008+00
c7056bce-96fe-43f3-9d5a-5815cf034835	d3569393-985f-4053-b8f4-5e14fc51b461	484224b2-0dce-4aa4-9b8e-2943d495564b	2	21.96	2025-09-25 15:49:21.360008+00
ba9c6800-b06e-467e-aa7f-89b0518bef97	32c57f90-438f-4ff4-8607-c09e53b9ddfe	9ea6300d-c39a-4e7e-991c-c5772ee95795	4	17.96	2025-09-25 15:49:21.360008+00
8e33428f-aebf-498b-a9e4-2a31b39bd59f	17696562-545d-411b-96ac-553be0bd74d6	f7238f11-8292-46d3-9a25-47aa5820cb8c	3	23.81	2025-09-25 15:49:21.360008+00
0e46d7b9-ee17-4cf6-854f-6e2f785da754	0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	2cd83dca-d805-467d-a87e-1472adf2f656	5	285.24	2025-09-25 15:49:21.360008+00
c9d9bd4e-9665-435b-bcc1-a4eba3c4718c	123c7f5f-6148-4cc1-8fbd-3289c7c15a2e	764b0075-9267-4393-a044-298cac24410d	1	20.13	2025-09-25 15:49:21.360008+00
d6c64731-aa60-4c38-a376-8c3fb4fee150	d3f139c5-20f0-4814-9d64-89d703cbf5d1	9e343fbe-d188-43c7-aae5-034b69c48952	1	27.19	2025-09-25 15:49:21.360008+00
cd22c67f-5ead-4a90-aa5d-3f6642b31a6d	2f1b8741-8866-4267-90ca-5084ab49e155	905533f0-1768-4875-af44-c40f2f12fcbf	5	329.12	2025-09-25 15:49:21.360008+00
c6330c17-6cf7-446a-865f-130690cee3b1	e89e3c79-c3c3-49b7-a2a7-07d311c5bf8e	9ffb6cbe-32ca-4b86-a399-f0dd4836be95	5	367.52	2025-09-25 15:49:21.360008+00
6b2cef21-1a40-474d-a328-7f0a858e4965	e44192ad-6d30-4273-b02c-d05dc9017744	bd45195c-2758-4f02-b57a-53fbac8b4cff	4	471.23	2025-09-25 15:49:21.360008+00
3ed2765b-0e9a-4fc7-a124-0aa9e29b5e92	af68737a-6f35-4095-8e08-f693aca5b974	3c3a0c10-ffb2-41b1-b588-db7e4a79936b	2	409.23	2025-09-25 15:49:21.360008+00
4481f886-4aa8-4835-ac13-1d7985cea181	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	5	291.83	2025-09-25 15:49:21.360008+00
9ef14604-ddbe-49cb-a399-38fcf02889c5	efdfbab8-034d-42de-97fc-e0807909bb0d	95fdab27-0aff-4ae3-af8b-3fcfc6220729	5	170.25	2025-09-25 15:49:21.360008+00
22e0d467-fce3-4e38-8b05-de07d2160e3e	987edebe-d35c-419a-b283-24996973dceb	ccc32aa1-6f22-4243-a460-765f77b1372d	4	432.13	2025-09-25 15:49:21.360008+00
6c6d2ae8-0e92-45e7-a5fe-1712f780935e	6aaf8114-6b7e-433d-a650-c54005da2285	94d5fd54-f886-4df1-afe2-7840ea858b5a	3	78.77	2025-09-25 15:49:21.360008+00
6af88448-ee58-4a34-83d5-ac2023f1d61a	a1a85a8d-8531-4710-9594-d07210cbaaab	57ca259d-950a-42a3-8abb-27c0512226f4	1	87.53	2025-09-25 15:49:21.360008+00
ee11cc92-18fb-4595-8cf2-e1c4cb64dd54	a569ad72-ed52-408b-980c-c8dfbb18fe8b	d87dd82d-0c97-44fc-9577-ad25303dd28f	4	419.82	2025-09-25 15:49:21.360008+00
cc92183d-fc80-49d3-81ef-f0d7f023ad82	20c128f4-782b-4e22-aae7-8675571d5216	7977b6a4-2f51-462e-b730-66f18785dbdb	3	209.21	2025-09-25 15:49:21.360008+00
ef576995-f205-48ad-a84a-ac237bbd987b	c14adf70-0385-4c05-958d-e07e8154e2c7	7fbd0972-f9f6-4800-bfca-53cdc4950908	1	340.61	2025-09-25 15:49:21.360008+00
428d87ba-4cb1-4e7d-a2b5-e89001f1eea3	e55fe7d6-aded-49e0-8610-544f5560872e	7707eedb-41cf-4d16-ae58-84ff56a12124	5	424.40	2025-09-25 15:49:21.360008+00
92e9644a-d163-4e6e-93c9-c95450a3a748	750e4907-ab47-4e1a-a191-e6356a4962aa	2d8a95df-f61e-470b-bc89-6f0d712c896b	1	287.63	2025-09-25 15:49:21.360008+00
3ee671bb-6820-4a4e-bbf2-c0cb6f77af77	5147a3ed-5fe1-49b2-9610-5df09c3c7f92	fd91f3dc-8855-4ec0-882a-a26e8ccc83a7	3	391.17	2025-09-25 15:49:21.360008+00
f24e6eb2-01be-4c2b-a604-dfd4b525d6f9	123604ff-db0e-49e2-8195-f688783fa74b	603e65d0-ecfa-4601-9ae6-931c14e772a4	4	351.05	2025-09-25 15:49:21.360008+00
25b40f18-11ce-43cb-9bf9-8c39723ebd44	21712398-44ef-4649-81cb-1d4a791df344	b0d4e638-18ea-4597-9d84-7d64c9882b62	5	126.77	2025-09-25 15:49:21.360008+00
b6438ea7-13c1-4584-b556-8723521e0019	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	19df3a58-27fd-4b03-bb58-f2542acecd7e	4	446.17	2025-09-25 15:49:21.360008+00
80e1ea94-e716-4add-b028-4de19c2850db	47d04618-8428-4f32-bf9d-b7b282613d88	1ad9d18c-2c66-4b7e-8a06-e83dae22239d	3	482.73	2025-09-25 15:49:21.360008+00
b1ae3667-c929-4011-bc5f-be1b9351d644	24732732-58ca-4efb-9165-3c9b0d9471af	7b6dc38b-d444-4921-bda3-16f738f7dc68	3	19.90	2025-09-25 15:49:21.360008+00
d361d63c-3323-4404-9834-8a84b5f57dd4	9baa1226-3fce-41c0-9415-863a8770c909	18d31cbe-f902-4211-b855-a8199875a0d1	4	147.47	2025-09-25 15:49:21.360008+00
acd9b5b3-0f20-42a5-b45f-d00fd0961c22	8ad3c805-448c-4596-a4d3-577c1ef68b79	3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	5	209.90	2025-09-25 15:49:21.360008+00
0aa004ee-b765-425b-9b1d-9cd6bd422926	e4c5f085-7c50-4767-ae55-f27b0095ca5a	e5f9b502-0800-4d62-9587-c5f2eba33f79	4	454.32	2025-09-25 15:49:21.360008+00
92ef66b7-366f-4da0-8461-6449134ff9de	9ddf866a-c7b1-480c-b2cb-a95cccfa1293	7b9e6416-f965-4255-9f0b-b4dfc27b980f	1	416.82	2025-09-25 15:49:21.360008+00
eba3fb50-5a1d-4394-9b46-653027f6f0a7	ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	3	217.36	2025-09-25 15:49:21.360008+00
87055460-8150-44ab-a992-bf22cd9cc81a	e4561b0d-c677-4aa0-8350-5560a9fc3289	f493aa7a-aec6-47d6-8be6-182d308b904c	3	25.60	2025-09-25 15:49:21.360008+00
c02ca09f-a649-45e3-a8d4-41ceaaafa759	de729129-ee71-4d4f-86b1-2b9f6413b383	9d039f27-429a-4d94-95ce-f740a903b200	5	79.38	2025-09-25 15:49:21.360008+00
46a1e59f-8797-4860-9798-e198b4b2acb4	3c5b50b1-2d09-479e-8389-e5daeea8257a	6a272495-c7b0-446a-ac47-69f5d91e4f26	1	115.24	2025-09-25 15:49:21.360008+00
60962c76-a067-4c25-bd05-2b53e0d4fb05	d10ee357-d8f1-458e-8484-fcacc5c4ac3a	eab928a2-4744-41ed-8bfe-59a345e2291a	4	179.40	2025-09-25 15:49:21.360008+00
f2b15de3-5f95-45f7-b547-cf57742fc2b8	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	8cb7f3af-5fa9-4d37-9dad-e273105d1f21	5	1.17	2025-09-25 15:49:21.360008+00
387b690e-f9a0-45d9-84b7-a0008ed9a4cc	3a9ce289-a876-4e46-835a-e120989c8652	26a142be-85ca-4609-bd38-3ad3eb7be080	3	77.20	2025-09-25 15:49:21.360008+00
326185da-6ad8-42b5-877b-d3aa462787db	86517f8b-c37c-4bd9-83b0-d44a59b52fce	f8ae2130-79d9-42d0-992c-43d9cf1a0688	1	3.07	2025-09-25 15:49:21.360008+00
dc8e722c-bf32-40e1-b026-3e699c260620	d489ffc3-d7f3-41ff-9c01-e7f67dac8933	337faa7d-82fb-4049-bcf1-e0f5ec4bfb68	4	76.56	2025-09-25 15:49:21.360008+00
dec5bfdb-b4c1-40d4-b745-f06055cbb17b	34f95a9f-4e7e-4ccd-8da9-a1b0f72ca2c7	1bb97fe4-a952-429b-9e82-af0cdfb9d700	3	489.02	2025-09-25 15:49:21.360008+00
b3fd7302-b612-4934-b0bd-e656bd90426c	47d04618-8428-4f32-bf9d-b7b282613d88	2319c429-263c-43d4-bca0-7f7e22971c3b	2	469.35	2025-09-25 15:49:21.360008+00
f2289214-fc2f-4ea3-8401-ec610c24f83d	eb38046e-741a-491f-8f27-789b5b7c0903	c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	2	219.78	2025-09-25 15:49:21.360008+00
dce80b49-2235-4135-bf03-3f92443ca2cd	281df8ad-c1e5-46b8-bc29-020b73430fe2	4b3c92b2-b064-45a3-9566-c963f4492abf	2	77.15	2025-09-25 15:49:21.360008+00
7e355ebe-73ad-453a-bc49-6765fea290d8	a09b2292-9ea4-465b-ba62-d0665ac25f6c	88a8d5a7-169a-448d-a9df-7e12953611da	3	271.33	2025-09-25 15:49:21.360008+00
9f405535-03fb-4878-9e3a-f90510c35d07	c2a449db-0250-418d-bcb4-fb0cf9cea4d5	55913ecd-e237-4052-a117-3551627fa29a	3	66.36	2025-09-25 15:49:21.360008+00
0ce3e0e2-5562-4a2b-9b24-0ac3833ea7af	178da109-b1da-4087-8b86-b5a245d666c3	91dc74ec-7d5f-413d-aabe-aea64403006a	4	285.77	2025-09-25 15:49:21.360008+00
eb02282e-7c34-453a-9e0d-d09c8bea6ed1	e4c5f085-7c50-4767-ae55-f27b0095ca5a	a52e2f4e-d07d-4aee-b531-714c0ad0d355	3	219.17	2025-09-25 15:49:21.360008+00
656f7d5b-11c3-4cce-8d90-e9056b72cc23	f0fd942b-8398-4ecc-8c53-eb8ae30b5908	26c3132e-21ee-4c0b-8b3d-803093c725f2	5	404.14	2025-09-25 15:49:21.360008+00
a37fbdf1-3028-4e72-b002-cd8e18e2c95c	7f522f6d-a40e-4b9a-bd19-bf36c9955f27	cf7c0140-d018-41ed-b1f3-d84978d66add	1	15.59	2025-09-25 15:49:21.360008+00
777ae0fc-75a5-4b72-9323-464b8f2f4578	0767e0c8-9b15-41c6-bd33-076d94ba2fe6	236c0db8-4326-4c16-9d7c-03d2f5c787ad	2	121.03	2025-09-25 15:49:21.360008+00
619cca5f-76a0-4478-95a4-7111274d804c	72326bc6-8625-4cc8-a771-f05af5bf0276	7e28a8eb-e0a0-4fcd-9432-4a4142b93364	5	190.38	2025-09-25 15:49:21.360008+00
12b54a40-b078-4409-abec-1426ce0ee23d	95c0e9b4-3cda-468d-b132-7b9806303461	4439085f-d4d6-4458-9e6d-703011ee1376	3	31.14	2025-09-25 15:49:21.360008+00
67930284-6ed9-4ec3-ae82-9981e0b1581d	cca06839-8936-4474-b9ce-9309b36ff30a	7cbac387-ba27-4696-9b12-08dbbbe2d631	4	127.85	2025-09-25 15:49:21.360008+00
ad39d497-c66f-46f3-867b-9c1699d66d03	af68737a-6f35-4095-8e08-f693aca5b974	75abba00-6208-40f4-80fd-a914bc24dc12	1	405.40	2025-09-25 15:49:21.360008+00
0763d36e-205b-442c-81b2-0db06d195aed	81e3e409-d429-4a1a-b8f3-2e8e517dac57	9382cd8d-9410-4b85-97ca-6288b82a734e	3	397.88	2025-09-25 15:49:21.360008+00
fe9d95ab-6baf-4372-9495-9f56e0787c96	04b226bb-5169-486d-ad2e-26a3f3c277bb	5537b5cd-974c-4232-9f90-dde2a70619bc	4	425.39	2025-09-25 15:49:21.360008+00
a0e80163-e24a-4278-b721-751a34d15b15	d6a0a1ac-417e-41e1-96e6-061a85cec67a	a5dde8fa-5075-4d78-bd8d-a8b0b48456d5	3	189.08	2025-09-25 15:49:21.360008+00
5b8b505d-a29e-4fe2-91b0-153b785b2c24	b9e2ae9c-46f9-45ae-944a-955e3f9a4952	2f27a396-89d6-4a3b-9b81-de8b4cf74f02	3	155.36	2025-09-25 15:49:21.360008+00
f8fa34af-083f-47b4-a1ba-d630091d409c	32bd1acc-1545-4a61-a0f2-1e47c9f2618f	e3f360dc-ca43-4d24-9063-8c9734ff9178	3	43.65	2025-09-25 15:49:21.360008+00
b9629051-a6ba-4c57-ae30-82236a5365c4	232d9918-fda2-4e9c-9209-df494b65366c	9dff09ea-3501-4a2e-a164-627b9e1073c1	2	94.84	2025-09-25 15:49:21.360008+00
0e4b2e67-6dba-4457-9707-e60d360576cf	b3e3b19b-4095-4ade-ab42-48bcd45a84ad	fc2abc4e-e4c2-420e-bd65-6428278e3841	1	401.58	2025-09-25 15:49:21.360008+00
f3326bcc-b645-49d7-a1fe-e6c5e832b9a9	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	f634f51d-2cea-4f75-90e2-d380d6a9195c	5	242.43	2025-09-25 15:49:21.360008+00
fb585a97-b486-45df-8947-13fd17e21841	3c5b50b1-2d09-479e-8389-e5daeea8257a	3e40bf78-29b5-4a0b-bf2a-d19f1cf071a3	2	210.55	2025-09-25 15:49:21.360008+00
ea703bd7-b60f-4b55-9dea-e7c006983a6b	01d87596-cfd1-4a33-a5a3-afc687b9fc5e	9f52e2bc-980b-48d4-a9da-ca34a8a0e9f3	5	383.03	2025-09-25 15:49:21.360008+00
94a7e05c-a49b-4731-a497-ac6fe4e9b7dc	90e77639-78b7-49b1-897b-12d578024a7b	1445e51c-61bd-4bba-84ee-22b3d6034aa6	5	87.92	2025-09-25 15:49:21.360008+00
fea5cc69-0748-4130-b365-b157c4baf6d8	06ec6966-1cbb-4cf9-8f63-482325332370	4ca3c954-9979-4d43-bb0d-5ed8d9f2ceaa	2	311.26	2025-09-25 15:49:21.360008+00
67c94361-1a77-4ca9-a61c-303a56469ac9	503e4f9c-9308-4ebc-afca-553d4b11ecce	21f89511-0b73-453d-90e5-5259485a5afe	2	350.37	2025-09-25 15:49:21.360008+00
21327e6f-dbe8-44cf-b8d0-73546d3aabc0	4ee52527-2803-491c-be99-3ed35efa903d	4ccc4ba0-062c-4e39-bae5-7c9970cb9945	4	96.95	2025-09-25 15:49:21.360008+00
955e7e7b-4847-4963-bf3e-9fd1b14c14e1	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	dab8b247-bc37-4c50-9b81-ac7aa596962b	1	213.79	2025-09-25 15:49:21.360008+00
0515a360-28e7-42e4-a648-da037fdf409a	45a00a80-5f66-4221-aa82-5a7d75d997b9	8656b34f-7ecf-47d6-9665-725eacdcba39	5	217.85	2025-09-25 15:49:21.360008+00
882fc371-c623-4755-9df2-60a4ec1dd80c	25b251ee-fa6c-452f-b0eb-a3f90e9403d0	1d0ca8ac-a720-45b6-9fb9-6c7c1c8c4557	3	148.53	2025-09-25 15:49:21.360008+00
771070ee-3255-4874-a14d-057385205b63	b983e3c2-258f-4546-9f88-e4eff6484f48	1ac02056-9f69-460e-be73-9439774634eb	1	199.56	2025-09-25 15:49:21.360008+00
43bcfb5b-1d0a-4bab-a24c-a719a5b4d221	272b6776-dddf-4ab4-ac22-a81e85805712	e85d3e7e-015a-4c9b-98d3-81e76e653386	4	198.06	2025-09-25 15:49:21.360008+00
301454da-da51-4583-bc4e-bd518e4e1661	0cb4d9f1-82ad-44d7-888c-eec2bd84474f	809b63b7-aeaf-4496-bc99-0694fe605c94	2	238.03	2025-09-25 15:49:21.360008+00
61eebe88-035b-4431-9459-0b00bfb03ca6	16a22e58-1834-4dc8-96d9-08dfe2fc0e67	e72277f0-d084-48ab-93be-36bb4c2f1c9d	5	374.16	2025-09-25 15:49:21.360008+00
4301ffdf-ecaf-481d-bcb6-dbc093fa327a	05639713-2fc1-4653-991a-6e7b6fb6963d	0ad7ba16-f2ec-4e35-923d-4d8b00f0dcc9	3	82.33	2025-09-25 15:49:21.360008+00
ca692039-a225-4ab0-9078-038cde087ffa	a8f1300e-9928-4a6c-87bb-88e67dc80007	736b283a-1808-46e4-85f3-a44cd7ac8a3f	3	167.76	2025-09-25 15:49:21.360008+00
ab6695f1-9647-4b6e-8630-ffebc07414a7	98b43bb9-9816-405e-ab39-8bbe4bc01b98	685e0f0a-4d1e-4ea9-8a74-58f6156117b6	3	141.04	2025-09-25 15:49:21.360008+00
97aea7c3-fd46-479c-9a76-9ace9e47bdeb	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	1cfda4fa-aaa5-40b7-a4f5-30a6ee857a5a	1	412.01	2025-09-25 15:49:21.360008+00
2c93d657-3af8-4381-a906-a8133c12cfad	a662f649-8a61-4f87-9685-bf4512d21b37	95f40c38-c977-4239-aea7-21df5de3a7ea	3	302.25	2025-09-25 15:49:21.360008+00
6f65fbc8-3591-4ffe-8f57-5561f2344675	a47099e5-e24f-48ac-b430-227b6dc72c47	c42aa557-2ac3-4c8b-b680-45467d38a8ab	3	147.24	2025-09-25 15:49:21.360008+00
2141d299-f765-4cd2-b853-ca4ae2d9a8df	72326bc6-8625-4cc8-a771-f05af5bf0276	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	3	369.68	2025-09-25 15:49:21.360008+00
d3804557-360e-481c-aa1b-9eb47e1ca11f	17696562-545d-411b-96ac-553be0bd74d6	8d082510-2d25-45c5-ab63-09578063bd42	2	282.17	2025-09-25 15:49:21.360008+00
625e9616-71d3-47a4-8f7f-bee8bb4d100b	ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	9a4e25a4-0a70-4f83-9843-5194af794055	2	49.73	2025-09-25 15:49:21.360008+00
037d3cdc-509d-45e5-8525-b239f35d16c9	d94e1b98-75f7-4be4-8e3a-ef61e09030ea	c57dcd86-44c2-475c-a8e2-8fa7ce846554	1	396.69	2025-09-25 15:49:21.360008+00
71a99ff3-3371-4966-91a4-0f209908e6a3	04ba2842-1c75-4c0a-9440-138d32d842bf	aedd1f54-9ef8-4bae-8650-8be25187046a	5	321.93	2025-09-25 15:49:21.360008+00
0b468d25-5111-435f-a1ec-099b263c45f0	1cdb3f00-6866-4d15-aeec-fd1c087251ad	39d35def-0cac-4a8b-9ba5-89d172693cc0	1	395.41	2025-09-25 15:49:21.360008+00
c38f33b6-9bf6-4198-998a-de080414e789	b051b1d6-9890-4e79-9dc1-f79c967fc9f9	4f3ea27c-9d55-4fce-adc3-9197e9274c24	5	106.07	2025-09-25 15:49:21.360008+00
9dc6c0f3-967d-4f7a-adfc-3468dd588f6a	66d5dff5-1fb9-41b1-b15a-dabe2c70fb70	536f80ae-a4b3-4301-8acd-e72cce70a461	4	264.43	2025-09-25 15:49:21.360008+00
17c3693b-ea03-46c7-91ed-e39dc920ea71	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	82eb95f2-6558-4fcc-b9ce-abdb673d000b	1	184.23	2025-09-25 15:49:21.360008+00
b9023a02-c6bc-4eca-8721-3e67354b2772	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	c1746368-b8da-4994-ab96-1d008bd54718	4	158.98	2025-09-25 15:49:21.360008+00
916d3bfc-8763-44bc-a818-8e3a9f7e157c	0dd73ff2-8ea2-458a-b8c5-af6d8bb93776	e9107d48-386a-48b3-b23d-76fcf499f5f1	1	3.26	2025-09-25 15:49:21.360008+00
8df61059-778d-48b2-ad04-a42e280d31a0	987edebe-d35c-419a-b283-24996973dceb	07f80eaf-836d-45bf-9c10-fe69001a2fef	2	319.61	2025-09-25 15:49:21.360008+00
62441e4b-ea64-482e-91ea-8e7223191fc5	f0fd942b-8398-4ecc-8c53-eb8ae30b5908	905533f0-1768-4875-af44-c40f2f12fcbf	2	226.49	2025-09-25 15:49:21.360008+00
8222fa33-7125-47f8-a4f8-a5c4871a6d88	5067949e-1cad-4b2d-94e1-ff4180e9526e	a0678678-c121-4170-83d4-ee3815ac836e	1	81.96	2025-09-25 15:49:21.360008+00
5e4a3f20-2401-4abf-8d4e-c695ebcb50b1	14449588-fbb8-4fc7-a2d7-c98a583024a6	60ede4fa-9169-42a7-89bc-a6c31e1b77ea	1	494.86	2025-09-25 15:49:21.360008+00
61a2dd7d-c88a-43c4-8ecb-cba1c029a9aa	4e570348-6554-42ca-b80c-f98d2f79b055	688b8efe-e6d0-4fc8-a0ee-5cefdf5e4173	2	212.22	2025-09-25 15:49:21.360008+00
e9e06a6c-a262-4b50-b84d-d21c42d208f3	232d9918-fda2-4e9c-9209-df494b65366c	85c7838c-47a5-432e-b0f3-669d4a929ee1	4	175.70	2025-09-25 15:49:21.360008+00
af9a90fb-8267-4b1a-8d13-5d1c4ca40248	a55c6aed-e1cd-4ae6-8f53-b37cbb1ab41c	77ba5c1a-63a2-4143-a679-6dc36039956e	2	45.36	2025-09-25 15:49:21.360008+00
7095da8d-863e-463e-975e-3780daca1de1	188ba3fb-b338-4cc0-b018-e1fe625804b2	ac9cef94-2751-4f36-9abd-43e045341268	4	331.91	2025-09-25 15:49:21.360008+00
cce107b1-eb00-4bea-9adb-ffd32627f212	b3e0dab7-bb8f-4118-9ffa-bf9eaef8898a	fecec68a-2825-4382-b4cd-77c817f1d576	5	315.71	2025-09-25 15:49:21.360008+00
33d5c476-2fa7-4059-a707-4b7fd669604d	52549fa7-0cbe-42b3-a714-11d46bfad8f4	33fa3b1b-3e7e-419b-ba3c-a05d8dc6c373	2	462.28	2025-09-25 15:49:21.360008+00
8cfab19a-dd0e-4038-9785-80943393fd2f	e4c5f085-7c50-4767-ae55-f27b0095ca5a	dc995feb-0c4b-46dd-83ee-bedda7f27956	5	256.63	2025-09-25 15:49:21.360008+00
a0b6ebfc-b168-432c-8f7a-3c124f683b33	5067949e-1cad-4b2d-94e1-ff4180e9526e	4df41507-2c3e-46fc-a67c-8c6711ddebda	5	338.93	2025-09-25 15:49:21.360008+00
2070c889-5e2e-4871-ab57-401b6f452790	6910c056-e78e-473f-91be-27421de436b1	2d7e1e87-2f04-4d18-9369-c6622970661d	1	324.11	2025-09-25 15:49:21.360008+00
d8a60b22-8862-4e65-9b2a-6f13fc849d19	826e481e-d428-43a7-8889-ba4cc9ed227e	b04eb25b-9fa2-4522-99e9-cdbc0ea05dc2	2	198.91	2025-09-25 15:49:21.360008+00
70d723a3-6b4b-408f-9cad-e306fe43dd09	ad175f2e-c4bb-4146-8eca-265407645116	589f5188-96bc-4404-9cfe-78d6eae50831	4	146.57	2025-09-25 15:49:21.360008+00
b63d9a34-85b6-4e97-a15c-e44fded3ab0d	06f9659d-9944-4e7f-b875-27476aa80190	27e2e9a6-1d22-41c0-976d-dc7ffc253d4e	1	55.85	2025-09-25 15:49:21.360008+00
8b18ec30-e234-4372-96ea-450f2f916eb8	8b6a006f-45e5-426b-b53b-83a6496c83d3	807e423e-35e3-4c30-95bc-12beeebc224e	4	140.01	2025-09-25 15:49:21.360008+00
b99f34d8-fc8e-4c48-b622-77eff6a9e1aa	35191e52-834b-49ce-ad39-75e35a3cfbee	096acccc-845a-4f8c-a4c9-4c2ee83dfce4	3	202.49	2025-09-25 15:49:21.360008+00
ecab403c-e3d8-424c-8d34-5972351b286f	80277854-2b1a-4543-b441-c5280a2768c9	adc0ce15-2ab2-4adc-ad8e-44624fded00f	2	317.58	2025-09-25 15:49:21.360008+00
cf443cb5-fc29-49d2-a859-bb4049166c22	eb38046e-741a-491f-8f27-789b5b7c0903	d33f0594-8bc5-4744-b189-55018e9becc5	4	123.06	2025-09-25 15:49:21.360008+00
f9d739ba-85a8-40fd-b13c-27bff0504915	e44192ad-6d30-4273-b02c-d05dc9017744	43eda1a7-ba23-4a06-b41d-f95a25e9f91a	2	186.74	2025-09-25 15:49:21.360008+00
bad908bc-4b7a-42c0-a27f-06095dcb9562	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	75fb9932-0412-463e-b047-9ef586a472b6	3	410.45	2025-09-25 15:49:21.360008+00
a5ccbdcd-39a0-4838-a49e-a1a5d463f910	d3569393-985f-4053-b8f4-5e14fc51b461	3b876e1c-0a67-4b21-b70f-910f190ea31b	2	117.77	2025-09-25 15:49:21.360008+00
9683f331-c1c5-4afa-8e62-f89e15180960	7374c864-9ec5-422b-9cea-44cc4b946383	bacacba7-76a9-4d09-ab72-f08a18504d23	4	330.04	2025-09-25 15:49:21.360008+00
40ed8e08-2bc2-4788-a7c7-dc0c735a7ca1	d8bf79f9-672b-4378-93a2-2225b3938f84	f9b58e17-4322-445e-9b20-d0750b8c09c3	5	245.51	2025-09-25 15:49:21.360008+00
0de66542-062c-4641-a2a8-1f9d6b84b908	272b6776-dddf-4ab4-ac22-a81e85805712	1ad9d18c-2c66-4b7e-8a06-e83dae22239d	3	104.53	2025-09-25 15:49:21.360008+00
adf357c3-5907-4c21-a9b4-f58a4ff8bc99	123604ff-db0e-49e2-8195-f688783fa74b	badbf107-01fd-4376-b55b-b1ffc7c8735f	1	352.77	2025-09-25 15:49:21.360008+00
d124637a-78a6-4782-87e4-7d495c313a88	843741b6-d4c1-47a1-a562-cffa5623c317	16b6747b-3732-453b-8e4a-9f967ad763f5	5	286.29	2025-09-25 15:49:21.360008+00
6c41f82e-711b-4990-86fa-068b1540f8c1	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	48572d54-e34b-4791-9e17-b95691b67941	4	84.80	2025-09-25 15:49:21.360008+00
18b113fd-eabf-4e0a-a38f-f16389c53de0	77440234-8793-475a-8679-682caf341a6f	cd862f44-36df-4ad5-b816-1a941066779c	4	495.03	2025-09-25 15:49:21.360008+00
c5782053-8186-4114-8e0e-837d21a6cc79	d4281f72-8512-46ed-b992-e0d67b8f11ec	ca472c78-183f-4c25-ac4c-4905a2af32fc	1	441.05	2025-09-25 15:49:21.360008+00
da09123b-1ac6-4b55-8cad-5a1b14c3566c	377076ea-c406-451a-aa04-794eae18719f	67552613-6deb-4627-aa8d-678ff2f9192f	3	252.22	2025-09-25 15:49:21.360008+00
5cd61773-c48f-4e4a-9bb2-d81187c793ec	b0f8fa2c-f1a8-4a95-9fe2-1008c62694e1	956a56b9-49f7-4357-8ce6-cf3b7a8d5f1d	3	27.56	2025-09-25 15:49:21.360008+00
91b40806-a224-4280-965e-2abdbb805236	4647fc71-9cda-41e0-b773-25dbeb306b51	d8cc973b-ce87-4abb-b851-b83ef3c6939e	4	116.62	2025-09-25 15:49:21.360008+00
a16f77b9-5d44-438b-abaf-e37bf035ed92	c9c94223-2df3-4066-86e1-444b6a2ab4ee	536d23ec-bd5f-49b6-b467-20c4f5fd66a8	3	321.86	2025-09-25 15:49:21.360008+00
52134340-d39f-4221-8eb5-b792b4bb4205	82d0a438-b64b-434c-b699-3bb958b99683	da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	5	202.26	2025-09-25 15:49:21.360008+00
360ded90-43b3-4d94-8f93-8de134ce3705	bea8a935-f088-4989-b741-d28734836f0b	7de85b6c-8a49-46c5-aaed-5f440dad07f2	2	139.60	2025-09-25 15:49:21.360008+00
ecf3a5b6-bccf-40ee-bbc5-04147917a341	a1a52a7b-6c94-43b6-b8d8-b0aac52b3db1	59c60900-03b7-4a16-a338-f731470e8ec7	2	277.11	2025-09-25 15:49:21.360008+00
5e36749b-990d-4dc5-8ac9-60f4561702fb	12f7f9b0-31c6-41cf-98b5-88aae39e68b2	705a8ddf-88f4-4ace-8cac-384c51b77125	5	388.78	2025-09-25 15:49:21.360008+00
50a2d609-263a-44c9-946a-e8f02f3c63d8	35191e52-834b-49ce-ad39-75e35a3cfbee	5eb24da8-573f-4682-bbd9-9c03f2eac2a6	1	271.65	2025-09-25 15:49:21.360008+00
e3c499aa-b903-4346-bcb6-4521fd9e8551	88d67c80-cddd-4ebe-ad98-0641b5884be1	4d9c2197-b188-4cc2-9d32-90c74001a4f5	3	372.24	2025-09-25 15:49:21.360008+00
94aa5947-e411-4515-aba3-810917fe73f1	fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	3	388.75	2025-09-25 15:49:21.360008+00
2c0f2b04-f7d2-47f1-90e7-4fc1482a8c65	dfb005cd-0407-45b1-a52c-f9b50f1d1d65	39df2403-7926-436b-b335-1872a3876a90	5	225.46	2025-09-25 15:49:21.360008+00
bc1323a1-7705-464b-9501-151fa0d005cb	e4561b0d-c677-4aa0-8350-5560a9fc3289	320018d9-91c7-4982-b01e-0ef944f99170	5	395.66	2025-09-25 15:49:21.360008+00
df356b4a-9211-48f1-ae61-3b5a5ccac261	45f0653b-a445-47a4-acc9-e13231abb0b7	b48e17a1-25d9-4368-a08d-a585dd43e711	2	88.13	2025-09-25 15:49:21.360008+00
b877cc46-2e42-4479-b61f-6dd610c63143	26d94299-b4a7-48f5-936e-c9975e12dd74	94ba21a1-56ff-425e-98e3-f431f832566a	1	57.84	2025-09-25 15:49:21.360008+00
7c3acaaa-3e73-4006-912d-72d341b25e13	12d7868e-c1a3-4618-ab63-a56d9efc5c91	7347cf20-6c94-4b73-ab81-2147533a2b91	1	273.01	2025-09-25 15:49:21.360008+00
ad3fca00-9a3b-43d0-afd6-8ce596ab6260	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	438166c2-b875-4bfd-862b-b2f7714b52d7	3	194.73	2025-09-25 15:49:21.360008+00
1fe98e0d-a1b6-4fe0-9980-ab4aa77493af	86af1dd3-a30b-4006-9b43-2c16f5a09fcf	c4d12db2-a825-4a54-a6a2-8d7f1bad5dfd	2	58.34	2025-09-25 15:49:21.360008+00
10a148e3-f864-4510-a0e5-739d1b163a99	a6aabe72-0dbe-4ee6-9d9d-a0251eadb3d6	fb417af0-916f-4df8-8522-beb0da87cfc2	3	46.15	2025-09-25 15:49:21.360008+00
6a29cf58-89be-4d80-9911-69de4f127271	772d52f2-8383-43ac-b62b-8265f7d3fbb5	4546edd1-0709-49a6-b91c-9fff4df751bf	1	459.63	2025-09-25 15:49:21.360008+00
4d06ad8c-9ae4-421f-9d3a-3e336077fc19	bf58f402-7f4d-4fa2-a27f-546eca05c308	45b843bd-3948-40d4-83cf-60cfe0469a0f	5	479.85	2025-09-25 15:49:21.360008+00
20a086d8-65f4-44fa-87e9-ad7043d985b3	b3e0dab7-bb8f-4118-9ffa-bf9eaef8898a	7e00c2fc-5dba-44dd-b87b-7aa2e087fedb	2	438.49	2025-09-25 15:49:21.360008+00
245c5aee-4bda-45ea-835c-6b65785f2d01	f3c7a23e-eeb7-4cd9-a82e-9b95190bab95	709287bc-f3cd-470b-8c90-29c3b09aa947	3	341.92	2025-09-25 15:49:21.360008+00
2ba78f47-09d4-4066-aa02-c388b8fa2a36	91e34dfa-9d3d-4330-8713-cedf19705c2a	742d19db-e9ef-415c-9c3f-3d147282b3ff	1	452.26	2025-09-25 15:49:21.360008+00
a63f0209-79bd-4aaf-8c77-e845578097c7	e897f67d-f5e7-45a0-804e-317267bb99e8	9fca81b9-db26-4b28-874e-1750710cbf3b	5	260.75	2025-09-25 15:49:21.360008+00
e321292d-2322-4fbd-a041-efc0eccade49	c9ca0c1e-8436-4524-b7f0-da21423547dd	26ac899c-ced3-47bf-8419-1617e9e07792	1	329.11	2025-09-25 15:49:21.360008+00
b06ada7a-3e56-4ac2-92d2-13d391ac3a84	77440234-8793-475a-8679-682caf341a6f	4d3a9cfc-9faa-4cb4-9925-2ef1401088a9	2	209.81	2025-09-25 15:49:21.360008+00
46cd8826-d76c-4300-bbbf-8322474cd0fb	d10ee357-d8f1-458e-8484-fcacc5c4ac3a	7b36058a-61a4-4bcc-b4f2-e1092aa12fc9	4	233.65	2025-09-25 15:49:21.360008+00
ce96f67f-05c8-4ae7-9a9c-e79fa5ba4ffe	4d3ee623-2887-492c-9353-2ca117ab3d2e	7cb3179c-ca2c-4b60-88ce-300066649462	5	446.63	2025-09-25 15:49:21.360008+00
cc7eb086-6e55-4b8c-8b51-fd3e98d5f4bd	26204835-dcc2-4a79-9c9d-3cd38271fcea	db186775-6fe3-4473-b30c-8f105d431952	5	368.15	2025-09-25 15:49:21.360008+00
0139df97-06ae-4667-a099-57f5e30c6e7d	dafb0045-c051-4e3a-b5b0-87b09fe3034e	2fd5912b-9adf-487a-a8c7-cb3a38daa80f	4	301.85	2025-09-25 15:49:21.360008+00
7d7c5d42-788a-47b5-a735-9a1996c82746	df5cfbc9-3b7f-4ef7-ad78-7e4479c99a9b	117fdc33-7e81-40a4-84f2-e9702ade010c	3	297.14	2025-09-25 15:49:21.360008+00
c2fc08bb-4ba9-4dd7-b411-9004a2d3d75d	e44192ad-6d30-4273-b02c-d05dc9017744	a59d762f-97f5-4080-b4f4-9aa9b2b02d36	1	71.37	2025-09-25 15:49:21.360008+00
0221fa55-c91a-4932-90ed-0af0408c38e0	5b7cef35-0333-432c-a41c-3355e75747f2	a5c886bb-dda2-447a-bcff-dd304e8e85f7	3	71.47	2025-09-25 15:49:21.360008+00
b0f1583f-eb12-4e32-9910-927cf4eb33d5	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	f1d31ebf-68df-4473-b61f-bf3c24343c0f	3	431.72	2025-09-25 15:49:21.360008+00
e979468c-d2b1-423f-9694-e0bdff77faeb	09810df9-2d0e-46f7-b38c-8258e166d908	841799a8-7865-4d0f-8067-48fbbd7e5e7e	1	136.50	2025-09-25 15:49:21.360008+00
f30fe5aa-ec7b-464b-80bb-eec094a62919	7374c864-9ec5-422b-9cea-44cc4b946383	a394c179-ff81-4ac3-b42f-4fa7b4d09ee5	4	52.71	2025-09-25 15:49:21.360008+00
03b2671c-3cd0-436c-a375-bd9f6dfb7ff9	41bc1f19-483d-4acd-a210-0fb701278bbe	c51d890d-f207-44ea-9d04-c039cf3d6dd5	5	87.32	2025-09-25 15:49:21.360008+00
f27a9e8d-624e-4f87-a237-fde757c9c565	16a22e58-1834-4dc8-96d9-08dfe2fc0e67	36cff3c5-18e8-4acd-8284-f7a49f6a72a2	5	364.09	2025-09-25 15:49:21.360008+00
9cda30e0-e232-4d14-97df-28f07e46832e	826e481e-d428-43a7-8889-ba4cc9ed227e	dd347383-08f4-45f6-b1f8-c68a23c43a02	1	69.71	2025-09-25 15:49:21.360008+00
d307193c-4285-445f-8e02-be3d4d8fe87a	1fc8a267-77bd-4aa5-96c6-4846794fae29	27a57e29-9044-4910-8ceb-6e40fe7b52c4	4	321.23	2025-09-25 15:49:21.360008+00
1542d9ce-f9cf-43ce-8b91-bca53c968bad	bd9572e4-f7f0-4388-948f-735bdb83daf2	75f7715c-75c0-4a2a-b649-b0c6e49d2294	2	384.09	2025-09-25 15:49:21.360008+00
396c6223-7129-4526-9a85-00cea42e53e5	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	c27b0e96-8a53-4700-b086-8c31ba149823	4	115.12	2025-09-25 15:49:21.360008+00
1444e487-96a8-41bd-9a82-5d0dcdb70e01	2f835276-86b6-4d57-a13f-c8850e3c1655	5f031354-7104-4787-8509-9f923d36b792	3	466.23	2025-09-25 15:49:21.360008+00
d41d8b36-952d-45a0-81b6-0c554bddbacd	1f5a7650-6543-4791-b064-3290aa6b362c	16caef05-933e-4d78-9ef0-33da5b9f38a0	2	328.11	2025-09-25 15:49:21.360008+00
690a73c8-526c-41da-b7d7-fb693fb1ce5b	14449588-fbb8-4fc7-a2d7-c98a583024a6	5835c521-b454-428b-a9ba-bc1b20d8d681	1	344.16	2025-09-25 15:49:21.360008+00
4aa0a806-721d-45ad-ba63-6e3ae3693507	c1f405d6-dd8a-405d-9218-a37d6970e656	c1b2fa5c-a16b-4a74-9cd9-02fe961a1f5b	2	83.79	2025-09-25 15:49:21.360008+00
eb0a2483-922c-4483-87d8-3146dc1e80b4	688dccef-34b0-4924-9653-9cf2dbb1d4e9	7e00c2fc-5dba-44dd-b87b-7aa2e087fedb	2	5.25	2025-09-25 15:49:21.360008+00
07af265e-9aa2-490f-93fa-d22ea97ba70e	6f3219d0-334c-4813-984d-8a1daace382c	536f80ae-a4b3-4301-8acd-e72cce70a461	5	11.18	2025-09-25 15:49:21.360008+00
43cba420-57bb-403b-adb3-9c8c51148371	94616eca-5069-4a67-a50c-a0e30b58ea7f	a768cfda-4d7b-499e-a7fe-501f68bb8241	3	15.62	2025-09-25 15:49:21.360008+00
eab012c6-79ff-4a4e-9e96-3a415451cdd1	6be97509-6f0b-4c4f-8e6a-b27529c67133	5c12ee9a-d7cf-4f48-9521-746cc1610ca5	4	355.03	2025-09-25 15:49:21.360008+00
532fdf44-b647-4617-a120-ccafcec5615f	6d8773f9-5e39-407d-b9b0-adbce97a9dc5	51df7af3-1a5f-4802-a9af-7f8255ed2251	1	386.81	2025-09-25 15:49:21.360008+00
8a76f9cd-a8c5-4211-9f74-2105ee979ef2	2f1b8741-8866-4267-90ca-5084ab49e155	b2c3bbf0-8067-4c0a-8c0d-2cf646c99ee0	3	460.19	2025-09-25 15:49:21.360008+00
839cea60-a98b-4260-a165-04356d6cf7ed	80277854-2b1a-4543-b441-c5280a2768c9	31b75483-396b-4a98-a51f-63b3e8216865	5	330.55	2025-09-25 15:49:21.360008+00
a92c5a73-7343-4fe9-b2b9-1d854b1b9da2	06507777-7b16-43a7-987e-7f191cb88b6d	a6381a31-5faf-49d1-b719-8c27719667d3	1	439.55	2025-09-25 15:49:21.360008+00
30333a0b-f897-4f4e-acf0-a8956b5e2d29	e6c0ba47-4039-4395-bb4b-f0e37705126c	7c3d6049-67fb-4254-b659-40ccf79572fb	3	2.73	2025-09-25 15:49:21.360008+00
4f225ffe-93d4-4dd8-9294-43686f1525e5	13c1c8f6-ea68-41f8-98cf-bf54740fe3b6	f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	2	287.66	2025-09-25 15:49:21.360008+00
1eda04f4-5789-4a75-8aaf-14be099b7b47	d4281f72-8512-46ed-b992-e0d67b8f11ec	a5dde8fa-5075-4d78-bd8d-a8b0b48456d5	1	110.14	2025-09-25 15:49:21.360008+00
85ff9d23-e5ed-47d8-8c1c-c39374ff03e0	05639713-2fc1-4653-991a-6e7b6fb6963d	7e1bb644-625c-48c5-ab0e-19ba4af3b7ac	3	472.62	2025-09-25 15:49:21.360008+00
859408eb-8349-4928-8690-f99acff1e01d	d10ee357-d8f1-458e-8484-fcacc5c4ac3a	d9107db3-0a4b-4a74-bb70-0ed53546282c	5	66.22	2025-09-25 15:49:21.360008+00
8ac2dbb5-31b7-4b36-b94c-bfb8fc20429f	5147a3ed-5fe1-49b2-9610-5df09c3c7f92	60ede4fa-9169-42a7-89bc-a6c31e1b77ea	5	189.61	2025-09-25 15:49:21.360008+00
75087297-5cfe-47ff-8da5-1bd29cb27530	59d98d0b-7e79-4710-833c-9b90ff83b1c9	329ef81a-ddb7-4583-a1e6-3088e1132d02	5	155.26	2025-09-25 15:49:21.360008+00
5ff37b1f-bd8e-4021-b3fe-4d053f166fff	603c2afb-984b-4c88-91ea-d4d5e379e8a2	244f5fdd-00d4-4ae7-a523-a14b19e3e3fc	2	95.44	2025-09-25 15:49:21.360008+00
4e884646-05a0-489e-8050-7aa7115224e0	7a0e8803-b665-46d2-a9f5-79297739c1e6	f5df4c23-eb63-4b9a-9208-0389662dd022	1	23.51	2025-09-25 15:49:21.360008+00
79929d4d-ea4a-44d5-8e9f-e46897ac96db	260c5ea6-e65c-47e4-b88f-a5345ad86fb9	18d31cbe-f902-4211-b855-a8199875a0d1	3	326.66	2025-09-25 15:49:21.360008+00
0f81f332-08ef-45cc-8e29-3371d9f1b15a	503e4f9c-9308-4ebc-afca-553d4b11ecce	a7357a6b-eb1f-4536-be65-b678cb076d9f	1	241.82	2025-09-25 15:49:21.360008+00
32e2cef5-ac8d-49ef-a0c2-08f3003617d8	be15e883-2c37-4a89-9dbb-d77fede72e32	60e6f374-032c-4182-85b4-22232ac5a0de	2	174.75	2025-09-25 15:49:21.360008+00
ca419951-9d60-4906-a4fa-b7b9a2800585	72326bc6-8625-4cc8-a771-f05af5bf0276	be17ba99-47cc-4f1b-89ab-f0ada842f8be	4	159.96	2025-09-25 15:49:21.360008+00
faec66d0-4dc9-4cfb-9392-044e2b550aac	e0ef9e43-0f15-4514-94bc-47922417f166	75a131a4-f92c-4efe-ae1b-e8ec24c6de21	3	434.07	2025-09-25 15:49:21.360008+00
1aca3fc2-a0fb-42e6-97e7-e0e7b3a545b9	7a1bfb17-b859-4250-bf36-5ff26230b8fc	42efecc1-d272-4b66-8b03-4dd82b43ef1c	1	15.30	2025-09-25 15:49:21.360008+00
0bf158b4-017e-4b01-b28a-af95016dad9f	86517f8b-c37c-4bd9-83b0-d44a59b52fce	fba6d988-0239-45ce-9863-9520aef4b3f6	3	277.44	2025-09-25 15:49:21.360008+00
b1730e9c-9be7-4ef2-af1e-f9a1bfe673d1	06507777-7b16-43a7-987e-7f191cb88b6d	1f57b10f-81ec-4212-93bc-58ae70c5a254	5	432.43	2025-09-25 15:49:21.360008+00
f7319499-4826-45e1-a43d-b6e89bf73ec5	d3f139c5-20f0-4814-9d64-89d703cbf5d1	f24f6a07-8c60-46dc-9238-4a71725cb34a	2	250.50	2025-09-25 15:49:21.360008+00
aa509319-d938-421e-82f0-194d7965f8e7	6d8773f9-5e39-407d-b9b0-adbce97a9dc5	299bbe41-9825-4f28-baa6-a9912151fcbd	2	107.78	2025-09-25 15:49:21.360008+00
fde4014c-f75d-4e68-a0c4-90b2ba01b007	9afc40e6-096c-4f61-9041-bff7533a1203	2d56540b-b214-4088-b0c5-c4fd2cc266fa	2	449.60	2025-09-25 15:49:21.360008+00
f1f4c2e7-ef54-4d13-a6e6-03d3cae305f9	272b6776-dddf-4ab4-ac22-a81e85805712	484224b2-0dce-4aa4-9b8e-2943d495564b	3	481.98	2025-09-25 15:49:21.360008+00
ecc3b9a5-81c2-4776-af33-33685fb78e8d	9aa91f21-3a06-4000-b2ea-006f267cc7c4	4f33627f-1c0d-4385-b95c-5c2ca24792ad	4	269.34	2025-09-25 15:49:21.360008+00
c0adfef8-37ff-458f-a853-e4193e17fd52	d03a1f35-5561-4042-a79b-ce2f6efed426	e06ca0c3-73d9-49e0-a5c6-d52ebd6153c4	2	97.55	2025-09-25 15:49:21.360008+00
1d7e0fae-1ae4-427a-993e-fc01009cec6b	dff49b1c-3584-4537-b0a3-39b63729570a	24e41afa-9161-4715-9372-14de21ddfa1f	5	355.28	2025-09-25 15:49:21.360008+00
7ff55dac-b9e6-4c11-852b-1dd75dece917	ad175f2e-c4bb-4146-8eca-265407645116	1bb97fe4-a952-429b-9e82-af0cdfb9d700	3	183.66	2025-09-25 15:49:21.360008+00
f4dcd40e-c598-4136-9381-7cef1048030a	eb38046e-741a-491f-8f27-789b5b7c0903	978dbe77-6d45-46ac-99a9-a543fff4efa1	5	165.98	2025-09-25 15:49:21.360008+00
af29c582-9c87-4d53-980d-f07703fb3b17	c1cd7c6d-9072-4172-8c7d-bdcb86d702f4	172f7972-39b2-4182-903a-8ac4660a5478	4	485.33	2025-09-25 15:49:21.360008+00
20dd5f1c-9ebf-4175-85f1-6431c5ef264c	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	3a7f861c-b3cc-4086-9e7f-40b7e0e4e2cd	4	36.43	2025-09-25 15:49:21.360008+00
633adbf9-8e45-430a-b374-35120d405f32	d2b4f687-7bf4-4b65-b058-37c2dad6f887	d82a8dd3-a1f1-42a5-9f01-033cb4a480b0	5	177.60	2025-09-25 15:49:21.360008+00
751ef067-69fe-4fd9-9d45-90e02d49f0cb	e4561b0d-c677-4aa0-8350-5560a9fc3289	6b8bae2b-61ba-4605-89bb-f68d26b660a8	1	348.84	2025-09-25 15:49:21.360008+00
3965ace4-d0ed-4a55-9284-bacc001087d4	6fc62102-14fa-46c8-be9b-cf3935b4f0ae	5d225952-d37d-4352-a096-35e8e555604a	3	207.39	2025-09-25 15:49:21.360008+00
6dec75b9-75a0-451f-8118-f547fe348835	b983e3c2-258f-4546-9f88-e4eff6484f48	db6614a2-13de-4516-aac9-870bb9ab87f3	4	162.70	2025-09-25 15:49:21.360008+00
508feaac-bbba-4034-acf6-c4921286a44a	3c5b50b1-2d09-479e-8389-e5daeea8257a	ac4cf314-3822-4cad-9489-1c3a4e011cdb	5	161.69	2025-09-25 15:49:21.360008+00
b1ae7016-dc67-49b9-9595-c5d650fb3efa	f477c695-25e7-413c-ad3b-66603185b512	d685e216-b8f7-4e4b-a97f-cdf030bc882b	4	208.48	2025-09-25 15:49:21.360008+00
7bdecbf5-a81f-4f98-8d43-36b2bbca9d56	0cb4d9f1-82ad-44d7-888c-eec2bd84474f	d87dd82d-0c97-44fc-9577-ad25303dd28f	1	6.81	2025-09-25 15:49:21.360008+00
7681cac6-8e39-4542-ad52-4d23e1510f53	5067949e-1cad-4b2d-94e1-ff4180e9526e	0ffff1c4-87a2-4beb-b40e-40395ceedad5	5	219.56	2025-09-25 15:49:21.360008+00
002df064-86a0-458f-b445-711b57e34359	41bc1f19-483d-4acd-a210-0fb701278bbe	1d32f141-7b63-4c15-b4a6-8167d6ddf351	3	450.89	2025-09-25 15:49:21.360008+00
9b90b603-2a88-4e32-b661-39f5258ee30e	8ad3c805-448c-4596-a4d3-577c1ef68b79	b885d6a5-df0f-466d-94c1-c2f270550b76	3	257.30	2025-09-25 15:49:21.360008+00
a2a258c7-6908-4367-9aac-e39eb066d360	e897f67d-f5e7-45a0-804e-317267bb99e8	705a8ddf-88f4-4ace-8cac-384c51b77125	1	373.83	2025-09-25 15:49:21.360008+00
7b381b38-b764-49ca-b181-755038f3704c	1fc8a267-77bd-4aa5-96c6-4846794fae29	9af6b8ce-1daf-418c-91d6-5a9b55cb54e1	5	10.51	2025-09-25 15:49:21.360008+00
80ea2b31-4c80-43cc-8cfd-49e2f24fa39e	12f7f9b0-31c6-41cf-98b5-88aae39e68b2	60e6f374-032c-4182-85b4-22232ac5a0de	4	149.53	2025-09-25 15:49:21.360008+00
97e1f342-0c00-406c-bac6-e25a1583d5f3	646020f9-385d-48af-99f8-1d1c6849ca2e	9709631a-d9f4-4c76-bb52-5692284f7495	4	334.16	2025-09-25 15:49:21.360008+00
bf869510-b170-459d-bef5-668021c1f633	fc35a6e0-5c19-49dd-9ce8-59732d670e5c	e033ca53-db4f-42b9-b50b-1bcb17480a5d	1	391.32	2025-09-25 15:49:21.360008+00
8d28944d-4c30-4154-a57c-d30f5c70f950	21712398-44ef-4649-81cb-1d4a791df344	7e793ed9-4bb8-4eb1-8ac8-8fe73fe2d288	1	449.61	2025-09-25 15:49:21.360008+00
d053d068-a80a-4cd7-9a9d-921f57b3a570	4d3ee623-2887-492c-9353-2ca117ab3d2e	d92462f4-d0f9-45cc-a17e-8a0abc992ccf	2	45.26	2025-09-25 15:49:21.360008+00
ec5b0c27-97f3-49f9-a906-c66b8548228b	9baa1226-3fce-41c0-9415-863a8770c909	694c7c50-b0e9-4984-8f01-c8a7f4107cd3	2	77.77	2025-09-25 15:49:21.360008+00
abe9a1f0-4f5c-44cd-9ab7-06dd61164fa8	24732732-58ca-4efb-9165-3c9b0d9471af	85e68321-7895-4d1f-9e05-28a2d824c984	2	293.24	2025-09-25 15:49:21.360008+00
00354e7d-4524-4b14-ab92-4c4e70acb29e	3a9ce289-a876-4e46-835a-e120989c8652	f6c35af7-4715-46bb-8d31-2969763c662d	2	243.28	2025-09-25 15:49:21.360008+00
40291a5a-1e4f-4855-b3ab-db0ee8bc86f5	c56ca266-c159-4ab6-9f7b-ddb3b2cd04d5	68774402-8cc0-4dfb-bd32-b96048384edc	1	438.75	2025-09-25 15:49:21.360008+00
f5e9c92a-0103-4c20-9904-e3bafb27a37f	150fc2ed-e9ed-40a6-8a63-901228df41ba	96025684-4b0c-41a7-8dc1-96f351c134f9	4	125.51	2025-09-25 15:49:21.360008+00
87835f3d-067f-4b93-851d-e618acb81795	32bd1acc-1545-4a61-a0f2-1e47c9f2618f	0262cb3a-42f7-4eb7-89cb-8f5d3372e510	3	144.24	2025-09-25 15:49:21.360008+00
3b4d0990-7c74-4b2c-adc9-3ea5a4f01dad	859c6dcb-2d8f-424a-914c-e2f8990acdf2	9e0ccba2-556f-40f1-9eaf-cdb4d2c15c30	3	69.65	2025-09-25 15:49:21.360008+00
1aa895db-a03e-4e60-96db-cc4e6baf1938	377076ea-c406-451a-aa04-794eae18719f	8e7a5f95-f1e6-4270-a55d-dae16786806b	1	268.56	2025-09-25 15:49:21.360008+00
89d2a85d-d2a0-479f-9f08-6537ce304e47	95c0e9b4-3cda-468d-b132-7b9806303461	f9b58e17-4322-445e-9b20-d0750b8c09c3	3	57.77	2025-09-25 15:49:21.360008+00
c8135191-3633-418a-a4b4-54074da95e07	eb38046e-741a-491f-8f27-789b5b7c0903	5253556c-057f-483c-9381-f6af86bde287	1	418.13	2025-09-25 15:49:21.360008+00
5a5715b7-299a-4eb5-b3ec-922068b7a475	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	94a4b3aa-2cf2-4f79-9bfe-1e59896eacf0	2	408.36	2025-09-25 15:49:21.360008+00
6fe05e37-fe34-4d69-a71b-3a8af543f8d9	04b226bb-5169-486d-ad2e-26a3f3c277bb	a274c297-8cdc-401d-aa87-4c61971c6730	2	97.11	2025-09-25 15:49:21.360008+00
4545d81b-d2c9-4ccb-9f8b-ee9b6a5c13d5	1c764e38-cd41-461a-9ec8-d97187982ab7	7ed809ef-5f5d-4e5a-b537-acc589b4dfdc	1	469.16	2025-09-25 15:49:21.360008+00
6886fa52-c5ff-48f0-8692-0b05facabff7	30bbe271-3b24-46e7-8cf9-1b29360fbd83	a89be87a-2d8d-4a07-9ba2-f1a87dbceeab	1	134.85	2025-09-25 15:49:21.360008+00
c6381e10-97b4-41aa-bfac-2ae1b507455d	29c44409-4491-4a6a-8843-fff08882f07e	675c3505-b139-4155-a162-13f7bcf9c5bb	3	268.01	2025-09-25 15:49:21.360008+00
b341bc38-17c5-48e7-89d4-184e9eff9f5f	9ddf866a-c7b1-480c-b2cb-a95cccfa1293	d393defe-2960-4f3c-be2e-335411d955dc	2	399.10	2025-09-25 15:49:21.360008+00
72ee1ff7-c3df-476f-9bd6-4055796031c7	211ce5a1-1e43-42ee-afd4-5f0de060e8e1	f6646719-cad7-44da-9df7-f91b352004f5	4	162.03	2025-09-25 15:49:21.360008+00
f77eb79b-66ea-4e82-820a-cc0b37c0196d	232d9918-fda2-4e9c-9209-df494b65366c	72c06a77-f84c-4691-bba7-23b68c7562d9	5	435.50	2025-09-25 15:49:21.360008+00
52eb3455-da03-4a30-badf-86888bc4a36b	38d8a74c-013c-4027-b2f2-721beb36de14	299bbe41-9825-4f28-baa6-a9912151fcbd	5	267.45	2025-09-25 15:49:21.360008+00
69bd7ad6-9046-424f-a79f-e185f6a34774	503e4f9c-9308-4ebc-afca-553d4b11ecce	aafd4c57-d44b-464e-b877-504a4daad1ef	4	471.38	2025-09-25 15:49:21.360008+00
74eeba10-eb65-4451-88e1-8267730a32f8	26204835-dcc2-4a79-9c9d-3cd38271fcea	d5cab7de-cb02-4979-9900-23c96091aa6e	5	246.69	2025-09-25 15:49:21.360008+00
a4978b15-92f8-414a-aba4-733c957fcd32	dfb005cd-0407-45b1-a52c-f9b50f1d1d65	f9621d19-b8e1-4501-af75-eb6f9d039552	5	347.36	2025-09-25 15:49:21.360008+00
1863bc8a-ccad-45ad-9c37-c1ebf3efd147	88d67c80-cddd-4ebe-ad98-0641b5884be1	ac9cef94-2751-4f36-9abd-43e045341268	5	254.34	2025-09-25 15:49:21.360008+00
25617816-8c4f-4b8b-83c8-80517fc394b9	38babc9e-d1b3-41b8-b3c0-b29070e8d22e	1445e51c-61bd-4bba-84ee-22b3d6034aa6	5	16.45	2025-09-25 15:49:21.360008+00
8341cb80-e764-4d94-8b02-8aeb49f8c9a5	29e75bea-4cb6-4bf0-8342-e2a00f220191	d3ea9f78-f866-4f13-bd3f-3ecdd4c8ad7b	5	443.95	2025-09-25 15:49:21.360008+00
bab38943-2d2e-4e0f-8aa5-77bb959eb232	49a8611c-52f8-4199-9cd9-8147c287f45e	343f5f5d-0ebe-403e-bad7-43caa47b701f	1	87.32	2025-09-25 15:49:21.360008+00
a413281d-6ee3-4f39-ba81-e0dfaa88ef07	c14adf70-0385-4c05-958d-e07e8154e2c7	f6d9030b-fce6-4d21-a869-e7adb7f82cc1	5	460.32	2025-09-25 15:49:21.360008+00
1df9db7f-d394-4a2a-a1d2-585a1960ebda	750e4907-ab47-4e1a-a191-e6356a4962aa	509da523-0dcd-4f76-97a1-ec35562b60cd	4	120.10	2025-09-25 15:49:21.360008+00
a40b3bd7-7d27-405a-9c99-364f9ddda9a9	c88dad4d-3293-4c57-b39b-957991bb2f44	68db7820-0366-4bfa-a95e-415e93fd5b08	3	183.39	2025-09-25 15:49:21.360008+00
d645b108-9382-459a-af76-d448b4c4a8bb	27e301e8-2e68-495a-8e90-334043fd9ec5	f4247160-edd1-47a0-ac1e-b52069c11582	4	82.14	2025-09-25 15:49:21.360008+00
d32199a0-cb60-4685-853f-3abf283da1aa	35191e52-834b-49ce-ad39-75e35a3cfbee	f5d8606a-303f-4976-989d-6a670aa41922	1	168.90	2025-09-25 15:49:21.360008+00
749b9ced-4307-476c-9c7f-24606435937c	d03d2567-bc3b-46a2-b2ee-11b8b8523357	6cde8001-cfd8-4c69-a25b-b5327083ce49	5	285.33	2025-09-25 15:49:21.360008+00
8f958d7c-b3dd-442c-81be-a80b6f69508f	9a41cbce-2a8f-47d9-8994-ba5e8c985c14	cff573bd-1ac2-4710-a91a-b86b26f172d7	5	418.45	2025-09-25 15:49:21.360008+00
c25de5db-376c-4c82-b6a1-d405ae93b491	b051b1d6-9890-4e79-9dc1-f79c967fc9f9	1ea07bac-05ce-4d10-9089-c79774474817	1	146.13	2025-09-25 15:49:21.360008+00
81df035d-e5df-4e09-9078-2b28b0208861	2f1b8741-8866-4267-90ca-5084ab49e155	ffbd23bb-fb48-4f33-b711-932063f46416	5	154.56	2025-09-25 15:49:21.360008+00
9abd533a-ea97-483c-9106-034cfe421ae2	6be97509-6f0b-4c4f-8e6a-b27529c67133	e785fa14-f618-4023-a0e1-e30b2d5e868a	4	217.37	2025-09-25 15:49:21.360008+00
0eceb396-b951-4172-86b3-a2f471c569fa	76aa7006-dac5-49a4-af4f-13a435e6b008	c295d290-a589-4dd1-ab4a-fe7b997567bb	1	180.03	2025-09-25 15:49:21.360008+00
2feb5be0-4e84-43c8-87c5-c0c5ba05f45f	8bb9b9aa-1719-4a93-892f-307d85090bb4	a768cfda-4d7b-499e-a7fe-501f68bb8241	1	183.99	2025-09-25 15:49:21.360008+00
7051e3d9-7391-4c0b-869e-4ee818f359e3	987edebe-d35c-419a-b283-24996973dceb	d5cb6d47-534e-4b1d-b339-c34315876121	3	300.03	2025-09-25 15:49:21.360008+00
4dc00097-37d2-4edd-a39e-09e5c79af975	0fbbd80c-1f78-49a7-a474-06be4c1258fb	e3024b67-ea1c-4c79-bb7c-25b66e152003	4	31.30	2025-09-25 15:49:21.360008+00
73288057-0df8-438b-8df3-a481371b8af3	bea8c473-528b-41cf-b562-335723212cfc	75cc5b91-f516-41fe-9e91-a1edf47a582b	5	457.62	2025-09-25 15:49:21.360008+00
9b83a571-8474-4069-9a98-767923f009cc	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	ea3aaa06-10a3-4c1d-9daa-a973be6ed558	3	32.11	2025-09-25 15:49:21.360008+00
036cb168-5809-4206-ac29-995e1d2fcb5a	a3dae141-e372-465c-a11f-cb3972d4649e	e5269f77-1c99-48bb-ac03-995b3774f631	2	386.98	2025-09-25 15:49:21.360008+00
537c3014-e884-4e7b-a30c-e59cae983e01	c7be5263-3b3a-450a-a207-2b7d1c69729c	4511cd81-1f63-408b-884d-24fa6f05b835	1	256.08	2025-09-25 15:49:21.360008+00
00f2045a-8c27-4ab4-9c54-beee8eb879d1	a47099e5-e24f-48ac-b430-227b6dc72c47	2fc0cd25-6d9a-44df-9031-779a6b5d4bf9	2	68.56	2025-09-25 15:49:21.360008+00
96dfd00c-c768-4a7c-8d13-3f52713c41d1	94cbcd20-2c3c-4343-812a-e323c45b0111	436eb316-6fca-43bd-9aa2-345440016680	4	220.96	2025-09-25 15:49:21.360008+00
1703fd74-33e0-4447-9d99-b4d6b9e0d599	90e77639-78b7-49b1-897b-12d578024a7b	b94454e6-f48d-44d2-9e38-6b1df6cd02be	2	363.19	2025-09-25 15:49:21.360008+00
cdffa92a-0788-4a5d-a910-69a139b0a5b4	7f676a50-1486-44ae-95d3-b223ab0ca9c5	27a57e29-9044-4910-8ceb-6e40fe7b52c4	4	88.39	2025-09-25 15:49:21.360008+00
c1841b97-fc8a-48ab-965b-29bbe05e5290	915e5bc2-8e56-417f-a081-ffeb296d2b35	e0c24143-c277-4e34-a7c8-db1fc9905c89	5	421.55	2025-09-25 15:49:21.360008+00
38ed8c45-d705-41ed-82cc-4817c8d7fbda	14449588-fbb8-4fc7-a2d7-c98a583024a6	448bc7ba-131c-43e9-9061-b6a3d574e1ad	5	372.03	2025-09-25 15:49:21.360008+00
9718bdb8-3556-4cb1-9e89-31baec83e601	95c0e9b4-3cda-468d-b132-7b9806303461	8f5225a6-34f5-4c15-a988-d7a4f55ab035	1	223.89	2025-09-25 15:49:21.360008+00
5ed2f3d3-29d6-4257-bd10-c3207af372ce	79dfa4b0-c8eb-4de9-b1df-56832c39e35f	542d4f5d-8ae8-4710-b47c-35544bca73a2	2	15.17	2025-09-25 15:49:21.360008+00
d275d8b6-2b59-4930-b070-872a92497144	eb38046e-741a-491f-8f27-789b5b7c0903	6bd7c59c-cb6a-4d44-927e-32b938067848	1	45.17	2025-09-25 15:49:21.360008+00
f0fc2658-d516-4262-ae22-35d3a5420da4	7856bf5b-2c19-43d8-b299-88d269f0b82d	e1e9b987-57bb-4fb7-8513-4d1fae8f8f4e	5	119.17	2025-09-25 15:49:21.360008+00
7fa61408-ebca-4987-ae48-cf70879563c7	0dd73ff2-8ea2-458a-b8c5-af6d8bb93776	1ad9d18c-2c66-4b7e-8a06-e83dae22239d	5	73.80	2025-09-25 15:49:21.360008+00
d3fe3de3-3eee-4ef6-bff0-c2b41d8f742c	86af1dd3-a30b-4006-9b43-2c16f5a09fcf	6dbceb74-0c47-4565-bfa3-dcb7d954d612	2	331.26	2025-09-25 15:49:21.360008+00
fe6c9a06-9432-4a43-9e7b-5e01dc8fe2b0	29c44409-4491-4a6a-8843-fff08882f07e	8d296070-64ae-41e8-9999-aefb490fca22	3	355.09	2025-09-25 15:49:21.360008+00
b77cbd0e-4938-46fb-a5b5-71f103cb0158	32c57f90-438f-4ff4-8607-c09e53b9ddfe	9b9271e8-4297-4c58-96c1-5197c0eabb7f	3	165.74	2025-09-25 15:49:21.360008+00
e67c4ed5-944a-47e1-a559-1a362bf31d4a	32bd1acc-1545-4a61-a0f2-1e47c9f2618f	7d3d4da1-e551-44f6-8f50-c062c0e368a4	1	77.85	2025-09-25 15:49:21.360008+00
2acff159-7382-4154-b326-3962b4796956	251661de-8717-434d-b047-add8040b9bf0	d393defe-2960-4f3c-be2e-335411d955dc	5	46.21	2025-09-25 15:49:21.360008+00
1963923a-51cd-4b7b-8b94-901040581ed9	4e570348-6554-42ca-b80c-f98d2f79b055	2163a0f0-9c62-437b-967c-e1ac10d7ee1c	3	352.81	2025-09-25 15:49:21.360008+00
c209fc09-8fac-47ac-8cf7-c42485f2cee2	31008365-6ecd-4fd9-a6bb-e94d23c15333	1cb84abc-2cbd-4772-88cb-9c1bc1d2eca1	2	315.50	2025-09-25 15:49:21.360008+00
7be65705-b2d6-4ee0-bcca-26cf0b0d16dd	e55fe7d6-aded-49e0-8610-544f5560872e	dd96e686-fa93-43ea-8ff4-a2525f0c8f6d	5	407.57	2025-09-25 15:49:21.360008+00
d4010b5a-7bdb-4e1b-8f1a-09cde3a7dfca	34f95a9f-4e7e-4ccd-8da9-a1b0f72ca2c7	6b8bae2b-61ba-4605-89bb-f68d26b660a8	5	85.72	2025-09-25 15:49:21.360008+00
ba19199d-87d0-4260-90bd-541c2768eb4c	c88dad4d-3293-4c57-b39b-957991bb2f44	9d08ff83-b53f-4ca4-9df5-2d02e9604aa0	1	236.96	2025-09-25 15:49:21.360008+00
82bccef3-56cf-4632-84bb-d21a2fd968bb	a47099e5-e24f-48ac-b430-227b6dc72c47	9ad8c55e-cfef-440d-94e5-b5c2ad7f5859	4	278.47	2025-09-25 15:49:21.360008+00
ddf55bb4-acb1-4ee1-a27f-fccb25ee2dfc	4e570348-6554-42ca-b80c-f98d2f79b055	905533f0-1768-4875-af44-c40f2f12fcbf	3	261.31	2025-09-25 15:49:21.360008+00
2d2ba4c2-f16b-4dec-a44e-ba85d029c91f	1f5a7650-6543-4791-b064-3290aa6b362c	a52e2f4e-d07d-4aee-b531-714c0ad0d355	3	363.55	2025-09-25 15:49:21.360008+00
c79de347-3fa7-4a4f-889f-df3d0a77a932	750e4907-ab47-4e1a-a191-e6356a4962aa	13404922-32d4-4b7b-93fe-08f504436a82	4	359.23	2025-09-25 15:49:21.360008+00
a488a27f-0bd3-4b2f-8720-d7491098c810	8152a226-4276-4a46-9056-dd92ddb1413d	8f1f4898-74f0-41a2-907a-0e82e0cb2ed6	5	413.13	2025-09-25 15:49:21.360008+00
9b992caf-d636-44f8-87ef-f99e264151ac	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	59949c43-3538-465d-b575-326cbdf39557	1	455.18	2025-09-25 15:49:21.360008+00
7b45252f-59bb-45ff-83d0-6dffcd239958	72326bc6-8625-4cc8-a771-f05af5bf0276	0f1a5116-4be6-402d-a686-67b33912c320	5	283.88	2025-09-25 15:49:21.360008+00
1d6be1e0-17eb-4d06-a89e-ef6d28aa0ae5	757c9061-6530-4e60-9f51-f749a75cf907	450e6ec6-8b6c-44b0-9a19-18c3a3582090	4	188.70	2025-09-25 15:49:21.360008+00
00d1bc5e-570d-4328-8e7c-10f78b25025f	32c57f90-438f-4ff4-8607-c09e53b9ddfe	0a561629-6faa-4571-a7eb-d47ada634332	1	78.19	2025-09-25 15:49:21.360008+00
b74df5df-6612-42f2-b790-31244e7d284c	a1a52a7b-6c94-43b6-b8d8-b0aac52b3db1	38698efa-0fa4-4a79-9d21-2da2af8008f9	4	367.37	2025-09-25 15:49:21.360008+00
050cfb3b-c1fd-4c05-a7d7-193a8b9231b0	57feceb2-4b87-4a89-aca7-1325f9705afa	676fcc0d-3c5e-497d-b57f-ee8fabfa95c8	5	290.84	2025-09-25 15:49:21.360008+00
7a49f5c5-7f71-4170-8a6b-c7b7d50a8b64	7a1bfb17-b859-4250-bf36-5ff26230b8fc	4df41507-2c3e-46fc-a67c-8c6711ddebda	2	133.18	2025-09-25 15:49:21.360008+00
02f10236-1d46-44cf-ad63-234f930f04cb	06ec6966-1cbb-4cf9-8f63-482325332370	4439085f-d4d6-4458-9e6d-703011ee1376	5	391.33	2025-09-25 15:49:21.360008+00
afbe77dd-0936-4cfa-b84a-c2ef726eb46b	0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	ce542f08-c868-478f-bde6-5e5db60c20ab	1	367.27	2025-09-25 15:49:21.360008+00
cb708eb7-a050-4ed1-8a6e-61a043e8144a	9ddf866a-c7b1-480c-b2cb-a95cccfa1293	ed12393f-ed39-4a41-aa7e-68085036adc9	2	188.38	2025-09-25 15:49:21.360008+00
a1a6ec98-8a7c-4ab8-8cf2-9f0eb8701b45	86af1dd3-a30b-4006-9b43-2c16f5a09fcf	65916b3c-9161-4b3f-96b6-40c59d46a652	4	141.15	2025-09-25 15:49:21.360008+00
f00090b1-afad-4e33-be74-813af9006d40	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	bf052005-a645-4f23-b7e8-9b4c039e3022	3	138.60	2025-09-25 15:49:21.360008+00
bd830e45-4aa0-45d0-bc97-5e82dade6cd5	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	36a6c226-7e64-42cc-a129-41e2439fdab8	5	372.55	2025-09-25 15:49:21.360008+00
44ca6a43-ffab-4b8f-aae3-50893f6817ea	bea8a935-f088-4989-b741-d28734836f0b	4f32fa4a-7f23-4f96-9208-413006b3308f	3	358.46	2025-09-25 15:49:21.360008+00
78d4e338-5537-4f1e-8fdf-0c0ed10a3191	27e301e8-2e68-495a-8e90-334043fd9ec5	d8cc973b-ce87-4abb-b851-b83ef3c6939e	1	488.19	2025-09-25 15:49:21.360008+00
d19dabd5-c130-4ddd-b4f8-989a069c8191	b051b1d6-9890-4e79-9dc1-f79c967fc9f9	b166158c-a5be-436c-ab5c-d1f97b0572b6	4	114.22	2025-09-25 15:49:21.360008+00
094abcb6-6c98-4dca-bd51-7d3ec655c347	0285e8f8-4fa5-416a-9cbf-256b098026c5	1ac02056-9f69-460e-be73-9439774634eb	3	281.22	2025-09-25 15:49:21.360008+00
c08241ac-a022-4bbe-afec-fb2497d8e93c	5067949e-1cad-4b2d-94e1-ff4180e9526e	ffbff3af-ecd6-4d7c-a5e6-a8d511ae2334	2	210.18	2025-09-25 15:49:21.360008+00
6f29527e-2ff4-4eb7-8444-a5b7a36dc93f	26204835-dcc2-4a79-9c9d-3cd38271fcea	90f27124-bec5-4f09-9d53-634414404daa	3	204.91	2025-09-25 15:49:21.360008+00
069593c2-2447-4c04-b409-e300bcae6558	b3e0dab7-bb8f-4118-9ffa-bf9eaef8898a	01fb9db6-a7be-48f5-b979-43865947ef42	2	466.72	2025-09-25 15:49:21.360008+00
880ad1d8-ae0a-4391-931e-f5460c3c8d99	c99c3a55-5a02-4422-8bba-8ac5704961c3	866ec54f-443e-4ee7-a605-619c43c6a6ac	5	375.32	2025-09-25 15:49:21.360008+00
f4fad71e-e4db-4af7-84a5-2577f6a68cf9	688dccef-34b0-4924-9653-9cf2dbb1d4e9	172f7972-39b2-4182-903a-8ac4660a5478	1	410.15	2025-09-25 15:49:21.360008+00
8c9788b7-8696-4196-8c55-faa1e4665221	4647fc71-9cda-41e0-b773-25dbeb306b51	c089edcb-9113-4eec-8083-c2c56dd4ee24	2	494.63	2025-09-25 15:49:21.360008+00
ba737968-b5ce-439b-b25a-60b77a164d2c	443b5fee-ce08-4994-98f5-b6b9c75e74f6	9e4dc57f-4b97-4742-bfd1-6fdc51803678	2	257.44	2025-09-25 15:49:21.360008+00
02496952-7fd8-45fa-bc50-666d46b88fac	688dccef-34b0-4924-9653-9cf2dbb1d4e9	f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	4	25.31	2025-09-25 15:49:21.360008+00
af99f50c-3407-4f14-a99a-474ddfc6dbc2	bbdf2ae9-4f93-4611-a772-7d489eb29879	c466f5d9-7b18-43d1-bf0f-3a425644e69e	5	57.32	2025-09-25 15:49:21.360008+00
a7bec2f5-d274-46dc-942d-d968f8d79486	6d7d0f2b-4e86-4b62-bf16-76cb84921825	78f65a6b-18c2-48df-8bc0-eb30a0154451	1	104.96	2025-09-25 15:49:21.360008+00
da9444cd-af03-42d5-8dbf-80af825d2a33	4942c836-17b6-4f00-b02b-588aed15e9d3	fc6bb273-6c79-4da7-9bbd-902c36847259	3	295.92	2025-09-25 15:49:21.360008+00
56a59355-b025-4ec4-a007-74d0c160f369	fc35a6e0-5c19-49dd-9ce8-59732d670e5c	6abb415b-fe4f-4793-ad8d-868a795e32ec	5	327.62	2025-09-25 15:49:21.360008+00
4b7dc6a8-24bc-472b-ae0d-7ace4ea6dc96	ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	e7f0c539-2930-4377-a02b-ef1af9a49026	1	110.73	2025-09-25 15:49:21.360008+00
17ca733d-ca3e-4f04-a242-9e9a1432e016	1cdb3f00-6866-4d15-aeec-fd1c087251ad	6dbceb74-0c47-4565-bfa3-dcb7d954d612	2	265.66	2025-09-25 15:49:21.360008+00
c1e5b9a4-1a19-496d-be2b-560652fa70cf	f5d9a35f-a471-4694-b45d-d24d9c682512	fecec68a-2825-4382-b4cd-77c817f1d576	3	410.45	2025-09-25 15:49:21.360008+00
8c7d1937-ff26-4883-9e66-7c8efd0050e3	150fc2ed-e9ed-40a6-8a63-901228df41ba	4ccc4ba0-062c-4e39-bae5-7c9970cb9945	4	122.37	2025-09-25 15:49:21.360008+00
21ce8131-35e4-422d-9a7e-8f6cae9d11bf	13c1c8f6-ea68-41f8-98cf-bf54740fe3b6	fa275115-fa7a-4c25-82e0-d252e045b29a	2	289.91	2025-09-25 15:49:21.360008+00
ba9dfba8-4311-4c51-9ed1-d71259f01370	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	02130ef9-7d07-4e39-83b4-7789103dfe0c	3	436.56	2025-09-25 15:49:21.360008+00
d6a437ea-58aa-444d-afcb-24e2993f7ad3	88208539-9376-4877-ae9b-8071dc1d8d98	751ee4e4-ff8e-4d55-ab7b-05bcd323576a	2	238.06	2025-09-25 15:49:21.360008+00
5c5aa5a2-e291-4ea9-9f6f-02be478c10d1	17696562-545d-411b-96ac-553be0bd74d6	badbf107-01fd-4376-b55b-b1ffc7c8735f	1	119.28	2025-09-25 15:49:21.360008+00
9f23db94-b189-47f3-8b20-f69779a04850	c4a24deb-273d-41a1-8c33-cdb4fe790380	80f50827-808f-4054-a4fa-e86b32d47e1e	3	264.73	2025-09-25 15:49:21.360008+00
b1a57cbd-e614-40a4-ba46-4f6fb6a66bbc	272b6776-dddf-4ab4-ac22-a81e85805712	099f686d-67fa-45f9-b8e4-b580e59670d4	5	26.70	2025-09-25 15:49:21.360008+00
d7cccfd1-980d-4138-9407-dcdfd4429350	5b7cef35-0333-432c-a41c-3355e75747f2	87d06221-5ca5-4779-b8e0-bf72cd6e2795	3	311.63	2025-09-25 15:49:21.360008+00
c075dfcd-77c7-4c24-93ac-37deda522d32	757c9061-6530-4e60-9f51-f749a75cf907	c110f3b0-4c75-4fee-a723-118fa839b84e	4	164.57	2025-09-25 15:49:21.360008+00
97b7efb6-08ee-4430-a0b8-55741ac43eab	82d0a438-b64b-434c-b699-3bb958b99683	3ab25fee-76a8-4cc0-935a-3f98460ff7d7	2	197.02	2025-09-25 15:49:21.360008+00
fc9b5894-380e-4874-80e7-c002974cb2de	86af1dd3-a30b-4006-9b43-2c16f5a09fcf	9ffb6cbe-32ca-4b86-a399-f0dd4836be95	4	225.93	2025-09-25 15:49:21.360008+00
6484806b-f77d-4c3b-8458-dcad0881eb8f	59d98d0b-7e79-4710-833c-9b90ff83b1c9	8d83a025-5e63-492f-b4d3-411c4eaa5161	3	431.47	2025-09-25 15:49:21.360008+00
66ada966-f30e-49ed-9966-fa976dcd2cfe	30bbe271-3b24-46e7-8cf9-1b29360fbd83	a5dde8fa-5075-4d78-bd8d-a8b0b48456d5	1	225.33	2025-09-25 15:49:21.360008+00
d0b97c61-410a-470a-90dd-30ce4aea6e99	49a53a47-96c0-4d2e-9c20-d187ea1fa421	a8a11156-1c57-4a4b-8c63-b08f29eac11f	4	394.09	2025-09-25 15:49:21.360008+00
f339b2ed-11f7-4459-bcb6-8aa3729b21b2	32bd1acc-1545-4a61-a0f2-1e47c9f2618f	94d5fd54-f886-4df1-afe2-7840ea858b5a	3	17.45	2025-09-25 15:49:21.360008+00
ec7bdede-ea9a-4c4d-9a14-a4b9ff28859b	326e3fff-476a-4842-91b0-53752eb15c7d	450e6ec6-8b6c-44b0-9a19-18c3a3582090	3	414.76	2025-09-25 15:49:21.360008+00
3d80d837-7c09-4f77-912e-a24bcec1364a	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	db49b6ec-1ee0-4fe0-bc63-f5d6255f92d5	3	201.61	2025-09-25 15:49:21.360008+00
b24da9f8-1ba7-49ab-a51f-15afeeb41f87	f4601bba-35a6-4906-9539-9e3678219a62	ca326115-3c26-4311-9daf-04c1954c2538	3	286.76	2025-09-25 15:49:21.360008+00
cc2b8488-d145-44d5-a6b3-82fc0b362351	967536eb-8cb9-4eb6-a8f7-77c9d6125463	aedd1f54-9ef8-4bae-8650-8be25187046a	1	257.76	2025-09-25 15:49:21.360008+00
adb56e84-31bc-466d-9fa7-a1e94d0bfb2e	98b43bb9-9816-405e-ab39-8bbe4bc01b98	2a77af69-7b2e-457e-b894-8e07457c8007	2	115.12	2025-09-25 15:49:21.360008+00
f15a9dc5-894e-4c9a-9647-07aa0c86ed10	6882d9a4-73a3-4f7f-8fe6-120bb76a1dcb	3ff42df6-c9fa-4c31-a2f8-6ebe767ea616	3	270.94	2025-09-25 15:49:21.360008+00
d7f2340d-d281-420a-b1fc-205eb59aa477	9a41cbce-2a8f-47d9-8994-ba5e8c985c14	05b31b6e-e489-4c9a-8976-cc6acfb7b161	5	460.34	2025-09-25 15:49:21.360008+00
8a3c0730-4f10-4b6d-bad6-fb38af5d26aa	41af7684-234f-4c36-93d9-550f6dec9dd7	dff247ae-66d0-421d-9ade-331030b7c3e4	2	279.94	2025-09-25 15:49:21.360008+00
a6f95717-801b-4c01-ba2d-b6c58ef0873b	a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	d3ea9f78-f866-4f13-bd3f-3ecdd4c8ad7b	3	464.78	2025-09-25 15:49:21.360008+00
70b43ead-d3a3-41ab-9060-e7f878a9856a	88d67c80-cddd-4ebe-ad98-0641b5884be1	4d7420ea-af38-45e4-ba7b-983666b7a631	2	292.28	2025-09-25 15:49:21.360008+00
63682d72-dfda-48f4-94eb-1484ed66aa48	3ddfbb5c-a1b2-4101-ba1e-0ff667c1ff78	6dd6c04b-c211-4ce7-b72c-c0761a4e14ee	1	439.70	2025-09-25 15:49:21.360008+00
6c57181b-c1d1-4277-a0fb-8448ac3bf471	260c5ea6-e65c-47e4-b88f-a5345ad86fb9	6eeb9ad3-c9f5-468b-acb0-3bb6773fabcc	4	238.55	2025-09-25 15:49:21.360008+00
86280f9f-41d9-42af-8c2b-a50c70ae3c1e	4647fc71-9cda-41e0-b773-25dbeb306b51	7b36058a-61a4-4bcc-b4f2-e1092aa12fc9	3	126.40	2025-09-25 15:49:21.360008+00
d0f8bf68-879f-4943-8b9e-90aa7e4e475c	6aaf8114-6b7e-433d-a650-c54005da2285	430f6e5d-6537-4ebb-96e5-aeb0777827fe	3	367.54	2025-09-25 15:49:21.360008+00
43f2d34c-e3ae-4935-b34b-456de7dfde0b	86517f8b-c37c-4bd9-83b0-d44a59b52fce	abb6ab02-a0d7-4873-bfa3-4e10d68b6c9a	2	366.54	2025-09-25 15:49:21.360008+00
bc4ef31d-319f-4ea1-b514-907a75da6810	42e0c51d-7b30-48be-b03e-71802fc7811f	350afe49-c3e0-4a97-8d8f-310e04a311b0	5	439.91	2025-09-25 15:49:21.360008+00
bc5ff861-c7fd-4ebc-8461-67890a6174ee	15b13006-4c56-4f21-9475-f3c5d7bfb52a	a7acef79-0b6c-4331-b733-54ce9c2a8e54	1	141.70	2025-09-25 15:49:21.360008+00
b3da73ac-7e36-4ce3-957e-fee74e730df9	94616eca-5069-4a67-a50c-a0e30b58ea7f	f8ae2130-79d9-42d0-992c-43d9cf1a0688	2	248.16	2025-09-25 15:49:21.360008+00
5ca36e8f-ae79-4991-9160-c921f965f664	01d87596-cfd1-4a33-a5a3-afc687b9fc5e	688b8efe-e6d0-4fc8-a0ee-5cefdf5e4173	3	381.49	2025-09-25 15:49:21.360008+00
3d3c4514-5307-46dc-842a-ea2b18cb2714	377076ea-c406-451a-aa04-794eae18719f	4fd9d068-d362-4394-9fac-619fe99e29bf	5	99.63	2025-09-25 15:49:21.360008+00
5aaf762c-4a60-40d2-a5fb-ac39028edd55	e6c0ba47-4039-4395-bb4b-f0e37705126c	8bd888a9-2d16-4edf-bdf1-4152af85d945	4	33.45	2025-09-25 15:49:21.360008+00
aa5b0942-1200-492c-a2f2-d0b168371a1a	66d5dff5-1fb9-41b1-b15a-dabe2c70fb70	4b3c92b2-b064-45a3-9566-c963f4492abf	5	331.08	2025-09-25 15:49:21.360008+00
c6fbd6cb-f7c6-4f8a-9bb2-80d536bd222c	57feceb2-4b87-4a89-aca7-1325f9705afa	42efecc1-d272-4b66-8b03-4dd82b43ef1c	2	236.70	2025-09-25 15:49:21.360008+00
d68a02f3-d3d6-4589-a36d-010d9bce88c7	7a1bfb17-b859-4250-bf36-5ff26230b8fc	cd862f44-36df-4ad5-b816-1a941066779c	2	254.68	2025-09-25 15:49:21.360008+00
0188b3d8-095b-4431-9fcc-21b2c4f1d165	4d52611f-06e4-4fac-99fb-1f45b0a1ac57	75a131a4-f92c-4efe-ae1b-e8ec24c6de21	5	263.94	2025-09-25 15:49:21.360008+00
b534186e-9926-4226-8ef5-69943d4de1bd	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	cd37d7b5-4541-4e4b-8a8c-f3d3404260ca	5	175.06	2025-09-25 15:49:21.360008+00
124965b9-e84e-4f72-86b4-cb61d1a3a41b	8ed1beb2-62b8-47b4-8d1d-2dee28ca32fa	4f69480a-a24e-445f-be33-571a96e23e13	3	429.17	2025-09-25 15:49:21.360008+00
a063880f-e916-498b-9634-312b5290a8f2	81e3e409-d429-4a1a-b8f3-2e8e517dac57	bd2cc9a2-7c6a-490b-a59e-d539bbb27edf	1	327.25	2025-09-25 15:49:21.360008+00
89b12a41-62a5-4155-8ebc-07e2a43c1ee2	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	50f9a4a6-37c1-4410-b87f-ed90f6ed0a0e	5	240.49	2025-09-25 15:49:21.360008+00
96b46935-e534-48d8-9462-65f3adb36aec	7a0e8803-b665-46d2-a9f5-79297739c1e6	5313e723-6857-4786-9992-2256123f182a	2	484.17	2025-09-25 15:49:21.360008+00
a96314c2-6719-4154-b9b4-047f08662676	dfb005cd-0407-45b1-a52c-f9b50f1d1d65	910a812d-0b9f-4e71-b753-a74d93721c7d	2	43.54	2025-09-25 15:49:21.360008+00
79440ecf-69b8-40cf-b843-53e793e8f41a	05563c70-d86a-4726-ba56-30fabe6c2764	29831035-def5-427e-b2cf-1b870011f3f9	2	277.78	2025-09-25 15:49:21.360008+00
41e4c7a6-ad67-484a-ae8a-2c8082c4affe	d3f139c5-20f0-4814-9d64-89d703cbf5d1	628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	1	146.55	2025-09-25 15:49:21.360008+00
4159e94c-7e89-4c9d-8682-4343d7bb2727	c4a24deb-273d-41a1-8c33-cdb4fe790380	65c0ab7f-24fb-40bc-87f5-b5829a108a71	5	329.10	2025-09-25 15:49:21.360008+00
f1592655-bee6-4fb9-b7ef-df6b194b65c0	bf58f402-7f4d-4fa2-a27f-546eca05c308	78b46b2a-8550-405c-88b0-e2619b3d095a	4	88.30	2025-09-25 15:49:21.360008+00
e4405e4d-7b36-40f3-a0e7-6648eeff5a57	4b4befc2-d7dd-46bc-b8a5-4f0ed3dda5d8	c96f321a-391f-4fe0-b189-23b2294f7466	4	290.79	2025-09-25 15:49:21.360008+00
1618ee12-ddbc-4be7-b054-55ecc130124b	178da109-b1da-4087-8b86-b5a245d666c3	7cd8aeab-d746-4e22-a331-20f85bc0547b	5	88.48	2025-09-25 15:49:21.360008+00
cdedb44e-bc0b-474f-9278-430327ad3108	30bbe271-3b24-46e7-8cf9-1b29360fbd83	9af2c1e3-9ac4-4581-851e-4631bb1d8ab1	5	96.26	2025-09-25 15:49:21.360008+00
784bef55-1008-4b72-8b6a-113b3edacc66	e9e7ddf6-004d-4f6c-893e-0b261662a06e	0350cac3-db8a-4f49-87e7-feeb90521b6f	1	194.93	2025-09-25 15:49:21.360008+00
d8618b35-f016-44d8-9ff1-6bde78d9b7a4	8152a226-4276-4a46-9056-dd92ddb1413d	841f34dc-a86e-4f1a-9c41-0a66ae0b29c0	3	284.05	2025-09-25 15:49:21.360008+00
6de36255-527e-4d18-acd0-0f4be8a9f287	f4f69eda-bc2a-4145-9730-ab4d5cbf4e89	709287bc-f3cd-470b-8c90-29c3b09aa947	3	276.66	2025-09-25 15:49:21.360008+00
f8128b93-b079-4f64-ada6-c6242c6c4e5c	06ec6966-1cbb-4cf9-8f63-482325332370	b19683b3-ab17-4746-9e07-440b6db949fe	2	495.41	2025-09-25 15:49:21.360008+00
99b9111d-4f63-4101-9a62-aae4e189167e	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	719993bf-3a56-4afe-b749-4954fe4ab27f	2	426.20	2025-09-25 15:49:21.360008+00
94210254-f0af-4029-bf0c-879426c4a7a5	86860fb8-6f26-4f28-9be8-276d06c16b8a	00e4225a-d885-4cd7-ae38-e8ab0073616d	4	102.23	2025-09-25 15:49:21.360008+00
a6e77291-2163-4a90-a32e-a493850110f7	88d67c80-cddd-4ebe-ad98-0641b5884be1	7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	4	27.62	2025-09-25 15:49:21.360008+00
a8de12e8-cba0-481f-abfd-f83f4c88c0a3	5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	24652c3b-5928-4336-9101-22ff1d683c47	5	435.13	2025-09-25 15:49:21.360008+00
40f6768d-ce34-40d8-9597-84bc76308bf6	772d52f2-8383-43ac-b62b-8265f7d3fbb5	9d108fa9-0eda-4747-847c-2557ebd3e468	5	421.88	2025-09-25 15:49:21.360008+00
933336b9-2aac-4647-bd6a-182e80885d9c	6882d9a4-73a3-4f7f-8fe6-120bb76a1dcb	9b7d79c3-4d67-41e0-afc4-33ad9c0ed7c5	4	245.16	2025-09-25 15:49:21.360008+00
8851ddd7-780d-4316-bf64-eb61e2c2f567	d9b325cd-29c7-44e6-a1dc-039aba44e40b	301b960f-1b4f-4759-9bb5-5f294838f218	4	107.45	2025-09-25 15:49:21.360008+00
b9bb438d-6bd7-4e66-8166-12172bfcc3d8	9c349870-4a91-4fac-b1c8-a59c6d9aea49	dc3c4bdb-d9e6-47b0-b642-cd10d9f663ff	3	190.81	2025-09-25 15:49:21.360008+00
b6088935-9506-46dd-988a-1804e4d52606	919fe3d6-7154-46b5-bd5f-f3120fee1a0b	5cd9a9a1-f212-4606-af53-fca25dd3080e	5	418.72	2025-09-25 15:49:21.360008+00
bc456a6c-866b-4bfa-ba2e-06f01904dc9d	3b72660b-c141-4949-9a58-1991db90bf7d	3da031bb-133f-4ad8-b643-bd1a5f886aa3	3	33.81	2025-09-25 15:49:21.360008+00
a568499f-8979-4344-bf54-8981d8905a98	be15e883-2c37-4a89-9dbb-d77fede72e32	d55b1e7b-d82c-405f-99bb-267e0d272594	5	241.74	2025-09-25 15:49:21.360008+00
70bcbf67-3608-496c-8252-3ee613b97f5f	c61eacdb-3561-4f85-a457-7bbdc1e340db	02130ef9-7d07-4e39-83b4-7789103dfe0c	2	57.44	2025-09-25 15:49:21.360008+00
a17c676e-23c0-4d8c-a5e4-d33be1a3dcde	cca06839-8936-4474-b9ce-9309b36ff30a	3c1a208d-d3a9-41c1-bdc8-f17d9025884e	1	38.28	2025-09-25 15:49:21.360008+00
a44721fc-92fe-4a3a-8fd5-b6e86e7ad3db	06f9659d-9944-4e7f-b875-27476aa80190	4e60b8c4-f146-4be6-8129-816854b5f830	3	396.25	2025-09-25 15:49:21.360008+00
a67955c2-3786-4bf5-811e-e402fc71f686	757c9061-6530-4e60-9f51-f749a75cf907	e24d4035-5902-4b41-b494-da0316041933	2	359.14	2025-09-25 15:49:21.360008+00
13d3b2e9-5a55-4c59-8bb1-7a738e25642c	443b5fee-ce08-4994-98f5-b6b9c75e74f6	53f1fb75-11ca-4299-858b-372f04dca7fd	5	55.93	2025-09-25 15:49:21.360008+00
b3c29bce-4989-4078-babe-3704179a4db8	4942c836-17b6-4f00-b02b-588aed15e9d3	3e211461-ef29-4d16-93b5-65c617abe5ea	3	182.87	2025-09-25 15:49:21.360008+00
ea61ec80-e216-4819-aa74-f58567b75d33	24732732-58ca-4efb-9165-3c9b0d9471af	0b86f9b2-2c5d-41c8-96b0-5f0329f2b640	1	469.63	2025-09-25 15:49:21.360008+00
f0c33fe1-0bb7-4e83-91cc-595fa781c5d4	bea8c473-528b-41cf-b562-335723212cfc	ac168279-ea8a-4a93-bd19-f8392df74292	4	128.30	2025-09-25 15:49:21.360008+00
2435e253-be9b-421f-8d98-79d6de245530	d3569393-985f-4053-b8f4-5e14fc51b461	74baed34-5bd9-4797-ba16-64c96ea776f4	5	460.08	2025-09-25 15:49:21.360008+00
46cf0b8a-31c3-4df6-94dc-43a160ee1a70	8ad3c805-448c-4596-a4d3-577c1ef68b79	26ef9482-13ef-447d-8705-626db164f85a	4	467.30	2025-09-25 15:49:21.360008+00
dbad6c3c-28ea-46cd-8337-52be02be54b1	3ddfbb5c-a1b2-4101-ba1e-0ff667c1ff78	a27d5cef-fa30-49a2-b338-b63c4ed23a9a	3	204.50	2025-09-25 15:49:21.360008+00
d568804e-1337-4933-aee1-21c613f6a1e9	a8f1300e-9928-4a6c-87bb-88e67dc80007	8de4438a-27ee-4dee-8b82-48173ae9c8ec	1	484.50	2025-09-25 15:49:21.360008+00
ee434b4f-884e-4d2f-bdab-8a38e3837cab	0767e0c8-9b15-41c6-bd33-076d94ba2fe6	c1a72083-cf94-4875-923b-86177624a286	4	221.34	2025-09-25 15:49:21.360008+00
622c8399-28c8-4dc1-a2d4-6e5d397c61b1	326e3fff-476a-4842-91b0-53752eb15c7d	a4ca9a09-1447-4df1-a3f4-4b5a8cc4321f	1	249.63	2025-09-25 15:49:21.360008+00
fc8d4c0e-9228-4d5d-920d-d04c14f37b32	80277854-2b1a-4543-b441-c5280a2768c9	bae15f80-741c-488a-8c41-d76ab1913368	5	435.57	2025-09-25 15:49:21.360008+00
2d76d1f0-8621-44fb-adc9-35e81752f935	0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	4f2223d9-a061-49a1-9c99-03119a08763e	5	211.33	2025-09-25 15:49:21.360008+00
b30e0b8a-bbc1-44b7-9d7f-9cd781bf3f11	a1963124-0e73-4dcf-8487-9e22573e91fe	8bc06db5-1714-4c98-8785-6d14c39abbba	1	165.35	2025-09-25 15:49:21.360008+00
44848a04-e9b0-4d83-bed1-3394d8f4b1b5	80277854-2b1a-4543-b441-c5280a2768c9	fd22ea45-0b26-4d83-9d24-0c09ae8e9a98	1	168.20	2025-09-25 15:49:21.360008+00
e596ccc6-62cf-4afc-beca-32df2b2a2709	94cbcd20-2c3c-4343-812a-e323c45b0111	e935a7d9-de71-436f-a81b-83df2cceb488	2	418.25	2025-09-25 15:49:21.360008+00
15ac37d7-97d8-43f1-b86b-927b9fe62e22	dff49b1c-3584-4537-b0a3-39b63729570a	2cac94f6-f439-4a4c-9f09-75eb1f99f0db	3	499.96	2025-09-25 15:49:21.360008+00
daffc7ee-9b57-4c67-8d8e-399ac09df985	377076ea-c406-451a-aa04-794eae18719f	41f0863c-9837-4832-a26b-d2b73aa5a262	5	408.32	2025-09-25 15:49:21.360008+00
49aced6d-0f4b-4a10-bb84-1c7fb7879b71	0c5be91b-4cb6-479f-8d5a-d661e3f1446e	d393defe-2960-4f3c-be2e-335411d955dc	2	417.78	2025-09-25 15:49:21.360008+00
7be30bb2-12dd-486c-ab92-6856b779f3ce	de729129-ee71-4d4f-86b1-2b9f6413b383	2fd5912b-9adf-487a-a8c7-cb3a38daa80f	4	1.30	2025-09-25 15:49:21.360008+00
b73d1643-0cfb-4b2c-b4a3-95b6ad824d8a	4e570348-6554-42ca-b80c-f98d2f79b055	a78bcf16-ef7c-4b5e-a7cc-b77d0c780c2a	5	266.81	2025-09-25 15:49:21.360008+00
abfc8abf-f1b6-4b24-a0c9-04c3c74644c8	e7af09a0-4128-438c-8b0c-fd71bf4172de	3c1a208d-d3a9-41c1-bdc8-f17d9025884e	5	114.57	2025-09-25 15:49:21.360008+00
a35439af-463c-491f-b045-f55f88718a70	251661de-8717-434d-b047-add8040b9bf0	e257c30c-24bd-4f7f-ac74-04e3fb863198	5	499.29	2025-09-25 15:49:21.360008+00
33690586-ea70-4c54-8797-14b27740abdf	03a68ad5-ad3b-4c06-ad83-9715d026142b	9f52e2bc-980b-48d4-a9da-ca34a8a0e9f3	5	326.34	2025-09-25 15:49:21.360008+00
297fc8c9-a903-49a9-9fee-52b6186ed018	ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	c99a333f-7850-48ee-be90-35ad9dac0cb9	3	273.28	2025-09-25 15:49:21.360008+00
c491f79e-79e4-4556-ad16-ceb796e526a6	eb38046e-741a-491f-8f27-789b5b7c0903	716cb29f-2b54-4eb2-9d2f-82eb248eca72	4	319.39	2025-09-25 15:49:21.360008+00
76a1ecfa-47f7-4f48-b2f8-3be8769bf737	c1e0cd9b-4de7-4253-b09c-2fb7299fb30d	be8ab051-2528-40c2-a631-76a69ba9586d	2	259.85	2025-09-25 15:49:21.360008+00
8969d9b2-412b-447e-ac29-8d7c5d671257	2d394776-4346-4293-a272-b482ea30acf2	d35d14e0-fbf2-4bdf-bd44-4648377c5703	1	442.83	2025-09-25 15:49:21.360008+00
ad6472d2-222c-4839-90fc-609f82c3363b	76aa7006-dac5-49a4-af4f-13a435e6b008	8d082510-2d25-45c5-ab63-09578063bd42	5	267.02	2025-09-25 15:49:21.360008+00
5e3eb2f0-d04a-432f-8f7d-0b124ab098d7	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	c42aa557-2ac3-4c8b-b680-45467d38a8ab	1	289.21	2025-09-25 15:49:21.360008+00
5d391f5d-a8b7-47b8-803f-1868f53f00ca	66d5dff5-1fb9-41b1-b15a-dabe2c70fb70	117fdc33-7e81-40a4-84f2-e9702ade010c	4	75.84	2025-09-25 15:49:21.360008+00
0bd5253f-d594-4674-8e98-30107a5d1230	a569ad72-ed52-408b-980c-c8dfbb18fe8b	7f72cfc7-633d-4d9f-a31e-e0424be358fb	4	168.76	2025-09-25 15:49:21.360008+00
5c3ef54f-ae82-4823-8067-f91b1131251c	24732732-58ca-4efb-9165-3c9b0d9471af	04c04857-5dce-479a-a2d2-87e61a214475	4	119.84	2025-09-25 15:49:21.360008+00
126380fa-8c4a-42b8-be80-492e0e5238d9	6fc62102-14fa-46c8-be9b-cf3935b4f0ae	4ca3c954-9979-4d43-bb0d-5ed8d9f2ceaa	5	156.21	2025-09-25 15:49:21.360008+00
0a6e7310-dc0b-42d3-a177-b37397ba77ac	7856bf5b-2c19-43d8-b299-88d269f0b82d	ca326115-3c26-4311-9daf-04c1954c2538	2	73.60	2025-09-25 15:49:21.360008+00
cdb93751-8ac6-474f-ae40-2b9c29aec8ce	c3c934db-f8c9-47be-8b8c-fd7ee1156937	ed12393f-ed39-4a41-aa7e-68085036adc9	4	313.62	2025-09-25 15:49:21.360008+00
bdb3238c-e851-4dd8-a43c-f984d8f2794a	91e34dfa-9d3d-4330-8713-cedf19705c2a	82a27f3b-a6c3-4c96-92e0-67949408e931	5	177.06	2025-09-25 15:49:21.360008+00
b5aea890-a97c-4d91-b47e-22cd662b156f	d4c1ef8a-7751-488e-8f5f-deb7d506d960	50f9a4a6-37c1-4410-b87f-ed90f6ed0a0e	5	322.44	2025-09-25 15:49:21.360008+00
c24058e4-933b-4ce3-8c17-6a45bdb4b76c	c1cd7c6d-9072-4172-8c7d-bdcb86d702f4	2566d6b9-b78f-4390-a3b4-5a334cef5230	5	112.15	2025-09-25 15:49:21.360008+00
4a756baa-f060-4520-b1bf-23fc55ae6043	7ee6fea3-ff9f-42e6-bb41-9367c3fb6a84	ba164ec0-372f-474c-99d5-f1c299711396	4	473.53	2025-09-25 15:49:21.360008+00
68c5aefd-d213-4e7a-96f6-509dfe53c698	7f676a50-1486-44ae-95d3-b223ab0ca9c5	6b8bae2b-61ba-4605-89bb-f68d26b660a8	2	256.07	2025-09-25 15:49:21.360008+00
8e9ecca5-3323-4903-ab87-82f03a27c41e	83760171-3ba4-4784-a5b9-989f166356d5	46de7031-f833-4bb7-922f-7012c0da4f14	4	336.55	2025-09-25 15:49:21.360008+00
8d3c30f6-a0f4-4237-ba82-92842c5d1e3d	cca06839-8936-4474-b9ce-9309b36ff30a	99e055ec-e67c-4dac-9f98-2d14cc4b759b	4	67.99	2025-09-25 15:49:21.360008+00
9239e0ca-79c3-4aff-837b-1d6ecc8b875a	5c41331a-7f4e-40ad-b284-eb3737b3a709	8e4f9281-4de2-4a32-8382-9889f1a24801	4	407.79	2025-09-25 15:49:21.360008+00
4db89bd6-a885-4f99-b183-65c6d7a7d045	57feceb2-4b87-4a89-aca7-1325f9705afa	356dbff0-728f-4cfb-81ca-1aba7a2422f9	3	14.58	2025-09-25 15:49:21.360008+00
c4319a30-a3c4-4a95-b7f3-e8d239288d29	6d7d0f2b-4e86-4b62-bf16-76cb84921825	a571ee56-1436-4637-a34b-39b35356e009	4	55.52	2025-09-25 15:49:21.360008+00
d62e59b9-c744-429b-8c18-aa067ff37775	0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	95fdab27-0aff-4ae3-af8b-3fcfc6220729	5	85.41	2025-09-25 15:49:21.360008+00
11dd3d86-c2e3-4345-8e96-31408c93a7d4	c99c3a55-5a02-4422-8bba-8ac5704961c3	f75153fb-81fd-4adc-bd1d-9bc21c5ace09	4	42.76	2025-09-25 15:49:21.360008+00
4f14ede2-9b9c-4c37-8e2e-4643d4baed3c	34f95a9f-4e7e-4ccd-8da9-a1b0f72ca2c7	aabe6af0-655e-4c8e-b995-b30e52c78100	2	28.82	2025-09-25 15:49:21.360008+00
f80bee1f-2a57-4abe-b097-0b428583d949	26d94299-b4a7-48f5-936e-c9975e12dd74	231463d4-4a25-4c91-97eb-a4d51817addd	4	401.31	2025-09-25 15:49:21.360008+00
c20f2214-0f74-40fb-b45b-3f41c233fb4e	c968da4d-d44c-4723-b372-c814d0be40c1	e9b4110e-ec56-4506-ba33-e895d567805e	5	74.12	2025-09-25 15:49:21.360008+00
bee3cc24-a937-43cc-90bc-d9c21b304d36	0285e8f8-4fa5-416a-9cbf-256b098026c5	efa90324-2240-43be-ab36-0a1bc0e32ce2	4	367.75	2025-09-25 15:49:21.360008+00
92e32380-8488-4747-abaf-7e37d8e06393	e1377f75-64b9-426b-87e8-d40f511170c2	52885168-97b2-4e13-93f8-92bd9dad7faa	2	179.70	2025-09-25 15:49:21.360008+00
be52434b-92b3-4f38-bf24-e14e45efa4f2	15b13006-4c56-4f21-9475-f3c5d7bfb52a	0c131e48-2bf1-402a-a2de-fb03d45a6173	3	16.46	2025-09-25 15:49:21.360008+00
57afa330-eda2-4afc-bde0-ceacd6989ae6	6ae5691a-d04a-4b0c-8233-8ff0f53ffd53	e8933d87-8ec8-424b-a393-c3fddbdf36d0	1	66.13	2025-09-25 15:49:21.360008+00
9b3a6575-cb7c-4cfe-856a-5c706a4c25ad	9ddf866a-c7b1-480c-b2cb-a95cccfa1293	c0e03395-6d27-423d-a275-ba997b04c267	2	499.85	2025-09-25 15:49:21.360008+00
1ad85976-eafe-413c-b932-a9ae7c5df2a0	aa564c03-b89f-4e26-819f-b348be96c1eb	2b794777-7b61-4a09-9156-dcf8248bda2a	5	265.95	2025-09-25 15:49:21.360008+00
c4be055f-11db-4156-9057-071be92fd436	e0ef9e43-0f15-4514-94bc-47922417f166	eb42357c-8d45-4b4d-a2c3-fb8a9678f4ec	2	171.48	2025-09-25 15:49:21.360008+00
dac17e5b-9b8e-4588-a433-947203e5fa8b	9a41cbce-2a8f-47d9-8994-ba5e8c985c14	8db519a9-5fcd-4378-bcb9-6d3ec9e2c114	2	158.99	2025-09-25 15:49:21.360008+00
2db90f3e-dadc-43d6-b459-42b023b7700a	6aaf8114-6b7e-433d-a650-c54005da2285	1f2f7bdb-175c-439a-b1a5-544fc834fcd1	5	319.48	2025-09-25 15:49:21.360008+00
f943289d-22c0-456a-a344-315df5f7826b	ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	80f50827-808f-4054-a4fa-e86b32d47e1e	2	140.49	2025-09-25 15:49:21.360008+00
fc1b729b-7bc1-496f-aa2d-c86a756ed1c6	bcb288fa-d037-4bb3-a5f3-90ad346ecc4c	49bf1177-bf4d-4d28-97b8-204c7ca33dd9	4	238.02	2025-09-25 15:49:21.360008+00
d3dd1b48-ef2e-4fa9-8c0a-36459289c5b8	b9e2ae9c-46f9-45ae-944a-955e3f9a4952	b345b1d6-afda-4064-82a3-8ada5c625990	2	307.32	2025-09-25 15:49:21.360008+00
da940a67-c039-4bb2-944c-d2bc0ac37cc5	29e75bea-4cb6-4bf0-8342-e2a00f220191	a18f19b4-8d9f-471e-8e85-ab00052d0514	4	354.66	2025-09-25 15:49:21.360008+00
efeeeed6-a40e-438e-a8c3-924e19d70e0e	52549fa7-0cbe-42b3-a714-11d46bfad8f4	af2a2d7d-edb0-49b2-ad2a-dfb0d68b822e	4	124.63	2025-09-25 15:49:21.360008+00
aeb1bba8-f79c-4f62-90ca-c19bfdd8c7b0	a8f1300e-9928-4a6c-87bb-88e67dc80007	5ed6762e-cc7c-447b-935a-7aa018a64ccf	1	431.92	2025-09-25 15:49:21.360008+00
271b62f2-4559-45a6-87f6-aa1d6334bd93	9c349870-4a91-4fac-b1c8-a59c6d9aea49	a5c886bb-dda2-447a-bcff-dd304e8e85f7	2	179.89	2025-09-25 15:49:21.360008+00
f29abb8c-ec45-442a-bdc8-52ecc18c5530	ad175f2e-c4bb-4146-8eca-265407645116	83868a37-56a6-4a61-80c8-e0b975371449	4	103.35	2025-09-25 15:49:21.360008+00
4111b3d3-1643-4357-854a-65a1416ef4f4	d489ffc3-d7f3-41ff-9c01-e7f67dac8933	89e83845-49f4-4dcb-be95-746a2504572e	1	139.95	2025-09-25 15:49:21.360008+00
07364a0f-802e-46c0-a75c-82a010f3c278	4942c836-17b6-4f00-b02b-588aed15e9d3	da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	4	164.37	2025-09-25 15:49:21.360008+00
4c655e80-de3e-410b-a6c9-11309b03a8ac	7a1bfb17-b859-4250-bf36-5ff26230b8fc	f676b696-78f3-4a4f-a04e-cfc9d92a2157	2	478.43	2025-09-25 15:49:21.360008+00
3727927c-702c-4e36-99b4-138442deab15	b3e3b19b-4095-4ade-ab42-48bcd45a84ad	21745193-9c4e-4249-b2a7-c93ff9c5bf58	5	413.34	2025-09-25 15:49:21.360008+00
aaff842a-ceb5-4883-b76d-544ccb1f3daa	81e3e409-d429-4a1a-b8f3-2e8e517dac57	02111b10-8e00-43a3-a82a-59b332d3cc77	3	72.60	2025-09-25 15:49:21.360008+00
71a2e047-76e5-460c-8375-7d58e7053394	bbdf2ae9-4f93-4611-a772-7d489eb29879	9f8a8d90-ea1b-4928-a2fa-135af6cc5301	5	220.21	2025-09-25 15:49:21.360008+00
8cc3699e-c397-4a8d-9868-22a5033bbef9	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	280697f2-83ef-479f-a96a-fefcd055b0be	5	498.98	2025-09-25 15:49:21.360008+00
d2527ff3-20d8-44d3-ac50-51d6b5787d96	d94e1b98-75f7-4be4-8e3a-ef61e09030ea	c20bb299-4a8b-49fa-b2a5-09b6309c23d4	2	373.29	2025-09-25 15:49:21.360008+00
034bb6e9-4588-4718-a17e-c1d0eb90d30e	859c6dcb-2d8f-424a-914c-e2f8990acdf2	3b876e1c-0a67-4b21-b70f-910f190ea31b	1	459.55	2025-09-25 15:49:21.360008+00
affe6a24-93ca-444b-877b-e625384603aa	a662f649-8a61-4f87-9685-bf4512d21b37	16c44ce4-e115-4b39-b307-78c786711eb1	4	164.16	2025-09-25 15:49:21.360008+00
9075c79f-3bd6-45cc-ae8d-800ceec7eed4	e4c5f085-7c50-4767-ae55-f27b0095ca5a	75384ea9-6d1f-49c3-8160-2c15639917c5	5	273.07	2025-09-25 15:49:21.360008+00
79d8b2ba-79c7-4b23-a946-bef39fb406dc	75574235-ca38-4468-9173-6c13e625a703	69bb44de-94a8-4d30-b00b-0761bd1538e1	4	42.41	2025-09-25 15:49:21.360008+00
1fa437e8-3172-417f-b453-1d9b20c0aef4	a27f5718-7e62-41fa-bcfb-f245f7e6c4f8	1ab30713-5e7d-46de-b29b-b022a593b830	1	173.30	2025-09-25 15:49:21.360008+00
06f1435f-889a-4541-a281-70409d49d43a	c968da4d-d44c-4723-b372-c814d0be40c1	1cfda4fa-aaa5-40b7-a4f5-30a6ee857a5a	1	54.38	2025-09-25 15:49:21.360008+00
b27f6076-ba6a-457d-96e1-289307ce00a7	cc1c0fe4-871d-42f3-aecd-3606874ffa5d	a78bcf16-ef7c-4b5e-a7cc-b77d0c780c2a	5	439.37	2025-09-25 15:49:21.360008+00
8c987df0-e7e5-4525-8353-29704c5df735	7ee6fea3-ff9f-42e6-bb41-9367c3fb6a84	59c60900-03b7-4a16-a338-f731470e8ec7	2	238.96	2025-09-25 15:49:21.360008+00
142393dd-90a5-4b86-a7bc-dba6f5ad1144	42e0c51d-7b30-48be-b03e-71802fc7811f	1c904265-71c1-40c9-8dcf-faa1f9f075e1	4	348.41	2025-09-25 15:49:21.360008+00
f5ba0820-2c9e-464f-9557-ee11f3afccb2	fc35a6e0-5c19-49dd-9ce8-59732d670e5c	235995d2-8eef-44fa-b69f-6db5f284b312	5	87.66	2025-09-25 15:49:21.360008+00
9f8217a1-e5de-4d5c-ac2c-21fdbc1412d2	6882d9a4-73a3-4f7f-8fe6-120bb76a1dcb	676fcc0d-3c5e-497d-b57f-ee8fabfa95c8	5	51.15	2025-09-25 15:49:21.360008+00
d5638880-37c3-447e-bd1e-368320d3ab5b	6fc62102-14fa-46c8-be9b-cf3935b4f0ae	cda83ed8-2806-4857-9275-256a46e498b4	1	42.06	2025-09-25 15:49:21.360008+00
27251ec0-fcc9-4402-aa4c-48e173a270d7	c14adf70-0385-4c05-958d-e07e8154e2c7	d92462f4-d0f9-45cc-a17e-8a0abc992ccf	2	252.66	2025-09-25 15:49:21.360008+00
f3484868-db86-46b5-a9ca-3a1537b9c8f3	0f9d7535-a266-421b-8111-2ba46b2803ac	bacacba7-76a9-4d09-ab72-f08a18504d23	4	222.12	2025-09-25 15:49:21.360008+00
4869766a-3bf1-4be6-a449-0f5d57afe75f	05639713-2fc1-4653-991a-6e7b6fb6963d	9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	4	480.41	2025-09-25 15:49:21.360008+00
5d81d226-afed-4079-aacf-3d049065e12c	dafb0045-c051-4e3a-b5b0-87b09fe3034e	48f91275-5780-4023-818b-f9de6a4d7001	1	426.12	2025-09-25 15:49:21.360008+00
7211a9a9-1478-4592-a064-3857cc5e6927	49a8611c-52f8-4199-9cd9-8147c287f45e	80206439-d96d-46cb-8d18-d06baf05ea36	3	55.34	2025-09-25 15:49:21.360008+00
1805e3fb-e9c7-400f-ad6d-7d89c66720f5	79c6078f-0f81-43e0-9642-90e4a872edaf	a229c4d3-5500-41e4-ab2b-36898ec53778	2	145.91	2025-09-25 15:49:21.360008+00
368f95fd-6c67-42e8-845a-e158a8ed9e05	94616eca-5069-4a67-a50c-a0e30b58ea7f	f2c97c44-10eb-4bf2-b021-d6806ada9794	4	115.79	2025-09-25 15:49:21.360008+00
a321878d-9bc9-4366-9dfb-fb7ad17a08e9	c0b3ffb5-4ee4-434d-a99a-8290e08c4562	5e589f6d-f0bf-4873-a301-dc0a4193bd86	1	144.69	2025-09-25 15:49:21.360008+00
d035763e-92f8-4607-805d-a6c08808ac27	80277854-2b1a-4543-b441-c5280a2768c9	1a747b45-a898-4f93-b6cf-e58f4fd2774d	3	371.55	2025-09-25 15:49:21.360008+00
4f7887da-e217-4df0-b3ee-fe5b843983b9	59d98d0b-7e79-4710-833c-9b90ff83b1c9	ef112dbd-c95f-4e0e-b1a2-d607ddf164b6	5	363.47	2025-09-25 15:49:21.360008+00
19d05c0c-1ddf-4dfc-aee4-36ad5c97f516	a1963124-0e73-4dcf-8487-9e22573e91fe	1e02cd6f-7165-4c24-a21d-17bde6de0cf5	5	416.72	2025-09-25 15:49:21.360008+00
3b26d256-27f6-4ac0-8d46-4ed8b1f2b4e2	efdfbab8-034d-42de-97fc-e0807909bb0d	6631f6a7-c5b2-418a-a2a7-23c2d463ed73	5	160.36	2025-09-25 15:49:21.360008+00
db1455a7-05f1-4819-b328-64800281cb8b	47d04618-8428-4f32-bf9d-b7b282613d88	a7357a6b-eb1f-4536-be65-b678cb076d9f	4	324.86	2025-09-25 15:49:21.360008+00
f0320dab-3ee4-4287-b6e9-1c8ee33ed2d5	3b72660b-c141-4949-9a58-1991db90bf7d	3470c7b1-d741-413f-858d-d49c2ab0dac2	3	480.58	2025-09-25 15:49:21.360008+00
cce9af3f-f107-4203-a659-6c7cb75fa3bb	180172de-af0b-4c91-8f84-2568a026fea8	099f686d-67fa-45f9-b8e4-b580e59670d4	1	249.37	2025-09-25 15:49:21.360008+00
6accf710-1447-4ddc-a9ee-2239633ac486	1f0966e0-81ed-436c-abb8-a2767d522dd5	a27d5cef-fa30-49a2-b338-b63c4ed23a9a	1	154.28	2025-09-25 15:49:21.360008+00
8ff1bf4a-b1a4-4b0a-acbe-5b699a186e78	987edebe-d35c-419a-b283-24996973dceb	f9801d3d-63f3-4956-898f-40dde6d01e9e	3	395.08	2025-09-25 15:49:21.360008+00
ed68a37a-f1a4-4226-9710-72a00290ca01	6be97509-6f0b-4c4f-8e6a-b27529c67133	5b2376e3-ced5-47e6-b110-771f51287033	3	207.52	2025-09-25 15:49:21.360008+00
f2ae1cbb-c142-4a73-b62b-8782aebb18b7	17696562-545d-411b-96ac-553be0bd74d6	41f0863c-9837-4832-a26b-d2b73aa5a262	4	245.54	2025-09-25 15:49:21.360008+00
20c89930-d981-47bf-bc6b-8bb98dc604ef	5079071f-a132-45a2-bd5a-34450f07a36c	be6e3ada-368c-4173-9e73-fc99f2d5b20e	3	38.16	2025-09-25 15:49:21.360008+00
6e70deb0-fdaf-486f-a35a-09d413a960e4	7470174d-b026-4646-a890-96d13435d6a2	fd48c418-c44d-4293-95bc-1585c54fe71f	2	90.62	2025-09-25 15:49:21.360008+00
92224cfc-1bcb-4178-bb37-4b41109fa2ab	c9c94223-2df3-4066-86e1-444b6a2ab4ee	1c0fdf1c-7dd6-4ff2-9bc3-59f2e01f1e28	2	467.40	2025-09-25 15:49:21.360008+00
dfe8d069-6208-4c89-bc94-6e2b12f824fc	b8bd434b-b2d4-4b4a-b989-5dce929672d1	38bfd2dc-08ec-44ff-a005-76aa7ad2ed61	3	347.64	2025-09-25 15:49:21.360008+00
d031bdec-9932-41e0-b3f4-3926438765e8	4942c836-17b6-4f00-b02b-588aed15e9d3	d2e095fc-f2ff-4502-8c47-01b10d503f0d	2	357.79	2025-09-25 15:49:21.360008+00
4f9a1511-aef4-4982-bbfd-e893956edcdb	9d403877-bd83-4049-a5c0-ec93f95f6973	d41c977d-bf05-49a6-b419-0b7496f86f41	1	423.92	2025-09-25 15:49:21.360008+00
abcb08ca-3e6c-4926-8d66-215f05755a05	42e0c51d-7b30-48be-b03e-71802fc7811f	e3f360dc-ca43-4d24-9063-8c9734ff9178	4	295.95	2025-09-25 15:49:21.360008+00
746a3fbf-63bd-45b1-8521-ab2be4b36ec9	b051b1d6-9890-4e79-9dc1-f79c967fc9f9	1d32f141-7b63-4c15-b4a6-8167d6ddf351	3	43.28	2025-09-25 15:49:21.360008+00
81386e15-fe3e-45e6-9a9a-c7bd0211fe63	7374c864-9ec5-422b-9cea-44cc4b946383	34c0124e-60b7-4ffa-ab69-1f879796474f	5	34.61	2025-09-25 15:49:21.360008+00
122d5d5e-ac61-4738-aa90-01718272db27	0285e8f8-4fa5-416a-9cbf-256b098026c5	f123ec31-3ce7-408d-87d0-72098804ee24	2	367.13	2025-09-25 15:49:21.360008+00
e779726a-d2a9-45fc-958f-cb5aaf77a488	211ce5a1-1e43-42ee-afd4-5f0de060e8e1	8a192d62-1b31-4c1c-8e89-5e3a96d90e33	5	394.36	2025-09-25 15:49:21.360008+00
a77994b4-4494-4c22-89db-d5e276bf00e2	485de802-4452-4547-8511-26b2526e13ff	628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	2	438.31	2025-09-25 15:49:21.360008+00
f79db0ae-b668-414f-8fff-12f8d9a65926	e897f67d-f5e7-45a0-804e-317267bb99e8	118237ca-4fcc-4611-aee1-1b5aa4c094fa	5	235.10	2025-09-25 15:49:21.360008+00
3cefd4e1-645d-4976-9d5c-395f7f1d845c	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	3aa4c585-7e17-4118-b80e-cbee745cd4d6	2	262.36	2025-09-25 15:49:21.360008+00
b93eea30-12dc-4b18-824c-8a93f5dfaa17	8ed1beb2-62b8-47b4-8d1d-2dee28ca32fa	3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	5	303.37	2025-09-25 15:49:21.360008+00
a017880b-0f57-439b-9132-4f47637cc263	e7af09a0-4128-438c-8b0c-fd71bf4172de	00e4225a-d885-4cd7-ae38-e8ab0073616d	3	197.63	2025-09-25 15:49:21.360008+00
63e47f09-13dd-414e-a9bc-7a253cffcc3f	d6a0a1ac-417e-41e1-96e6-061a85cec67a	254d53f1-8fa1-41e8-9dd2-3e5ad086ddf8	5	42.02	2025-09-25 15:49:21.360008+00
389b5514-b9b3-45bb-8a56-78efff660d90	188ba3fb-b338-4cc0-b018-e1fe625804b2	7e1bb644-625c-48c5-ab0e-19ba4af3b7ac	4	437.89	2025-09-25 15:49:21.360008+00
d8bc83fb-30a6-4da8-94c4-9d2a6b607e30	100bf38b-7961-4a14-8746-7bc493e66fdb	739f522a-3f63-4043-8992-f2cb9ba02109	1	217.61	2025-09-25 15:49:21.360008+00
ae2e1710-8c26-42c3-bacf-78068114ec3d	d9b325cd-29c7-44e6-a1dc-039aba44e40b	9177a11d-1cef-401d-a853-7448a708bdc7	3	392.86	2025-09-25 15:49:21.360008+00
08e798ad-bf5c-4ef3-b12d-f4127200976c	c7be5263-3b3a-450a-a207-2b7d1c69729c	51ff9784-c1f5-4cb9-8ebd-612344e73ade	3	398.35	2025-09-25 15:49:21.360008+00
4b9efa29-f5ae-4843-92ff-cbd1853b54f8	6aaf8114-6b7e-433d-a650-c54005da2285	719993bf-3a56-4afe-b749-4954fe4ab27f	5	351.39	2025-09-25 15:49:21.360008+00
705c46bd-82fc-4828-8443-03e13534434c	efdfbab8-034d-42de-97fc-e0807909bb0d	5dc3359a-848a-41ea-8c69-28e6e255ddc0	4	7.67	2025-09-25 15:49:21.360008+00
55e3a711-e481-4447-aef7-2dab51bdefaf	3deb824a-cf6b-45b3-b5f9-819dbaeb3eb4	13404922-32d4-4b7b-93fe-08f504436a82	3	28.37	2025-09-25 15:49:21.360008+00
eb4c634b-200b-4801-ba1a-9a18e08c7a84	30bbe271-3b24-46e7-8cf9-1b29360fbd83	0a866c4a-8b4b-407b-9eee-d41b65767b6a	5	101.79	2025-09-25 15:49:21.360008+00
d63dc75f-7d51-4ac0-913b-b837c1c261c0	b0f8fa2c-f1a8-4a95-9fe2-1008c62694e1	caa6bc73-fb21-4bad-8f74-611730b8ed99	4	469.83	2025-09-25 15:49:21.360008+00
48ded3c2-6219-4e9d-b04d-7c4f942c0c2d	45a00a80-5f66-4221-aa82-5a7d75d997b9	ca326115-3c26-4311-9daf-04c1954c2538	1	187.24	2025-09-25 15:49:21.360008+00
796d55d1-807b-4a5c-8d08-5dcc09f090c3	d489ffc3-d7f3-41ff-9c01-e7f67dac8933	d5cb6d47-534e-4b1d-b339-c34315876121	5	139.69	2025-09-25 15:49:21.360008+00
8bcab6a5-79ed-472a-af23-282044b71ca6	2f835276-86b6-4d57-a13f-c8850e3c1655	b0636ba5-8172-44fa-814e-56fd191ed72c	4	71.44	2025-09-25 15:49:21.360008+00
3498ea9e-5ed7-427d-a57c-4a175b7275b3	5c773ac9-d046-4afd-8ebd-8b75f756976b	866ec54f-443e-4ee7-a605-619c43c6a6ac	1	216.63	2025-09-25 15:49:21.360008+00
5899e4eb-b77d-4956-b542-65012c0a0161	8b6a006f-45e5-426b-b53b-83a6496c83d3	1e02cd6f-7165-4c24-a21d-17bde6de0cf5	2	329.06	2025-09-25 15:49:21.360008+00
3ecc4514-4345-4378-9912-d90f9fe7c9de	26f6f110-f310-49d5-a742-3d58af2fdfcf	e2f787f5-e9af-445e-82fb-c82755ad983a	2	149.03	2025-09-25 15:49:21.360008+00
87eceaee-f11f-4e4b-b243-d9062380c6de	4942c836-17b6-4f00-b02b-588aed15e9d3	ff7620ed-ed9a-4893-9cd1-10e78696e6c4	2	280.55	2025-09-25 15:49:21.360008+00
44e65a06-c8f4-4dce-8166-02d919d6c087	123604ff-db0e-49e2-8195-f688783fa74b	d2e095fc-f2ff-4502-8c47-01b10d503f0d	4	249.42	2025-09-25 15:49:21.360008+00
8a34d0f6-b1d0-41c6-aff1-80a8e1cf9d82	5b7cef35-0333-432c-a41c-3355e75747f2	e06ca0c3-73d9-49e0-a5c6-d52ebd6153c4	1	152.38	2025-09-25 15:49:21.360008+00
fe134ebd-ac5b-4162-9aea-78a08bbf4d5a	34f95a9f-4e7e-4ccd-8da9-a1b0f72ca2c7	fdd2b008-7d68-4b62-9177-d946e5761288	1	461.46	2025-09-25 15:49:21.360008+00
76b5a283-0194-48dc-8303-b42a58137f02	a6aabe72-0dbe-4ee6-9d9d-a0251eadb3d6	e07fe63a-e903-4360-852d-300a8cd9e1db	5	23.32	2025-09-25 15:49:21.360008+00
ed6fe066-697b-4b76-979f-3dcdc986338b	7f522f6d-a40e-4b9a-bd19-bf36c9955f27	1a747b45-a898-4f93-b6cf-e58f4fd2774d	2	277.06	2025-09-25 15:49:21.360008+00
3e9984ad-7545-4674-b03c-d0721b4f8ace	c14adf70-0385-4c05-958d-e07e8154e2c7	43eda1a7-ba23-4a06-b41d-f95a25e9f91a	5	213.66	2025-09-25 15:49:21.360008+00
9c6f8150-43ee-4076-9412-a861e816d624	d4c1ef8a-7751-488e-8f5f-deb7d506d960	6631f6a7-c5b2-418a-a2a7-23c2d463ed73	1	74.54	2025-09-25 15:49:21.360008+00
2a064cae-b821-461e-84f0-7a6f7f228cc0	78ec1831-3694-4677-9a36-284665600143	910a812d-0b9f-4e71-b753-a74d93721c7d	3	327.75	2025-09-25 15:49:21.360008+00
2c9eedf8-c58c-4d9d-ae6a-1a3f3edc5c50	88208539-9376-4877-ae9b-8071dc1d8d98	1c16adca-43ef-4fc3-8e3b-115e636fc6b4	5	488.06	2025-09-25 15:49:21.360008+00
0439d7ae-db99-4ee5-9753-32f49ff0cc50	ab0163d0-e99d-4b45-b6ed-256da0ac008e	7bb56b0c-494a-4fcc-ba6d-48ba50313e6d	4	418.26	2025-09-25 15:49:21.360008+00
9dbcb134-a225-4adf-af38-270c36e37349	859c6dcb-2d8f-424a-914c-e2f8990acdf2	50d5fe28-104c-4636-a8d3-478901f022be	5	235.93	2025-09-25 15:49:21.360008+00
c0f296e9-b2df-4584-8fba-9ed3909b0669	7a0e8803-b665-46d2-a9f5-79297739c1e6	3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	2	446.46	2025-09-25 15:49:21.360008+00
04ddbeb4-f556-4ff7-ba32-557666a1b2c2	49a53a47-96c0-4d2e-9c20-d187ea1fa421	f33cdff5-133d-48ba-9442-c3f1f0b84bdf	4	390.00	2025-09-25 15:49:21.360008+00
33f106a6-07a8-40c6-bbb3-4e4c60edf50e	86af1dd3-a30b-4006-9b43-2c16f5a09fcf	3470c7b1-d741-413f-858d-d49c2ab0dac2	2	11.73	2025-09-25 15:49:21.360008+00
768884da-cbed-443a-a7be-e86773d0824a	c2a449db-0250-418d-bcb4-fb0cf9cea4d5	d2257e19-50a7-4ec5-833b-8fb0c0ab54db	3	312.78	2025-09-25 15:49:21.360008+00
2a1c4efa-b7d4-459a-a9da-bebfa90ef4b2	26204835-dcc2-4a79-9c9d-3cd38271fcea	21f0cd0b-99e5-4271-9545-9bb8ee47a8d5	1	333.65	2025-09-25 15:49:21.360008+00
9e8821b6-e8cc-4d8f-a335-7a0c70f65551	6f3219d0-334c-4813-984d-8a1daace382c	27e2e9a6-1d22-41c0-976d-dc7ffc253d4e	2	254.83	2025-09-25 15:49:21.360008+00
80a3122f-e369-419c-9a34-31748a867a22	485de802-4452-4547-8511-26b2526e13ff	7f72cfc7-633d-4d9f-a31e-e0424be358fb	5	493.10	2025-09-25 15:49:21.360008+00
272c336f-b817-4d0d-9694-9360e61721f5	9aa91f21-3a06-4000-b2ea-006f267cc7c4	64c6dfed-e411-4eb9-a9ed-bccfba268180	5	219.38	2025-09-25 15:49:21.360008+00
59081924-f733-48fa-bb09-581b453c173a	503e4f9c-9308-4ebc-afca-553d4b11ecce	c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	1	309.98	2025-09-25 15:49:21.360008+00
27601411-700e-4fad-86fb-d65b2bb3d6a2	21712398-44ef-4649-81cb-1d4a791df344	26ef9482-13ef-447d-8705-626db164f85a	5	388.79	2025-09-25 15:49:21.360008+00
567c89b7-0f10-4c14-98ef-bb496fdea4f3	e1377f75-64b9-426b-87e8-d40f511170c2	57173183-c9d3-4b5a-a453-7eb01e33ad65	3	251.99	2025-09-25 15:49:21.360008+00
93a912b2-ddec-4730-b663-61e763582130	04b226bb-5169-486d-ad2e-26a3f3c277bb	a009fa16-adc5-4dff-aef0-33eab2015e8e	3	366.47	2025-09-25 15:49:21.360008+00
043cc0be-b984-4d59-a705-0ebb8906af21	ff6fed51-72b2-4a19-9cbc-6861c66aee8a	623359cd-90ee-44dc-add9-ec00f7428b85	2	458.02	2025-09-25 15:49:21.360008+00
0a5bfcf1-37c7-4427-836a-e88b8760eb55	ad175f2e-c4bb-4146-8eca-265407645116	c51d890d-f207-44ea-9d04-c039cf3d6dd5	4	180.09	2025-09-25 15:49:21.360008+00
3adaf871-07c0-4472-bdbf-d7563ce39f28	d03d2567-bc3b-46a2-b2ee-11b8b8523357	a4ca9a09-1447-4df1-a3f4-4b5a8cc4321f	1	136.18	2025-09-25 15:49:21.360008+00
f3708292-b5db-44d9-8e97-f23e0e53fb7c	104b98ef-d1ca-4281-9cdc-0cccad91ffce	a338d9bb-090f-49ae-9ff7-d117060b57b6	5	134.09	2025-09-25 15:49:21.360008+00
7f0605c2-df38-4d1a-8f49-06494220cc05	150fc2ed-e9ed-40a6-8a63-901228df41ba	8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	3	436.01	2025-09-25 15:49:21.360008+00
c453a971-fec6-444b-b572-965bf426737c	8b6a006f-45e5-426b-b53b-83a6496c83d3	b4c7bf0d-33c0-444b-a161-17722da12c53	2	200.90	2025-09-25 15:49:21.360008+00
d7df3c2e-d253-4d8d-b79c-a36e0ecc5ae4	86860fb8-6f26-4f28-9be8-276d06c16b8a	a8ae8cf4-1975-4e07-a6d3-104867375a8e	1	109.60	2025-09-25 15:49:21.360008+00
592f2e5a-b987-4d84-8cbe-aa6f00772f16	4ee52527-2803-491c-be99-3ed35efa903d	bc71e17f-bff7-4ef4-bfc0-3c53fa41cad1	3	43.02	2025-09-25 15:49:21.360008+00
80bff431-6f6e-4ca6-a614-70f854d7f42f	78ec1831-3694-4677-9a36-284665600143	474e2fa1-db3a-4a18-9525-ee013d90e4a3	2	425.71	2025-09-25 15:49:21.360008+00
30c947b5-99c8-4497-b869-125ae8470a36	a27f5718-7e62-41fa-bcfb-f245f7e6c4f8	9d108fa9-0eda-4747-847c-2557ebd3e468	5	231.03	2025-09-25 15:49:21.360008+00
48038e09-de8e-455c-9f9a-d3c96a221405	3a9ce289-a876-4e46-835a-e120989c8652	75384ea9-6d1f-49c3-8160-2c15639917c5	3	132.66	2025-09-25 15:49:21.360008+00
34b40c08-edce-4838-81e3-278d29737421	b0f8fa2c-f1a8-4a95-9fe2-1008c62694e1	075b7006-b602-4ea0-a2ee-4b07f65960ed	3	489.26	2025-09-25 15:49:21.360008+00
b994e40d-5359-4278-9c59-72cedbfd7480	45f0653b-a445-47a4-acc9-e13231abb0b7	862d4d17-b20e-43c0-b32d-77c7cba5aa2f	5	315.60	2025-09-25 15:49:21.360008+00
d3240b2b-f3a8-4a28-9dd2-8fe13d46064a	41af7684-234f-4c36-93d9-550f6dec9dd7	c57dcd86-44c2-475c-a8e2-8fa7ce846554	4	488.55	2025-09-25 15:49:21.360008+00
ebef6f19-5511-4e9e-973d-851c21c86a03	94616eca-5069-4a67-a50c-a0e30b58ea7f	f3c60162-6f84-46c1-8a02-a4e9649cfc51	2	118.31	2025-09-25 15:49:21.360008+00
919b1cfd-b721-4b4b-a450-5a12b52560e3	4cd05a47-7bfb-45f3-9142-0cb00b39f08f	119ef357-5ee0-4d30-b76e-a0904ed0c28c	2	494.78	2025-09-25 15:49:21.360008+00
6005c56c-7520-4e9c-80fc-f26065ae672d	c1e0cd9b-4de7-4253-b09c-2fb7299fb30d	623359cd-90ee-44dc-add9-ec00f7428b85	2	150.53	2025-09-25 15:49:21.360008+00
6d277609-996c-4e17-926f-a4f4569d1d89	90e77639-78b7-49b1-897b-12d578024a7b	856d5eca-a8d9-4b7b-bf5b-5503dccb7afd	3	109.71	2025-09-25 15:49:21.360008+00
01777636-9f19-4052-bb2f-36705850af8c	a1963124-0e73-4dcf-8487-9e22573e91fe	46f455c8-0f16-48a5-81ba-5ec3954da241	1	156.87	2025-09-25 15:49:21.360008+00
94801d1d-dc86-43f5-a1b2-9fd3b33e6d80	188ba3fb-b338-4cc0-b018-e1fe625804b2	0f0ff4ee-abfb-4c21-b535-c5dbe857dc12	4	415.35	2025-09-25 15:49:21.360008+00
6409210f-841b-46bb-a35d-258a0f8f746e	96add786-acb1-4407-b0de-3843ac033a4c	923c943d-497e-48e3-b9e4-7c33df1370c6	5	172.41	2025-09-25 15:49:21.360008+00
9af1b33b-5616-43e5-9bce-9a6c02c7bc9e	646020f9-385d-48af-99f8-1d1c6849ca2e	39d35def-0cac-4a8b-9ba5-89d172693cc0	3	191.65	2025-09-25 15:49:21.360008+00
0d77bd74-f893-4950-8743-6fb4ccb90dae	9aa91f21-3a06-4000-b2ea-006f267cc7c4	61136316-3e66-423b-aab2-90168b427076	2	208.76	2025-09-25 15:49:21.360008+00
2460839e-3e0d-48d6-b140-24db9f588633	e897f67d-f5e7-45a0-804e-317267bb99e8	2a77af69-7b2e-457e-b894-8e07457c8007	4	323.42	2025-09-25 15:49:21.360008+00
f92a4344-e6d0-48d4-8537-3f19af90bafd	c3c934db-f8c9-47be-8b8c-fd7ee1156937	94d5fd54-f886-4df1-afe2-7840ea858b5a	4	233.93	2025-09-25 15:49:21.360008+00
a5d75884-8fb6-4da4-961b-6edabab23daa	192db6a0-59c5-47b1-83e1-364a3d165fea	ed12393f-ed39-4a41-aa7e-68085036adc9	4	367.54	2025-09-25 15:49:21.360008+00
6a90eb48-1564-494a-90fd-a2582f35d38f	1fc8a267-77bd-4aa5-96c6-4846794fae29	0be61747-18b4-4024-9b9d-6066bd9939a5	5	290.30	2025-09-25 15:49:21.360008+00
5ad00591-84e6-4cb4-8968-a8a20c2c6847	272b6776-dddf-4ab4-ac22-a81e85805712	8bc1489d-cd37-4ab3-ad35-fb2e2565255b	2	147.13	2025-09-25 15:49:21.360008+00
6c0b9d51-855a-4ca1-af4b-c1b8afe36a12	d4c1ef8a-7751-488e-8f5f-deb7d506d960	7ee24945-3399-4dcb-838f-a9c7cdf6010d	4	61.12	2025-09-25 15:49:21.360008+00
f7ff4640-4860-4ec9-969f-70800fd5b52c	0f9d7535-a266-421b-8111-2ba46b2803ac	a009fa16-adc5-4dff-aef0-33eab2015e8e	3	204.71	2025-09-25 15:49:21.360008+00
f7f43888-0209-4020-952e-521e5ccd8404	8193f4c2-47fc-41ff-989b-cd23b36c3374	87f44895-4e30-42ac-bf6d-d4b3b1a7a68e	4	236.78	2025-09-25 15:49:21.360008+00
ff0e075b-3443-4285-bd17-8ff9a46fba2b	15b13006-4c56-4f21-9475-f3c5d7bfb52a	268710b5-2300-4548-bad1-47513dbf13d0	4	364.23	2025-09-25 15:49:21.360008+00
de0ed83d-fa6c-4c13-a22d-7d97e06e19e2	09810df9-2d0e-46f7-b38c-8258e166d908	edaedf56-d5e6-4471-90df-e6cf1e028976	5	274.56	2025-09-25 15:49:21.360008+00
b7b94de0-65e5-4d9e-be1b-0f702524466e	b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	cacd951b-2ee2-45d8-bff8-f3d08498e804	4	426.33	2025-09-25 15:49:21.360008+00
3b677051-30d7-4f1b-909e-1f120f81a2cf	dff49b1c-3584-4537-b0a3-39b63729570a	18d31cbe-f902-4211-b855-a8199875a0d1	1	246.67	2025-09-25 15:49:21.360008+00
c22ec30a-45a5-4a76-902e-5fc46e2777c1	9208a3c5-c409-4c66-ac38-5d24f4798a1e	c6975f71-dc00-421c-8c3c-b52c125afc91	4	183.67	2025-09-25 15:49:21.360008+00
e51388a0-d71a-4c7b-aa70-39714f0f9fe6	c9c94223-2df3-4066-86e1-444b6a2ab4ee	07bd80db-59c8-4656-9564-d5f2910712ea	5	187.51	2025-09-25 15:49:21.360008+00
a3755378-b6aa-487d-bf11-09576fd37deb	72326bc6-8625-4cc8-a771-f05af5bf0276	329ef81a-ddb7-4583-a1e6-3088e1132d02	5	186.52	2025-09-25 15:49:21.360008+00
13df8215-6ef4-43eb-8401-4f12829f70f4	2f835276-86b6-4d57-a13f-c8850e3c1655	1445e51c-61bd-4bba-84ee-22b3d6034aa6	5	312.86	2025-09-25 15:49:21.360008+00
de1c283e-eed4-4606-b941-fb377b898289	d3f139c5-20f0-4814-9d64-89d703cbf5d1	c02cd2ff-f382-4b9e-83ae-c2efb8204954	2	122.37	2025-09-25 15:49:21.360008+00
dbd280a0-466d-4171-8116-7d464ee24db1	30bbe271-3b24-46e7-8cf9-1b29360fbd83	dfe4ce16-3d38-4433-87d9-a7e802c74f40	1	272.84	2025-09-25 15:49:21.360008+00
cd5dbde5-fc8c-4e85-8130-a7e4f949bb26	dd1f1551-f4d3-40b3-9887-780273c7d8c4	08de722c-d87c-4a2a-938d-ede6bc53253c	2	271.80	2025-09-25 15:49:21.360008+00
b55bea39-e756-4780-a3da-5d2f2fc75f87	0dd73ff2-8ea2-458a-b8c5-af6d8bb93776	4d7420ea-af38-45e4-ba7b-983666b7a631	2	268.74	2025-09-25 15:49:21.360008+00
bb5b5242-765d-438a-9617-f8d1c068cfdd	ff6fed51-72b2-4a19-9cbc-6861c66aee8a	e3024b67-ea1c-4c79-bb7c-25b66e152003	5	299.40	2025-09-25 15:49:21.360008+00
344d99e7-d2b0-4adf-890c-b5c9096329ca	a662f649-8a61-4f87-9685-bf4512d21b37	21f89511-0b73-453d-90e5-5259485a5afe	3	289.84	2025-09-25 15:49:21.360008+00
c63e483d-36d3-4bda-bd7d-c0cd373e2824	c1e0cd9b-4de7-4253-b09c-2fb7299fb30d	5c911ffd-8f0f-4b09-9325-70e6270c87af	3	309.21	2025-09-25 15:49:21.360008+00
54af6116-ef11-4f1f-a0be-2ece1e839356	1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	198cd3a7-9f2a-493a-8d28-781f30037bd0	1	229.17	2025-09-25 15:49:21.360008+00
477e91af-03c8-48b8-a68d-4448d3333602	7374c864-9ec5-422b-9cea-44cc4b946383	884e381f-f04b-4179-a918-804407cdc849	1	395.64	2025-09-25 15:49:21.360008+00
b78ef20b-dc6c-4ae6-83d3-6ab2b1e1d957	c7be5263-3b3a-450a-a207-2b7d1c69729c	9177a11d-1cef-401d-a853-7448a708bdc7	4	8.67	2025-09-25 15:49:21.360008+00
8e5c7c66-2e12-4746-bb87-18fac93561a4	75574235-ca38-4468-9173-6c13e625a703	72c06a77-f84c-4691-bba7-23b68c7562d9	3	287.31	2025-09-25 15:49:21.360008+00
eb08da2d-5973-421b-bbce-f0934836afc8	7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	16b6747b-3732-453b-8e4a-9f967ad763f5	3	275.71	2025-09-25 15:49:21.360008+00
b46b3d17-593a-4fcf-bc06-e8e38ecd4a1e	88208539-9376-4877-ae9b-8071dc1d8d98	f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	3	287.36	2025-09-25 15:49:21.360008+00
8e5fb968-e365-4cee-90e6-18f6254f4a49	3b72660b-c141-4949-9a58-1991db90bf7d	6d33ee77-15a3-44b5-ac00-0f3fc0a4dd6c	2	208.72	2025-09-25 15:49:21.360008+00
0f87663a-b291-4c4e-81ec-64f6620d2f63	c2a449db-0250-418d-bcb4-fb0cf9cea4d5	5b2376e3-ced5-47e6-b110-771f51287033	2	369.83	2025-09-25 15:49:21.360008+00
72dafac1-1be4-4aa1-ae94-c4a9e1becdf7	de729129-ee71-4d4f-86b1-2b9f6413b383	f5df4c23-eb63-4b9a-9208-0389662dd022	3	179.04	2025-09-25 15:49:21.360008+00
9868c7f6-bd35-4e20-9304-9f43f932f81b	7856bf5b-2c19-43d8-b299-88d269f0b82d	e221f6ee-14c9-4737-9dd7-049752f4aac6	2	252.63	2025-09-25 15:49:21.360008+00
88ebd955-454e-4182-a466-e5101d142049	41af7684-234f-4c36-93d9-550f6dec9dd7	6254c18f-5485-43a5-98fb-2e85e1a91afe	5	55.26	2025-09-25 15:49:21.360008+00
b6a0019a-3902-489d-a3fa-b2d0845f56b4	2f96352c-3501-43dd-81f6-53aac41f6fb4	bae15f80-741c-488a-8c41-d76ab1913368	4	444.50	2025-09-25 15:49:21.360008+00
a1de62e3-5915-4f5a-ad70-a00349d94c7f	bbdf2ae9-4f93-4611-a772-7d489eb29879	fc1caf36-2718-44db-bf7c-deea57dde18f	3	335.70	2025-09-25 15:49:21.360008+00
47b0d2e6-4900-4bac-a88f-729b67ba5693	5db9bcf5-30f4-42a7-94e9-d0ff04c9ce83	7a4e99c7-87df-4c6e-bbb2-2f181600c5b4	5	353.59	2025-09-25 15:49:21.360008+00
74008bf0-34d7-46e0-b012-e036f1467677	6222f2d2-7dca-4536-a261-64aafcb4a1c8	2c94525c-a26e-44d5-b79e-9a20f90959d6	3	412.38	2025-09-25 15:49:21.360008+00
d4e69494-6e4c-4636-a7e9-fd774707eb20	e897f67d-f5e7-45a0-804e-317267bb99e8	d82a8dd3-a1f1-42a5-9f01-033cb4a480b0	2	8.19	2025-09-25 15:49:21.360008+00
e513eb52-ceb4-4305-800c-8bc27101a66e	f5d9a35f-a471-4694-b45d-d24d9c682512	26a142be-85ca-4609-bd38-3ad3eb7be080	2	62.77	2025-09-25 15:49:21.360008+00
d022bee2-02a2-4716-916e-de37c20a90a2	a8f1300e-9928-4a6c-87bb-88e67dc80007	3470c7b1-d741-413f-858d-d49c2ab0dac2	4	125.30	2025-09-25 15:49:21.360008+00
18bf9776-8108-4287-8167-11904538cc22	cc1c0fe4-871d-42f3-aecd-3606874ffa5d	2fc0cd25-6d9a-44df-9031-779a6b5d4bf9	1	392.39	2025-09-25 15:49:21.360008+00
1996fe46-3bc2-4666-b44f-eae140fd4c0b	75574235-ca38-4468-9173-6c13e625a703	709287bc-f3cd-470b-8c90-29c3b09aa947	2	286.91	2025-09-25 15:49:21.360008+00
e3ddc31a-1840-4c90-b320-e72575f8e77b	88d67c80-cddd-4ebe-ad98-0641b5884be1	12a3e1ab-f75a-4bce-bedb-b39148d81cc4	1	334.40	2025-09-25 15:49:21.360008+00
ba939b09-eb88-4545-8a32-809a7cfa0bd3	eb38046e-741a-491f-8f27-789b5b7c0903	50e4f74a-a750-4ab6-b4ff-7f680f604249	4	25.67	2025-09-25 15:49:21.360008+00
7ca4723f-91c8-42d1-a43f-e5118f8dda4d	df5cfbc9-3b7f-4ef7-ad78-7e4479c99a9b	634d0cde-b191-497a-9977-8bb037147b0b	5	191.83	2025-09-25 15:49:21.360008+00
528c330a-0685-4c07-a35f-1e986e892446	104b98ef-d1ca-4281-9cdc-0cccad91ffce	69bb44de-94a8-4d30-b00b-0761bd1538e1	1	413.69	2025-09-25 15:49:21.360008+00
35db2ccb-3ec1-4506-a4b4-10a3af591cfa	eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	26ef9482-13ef-447d-8705-626db164f85a	1	179.20	2025-09-25 15:49:21.360008+00
6dcf4bd7-a81b-4c89-bfcb-506d1d76197a	750e4907-ab47-4e1a-a191-e6356a4962aa	449d5f97-315e-4a4e-af32-df159c3391f7	5	442.52	2025-09-25 15:49:21.360008+00
608ceb4f-31e6-439f-9fda-9ec4b450473e	7a0e8803-b665-46d2-a9f5-79297739c1e6	463e721d-3caa-412f-a1e7-78240415f238	4	234.20	2025-09-25 15:49:21.360008+00
6585e4b6-a8d5-403d-b3ab-de39133b9758	1f5a7650-6543-4791-b064-3290aa6b362c	63a6de5e-22b4-4314-8981-ba22992c63bf	5	189.17	2025-09-25 15:49:21.360008+00
fd55d708-4b4a-4319-933a-1fd7497423bf	a8f1300e-9928-4a6c-87bb-88e67dc80007	1d73ab87-99a5-4dfc-ad19-1f06460b414b	3	195.76	2025-09-25 15:49:21.360008+00
d6dfa4c5-fd4f-4e5c-a009-7ce50bf481d4	d3569393-985f-4053-b8f4-5e14fc51b461	d414609e-4f02-484f-a064-7f047dbcfbeb	1	38.59	2025-09-25 15:49:21.360008+00
4ee7e3c5-fb67-4706-943a-a1e62e477c02	688dccef-34b0-4924-9653-9cf2dbb1d4e9	36626c9a-a7dc-4179-8027-4c3435f1f2f7	4	150.82	2025-09-25 15:49:21.360008+00
13ed7ef1-b778-4525-bbb3-7d1de1e89f7a	95c0e9b4-3cda-468d-b132-7b9806303461	a9ab9109-2922-4a24-8f71-320144708c4f	5	300.37	2025-09-25 15:49:21.360008+00
620356d1-6e7d-4339-9b77-fea9f2d69645	0c5be91b-4cb6-479f-8d5a-d661e3f1446e	ee50a987-173b-4b05-a631-2e8938684d91	2	41.42	2025-09-25 15:49:21.360008+00
6cec96ee-77ee-42d8-b313-d76c847b1e17	81e3e409-d429-4a1a-b8f3-2e8e517dac57	9e6b28df-dc8e-4a28-a237-806f68027afd	1	111.45	2025-09-25 15:49:21.360008+00
da00d8a5-a8e6-49d2-a524-6a48187e1b18	5686613b-1b0e-4868-93e4-29bff9ff402a	5ed6762e-cc7c-447b-935a-7aa018a64ccf	5	22.96	2025-09-25 15:49:21.360008+00
07e6a9f9-f134-4c9d-b0e9-dbcab461cc7a	bd9572e4-f7f0-4388-948f-735bdb83daf2	118237ca-4fcc-4611-aee1-1b5aa4c094fa	3	33.75	2025-09-25 15:49:21.360008+00
652fb064-8c3c-463d-badf-d44e3c5d7241	49a8611c-52f8-4199-9cd9-8147c287f45e	f4bb1a25-5769-4509-a949-888b449fc515	1	232.74	2025-09-25 15:49:21.360008+00
83740b2c-693e-4f18-91b5-a1fae3b4eded	16a22e58-1834-4dc8-96d9-08dfe2fc0e67	02130ef9-7d07-4e39-83b4-7789103dfe0c	3	113.99	2025-09-25 15:49:21.360008+00
ec906c56-4a0b-4ff6-b1a6-f489285365ee	57feceb2-4b87-4a89-aca7-1325f9705afa	a5c886bb-dda2-447a-bcff-dd304e8e85f7	4	128.34	2025-09-25 15:49:21.360008+00
70811c10-11fd-47d0-a6e8-927e638d9ee0	04b226bb-5169-486d-ad2e-26a3f3c277bb	268710b5-2300-4548-bad1-47513dbf13d0	3	21.31	2025-09-25 15:49:21.360008+00
9f002e70-8180-4da2-bd93-bd34735c45b7	0fbbd80c-1f78-49a7-a474-06be4c1258fb	6db11ded-e71d-430f-b297-f7e9a8f1890a	5	245.50	2025-09-25 15:49:21.360008+00
9d64b326-0bc2-4419-bd82-3651bebe8c67	646020f9-385d-48af-99f8-1d1c6849ca2e	8d83a025-5e63-492f-b4d3-411c4eaa5161	4	493.51	2025-09-25 15:49:21.360008+00
54396ebd-bce8-43b2-afde-5ae91b20291a	27e301e8-2e68-495a-8e90-334043fd9ec5	f608654f-7d29-452a-83bd-36c0d56f04e4	2	469.23	2025-09-25 15:49:21.360008+00
462bf05b-8791-4e7e-bd00-9631efaf167c	29c44409-4491-4a6a-8843-fff08882f07e	625de24b-bb6b-4771-bfdb-19cfbe0bffd6	5	41.07	2025-09-25 15:49:21.360008+00
7e5aeb0a-180d-4798-b1b7-87c7e2325346	c2a449db-0250-418d-bcb4-fb0cf9cea4d5	4f32fa4a-7f23-4f96-9208-413006b3308f	5	106.27	2025-09-25 15:49:21.360008+00
e8b2052a-32b1-46a8-a207-7233050e41bf	c9c94223-2df3-4066-86e1-444b6a2ab4ee	752a4864-78f6-4f0a-a899-2df7627aaac1	5	473.15	2025-09-25 15:49:21.360008+00
5ce537d6-44aa-408d-a578-5e301ad6effc	a3dae141-e372-465c-a11f-cb3972d4649e	fc6bb273-6c79-4da7-9bbd-902c36847259	4	396.67	2025-09-25 15:49:21.360008+00
e9127654-2854-4713-a1ee-8bcb64a6fb4e	3ddfbb5c-a1b2-4101-ba1e-0ff667c1ff78	d82a8dd3-a1f1-42a5-9f01-033cb4a480b0	3	332.96	2025-09-25 15:49:21.360008+00
28c8b2b1-fea0-4cdb-8326-dfad33c2c2a4	d6a0a1ac-417e-41e1-96e6-061a85cec67a	a394c179-ff81-4ac3-b42f-4fa7b4d09ee5	2	135.32	2025-09-25 15:49:21.360008+00
48ced1a7-da93-42d5-9a80-a4a80cf615f5	4b4befc2-d7dd-46bc-b8a5-4f0ed3dda5d8	7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	5	470.37	2025-09-25 15:49:21.360008+00
0c5756ee-b63b-477a-92ae-84d44bdcbc4f	29e75bea-4cb6-4bf0-8342-e2a00f220191	5298a3f5-5f31-41b3-af22-7fd5aca2e5be	2	185.08	2025-09-25 15:49:21.360008+00
fee40325-7686-44c1-9a0e-f09196025dc3	15b13006-4c56-4f21-9475-f3c5d7bfb52a	35760cce-90a5-4a54-9300-fde2ac98a9ed	2	383.33	2025-09-25 15:49:21.360008+00
37f52f05-5bfd-48be-939a-e401c397b8c4	de729129-ee71-4d4f-86b1-2b9f6413b383	91dc74ec-7d5f-413d-aabe-aea64403006a	4	298.32	2025-09-25 15:49:21.360008+00
ddb19247-2e53-467a-8446-9a7218261d84	192db6a0-59c5-47b1-83e1-364a3d165fea	adef93e2-5ebb-4fbe-9be0-8a912003fafe	5	434.98	2025-09-25 15:49:21.360008+00
32069f9b-e675-4867-bf85-5ea443e04e20	e7af09a0-4128-438c-8b0c-fd71bf4172de	78f65a6b-18c2-48df-8bc0-eb30a0154451	1	308.15	2025-09-25 15:49:21.360008+00
b8441822-01a2-495e-b6d7-56e82492272e	c99c3a55-5a02-4422-8bba-8ac5704961c3	a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	1	133.27	2025-09-25 15:49:21.360008+00
c4faa41d-e7ee-486d-8724-bd6ac5e974eb	bea8a935-f088-4989-b741-d28734836f0b	f96ccd19-1c60-4ae7-8fea-23ef4ab7894c	1	318.33	2025-09-25 15:49:21.360008+00
f5ddbb42-decc-4264-a93f-f83e65ac22dc	0285e8f8-4fa5-416a-9cbf-256b098026c5	c0618cb6-0459-483f-a990-6ceb8852d6da	4	96.52	2025-09-25 15:49:21.360008+00
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, nombre, precio_valor, stock, created_at, updated_at) FROM stdin;
e21ced8d-76cf-4fc2-b265-3d592622ffa9	Laptop Dell Inspiron	15000.00	10	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
c89378ad-9f9f-401b-9b9c-e3ffea908751	Mouse Inal├ímbrico	250.00	50	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
0fca3a00-37f1-4b46-b529-268b66e55be9	Teclado Mec├ínico	800.00	25	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
36a9d694-10dc-49e0-a0b8-a1a01f03ebe0	Monitor 24 pulgadas	2500.00	15	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
534baa0b-f5d1-4cba-a251-27ec4f8ccc87	Auriculares Bluetooth	500.00	30	2025-09-23 06:08:28.87557+00	2025-09-23 06:08:28.87557+00
c3c4fda6-2d2c-427f-a899-ca1b5b56856d	Laptop Dell Inspiron test 1	15000.00	10	2025-09-24 00:17:50.546367+00	2025-09-24 00:17:50.546367+00
593d98fd-14f5-4e53-9d89-41e9961694a4	Laptop Dell Inspiron test 2	15000.00	10	2025-09-24 00:17:56.30115+00	2025-09-24 00:17:56.30115+00
8cf7d38c-debb-47fa-b29c-8cb7b8f9d7a8	Laptop Dell Inspiron test 3	15000.00	10	2025-09-24 00:18:00.158238+00	2025-09-24 00:18:00.158238+00
aa39d73d-7815-47f1-abdd-43022794a556	Laptop Dell Inspiron test 4	15000.00	10	2025-09-24 00:18:03.615376+00	2025-09-24 00:18:03.615376+00
27f0604c-2926-448c-876c-6fb5a5d5390b	Laptop Dell Inspiron test 5	15000.00	10	2025-09-24 00:18:06.911731+00	2025-09-24 00:18:06.911731+00
2f5a48db-d55f-4a58-89b3-cef67eead70c	Laptop Dell Inspiron test 6 editada	15000.00	10	2025-09-24 00:18:10.494046+00	2025-09-24 21:36:51.132391+00
b3299643-205d-46bc-897a-2f555b1b745b	egestas metus aenean fermentum	2725.08	21	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d2c940c4-f1cb-487b-877c-44d66b2c7a34	mauris non ligula pellentesque	2736.08	298	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
de92e57b-2c55-4ea7-af68-b305204256f2	venenatis tristique fusce congue	1284.63	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1d73ab87-99a5-4dfc-ad19-1f06460b414b	augue vel accumsan tellus	12.76	73	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f5d8606a-303f-4976-989d-6a670aa41922	donec quis orci eget orci	1255.47	36	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1a747b45-a898-4f93-b6cf-e58f4fd2774d	eget congue eget semper rutrum	742.04	294	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
742d19db-e9ef-415c-9c3f-3d147282b3ff	a libero nam dui	1249.17	263	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
244f5fdd-00d4-4ae7-a523-a14b19e3e3fc	at nunc commodo placerat praesent	1442.05	158	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
866ec54f-443e-4ee7-a605-619c43c6a6ac	consequat varius integer ac	2227.34	125	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2b1971fa-4018-48b9-b2ce-173cb910255d	nulla ac enim in tempor	1919.47	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0d5f35c3-94d6-4b80-a5b9-dab9ef517eb0	ac nibh fusce lacus	1461.28	249	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7707eedb-41cf-4d16-ae58-84ff56a12124	ipsum ac tellus semper interdum	1164.74	486	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
474e2fa1-db3a-4a18-9525-ee013d90e4a3	faucibus accumsan odio curabitur convallis	1216.07	60	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
26a142be-85ca-4609-bd38-3ad3eb7be080	ipsum ac tellus semper	1816.22	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
21f0cd0b-99e5-4271-9545-9bb8ee47a8d5	eleifend pede libero quis	2693.69	301	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
faa218cd-8b22-43f6-aa0f-df0d8b7993ee	vestibulum vestibulum ante ipsum	2094.52	245	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
484224b2-0dce-4aa4-9b8e-2943d495564b	porta volutpat erat quisque	2565.88	347	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
044fd898-06f8-4d48-8929-5acb15442c11	fusce consequat nulla nisl	1273.93	371	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6c485af1-c004-471a-a088-07cc4d59b7c6	in hac habitasse platea dictumst	2217.15	128	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6054583e-2c64-42cd-9d74-630e0fe6a41c	nibh in lectus pellentesque	2289.11	286	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d393defe-2960-4f3c-be2e-335411d955dc	morbi non lectus aliquam sit	2511.70	340	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ac4cf314-3822-4cad-9489-1c3a4e011cdb	nunc viverra dapibus nulla suscipit	40.45	405	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4d3a9cfc-9faa-4cb4-9925-2ef1401088a9	urna pretium nisl ut	2556.53	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
39df2403-7926-436b-b335-1872a3876a90	nunc donec quis orci eget	909.85	104	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
343f5f5d-0ebe-403e-bad7-43caa47b701f	maecenas ut massa quis augue	498.53	374	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dd347383-08f4-45f6-b1f8-c68a23c43a02	nulla nunc purus phasellus	1246.28	437	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ff45506a-c74c-4d5f-adf6-690a5e0c3b68	mauris enim leo rhoncus	1262.93	219	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a8a11156-1c57-4a4b-8c63-b08f29eac11f	eu orci mauris lacinia sapien	1310.10	476	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
24509544-4e2f-482c-9059-99deda116078	eget eleifend luctus ultricies eu	2585.50	76	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dd96e686-fa93-43ea-8ff4-a2525f0c8f6d	at nulla suspendisse potenti	1322.15	230	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a768cfda-4d7b-499e-a7fe-501f68bb8241	nulla elit ac nulla sed	152.43	385	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ccc4bb9c-f827-4f5b-b7aa-27140781312d	ridiculus mus vivamus vestibulum	168.43	323	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4d9c2197-b188-4cc2-9d32-90c74001a4f5	vestibulum ante ipsum primis in	2249.62	17	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
254d53f1-8fa1-41e8-9dd2-3e5ad086ddf8	nec molestie sed justo pellentesque	127.98	164	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b5388612-d6e3-45f7-974c-f4b05ee527e3	leo odio porttitor id consequat	1555.77	474	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ac168279-ea8a-4a93-bd19-f8392df74292	in quis justo maecenas	758.42	113	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a0678678-c121-4170-83d4-ee3815ac836e	augue vel accumsan tellus	804.07	174	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
120d6ea9-b9d5-4231-b890-cd4132354f28	eget eros elementum pellentesque	1504.89	259	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8bee181e-b313-4a84-8105-46e07f0cf824	vestibulum ante ipsum primis in	1406.12	305	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1ab30713-5e7d-46de-b29b-b022a593b830	quis justo maecenas rhoncus aliquam	1717.40	182	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
01fb9db6-a7be-48f5-b979-43865947ef42	ut at dolor quis odio	2132.03	214	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cafef26b-d5fc-467d-8945-8c2c4b3c871f	condimentum curabitur in libero ut	417.74	24	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e5a34702-df91-4bbb-a7d7-9eaeeac19445	vestibulum rutrum rutrum neque aenean	2613.56	46	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
16caef05-933e-4d78-9ef0-33da5b9f38a0	vivamus in felis eu sapien	2846.36	102	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b166158c-a5be-436c-ab5c-d1f97b0572b6	fermentum donec ut mauris	1697.75	196	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
42e164d2-5b1c-470c-ba3d-f714e0c17aa3	lobortis est phasellus sit	197.52	375	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8bd888a9-2d16-4edf-bdf1-4152af85d945	et ultrices posuere cubilia curae	1220.81	338	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
96f27450-67bb-4291-8154-1500feeb9253	pede justo eu massa donec	2314.10	319	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f24bb18-71e4-40fd-af30-bf52d35d0f71	vulputate nonummy maecenas tincidunt lacus	2957.64	325	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
54a4c96d-3ff9-4d8f-9041-7ab5cd9e482f	nec nisi vulputate nonummy	2041.82	96	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b23a66f7-3529-4cd2-9e22-ccba6a804d4a	turpis sed ante vivamus	2414.57	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
827e4ef4-056e-4a4e-a7b0-dadd7aa95d4a	sagittis sapien cum sociis natoque	2838.84	368	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75ad64fb-062d-4f05-a145-5fac4710ecd2	dictumst morbi vestibulum velit id	2540.78	107	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6fb7b197-4beb-4c50-ad29-bc14326db41e	vehicula condimentum curabitur in libero	2901.48	42	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f5df4c23-eb63-4b9a-9208-0389662dd022	adipiscing lorem vitae mattis nibh	322.33	436	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a0934b97-535d-4536-a286-7debe5ac9988	ac lobortis vel dapibus at	1319.86	460	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e9b4110e-ec56-4506-ba33-e895d567805e	cum sociis natoque penatibus et	1403.59	455	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
67552613-6deb-4627-aa8d-678ff2f9192f	placerat ante nulla justo aliquam	841.15	39	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
03975248-b6dd-4fd1-a2cf-aea26f94aa36	luctus et ultrices posuere cubilia	1989.23	33	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
306e3d9a-47d6-4f1a-bb3c-de7d2a8e9f52	feugiat non pretium quis	264.23	458	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
55aa04c2-87e7-462c-b372-7bb308f443ea	parturient montes nascetur ridiculus mus	2434.90	341	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
840d1b24-37df-4652-9293-a94e8844f668	vulputate elementum nullam varius nulla	1332.66	106	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3aa4c585-7e17-4118-b80e-cbee745cd4d6	libero nullam sit amet	1531.31	147	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f96ccd19-1c60-4ae7-8fea-23ef4ab7894c	posuere metus vitae ipsum	2298.29	165	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d9019e8a-3f30-486d-bc39-455fa90ee7fa	orci eget orci vehicula	1945.23	311	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
235995d2-8eef-44fa-b69f-6db5f284b312	volutpat sapien arcu sed augue	593.35	402	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
60ede4fa-9169-42a7-89bc-a6c31e1b77ea	pede lobortis ligula sit	1613.17	174	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c99a333f-7850-48ee-be90-35ad9dac0cb9	nibh ligula nec sem duis	946.68	305	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
27e2e9a6-1d22-41c0-976d-dc7ffc253d4e	quam pharetra magna ac	460.42	42	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
856d5eca-a8d9-4b7b-bf5b-5503dccb7afd	turpis nec euismod scelerisque quam	914.35	439	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c295d290-a589-4dd1-ab4a-fe7b997567bb	sit amet justo morbi	1327.49	378	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
41f0863c-9837-4832-a26b-d2b73aa5a262	libero quis orci nullam	368.83	484	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5253556c-057f-483c-9381-f6af86bde287	sed augue aliquam erat	1325.04	200	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6abb415b-fe4f-4793-ad8d-868a795e32ec	vitae consectetuer eget rutrum at	313.21	446	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a67c21eb-f30b-42c9-8f65-621f50829602	consequat in consequat ut nulla	2043.79	110	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c1b2fa5c-a16b-4a74-9cd9-02fe961a1f5b	sit amet eleifend pede libero	404.65	314	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
807e423e-35e3-4c30-95bc-12beeebc224e	in eleifend quam a	2244.38	124	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9177a11d-1cef-401d-a853-7448a708bdc7	donec ut mauris eget	2726.59	316	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b44bed20-df21-4afa-a304-5a70bf1661fe	lacinia aenean sit amet	2620.07	124	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7ea74fc2-3204-4bb5-a803-c5d2549a0bff	sodales sed tincidunt eu	1072.47	369	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2753b302-63d5-428f-a8ce-ebffef9b210b	aliquam non mauris morbi	2295.85	476	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f1808efb-d1f3-4add-ab30-cbe3159c644a	vestibulum ante ipsum primis	154.74	188	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f4bb1a25-5769-4509-a949-888b449fc515	viverra eget congue eget semper	1655.95	472	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
542d4f5d-8ae8-4710-b47c-35544bca73a2	metus aenean fermentum donec	266.72	274	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c0c1d570-83c0-4529-b3ae-cf0b55eeee68	hac habitasse platea dictumst etiam	939.91	22	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ba5be328-3e0f-4d8d-982e-a6249718b39a	maecenas rhoncus aliquam lacus morbi	1433.66	448	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b48e17a1-25d9-4368-a08d-a585dd43e711	ante vivamus tortor duis mattis	1189.24	433	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b9fd3dcc-1e9b-4a16-8dd5-741e242f4702	ipsum integer a nibh	637.88	372	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ed0cfe81-75b1-4916-a870-f5a33eea476f	lacinia nisi venenatis tristique	2408.09	379	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5aa541f1-2bca-4ec7-bbca-06775a6babb7	ut massa quis augue	1406.65	254	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5fa48e09-bf45-4576-a1ed-fedf21422519	nullam molestie nibh in	113.98	96	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7ee8227b-c223-4f01-afcd-ca14337fa151	nulla justo aliquam quis	2171.70	434	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f36e8299-fc81-49a1-9643-a012f892462f	vel dapibus at diam nam	897.64	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
eab928a2-4744-41ed-8bfe-59a345e2291a	posuere cubilia curae nulla	2751.00	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
44c194bc-f69d-4a8d-a525-f18eb67c3663	eu interdum eu tincidunt in	1513.43	177	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
34c0124e-60b7-4ffa-ab69-1f879796474f	platea dictumst morbi vestibulum velit	1501.57	375	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ee50a987-173b-4b05-a631-2e8938684d91	scelerisque quam turpis adipiscing	1744.44	287	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
48693bd0-e479-45b8-b850-83da72ea768a	fermentum justo nec condimentum neque	1716.49	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9f8a8d90-ea1b-4928-a2fa-135af6cc5301	elementum nullam varius nulla facilisi	220.05	224	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b92b4fe1-631b-49a8-b192-df53ed3394c4	rutrum nulla tellus in	72.83	28	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9ffb6cbe-32ca-4b86-a399-f0dd4836be95	fermentum donec ut mauris eget	2202.45	213	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aafd4c57-d44b-464e-b877-504a4daad1ef	consectetuer adipiscing elit proin interdum	1964.06	349	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
36a6c226-7e64-42cc-a129-41e2439fdab8	venenatis lacinia aenean sit	2301.86	344	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2dd75261-4657-4253-9efa-9623252edc34	ante ipsum primis in faucibus	632.91	342	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e4b0bc1b-55cd-4c24-b915-d20fb13042f0	orci pede venenatis non	1704.65	34	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
62da5688-0423-438a-9d5f-5ffedde13ce7	consequat morbi a ipsum	2884.99	162	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c7061bac-6800-4837-812b-4259c2eef643	praesent lectus vestibulum quam	2683.77	419	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b1ed1407-1c4f-43b5-b023-b8aff3357fc2	in ante vestibulum ante ipsum	1511.07	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c96f321a-391f-4fe0-b189-23b2294f7466	magna bibendum imperdiet nullam orci	2525.93	468	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
be17ba99-47cc-4f1b-89ab-f0ada842f8be	ultrices vel augue vestibulum	2130.08	43	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e3e6ba05-b880-4bbe-9677-50fa392e4c0c	ac lobortis vel dapibus at	2817.51	415	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
21f89511-0b73-453d-90e5-5259485a5afe	pede ac diam cras	931.41	409	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
198aea83-e7ef-4117-b08d-87c5f12c28e8	donec pharetra magna vestibulum	2066.03	278	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
38bfd2dc-08ec-44ff-a005-76aa7ad2ed61	non lectus aliquam sit	2470.38	287	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
299bbe41-9825-4f28-baa6-a9912151fcbd	varius ut blandit non interdum	1965.06	264	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2bf3df4a-c939-46eb-b584-d52d8b3e1570	accumsan tellus nisi eu orci	351.13	230	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e221f6ee-14c9-4737-9dd7-049752f4aac6	ut volutpat sapien arcu	1292.94	149	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4959ca38-b273-479e-a65f-f1943f0e439f	orci luctus et ultrices posuere	1198.40	199	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
751ee4e4-ff8e-4d55-ab7b-05bcd323576a	enim in tempor turpis	2922.13	242	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2f0aead7-7384-4467-bf56-bc0e7d8ef4d8	purus aliquet at feugiat	247.66	351	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
809b63b7-aeaf-4496-bc99-0694fe605c94	consequat lectus in est risus	2408.39	494	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
48776d48-3d14-4b31-a4bb-e8adc2d07748	donec diam neque vestibulum eget	872.51	163	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a1a72c5c-cc81-4a56-bac4-1faf14818022	lectus in quam fringilla rhoncus	1066.13	297	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fa82a48b-d4f4-438b-9b7c-0c710c755d96	primis in faucibus orci luctus	2952.95	91	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c0f634d7-4b5b-43e6-8f84-d62622a1576b	purus aliquet at feugiat	2617.41	426	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4ca3c954-9979-4d43-bb0d-5ed8d9f2ceaa	condimentum curabitur in libero	2632.16	95	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f1f84df3-b43c-4e68-adb0-db391807a1a9	et ultrices posuere cubilia curae	2565.62	273	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1c773b7e-e1e5-42ba-a7ba-b55a47dc78dc	suscipit nulla elit ac nulla	2816.46	342	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ac1d25fd-ea2e-461b-837d-85d1a9222fb2	in faucibus orci luctus	3.28	254	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4becc982-bcab-4455-9214-2dd45682a6e1	consequat ut nulla sed accumsan	18.96	196	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
375a2475-47ea-452b-9d02-cea3a968e7ef	amet sapien dignissim vestibulum	1431.18	82	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
45b843bd-3948-40d4-83cf-60cfe0469a0f	ligula suspendisse ornare consequat	2559.09	250	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8bc1489d-cd37-4ab3-ad35-fb2e2565255b	tincidunt eu felis fusce	327.44	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1bb97fe4-a952-429b-9e82-af0cdfb9d700	vulputate ut ultrices vel	905.18	244	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
21a0d865-c047-4d76-97f7-cfe11ac1e644	fusce consequat nulla nisl nunc	1953.04	412	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b5472fe6-08a0-4a71-b141-098cb95417c9	sodales scelerisque mauris sit	2247.19	163	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
172f7972-39b2-4182-903a-8ac4660a5478	turpis elementum ligula vehicula consequat	803.99	11	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f82b81d-f611-449e-b94e-b4b9ea1329ee	non interdum in ante vestibulum	2939.07	390	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
10c81407-ee15-4728-861c-97322a49036a	platea dictumst maecenas ut massa	1927.33	409	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
848831ab-8530-41cf-839b-d9eba748aff7	erat eros viverra eget	679.34	152	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c433fb1f-48e5-4b80-80e6-3c01bf2015a2	adipiscing molestie hendrerit at	1201.40	110	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e06ca0c3-73d9-49e0-a5c6-d52ebd6153c4	non sodales sed tincidunt eu	716.72	248	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f4429a7d-1708-4564-afa1-873cc4345c03	ipsum dolor sit amet consectetuer	1110.04	183	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
688b8efe-e6d0-4fc8-a0ee-5cefdf5e4173	congue risus semper porta	475.80	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
02ed6ab3-2074-4dd9-a6a9-c8160abc4bd0	iaculis diam erat fermentum justo	2297.94	165	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
448bc7ba-131c-43e9-9061-b6a3d574e1ad	luctus nec molestie sed	2639.88	117	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75384ea9-6d1f-49c3-8160-2c15639917c5	arcu sed augue aliquam erat	2857.67	472	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1e02cd6f-7165-4c24-a21d-17bde6de0cf5	ultrices aliquet maecenas leo odio	1493.64	176	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
119ef357-5ee0-4d30-b76e-a0904ed0c28c	ac nibh fusce lacus purus	2365.71	145	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c6975f71-dc00-421c-8c3c-b52c125afc91	nisi venenatis tristique fusce congue	1209.41	393	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7e1bb644-625c-48c5-ab0e-19ba4af3b7ac	pede venenatis non sodales sed	2087.47	241	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
320018d9-91c7-4982-b01e-0ef944f99170	morbi porttitor lorem id ligula	919.82	331	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
88a8d5a7-169a-448d-a9df-7e12953611da	duis at velit eu est	129.37	218	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fd91f3dc-8855-4ec0-882a-a26e8ccc83a7	ac tellus semper interdum	1525.25	267	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b74ed3cd-03cd-4d1b-8989-9c46bf8a230e	elementum pellentesque quisque porta volutpat	694.93	206	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
da5cb56e-8ca9-45a1-bfdc-5d51fc4a9005	interdum mauris ullamcorper purus sit	819.20	221	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
95062fe6-f332-4c00-9973-cf6230544a8c	vestibulum eget vulputate ut ultrices	1690.24	106	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
21745193-9c4e-4249-b2a7-c93ff9c5bf58	sit amet lobortis sapien	1897.74	385	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9aa4f60a-2af8-40d4-83a6-8a0aa1d44524	augue vestibulum rutrum rutrum	41.83	83	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6511939c-616c-4cdb-8268-d754d2c03d46	proin leo odio porttitor id	2929.15	116	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
00e4225a-d885-4cd7-ae38-e8ab0073616d	neque sapien placerat ante nulla	1147.53	100	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
96025684-4b0c-41a7-8dc1-96f351c134f9	pharetra magna ac consequat metus	653.74	412	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2a822dd9-fd77-430b-bd12-019d4b26f9b0	faucibus orci luctus et ultrices	2358.62	423	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d310d2a6-c411-466f-b6be-1670a7bbb74e	elit ac nulla sed vel	2126.75	32	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0c936036-ca0a-402f-94e9-41a54a1ca8ed	imperdiet et commodo vulputate justo	822.70	429	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
203d7106-92e4-4183-9ed7-b1c41bd80cdb	lorem integer tincidunt ante vel	305.24	46	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3c3a0c10-ffb2-41b1-b588-db7e4a79936b	faucibus accumsan odio curabitur	2700.49	106	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b04eb25b-9fa2-4522-99e9-cdbc0ea05dc2	enim sit amet nunc	922.39	385	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dff247ae-66d0-421d-9ade-331030b7c3e4	morbi porttitor lorem id	881.00	144	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
096acccc-845a-4f8c-a4c9-4c2ee83dfce4	mauris ullamcorper purus sit	2675.71	334	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f032a584-5abf-47bc-892e-f61dccc60a62	pellentesque quisque porta volutpat	588.08	134	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cf7c0140-d018-41ed-b1f3-d84978d66add	quam sollicitudin vitae consectetuer eget	2230.72	241	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f1d31ebf-68df-4473-b61f-bf3c24343c0f	quisque id justo sit amet	1869.81	6	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2d8a95df-f61e-470b-bc89-6f0d712c896b	orci luctus et ultrices posuere	1150.12	205	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bdb9c0b8-9d67-4339-a15d-b122c7b9f7ce	in tempor turpis nec	727.02	480	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
322d14c9-e270-4d50-a416-af049e62205c	justo aliquam quis turpis eget	2698.36	135	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ac724a6-3c7c-4869-a512-b832457111e8	nam nulla integer pede	1815.53	492	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8dc7fa3a-ab89-4405-b1ad-301b6a89afde	velit vivamus vel nulla	2448.80	75	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
65916b3c-9161-4b3f-96b6-40c59d46a652	turpis sed ante vivamus	984.71	167	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4826f8ee-9b6c-4fcc-b26c-96542ce2a7ef	primis in faucibus orci luctus	488.71	489	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6a273237-8b22-41e9-b314-77bac06d3bc0	ultrices libero non mattis	1528.40	26	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cfe43372-ca94-4c3a-828d-04bf8c150082	faucibus orci luctus et ultrices	2515.82	114	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
39d35def-0cac-4a8b-9ba5-89d172693cc0	lobortis convallis tortor risus	2940.10	489	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
94ba21a1-56ff-425e-98e3-f431f832566a	nullam sit amet turpis elementum	929.24	357	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9b9271e8-4297-4c58-96c1-5197c0eabb7f	nunc vestibulum ante ipsum primis	2487.36	458	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
240219a6-3502-4dd0-b3b6-7589050f2b81	eget vulputate ut ultrices	400.17	367	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
917a1dd1-02af-4545-b68a-4b134d7bb653	turpis nec euismod scelerisque quam	632.70	323	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e22d5a6e-1385-49b5-837a-daf9c2e25836	curae nulla dapibus dolor vel	832.80	410	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0262cb3a-42f7-4eb7-89cb-8f5d3372e510	congue eget semper rutrum nulla	1599.41	360	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
25c9e5a0-94e4-46d3-89c3-6c177c3ccb5b	pulvinar nulla pede ullamcorper	2730.02	338	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1e0921bc-f579-409f-832d-1fe4da09a2fa	tempus vel pede morbi	2361.67	253	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
628a485a-9bf2-45ef-8db7-63ba6fc4bb9f	id sapien in sapien	1579.32	43	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ab25fee-76a8-4cc0-935a-3f98460ff7d7	amet consectetuer adipiscing elit	2090.28	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a3f19f10-0544-435d-998f-ea2b3326a026	id consequat in consequat	1502.44	215	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
60c95653-221b-4f7b-8e5f-4c1f8eccc11e	etiam faucibus cursus urna ut	2842.54	191	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8656b34f-7ecf-47d6-9665-725eacdcba39	sapien ut nunc vestibulum ante	2053.94	490	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
38698efa-0fa4-4a79-9d21-2da2af8008f9	at turpis donec posuere metus	2949.43	493	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5243c8f7-3bd6-49d9-8e2d-6fdae0abbef5	tempor convallis nulla neque libero	1337.57	130	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5468bad5-508c-4ba9-8820-354efb50b6ec	lacinia aenean sit amet justo	372.09	11	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ea4662b7-17b2-4bf8-bb83-d36907342425	morbi ut odio cras	401.22	58	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2d56540b-b214-4088-b0c5-c4fd2cc266fa	adipiscing elit proin interdum	1285.64	397	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
694c7c50-b0e9-4984-8f01-c8a7f4107cd3	lobortis vel dapibus at diam	1666.53	273	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e2562ec4-7772-4852-a62c-294bcee7757f	enim in tempor turpis nec	389.49	135	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bb9e8516-b78b-44b5-8554-6118185a0bf0	curae mauris viverra diam vitae	1041.04	489	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f6646719-cad7-44da-9df7-f91b352004f5	vestibulum eget vulputate ut	1372.04	306	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2b794777-7b61-4a09-9156-dcf8248bda2a	justo nec condimentum neque sapien	631.14	227	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
813efc28-0838-4fb3-9aba-35a8ec0c9f07	donec diam neque vestibulum eget	2557.73	373	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b745f318-19a0-44ff-912d-f19d67e310b5	aenean lectus pellentesque eget nunc	2015.38	295	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
66ad7934-1f5a-47f5-91c8-df3c18c07b79	ipsum aliquam non mauris	377.18	155	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ac9cef94-2751-4f36-9abd-43e045341268	cras pellentesque volutpat dui	2089.50	417	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1f9d3a8d-789d-4234-a4fc-babb3f8f1559	magnis dis parturient montes nascetur	1014.51	20	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fb417af0-916f-4df8-8522-beb0da87cfc2	consectetuer adipiscing elit proin interdum	1681.30	306	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
77668721-237f-4e45-8e0b-4e00732fc412	tincidunt nulla mollis molestie lorem	1333.47	429	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
625de24b-bb6b-4771-bfdb-19cfbe0bffd6	felis donec semper sapien a	359.23	8	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c2f4dd5d-7020-46bd-bea6-2865a22a579f	vivamus tortor duis mattis egestas	1259.73	321	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5958b536-aaaa-4c7e-baf0-72743dfb953f	nunc purus phasellus in felis	2201.60	494	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
16c44ce4-e115-4b39-b307-78c786711eb1	tempor convallis nulla neque libero	2723.65	297	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2c94525c-a26e-44d5-b79e-9a20f90959d6	pede libero quis orci	2535.02	150	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
589f5188-96bc-4404-9cfe-78d6eae50831	amet turpis elementum ligula vehicula	2724.86	10	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
26ef9482-13ef-447d-8705-626db164f85a	amet cursus id turpis integer	261.12	304	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6e255240-5ac7-4575-96ce-d8418e958aa8	eu est congue elementum in	2313.08	215	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
736e608f-f545-4d28-9da1-146cc3444701	pede justo lacinia eget tincidunt	2794.48	0	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d5cab7de-cb02-4979-9900-23c96091aa6e	ac nibh fusce lacus	1482.83	483	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3bc7ded0-4552-4ce6-b0da-4b564392aef0	orci luctus et ultrices	1846.71	470	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cd6571a9-241c-4ed0-9d0e-e22f63583e41	imperdiet nullam orci pede venenatis	1813.00	198	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3a1de227-d303-46d6-9e73-1e65ab3d8f94	aliquet ultrices erat tortor sollicitudin	1578.36	315	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a274c297-8cdc-401d-aa87-4c61971c6730	sit amet consectetuer adipiscing	1633.00	363	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
687e4d57-6081-4e35-b469-4fa2d93cf1bc	pellentesque volutpat dui maecenas tristique	1510.10	411	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
df9fc1d8-9368-4d8a-9820-493051171d87	non mauris morbi non	2534.68	495	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fecec68a-2825-4382-b4cd-77c817f1d576	platea dictumst aliquam augue	1022.21	360	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3f930a17-699a-48b2-9ca2-245e31268823	dictumst aliquam augue quam	1947.07	75	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
117fdc33-7e81-40a4-84f2-e9702ade010c	viverra eget congue eget semper	2356.53	497	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
64010f20-cdc0-4c92-9c66-cc08b8827113	nam nulla integer pede justo	1241.23	75	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
41c1c9b3-5604-4703-a733-3a96b08f1dac	malesuada in imperdiet et	2526.60	468	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
abe82c8f-d2c5-47c4-84d9-7bfff4d15ff0	ipsum dolor sit amet	2308.01	229	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
339eb046-d875-45ae-96ea-c973f19333ef	nec euismod scelerisque quam turpis	508.84	16	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
31b75483-396b-4a98-a51f-63b3e8216865	donec odio justo sollicitudin	2820.03	263	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4d7420ea-af38-45e4-ba7b-983666b7a631	lectus pellentesque eget nunc	2599.06	292	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7e793ed9-4bb8-4eb1-8ac8-8fe73fe2d288	donec ut mauris eget massa	445.95	24	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aac955c0-cf83-4bc5-9707-2cbc8cd5fde3	eget eleifend luctus ultricies	889.98	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
37a371b9-fcc9-4020-92f2-b41636c96079	aliquet at feugiat non pretium	2558.15	136	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a6fc8ae4-95d2-4840-b6ab-e565b61ef4ed	faucibus orci luctus et ultrices	987.41	470	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8f5225a6-34f5-4c15-a988-d7a4f55ab035	laoreet ut rhoncus aliquet	133.01	426	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ed0e0cee-7afe-4af3-a074-002f8339d094	tincidunt eget tempus vel	2275.54	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
61136316-3e66-423b-aab2-90168b427076	etiam pretium iaculis justo	2116.27	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
be8ab051-2528-40c2-a631-76a69ba9586d	ullamcorper augue a suscipit	2771.22	63	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
33fa3b1b-3e7e-419b-ba3c-a05d8dc6c373	lectus in quam fringilla	295.04	142	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5e955770-be3c-4861-a9bd-ce75cf16d612	morbi vestibulum velit id	1003.17	25	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c4fffe59-53eb-4074-b43e-f6e66f39dd92	dolor vel est donec	1592.08	407	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cd37d7b5-4541-4e4b-8a8c-f3d3404260ca	bibendum imperdiet nullam orci pede	2962.24	141	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ccc32aa1-6f22-4243-a460-765f77b1372d	in blandit ultrices enim	1432.35	480	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db25a60b-7e10-4a3e-985c-862e305d8d12	faucibus orci luctus et	1823.41	209	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8e4f9281-4de2-4a32-8382-9889f1a24801	amet eleifend pede libero	1099.93	257	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a8ae8cf4-1975-4e07-a6d3-104867375a8e	lobortis vel dapibus at	2625.61	22	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b5eee025-52d6-4293-853a-e8652daa2961	velit eu est congue	2752.64	122	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ab9dd606-ca63-4a8f-9891-92ff53c2b29e	et tempus semper est quam	2937.98	73	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
63644e2c-a2bb-463c-b38a-f889a9b401c6	sapien varius ut blandit non	705.06	221	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e7d7d5bd-c4a0-4990-affc-79d875c9bf9f	neque vestibulum eget vulputate ut	2824.23	363	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f7238f11-8292-46d3-9a25-47aa5820cb8c	sapien dignissim vestibulum vestibulum	2897.39	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ee8aadd-6e7d-4bb5-8378-cc087c6e042f	ultricies eu nibh quisque id	868.52	270	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
49a91d2e-8a57-41e0-9137-6ae5e9b848a9	semper sapien a libero	804.82	96	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
623359cd-90ee-44dc-add9-ec00f7428b85	gravida sem praesent id	1120.25	200	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b7c38c8c-048f-446e-b2a4-093988b2b3f3	ut massa quis augue luctus	139.17	498	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7977b6a4-2f51-462e-b730-66f18785dbdb	dapibus duis at velit	1554.97	271	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3c1a208d-d3a9-41c1-bdc8-f17d9025884e	laoreet ut rhoncus aliquet pulvinar	1185.43	10	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d9107db3-0a4b-4a74-bb70-0ed53546282c	erat eros viverra eget	168.68	466	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a27d5cef-fa30-49a2-b338-b63c4ed23a9a	dui vel sem sed sagittis	895.30	260	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7bb56b0c-494a-4fcc-ba6d-48ba50313e6d	quam pharetra magna ac	733.46	216	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c1746368-b8da-4994-ab96-1d008bd54718	augue vestibulum ante ipsum primis	2181.43	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7cd8aeab-d746-4e22-a331-20f85bc0547b	ac est lacinia nisi	981.08	212	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d55b1e7b-d82c-405f-99bb-267e0d272594	eros elementum pellentesque quisque	971.67	400	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f86c5cc0-b356-4be4-b4ef-256000244a22	pulvinar sed nisl nunc	1695.29	92	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fd48c418-c44d-4293-95bc-1585c54fe71f	morbi vel lectus in quam	584.83	212	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4d13a5aa-15f7-4ccf-a8d2-b4ccc1c5c6ea	posuere cubilia curae nulla dapibus	2455.13	204	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b94454e6-f48d-44d2-9e38-6b1df6cd02be	consequat varius integer ac leo	1526.48	136	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bacacba7-76a9-4d09-ab72-f08a18504d23	libero non mattis pulvinar	906.51	278	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b0d4e638-18ea-4597-9d84-7d64c9882b62	integer ac neque duis bibendum	1994.23	111	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
099f686d-67fa-45f9-b8e4-b580e59670d4	in tempus sit amet sem	1508.75	142	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
80f50827-808f-4054-a4fa-e86b32d47e1e	consectetuer eget rutrum at	2408.69	57	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bb972181-e2dd-445f-a60e-adcdc29a1fb0	nec sem duis aliquam	2529.88	434	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fc1caf36-2718-44db-bf7c-deea57dde18f	donec semper sapien a libero	2444.03	449	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3e646ae0-1e23-439d-a83e-a9318a4910c1	nullam orci pede venenatis non	2665.83	313	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4973acd3-2053-4736-801c-25c9e551439f	risus semper porta volutpat quam	317.53	24	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b17791e0-ccc4-40a4-85da-6aa6f36bdbd3	ipsum dolor sit amet consectetuer	260.34	216	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5c911ffd-8f0f-4b09-9325-70e6270c87af	duis bibendum felis sed interdum	719.07	329	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e8933d87-8ec8-424b-a393-c3fddbdf36d0	odio donec vitae nisi nam	83.36	497	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9176623a-6f63-4184-8b0b-dcd9dcdefe99	felis ut at dolor	1895.30	140	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bd2cc9a2-7c6a-490b-a59e-d539bbb27edf	nec condimentum neque sapien	1372.03	237	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a5dde8fa-5075-4d78-bd8d-a8b0b48456d5	tellus semper interdum mauris ullamcorper	2533.12	498	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2cd83dca-d805-467d-a87e-1472adf2f656	elit proin interdum mauris	2032.78	382	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dd70b6ff-2461-4a7e-b011-cab3e03d225e	pede libero quis orci	121.47	120	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b4ab738a-4c07-419d-b547-152d5a282bd5	non pretium quis lectus	427.86	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
736b283a-1808-46e4-85f3-a44cd7ac8a3f	id luctus nec molestie	483.73	486	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b4c7bf0d-33c0-444b-a161-17722da12c53	justo maecenas rhoncus aliquam	1975.30	265	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6559c77c-2a53-4b45-bc03-e0c7a3f2848c	justo nec condimentum neque	2618.06	376	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dfc96061-c9e3-4063-9903-7ad24ceb276c	aliquam quis turpis eget elit	1334.24	25	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3f697690-af3d-4376-b1c4-8374dd413173	vestibulum ante ipsum primis	1907.17	292	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a338d9bb-090f-49ae-9ff7-d117060b57b6	sem sed sagittis nam	662.44	161	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
69bb44de-94a8-4d30-b00b-0761bd1538e1	gravida nisi at nibh in	236.57	376	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
36d84340-6f62-451c-bc62-fd1f30dd4352	libero nam dui proin	1.05	195	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
521f9a88-417c-4ec7-9451-125b852780b5	integer a nibh in quis	92.12	15	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
76d7548b-f723-4eda-883a-1b35e77a8718	venenatis lacinia aenean sit	2095.51	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
07f80eaf-836d-45bf-9c10-fe69001a2fef	ut dolor morbi vel	2428.53	138	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
eefa4819-2e8e-4277-ba5b-0c53a7f62851	amet sem fusce consequat	1988.61	233	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
950157af-af1e-43a5-b63f-0d5f6e4d09d5	tristique tortor eu pede	1749.65	455	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a43f31cd-13fc-46e8-911f-4876ac99098b	congue vivamus metus arcu adipiscing	1799.67	151	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0350cac3-db8a-4f49-87e7-feeb90521b6f	curabitur convallis duis consequat	852.95	146	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f9801d3d-63f3-4956-898f-40dde6d01e9e	augue vel accumsan tellus nisi	2639.38	180	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
884e381f-f04b-4179-a918-804407cdc849	nunc donec quis orci	1506.64	402	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cda83ed8-2806-4857-9275-256a46e498b4	interdum eu tincidunt in	578.12	181	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4df41507-2c3e-46fc-a67c-8c6711ddebda	erat vestibulum sed magna	932.93	382	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
eb42357c-8d45-4b4d-a2c3-fb8a9678f4ec	dui proin leo odio	93.45	417	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
36626c9a-a7dc-4179-8027-4c3435f1f2f7	lobortis sapien sapien non	208.59	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d87dd82d-0c97-44fc-9577-ad25303dd28f	hac habitasse platea dictumst	799.79	489	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0f1a5116-4be6-402d-a686-67b33912c320	accumsan odio curabitur convallis duis	1810.59	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5579eec5-79c5-4572-b6b1-dffcf872bf64	ante vel ipsum praesent blandit	2224.99	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2138c407-1f02-41ce-8a0b-3d1c0ba645a0	nullam molestie nibh in	2763.37	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d81476a4-8563-4c32-a7a8-3abfdb5e6968	proin interdum mauris non ligula	2616.84	56	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
adc0ce15-2ab2-4adc-ad8e-44624fded00f	a nibh in quis justo	1928.72	376	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a52e2f4e-d07d-4aee-b531-714c0ad0d355	congue risus semper porta	396.10	385	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
08de722c-d87c-4a2a-938d-ede6bc53253c	cubilia curae nulla dapibus dolor	2455.14	346	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
99e055ec-e67c-4dac-9f98-2d14cc4b759b	pede ullamcorper augue a	1251.95	497	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f0c4f875-9bb2-49b1-a2a0-ab918196c5a2	sapien non mi integer ac	218.11	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1d9aebe6-0465-41b1-9509-956807d030cf	lobortis vel dapibus at	2048.95	22	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9382cd8d-9410-4b85-97ca-6288b82a734e	arcu adipiscing molestie hendrerit	5.92	134	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1d7ed714-affd-46a7-9ad1-fe88d38e314b	tellus nulla ut erat	412.72	277	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
411be77c-517f-4f2c-89e3-07281888389b	nunc purus phasellus in felis	1431.92	499	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c1a72083-cf94-4875-923b-86177624a286	ac consequat metus sapien ut	1443.13	378	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7ee24945-3399-4dcb-838f-a9c7cdf6010d	nam tristique tortor eu	2206.77	343	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b2c3bbf0-8067-4c0a-8c0d-2cf646c99ee0	ac enim in tempor turpis	477.01	254	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e935a7d9-de71-436f-a81b-83df2cceb488	massa quis augue luctus	251.78	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
99cbee9d-abd8-48fc-a7a9-1dd7ceb5a94e	nibh in quis justo maecenas	1392.52	111	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8b01af50-26a1-487b-8b2c-120b749d30a3	odio justo sollicitudin ut	1511.95	84	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
329ef81a-ddb7-4583-a1e6-3088e1132d02	luctus et ultrices posuere	2595.79	79	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
41bd3b64-cdf7-45cd-9f90-e3341505c760	non quam nec dui luctus	2905.52	327	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
78b46b2a-8550-405c-88b0-e2619b3d095a	non interdum in ante	2084.98	100	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
91184f6c-6283-4075-b03b-ab164a047381	potenti cras in purus	2442.12	346	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bd45195c-2758-4f02-b57a-53fbac8b4cff	magnis dis parturient montes nascetur	1276.62	21	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a865371d-0f9a-4706-b03c-3263812c7e7d	orci luctus et ultrices	2589.47	221	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
efa90324-2240-43be-ab36-0a1bc0e32ce2	habitasse platea dictumst morbi vestibulum	729.12	144	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
16237e4b-0664-482e-a32f-3d60cc5e6114	ultricies eu nibh quisque	234.07	395	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
525312fd-c86f-4404-b696-6a21f510007a	venenatis tristique fusce congue	809.08	61	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
356dbff0-728f-4cfb-81ca-1aba7a2422f9	ligula pellentesque ultrices phasellus	1799.11	490	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
43fdac1c-18e0-4126-8bd2-e31c1760f22b	nunc commodo placerat praesent	643.24	428	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a2f14642-a908-451a-b35b-214b4726122b	tortor risus dapibus augue vel	2305.81	359	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
536f80ae-a4b3-4301-8acd-e72cce70a461	ornare consequat lectus in est	1830.93	199	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6dd6c04b-c211-4ce7-b72c-c0761a4e14ee	amet justo morbi ut	2315.96	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
685e0f0a-4d1e-4ea9-8a74-58f6156117b6	primis in faucibus orci luctus	2646.47	12	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fe92e40b-77a9-4427-bb39-7b686e50993a	morbi vestibulum velit id	2596.36	138	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5fb10895-43ae-44c9-8307-fcc6ea017588	pede lobortis ligula sit	1779.82	244	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
52885168-97b2-4e13-93f8-92bd9dad7faa	ipsum primis in faucibus orci	2451.32	206	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
42efecc1-d272-4b66-8b03-4dd82b43ef1c	interdum in ante vestibulum	1046.64	278	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
057f73fe-28a3-43a3-9eaf-15ac91e24a5a	eu sapien cursus vestibulum	1951.79	486	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
73237e42-2ebf-4f37-9667-c6ccc0b02675	nec dui luctus rutrum	1773.93	170	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8de4438a-27ee-4dee-8b82-48173ae9c8ec	augue vestibulum rutrum rutrum neque	878.88	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
89e83845-49f4-4dcb-be95-746a2504572e	condimentum curabitur in libero	1315.45	448	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dab8b247-bc37-4c50-9b81-ac7aa596962b	pulvinar lobortis est phasellus	277.62	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
32438594-d5e2-4e96-964d-6b747e805315	quam pede lobortis ligula	680.51	447	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7271e834-4e75-469d-9037-7e8aacd4eb1a	orci luctus et ultrices posuere	1018.22	256	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a7acef79-0b6c-4331-b733-54ce9c2a8e54	nulla ultrices aliquet maecenas	1651.27	299	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75f7715c-75c0-4a2a-b649-b0c6e49d2294	donec pharetra magna vestibulum aliquet	34.78	412	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5b7673eb-0927-499d-be63-0a3c15fe8ab8	ut at dolor quis odio	817.20	246	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
46de7031-f833-4bb7-922f-7012c0da4f14	molestie hendrerit at vulputate vitae	65.45	300	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c81e40cb-91b9-413b-9af0-c52b27eebc22	egestas metus aenean fermentum	1819.18	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c4d12db2-a825-4a54-a6a2-8d7f1bad5dfd	massa quis augue luctus tincidunt	2213.71	210	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
be77833d-47e2-42d5-baaa-aaaefb069827	non sodales sed tincidunt	1471.91	147	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ea564c33-1608-4b5a-a1b0-3d7b711b01dd	justo sit amet sapien	709.68	77	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3b876e1c-0a67-4b21-b70f-910f190ea31b	ac nulla sed vel	107.54	181	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6b8bae2b-61ba-4605-89bb-f68d26b660a8	porta volutpat quam pede lobortis	1994.91	258	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
02111b10-8e00-43a3-a82a-59b332d3cc77	pellentesque volutpat dui maecenas tristique	2431.24	122	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
48572d54-e34b-4791-9e17-b95691b67941	ac nulla sed vel enim	490.71	108	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e8a66c29-6930-45e8-bc04-74979124ced3	montes nascetur ridiculus mus vivamus	671.63	113	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d8b2437a-671e-4b32-a9e7-337730fed7f9	luctus ultricies eu nibh	645.08	190	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5313e723-6857-4786-9992-2256123f182a	at nibh in hac	2742.10	440	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4ed917e1-6310-41bd-b1f0-4513a3b8c1f8	curae nulla dapibus dolor	1555.30	348	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ca94801-5e08-4acf-a654-692b8a559db8	nam congue risus semper porta	2330.23	48	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c871a115-6647-49bd-8a4f-0d1e0fda742c	sapien iaculis congue vivamus metus	1070.90	12	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
978dbe77-6d45-46ac-99a9-a543fff4efa1	vestibulum velit id pretium iaculis	1816.59	438	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aabe6af0-655e-4c8e-b995-b30e52c78100	consequat nulla nisl nunc	314.63	137	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
02130ef9-7d07-4e39-83b4-7789103dfe0c	parturient montes nascetur ridiculus mus	2009.01	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9591a7f4-5431-49d8-82d7-54566ddbbcb9	nullam molestie nibh in	2358.03	401	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ae92a2db-c36a-45d4-90b8-0fc3c018c814	sapien cum sociis natoque	332.68	228	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d8cc973b-ce87-4abb-b851-b83ef3c6939e	sit amet nunc viverra dapibus	237.76	336	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6c777294-54b5-4d1c-935d-a79ab27efa74	mauris vulputate elementum nullam varius	2716.32	301	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b2c88de0-c2b3-4c7d-9012-3cf0a4624070	ultrices libero non mattis pulvinar	2047.19	433	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
23117a1b-3b79-4376-aa5a-d428ebf47e2d	mi integer ac neque	979.08	353	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f9b58e17-4322-445e-9b20-d0750b8c09c3	libero ut massa volutpat	1264.29	260	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c3da0e95-984c-40a5-be8a-19da27e84033	aenean lectus pellentesque eget	1015.53	469	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
04c04857-5dce-479a-a2d2-87e61a214475	venenatis lacinia aenean sit	794.05	183	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9d039f27-429a-4d94-95ce-f740a903b200	non mattis pulvinar nulla pede	505.36	258	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
51ff9784-c1f5-4cb9-8ebd-612344e73ade	dui luctus rutrum nulla tellus	2780.36	88	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7b6dc38b-d444-4921-bda3-16f738f7dc68	platea dictumst etiam faucibus	304.47	251	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
831420e0-0a7d-447b-8009-8c420e48c9d6	sit amet nunc viverra dapibus	10.61	105	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1dbb6073-0abf-4868-a2b2-41733d5d85b2	enim sit amet nunc viverra	1858.68	278	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dc650372-e01c-4852-8f0e-42c9da6eee32	primis in faucibus orci luctus	1563.77	441	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7fbd0972-f9f6-4800-bfca-53cdc4950908	amet justo morbi ut	2026.12	451	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f78e510b-66cd-425c-a1fd-aa9c6cd8fd47	nibh in hac habitasse platea	491.78	429	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5e74dad6-6905-4071-9d02-dab19b8d4776	molestie nibh in lectus	1348.78	135	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
46d6876b-b606-4a5b-b369-23280e6c2fe0	quis orci nullam molestie nibh	958.17	84	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
676fcc0d-3c5e-497d-b57f-ee8fabfa95c8	libero nullam sit amet turpis	1115.66	277	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3c796ee1-f3e7-484d-8659-fa9251c5cce2	bibendum felis sed interdum	679.77	195	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7d3d4da1-e551-44f6-8f50-c062c0e368a4	blandit non interdum in ante	1875.63	386	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5f9ce2ca-96b2-4e3d-9243-9772cb7d6186	in lacus curabitur at	2782.21	393	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0a866c4a-8b4b-407b-9eee-d41b65767b6a	volutpat quam pede lobortis ligula	1454.53	449	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
abb6ab02-a0d7-4873-bfa3-4e10d68b6c9a	ipsum primis in faucibus orci	1053.69	94	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2d7e1e87-2f04-4d18-9369-c6622970661d	purus sit amet nulla	920.84	205	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
910a812d-0b9f-4e71-b753-a74d93721c7d	felis eu sapien cursus vestibulum	1351.45	79	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9951670c-9161-463c-ac20-58201c7ca893	eros viverra eget congue eget	1969.53	107	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
463e721d-3caa-412f-a1e7-78240415f238	at turpis a pede posuere	2198.00	138	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9af2c1e3-9ac4-4581-851e-4631bb1d8ab1	quisque arcu libero rutrum	2425.92	267	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7b36058a-61a4-4bcc-b4f2-e1092aa12fc9	in quis justo maecenas	2883.58	443	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8f1f4898-74f0-41a2-907a-0e82e0cb2ed6	amet justo morbi ut	2839.03	310	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
63a6de5e-22b4-4314-8981-ba22992c63bf	a ipsum integer a	1105.64	186	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f4247160-edd1-47a0-ac1e-b52069c11582	est phasellus sit amet erat	433.19	365	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a571ee56-1436-4637-a34b-39b35356e009	vulputate justo in blandit ultrices	1757.31	166	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7ed809ef-5f5d-4e5a-b537-acc589b4dfdc	pellentesque ultrices mattis odio donec	2195.26	336	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c9fb3074-44be-4f28-a5f0-17cdaf1e5d63	donec quis orci eget orci	2276.63	446	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7f72cfc7-633d-4d9f-a31e-e0424be358fb	sapien a libero nam	749.14	452	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6ad019da-5023-4083-b0c1-193ed3bec8f1	morbi non quam nec dui	1798.89	111	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
53f1fb75-11ca-4299-858b-372f04dca7fd	rhoncus mauris enim leo rhoncus	1101.45	304	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d296070-64ae-41e8-9999-aefb490fca22	at turpis a pede	1098.40	70	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fd22ea45-0b26-4d83-9d24-0c09ae8e9a98	turpis elementum ligula vehicula	1244.81	434	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
55adb5e7-144f-46f2-8b39-88d376859a6a	primis in faucibus orci luctus	1083.11	218	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f634f51d-2cea-4f75-90e2-d380d6a9195c	ultrices libero non mattis pulvinar	769.10	47	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
636633c1-3d62-4b6f-9154-4ed3fc8595d5	praesent lectus vestibulum quam sapien	1286.34	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d7707eed-1a6f-4d82-bead-cd182f3541c0	rutrum ac lobortis vel	2526.73	243	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a04997a5-3598-4ac7-8929-df0a47be7a71	vel augue vestibulum ante	799.45	253	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5d225952-d37d-4352-a096-35e8e555604a	erat nulla tempus vivamus in	1969.27	500	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
36131294-16e8-40fa-94f5-5fcc003336f8	maecenas leo odio condimentum	2325.16	160	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1d32f141-7b63-4c15-b4a6-8167d6ddf351	nulla neque libero convallis	1963.62	139	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
badbf107-01fd-4376-b55b-b1ffc7c8735f	justo aliquam quis turpis eget	2220.53	98	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f5531274-e84d-4232-8062-8f89904b0a9a	sed augue aliquam erat	2645.20	168	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c2ac6955-d1f2-40e5-866b-384d2d77dcf6	at nibh in hac	1791.06	464	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8a29d493-f190-4d23-b87f-f5a4a87c3cad	mi integer ac neque	2097.13	264	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
07255a53-2da9-4f48-a69d-639507f6118d	urna pretium nisl ut volutpat	2525.23	494	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f33cdff5-133d-48ba-9442-c3f1f0b84bdf	lacinia erat vestibulum sed	925.48	379	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6631f6a7-c5b2-418a-a2a7-23c2d463ed73	lorem ipsum dolor sit amet	1524.73	142	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f2223d9-a061-49a1-9c99-03119a08763e	ut blandit non interdum	972.12	429	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
77e2a768-b896-47a9-847a-07254252ea0e	eu mi nulla ac	1727.21	125	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bee98622-9bd1-490e-ad11-8058c4256166	vivamus in felis eu sapien	2826.18	229	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c110f3b0-4c75-4fee-a723-118fa839b84e	duis aliquam convallis nunc proin	2620.66	150	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dc995feb-0c4b-46dd-83ee-bedda7f27956	in hac habitasse platea dictumst	506.10	448	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d8eb83c2-5476-448f-95eb-8814096493c4	sapien dignissim vestibulum vestibulum	1207.67	340	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9f46816d-e9aa-4dc8-9ce4-4fd5079b4cd6	ultrices mattis odio donec vitae	2599.87	471	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
17b870d0-6707-45c0-bbae-2b68ceb1f357	ultrices erat tortor sollicitudin	452.82	51	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6db11ded-e71d-430f-b297-f7e9a8f1890a	mus etiam vel augue vestibulum	46.83	470	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2163a0f0-9c62-437b-967c-e1ac10d7ee1c	vel nulla eget eros elementum	310.55	34	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
17706b23-4371-4a27-925b-937740976d32	magna ac consequat metus sapien	9.39	214	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6d379f9d-2411-41f9-8b56-ac87157b7574	condimentum curabitur in libero	941.48	276	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
10315f77-07b4-4b7f-91e3-2ad0065106b6	cubilia curae donec pharetra	2821.85	348	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dfa140de-29e1-4d71-a7c8-9fee44141e4b	nulla suscipit ligula in	645.81	262	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
86eb1621-d103-4562-bb6f-0cfe8c9a4421	platea dictumst etiam faucibus	433.08	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75abba00-6208-40f4-80fd-a914bc24dc12	donec diam neque vestibulum	2029.18	128	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
39af329d-2faf-4395-8ba7-535006a4a640	luctus et ultrices posuere	976.15	156	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5537b5cd-974c-4232-9f90-dde2a70619bc	nulla tellus in sagittis	907.00	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
43eda1a7-ba23-4a06-b41d-f95a25e9f91a	nulla elit ac nulla	597.01	9	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
abeedc0e-2150-4a9f-865a-044ac8ed9e41	congue eget semper rutrum nulla	352.32	125	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fa3272e9-1d81-4855-8ec7-605895884f33	proin leo odio porttitor id	2440.46	256	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d3839398-cd1d-4451-8ceb-c07ffef517b0	et ultrices posuere cubilia curae	2949.86	7	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6b9edb41-cbae-48d9-bfcd-10b65500fe3e	lorem ipsum dolor sit amet	923.03	187	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b19683b3-ab17-4746-9e07-440b6db949fe	lorem id ligula suspendisse	2803.58	361	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
26ac899c-ced3-47bf-8419-1617e9e07792	aenean sit amet justo morbi	2174.04	422	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3e34ea2b-557e-430f-b6a2-81f8e4c33dea	vulputate ut ultrices vel augue	1265.79	146	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d888f1e9-3e03-4db5-93c2-1f6ae57cb63e	cum sociis natoque penatibus	2256.49	305	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b40df738-023f-45b3-8b08-7f8f9f66f600	sapien cum sociis natoque	1338.78	341	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bc71e17f-bff7-4ef4-bfc0-3c53fa41cad1	tortor quis turpis sed ante	1187.89	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
430f6e5d-6537-4ebb-96e5-aeb0777827fe	parturient montes nascetur ridiculus	113.62	166	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
eb81f861-2147-4bb2-ada9-caa72cd0cd9d	duis bibendum felis sed	1663.65	326	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
31870e01-19d5-4b77-aa17-9be9142218d0	porttitor lorem id ligula suspendisse	2680.92	239	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e85d3e7e-015a-4c9b-98d3-81e76e653386	sagittis dui vel nisl duis	787.94	63	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
252cd84f-df50-4c7e-a73f-8f47e7c063e4	nunc vestibulum ante ipsum primis	1965.34	440	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d781d9ee-a23a-4bad-aa1f-ec51c7b98b5c	leo maecenas pulvinar lobortis est	1377.57	386	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7e28a8eb-e0a0-4fcd-9432-4a4142b93364	maecenas ut massa quis augue	2811.48	330	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c375ccaf-0bf6-4f07-9e71-00a068a33aaf	duis bibendum morbi non quam	695.28	408	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8534c7b4-3f09-403f-bb45-3b6241ee860a	dignissim vestibulum vestibulum ante	1040.61	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
58d8e644-eeec-4506-a7b2-397b94088d39	vehicula consequat morbi a	2241.54	82	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
647b0808-e8eb-4167-88e6-106f0af62c7d	auctor gravida sem praesent id	2696.43	394	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f3ea27c-9d55-4fce-adc3-9197e9274c24	at ipsum ac tellus semper	1093.73	241	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7a8bc5cc-632d-45d0-8549-66fe93475acc	dui proin leo odio	66.68	382	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5835c521-b454-428b-a9ba-bc1b20d8d681	nulla elit ac nulla sed	1913.15	43	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c089edcb-9113-4eec-8083-c2c56dd4ee24	at diam nam tristique	1563.12	135	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0dd1f0be-83c6-4475-b0ad-e139e2fd6562	odio donec vitae nisi nam	1424.33	20	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7de85b6c-8a49-46c5-aaed-5f440dad07f2	sit amet consectetuer adipiscing elit	1921.39	246	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
64979d06-6350-48ee-9931-f5e895d3ccfc	justo sollicitudin ut suscipit a	150.21	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
37fa7e9d-79bd-4428-8772-04e080033aa4	sagittis nam congue risus semper	2880.31	285	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
af6b0b44-8998-4a55-b5f2-9b9ebc974dcf	nullam orci pede venenatis	1160.65	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7a4e99c7-87df-4c6e-bbb2-2f181600c5b4	praesent blandit lacinia erat vestibulum	2174.79	172	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
988c7970-c1c1-4287-86ed-4ebda06e707a	sociis natoque penatibus et	2479.40	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
050432f7-2bee-4145-8847-a5426907a9de	id justo sit amet sapien	804.50	332	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f6831c4d-01a8-4471-ac47-b4de6fd26c34	congue etiam justo etiam	2428.92	466	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75fb9932-0412-463e-b047-9ef586a472b6	et eros vestibulum ac est	329.80	476	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
acb1fcc1-8d7e-41b1-98ee-1133cba32242	penatibus et magnis dis parturient	2592.15	373	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bdcdcd5c-c2b2-47cb-98c8-a12c8bd36fbc	a odio in hac	630.01	183	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5b2376e3-ced5-47e6-b110-771f51287033	lacinia erat vestibulum sed magna	2815.98	286	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0a561629-6faa-4571-a7eb-d47ada634332	nullam molestie nibh in	922.76	358	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fa58b147-cbd3-4b5e-8515-6259a5d08e32	vivamus metus arcu adipiscing molestie	100.98	70	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b27bc8b7-4b77-49c3-8566-c6a9b005907d	eget eleifend luctus ultricies	648.00	243	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cff573bd-1ac2-4710-a91a-b86b26f172d7	vestibulum ante ipsum primis	2535.67	259	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d082510-2d25-45c5-ab63-09578063bd42	ipsum primis in faucibus orci	2046.46	437	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
77de7ac2-2c19-472c-98c0-6f56e2004db2	in magna bibendum imperdiet	341.92	459	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fdd2b008-7d68-4b62-9177-d946e5761288	ligula in lacus curabitur at	2336.08	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
be6e3ada-368c-4173-9e73-fc99f2d5b20e	eu est congue elementum in	1695.92	16	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9e343fbe-d188-43c7-aae5-034b69c48952	est donec odio justo	751.81	14	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c6a7491b-19f9-49df-937e-650f15262690	sodales sed tincidunt eu	2053.49	15	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e0024d12-9869-4fbb-9a71-da35bea19fcd	blandit ultrices enim lorem ipsum	1513.33	206	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5f031354-7104-4787-8509-9f923d36b792	molestie lorem quisque ut	1060.93	259	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1263b64c-172c-4256-8cf1-1175bfeb1ede	mus etiam vel augue	666.95	451	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
24e41afa-9161-4715-9372-14de21ddfa1f	mi sit amet lobortis sapien	1659.36	370	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75a131a4-f92c-4efe-ae1b-e8ec24c6de21	nisi at nibh in hac	2210.99	69	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
72c06a77-f84c-4691-bba7-23b68c7562d9	ultrices aliquet maecenas leo odio	2921.55	108	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c097b7fa-ef04-43e4-b3fd-6a6429ae6e8c	nec euismod scelerisque quam turpis	1766.94	246	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1cb84abc-2cbd-4772-88cb-9c1bc1d2eca1	id lobortis convallis tortor risus	1993.24	409	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ecf1efc3-4c8b-4dce-a60d-e569c007749f	ultricies eu nibh quisque	1019.21	362	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
13404922-32d4-4b7b-93fe-08f504436a82	non velit donec diam	2819.82	116	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0ddcc716-22b8-4b71-8deb-24ad5844df78	eget massa tempor convallis nulla	790.19	436	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
88bbba47-4ee7-4b40-a9ca-cc189c6567fc	iaculis diam erat fermentum justo	2309.82	240	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e75a724b-b522-47e9-8475-f8f74181c1c6	fermentum justo nec condimentum	2131.05	314	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4e310021-e795-48f8-95f0-c106494cb015	vitae nisl aenean lectus	399.33	186	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a009fa16-adc5-4dff-aef0-33eab2015e8e	ac consequat metus sapien ut	226.16	11	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5dc3359a-848a-41ea-8c69-28e6e255ddc0	ultrices posuere cubilia curae duis	313.30	438	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a78bcf16-ef7c-4b5e-a7cc-b77d0c780c2a	felis sed lacus morbi	1411.72	274	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b87cdb86-a8a2-41c0-9330-030ba505895d	ligula in lacus curabitur	2823.87	383	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8e7a5f95-f1e6-4270-a55d-dae16786806b	lorem id ligula suspendisse ornare	74.36	500	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f64cee3c-08bd-4621-84d4-3ba2a3c17bf6	dui vel nisl duis	2910.98	310	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3eb8f8f8-3249-4109-acd5-d6d6dd9a2c03	ante vivamus tortor duis	2270.28	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dbc90d6d-bd76-4d68-860a-feae43bd1238	ut dolor morbi vel	817.33	306	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
841b7e04-50c4-472b-a915-2f0e108cce3d	praesent id massa id nisl	2888.11	432	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b9434108-7ef0-42bf-9f20-80d74059c1a0	sed tincidunt eu felis fusce	1702.43	218	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9d08ff83-b53f-4ca4-9df5-2d02e9604aa0	in eleifend quam a odio	2133.36	490	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5298a3f5-5f31-41b3-af22-7fd5aca2e5be	viverra diam vitae quam suspendisse	272.45	213	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7cc1d67b-d5d1-4a4f-a483-dc1a79c88538	vel augue vestibulum ante ipsum	1458.14	149	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
30381c58-d8b1-47f4-a6a4-2c62bb899633	nam tristique tortor eu	915.06	275	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
627279d7-1ca7-47ca-9af8-06b27bff9d10	congue diam id ornare imperdiet	1230.07	378	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d83a025-5e63-492f-b4d3-411c4eaa5161	vel accumsan tellus nisi	1477.63	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
73796226-26fd-4bf4-bf3a-0fe57d1c0765	accumsan tortor quis turpis sed	127.20	37	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
49d33abf-57a4-4c58-bce0-ab6a700fc07c	sed tristique in tempus sit	1327.96	197	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0f0ff4ee-abfb-4c21-b535-c5dbe857dc12	lorem quisque ut erat curabitur	2776.22	237	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7cbac387-ba27-4696-9b12-08dbbbe2d631	sed ante vivamus tortor duis	533.20	286	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
27a57e29-9044-4910-8ceb-6e40fe7b52c4	urna pretium nisl ut volutpat	342.90	441	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9e0ccba2-556f-40f1-9eaf-cdb4d2c15c30	lorem ipsum dolor sit amet	2307.71	395	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
675c3505-b139-4155-a162-13f7bcf9c5bb	et ultrices posuere cubilia curae	740.14	123	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f24f6a07-8c60-46dc-9238-4a71725cb34a	pharetra magna ac consequat	1547.35	481	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7cb3179c-ca2c-4b60-88ce-300066649462	justo morbi ut odio cras	197.86	423	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5f60a03b-aa48-47e3-8001-58fd01a8c0af	consectetuer adipiscing elit proin interdum	2618.62	101	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9d108fa9-0eda-4747-847c-2557ebd3e468	ut nunc vestibulum ante	814.18	217	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ee8b33b7-8db8-4491-8c99-1204dfb9f6fb	eget congue eget semper	1276.64	235	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5dfd9857-fa8f-4524-8b5d-f7d14823b183	cubilia curae donec pharetra magna	858.31	237	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aebf681c-0b04-4393-b847-9142c6e33b9c	et commodo vulputate justo in	2798.45	98	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
67cfddcb-98cd-4580-a845-be518779ded0	maecenas rhoncus aliquam lacus	2462.28	297	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
87d06221-5ca5-4779-b8e0-bf72cd6e2795	pulvinar sed nisl nunc rhoncus	2486.71	115	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6cde8001-cfd8-4c69-a25b-b5327083ce49	sodales scelerisque mauris sit amet	1387.06	322	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7c85c03a-5311-41ce-9f14-f6914502bf68	nulla ut erat id	1714.45	446	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b885d6a5-df0f-466d-94c1-c2f270550b76	diam nam tristique tortor	1463.80	371	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1e1400eb-3748-4978-9953-a905d2e29e9e	et ultrices posuere cubilia curae	1590.89	445	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8990ec74-9c29-4456-b1bd-9c648276ba1c	diam nam tristique tortor eu	2690.91	39	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ffe792a1-957c-4a1e-a728-45917cc2213a	enim lorem ipsum dolor	2074.27	460	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
79c4980d-3a3b-44af-bbc0-8cc531963d79	volutpat in congue etiam	2253.96	471	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
439736ae-d847-4c03-b0aa-1d0c018f8ec7	massa id nisl venenatis lacinia	1718.59	405	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fc6bb273-6c79-4da7-9bbd-902c36847259	amet sem fusce consequat	952.24	482	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5d70a7aa-cb6e-48c1-9e6f-dd4df453fadd	justo morbi ut odio cras	247.36	231	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f493aa7a-aec6-47d6-8be6-182d308b904c	at nulla suspendisse potenti cras	586.07	333	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1d0ca8ac-a720-45b6-9fb9-6c7c1c8c4557	purus eu magna vulputate	1522.81	264	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f47e35e1-698a-4a8c-9db8-128f82ea6d5d	non velit nec nisi vulputate	2698.19	173	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
af2a2d7d-edb0-49b2-ad2a-dfb0d68b822e	vitae nisi nam ultrices libero	1437.26	356	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f9621d19-b8e1-4501-af75-eb6f9d039552	at dolor quis odio consequat	1384.09	183	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2cac94f6-f439-4a4c-9f09-75eb1f99f0db	hac habitasse platea dictumst aliquam	685.95	267	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
436eb316-6fca-43bd-9aa2-345440016680	interdum mauris non ligula pellentesque	1003.73	476	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a7cff05a-8292-4747-8a9a-9905edf4c651	fusce consequat nulla nisl nunc	1310.41	104	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0e00734a-47e7-405a-a378-2fa08cd88107	in hac habitasse platea dictumst	2046.65	335	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
caa6bc73-fb21-4bad-8f74-611730b8ed99	nisl venenatis lacinia aenean	1253.90	171	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e07fe63a-e903-4360-852d-300a8cd9e1db	arcu libero rutrum ac	2826.19	352	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75423bf9-9773-4e43-a7dc-869dd3830e92	neque aenean auctor gravida	2992.29	244	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cf788532-795f-4659-ada5-b04433a377ba	posuere cubilia curae donec	930.16	416	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7b9e6416-f965-4255-9f0b-b4dfc27b980f	duis at velit eu	804.67	161	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
acd0bf2f-72b1-43b6-a0cf-afa10add5ddf	at velit eu est	2910.82	338	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4ccc4ba0-062c-4e39-bae5-7c9970cb9945	lobortis ligula sit amet	2308.01	323	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
51df7af3-1a5f-4802-a9af-7f8255ed2251	eu mi nulla ac	1830.08	33	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dc3c4bdb-d9e6-47b0-b642-cd10d9f663ff	ligula pellentesque ultrices phasellus id	2207.02	149	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
759ac7fe-7f3d-4afd-ac5a-6872e587ea91	nibh ligula nec sem duis	2877.14	352	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7e00c2fc-5dba-44dd-b87b-7aa2e087fedb	tempor turpis nec euismod	64.65	162	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
603e65d0-ecfa-4601-9ae6-931c14e772a4	ante vel ipsum praesent	929.75	494	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0be61747-18b4-4024-9b9d-6066bd9939a5	consectetuer adipiscing elit proin risus	2439.66	319	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4227498f-71e0-42c4-b383-ab5cfefdc975	tortor risus dapibus augue	392.42	123	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d41c2e97-0aa8-4cde-a49a-97dbbdbdaeca	magna at nunc commodo	1166.44	206	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
73403e11-e047-4d98-bd44-b30ce4dddeb4	imperdiet sapien urna pretium nisl	656.85	25	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0fd70815-cee5-470f-8b7b-37c3fbb1b4fc	erat id mauris vulputate	1867.34	202	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d8d4082d-189e-4269-bd4d-b8a3527eaefb	aenean fermentum donec ut	1570.84	402	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
05b31b6e-e489-4c9a-8976-cc6acfb7b161	congue risus semper porta volutpat	226.89	343	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
90f27124-bec5-4f09-9d53-634414404daa	ipsum praesent blandit lacinia erat	551.27	171	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
719993bf-3a56-4afe-b749-4954fe4ab27f	eros viverra eget congue eget	1845.76	437	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
634d0cde-b191-497a-9977-8bb037147b0b	congue risus semper porta	2595.44	315	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
07bd80db-59c8-4656-9564-d5f2910712ea	ipsum integer a nibh in	872.29	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2309e007-c814-4f0a-b5d4-f7a5cb7175b6	sit amet consectetuer adipiscing elit	1579.83	58	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f686b3d5-1fce-4c27-91a8-3bd4b6ac3e6a	integer tincidunt ante vel ipsum	309.34	306	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f75153fb-81fd-4adc-bd1d-9bc21c5ace09	dictumst etiam faucibus cursus urna	948.82	79	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b472815f-8199-4a3f-9ffd-e41be8e606b9	sapien cum sociis natoque	2709.43	78	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
80206439-d96d-46cb-8d18-d06baf05ea36	accumsan odio curabitur convallis duis	1563.25	437	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a89be87a-2d8d-4a07-9ba2-f1a87dbceeab	proin eu mi nulla ac	1391.90	122	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
841799a8-7865-4d0f-8067-48fbbd7e5e7e	turpis a pede posuere nonummy	1239.84	208	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ffbff3af-ecd6-4d7c-a5e6-a8d511ae2334	convallis nunc proin at	2760.79	85	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1445e51c-61bd-4bba-84ee-22b3d6034aa6	nam congue risus semper	255.29	358	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
800d96a8-b4d6-4a3d-8ace-c0c214669238	in imperdiet et commodo	2692.57	247	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a394c179-ff81-4ac3-b42f-4fa7b4d09ee5	orci pede venenatis non sodales	572.56	30	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cacd951b-2ee2-45d8-bff8-f3d08498e804	eget elit sodales scelerisque	853.75	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1cfda4fa-aaa5-40b7-a4f5-30a6ee857a5a	dapibus dolor vel est donec	1122.29	493	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f6d9030b-fce6-4d21-a869-e7adb7f82cc1	rutrum ac lobortis vel dapibus	173.36	94	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3470c7b1-d741-413f-858d-d49c2ab0dac2	purus phasellus in felis	2906.35	402	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e7ce8a49-0deb-49fb-bf46-587dd7b24e36	non interdum in ante vestibulum	2769.59	142	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ce542f08-c868-478f-bde6-5e5db60c20ab	augue quam sollicitudin vitae	339.80	201	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c0e03395-6d27-423d-a275-ba997b04c267	diam vitae quam suspendisse potenti	2437.64	80	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7347cf20-6c94-4b73-ab81-2147533a2b91	id luctus nec molestie	360.62	92	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
49bf1177-bf4d-4d28-97b8-204c7ca33dd9	sit amet nunc viverra	2871.69	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9ad8c55e-cfef-440d-94e5-b5c2ad7f5859	lobortis sapien sapien non mi	1089.04	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
29831035-def5-427e-b2cf-1b870011f3f9	a ipsum integer a	2877.80	143	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f69480a-a24e-445f-be33-571a96e23e13	quis odio consequat varius integer	1742.23	344	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5ed6762e-cc7c-447b-935a-7aa018a64ccf	congue vivamus metus arcu	1161.20	134	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
12a3e1ab-f75a-4bce-bedb-b39148d81cc4	cubilia curae nulla dapibus dolor	493.55	216	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
65c0ab7f-24fb-40bc-87f5-b5829a108a71	curae donec pharetra magna	394.14	323	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f608654f-7d29-452a-83bd-36c0d56f04e4	ante ipsum primis in	2971.67	246	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1c2e1ad8-af4a-43b2-9a7d-2f46905eb890	non mauris morbi non lectus	1038.57	153	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ef4ed276-3f1d-4d7b-aaab-4a06777be9eb	cras non velit nec nisi	909.69	52	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
509da523-0dcd-4f76-97a1-ec35562b60cd	scelerisque quam turpis adipiscing lorem	2194.30	222	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e7f0c539-2930-4377-a02b-ef1af9a49026	tempus semper est quam	103.45	252	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
64c6dfed-e411-4eb9-a9ed-bccfba268180	quam nec dui luctus rutrum	614.97	317	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4022c33a-8863-4bc7-9ea6-7b2b2b830453	erat quisque erat eros viverra	1550.53	97	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d5ca5f7-3864-4fa4-9037-055ecb2ab397	quis libero nullam sit	2576.63	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3a7f861c-b3cc-4086-9e7f-40b7e0e4e2cd	ipsum integer a nibh	1492.29	154	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e747d9f5-9165-4d7f-a824-2539a1a64b08	eleifend donec ut dolor morbi	910.60	322	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1f2f7bdb-175c-439a-b1a5-544fc834fcd1	potenti in eleifend quam a	525.29	113	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
74baed34-5bd9-4797-ba16-64c96ea776f4	eget congue eget semper rutrum	1959.37	63	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b6677ddd-5bd4-40fb-add8-8e19d37a5dab	lectus in quam fringilla rhoncus	1838.55	243	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b0636ba5-8172-44fa-814e-56fd191ed72c	faucibus orci luctus et ultrices	1453.06	229	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e9107d48-386a-48b3-b23d-76fcf499f5f1	in faucibus orci luctus et	1545.77	286	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d62ca090-da75-414d-bc20-2aec5141f470	luctus et ultrices posuere	359.71	463	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b2796699-cb23-4419-8ca9-ee5e83e900e6	quis orci nullam molestie nibh	696.92	122	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
841f34dc-a86e-4f1a-9c41-0a66ae0b29c0	proin leo odio porttitor	2505.83	136	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6b5ef984-fc98-49e0-871f-b7186607c3d3	tempor turpis nec euismod	225.85	90	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5d1c38ff-7d42-4b8c-afd9-693c634cdbb9	ut nulla sed accumsan	2841.26	34	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6199b152-5290-426e-9731-ae4cde532bfb	nulla ac enim in	2047.82	224	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
337faa7d-82fb-4049-bcf1-e0f5ec4bfb68	lacinia erat vestibulum sed magna	1556.56	236	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ca472c78-183f-4c25-ac4c-4905a2af32fc	hac habitasse platea dictumst	1970.96	173	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
91dc74ec-7d5f-413d-aabe-aea64403006a	tempor convallis nulla neque	1597.32	312	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
eea66eac-ec69-41ad-9f09-bda437c36500	ornare imperdiet sapien urna pretium	332.59	92	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8db519a9-5fcd-4378-bcb9-6d3ec9e2c114	phasellus id sapien in sapien	668.69	404	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
50e4f74a-a750-4ab6-b4ff-7f680f604249	justo pellentesque viverra pede	2664.91	91	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d3ea9f78-f866-4f13-bd3f-3ecdd4c8ad7b	in felis eu sapien cursus	2408.79	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
764b0075-9267-4393-a044-298cac24410d	ligula suspendisse ornare consequat lectus	2895.13	465	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
191240d3-a9a5-4e4e-a86c-96937e015034	eleifend luctus ultricies eu nibh	1035.66	147	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5eb24da8-573f-4682-bbd9-9c03f2eac2a6	erat volutpat in congue	2837.56	380	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1196c8ed-24dc-4ca1-8001-af34b8282a2f	amet nulla quisque arcu libero	2826.26	181	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
71021f34-e6fb-48a5-a128-5f9a82263ed0	lectus vestibulum quam sapien	244.40	254	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fba6d988-0239-45ce-9863-9520aef4b3f6	eget orci vehicula condimentum curabitur	2775.99	34	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d0568fad-6695-41ab-b16c-fc9c47ccc21f	morbi quis tortor id	364.21	415	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
349e25f0-b0ba-4555-a7b2-47343ce61896	integer tincidunt ante vel ipsum	475.58	431	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1c904265-71c1-40c9-8dcf-faa1f9f075e1	sapien in sapien iaculis	591.07	159	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9565f7a1-cae3-4d2a-87db-c656ac705b65	eu felis fusce posuere	1581.26	393	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d92462f4-d0f9-45cc-a17e-8a0abc992ccf	magna vestibulum aliquet ultrices	2299.04	52	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8e9f7564-7d74-4852-a5fb-24627acc6615	consequat in consequat ut nulla	965.01	345	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c51d890d-f207-44ea-9d04-c039cf3d6dd5	magna bibendum imperdiet nullam	1574.89	475	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
41bcbe47-f1e6-4f71-a98e-88bb5beb1f32	enim leo rhoncus sed	2233.29	13	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9ef6abea-4257-4f93-b097-4b27a4de5081	nibh in hac habitasse	2653.68	28	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1ad9d18c-2c66-4b7e-8a06-e83dae22239d	mauris morbi non lectus	430.65	323	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
716cb29f-2b54-4eb2-9d2f-82eb248eca72	nulla nunc purus phasellus in	243.66	363	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8ccb0951-19d5-4561-8e69-4c827cc20f60	nulla suspendisse potenti cras in	483.93	168	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
81fb946c-0924-4f49-b172-7d321746b6a7	in faucibus orci luctus	2116.68	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
94de5b8b-bf70-4e04-b88f-60fa5052210b	in hac habitasse platea	1203.24	155	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
032f0961-4192-4b48-acbb-a74e7a1d226e	a odio in hac	2737.98	482	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6eeb9ad3-c9f5-468b-acb0-3bb6773fabcc	pede morbi porttitor lorem	849.98	151	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
95fdab27-0aff-4ae3-af8b-3fcfc6220729	aliquet massa id lobortis	910.40	51	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6a272495-c7b0-446a-ac47-69f5d91e4f26	imperdiet et commodo vulputate	1352.24	106	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
449d5f97-315e-4a4e-af32-df159c3391f7	fermentum justo nec condimentum neque	160.20	279	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
24eec193-7ce7-48cf-92de-9826d32b8901	ipsum dolor sit amet	2922.50	457	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9fca81b9-db26-4b28-874e-1750710cbf3b	vestibulum ante ipsum primis in	2529.19	298	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
595a5345-7966-4d57-886a-102c21c3eda4	at diam nam tristique	1025.41	207	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9ea6300d-c39a-4e7e-991c-c5772ee95795	aliquet ultrices erat tortor sollicitudin	514.43	118	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c02e1b6d-eaf5-425f-931b-1a3af2175c32	nulla elit ac nulla	1963.26	224	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fb808fd7-4048-425d-b811-16edd84f5cab	et ultrices posuere cubilia curae	498.74	49	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fb0a123e-0eac-43c4-b79f-ebbf6a3e2644	velit eu est congue elementum	855.05	388	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f8ae2130-79d9-42d0-992c-43d9cf1a0688	velit eu est congue elementum	86.30	438	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
752a4864-78f6-4f0a-a899-2df7627aaac1	orci luctus et ultrices posuere	1655.24	287	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a1e07210-4263-43e4-ad1a-5bd3b012991e	felis ut at dolor	1422.59	194	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cfe81931-7e8c-487f-bbd7-50dac37d4910	placerat praesent blandit nam	762.59	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
edaedf56-d5e6-4471-90df-e6cf1e028976	maecenas leo odio condimentum	1536.24	90	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
85e68321-7895-4d1f-9e05-28a2d824c984	turpis sed ante vivamus tortor	905.05	412	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fc8576b4-05cb-4469-bb22-7286c11c4107	enim leo rhoncus sed vestibulum	74.50	44	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e72277f0-d084-48ab-93be-36bb4c2f1c9d	risus dapibus augue vel	260.37	430	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9b7d79c3-4d67-41e0-afc4-33ad9c0ed7c5	nibh in quis justo	1940.75	57	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
350afe49-c3e0-4a97-8d8f-310e04a311b0	ultrices posuere cubilia curae	1456.27	191	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
628570d2-cdaf-4cdf-8913-a3c5d230073f	nibh ligula nec sem	2327.03	131	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d414609e-4f02-484f-a064-7f047dbcfbeb	dis parturient montes nascetur	565.86	194	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3e40bf78-29b5-4a0b-bf2a-d19f1cf071a3	sed vel enim sit amet	535.93	216	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d9b51dc-c675-4f6f-a1c6-d63fa893cadd	donec semper sapien a	1866.33	309	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a80d9152-c403-446a-8910-a0717ac547e1	ornare consequat lectus in	1883.95	372	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
280697f2-83ef-479f-a96a-fefcd055b0be	aenean fermentum donec ut mauris	2436.89	6	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2319c429-263c-43d4-bca0-7f7e22971c3b	nunc viverra dapibus nulla	1247.56	85	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6656b6cc-5f25-4c92-b0cb-8fa0b3aab6dd	hendrerit at vulputate vitae nisl	688.85	384	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
50d5fe28-104c-4636-a8d3-478901f022be	vestibulum velit id pretium iaculis	1302.37	422	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e6f4d25f-cdd9-44ce-820e-ca525faf879d	adipiscing lorem vitae mattis	1011.01	284	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6254c18f-5485-43a5-98fb-2e85e1a91afe	condimentum id luctus nec	1012.34	104	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f2c97c44-10eb-4bf2-b021-d6806ada9794	dapibus at diam nam tristique	2920.22	435	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bd895a29-ec6a-43e9-b05d-b747bc7c1ac3	ac diam cras pellentesque	702.49	205	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e0c24143-c277-4e34-a7c8-db1fc9905c89	eleifend donec ut dolor morbi	1553.47	28	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bb353bdf-b32e-41ff-b04f-93cd52192837	ipsum ac tellus semper	2173.31	272	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
451c146f-adbb-45b2-baa5-a122aa08d5fa	feugiat et eros vestibulum	137.01	361	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
46f455c8-0f16-48a5-81ba-5ec3954da241	scelerisque quam turpis adipiscing	1252.26	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
525c58fe-d14c-467b-90d8-4b5fe605dbde	mauris eget massa tempor convallis	319.14	267	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0f37ed0b-4210-42e3-849f-4ea529319e73	nisl aenean lectus pellentesque eget	1907.39	165	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d42e90f-73e2-46ab-8fa4-0757172c2dd6	blandit mi in porttitor pede	983.24	262	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3dfb6349-7d5f-41eb-8139-ef0625f06a40	porttitor id consequat in	808.70	71	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d41c977d-bf05-49a6-b419-0b7496f86f41	est congue elementum in	1972.42	359	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bf052005-a645-4f23-b7e8-9b4c039e3022	vel sem sed sagittis	1892.14	0	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e551bf7e-0257-4ff9-9c5e-c601a29787d1	aenean lectus pellentesque eget	454.17	269	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
39025fe1-ec48-4cae-87d3-a64035089538	odio cras mi pede	942.83	307	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f7c6adb9-957f-4ff9-ab19-a8471a6ecc66	at turpis donec posuere	2241.22	382	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a59d762f-97f5-4080-b4f4-9aa9b2b02d36	aliquam erat volutpat in	2811.11	227	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6d33ee77-15a3-44b5-ac00-0f3fc0a4dd6c	rhoncus aliquam lacus morbi quis	912.40	324	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
44db39b5-4967-4538-8af1-1981d6846d0a	ornare imperdiet sapien urna	1136.74	311	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db64b86f-1258-497a-969c-de973653f308	vestibulum eget vulputate ut	319.25	136	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
428e93e6-01c2-42a0-a995-ed41d3998734	donec quis orci eget orci	2984.81	133	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4117ed09-68b5-4cfe-aed2-7e4d8e1b0f12	lacus at turpis donec	2251.06	223	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
89277d81-2812-4ef4-8b07-f9869603815d	dui luctus rutrum nulla tellus	2057.03	342	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
94a4b3aa-2cf2-4f79-9bfe-1e59896eacf0	mauris viverra diam vitae quam	652.72	383	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e5055dc0-3bbd-438a-8ff5-921d70643ac7	at nulla suspendisse potenti cras	2933.73	251	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ea3aaa06-10a3-4c1d-9daa-a973be6ed558	in congue etiam justo	2543.81	315	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a5c886bb-dda2-447a-bcff-dd304e8e85f7	lectus vestibulum quam sapien	527.71	4	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fc2abc4e-e4c2-420e-bd65-6428278e3841	donec pharetra magna vestibulum aliquet	1372.98	388	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
25dbebc1-c41d-4e42-a4c1-fdc78888a14b	in imperdiet et commodo vulputate	1943.65	202	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ca326115-3c26-4311-9daf-04c1954c2538	leo rhoncus sed vestibulum sit	2466.93	440	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ff7620ed-ed9a-4893-9cd1-10e78696e6c4	praesent id massa id nisl	1024.95	97	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c02cd2ff-f382-4b9e-83ae-c2efb8204954	nulla dapibus dolor vel est	981.42	113	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e3f360dc-ca43-4d24-9063-8c9734ff9178	lacinia sapien quis libero	2313.03	297	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2eaed555-a3a1-4a7c-ae53-0c6fffbe6f52	molestie nibh in lectus	2569.59	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bbd343e0-6245-4cd0-965c-0993381a2d72	fermentum donec ut mauris	29.21	13	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
108eb6a7-0467-4283-a1a8-c73da5f0ce5c	turpis a pede posuere nonummy	2099.46	445	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
075b7006-b602-4ea0-a2ee-4b07f65960ed	justo eu massa donec	2366.71	366	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a9ab9109-2922-4a24-8f71-320144708c4f	vel nisl duis ac nibh	1198.23	1	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
263e7942-e285-4939-be57-7f77b2431136	amet nulla quisque arcu	2088.33	427	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9e4dc57f-4b97-4742-bfd1-6fdc51803678	duis ac nibh fusce lacus	1012.79	319	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5d6e3a87-4842-46df-882f-5e662fbccd09	cubilia curae donec pharetra	298.15	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dd8a0800-fba3-4629-9a8e-2472f1a995eb	nunc commodo placerat praesent blandit	674.18	275	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4fd9d068-d362-4394-9fac-619fe99e29bf	quam pede lobortis ligula	2983.14	116	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ef112dbd-c95f-4e0e-b1a2-d607ddf164b6	felis sed lacus morbi	438.59	338	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4e60b8c4-f146-4be6-8129-816854b5f830	duis bibendum morbi non quam	397.08	336	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
36cff3c5-18e8-4acd-8284-f7a49f6a72a2	et commodo vulputate justo	1181.54	63	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
18d31cbe-f902-4211-b855-a8199875a0d1	consequat lectus in est	1406.79	22	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
698b382e-387f-4466-8c38-e94559a4b97e	lectus vestibulum quam sapien	2314.19	21	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9af6b8ce-1daf-418c-91d6-5a9b55cb54e1	interdum mauris ullamcorper purus	298.71	258	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2ab41804-1215-4425-8038-eb4dc53c2b58	id sapien in sapien	2576.94	371	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
438166c2-b875-4bfd-862b-b2f7714b52d7	nulla integer pede justo	63.12	30	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
59d81ac5-ff64-479e-9e48-d294dfeeab56	nunc proin at turpis a	2791.93	223	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1c0fdf1c-7dd6-4ff2-9bc3-59f2e01f1e28	praesent lectus vestibulum quam sapien	535.02	105	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db8f731a-a258-4ac2-b1c5-477635ea3457	maecenas tristique est et	2786.10	353	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bae15f80-741c-488a-8c41-d76ab1913368	mus etiam vel augue	2369.23	100	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ff42df6-c9fa-4c31-a2f8-6ebe767ea616	magna ac consequat metus sapien	2816.97	27	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aa0ef1f2-97aa-4f0d-9b61-9d158bd4ce46	dapibus at diam nam tristique	1788.86	125	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c79544e7-ba7b-4321-9636-7083dfe7fbd6	id consequat in consequat ut	1668.53	165	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1ea07bac-05ce-4d10-9089-c79774474817	volutpat erat quisque erat	1311.24	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d22b4f3d-6b26-4c71-ac3d-e52a0c0263c8	vel lectus in quam fringilla	497.47	492	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c2e83d45-719b-45ea-9650-8d4d45b16e6e	at nibh in hac habitasse	422.08	414	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d685e216-b8f7-4e4b-a97f-cdf030bc882b	lacinia nisi venenatis tristique	2563.53	425	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
06c36a48-6057-499b-879a-97246326daf0	sociis natoque penatibus et magnis	38.26	386	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6bd7c59c-cb6a-4d44-927e-32b938067848	massa id nisl venenatis lacinia	1773.05	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
87f44895-4e30-42ac-bf6d-d4b3b1a7a68e	lorem ipsum dolor sit amet	1254.58	336	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ffbd23bb-fb48-4f33-b711-932063f46416	amet sapien dignissim vestibulum vestibulum	2821.44	53	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fe2a810e-afcf-49a1-b45a-26e66bcea3bc	urna ut tellus nulla ut	222.20	162	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
238a65f6-cddb-4bdb-b0f5-0a0764795e47	ipsum aliquam non mauris morbi	2965.88	468	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d2257e19-50a7-4ec5-833b-8fb0c0ab54db	donec ut mauris eget massa	102.13	120	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
56a657c0-83d5-4bb0-908f-ac2797e3f43d	ultrices erat tortor sollicitudin mi	1330.52	390	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e842cc93-5510-42fe-999d-bb8d5a25998b	non velit donec diam neque	1194.80	157	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
709287bc-f3cd-470b-8c90-29c3b09aa947	pede ullamcorper augue a	2029.01	94	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4511cd81-1f63-408b-884d-24fa6f05b835	scelerisque quam turpis adipiscing lorem	1222.01	145	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e5269f77-1c99-48bb-ac03-995b3774f631	eu magna vulputate luctus cum	1857.36	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d82a8dd3-a1f1-42a5-9f01-033cb4a480b0	in tempor turpis nec euismod	2607.83	472	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
231463d4-4a25-4c91-97eb-a4d51817addd	id justo sit amet	285.20	391	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fb9508a0-f78d-4958-a132-a0703fc46ab4	sed justo pellentesque viverra pede	196.68	458	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
323798a7-0e1f-43ed-ba23-eb07b7853cd4	non pretium quis lectus suspendisse	1573.89	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
50f9a4a6-37c1-4410-b87f-ed90f6ed0a0e	velit id pretium iaculis diam	2444.36	1	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
66117f6a-f75b-4b99-9dd8-e4bd3e671b17	praesent blandit lacinia erat vestibulum	678.58	181	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b0533cb2-0937-48c8-8e50-6ce525b11874	varius integer ac leo pellentesque	1636.43	164	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c4c98577-8d6c-42cc-bbfe-64aeac90317e	convallis duis consequat dui	738.21	341	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3e095011-5a63-4ee4-8255-e8c5662e4fa5	vestibulum sed magna at	2572.48	29	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bd1fa32e-baed-4e76-8f09-488bf794989a	nunc nisl duis bibendum felis	321.61	491	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1f57b10f-81ec-4212-93bc-58ae70c5a254	ante vestibulum ante ipsum primis	1905.58	156	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a65185d7-00c8-4d26-ae2a-f954adf0ab0f	cras in purus eu magna	2022.06	401	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2ca7a820-8b8d-48b2-b0ad-770686f0ec95	etiam vel augue vestibulum rutrum	760.43	25	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
60e6f374-032c-4182-85b4-22232ac5a0de	ultrices phasellus id sapien	857.83	207	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c7008b74-2a35-40ac-a28b-ea4c9e0c8bdd	eu nibh quisque id	2743.05	334	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db6614a2-13de-4516-aac9-870bb9ab87f3	leo rhoncus sed vestibulum sit	2527.15	278	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1ac02056-9f69-460e-be73-9439774634eb	quisque id justo sit	2034.98	274	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
302334a4-7bb0-4cff-967c-d1967bbb1c4d	laoreet ut rhoncus aliquet	667.92	363	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3ee86da7-002a-43b1-a506-07f151f86be2	erat id mauris vulputate	2723.54	104	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ba164ec0-372f-474c-99d5-f1c299711396	quam nec dui luctus	1997.25	333	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1a99c802-d54f-410e-a2bd-ba389dbd5495	faucibus orci luctus et	634.61	204	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8bc06db5-1714-4c98-8785-6d14c39abbba	quisque id justo sit	1130.78	37	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f123ec31-3ce7-408d-87d0-72098804ee24	libero quis orci nullam	1617.85	308	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ed12393f-ed39-4a41-aa7e-68085036adc9	donec odio justo sollicitudin ut	298.10	374	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d73c1d4b-d02e-4186-97a8-5608995eeffd	congue elementum in hac	27.58	432	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b2df4543-5ce6-47fc-b9d3-38ea3098e39a	sagittis dui vel nisl	1304.34	215	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
94d5fd54-f886-4df1-afe2-7840ea858b5a	blandit nam nulla integer pede	545.11	406	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
70aa12be-dfd0-4f6d-8f7c-f1cf108a89c1	dui luctus rutrum nulla	2736.67	222	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e5f9b502-0800-4d62-9587-c5f2eba33f79	non interdum in ante	1988.92	423	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
75cc5b91-f516-41fe-9e91-a1edf47a582b	morbi porttitor lorem id ligula	86.34	99	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4a0ec488-906b-4818-ac61-414fe52d9aa2	a ipsum integer a	381.39	238	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5c12ee9a-d7cf-4f48-9521-746cc1610ca5	ac enim in tempor turpis	997.05	451	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
862d4d17-b20e-43c0-b32d-77c7cba5aa2f	viverra dapibus nulla suscipit ligula	234.48	418	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7f71a292-2cd0-4ed8-9d2a-587bdf9d9755	non interdum in ante	1734.81	271	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3fac4767-44ef-4993-ac72-c5381feb5e83	imperdiet et commodo vulputate	2932.18	172	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
48f91275-5780-4023-818b-f9de6a4d7001	a odio in hac habitasse	2690.59	268	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
68db7820-0366-4bfa-a95e-415e93fd5b08	quam suspendisse potenti nullam	2856.55	241	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5b6a34d1-72e2-4afe-9018-72564a2b22d1	massa volutpat convallis morbi	733.89	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e033ca53-db4f-42b9-b50b-1bcb17480a5d	aliquam convallis nunc proin at	2897.52	122	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b6c39710-4549-4a52-8cb2-8ab76552fa1e	aliquet maecenas leo odio condimentum	2104.49	365	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
caef9f02-4ea1-44fd-bccd-c3769d7020f1	donec odio justo sollicitudin	1141.62	187	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
456c24b7-60aa-4ea2-85b3-1e3f7254580c	consequat in consequat ut nulla	337.36	269	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3da031bb-133f-4ad8-b643-bd1a5f886aa3	orci eget orci vehicula	2468.44	311	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
32f7d55d-107c-4f71-96a3-8bd0645b1ebc	faucibus accumsan odio curabitur convallis	2192.74	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
78f65a6b-18c2-48df-8bc0-eb30a0154451	quis tortor id nulla	2191.63	365	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8a192d62-1b31-4c1c-8e89-5e3a96d90e33	est congue elementum in	613.43	73	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a0572c7c-e714-4a72-9a96-b6b360bb874e	id ornare imperdiet sapien	2073.24	217	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7d02f8ee-65e2-45f7-970d-802574aac4b8	quam nec dui luctus rutrum	92.05	72	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
adb90a8d-06ab-49f5-8bca-d1197b222f09	tempor turpis nec euismod	2232.33	179	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c242c336-4820-418f-b8c8-c1069bd15327	nunc purus phasellus in	106.20	17	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4439085f-d4d6-4458-9e6d-703011ee1376	amet consectetuer adipiscing elit proin	2646.25	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
127f89d8-13b4-449c-8d8c-0503721de511	nec euismod scelerisque quam	867.72	229	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8423502a-d4b8-43f7-a439-7af92b153814	luctus tincidunt nulla mollis molestie	1852.63	192	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e257c30c-24bd-4f7f-ac74-04e3fb863198	morbi sem mauris laoreet	133.33	87	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
720dc748-8103-4316-bd82-8c2285b61549	fermentum justo nec condimentum	880.79	303	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
161afcb2-158e-4589-b668-957a2f093329	ultrices posuere cubilia curae	2677.82	125	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
48f259b0-8a2c-4258-b06a-907f2f255334	nonummy integer non velit donec	163.25	71	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bffea342-f08c-4cd3-9343-b093e9437b44	nam tristique tortor eu	1791.20	421	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7c3d6049-67fb-4254-b659-40ccf79572fb	a suscipit nulla elit	2025.87	462	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e7d68233-2ea1-4007-a645-58c6906d4ed4	vulputate ut ultrices vel	2159.72	47	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e3024b67-ea1c-4c79-bb7c-25b66e152003	nunc commodo placerat praesent	838.60	225	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9b50e867-a6dd-4818-8612-e94612ec4157	id nisl venenatis lacinia	948.29	131	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
890a7bec-aaa0-4a15-887d-23b8465a0605	dolor sit amet consectetuer adipiscing	1187.50	267	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c42aa557-2ac3-4c8b-b680-45467d38a8ab	nec euismod scelerisque quam turpis	1359.44	454	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
536d23ec-bd5f-49b6-b467-20c4f5fd66a8	consequat lectus in est	40.62	256	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
68774402-8cc0-4dfb-bd32-b96048384edc	maecenas ut massa quis	2285.86	112	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c20bb299-4a8b-49fa-b2a5-09b6309c23d4	sem duis aliquam convallis	1190.10	187	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cf28c8b3-fd3d-40d3-9c0c-c9990416d8ab	suscipit ligula in lacus	321.60	206	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a256562c-e11f-41d1-baaa-282749528770	est lacinia nisi venenatis	2270.57	48	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0ad7ba16-f2ec-4e35-923d-4d8b00f0dcc9	luctus et ultrices posuere cubilia	2305.96	346	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4b3c92b2-b064-45a3-9566-c963f4492abf	aliquam augue quam sollicitudin vitae	1443.43	367	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b345b1d6-afda-4064-82a3-8ada5c625990	in hac habitasse platea	1299.00	368	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f6c35af7-4715-46bb-8d31-2969763c662d	ipsum primis in faucibus	1580.07	96	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e715cd7f-f67b-45c2-9d9e-ab1c534f2827	diam erat fermentum justo	342.78	333	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
1c16adca-43ef-4fc3-8e3b-115e636fc6b4	varius integer ac leo pellentesque	2747.17	34	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8cb7f3af-5fa9-4d37-9dad-e273105d1f21	risus auctor sed tristique	2421.87	88	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
ae58abdb-65e1-4b29-af25-1ec389b777b3	nisi eu orci mauris	1162.35	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
57173183-c9d3-4b5a-a453-7eb01e33ad65	sem fusce consequat nulla	2053.47	431	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
55913ecd-e237-4052-a117-3551627fa29a	vestibulum velit id pretium iaculis	281.02	374	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f676b696-78f3-4a4f-a04e-cfc9d92a2157	orci pede venenatis non sodales	664.28	361	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fc54743a-619b-42d8-bd15-b78714ac9b34	massa quis augue luctus tincidunt	589.77	411	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
35760cce-90a5-4a54-9300-fde2ac98a9ed	montes nascetur ridiculus mus vivamus	1350.09	426	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4ea793ae-9d8d-4660-8e5b-10d6611e00fc	proin leo odio porttitor	2415.52	471	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f32fa4a-7f23-4f96-9208-413006b3308f	blandit lacinia erat vestibulum	2125.67	316	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
feaf2e6c-1ca6-446c-aed0-0ec34cd053c9	nibh fusce lacus purus	2735.49	496	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d5cb6d47-534e-4b1d-b339-c34315876121	in congue etiam justo etiam	201.80	42	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
95f40c38-c977-4239-aea7-21df5de3a7ea	eu nibh quisque id	2981.22	157	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d2e095fc-f2ff-4502-8c47-01b10d503f0d	at lorem integer tincidunt ante	166.31	250	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3c9d9922-e12a-4dc1-a5bb-59b17fb77bec	ipsum praesent blandit lacinia	670.63	60	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
861a0ba1-2b5c-4a44-8421-ea507e016cc9	convallis nunc proin at turpis	2254.29	160	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
236c0db8-4326-4c16-9d7c-03d2f5c787ad	condimentum curabitur in libero	646.45	380	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
905533f0-1768-4875-af44-c40f2f12fcbf	tellus nisi eu orci	2260.50	195	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
adef93e2-5ebb-4fbe-9be0-8a912003fafe	nunc donec quis orci eget	1535.31	105	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
316e22ef-56a7-4d64-96c2-70cadb55a1d3	interdum mauris non ligula pellentesque	1193.24	430	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4165ae62-0553-416f-9c9c-41fd14f9f6ff	nulla pede ullamcorper augue	2058.65	109	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
37ee20d3-3e40-4763-a4df-162a82d4ea25	ante ipsum primis in faucibus	2083.70	360	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
19df3a58-27fd-4b03-bb58-f2542acecd7e	donec ut dolor morbi vel	1658.11	333	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
84b5d0df-0702-4661-9e1d-c17b7662d389	quam pharetra magna ac consequat	2386.33	425	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
956a56b9-49f7-4357-8ce6-cf3b7a8d5f1d	id ornare imperdiet sapien	667.05	55	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
82eb95f2-6558-4fcc-b9ce-abdb673d000b	ipsum primis in faucibus orci	1614.42	297	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3c4db21d-9d76-479b-b0d3-b06b75d45bb5	nullam orci pede venenatis	2235.52	92	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c0618cb6-0459-483f-a990-6ceb8852d6da	interdum eu tincidunt in leo	31.46	294	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
85c7838c-47a5-432e-b0f3-669d4a929ee1	in consequat ut nulla	516.78	210	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
59949c43-3538-465d-b575-326cbdf39557	non mi integer ac neque	2911.37	411	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d8e8cf41-1f50-44d6-be1b-753f999a5fbf	vulputate elementum nullam varius nulla	15.51	1	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7529abdc-8713-4045-8e8d-208fe6c1f879	rutrum rutrum neque aenean auctor	2630.42	499	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2a77af69-7b2e-457e-b894-8e07457c8007	mauris sit amet eros suspendisse	568.65	274	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a249e695-7d78-464f-a3b1-a328a4cf7e38	non velit nec nisi vulputate	2123.51	246	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
16b6747b-3732-453b-8e4a-9f967ad763f5	ut massa volutpat convallis morbi	1116.14	322	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a18f19b4-8d9f-471e-8e85-ab00052d0514	sodales scelerisque mauris sit	2611.64	43	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
705a8ddf-88f4-4ace-8cac-384c51b77125	tellus nisi eu orci mauris	510.34	378	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
923c943d-497e-48e3-b9e4-7c33df1370c6	risus dapibus augue vel accumsan	185.06	136	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a7357a6b-eb1f-4536-be65-b678cb076d9f	sapien a libero nam dui	1099.55	499	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a4ca9a09-1447-4df1-a3f4-4b5a8cc4321f	sagittis nam congue risus semper	1240.25	350	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a4f81295-eb15-406e-a8fb-d98a93712a53	nisl duis bibendum felis	330.63	444	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9f52e2bc-980b-48d4-a9da-ca34a8a0e9f3	molestie hendrerit at vulputate vitae	2825.73	349	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4ae15b06-0477-4525-9c78-41e39e1bb3a7	natoque penatibus et magnis	922.67	346	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2fd5912b-9adf-487a-a8c7-cb3a38daa80f	sapien sapien non mi integer	1428.65	38	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
07788856-f12d-4ed3-b8a3-23b1df599b28	eget massa tempor convallis nulla	33.26	31	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
483a148c-18b9-4e7b-8f6d-48e9db2a12b8	condimentum curabitur in libero	1936.67	487	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bdd9caba-e55e-4442-a12d-c961baf57333	at vulputate vitae nisl	1779.35	271	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4546edd1-0709-49a6-b91c-9fff4df751bf	vestibulum vestibulum ante ipsum	2867.90	210	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
118237ca-4fcc-4611-aee1-1b5aa4c094fa	in quam fringilla rhoncus	748.82	334	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a6381a31-5faf-49d1-b719-8c27719667d3	duis at velit eu est	1203.99	156	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
301b960f-1b4f-4759-9bb5-5f294838f218	mauris sit amet eros suspendisse	868.21	36	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5beaf691-57aa-4d6e-99b4-fd12a65a6751	libero quis orci nullam molestie	2742.07	112	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4678d484-e4a7-4128-b810-9821665cc3ba	consectetuer adipiscing elit proin risus	1328.94	379	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e2f787f5-e9af-445e-82fb-c82755ad983a	consequat metus sapien ut	2404.05	41	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
52c74d64-e26d-46eb-8767-29af802ecfd4	eros viverra eget congue	2701.47	217	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
6dbceb74-0c47-4565-bfa3-dcb7d954d612	donec semper sapien a libero	2560.39	254	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
10e6b161-8e5d-475c-834b-75d4b52bacc7	adipiscing molestie hendrerit at vulputate	247.04	169	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e785fa14-f618-4023-a0e1-e30b2d5e868a	suscipit a feugiat et	2897.60	316	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f28dc1d5-6491-4b43-86fa-00c71eb6ce06	ante vel ipsum praesent	1502.16	326	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cd862f44-36df-4ad5-b816-1a941066779c	lobortis convallis tortor risus	537.86	432	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0ffe097b-c049-47ce-a8a2-d2ac648aaff6	congue eget semper rutrum nulla	1116.13	415	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
198cd3a7-9f2a-493a-8d28-781f30037bd0	curabitur at ipsum ac	894.17	102	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9a4e25a4-0a70-4f83-9843-5194af794055	euismod scelerisque quam turpis adipiscing	421.55	11	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8f4c4357-0341-4fa8-b231-332aff87d60f	quisque porta volutpat erat quisque	294.55	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
65ba3a06-90af-4b70-950b-a7f249aa72e1	nibh quisque id justo sit	1797.93	54	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d33f0594-8bc5-4744-b189-55018e9becc5	dignissim vestibulum vestibulum ante	2923.02	481	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
cf1e1bf1-e189-4e3f-bc2b-e58542713b9b	pellentesque at nulla suspendisse potenti	1265.93	30	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9ccc6ad8-2ff1-4339-9f23-c030c21a5f27	ante ipsum primis in	2277.69	302	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0ffff1c4-87a2-4beb-b40e-40395ceedad5	ante ipsum primis in	636.95	403	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9709631a-d9f4-4c76-bb52-5692284f7495	turpis eget elit sodales scelerisque	729.37	293	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f3c60162-6f84-46c1-8a02-a4e9649cfc51	sollicitudin ut suscipit a feugiat	816.96	12	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dfe4ce16-3d38-4433-87d9-a7e802c74f40	mollis molestie lorem quisque ut	1743.48	347	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c466f5d9-7b18-43d1-bf0f-3a425644e69e	amet lobortis sapien sapien	2715.61	226	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db186775-6fe3-4473-b30c-8f105d431952	tincidunt lacus at velit	741.88	243	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
739f522a-3f63-4043-8992-f2cb9ba02109	morbi quis tortor id	878.05	66	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
7c6ecbf8-6f0d-4946-9d9c-0d99d210458c	nulla eget eros elementum pellentesque	924.50	305	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f884e25c-e322-4906-bb12-b409b7b77d8c	eu sapien cursus vestibulum	1083.74	318	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
dcaff263-a8be-4065-bae0-f2e33c8e5977	justo etiam pretium iaculis	1625.87	492	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
42464cac-25cd-4c8e-94bf-b9fea5ac5bfe	sed magna at nunc	2477.88	406	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c6189e72-b22f-441a-9834-3141920f7e29	laoreet ut rhoncus aliquet	172.67	73	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2c6361bf-9542-4b38-b6dd-fc0720e4bc65	odio condimentum id luctus nec	1662.81	215	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a71d82ee-1a9b-4b49-acab-6a9345bd41a6	morbi non lectus aliquam	2943.86	487	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
66f52fb0-6075-4cf9-b884-caf6c6b13e66	eget nunc donec quis	811.16	270	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f107a70c-1c67-40b2-a55a-9176679df5e2	non velit donec diam	2737.26	49	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0c9f2c2b-6f6f-4f31-915e-8bddf6ba97f6	eget rutrum at lorem integer	249.43	135	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a35cbb2e-42ca-4b4d-a270-02668ed8f2bc	erat id mauris vulputate elementum	1655.81	162	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e24d4035-5902-4b41-b494-da0316041933	donec ut dolor morbi vel	2364.84	1	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
131f7641-a519-445e-8c84-439d6205392c	aliquet pulvinar sed nisl	898.43	312	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8b45ec0d-477a-41da-b183-e4159460bb99	vitae mattis nibh ligula	1991.36	281	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
789cd210-cbd2-46fb-a033-b30fea6e3094	rutrum neque aenean auctor gravida	95.52	264	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
4f33627f-1c0d-4385-b95c-5c2ca24792ad	nunc proin at turpis	1387.00	116	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
59c60900-03b7-4a16-a338-f731470e8ec7	nec condimentum neque sapien placerat	1762.93	107	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9dff09ea-3501-4a2e-a164-627b9e1073c1	nulla ultrices aliquet maecenas leo	849.43	397	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9e6b28df-dc8e-4a28-a237-806f68027afd	pretium quis lectus suspendisse	1253.59	11	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
83e7dee1-3dc9-474a-bc10-ba61a9d1fbb4	massa id nisl venenatis lacinia	197.38	376	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5cd9a9a1-f212-4606-af53-fca25dd3080e	et ultrices posuere cubilia	2032.69	341	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
13802b08-733c-4d8a-b132-ac684eda7218	nulla nunc purus phasellus in	22.33	81	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
37e2f74c-e019-40fb-ad28-efd8fd321667	pharetra magna vestibulum aliquet ultrices	1958.19	492	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fa275115-fa7a-4c25-82e0-d252e045b29a	velit vivamus vel nulla	2542.16	420	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
77ece648-bed2-413f-9a8a-908f0a322192	pretium iaculis justo in hac	839.59	233	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
99b4888e-0ed2-4039-9423-661b9705cc63	nec nisi vulputate nonummy	706.11	364	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c80893b6-b638-4a83-b6ae-2b95ae123dae	integer ac leo pellentesque ultrices	2247.47	442	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8d6905a1-7ef7-4e8a-bf52-59493aa817f8	libero ut massa volutpat	2.70	343	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
42a74d33-01c9-42ed-b501-39ffe285d680	magna vulputate luctus cum	2179.12	189	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
bc586784-ed94-4d2d-a857-54d4ba19cccc	congue vivamus metus arcu	1083.82	339	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c9268f65-058b-4a3d-9e71-0e83e2ad0f15	condimentum curabitur in libero ut	2071.67	433	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
af707ecd-ed23-4117-989e-4eeb702dd659	quis libero nullam sit amet	912.88	121	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0d53e67b-aad5-43ea-992d-19597925fdd7	dapibus nulla suscipit ligula in	147.46	228	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
8980a61c-d2f5-47c4-802b-3bccd78b85db	curae mauris viverra diam	1276.21	172	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
34d2c6d9-e834-4a6b-8969-d25320f48ac2	nec nisi vulputate nonummy	940.69	481	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
aedd1f54-9ef8-4bae-8650-8be25187046a	duis mattis egestas metus	317.06	200	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2fc0cd25-6d9a-44df-9031-779a6b5d4bf9	diam vitae quam suspendisse	616.10	277	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
82a27f3b-a6c3-4c96-92e0-67949408e931	in lacus curabitur at	1551.05	481	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
268710b5-2300-4548-bad1-47513dbf13d0	odio elementum eu interdum	2834.69	239	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0c131e48-2bf1-402a-a2de-fb03d45a6173	viverra pede ac diam cras	2872.67	147	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
867f8537-e019-444c-8ebf-33c3c7267f18	vitae quam suspendisse potenti	1765.18	314	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
5e589f6d-f0bf-4873-a301-dc0a4193bd86	dolor quis odio consequat varius	454.77	420	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
99bc63e0-ee78-4422-806f-b63678fc516b	varius nulla facilisi cras non	1645.20	320	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
47d89e50-a931-45b0-82cb-b8323605b5e9	luctus et ultrices posuere	130.20	310	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
354922ef-a4d4-4a37-8620-3514a28b8849	aenean auctor gravida sem praesent	470.35	313	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a229c4d3-5500-41e4-ab2b-36898ec53778	dolor vel est donec	1646.53	450	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f5a1b008-6984-4d71-92bd-3a51ef1d9edb	libero convallis eget eleifend luctus	145.67	205	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
b6359526-55db-4701-ac7d-b51d5bdb2fc6	nullam molestie nibh in	2723.99	94	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
3e211461-ef29-4d16-93b5-65c617abe5ea	hendrerit at vulputate vitae nisl	2697.72	252	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d4c396bb-72ad-48bc-b57f-ae66c7d8d035	integer non velit donec diam	660.79	188	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
26c9cfd2-87b9-497d-82e3-ec766ece8ea4	integer aliquet massa id	730.64	314	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
83868a37-56a6-4a61-80c8-e0b975371449	mi integer ac neque	2650.65	457	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
826cdee7-92cd-4e48-88e0-db637b46543b	sed tristique in tempus	2324.08	23	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
e1e9b987-57bb-4fb7-8513-4d1fae8f8f4e	sit amet erat nulla tempus	1912.55	307	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0014e265-84df-400e-8491-66e52724e161	sit amet sapien dignissim	725.68	126	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a9d89676-fe45-4c0d-b2ca-7039f9b29359	consectetuer adipiscing elit proin risus	1421.66	39	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
30743074-836c-4015-9f80-b7446a28a511	risus dapibus augue vel accumsan	1795.87	491	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fde55e8c-2b45-45f1-bfa4-b3acdbb8c716	ante vivamus tortor duis	1647.02	326	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2f27a396-89d6-4a3b-9b81-de8b4cf74f02	convallis duis consequat dui nec	811.66	320	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
d35d14e0-fbf2-4bdf-bd44-4648377c5703	in sapien iaculis congue	2671.84	249	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
23564ad7-a514-4fdd-9879-bfbd0ea21589	dictumst etiam faucibus cursus urna	1190.80	396	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
24652c3b-5928-4336-9101-22ff1d683c47	duis mattis egestas metus aenean	380.78	422	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
0b86f9b2-2c5d-41c8-96b0-5f0329f2b640	porttitor lorem id ligula	2409.31	284	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
57ca259d-950a-42a3-8abb-27c0512226f4	vel ipsum praesent blandit	1026.27	337	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
450e6ec6-8b6c-44b0-9a19-18c3a3582090	in hac habitasse platea	2053.83	416	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c27b0e96-8a53-4700-b086-8c31ba149823	id consequat in consequat ut	2392.22	379	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
77ba5c1a-63a2-4143-a679-6dc36039956e	nisi nam ultrices libero	2435.99	187	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
f6287873-8e98-4390-b5bf-f71ed8f5a890	non ligula pellentesque ultrices	1691.80	365	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
9a15c0f7-94c8-412c-a653-8fdb151e2eee	nulla pede ullamcorper augue	2027.23	296	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c57dcd86-44c2-475c-a8e2-8fa7ce846554	luctus et ultrices posuere	86.13	437	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
a067a03d-fb3d-4178-986f-3f263a72104f	ante ipsum primis in	241.52	181	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
2566d6b9-b78f-4390-a3b4-5a334cef5230	vestibulum quam sapien varius ut	1960.25	494	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c8003c5f-e1a6-4ac8-905b-099a4b728500	suscipit a feugiat et	2214.58	498	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c87778b1-dabf-42df-964e-6d6799653018	dictumst maecenas ut massa	739.61	229	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
26c3132e-21ee-4c0b-8b3d-803093c725f2	rutrum at lorem integer	1536.32	282	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
fe6b6e4d-2292-4b2b-b115-c39f1a8783f9	ridiculus mus etiam vel augue	2012.42	145	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
c4f38080-765e-4639-b448-bea201833b34	curae mauris viverra diam vitae	846.48	184	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
db49b6ec-1ee0-4fe0-bc63-f5d6255f92d5	augue vel accumsan tellus nisi	156.24	498	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
254f4daa-339b-403a-bd8d-8926449ae5be	pede ullamcorper augue a	2234.94	352	2025-09-25 04:24:07.543325+00	2025-09-25 04:24:07.543325+00
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id, fecha, cliente_id, created_at, updated_at, estado) FROM stdin;
1bd0dd4c-aaca-4794-8e97-b74ba449fd35	2025-04-24 00:28:55+00	a21e647c-01f0-4613-9cc5-3ee1f275474c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1efaa2bd-8989-499a-aa6c-8a7c21efdd7c	2025-06-08 10:28:21+00	9b64f8f2-835b-4a40-9e95-581f68342069	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
08062321-3a38-48a8-92f4-02025313916e	2025-09-19 06:49:45+00	86721efb-f93a-4405-acc2-2eb76a2be5c0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
68251dab-f3ed-487c-89d2-3bb3ce61cb51	2025-08-10 06:27:15+00	fc443c78-1a65-487d-b9d7-4c3dd1789a8a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b07c22ad-19c8-49ce-8891-19bb8fad43d9	2025-01-02 16:17:13+00	fea308c2-ae69-430c-b0f1-e1a4e82191c8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
50e45178-6375-40c0-a761-6b0857248d24	2025-09-07 14:54:56+00	88788896-9caf-48bf-8960-64f59fd83890	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f1c21b5c-0aa3-4999-ac25-c8b15ccafad2	2025-04-18 19:59:39+00	ce136afd-43e4-4194-adea-5ec300a6c463	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b14c0b15-9d1b-4068-a271-3aa127c22c0c	2025-01-18 01:10:52+00	afd0ca3a-199c-447e-9d18-31f271a34646	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6687abd5-7e8d-4f93-8872-ed7973c82067	2025-02-03 14:55:16+00	fcac830b-2aa7-4ae0-b255-3cb4feee6590	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6a97095f-68e7-4605-86ad-ef83593423e8	2025-03-24 05:25:16+00	46ebea9e-fdcc-4ac0-b547-d9257457b5df	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
cc93871a-784b-45f8-9178-4ffe08a18c86	2025-06-11 19:46:22+00	b2b973d2-469d-4175-9685-e1ffcb2ffda0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ca1d7b0d-afce-408b-ba4b-2ccb0a30705a	2025-06-07 19:09:45+00	e0da9539-df45-477b-a165-0c7a8cf26067	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
16147c77-08e8-44da-87a5-8d30d54115fb	2025-01-10 14:14:18+00	71c371cd-541f-414c-990f-c51a913e449b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
525a282d-0f8d-4f23-b0b8-d68235fe2da1	2025-07-13 15:01:17+00	6b841441-dac9-4346-8b08-4a6dff9d2a62	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
97d16adc-06c5-4662-b6b4-631198caed60	2025-07-19 19:56:55+00	f96922cc-14f3-421a-844e-02b7faf42e36	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
effa6386-eb68-4670-abfe-9def4aed1765	2025-07-07 00:40:04+00	eff3d0cf-f7e7-40ca-ae62-89fd78c4abd8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
760029fb-2348-4c8a-a68a-6a51117954b6	2025-03-14 02:14:43+00	d5be2e70-5ed2-4266-852c-7d7a457438c9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
08d6ac3f-89dc-42dd-81eb-30cfcced5621	2025-06-07 18:02:58+00	d84e3776-7f43-4ab1-afe3-09313a53fbf3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b954a6ca-3db3-4b63-84d6-f7fe72c548e8	2025-06-17 22:03:47+00	132e75b8-29ec-48a2-babe-7e1ff0ca11dd	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
da954279-0735-46cb-96c6-6b725726f5ac	2025-04-27 16:25:55+00	a2ffd1d7-4916-4223-a8b3-2ad22ae25697	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
237a8e42-b8be-4a34-9107-99c8c32ce353	2025-09-12 00:53:32+00	ba54b19e-bd0e-4c3b-9f6a-7fafd95d4f08	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6a1061ed-9985-4a6b-857f-741033d4b2d6	2025-03-26 18:19:43+00	8a37a235-bdbe-4674-8792-ad8ccec0cb25	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
be27466b-77cb-4dea-9f69-0d9bdcf5bf92	2025-05-13 11:13:59+00	0df8a564-9b3e-46d5-ac69-18700b8643a9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1276fb6d-6b59-42ae-bbf4-b93b6c728ad2	2025-02-06 05:56:13+00	3868d5e0-ddb2-4ae6-9611-2b6b95d9296a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
d68fd55d-4c20-4f1d-9de7-5924e4e30de3	2025-08-21 15:27:36+00	36192d6d-eac2-405c-82f2-05cbc60424af	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6a33e3aa-494d-491f-88f4-1afd96bd07e9	2025-02-14 22:33:40+00	d0066b1d-7cd0-4105-94c8-95506e001818	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
565b0387-3386-402f-a840-08a8b9f80ea2	2025-01-17 08:27:10+00	cc601655-da93-4d86-bee4-51b19294bfed	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
56982c1e-cb17-46f5-8ba1-bd1dd4e24e28	2025-08-24 15:08:17+00	08be2e2f-02bf-4ee5-9df3-8610cbf7711f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5c366199-d746-4aac-877d-e8340442d6c2	2025-05-04 20:22:02+00	da0b9086-534a-45c8-9bc7-af27d10afd1d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1529758e-e2db-4a59-9475-3ee95437d6c6	2025-08-04 18:52:54+00	e9ff238c-3c9e-40c0-b970-91f816544406	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
600ba42b-aaf3-41b5-9832-5e430c8d5c74	2025-06-28 09:00:53+00	6fcad9cb-26e0-4ba3-8516-03c6798856f8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1112f024-0107-432c-ad8b-7f9ce6c17f15	2025-03-03 03:57:08+00	26cf9196-7178-494c-8048-4452df361e38	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
20d5fe53-f541-4e01-83ad-984ceb53702e	2025-09-13 10:59:58+00	2776ab75-2cff-4412-b7f5-ae1714bab55e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
65715f5c-56f8-4953-b5f4-0bc3d8d18eff	2025-04-14 21:32:19+00	6756378e-6b18-4bc8-914d-d7594d341e8e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
43fa5db4-cd26-407b-b9df-3d1400eca579	2025-06-19 00:47:52+00	5cf53c78-69f3-4f8d-831a-de21c9c83541	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
66060674-81bf-4ad2-af73-04a253cd2c4c	2025-04-02 07:52:07+00	6d2213ae-6018-43e1-9ca4-ff580b1a8d5c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
45539d45-9787-4efe-a7af-4ccd15da1916	2025-07-03 09:08:49+00	141817f0-d461-456a-b436-d1f0133d62c3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
525e96b1-c61a-49d0-ab04-1603c0ab49fc	2025-05-22 21:32:58+00	5275f25b-7dbc-4bc2-bb1f-ae10d8fcbcac	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c9f6a6ed-e9fa-4340-8fea-7d04e1cefb97	2025-06-13 15:36:01+00	8aca309c-9886-43c8-84cb-1d00a3ceb119	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
30285572-1976-472b-97a9-c6d411bb8d0c	2025-01-11 06:52:10+00	4cb63142-d641-417a-8a76-87efbbe4b9d0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
001e1111-8116-4bf1-9eeb-3e46c157897f	2025-06-10 01:07:20+00	b41d64db-11bf-4894-ba33-70feaef7bbf1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e9bc0fdc-18c8-4436-98d4-1168a12a093a	2025-01-11 07:55:42+00	2c75199a-155a-4011-a750-c907c392e3b0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5dd960b8-4a7c-4113-82c6-7cb8ebcdda54	2025-08-03 14:34:58+00	ff19237b-8724-4e3c-960e-1c6e06aec0c7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f035d8f8-e3ca-4fab-9c19-f8dcd1d1013f	2025-02-19 13:26:35+00	2ff9c668-92b1-4a4a-9234-694322ca1cf3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
22e7a462-e53f-4048-8819-df1c202a992a	2025-05-03 12:34:28+00	bcd1dcda-41d2-4097-ba51-ff34e6cbb39b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
bc21c33d-8668-4e92-aa3d-eea3658f8858	2025-08-22 19:52:32+00	293cf87e-ebbb-4bcf-a5b6-f162d82c1638	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
84929b25-b2ed-4d34-bc13-3ec73853b06d	2025-06-18 21:28:49+00	03a5cb9a-157c-4b21-8bf8-7054bca18330	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
90c3d581-e6d0-4778-94d2-4da99a0eb10c	2025-03-14 09:35:32+00	437825dc-f7b1-4ce3-91a4-fb6d1b0b9ea9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b771a9e0-f6ad-4817-8a83-791d3b689769	2025-05-23 23:14:55+00	57549ff8-deaf-477a-bb6f-e9e9d834e4cf	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f3c939eb-8f61-49d5-916e-da09ef3fcf4e	2025-03-05 08:54:43+00	1f274993-8c62-44ee-a5b2-9e90791175bc	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
499af625-149a-4241-a03b-aded701ad4d2	2025-02-23 12:05:06+00	8eeb8b22-333e-45bb-928c-1e2544f5819b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5bf7dd46-4047-44bc-9990-7345e0df563a	2025-05-15 12:16:23+00	af3826b2-6b96-4392-a17b-402572120b59	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
979af0fb-584d-44f1-b715-01bbbf2751e3	2025-02-26 16:31:15+00	eac11ec5-afca-4e01-a06c-2cb67a0e82d6	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ef81b2be-c029-42a1-8b4c-ee186a60824c	2025-04-03 16:19:43+00	214f606c-08be-41fe-9463-dcc2375df680	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
33aa031b-4e8d-457d-b7ad-f0d11295d0c1	2025-02-05 05:41:50+00	d789ec6f-f6f7-4966-8872-32638c25db25	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
347af1fc-eb17-4ed2-aa1a-0f16c64815e4	2025-09-19 16:23:27+00	658d256c-9145-4838-8956-49a64d60416d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
aea6cca1-ab99-4fb1-9aa5-fc82f54da674	2025-05-29 07:34:25+00	311053f7-37e4-4406-81b2-74e5170210fa	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5063566c-73a5-49b2-9179-c966531ec333	2025-06-11 19:53:18+00	c1475344-55c3-44c9-a4fa-9a94d92b3ad5	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
084cf75b-e856-4d65-977d-3b5739133ce8	2025-07-30 07:04:00+00	8f8135c0-98c8-49e1-8ca6-cfe514a80013	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
524c4a55-37d7-47c5-af46-c34b7a7f253f	2025-03-27 00:24:36+00	792241b1-120b-400c-879c-ec62c65a71c2	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
486d0262-fa5b-4a73-8fe7-29ef1b57e731	2025-02-14 20:17:05+00	7d13f666-ead3-4e2a-8acf-36a2ff44a80d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
fac46dd0-4c20-4fd2-a743-dde035ca9d5b	2025-09-25 03:27:15+00	e7424aa1-9bcb-4080-83c8-e47be320d7ed	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
09932be4-6bb9-4ebd-a2d2-2fbfb32d308a	2025-08-29 07:43:01+00	0a5af9fb-e5ad-4ec1-842c-e8ff5d96e1a9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ab4d5e03-c2ed-40ce-8340-658781fa652b	2025-09-05 02:25:51+00	9730df42-9c5e-47e1-82e4-7206504e32bf	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f40f0728-62c1-46df-953f-e17e6e5aa6e8	2025-03-17 05:52:45+00	26cf9196-7178-494c-8048-4452df361e38	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1cafacc5-488f-46af-b0fa-7641c2bb1509	2025-08-22 22:30:08+00	73acf395-b113-42e0-9391-57c6143456f4	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
dbd346ee-a8e6-4a1e-a24f-fc2daba21fdc	2025-01-28 00:13:49+00	0ceeb0dd-3723-487e-9d6e-5f9e2f796249	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3f0d00bf-dd48-4b8e-8fc6-bc3ed8c28d0e	2025-03-29 08:53:02+00	eb479092-7c5b-4550-90f5-3098b095c2d3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
aa571a5a-d2c2-4cfd-b214-badd309a7bce	2025-01-16 13:17:14+00	a406b8fd-b6f6-4a5b-975d-3274fdc22984	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
155670e0-b314-4f32-a41e-7f1bd25722de	2025-04-12 05:45:41+00	46559488-d741-423e-aeb9-4ca82f7b5890	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
335585f6-4bb1-4bb4-b668-b154bafedf8a	2025-02-04 13:52:54+00	8bf928eb-e7e4-4c1a-b629-0bd4185e0c3a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
eaeb2b8e-90c8-4875-9980-9e57f8e2bebf	2025-03-18 13:54:06+00	9654ff0a-17f8-464d-aa42-a99d01ef3575	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
d2859681-703f-40dc-8ab7-5792acf0c507	2025-06-23 11:37:37+00	0021827f-5d97-4841-8b89-69aab8ac4812	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
22e2a4b7-339e-452d-a5bf-28c30443d691	2025-03-15 17:28:08+00	3245375d-cca3-4320-b6f4-f8ed7dac5e9a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a37b9b0b-eec6-4fcd-89ad-c3f8d00e5983	2025-08-13 15:59:11+00	ba54b19e-bd0e-4c3b-9f6a-7fafd95d4f08	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
948cc5b6-87b2-4ce6-9dda-289c7563bc38	2025-03-07 15:14:04+00	e699fbd7-339f-4112-a72d-a9020efff067	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ea2d8bd2-3631-443f-821f-7e6c24e43857	2025-02-15 04:33:27+00	71c371cd-541f-414c-990f-c51a913e449b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a8429b46-b30d-452c-b54a-838f80af17f5	2025-02-03 04:44:51+00	0fa414f3-03cf-47c0-988a-756715d394dc	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a352ecfc-6105-4f71-a5bb-32a178c1384b	2025-07-04 14:43:34+00	5975a184-36e9-40ed-b4b8-6782199da858	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8f61c253-3137-406f-9f23-1cec641712bc	2025-08-03 13:23:46+00	4b03c778-b0e4-40d0-abaf-21a8fcd54850	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
50024ba2-9983-4e14-afaf-00df3f238341	2025-01-06 12:20:46+00	46ebea9e-fdcc-4ac0-b547-d9257457b5df	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8b759c5c-7c58-4431-ad99-ac9ba0655a5a	2025-04-20 03:16:53+00	5d35d17b-3c48-4cd5-b30a-25d25eb0eb0b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4e0fc028-5900-4a70-8e05-35ee95745e2e	2025-05-05 15:34:06+00	fcc4a60d-0cfe-4eee-853e-773af996d4fe	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7b507156-3da2-4384-9c0f-5d53f3922b7a	2025-02-28 20:19:36+00	bc21d5df-dd8d-479d-8081-7997ebcab5ec	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4a921fd4-12af-44d6-a149-53dc0eca642c	2025-04-18 23:41:28+00	80393557-fae3-4dc6-9222-aa82c0747848	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
14fabcf9-3e3a-4cd1-bf67-7e91c1d422d9	2025-06-23 22:57:36+00	9654ff0a-17f8-464d-aa42-a99d01ef3575	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5b807691-609a-46a0-83e9-4cebbe15a46f	2025-06-04 07:31:36+00	ba2245e8-219f-4cce-8133-77919112f1ab	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b4f566c2-f04f-40f7-b853-308708b8c173	2025-05-31 22:00:44+00	5d2875de-e7ed-4e31-8eaa-ae8c7c51a573	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2852a240-9b4d-432d-ac95-443b5b17ae34	2025-01-27 07:38:22+00	8278c051-7a12-441f-9335-7a58a42f2165	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
87758a86-90a7-4859-8155-e3cdc49e8703	2025-09-27 09:47:57+00	b2b973d2-469d-4175-9685-e1ffcb2ffda0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
84215ee9-c6c5-45fd-9a43-7cc76c8bb7f7	2025-08-12 13:31:47+00	85fb56b0-ce83-451b-8c53-be8919c14eea	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
32ac1773-f123-4af8-ad67-bf7d7d2df925	2025-02-09 04:12:22+00	d5417458-c0e6-4f1f-8431-efe9a79d17e8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
223005b3-31fa-485f-b021-606d097d451d	2025-09-11 02:58:54+00	fb9ce2c4-8da7-46b5-886c-4e76367f5387	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
57c9f478-0322-4dcc-8934-5d3ed768e1fb	2025-09-03 12:10:09+00	0021827f-5d97-4841-8b89-69aab8ac4812	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
833ed813-6177-423d-9903-87634724c195	2025-02-07 17:55:08+00	06ddcf3f-c064-4652-8e8b-34186de83544	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a40eba37-28eb-40a2-b5e7-fc34abc8d3d5	2025-01-10 09:45:20+00	608ca06f-82fe-4b83-89e8-f0dd3338b782	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8a1fd9fc-2380-47e4-8d86-828b7d36b208	2025-04-14 02:19:58+00	e0da9539-df45-477b-a165-0c7a8cf26067	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c9f84933-0b22-471e-bae8-cf205690ad63	2025-07-30 08:27:13+00	8bf928eb-e7e4-4c1a-b629-0bd4185e0c3a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b2d6eda1-2ce5-4f67-845a-e323428c087d	2025-06-22 23:45:53+00	f97cd263-93d7-45d2-afe2-9beec715f68d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
037c0b2d-f508-4e34-adf3-bce8f5932aee	2025-02-25 08:12:39+00	66110541-23b5-4e19-9515-de22b0829a63	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
33d3b868-0f87-4758-a6ac-7c666e44d5be	2025-07-07 22:40:43+00	1a7f7ed8-c0a2-4a5b-9648-3627ce7868b2	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
58732d14-1087-42df-88a1-891062e59216	2025-06-06 08:07:22+00	95ce86a0-7069-42fc-b656-168d3db68b96	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6a345b9a-297e-4afc-b3b1-6100af89d749	2025-08-26 22:01:54+00	9fc29198-4e6b-46cc-8d55-a47f22f8bea3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
dde289e8-65f3-48d7-81b9-fb0cfc69583c	2025-04-21 12:02:19+00	0d3f9a2c-736d-45df-b12f-4a6819528e95	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
48682c5c-53fe-4cf1-ba6a-a8d484288aff	2025-04-22 12:56:35+00	f85af929-1706-47ac-a5f7-7372a42b7db3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9cea1810-1a51-4ff6-95d0-7b290b81268d	2025-02-05 04:58:04+00	2029bda5-cca1-4d96-aafd-78cd2ed3a3e7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
eaccc436-9b93-4748-bf78-de7e26546665	2025-04-15 21:11:20+00	0fb10a3b-c475-4a2a-8311-e576e230ca87	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
30f2e86d-4612-4f51-9107-10c11ec149b0	2025-08-19 18:50:06+00	37e6fbfc-2087-482a-b815-a4deb720453b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ec6ec66b-e8ee-495e-8948-2b9be9305307	2025-02-09 12:45:02+00	12ac2fff-8f3d-4eb7-9b68-c76fc1fbdad8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
22720962-2ff2-444e-8219-348d1d8bd7d5	2025-02-16 13:27:55+00	2e1a4a68-cd03-4ba4-8850-d5a048f69545	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
bdda4657-a1b8-40e4-b255-f78d53dd7125	2025-08-28 23:01:30+00	fea308c2-ae69-430c-b0f1-e1a4e82191c8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2efcb15a-8d88-49ab-970e-1216457514f9	2025-05-25 09:50:12+00	2e190f2d-8bc8-48d0-b091-b47f6b0432b3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
76dfa88b-3479-4d45-87ef-c3922d07a9fe	2025-05-26 05:18:13+00	0771d7f6-c009-48a9-b8f0-4c4831387f10	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8316841c-b2c1-4764-9d00-fe876b6f769b	2025-07-18 13:56:56+00	2b4c5160-fd64-45ea-90df-c7134512f0e1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
98deafff-495a-4fc8-bf3e-5f7961607766	2025-06-20 19:48:20+00	33b10c2c-6158-4452-9d9a-60d39b439101	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
19645d20-d291-441f-9003-ec78341bad89	2025-03-20 16:26:36+00	28f695b2-305a-4330-ba72-37264457717b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
fa43f9b0-bd2a-4888-ba22-afd7b2ea9c3a	2025-07-09 23:41:41+00	1ec03b8f-6ca6-4280-acfc-1419b584c7f4	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e9a8fa5f-b13a-41c8-ab5f-435092906813	2025-02-07 21:35:23+00	fa383ea2-80c5-48b4-9f9e-0c9cfb8ae802	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4ed80603-7451-47ea-a4f0-cf51d43831b5	2025-08-31 21:14:43+00	541ad1d7-98c6-42ba-9252-6dc776da1d71	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2e6c84e3-29ac-4202-a0c5-96b9b1861228	2025-01-22 09:34:50+00	46559488-d741-423e-aeb9-4ca82f7b5890	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
59d3ce40-a157-4ff2-9d4c-bcf6c0a21116	2025-04-07 02:46:14+00	759f9ea8-3c81-4fe8-85c5-5397cc9b832d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
426b8444-2d7d-4280-87b1-1027ff285c10	2025-05-16 08:25:37+00	8278c051-7a12-441f-9335-7a58a42f2165	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2da66b6f-1471-481d-8df6-aece86f2de90	2025-06-06 15:10:09+00	fbef497f-7db1-43a7-a2fb-61465d8291b6	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
52b2eafb-4738-46ad-bd12-3d59ff910c03	2025-06-21 02:07:28+00	d1b29906-858b-405d-8bfc-9d9c688881ba	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
78827d48-4c31-4772-9d47-67e60e25d2b9	2025-05-09 20:37:35+00	3aa8566f-1c6c-4457-9e56-85f31ffd39d4	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e9d423c3-dad6-43ec-89ab-87021d056af8	2025-09-19 16:23:41+00	eff3d0cf-f7e7-40ca-ae62-89fd78c4abd8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
43807782-c0f1-4d10-adda-45c65b2e535c	2025-01-05 19:59:30+00	c9ded4c0-3ea7-47a1-827b-29e14963410f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e11e7ed0-f84b-43f0-9471-49694b423953	2025-09-01 20:53:59+00	53fd823f-f0b6-4846-a86a-5a6f32b082ed	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
81c6669e-9f7e-4d7d-b826-3b2032020e7c	2025-03-28 16:53:16+00	706ffd1f-30d6-4cd4-ad96-836d07462866	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
d8c3fbc5-76e6-43eb-9a9d-005674e30afc	2025-07-29 03:56:34+00	72a63ba6-e33c-4ac6-8e75-c761b5d3bc69	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4462b016-e0b0-4540-9d60-2887e9a5767f	2025-01-23 15:11:04+00	d109c5c0-b88e-47b1-9967-47c19bde3737	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8b1d9977-e8da-490a-8a9f-b67c3df4199a	2025-09-22 14:44:45+00	4308d6be-8a4d-46f5-8060-4abc5eb6ac36	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8a2cba90-80cb-4577-9bd8-b97c5840496f	2025-04-28 15:33:51+00	fa9826c9-fa14-4318-a4e8-0fc1bae6b366	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c2ef5dbb-e7b5-4988-bf2d-ff91ecace787	2025-02-06 08:28:30+00	d389ab1c-0bd3-4eed-9a6a-e47a364d1c91	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
331101e6-e9a5-4b49-8f31-7b10f6879b06	2025-02-25 19:00:14+00	03a5cb9a-157c-4b21-8bf8-7054bca18330	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8582c426-c826-42e9-88c8-217c96b432de	2025-05-27 03:20:16+00	bb87f8f2-e257-47d0-b74b-18037adbd2c7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
525d8bea-4e85-468b-b517-b93f48a3ba36	2025-04-02 20:34:33+00	b02251d9-274f-4780-8a9b-a7926bf0ef2d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
24a95a0d-6617-4dd2-976f-8bf79ff0e903	2025-01-08 12:16:34+00	7f9dfa3c-84fb-4590-a7c4-986edba2651b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
28f7cb6c-a299-4812-bc5a-f10d3e260619	2025-07-06 08:55:02+00	79c14c6e-09a6-4fc6-8c94-5c3e3852469c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
226efa52-93a0-4d6c-b9d6-ea132c4fd535	2025-05-24 08:01:12+00	05c5a7c0-ab3a-4795-bf15-c34ef90822de	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
27ff74a6-1a34-4174-9a32-d8de03a71f66	2025-08-04 22:41:47+00	222ff28b-c0af-4643-ac76-3050c682bdbe	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9b45b796-bb7f-443d-bb83-ab9e99fbc9e2	2025-08-06 21:16:59+00	31ee4e82-4dc2-44f4-898d-2f2c95330b71	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
25c1f42e-8be1-44bb-b691-1a5d06a49a76	2025-01-16 07:59:11+00	a1582aa4-f7e6-48c9-b2e6-9a1a614a757a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
62b0727d-68b0-41e2-bf76-5411fa41c964	2025-06-19 21:11:25+00	769d29ed-b7f7-49d0-8ae7-38b40c866fcd	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
d0e67a77-64cc-4d59-81bc-1b5a49fd3cda	2025-07-25 17:54:41+00	8ae9995d-4425-463a-bfd3-0a7ba52904a4	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f5ecb52e-02b5-486a-9a46-6d49fc404954	2025-03-06 18:45:25+00	c74451a7-d733-4b91-ab34-71dade63fb11	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1546f566-2571-4c5f-8f78-6bba8e0afe9f	2025-01-17 16:14:57+00	cc601655-da93-4d86-bee4-51b19294bfed	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ac240e7d-0011-4233-8958-dc5c19352f3b	2025-08-11 01:15:21+00	67ffc536-aeb9-4efa-9c3d-7fad132a8856	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
317b8c5b-78d9-49b3-a4f3-8510d741a9d1	2025-05-08 09:25:04+00	3b7d3bab-063a-4028-933c-14079df90c5e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
340d285d-b98b-454b-b371-ac1d89d58318	2025-03-25 10:09:48+00	a8d89fcd-8817-4c40-a043-97df72e6fbb3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1186879e-b083-40c7-b51a-d7bf6860b348	2025-05-30 14:04:10+00	816f9d2f-7e6b-4ed8-9e05-0d5c1e8300ad	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
20ae85e3-8269-496d-8df3-6389013ca41d	2025-06-09 16:12:12+00	57549ff8-deaf-477a-bb6f-e9e9d834e4cf	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
99f9ec85-3a72-4110-be59-d9afdefe21d5	2025-08-20 23:05:11+00	36e8e6e5-604b-4471-bebe-73e9f0a8d32c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
650c8ab4-804f-4409-bfa5-10b26f8610fb	2025-07-28 09:45:50+00	85ea2922-d772-48ed-b418-906988e581e1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
59893b10-830f-45ae-ac1f-450959f712b3	2025-01-16 21:39:05+00	616efa53-179f-4fbc-a4f8-2a2a249b93ac	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
bceef424-4b29-47c2-8409-f5b9897e681c	2025-03-05 11:30:27+00	b22e4ddf-a20e-4c85-b3db-c6d389f38be1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2c11a5c2-9d3c-4be7-84cc-0155723a7667	2025-03-02 02:44:11+00	f55da3b8-8ed5-4612-995d-c381520fde80	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6f88a97d-f175-40d0-b968-273c0dc967f5	2025-07-24 12:08:13+00	6f7ed7d8-7f29-44cc-b60f-eda4e5871a62	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b638ee2d-80a6-4ff3-b15f-3ea2dc1e3ac2	2025-06-23 12:40:29+00	dc0a6ed5-1baa-431d-9deb-287be9cdad53	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9c2f5e1d-1c89-4a70-8825-64f52270320f	2025-09-08 21:19:37+00	a7062a62-7d3b-455d-923a-f8fb26567e31	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ae30053b-e2c9-4893-891c-172cc2df8766	2025-06-25 22:25:16+00	036da2f6-96e5-44b0-b671-12de851acf0f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5eeea7cb-6bdf-405b-9708-8191fc4424b5	2025-04-09 10:16:29+00	aa2767a1-e713-4e77-b3d7-aaadcf860626	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
44950334-23ad-47ac-8466-4f67d1c04b27	2025-04-25 04:32:45+00	c0f4b06c-eaa7-41fa-bd27-dc2973da4019	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4022498b-124e-4e7f-a690-5c227b7ab3c1	2025-05-25 23:34:23+00	c3b5947d-806e-46b7-87d2-979cdbc65650	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a1a24691-e582-4e5e-ac0c-18a20c4042b2	2025-08-03 11:38:51+00	44af3aa2-1e6f-4159-bec4-422b11427aea	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9b71b1b1-9175-4e94-8df5-8d99337039f3	2025-07-26 10:31:38+00	6e6f2532-7bf2-48da-93f2-676a3c03818b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f6a00ade-1778-4516-955f-dc8933a5c3cb	2025-02-09 07:33:46+00	c5626bcf-deac-431a-89ae-b2551bd4e096	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
16fb54f2-da1c-4d8b-80c6-c3f758af6b8a	2025-01-11 17:37:21+00	762a2ce9-995d-4c50-b6ce-4a79a6ddb522	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3ec83e75-3a39-4fa9-a28d-02fb91767b3a	2025-09-13 20:14:47+00	9e6d2375-9da2-4017-9e20-6a1e1c2f447f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
985f818c-1a1a-4d3e-8bef-69164308c435	2025-01-25 04:05:34+00	da5927b6-c31b-4572-bd0c-579406386e09	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c2a37430-7f62-4c51-88f2-25655b1f982a	2025-08-22 12:31:42+00	1f274993-8c62-44ee-a5b2-9e90791175bc	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6dc3941c-bada-4523-98ba-8c8ff7b8b92a	2025-06-16 13:27:37+00	c5626bcf-deac-431a-89ae-b2551bd4e096	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b44c9ec4-a6be-4749-bf87-a6b12b9fa08d	2025-01-04 10:57:16+00	cfff9d0c-07ea-4bdf-beb8-9b9ac4558433	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
53b43699-f881-46ea-9196-733d65a9f7f6	2025-04-25 02:05:05+00	1ab6eb59-ff73-47a7-a3d2-1b17f92a2656	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
84a0b61f-5665-4166-9a16-016ce275479b	2025-08-17 23:09:46+00	a8d47bdc-647e-4d2b-9a54-421849b3646b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f32b1168-47b6-4aa6-8db0-4a813f1f4642	2025-05-12 04:40:50+00	8a741d8d-aec6-4c43-9076-23da6fea6c8c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9fac23ce-78e4-4547-9122-f8aa6edcc971	2025-05-27 13:04:01+00	bdec438b-83cc-4d1e-a6f9-9d69c19301a3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
34112ecb-61af-4dce-8e91-ebcfa78948b9	2025-04-12 19:57:11+00	cb6f463d-f131-4e24-8fd2-dab5c26b5867	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4563b92f-05ed-47bd-b381-63564b3df8cd	2025-05-17 00:57:17+00	f5468e06-2893-439f-bc21-e72040b44af7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
654b1ef3-ade0-4ed9-854b-2a1172e403e7	2025-08-31 09:03:02+00	42a4c761-851d-441b-a8ac-07b7f4bb979a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1a329d51-580e-419a-8257-9e5603604252	2025-01-29 13:09:34+00	2816c046-f4a5-414d-9128-f4b933a39fe8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
643042eb-8aa7-4861-b2d8-ea84a8985a0e	2025-06-05 13:52:06+00	071b351f-8fd0-4656-bd37-e218663d1c00	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c3dea71b-bcfb-4178-8ffe-2658d60a91eb	2025-06-23 01:11:41+00	816f9d2f-7e6b-4ed8-9e05-0d5c1e8300ad	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4c168f8e-9007-4772-959b-d039729ead3c	2025-06-20 02:34:13+00	94d559c9-1703-4539-9a68-62ffffd1a875	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f1bd4a4f-9854-4cb6-a266-9ef17f74690a	2025-02-25 10:10:43+00	7ffbbbb6-c6ca-4697-95d3-a8d45b9c68e0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
abfccf19-05f0-4433-92f2-9a03dec16d06	2025-06-30 21:42:12+00	4722fec9-9361-4eaa-9f0e-db126be63dd5	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
acfe7c5f-68ab-475f-8cfc-b9134ff4612f	2025-07-28 16:00:39+00	b02251d9-274f-4780-8a9b-a7926bf0ef2d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
0bcc7a69-5df9-48de-9a4f-fe430d477914	2025-08-12 23:28:29+00	deed74cc-86f6-4be3-b300-101c1f632ff2	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a36a97f3-479c-481d-8fd1-19c8bcd8c3d3	2025-07-28 05:11:50+00	c8e83e88-ce78-4377-a36f-be4afd694031	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9950f002-d400-4835-97fe-97a61c858a79	2025-08-04 02:16:59+00	33b35274-80d7-4ba5-901c-ed0e77a82aa5	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
53b1bc46-be1f-4a23-8d19-7b034efedf21	2025-08-31 03:58:16+00	e9a2eb57-88a2-40c1-bf6f-6256ecb75f24	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
616743a4-8c7f-4bdc-9b58-3e546b2bc63a	2025-01-01 09:39:32+00	2b4c5160-fd64-45ea-90df-c7134512f0e1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c1cc4694-d310-488d-8e5d-63847b4c6891	2025-04-21 03:06:07+00	0105ffac-e3c6-4c4a-acba-13e8c6633e8b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2cf249cf-6d5e-41af-8681-77dc129d09ac	2025-04-22 12:38:56+00	6f3a42c5-a91b-4a5a-b9f7-b1de67a0200f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
1d9052a7-123b-4c23-925a-27bb369ebb16	2025-06-23 18:36:10+00	0ad8c796-e0ff-4509-b1dd-deb37d50ec3e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
019ea4d1-14af-409d-89ee-fbf3c80454d7	2025-06-01 04:12:26+00	f9a98114-5664-4b51-a2c3-0de70c2adcc8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
df8d6ba7-5a0d-4ceb-961e-e687721e7c20	2025-03-24 22:00:48+00	905baa6c-bd4b-4750-86af-4c5d319333b6	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e9b759af-dc7b-4a58-bcfc-747a2f9a42d7	2025-04-14 12:24:52+00	d8157441-11b3-4a3f-81c8-814fabb9804f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ca2f4b3c-05d7-468d-b840-0460d1a6c950	2025-05-02 01:25:42+00	a406b8fd-b6f6-4a5b-975d-3274fdc22984	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f68538d9-d585-415e-a966-1e4879e673f6	2025-07-31 02:00:20+00	78847713-061a-4e73-a32d-d2628d9fa33a	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
58bb516e-b6ea-434a-a215-e28baf801d47	2025-02-18 10:43:30+00	c14ced2d-5be0-43b7-916c-fb32f93eda44	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ae75b3b4-b870-4754-8880-04e837237db9	2025-07-27 11:58:56+00	9f72cc06-4bc1-4096-8c9f-0518c37c02f7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c21b52f0-431a-4470-a6f7-4b44be6d4c9e	2025-01-17 22:15:04+00	19958a9e-3d5c-4c21-bda8-815f9e61d3c9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
0acee6b5-430a-464b-97ba-9e6e9f750cee	2025-02-02 18:38:28+00	5ab39e3a-3fa3-4787-bdf1-41f7e7f0c97b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2092e299-3ede-49dc-baa8-6942bbfbae4c	2025-03-08 02:15:29+00	ba54b19e-bd0e-4c3b-9f6a-7fafd95d4f08	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
59a54bf6-277a-4070-a309-a16cdf72e72b	2025-05-07 06:45:06+00	0b133972-7744-4701-a411-0b3db31b97e5	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
09f72230-c54c-451e-b640-69b755f8526c	2025-08-26 03:13:46+00	6bb7d1ce-771b-48b8-9601-1ce04a24fc27	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6cb6a800-5043-433f-ae41-af18c9863d4d	2025-06-06 10:14:54+00	49ad7bac-16ec-4ea8-8bec-b9bf5c2a68f9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f4784dfd-3b6a-43e0-ac1c-28ae332c1e50	2025-08-20 13:45:10+00	6c784636-dd58-4e3d-b92b-77fb3dafeb65	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ab57d331-2736-4ca5-9326-3ee0f948c949	2025-04-04 03:57:04+00	4ffd6975-e624-4d75-96de-6994ce827ba2	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5fbfff3d-7b8d-4de0-8cf7-2aede26c6ebc	2025-03-28 20:25:40+00	a7be77a2-aa7f-48ce-87b6-128f5edff5d0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
06689776-cf7b-49a7-9af2-a1c7e1943392	2025-04-29 21:56:09+00	582b8d6b-d677-4463-af5b-db4c0194210b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9526c4ff-a55b-4e0a-b7a4-b0b58f9c6f6e	2025-08-28 21:57:09+00	b8a4b932-2cd6-4f88-a0bc-3b667426b9cd	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
69b95624-5ea7-46b9-bf49-70f8c2204162	2025-07-13 12:53:46+00	3ab9289b-1ad7-46c8-90cd-5aaeedf422db	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ab0c5c47-42ad-4cd1-ae01-bfedc5e06335	2025-03-07 10:15:04+00	4de717f0-bbcc-4f3e-ba36-df6b058fa10f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f548ae40-f469-4a98-9ab4-36bbb21b38ee	2025-09-02 14:45:36+00	01fa2974-7657-47e4-ba6d-f9ab2296dd15	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
696828dc-8af1-4e10-a1b1-85d38f508324	2025-08-28 07:37:28+00	817d1766-0305-45dd-8519-aadb3127df1b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
0d3087db-c025-4035-b7bd-899b8247bcd4	2025-06-29 10:54:02+00	ee938f3f-c3cb-4591-b579-103165e0a719	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
bba69bcd-4eee-40b5-aa14-769a0d5f71b9	2025-01-02 04:55:23+00	ec58aceb-1baf-4912-a970-59cff2ef10f7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
6ec08346-23fb-4c08-8fd8-389c0a163beb	2025-07-31 22:51:51+00	7899b858-3240-4942-b047-955a0380d8b0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
70661215-9aff-4315-9fc5-027c065db093	2025-02-25 20:54:08+00	e1fda3ad-6807-45cf-b3f3-20670ba49d7b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
cffac55d-8d01-4062-80e1-13d4c49696e2	2025-01-18 22:07:55+00	025259b4-fc8e-455b-81d3-89a92763522f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
dfdd0300-e01c-45ca-bd58-194ef077debc	2025-06-07 13:13:55+00	f7237221-43de-40d1-b74f-14447a3d55ec	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
be4effb4-85e8-4d38-acb3-d641f0571686	2025-04-06 07:54:26+00	b2354cac-019a-4308-addc-7205f5b4b84f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4efb1ecb-9666-464a-86c9-8f5d5776d441	2025-01-26 18:31:59+00	8c2fbf7f-e371-4f6a-bf7b-2b49765545c3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
fd06bf20-2733-4de1-86f1-aac365c3c0ed	2025-03-26 09:14:26+00	c59a8e84-1d0d-437f-96ab-cf5d7f7e3788	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e4e5df46-295e-44cd-a7ce-bfd92050529d	2025-04-26 08:31:15+00	00c97b1c-0b26-41b3-abe4-8e79e3a90c80	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
84b7ec69-3da0-4827-9fbb-3c41ba0a81e8	2025-07-01 15:29:54+00	138592b4-d113-4740-add6-3ff58ce85611	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7fec9c60-97d1-40ff-af2d-af0f6c31f8a7	2025-05-22 21:29:09+00	6d2213ae-6018-43e1-9ca4-ff580b1a8d5c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b57a7b71-d56e-413a-a83e-cd07d045446c	2025-07-15 11:28:31+00	a0e1448c-37ee-4e1d-ba5f-7b2a30b021e8	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3ac2a44e-2d7e-4aac-848a-52a503161e85	2025-05-08 08:57:15+00	8de15ae6-aed2-4233-9462-1f9de7e95a79	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
db1badd8-71cc-4a88-a06d-abebe02ee7fa	2025-03-09 18:34:50+00	863defe7-b55c-4bd0-ba45-a54090c0438e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2a21d19d-fccf-4bb9-8eaf-a5ec16428fc0	2025-02-08 07:42:49+00	274428cc-fea2-4c89-88aa-6eadc0b1cedb	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
84e7bd8c-0ad7-46e7-8dfe-3968c6c807a7	2025-06-25 13:19:30+00	a4f42833-63db-4d30-9f1b-5de562b36809	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a477e93f-ec62-4192-b72d-237e93649f33	2025-03-07 17:11:11+00	82a74b71-8e30-4e7d-aec6-c0d02867853c	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
64bf5e36-4ca9-4761-a7cd-3794329e2424	2025-04-21 17:12:48+00	2912c00f-f5ed-4411-ae00-704e32d85555	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
873132fd-5424-4c58-bf3a-6abe74432ab0	2025-04-20 05:14:10+00	dd8357b7-7ba5-4ef8-8871-59ba3dd67e5b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4a4a14f2-0024-4c6b-8825-a0f0b4e27adf	2025-08-11 20:27:19+00	0c098fe5-258d-4cb9-9514-a32e53e37ae4	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f240e3ce-f856-4de2-803c-b9ed09a26deb	2025-03-27 10:34:55+00	45c2117d-5b42-4671-a1a7-f3bb910938ba	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b5e7ba07-b6b5-40ad-bf4d-22815c5079a8	2025-05-12 07:12:11+00	53821ce0-7738-48f2-bccf-2f6379ba46d0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
346bd78e-f7c1-4da6-afcc-8cb304916ecf	2025-09-05 23:53:10+00	2ff9c668-92b1-4a4a-9234-694322ca1cf3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
13872660-5f31-43e8-b5d2-f6d0cfb6ffda	2025-07-06 20:03:20+00	b28b3c00-f409-485e-acbb-67624a16b612	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
86d84a87-7753-4a61-8dc5-ecec33b095f2	2025-01-01 21:44:33+00	627738b8-0840-42e9-93aa-c1022dbffcc7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9a0156d7-066c-4adf-ab25-b639d2c85d2b	2025-05-24 15:55:23+00	7d3e50be-a1ed-4c45-baac-904700fb6dd6	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
55f039e3-7cba-43cb-a899-44f7c7649d77	2025-07-09 07:35:30+00	0a48853e-8631-4930-9139-a0ff77d98bfc	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3ea59b35-95d6-42fc-8d26-061897e4d2a8	2025-06-10 04:58:54+00	d6fa7d44-9ae4-4c5f-8130-ff14035ffed0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
a2d37279-1651-47c9-8964-bc58ba2f7766	2025-01-07 16:12:54+00	9ff6d4c6-f6bd-41ba-ae5d-6896f8a99d70	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7c190cc8-396b-452c-a86e-9a4b029eaa78	2025-01-21 21:10:40+00	2e1c87ac-dcff-4d4b-a4b7-90e6ca09bdf0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
137e01ef-bf96-4a2b-9ed4-c69197e8d93c	2025-07-24 08:55:41+00	d8157441-11b3-4a3f-81c8-814fabb9804f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
dd00c93f-80d8-4575-b3c4-4df3733a2afe	2025-07-20 04:42:24+00	51182f6b-1aef-494c-b0ab-7b65c1c20f68	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
f8e6b3ac-4a12-4f9c-a5af-8fe0619422ec	2025-04-20 23:51:00+00	7577518f-e010-44ba-ad1a-4093ec0c5c65	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b9a902f1-f383-4fc7-ab3a-808b76119776	2025-06-21 01:54:14+00	f96922cc-14f3-421a-844e-02b7faf42e36	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5a475899-b907-47a0-9b74-d7a44c28c45d	2025-08-29 10:26:51+00	6f3a42c5-a91b-4a5a-b9f7-b1de67a0200f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
36dd238f-16c8-4b6d-805e-0f076a282bc5	2025-08-04 03:28:27+00	0a5af9fb-e5ad-4ec1-842c-e8ff5d96e1a9	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8c30775c-7387-485e-a1e3-b48311e93820	2025-07-01 12:05:29+00	95ce86a0-7069-42fc-b656-168d3db68b96	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5b0f6a5b-5cda-4e34-b841-92e0f187f042	2025-07-24 22:01:39+00	49a25517-3194-43a5-aa36-ec20b6e61295	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9df8a799-2e52-489a-8914-c5a40ffe2506	2025-09-09 23:11:00+00	2baad8a0-4246-4130-9565-f1465e21beee	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7a01433d-4449-4655-9ec4-23cb49977c79	2025-02-03 13:42:36+00	7f68cfb1-84f6-4174-9c3b-736b205f6255	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e78e96a0-29bf-41e7-82ca-37191ebe6682	2025-07-21 21:40:26+00	0a1b4bf0-f782-44b4-87c5-28086bb8944e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9fb60e99-c303-4b61-99fa-dbabe0298b73	2025-07-05 15:31:25+00	c1475344-55c3-44c9-a4fa-9a94d92b3ad5	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7ac3648f-0fad-47e7-b559-704d4eded058	2025-07-25 10:31:05+00	582b8d6b-d677-4463-af5b-db4c0194210b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b3675589-9b4e-45e4-9c7d-8b116c83f0c2	2025-07-16 12:41:54+00	a1088dab-c465-44d3-8f6f-450fb54d8f7f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9e066f71-57dc-4b0f-b198-d4d5c2da6943	2025-05-26 16:51:19+00	35d4855c-3c42-4d28-9402-34478e73934e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
fbf4368e-b376-40ff-8f59-8fae4a89bb25	2025-04-21 05:27:32+00	b6a93203-51df-441d-a4e9-8357dc3c57aa	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
31307789-e6b0-44ed-b9ce-bd7582743d87	2025-03-26 00:46:20+00	3f1b1834-828a-45e1-94d0-a32f73edd2d0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ccfd36b5-9867-4357-918e-775b6a13ae17	2025-02-22 10:30:50+00	68efa735-1545-40e1-bc6f-59386cb42eec	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9c673189-3650-497c-bb8e-cea432195f24	2025-02-06 19:17:19+00	992fd6c1-f6da-491d-8f30-397d9454ace1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3be93ddf-24fa-4a11-8b3a-f873bd9fbf7b	2025-02-20 09:16:16+00	420701ed-b5f2-4870-8476-4186e2725881	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
e5f30e6c-96b7-42a3-bffc-6d1fc991f36d	2025-02-11 09:26:06+00	ee61a57d-66a3-4326-bd8c-24c2521df62e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4fca2ba7-55aa-4bd8-83ed-14a6c274b996	2025-08-17 19:07:48+00	39e2f8c6-2e25-43b0-a8ae-259188785fff	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
ef4fce6c-c216-4bf3-a10a-15d6bce77f94	2025-07-18 17:11:40+00	d6a5db0d-2383-4142-872c-0884282363c3	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
c1b81df1-b1eb-4f4a-b218-5aab6e89d7f9	2025-01-16 23:06:15+00	ff19237b-8724-4e3c-960e-1c6e06aec0c7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
d69ac389-3833-4684-8f50-5a7e9e00ffda	2025-01-11 12:39:59+00	3d00663a-753e-4dfc-8154-ba240126de68	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
5dbfe65f-d09f-4de0-ac22-02eb460de7e9	2025-01-26 00:03:49+00	36d911da-da21-4724-927d-5f0389b8c155	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
190dc437-aabb-400c-843c-7ab83c64dae0	2025-08-29 15:52:56+00	8bf24122-a922-430f-bd2c-e44bdbfd8a29	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9f244e1c-9b85-4e5f-826f-ef37efe2ad1b	2025-05-01 19:01:06+00	eadc3e1b-2cda-4508-9c7a-98a0a6e0e34e	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8760072d-6ab9-49aa-94df-f2c7154017a6	2025-05-02 22:58:33+00	7b965e81-f0bc-4468-9646-f70e5cf74f92	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
38e69936-c671-423e-96bd-150fdc01b57c	2025-02-25 05:29:10+00	9932d484-80f2-4022-98e0-06951604bfba	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7e123710-0d2a-4385-8684-cf431f2f30eb	2025-03-20 19:45:30+00	bb71d39e-7093-487b-8e6a-2be52b6ec5bd	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
0af99923-2595-4550-b08b-94209f0a6342	2025-01-26 07:53:34+00	13906bdb-89b3-4a5c-a200-58ba9deda27b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
92156aa5-f6d6-4e1f-b6a8-6daa3ce7835e	2025-05-26 22:48:31+00	706ffd1f-30d6-4cd4-ad96-836d07462866	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
8f1588ed-8fee-4027-b0a1-e1b5a360dd66	2025-09-12 15:01:43+00	950ab134-5d2d-4363-a9c8-b354b6c701c2	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
03a50453-cff6-460f-929e-6d23c98a31e0	2025-09-27 13:15:21+00	e9ff238c-3c9e-40c0-b970-91f816544406	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3115f2cf-6015-4bee-9d03-20bba3f38819	2025-01-04 16:27:24+00	f95f05d0-ae09-4b8c-951c-980399fa0574	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
4d8f677a-8f36-4f7a-ae53-ebd59735d505	2025-08-02 08:02:19+00	6f7ed7d8-7f29-44cc-b60f-eda4e5871a62	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
74fc3cad-5d31-4f86-96b7-b22859970376	2025-03-11 17:36:55+00	cfee3350-463c-478f-9f9c-16d3c846a7bd	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b1c19e0e-8a41-4676-9103-2ad593157d5e	2025-08-11 16:07:43+00	e015919b-d953-4922-83e0-f7b0eb02f87f	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
b3aab42c-57e3-4688-b683-3f401362cc95	2025-05-27 09:38:56+00	05ef92ce-271f-4b68-b067-5d132ebbe397	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
af0974a1-70cb-4884-980b-f4b4078e936d	2025-01-26 06:16:39+00	6318f4a5-313d-47c9-88c9-3edf06d108c7	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
da1a2d3f-7a99-4c79-ae23-495545b71b44	2025-07-28 14:56:08+00	315114b1-9368-4152-b921-025e74146390	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
08607ad3-480a-4945-a934-b96d6ea030fd	2025-04-21 05:40:47+00	2b98cfe5-b4b4-4984-bf10-ce1a67ed73e1	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
3f2e669c-1d3e-49a3-a5d9-f7d449c3e305	2025-03-19 23:56:38+00	9b71db32-2e8d-4738-9591-bcdac6dd6d67	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
7ece7c8a-95ec-4d16-b3ee-3fa5122ed105	2025-01-10 07:28:56+00	a12aa356-6712-4671-8884-4e53ab4eaeca	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
2d9d678e-0fee-44c3-a911-351552bd549b	2025-05-30 18:46:46+00	b23f9ec1-f087-437f-9e60-a8de6accac26	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
9ff9f917-e737-4cb1-9c2b-d3fc2a6dbeaa	2025-04-02 21:10:31+00	8f8135c0-98c8-49e1-8ca6-cfe514a80013	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
065738ad-d13c-4646-8ee3-1aecc2e81ba7	2025-06-07 20:45:29+00	2da1bce2-8ab0-4f10-acad-e471db3b6ddb	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
51e85022-111e-4b2f-b141-76d0042ab084	2025-07-02 20:57:54+00	97e7c080-2348-4aff-b869-e11e58668497	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
af23ff0a-f05e-4a77-a6e8-747d1aac6b18	2025-03-20 20:35:31+00	5f7e6282-877d-4854-8e8f-73d426a3f57b	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
682fc0f5-6a01-461f-a358-1eb138eecc40	2025-04-03 05:37:54+00	565c3ecd-99c0-42ba-86a4-7bcb6ae4572d	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
21f96094-3dc8-4573-87ae-01e98c850b79	2025-01-27 16:21:31+00	a6ad0e9a-e753-4d1c-b84d-6fdef86c1df0	2025-09-25 04:30:14.270372+00	2025-09-25 04:30:14.270372+00	A
86860fb8-6f26-4f28-9be8-276d06c16b8a	2025-03-23 06:55:21+00	a46633bb-5b2c-4bf8-afad-512612d8f004	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
443b5fee-ce08-4994-98f5-b6b9c75e74f6	2025-02-26 06:09:23+00	5205fc10-9f7e-4ca0-a46e-1e55b8629dc0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6fc62102-14fa-46c8-be9b-cf3935b4f0ae	2025-05-08 22:52:52+00	a5213291-1279-4d51-96fc-a54adc6447ab	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d3f139c5-20f0-4814-9d64-89d703cbf5d1	2025-05-15 01:55:09+00	9b71db32-2e8d-4738-9591-bcdac6dd6d67	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c88dad4d-3293-4c57-b39b-957991bb2f44	2025-05-31 08:43:42+00	c07d79b8-59c5-47b3-81f3-cc0f3aed6104	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
01d87596-cfd1-4a33-a5a3-afc687b9fc5e	2025-01-21 07:34:08+00	12ac2fff-8f3d-4eb7-9b68-c76fc1fbdad8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
04b226bb-5169-486d-ad2e-26a3f3c277bb	2025-08-19 14:43:13+00	83f07b63-df98-472f-959f-e5dda9716569	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
894278f1-a63b-4c52-80fe-aa34545a8629	2025-07-24 15:15:23+00	7d8626cd-ce98-4da3-a842-f3030c88da5c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ae7a7873-27e1-459c-920d-91748499d60c	2025-03-27 18:59:12+00	1cca8b9a-9c38-4eb0-bbee-9555a88f7767	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
45f0653b-a445-47a4-acc9-e13231abb0b7	2025-03-12 01:10:04+00	ca031c40-10b3-4a0a-8f71-cf1b2cd0fb66	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ff6fed51-72b2-4a19-9cbc-6861c66aee8a	2025-07-15 12:02:47+00	7a52dd4b-3550-4617-bd7f-043ab2a641b8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1c764e38-cd41-461a-9ec8-d97187982ab7	2025-08-08 13:56:18+00	c91e2941-1dd8-498d-a089-a9d000406b5d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
29e75bea-4cb6-4bf0-8342-e2a00f220191	2025-06-27 11:13:23+00	dc2665b0-6cdb-4026-8c33-026f11b83e22	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9baa1226-3fce-41c0-9415-863a8770c909	2025-02-21 00:28:01+00	141817f0-d461-456a-b436-d1f0133d62c3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1cdb3f00-6866-4d15-aeec-fd1c087251ad	2025-09-20 06:57:06+00	9cee4f9c-718c-4bd2-b0ba-54b20a53c4ce	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5b7cef35-0333-432c-a41c-3355e75747f2	2025-08-11 10:10:45+00	3027034b-a033-41de-ac0c-bad351395389	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
260c5ea6-e65c-47e4-b88f-a5345ad86fb9	2025-07-24 20:24:44+00	5aeb21eb-16df-4225-b700-dc3c780d6c6f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bea8a935-f088-4989-b741-d28734836f0b	2025-09-05 08:21:35+00	9cb003ff-97fb-4128-bfc4-278543da3a86	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9ddf866a-c7b1-480c-b2cb-a95cccfa1293	2025-04-14 09:17:00+00	18e0f260-5c90-4b75-952e-718986135355	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
44bfddf1-9b55-4e7a-bab3-974805d20e1c	2025-04-05 20:48:45+00	d251066c-1808-4352-b02e-24ea0604a793	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9d403877-bd83-4049-a5c0-ec93f95f6973	2025-08-02 22:38:55+00	be9ec587-8257-4c63-8919-0f5e6f5a3440	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
31008365-6ecd-4fd9-a6bb-e94d23c15333	2025-08-11 14:40:17+00	3aa8566f-1c6c-4457-9e56-85f31ffd39d4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8ad3c805-448c-4596-a4d3-577c1ef68b79	2025-09-22 02:08:25+00	eb21ea89-a4ce-45a2-bb20-4498e5285051	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
29c44409-4491-4a6a-8843-fff08882f07e	2025-07-17 20:16:14+00	c35579b0-340a-4164-8820-8c08c2fa9133	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4b0ec16e-5805-48a6-ad94-28625f3522fa	2025-09-21 07:59:00+00	312b0ddb-aa0c-4ccb-8e8c-9aa9dd035391	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
fb66b6d0-b80d-4a7c-9c8b-25eb4aeda60c	2025-08-17 20:29:12+00	eda495a0-c706-4093-a58e-a4f52c855171	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bf58f402-7f4d-4fa2-a27f-546eca05c308	2025-04-05 12:27:12+00	0c9a896c-29c8-46b7-8469-90ffadc38b3c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
42e0c51d-7b30-48be-b03e-71802fc7811f	2025-07-28 10:42:14+00	443564fd-31da-460b-b7ef-8be8168d4c7b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
38d8a74c-013c-4027-b2f2-721beb36de14	2025-08-02 17:38:28+00	feb51841-b763-4982-a95b-ba8f6b3e6763	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a47099e5-e24f-48ac-b430-227b6dc72c47	2025-07-23 23:55:58+00	a8d89fcd-8817-4c40-a043-97df72e6fbb3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c1f405d6-dd8a-405d-9218-a37d6970e656	2025-05-16 15:32:20+00	f97cd263-93d7-45d2-afe2-9beec715f68d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a1963124-0e73-4dcf-8487-9e22573e91fe	2025-04-16 18:02:12+00	5d1149b0-1ed3-4ea3-a653-0f7db6a0fee6	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c3c934db-f8c9-47be-8b8c-fd7ee1156937	2025-09-15 02:11:22+00	b25b3acb-06fd-4a94-8bce-b77cb46ac2d7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
86af1dd3-a30b-4006-9b43-2c16f5a09fcf	2025-03-28 14:41:41+00	c7b55a64-e944-4faa-8dfa-92394260a389	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
84e30ccb-1a2c-4aab-8f51-535fa4b30f24	2025-08-09 20:44:50+00	75a72fe4-7dcd-4efe-90e0-6c348ca16f42	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c968da4d-d44c-4723-b372-c814d0be40c1	2025-03-01 19:52:18+00	40cb73d0-6db8-4960-80b2-0325ce2ff084	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
485de802-4452-4547-8511-26b2526e13ff	2025-07-30 13:05:56+00	832ba76c-d38e-4ffa-b09c-bb8eba61db56	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
76aa7006-dac5-49a4-af4f-13a435e6b008	2025-09-20 17:06:36+00	8c2fbf7f-e371-4f6a-bf7b-2b49765545c3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4647fc71-9cda-41e0-b773-25dbeb306b51	2025-07-03 02:40:09+00	e73b72b3-9263-4186-8b60-9f05f5ff60fd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
733f73d3-895f-446e-b37c-58d672899e95	2025-07-14 23:51:01+00	bb87f8f2-e257-47d0-b74b-18037adbd2c7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7374c864-9ec5-422b-9cea-44cc4b946383	2025-01-24 00:24:51+00	d291347b-7fe5-487c-8337-0a5af407f88f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7856bf5b-2c19-43d8-b299-88d269f0b82d	2025-05-04 05:27:35+00	79f3a79b-b035-4089-8995-acbaf3831fb7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1bdd0c7a-94a3-4fe7-b49c-9de0deb6b392	2025-06-24 01:21:38+00	1bcbfa69-f081-4b44-b03a-c27c04aa9c15	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9aa91f21-3a06-4000-b2ea-006f267cc7c4	2025-08-13 16:00:39+00	02e3f24f-0e28-4bda-ab9c-23e622123b56	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
13c1c8f6-ea68-41f8-98cf-bf54740fe3b6	2025-07-25 08:46:13+00	887cead9-95fa-4a0b-a499-a60e1f0e4ace	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
83760171-3ba4-4784-a5b9-989f166356d5	2025-03-10 03:57:48+00	0c098fe5-258d-4cb9-9514-a32e53e37ae4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
915e5bc2-8e56-417f-a081-ffeb296d2b35	2025-09-01 20:21:10+00	576228f6-46da-496d-9847-a0c9aff683da	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4e570348-6554-42ca-b80c-f98d2f79b055	2025-06-25 18:49:44+00	83f07b63-df98-472f-959f-e5dda9716569	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0767e0c8-9b15-41c6-bd33-076d94ba2fe6	2025-01-10 15:40:57+00	9fe2bfe1-5fd7-4885-b260-f4dfc6c7005f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
750e4907-ab47-4e1a-a191-e6356a4962aa	2025-07-19 09:42:24+00	3eda5efa-d068-461d-a3c3-7111c14ba7e5	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
32bd1acc-1545-4a61-a0f2-1e47c9f2618f	2025-07-19 13:53:41+00	80393557-fae3-4dc6-9222-aa82c0747848	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
15b13006-4c56-4f21-9475-f3c5d7bfb52a	2025-07-19 01:54:18+00	f205e150-ebe7-4dde-a27e-e88060293e4a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
503e4f9c-9308-4ebc-afca-553d4b11ecce	2025-02-22 12:27:57+00	0a5af9fb-e5ad-4ec1-842c-e8ff5d96e1a9	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ba30a933-902b-4c37-9d2e-3ac7cd395d0b	2025-05-25 18:37:40+00	d62f7501-232f-47e0-9809-ed565f79caff	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b988dff0-ccd3-4c82-bb61-5e6b2efb6546	2025-07-06 04:03:19+00	005ea466-2847-44b8-b342-d67094a6c196	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
82d4a0a9-6fca-4fb8-b03f-18cd805a59a1	2025-04-11 01:20:59+00	2e1a4a68-cd03-4ba4-8850-d5a048f69545	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
05639713-2fc1-4653-991a-6e7b6fb6963d	2025-08-07 17:46:19+00	69669795-f97c-4442-8f37-3ca83c04120d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
232d9918-fda2-4e9c-9209-df494b65366c	2025-06-24 10:38:58+00	da0b9086-534a-45c8-9bc7-af27d10afd1d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d8bf79f9-672b-4378-93a2-2225b3938f84	2025-05-28 20:30:00+00	141d8c14-4a1f-4b3d-8ee7-0292d0490a3b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
646020f9-385d-48af-99f8-1d1c6849ca2e	2025-07-26 01:45:35+00	7f68cfb1-84f6-4174-9c3b-736b205f6255	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f3c7a23e-eeb7-4cd9-a82e-9b95190bab95	2025-05-24 03:42:41+00	c87e6411-01b5-43ab-aa5f-694774ee51aa	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
cc1c0fe4-871d-42f3-aecd-3606874ffa5d	2025-08-31 06:57:38+00	7f9dfa3c-84fb-4590-a7c4-986edba2651b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d03d2567-bc3b-46a2-b2ee-11b8b8523357	2025-06-16 11:40:56+00	5e534def-4117-4667-97cf-40aae09524d7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
79dfa4b0-c8eb-4de9-b1df-56832c39e35f	2025-06-25 12:59:01+00	27efc495-12dd-4456-a09b-1d78cde3bc4c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f4f69eda-bc2a-4145-9730-ab4d5cbf4e89	2025-03-26 14:04:15+00	901def71-ac5e-4709-8e26-716d2fcb2ea1	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
281df8ad-c1e5-46b8-bc29-020b73430fe2	2025-05-07 17:53:53+00	79c14c6e-09a6-4fc6-8c94-5c3e3852469c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
eb38046e-741a-491f-8f27-789b5b7c0903	2025-08-21 06:38:51+00	d1b29906-858b-405d-8bfc-9d9c688881ba	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e44192ad-6d30-4273-b02c-d05dc9017744	2025-04-01 13:15:09+00	00e7d3a7-0eba-4ea0-a569-6e2b6eea02d6	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
21712398-44ef-4649-81cb-1d4a791df344	2025-01-22 19:35:53+00	8d9583a3-0809-48e6-bbd4-8c6863e790ce	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
af68737a-6f35-4095-8e08-f693aca5b974	2025-05-06 22:22:08+00	331aa4f6-aa90-4946-a761-d9180179f4ec	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
967536eb-8cb9-4eb6-a8f7-77c9d6125463	2025-07-22 11:27:39+00	977a10d3-c642-4ca0-9b07-503ac882197e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0078ae72-266c-4cc2-bac4-0b56d1a96b26	2025-05-01 05:18:29+00	98e8b5cc-683c-4ad9-b2a4-804931ecdd40	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0cb4d9f1-82ad-44d7-888c-eec2bd84474f	2025-07-19 00:28:15+00	bbaa7b94-279e-4ee8-964a-476eaf19093c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e0ef9e43-0f15-4514-94bc-47922417f166	2025-02-24 06:04:11+00	ec58aceb-1baf-4912-a970-59cff2ef10f7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6222f2d2-7dca-4536-a261-64aafcb4a1c8	2025-05-29 03:17:42+00	a46633bb-5b2c-4bf8-afad-512612d8f004	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1fc8a267-77bd-4aa5-96c6-4846794fae29	2025-01-02 12:34:15+00	565c3ecd-99c0-42ba-86a4-7bcb6ae4572d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
91b0003f-07e6-45b7-a193-7741a96fe39c	2025-09-22 07:37:05+00	14e4a3e6-2eef-46d0-a1ea-689df5271fb1	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
859c6dcb-2d8f-424a-914c-e2f8990acdf2	2025-01-18 13:58:38+00	dc6a79f3-6f98-4391-bf28-22af2b763935	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
967c1496-21ee-4c91-b2b9-b43ed208655f	2025-04-23 11:57:05+00	33c59aef-a09c-4b5c-9c02-90dcad4c8ae7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4d52611f-06e4-4fac-99fb-1f45b0a1ac57	2025-01-21 17:41:18+00	141d8c14-4a1f-4b3d-8ee7-0292d0490a3b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
12d7868e-c1a3-4618-ab63-a56d9efc5c91	2025-06-27 12:31:01+00	0043e88e-0302-4149-afbc-5f0c50db8cb7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e897f67d-f5e7-45a0-804e-317267bb99e8	2025-06-20 15:07:39+00	79f3a79b-b035-4089-8995-acbaf3831fb7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
dd1f1551-f4d3-40b3-9887-780273c7d8c4	2025-05-20 17:19:43+00	3b647614-41b5-453f-be8a-46a1fd4435e7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5f9dcf77-6bfe-4453-a5eb-c1599dd8bc1d	2025-05-20 16:59:36+00	bc7cb9b6-8b8e-4afa-a9a9-c16b719c692d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
178da109-b1da-4087-8b86-b5a245d666c3	2025-05-25 03:43:38+00	71c53a5a-e1b8-4c35-9c49-cc3b45fdf939	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d94e1b98-75f7-4be4-8e3a-ef61e09030ea	2025-02-05 21:15:30+00	08be2e2f-02bf-4ee5-9df3-8610cbf7711f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f477c695-25e7-413c-ad3b-66603185b512	2025-03-02 09:45:11+00	0c098fe5-258d-4cb9-9514-a32e53e37ae4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7078a458-4849-4d87-8dd1-f705e9d204e9	2025-03-30 09:03:35+00	f93f9664-a320-4ab7-b607-5ea7f9292122	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
3a9ce289-a876-4e46-835a-e120989c8652	2025-02-05 06:05:43+00	d789ec6f-f6f7-4966-8872-32638c25db25	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
603c2afb-984b-4c88-91ea-d4d5e379e8a2	2025-02-21 16:46:47+00	3ddc41b9-282c-4d50-8e34-dff0dedce312	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
826e481e-d428-43a7-8889-ba4cc9ed227e	2025-03-15 09:22:37+00	312b0ddb-aa0c-4ccb-8e8c-9aa9dd035391	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
81e3e409-d429-4a1a-b8f3-2e8e517dac57	2025-09-15 19:45:42+00	a21e647c-01f0-4613-9cc5-3ee1f275474c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5c41331a-7f4e-40ad-b284-eb3737b3a709	2025-03-20 07:21:10+00	19b0f20d-6a07-4c60-ac3d-678788a0e37e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
86517f8b-c37c-4bd9-83b0-d44a59b52fce	2025-01-26 09:44:54+00	f44d5832-7866-493a-9414-fd61678c6dc8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
843741b6-d4c1-47a1-a562-cffa5623c317	2025-09-01 01:41:37+00	0cea6f9d-a803-4c9c-af09-51ffbf97604d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0dd73ff2-8ea2-458a-b8c5-af6d8bb93776	2025-07-08 16:34:35+00	de54f438-9c17-472b-b868-797cb315c98d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
49a53a47-96c0-4d2e-9c20-d187ea1fa421	2025-09-23 10:34:23+00	6dc989ed-8368-44e2-acb1-429f2bfb4065	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c99c3a55-5a02-4422-8bba-8ac5704961c3	2025-03-17 21:18:34+00	95f81659-a717-4419-8525-d18b8276b779	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a662f649-8a61-4f87-9685-bf4512d21b37	2025-08-07 00:08:15+00	ff574694-f7fb-4066-b6f6-636febf39135	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8b06a691-37b4-4a8c-8a84-e7c5b02f8369	2025-05-13 20:04:20+00	769d29ed-b7f7-49d0-8ae7-38b40c866fcd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a6aabe72-0dbe-4ee6-9d9d-a0251eadb3d6	2025-02-25 21:21:40+00	0fe8afec-f9b4-497a-84be-6736511ab241	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
fc35a6e0-5c19-49dd-9ce8-59732d670e5c	2025-06-10 08:18:50+00	03a3a9cb-6f9d-4dd7-9d0b-11e79237938a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
757c9061-6530-4e60-9f51-f749a75cf907	2025-08-21 20:15:11+00	4f24319d-db28-41fd-bbca-ba5354063616	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
123c7f5f-6148-4cc1-8fbd-3289c7c15a2e	2025-05-04 02:20:02+00	3868d5e0-ddb2-4ae6-9611-2b6b95d9296a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
05563c70-d86a-4726-ba56-30fabe6c2764	2025-07-23 05:14:08+00	16938398-a520-4757-942a-1df8896bbbda	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d10ee357-d8f1-458e-8484-fcacc5c4ac3a	2025-08-12 14:30:09+00	a2f1a942-026c-46d9-be43-12b8c76e3e97	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
88208539-9376-4877-ae9b-8071dc1d8d98	2025-06-23 00:16:28+00	44c2a178-1d7d-4793-815c-2b28d04dee81	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4ee52527-2803-491c-be99-3ed35efa903d	2025-07-16 01:17:39+00	53e2f53d-c15b-411c-be68-faed55b71724	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a1a85a8d-8531-4710-9594-d07210cbaaab	2025-08-20 20:20:45+00	576228f6-46da-496d-9847-a0c9aff683da	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e4c5f085-7c50-4767-ae55-f27b0095ca5a	2025-08-31 12:49:55+00	8057d2e0-52ac-498c-a30f-6157fc6c549d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a27f5718-7e62-41fa-bcfb-f245f7e6c4f8	2025-09-28 22:13:08+00	90e464db-5355-4a20-b1bb-8c5d5cf46ad7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d4c1ef8a-7751-488e-8f5f-deb7d506d960	2025-09-18 04:03:20+00	2816c046-f4a5-414d-9128-f4b933a39fe8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c265e8da-7580-4907-8a6d-d9220cd8574f	2025-04-28 23:48:03+00	4918dce9-e477-4029-b77e-c9bd98ed5135	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
14449588-fbb8-4fc7-a2d7-c98a583024a6	2025-05-23 06:30:23+00	bbaa7b94-279e-4ee8-964a-476eaf19093c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
17696562-545d-411b-96ac-553be0bd74d6	2025-09-14 20:31:21+00	ddf73de0-fc75-465f-80b0-797b639369f0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6ae5691a-d04a-4b0c-8233-8ff0f53ffd53	2025-02-07 06:47:37+00	6d75afb0-1a0c-4dac-9f9b-4dcf3abf3607	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
3b72660b-c141-4949-9a58-1991db90bf7d	2025-05-01 01:25:24+00	d7c491c2-00f6-4098-bc21-86a227f9d6c2	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
104b98ef-d1ca-4281-9cdc-0cccad91ffce	2025-02-26 16:32:00+00	9c5a0b76-938e-444e-b077-e80f7a33726a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
123604ff-db0e-49e2-8195-f688783fa74b	2025-06-18 00:56:44+00	f205e150-ebe7-4dde-a27e-e88060293e4a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
dff49b1c-3584-4537-b0a3-39b63729570a	2025-07-28 12:09:25+00	2ad65f1b-9842-42b3-9718-5d78a99bb3c1	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ae53cb3b-f436-4e76-aa4b-7a8df1809e7a	2025-03-04 11:16:14+00	d109c5c0-b88e-47b1-9967-47c19bde3737	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d4281f72-8512-46ed-b992-e0d67b8f11ec	2025-07-19 11:24:29+00	977580b3-4c8f-42d5-970e-d38a9882d0cd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b3e0dab7-bb8f-4118-9ffa-bf9eaef8898a	2025-03-19 13:03:00+00	c903953b-23ea-4b6f-ab9d-04adc7be16bd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5147a3ed-5fe1-49b2-9610-5df09c3c7f92	2025-04-19 05:33:17+00	e78f870c-19ba-46b4-afac-f4afcf75c48f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6910c056-e78e-473f-91be-27421de436b1	2025-08-23 10:11:06+00	ae23c60e-eb3f-4397-84ca-b452fcb976f8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5079071f-a132-45a2-bd5a-34450f07a36c	2025-09-29 05:50:41+00	88b13b15-606c-4992-bc11-6583b7e69175	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
772d52f2-8383-43ac-b62b-8265f7d3fbb5	2025-02-14 12:15:38+00	33f4a985-a783-407a-8ad7-10ba3e1ae8ae	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
fc8eb1ce-7d4e-4d44-9fc2-94875a65f24a	2025-04-09 07:50:53+00	2779b58a-3f53-43b2-9845-c721820aa925	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
20c128f4-782b-4e22-aae7-8675571d5216	2025-03-03 16:12:43+00	0a1b4bf0-f782-44b4-87c5-28086bb8944e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c56ca266-c159-4ab6-9f7b-ddb3b2cd04d5	2025-04-06 00:43:30+00	93872562-3106-45fb-b14b-c3a003f843f6	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0671af9d-ac83-4eee-82fb-e686ea253334	2025-02-28 21:28:45+00	950ab134-5d2d-4363-a9c8-b354b6c701c2	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7f676a50-1486-44ae-95d3-b223ab0ca9c5	2025-01-28 01:06:07+00	acce6966-9917-459c-9285-dae8f366069a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c7be5263-3b3a-450a-a207-2b7d1c69729c	2025-01-03 13:54:09+00	576228f6-46da-496d-9847-a0c9aff683da	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
66d5dff5-1fb9-41b1-b15a-dabe2c70fb70	2025-04-09 18:06:57+00	ac29ba88-d7a6-41f1-a140-c21625392d58	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8272ae10-a8fb-447e-a317-6f6f35bdb5df	2025-07-22 02:10:45+00	f1dd1379-1708-45ef-a3d3-5fdf1fdec5b4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8ed1beb2-62b8-47b4-8d1d-2dee28ca32fa	2025-07-27 12:43:10+00	294b2b0d-b1fd-4fb1-99f3-c3446e40e492	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
24732732-58ca-4efb-9165-3c9b0d9471af	2025-05-09 00:40:08+00	42a4c761-851d-441b-a8ac-07b7f4bb979a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
cca06839-8936-4474-b9ce-9309b36ff30a	2025-06-09 18:04:31+00	fc47f40d-a969-42d6-9025-b69a03e3815e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b6f5c90b-4cbb-4220-80c7-3c945fa3e6f9	2025-05-19 06:22:15+00	953b55e2-8c6c-4c45-a6d8-7a659bd3a73e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
150fc2ed-e9ed-40a6-8a63-901228df41ba	2025-01-28 20:19:04+00	8aca309c-9886-43c8-84cb-1d00a3ceb119	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
12f7f9b0-31c6-41cf-98b5-88aae39e68b2	2025-09-24 01:45:48+00	658d256c-9145-4838-8956-49a64d60416d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
df5cfbc9-3b7f-4ef7-ad78-7e4479c99a9b	2025-01-16 16:51:18+00	071b351f-8fd0-4656-bd37-e218663d1c00	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
95c0e9b4-3cda-468d-b132-7b9806303461	2025-03-07 14:06:32+00	b952397c-66aa-4314-b3cf-da6fba470ca7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
90e77639-78b7-49b1-897b-12d578024a7b	2025-03-18 16:23:33+00	e974f141-ba83-4855-a7f7-fd9ed0800c36	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5c773ac9-d046-4afd-8ebd-8b75f756976b	2025-08-17 14:39:15+00	437825dc-f7b1-4ce3-91a4-fb6d1b0b9ea9	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
75574235-ca38-4468-9173-6c13e625a703	2025-06-01 20:54:55+00	836764ce-2887-44d2-99f3-bea3e4e886e3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
34f95a9f-4e7e-4ccd-8da9-a1b0f72ca2c7	2025-03-16 22:41:50+00	129e303f-90dc-481f-bf39-38d25395e3dc	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
2f96352c-3501-43dd-81f6-53aac41f6fb4	2025-02-20 18:36:21+00	c1d933c3-8326-4a08-8b4a-4103c55335b0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
72326bc6-8625-4cc8-a771-f05af5bf0276	2025-07-17 01:49:37+00	95f81659-a717-4419-8525-d18b8276b779	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
192db6a0-59c5-47b1-83e1-364a3d165fea	2025-05-14 08:53:02+00	83f07b63-df98-472f-959f-e5dda9716569	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
04ba2842-1c75-4c0a-9440-138d32d842bf	2025-06-22 06:09:09+00	953b55e2-8c6c-4c45-a6d8-7a659bd3a73e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
26f6f110-f310-49d5-a742-3d58af2fdfcf	2025-04-02 00:18:29+00	560f688f-4b1c-42bd-88f4-1a2b769c301c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c9ca0c1e-8436-4524-b7f0-da21423547dd	2025-05-31 13:13:43+00	0c3e51b0-4bac-48db-9c19-48bfbf164c88	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
919fe3d6-7154-46b5-bd5f-f3120fee1a0b	2025-04-28 20:49:17+00	2779b58a-3f53-43b2-9845-c721820aa925	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
2f1b8741-8866-4267-90ca-5084ab49e155	2025-05-09 04:33:24+00	14539ec4-3cbc-4189-9aa4-6923119677c9	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
52549fa7-0cbe-42b3-a714-11d46bfad8f4	2025-05-21 19:11:49+00	c7b55a64-e944-4faa-8dfa-92394260a389	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
272b6776-dddf-4ab4-ac22-a81e85805712	2025-06-10 04:14:55+00	d3455ff3-2101-4ed2-b690-481467c42934	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
2d394776-4346-4293-a272-b482ea30acf2	2025-06-12 03:26:48+00	f3e50855-6a50-4f24-ac55-7b346820cd48	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f5d9a35f-a471-4694-b45d-d24d9c682512	2025-07-22 19:27:58+00	afd0ca3a-199c-447e-9d18-31f271a34646	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e9e7ddf6-004d-4f6c-893e-0b261662a06e	2025-06-23 05:55:11+00	15a8eef5-b681-4aea-b206-f7b93429138f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7a07cac1-cb16-48cc-a35f-dd7974c78726	2025-05-17 11:51:04+00	3e9e14e2-71b1-4d8c-b56a-80d2e2e56952	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6f3219d0-334c-4813-984d-8a1daace382c	2025-08-24 14:13:58+00	e8f4c000-8fbc-43fe-8e64-1063de54e12e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
dfb005cd-0407-45b1-a52c-f9b50f1d1d65	2025-07-28 22:36:17+00	18b31370-0f44-400e-ba09-57abe65bb51b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
79c6078f-0f81-43e0-9642-90e4a872edaf	2025-09-06 16:08:18+00	c319b518-4a5a-46a7-b341-3c8dc578a699	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
57feceb2-4b87-4a89-aca7-1325f9705afa	2025-09-10 19:42:06+00	e1fda3ad-6807-45cf-b3f3-20670ba49d7b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f55e497d-80d2-46d4-8ef6-08d5577450e3	2025-07-28 16:05:10+00	e015919b-d953-4922-83e0-f7b0eb02f87f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a09b2292-9ea4-465b-ba62-d0665ac25f6c	2025-02-16 08:30:49+00	8836b2af-fbaf-4c79-bf1b-3275b22e6d00	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9c349870-4a91-4fac-b1c8-a59c6d9aea49	2025-01-24 08:00:58+00	1f8912cc-bf3f-4eb9-a4f3-5d98e9da524f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
82d0a438-b64b-434c-b699-3bb958b99683	2025-02-18 02:01:09+00	b6a93203-51df-441d-a4e9-8357dc3c57aa	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0c5be91b-4cb6-479f-8d5a-d661e3f1446e	2025-09-17 08:39:59+00	ddf73de0-fc75-465f-80b0-797b639369f0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c61eacdb-3561-4f85-a457-7bbdc1e340db	2025-01-21 18:06:36+00	97e7c080-2348-4aff-b869-e11e58668497	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4d3ee623-2887-492c-9353-2ca117ab3d2e	2025-03-18 22:27:28+00	88d2c7e9-0e1c-46b7-b92f-75a6c8ad26ca	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d03a1f35-5561-4042-a79b-ce2f6efed426	2025-06-06 12:23:51+00	255c543f-49b6-4144-b995-1185c1ac7116	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e89e3c79-c3c3-49b7-a2a7-07d311c5bf8e	2025-04-26 00:15:53+00	2b6336f7-a67c-496b-89ec-60969da85f11	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d6a0a1ac-417e-41e1-96e6-061a85cec67a	2025-04-21 03:18:05+00	1bcbfa69-f081-4b44-b03a-c27c04aa9c15	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9208a3c5-c409-4c66-ac38-5d24f4798a1e	2025-01-14 00:22:36+00	eb21ea89-a4ce-45a2-bb20-4498e5285051	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a1a52a7b-6c94-43b6-b8d8-b0aac52b3db1	2025-01-27 18:13:57+00	036da2f6-96e5-44b0-b671-12de851acf0f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
91e34dfa-9d3d-4330-8713-cedf19705c2a	2025-09-18 14:12:13+00	93872562-3106-45fb-b14b-c3a003f843f6	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
2f835276-86b6-4d57-a13f-c8850e3c1655	2025-08-22 12:55:07+00	c14ced2d-5be0-43b7-916c-fb32f93eda44	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
27e301e8-2e68-495a-8e90-334043fd9ec5	2025-06-12 06:57:12+00	ee61a57d-66a3-4326-bd8c-24c2521df62e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5067949e-1cad-4b2d-94e1-ff4180e9526e	2025-03-30 23:26:58+00	e8e995e3-f265-4aed-a3f7-8f07b8a8b6d0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d9b325cd-29c7-44e6-a1dc-039aba44e40b	2025-01-30 05:58:56+00	c532d8dc-3acc-4665-ad97-f9ccddf63731	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7f522f6d-a40e-4b9a-bd19-bf36c9955f27	2025-09-01 04:46:06+00	bc45cfa8-29f9-44fb-94d1-b9214a339992	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6d7d0f2b-4e86-4b62-bf16-76cb84921825	2025-06-23 02:48:18+00	de19579b-cb62-473f-b8aa-52e9b3cd12a2	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bcb288fa-d037-4bb3-a5f3-90ad346ecc4c	2025-08-01 14:07:15+00	b377c9fa-eda9-449e-8bd5-6e12405e4959	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8193f4c2-47fc-41ff-989b-cd23b36c3374	2025-05-19 04:08:23+00	1ad992a0-e8f4-4592-94d7-d3819c22bb7a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c0b3ffb5-4ee4-434d-a99a-8290e08c4562	2025-05-31 16:22:34+00	0d3f9a2c-736d-45df-b12f-4a6819528e95	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
eb690bd9-e70a-4f1a-aee4-8c9a764bd39f	2025-06-28 02:02:25+00	ab48c3eb-d964-455d-881f-97faf8f1a19d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bea8c473-528b-41cf-b562-335723212cfc	2025-06-22 12:03:30+00	91c5c691-df8e-48e9-af2a-20fb71a14cb3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8bb9b9aa-1719-4a93-892f-307d85090bb4	2025-04-10 17:05:31+00	ae23c60e-eb3f-4397-84ca-b452fcb976f8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
32c57f90-438f-4ff4-8607-c09e53b9ddfe	2025-08-01 00:42:00+00	7c303f3d-41e2-4cf2-aaf9-2b090af39b77	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
251661de-8717-434d-b047-add8040b9bf0	2025-08-02 12:51:02+00	1f274993-8c62-44ee-a5b2-9e90791175bc	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
688dccef-34b0-4924-9653-9cf2dbb1d4e9	2025-05-10 10:08:44+00	5394596a-9207-4584-bde1-fd78a915287c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bbdf2ae9-4f93-4611-a772-7d489eb29879	2025-09-26 14:16:40+00	0a2938fa-62b8-4a26-9afe-918a486e713c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e4561b0d-c677-4aa0-8350-5560a9fc3289	2025-06-23 19:14:08+00	49ad7bac-16ec-4ea8-8bec-b9bf5c2a68f9	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8152a226-4276-4a46-9056-dd92ddb1413d	2025-01-27 09:20:56+00	627738b8-0840-42e9-93aa-c1022dbffcc7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6be97509-6f0b-4c4f-8e6a-b27529c67133	2025-08-20 13:37:20+00	816f9d2f-7e6b-4ed8-9e05-0d5c1e8300ad	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
de729129-ee71-4d4f-86b1-2b9f6413b383	2025-04-28 12:54:02+00	c44130c6-a977-441c-aad4-41b141b2c4aa	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
59d98d0b-7e79-4710-833c-9b90ff83b1c9	2025-09-25 20:42:32+00	94c5b780-4ff1-4155-a702-51ddf0c18277	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8b6a006f-45e5-426b-b53b-83a6496c83d3	2025-07-25 19:14:28+00	fb9ce2c4-8da7-46b5-886c-4e76367f5387	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
26d94299-b4a7-48f5-936e-c9975e12dd74	2025-09-24 20:13:04+00	5aeb21eb-16df-4225-b700-dc3c780d6c6f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
49a8611c-52f8-4199-9cd9-8147c287f45e	2025-07-16 15:41:44+00	2e1c87ac-dcff-4d4b-a4b7-90e6ca09bdf0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c1e0cd9b-4de7-4253-b09c-2fb7299fb30d	2025-07-06 02:26:23+00	eeb14492-cad6-4e86-a620-3a912baf9040	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
41af7684-234f-4c36-93d9-550f6dec9dd7	2025-03-26 14:55:03+00	8b334546-6cb6-4d66-a592-a8adebe951ef	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b983e3c2-258f-4546-9f88-e4eff6484f48	2025-08-22 05:38:07+00	79c14c6e-09a6-4fc6-8c94-5c3e3852469c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
41bc1f19-483d-4acd-a210-0fb701278bbe	2025-04-05 04:47:21+00	560f688f-4b1c-42bd-88f4-1a2b769c301c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b0f8fa2c-f1a8-4a95-9fe2-1008c62694e1	2025-04-27 17:45:24+00	c895ce3e-0df2-41f9-927d-4e8aad9db54d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b2de3ca3-8b8e-4329-bc10-05b361d10901	2025-03-16 06:48:34+00	9b06b669-f340-49da-8d00-6e2e2bf19c62	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9afc40e6-096c-4f61-9041-bff7533a1203	2025-02-07 17:24:31+00	7f3953a0-71da-4b96-9b62-f567a513508b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1f0966e0-81ed-436c-abb8-a2767d522dd5	2025-04-09 12:37:48+00	ad450c30-79d8-4762-ad7d-3b118533c789	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0f9d7535-a266-421b-8111-2ba46b2803ac	2025-02-23 15:46:23+00	15acf686-50f0-423e-9d2e-5d92fceb9df1	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
211ce5a1-1e43-42ee-afd4-5f0de060e8e1	2025-03-04 12:01:24+00	b452fffe-c150-42d3-928e-8d5482bde098	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
cacf6667-3f07-4dbd-b449-c1286671c667	2025-08-16 15:05:15+00	fea308c2-ae69-430c-b0f1-e1a4e82191c8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f4601bba-35a6-4906-9539-9e3678219a62	2025-06-03 06:58:40+00	2185a335-e328-4c34-812a-ee0b85bb82e4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7ee6fea3-ff9f-42e6-bb41-9367c3fb6a84	2025-07-26 12:58:59+00	769d29ed-b7f7-49d0-8ae7-38b40c866fcd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
aa564c03-b89f-4e26-819f-b348be96c1eb	2025-04-03 23:34:57+00	d872ca1e-887f-44d1-a0a0-bf1621ea6016	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
94616eca-5069-4a67-a50c-a0e30b58ea7f	2025-01-04 14:06:04+00	299ac0b1-7fdf-4ed9-9c26-6843c5dbaf60	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
24c6a1e6-b633-4ba9-88c6-5c6563dbc936	2025-06-28 18:55:18+00	46ebea9e-fdcc-4ac0-b547-d9257457b5df	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
8af7dd0b-d40b-4a6b-b999-378b1c43d31a	2025-03-06 02:23:06+00	81a65f3f-12b4-4564-b25a-2e07658d2dbd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b8bd434b-b2d4-4b4a-b989-5dce929672d1	2025-06-23 02:55:38+00	0abb2520-e650-44a9-8eb5-d9d41e779455	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
45a00a80-5f66-4221-aa82-5a7d75d997b9	2025-03-09 18:39:03+00	1b70529c-e127-4e1c-a303-4379e0e7a53c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0bc5a22e-be66-412b-b8ee-36cbf6bc31e4	2025-09-13 18:11:52+00	5d2875de-e7ed-4e31-8eaa-ae8c7c51a573	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e1377f75-64b9-426b-87e8-d40f511170c2	2025-07-04 03:25:15+00	f225988b-909b-4ff4-a6e3-41dd8e1bfdcd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7a1bfb17-b859-4250-bf36-5ff26230b8fc	2025-07-27 22:40:42+00	4c65d79b-9ccb-4511-a3ac-e3744b53226c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
326e3fff-476a-4842-91b0-53752eb15c7d	2025-01-04 05:14:17+00	e806573f-624d-44fa-acee-34fda3f3b541	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
3deb824a-cf6b-45b3-b5f9-819dbaeb3eb4	2025-06-30 21:26:14+00	d6fa7d44-9ae4-4c5f-8130-ff14035ffed0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7410efd6-4e05-457b-8560-1aef32d1ffbe	2025-05-31 20:25:22+00	19fe68ff-ae9e-42c5-9a99-89a175a530d4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
03a68ad5-ad3b-4c06-ad83-9715d026142b	2025-06-10 03:54:24+00	7ffbbbb6-c6ca-4697-95d3-a8d45b9c68e0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
188ba3fb-b338-4cc0-b018-e1fe625804b2	2025-07-07 19:19:39+00	a328bead-5dde-47dc-a974-cd8bca1f6f51	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d79f3ce6-cdfb-42f2-bd07-bfe7e69ebe85	2025-05-15 12:20:39+00	d62c309b-c263-4566-ad53-19f02b204a76	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5686613b-1b0e-4868-93e4-29bff9ff402a	2025-07-29 17:48:05+00	56a743d4-f5fb-4d75-a5f3-d00876372458	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
1f5a7650-6543-4791-b064-3290aa6b362c	2025-08-30 08:40:42+00	ce69ebe9-a296-42bb-a597-08c18fbc6c2b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
06507777-7b16-43a7-987e-7f191cb88b6d	2025-04-22 15:40:58+00	0d3f9a2c-736d-45df-b12f-4a6819528e95	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
88d67c80-cddd-4ebe-ad98-0641b5884be1	2025-05-26 02:08:05+00	7f9dfa3c-84fb-4590-a7c4-986edba2651b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
dd160a72-c3e1-421f-896d-53fa9eea0ce3	2025-05-04 14:46:13+00	9934a312-7eaf-4ba5-81ae-a5b5a711f09e	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e7af09a0-4128-438c-8b0c-fd71bf4172de	2025-01-12 22:42:34+00	d1277f28-967d-4240-bb22-806b9022a1e0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6aaf8114-6b7e-433d-a650-c54005da2285	2025-08-15 05:25:23+00	2dc73dc0-7360-4ce3-bb15-bbd96452282f	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ad175f2e-c4bb-4146-8eca-265407645116	2025-05-29 18:45:49+00	293cf87e-ebbb-4bcf-a5b6-f162d82c1638	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ddfaf56d-8d7f-46dc-9a38-85668a57a1b1	2025-05-20 04:17:28+00	73acf395-b113-42e0-9391-57c6143456f4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
bd9572e4-f7f0-4388-948f-735bdb83daf2	2025-07-18 21:39:45+00	5d35d17b-3c48-4cd5-b30a-25d25eb0eb0b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
180172de-af0b-4c91-8f84-2568a026fea8	2025-06-23 01:36:50+00	7577518f-e010-44ba-ad1a-4093ec0c5c65	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
987edebe-d35c-419a-b283-24996973dceb	2025-05-05 12:57:08+00	28f695b2-305a-4330-ba72-37264457717b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d489ffc3-d7f3-41ff-9c01-e7f67dac8933	2025-05-12 23:47:55+00	5489dfae-c903-4fd8-831f-dfe175136ab3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
377076ea-c406-451a-aa04-794eae18719f	2025-07-29 11:02:00+00	fe7e21bb-c297-4e06-8a3e-764eb307ba9d	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b9e2ae9c-46f9-45ae-944a-955e3f9a4952	2025-08-26 01:02:28+00	dd8357b7-7ba5-4ef8-8871-59ba3dd67e5b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
100bf38b-7961-4a14-8746-7bc493e66fdb	2025-06-22 15:26:03+00	706197ba-3cba-4c9b-9431-8ec49c4a01c6	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
2ab2f9b0-1332-4713-ac18-fbfeed89b8e5	2025-04-18 02:42:22+00	deed74cc-86f6-4be3-b300-101c1f632ff2	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a424e6dd-2ac1-4f95-9fa8-f029e5bb7152	2025-01-20 16:15:58+00	c1475344-55c3-44c9-a4fa-9a94d92b3ad5	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
205165a8-2c1b-4eaa-8e25-2d478e315ea1	2025-02-18 16:43:43+00	1b1b1e31-7b86-4dd5-b042-0eb38f0d26a0	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a55c6aed-e1cd-4ae6-8f53-b37cbb1ab41c	2025-02-05 00:09:28+00	cb90b97f-d12e-4325-9a79-50546bea4677	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
f0fd942b-8398-4ecc-8c53-eb8ae30b5908	2025-08-18 15:15:09+00	85fb56b0-ce83-451b-8c53-be8919c14eea	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b051b1d6-9890-4e79-9dc1-f79c967fc9f9	2025-05-28 06:00:15+00	00c97b1c-0b26-41b3-abe4-8e79e3a90c80	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7470174d-b026-4646-a890-96d13435d6a2	2025-08-09 04:47:06+00	8b334546-6cb6-4d66-a592-a8adebe951ef	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4942c836-17b6-4f00-b02b-588aed15e9d3	2025-01-14 21:05:06+00	8b0b8c20-4fa1-439a-90a6-7f5a26d7cbbc	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7a0e8803-b665-46d2-a9f5-79297739c1e6	2025-09-24 13:00:24+00	ad1c6c9b-5a05-47a4-a70c-bf6427727fae	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e55fe7d6-aded-49e0-8610-544f5560872e	2025-05-02 20:14:18+00	a1884b61-e043-4088-96ea-5d0afbb4f877	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c9c94223-2df3-4066-86e1-444b6a2ab4ee	2025-09-09 08:31:49+00	6bc5848a-4f5d-466d-bc9c-6883c64ef67c	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a8f1300e-9928-4a6c-87bb-88e67dc80007	2025-03-27 14:38:35+00	afd0ca3a-199c-447e-9d18-31f271a34646	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
5db9bcf5-30f4-42a7-94e9-d0ff04c9ce83	2025-03-15 13:41:27+00	ff574694-f7fb-4066-b6f6-636febf39135	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
35191e52-834b-49ce-ad39-75e35a3cfbee	2025-09-04 11:36:25+00	57b6ba19-9f86-42f4-8780-e3885c21e6be	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0fbbd80c-1f78-49a7-a474-06be4c1258fb	2025-07-11 16:50:14+00	a8d89fcd-8817-4c40-a043-97df72e6fbb3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a569ad72-ed52-408b-980c-c8dfbb18fe8b	2025-04-30 19:07:56+00	88b13b15-606c-4992-bc11-6583b7e69175	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c2a449db-0250-418d-bcb4-fb0cf9cea4d5	2025-01-10 04:43:50+00	fb8ef9ad-4662-43b4-ab6b-c507758eff6b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
47d04618-8428-4f32-bf9d-b7b282613d88	2025-07-25 10:52:48+00	763f796c-9a03-4934-ae62-061cfe1a4a07	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
77440234-8793-475a-8679-682caf341a6f	2025-01-10 07:14:35+00	40cb73d0-6db8-4960-80b2-0325ce2ff084	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
96add786-acb1-4407-b0de-3843ac033a4c	2025-03-03 01:30:37+00	7ced36ba-9965-437c-83b3-549b7e691d2b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
ab0163d0-e99d-4b45-b6ed-256da0ac008e	2025-01-27 12:05:46+00	f55da3b8-8ed5-4612-995d-c381520fde80	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c14adf70-0385-4c05-958d-e07e8154e2c7	2025-08-15 10:44:32+00	d84e3776-7f43-4ab1-afe3-09313a53fbf3	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
26204835-dcc2-4a79-9c9d-3cd38271fcea	2025-07-08 23:13:39+00	7f9dfa3c-84fb-4590-a7c4-986edba2651b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
0285e8f8-4fa5-416a-9cbf-256b098026c5	2025-09-27 06:43:31+00	13107b10-6838-41e9-bbab-199b505fd4fe	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
06f9659d-9944-4e7f-b875-27476aa80190	2025-05-05 16:44:59+00	cd87bb68-a0f4-4044-a842-d780de9b4813	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
38babc9e-d1b3-41b8-b3c0-b29070e8d22e	2025-03-04 12:53:44+00	8bf928eb-e7e4-4c1a-b629-0bd4185e0c3a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c1cd7c6d-9072-4172-8c7d-bdcb86d702f4	2025-07-10 00:00:35+00	adbfc61b-8950-4067-b9f6-5bc167270e8b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
7d54e41d-6ab0-4c7f-a193-2d2ab5e224c2	2025-01-04 07:05:46+00	8d9583a3-0809-48e6-bbd4-8c6863e790ce	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6882d9a4-73a3-4f7f-8fe6-120bb76a1dcb	2025-05-02 01:10:40+00	44c2a178-1d7d-4793-815c-2b28d04dee81	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
78ec1831-3694-4677-9a36-284665600143	2025-07-30 16:26:04+00	da39ecd3-4ebd-42af-9b5f-f6266e81e8e4	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
a3dae141-e372-465c-a11f-cb3972d4649e	2025-03-04 12:52:37+00	c903953b-23ea-4b6f-ab9d-04adc7be16bd	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4cd05a47-7bfb-45f3-9142-0cb00b39f08f	2025-02-16 05:18:56+00	baf1e99f-21f3-41ea-9a3c-d85814df54ad	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
c4a24deb-273d-41a1-8c33-cdb4fe790380	2025-07-18 12:27:59+00	d1b27565-beeb-4317-8460-e991eff037ed	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d3569393-985f-4053-b8f4-5e14fc51b461	2025-05-08 00:54:11+00	c56c06d1-f595-432f-94ed-0b47142e5e18	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
4b4befc2-d7dd-46bc-b8a5-4f0ed3dda5d8	2025-07-20 09:39:25+00	12b2723e-4f18-46be-a048-04c803213455	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
dafb0045-c051-4e3a-b5b0-87b09fe3034e	2025-03-31 10:46:12+00	3c7646b8-2942-4eac-8454-a4691b45c90b	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
e6c0ba47-4039-4395-bb4b-f0e37705126c	2025-09-02 02:08:42+00	06ddcf3f-c064-4652-8e8b-34186de83544	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
6d8773f9-5e39-407d-b9b0-adbce97a9dc5	2025-01-08 05:33:17+00	98bc4ffa-0f02-4922-acca-7a314a1ca988	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9a41cbce-2a8f-47d9-8994-ba5e8c985c14	2025-03-24 02:15:16+00	de9d8c53-93f6-46cc-bd6e-28dee2d70944	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
3ddfbb5c-a1b2-4101-ba1e-0ff667c1ff78	2025-08-11 16:34:06+00	27664b9d-8ffd-4751-b9e4-1855b86e6afa	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
94cbcd20-2c3c-4343-812a-e323c45b0111	2025-01-28 07:43:13+00	05353d8e-0f9b-4585-87c7-75b1883dceae	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
be15e883-2c37-4a89-9dbb-d77fede72e32	2025-01-19 11:13:22+00	5e4a5339-8386-481d-ac34-8f4fce114ced	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
3c5b50b1-2d09-479e-8389-e5daeea8257a	2025-09-05 14:48:51+00	9483f8af-b652-41fc-9590-d0ce8b5b8329	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
30bbe271-3b24-46e7-8cf9-1b29360fbd83	2025-07-01 04:40:35+00	8a1ce967-a245-4fb7-8104-af299d67fa20	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
efdfbab8-034d-42de-97fc-e0807909bb0d	2025-05-02 04:09:38+00	98d07833-61d5-4937-b4bf-9d40e69dc188	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
16a22e58-1834-4dc8-96d9-08dfe2fc0e67	2025-03-03 15:38:48+00	b47125dd-343e-4672-bd99-2c57b69dc880	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
b3e3b19b-4095-4ade-ab42-48bcd45a84ad	2025-08-09 06:19:13+00	56842b68-9974-4e53-9357-9a0ffedf2859	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
09810df9-2d0e-46f7-b38c-8258e166d908	2025-02-16 06:31:41+00	fc443c78-1a65-487d-b9d7-4c3dd1789a8a	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
d2b4f687-7bf4-4b65-b058-37c2dad6f887	2025-06-16 21:54:32+00	48801623-f4d3-41cc-81a8-0acef0884ae7	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
06ec6966-1cbb-4cf9-8f63-482325332370	2025-09-14 15:20:47+00	4d70fc72-03f4-49f0-b15a-07cf3ea4e4f8	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
9fea60bd-6259-4cc7-b3fd-496c335501a4	2025-04-24 22:58:22+00	18e0f260-5c90-4b75-952e-718986135355	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
80277854-2b1a-4543-b441-c5280a2768c9	2025-05-27 04:35:48+00	7d058523-aaac-4091-bf37-e80ebc5b2b57	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
25b251ee-fa6c-452f-b0eb-a3f90e9403d0	2025-08-21 15:08:41+00	48a960c8-80f1-421d-9058-ae39396310eb	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
98b43bb9-9816-405e-ab39-8bbe4bc01b98	2025-09-26 01:09:54+00	63a1c9d4-8d95-4c98-8ed0-3c25ec6877ac	2025-09-25 15:46:45.093509+00	2025-09-25 15:46:45.093509+00	A
\.


--
-- Name: clientes clientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_key UNIQUE (correo);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: lineas_venta lineas_venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lineas_venta
    ADD CONSTRAINT lineas_venta_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);


--
-- Name: idx_clientes_correo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clientes_correo ON public.clientes USING btree (correo);


--
-- Name: idx_clientes_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clientes_nombre ON public.clientes USING btree (nombre);


--
-- Name: idx_lineas_venta_producto_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lineas_venta_producto_id ON public.lineas_venta USING btree (producto_id);


--
-- Name: idx_lineas_venta_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_lineas_venta_unique ON public.lineas_venta USING btree (venta_id, producto_id);


--
-- Name: idx_lineas_venta_venta_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lineas_venta_venta_id ON public.lineas_venta USING btree (venta_id);


--
-- Name: idx_productos_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_productos_nombre ON public.productos USING btree (nombre);


--
-- Name: idx_productos_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_productos_stock ON public.productos USING btree (stock);


--
-- Name: idx_ventas_cliente_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_cliente_id ON public.ventas USING btree (cliente_id);


--
-- Name: idx_ventas_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_estado ON public.ventas USING btree (estado);


--
-- Name: idx_ventas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_fecha ON public.ventas USING btree (fecha);


--
-- Name: clientes update_clientes_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_clientes_updated_at BEFORE UPDATE ON public.clientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: productos update_productos_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_productos_updated_at BEFORE UPDATE ON public.productos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ventas update_ventas_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_ventas_updated_at BEFORE UPDATE ON public.ventas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: lineas_venta lineas_venta_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lineas_venta
    ADD CONSTRAINT lineas_venta_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE RESTRICT;


--
-- Name: lineas_venta lineas_venta_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lineas_venta
    ADD CONSTRAINT lineas_venta_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.ventas(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict j4CdfVcWatLk0Nylh4ENNfJbjebyNvGi4Uo65YNbxbN9lHD4DTSWIsTqod0sOwL

