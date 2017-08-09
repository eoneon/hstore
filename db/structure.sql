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
    mounting_type_id integer,
    certificate_type_id integer,
    signature_type_id integer
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
    name character varying,
    properties hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    item_type_id integer,
    artist_id integer,
    mounting_type_id integer,
    certificate_type_id integer,
    signature_type_id integer
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
-- Name: mounting_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mounting_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mounting_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mounting_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mounting_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mounting_types_id_seq OWNED BY mounting_types.id;


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
    properties character varying
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
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: certificate_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_types ALTER COLUMN id SET DEFAULT nextval('certificate_types_id_seq'::regclass);


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
-- Name: mounting_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mounting_types ALTER COLUMN id SET DEFAULT nextval('mounting_types_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: signature_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signature_types ALTER COLUMN id SET DEFAULT nextval('signature_types_id_seq'::regclass);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: certificate_types certificate_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY certificate_types
    ADD CONSTRAINT certificate_types_pkey PRIMARY KEY (id);


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
-- Name: mounting_types mounting_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mounting_types
    ADD CONSTRAINT mounting_types_pkey PRIMARY KEY (id);


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
-- Name: index_item_fields_on_certificate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_certificate_type_id ON item_fields USING btree (certificate_type_id);


--
-- Name: index_item_fields_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_item_type_id ON item_fields USING btree (item_type_id);


--
-- Name: index_item_fields_on_mounting_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_mounting_type_id ON item_fields USING btree (mounting_type_id);


--
-- Name: index_item_fields_on_signature_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_fields_on_signature_type_id ON item_fields USING btree (signature_type_id);


--
-- Name: index_items_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_artist_id ON items USING btree (artist_id);


--
-- Name: index_items_on_certificate_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_certificate_type_id ON items USING btree (certificate_type_id);


--
-- Name: index_items_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_item_type_id ON items USING btree (item_type_id);


--
-- Name: index_items_on_mounting_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_mounting_type_id ON items USING btree (mounting_type_id);


--
-- Name: index_items_on_signature_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_signature_type_id ON items USING btree (signature_type_id);


--
-- Name: index_searches_on_item_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_item_type_id ON searches USING btree (item_type_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: items fk_rails_2190cda116; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_2190cda116 FOREIGN KEY (artist_id) REFERENCES artists(id);


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
-- Name: item_fields fk_rails_9cf276619f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_9cf276619f FOREIGN KEY (signature_type_id) REFERENCES signature_types(id);


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
-- Name: items fk_rails_de821dde30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_de821dde30 FOREIGN KEY (mounting_type_id) REFERENCES mounting_types(id);


--
-- Name: item_fields fk_rails_eeff7f6bad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_fields
    ADD CONSTRAINT fk_rails_eeff7f6bad FOREIGN KEY (mounting_type_id) REFERENCES mounting_types(id);


--
-- Name: items fk_rails_f33fab0fcc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT fk_rails_f33fab0fcc FOREIGN KEY (signature_type_id) REFERENCES signature_types(id);


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

