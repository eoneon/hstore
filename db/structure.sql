--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: add_disclaimer_type_reference_to_item_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE add_disclaimer_type_reference_to_item_fields (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: add_disclaimer_type_reference_to_item_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE add_disclaimer_type_reference_to_item_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: add_disclaimer_type_reference_to_item_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE add_disclaimer_type_reference_to_item_fields_id_seq OWNED BY add_disclaimer_type_reference_to_item_fields.id;


--
-- Name: artist_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE artist_items (
    id integer NOT NULL,
    artist_id integer,
    item_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: artist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artist_items_id_seq OWNED BY artist_items.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE artists (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying,
    sort integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    kind character varying
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: certificate_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE certificate_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: certificate_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE certificate_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificate_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE certificate_types_id_seq OWNED BY certificate_types.id;


--
-- Name: dimension_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE dimension_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dimension_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dimension_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dimension_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dimension_types_id_seq OWNED BY dimension_types.id;


--
-- Name: disclaimer_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE disclaimer_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: disclaimer_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE disclaimer_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: disclaimer_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE disclaimer_types_id_seq OWNED BY disclaimer_types.id;


--
-- Name: displays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE displays (
    id integer NOT NULL,
    name character varying,
    artist_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: displays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE displays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: displays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE displays_id_seq OWNED BY displays.id;


--
-- Name: edition_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE edition_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: edition_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edition_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edition_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edition_types_id_seq OWNED BY edition_types.id;


--
-- Name: embellish_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE embellish_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: embellish_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE embellish_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: embellish_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE embellish_types_id_seq OWNED BY embellish_types.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoices (
    id integer NOT NULL,
    invoice integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- Name: item_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_fields (
    id integer NOT NULL,
    field_type character varying,
    required boolean,
    item_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    certificate_type_id integer,
    signature_type_id integer,
    substrate_type_id integer,
    dimension_type_id integer,
    edition_type_id integer,
    reserve_type_id integer,
    disclaimer_type_id integer
);


--
-- Name: item_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_fields_id_seq OWNED BY item_fields.id;


--
-- Name: item_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_types_id_seq OWNED BY item_types.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    properties hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    item_type_id integer,
    mounting_type_id integer,
    certificate_type_id integer,
    signature_type_id integer,
    image_width integer,
    image_height integer,
    substrate_type_id integer,
    retail integer,
    title text,
    sku integer,
    invoice_id integer,
    art_type character varying,
    category character varying,
    dimension_type_id integer,
    embellish_type_id integer,
    edition_type_id integer,
    image_size double precision,
    reserve_type_id integer,
    disclaimer_type_id integer
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: reserve_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reserve_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reserve_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reserve_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reserve_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reserve_types_id_seq OWNED BY reserve_types.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE searches (
    id integer NOT NULL,
    keywords character varying,
    item_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    properties character varying,
    substrate_type_id integer,
    signature_type_id integer,
    certificate_type_id integer,
    image_width integer,
    image_height integer,
    edition_type_id integer,
    dimension_type_id integer,
    artist_id integer,
    width double precision,
    height double precision,
    title character varying
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searches_id_seq OWNED BY searches.id;


--
-- Name: signature_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE signature_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: signature_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signature_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signature_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signature_types_id_seq OWNED BY signature_types.id;


--
-- Name: substrate_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE substrate_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: substrate_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE substrate_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: substrate_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE substrate_types_id_seq OWNED BY substrate_types.id;


--
-- Name: title_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE title_items (
    id integer NOT NULL,
    title_id integer,
    item_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: title_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE title_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: title_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE title_items_id_seq OWNED BY title_items.id;


--
-- Name: titles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE titles (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: titles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE titles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: titles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE titles_id_seq OWNED BY titles.id;


--
-- Name: value_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE value_items (
    id integer NOT NULL,
    kind character varying,
    name character varying,
    sort integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_value_id integer
);


--
-- Name: value_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE value_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: value_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE value_items_id_seq OWNED BY value_items.id;


--
-- Name: add_disclaimer_type_reference_to_item_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY add_disclaimer_type_reference_to_item_fields ALTER COLUMN id SET DEFAULT nextval('add_disclaimer_type_reference_to_item_fields_id_seq'::regclass);


--
-- Name: artist_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_items ALTER COLUMN id SET DEFAULT nextval('artist_items_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: certificate_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_types ALTER COLUMN id SET DEFAULT nextval('certificate_types_id_seq'::regclass);


--
-- Name: dimension_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dimension_types ALTER COLUMN id SET DEFAULT nextval('dimension_types_id_seq'::regclass);


--
-- Name: disclaimer_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY disclaimer_types ALTER COLUMN id SET DEFAULT nextval('disclaimer_types_id_seq'::regclass);


--
-- Name: displays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY displays ALTER COLUMN id SET DEFAULT nextval('displays_id_seq'::regclass);


--
-- Name: edition_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY edition_types ALTER COLUMN id SET DEFAULT nextval('edition_types_id_seq'::regclass);


--
-- Name: embellish_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY embellish_types ALTER COLUMN id SET DEFAULT nextval('embellish_types_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- Name: item_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields ALTER COLUMN id SET DEFAULT nextval('item_fields_id_seq'::regclass);


--
-- Name: item_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_types ALTER COLUMN id SET DEFAULT nextval('item_types_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: reserve_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reserve_types ALTER COLUMN id SET DEFAULT nextval('reserve_types_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: signature_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signature_types ALTER COLUMN id SET DEFAULT nextval('signature_types_id_seq'::regclass);


--
-- Name: substrate_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY substrate_types ALTER COLUMN id SET DEFAULT nextval('substrate_types_id_seq'::regclass);


--
-- Name: title_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY title_items ALTER COLUMN id SET DEFAULT nextval('title_items_id_seq'::regclass);


--
-- Name: titles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY titles ALTER COLUMN id SET DEFAULT nextval('titles_id_seq'::regclass);


--
-- Name: value_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY value_items ALTER COLUMN id SET DEFAULT nextval('value_items_id_seq'::regclass);


--
-- Name: add_disclaimer_type_reference_to_item_fields add_disclaimer_type_reference_to_item_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY add_disclaimer_type_reference_to_item_fields
    ADD CONSTRAINT add_disclaimer_type_reference_to_item_fields_pkey PRIMARY KEY (id);


--
-- Name: artist_items artist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_items
    ADD CONSTRAINT artist_items_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: certificate_types certificate_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_types
    ADD CONSTRAINT certificate_types_pkey PRIMARY KEY (id);


--
-- Name: dimension_types dimension_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dimension_types
    ADD CONSTRAINT dimension_types_pkey PRIMARY KEY (id);


--
-- Name: disclaimer_types disclaimer_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY disclaimer_types
    ADD CONSTRAINT disclaimer_types_pkey PRIMARY KEY (id);


--
-- Name: displays displays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY displays
    ADD CONSTRAINT displays_pkey PRIMARY KEY (id);


--
-- Name: edition_types edition_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY edition_types
    ADD CONSTRAINT edition_types_pkey PRIMARY KEY (id);


--
-- Name: embellish_types embellish_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY embellish_types
    ADD CONSTRAINT embellish_types_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: item_fields item_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT item_fields_pkey PRIMARY KEY (id);


--
-- Name: item_types item_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_types
    ADD CONSTRAINT item_types_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: reserve_types reserve_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reserve_types
    ADD CONSTRAINT reserve_types_pkey PRIMARY KEY (id);


--
-- Name: searches searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: signature_types signature_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY signature_types
    ADD CONSTRAINT signature_types_pkey PRIMARY KEY (id);


--
-- Name: substrate_types substrate_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY substrate_types
    ADD CONSTRAINT substrate_types_pkey PRIMARY KEY (id);


--
-- Name: title_items title_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title_items
    ADD CONSTRAINT title_items_pkey PRIMARY KEY (id);


--
-- Name: titles titles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (id);


--
-- Name: value_items value_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY value_items
    ADD CONSTRAINT value_items_pkey PRIMARY KEY (id);


--
-- Name: index_artist_items_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_items_on_artist_id ON artist_items USING btree (artist_id);


--
-- Name: index_artist_items_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_items_on_item_id ON artist_items USING btree (item_id);


--
-- Name: index_displays_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_displays_on_artist_id ON displays USING btree (artist_id);


--
-- Name: index_item_fields_on_certificate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_certificate_type_id ON item_fields USING btree (certificate_type_id);


--
-- Name: index_item_fields_on_dimension_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_dimension_type_id ON item_fields USING btree (dimension_type_id);


--
-- Name: index_item_fields_on_disclaimer_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_disclaimer_type_id ON item_fields USING btree (disclaimer_type_id);


--
-- Name: index_item_fields_on_edition_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_edition_type_id ON item_fields USING btree (edition_type_id);


--
-- Name: index_item_fields_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_item_type_id ON item_fields USING btree (item_type_id);


--
-- Name: index_item_fields_on_reserve_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_reserve_type_id ON item_fields USING btree (reserve_type_id);


--
-- Name: index_item_fields_on_signature_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_signature_type_id ON item_fields USING btree (signature_type_id);


--
-- Name: index_item_fields_on_substrate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_substrate_type_id ON item_fields USING btree (substrate_type_id);


--
-- Name: index_items_on_certificate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_certificate_type_id ON items USING btree (certificate_type_id);


--
-- Name: index_items_on_dimension_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_dimension_type_id ON items USING btree (dimension_type_id);


--
-- Name: index_items_on_disclaimer_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_disclaimer_type_id ON items USING btree (disclaimer_type_id);


--
-- Name: index_items_on_edition_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_edition_type_id ON items USING btree (edition_type_id);


--
-- Name: index_items_on_embellish_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_embellish_type_id ON items USING btree (embellish_type_id);


--
-- Name: index_items_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_invoice_id ON items USING btree (invoice_id);


--
-- Name: index_items_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_item_type_id ON items USING btree (item_type_id);


--
-- Name: index_items_on_mounting_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_mounting_type_id ON items USING btree (mounting_type_id);


--
-- Name: index_items_on_reserve_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_reserve_type_id ON items USING btree (reserve_type_id);


--
-- Name: index_items_on_signature_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_signature_type_id ON items USING btree (signature_type_id);


--
-- Name: index_items_on_substrate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_substrate_type_id ON items USING btree (substrate_type_id);


--
-- Name: index_searches_on_certificate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_certificate_type_id ON searches USING btree (certificate_type_id);


--
-- Name: index_searches_on_dimension_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_dimension_type_id ON searches USING btree (dimension_type_id);


--
-- Name: index_searches_on_edition_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_edition_type_id ON searches USING btree (edition_type_id);


--
-- Name: index_searches_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_item_type_id ON searches USING btree (item_type_id);


--
-- Name: index_searches_on_signature_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_signature_type_id ON searches USING btree (signature_type_id);


--
-- Name: index_searches_on_substrate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_substrate_type_id ON searches USING btree (substrate_type_id);


--
-- Name: index_title_items_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_title_items_on_item_id ON title_items USING btree (item_id);


--
-- Name: index_title_items_on_title_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_title_items_on_title_id ON title_items USING btree (title_id);


--
-- Name: index_value_items_on_parent_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_value_items_on_parent_value_id ON value_items USING btree (parent_value_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: item_fields fk_rails_06eaf1db85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_06eaf1db85 FOREIGN KEY (dimension_type_id) REFERENCES dimension_types(id);


--
-- Name: searches fk_rails_0a13cb5f64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_0a13cb5f64 FOREIGN KEY (certificate_type_id) REFERENCES certificate_types(id);


--
-- Name: items fk_rails_10c92a7db6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_10c92a7db6 FOREIGN KEY (invoice_id) REFERENCES invoices(id);


--
-- Name: items fk_rails_1240dd3783; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_1240dd3783 FOREIGN KEY (dimension_type_id) REFERENCES dimension_types(id);


--
-- Name: items fk_rails_1507fef2dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_1507fef2dd FOREIGN KEY (substrate_type_id) REFERENCES substrate_types(id);


--
-- Name: searches fk_rails_1c204d5c87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_1c204d5c87 FOREIGN KEY (dimension_type_id) REFERENCES dimension_types(id);


--
-- Name: item_fields fk_rails_374eed167f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_374eed167f FOREIGN KEY (reserve_type_id) REFERENCES reserve_types(id);


--
-- Name: item_fields fk_rails_45b5719c1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_45b5719c1d FOREIGN KEY (disclaimer_type_id) REFERENCES disclaimer_types(id);


--
-- Name: searches fk_rails_48c976852a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_48c976852a FOREIGN KEY (substrate_type_id) REFERENCES substrate_types(id);


--
-- Name: title_items fk_rails_4cf5b6c98a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title_items
    ADD CONSTRAINT fk_rails_4cf5b6c98a FOREIGN KEY (title_id) REFERENCES titles(id);


--
-- Name: items fk_rails_53473d0118; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_53473d0118 FOREIGN KEY (edition_type_id) REFERENCES edition_types(id);


--
-- Name: items fk_rails_56a4639c34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_56a4639c34 FOREIGN KEY (embellish_type_id) REFERENCES embellish_types(id);


--
-- Name: item_fields fk_rails_58724ce616; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_58724ce616 FOREIGN KEY (substrate_type_id) REFERENCES substrate_types(id);


--
-- Name: searches fk_rails_5e7a92d8a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_5e7a92d8a0 FOREIGN KEY (signature_type_id) REFERENCES signature_types(id);


--
-- Name: searches fk_rails_676e169dba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_676e169dba FOREIGN KEY (edition_type_id) REFERENCES edition_types(id);


--
-- Name: items fk_rails_6bed0f90a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_6bed0f90a5 FOREIGN KEY (item_type_id) REFERENCES item_types(id);


--
-- Name: searches fk_rails_8008e11d5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_8008e11d5a FOREIGN KEY (item_type_id) REFERENCES item_types(id);


--
-- Name: items fk_rails_8346602730; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_8346602730 FOREIGN KEY (disclaimer_type_id) REFERENCES disclaimer_types(id);


--
-- Name: artist_items fk_rails_83fbd3f795; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_items
    ADD CONSTRAINT fk_rails_83fbd3f795 FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_fields fk_rails_9cf276619f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_9cf276619f FOREIGN KEY (signature_type_id) REFERENCES signature_types(id);


--
-- Name: title_items fk_rails_a50849e65b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title_items
    ADD CONSTRAINT fk_rails_a50849e65b FOREIGN KEY (item_id) REFERENCES items(id);


--
-- Name: item_fields fk_rails_a6e4d93288; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_a6e4d93288 FOREIGN KEY (item_type_id) REFERENCES item_types(id);


--
-- Name: items fk_rails_aaaefcdef2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_aaaefcdef2 FOREIGN KEY (certificate_type_id) REFERENCES certificate_types(id);


--
-- Name: item_fields fk_rails_bc0fdfef92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_bc0fdfef92 FOREIGN KEY (certificate_type_id) REFERENCES certificate_types(id);


--
-- Name: displays fk_rails_c725fa2dec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY displays
    ADD CONSTRAINT fk_rails_c725fa2dec FOREIGN KEY (artist_id) REFERENCES artists(id);


--
-- Name: artist_items fk_rails_d905fc3a1a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_items
    ADD CONSTRAINT fk_rails_d905fc3a1a FOREIGN KEY (artist_id) REFERENCES artists(id);


--
-- Name: items fk_rails_dc9cece0bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_dc9cece0bc FOREIGN KEY (reserve_type_id) REFERENCES reserve_types(id);


--
-- Name: items fk_rails_f33fab0fcc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_f33fab0fcc FOREIGN KEY (signature_type_id) REFERENCES signature_types(id);


--
-- Name: item_fields fk_rails_f444bd9019; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_f444bd9019 FOREIGN KEY (edition_type_id) REFERENCES edition_types(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20170710182320');

INSERT INTO schema_migrations (version) VALUES ('20170710233541');

INSERT INTO schema_migrations (version) VALUES ('20170710233809');

INSERT INTO schema_migrations (version) VALUES ('20170711000609');

INSERT INTO schema_migrations (version) VALUES ('20170711004141');

INSERT INTO schema_migrations (version) VALUES ('20170711205828');

INSERT INTO schema_migrations (version) VALUES ('20170717181834');

INSERT INTO schema_migrations (version) VALUES ('20170724202957');

INSERT INTO schema_migrations (version) VALUES ('20170724203100');

INSERT INTO schema_migrations (version) VALUES ('20170806223623');

INSERT INTO schema_migrations (version) VALUES ('20170806224223');

INSERT INTO schema_migrations (version) VALUES ('20170806230231');

INSERT INTO schema_migrations (version) VALUES ('20170808004355');

INSERT INTO schema_migrations (version) VALUES ('20170808004542');

INSERT INTO schema_migrations (version) VALUES ('20170808004809');

INSERT INTO schema_migrations (version) VALUES ('20170808234944');

INSERT INTO schema_migrations (version) VALUES ('20170808235013');

INSERT INTO schema_migrations (version) VALUES ('20170808235312');

INSERT INTO schema_migrations (version) VALUES ('20170818031334');

INSERT INTO schema_migrations (version) VALUES ('20170818145907');

INSERT INTO schema_migrations (version) VALUES ('20170818150111');

INSERT INTO schema_migrations (version) VALUES ('20170818150315');

INSERT INTO schema_migrations (version) VALUES ('20170821191741');

INSERT INTO schema_migrations (version) VALUES ('20170821234701');

INSERT INTO schema_migrations (version) VALUES ('20170824161153');

INSERT INTO schema_migrations (version) VALUES ('20170824162842');

INSERT INTO schema_migrations (version) VALUES ('20170828233649');

INSERT INTO schema_migrations (version) VALUES ('20170828235333');

INSERT INTO schema_migrations (version) VALUES ('20170829000409');

INSERT INTO schema_migrations (version) VALUES ('20170829000554');

INSERT INTO schema_migrations (version) VALUES ('20170831215118');

INSERT INTO schema_migrations (version) VALUES ('20170901002002');

INSERT INTO schema_migrations (version) VALUES ('20170916173823');

INSERT INTO schema_migrations (version) VALUES ('20170921184659');

INSERT INTO schema_migrations (version) VALUES ('20170927180330');

INSERT INTO schema_migrations (version) VALUES ('20171003022542');

INSERT INTO schema_migrations (version) VALUES ('20171003210537');

INSERT INTO schema_migrations (version) VALUES ('20171006211405');

INSERT INTO schema_migrations (version) VALUES ('20171006221810');

INSERT INTO schema_migrations (version) VALUES ('20171007181058');

INSERT INTO schema_migrations (version) VALUES ('20171007183115');

INSERT INTO schema_migrations (version) VALUES ('20171007183242');

INSERT INTO schema_migrations (version) VALUES ('20171009025717');

INSERT INTO schema_migrations (version) VALUES ('20171012220244');

INSERT INTO schema_migrations (version) VALUES ('20171012220701');

INSERT INTO schema_migrations (version) VALUES ('20171012220748');

INSERT INTO schema_migrations (version) VALUES ('20171012220830');

INSERT INTO schema_migrations (version) VALUES ('20171013011210');

INSERT INTO schema_migrations (version) VALUES ('20171014011058');

INSERT INTO schema_migrations (version) VALUES ('20171017012712');

INSERT INTO schema_migrations (version) VALUES ('20171017012916');

INSERT INTO schema_migrations (version) VALUES ('20171017012937');

INSERT INTO schema_migrations (version) VALUES ('20171017013933');

INSERT INTO schema_migrations (version) VALUES ('20171017014115');

INSERT INTO schema_migrations (version) VALUES ('20171103212425');

INSERT INTO schema_migrations (version) VALUES ('20171104205917');

INSERT INTO schema_migrations (version) VALUES ('20171106231637');

INSERT INTO schema_migrations (version) VALUES ('20171107001352');

INSERT INTO schema_migrations (version) VALUES ('20171108022815');

INSERT INTO schema_migrations (version) VALUES ('20171108041059');

INSERT INTO schema_migrations (version) VALUES ('20171108041726');

INSERT INTO schema_migrations (version) VALUES ('20171108045701');

INSERT INTO schema_migrations (version) VALUES ('20171108161151');

INSERT INTO schema_migrations (version) VALUES ('20171108162249');

INSERT INTO schema_migrations (version) VALUES ('20171108162955');

INSERT INTO schema_migrations (version) VALUES ('20171108164415');

INSERT INTO schema_migrations (version) VALUES ('20171108164905');

INSERT INTO schema_migrations (version) VALUES ('20171108165240');

INSERT INTO schema_migrations (version) VALUES ('20171108165813');

INSERT INTO schema_migrations (version) VALUES ('20171108170352');

INSERT INTO schema_migrations (version) VALUES ('20171108170618');

INSERT INTO schema_migrations (version) VALUES ('20171109211339');

INSERT INTO schema_migrations (version) VALUES ('20171110055042');

INSERT INTO schema_migrations (version) VALUES ('20171205233506');

INSERT INTO schema_migrations (version) VALUES ('20171205234118');

INSERT INTO schema_migrations (version) VALUES ('20171205234338');

INSERT INTO schema_migrations (version) VALUES ('20171207211130');

INSERT INTO schema_migrations (version) VALUES ('20171207211327');

INSERT INTO schema_migrations (version) VALUES ('20171207211557');

INSERT INTO schema_migrations (version) VALUES ('20171207213343');

