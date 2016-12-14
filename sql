--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

-- Started on 2016-12-14 14:02:46 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12397)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2173 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 183 (class 1259 OID 26499)
-- Name: album_ids; Type: SEQUENCE; Schema: public; Owner: perl
--

CREATE SEQUENCE album_ids
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE album_ids OWNER TO perl;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 185 (class 1259 OID 26503)
-- Name: albums; Type: TABLE; Schema: public; Owner: perl
--

CREATE TABLE albums (
    id integer DEFAULT nextval('album_ids'::regclass) NOT NULL,
    album character varying(255),
    band character varying(255),
    year integer,
    user_id integer
);


ALTER TABLE albums OWNER TO perl;

--
-- TOC entry 184 (class 1259 OID 26501)
-- Name: track_ids; Type: SEQUENCE; Schema: public; Owner: perl
--

CREATE SEQUENCE track_ids
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE track_ids OWNER TO perl;

--
-- TOC entry 186 (class 1259 OID 26517)
-- Name: tracks; Type: TABLE; Schema: public; Owner: perl
--

CREATE TABLE tracks (
    id integer DEFAULT nextval('track_ids'::regclass) NOT NULL,
    track character varying(255),
    format character varying(20),
    image character varying(255),
    album_id integer
);


ALTER TABLE tracks OWNER TO perl;

--
-- TOC entry 182 (class 1259 OID 26490)
-- Name: user_ids; Type: SEQUENCE; Schema: public; Owner: perl
--

CREATE SEQUENCE user_ids
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_ids OWNER TO perl;

--
-- TOC entry 181 (class 1259 OID 26482)
-- Name: users; Type: TABLE; Schema: public; Owner: perl
--

CREATE TABLE users (
    id integer DEFAULT nextval('user_ids'::regclass) NOT NULL,
    login character(22),
    password character(255)
);


ALTER TABLE users OWNER TO perl;

--
-- TOC entry 2174 (class 0 OID 0)
-- Dependencies: 183
-- Name: album_ids; Type: SEQUENCE SET; Schema: public; Owner: perl
--

SELECT pg_catalog.setval('album_ids', 4, true);


--
-- TOC entry 2164 (class 0 OID 26503)
-- Dependencies: 185
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: perl
--

COPY albums (id, album, band, year, user_id) FROM stdin;
1	sdf123	\N	1123	4
2	sdf123asd	\N	1123	4
3	sdf123asdasdasd	sdf123sdf	1123	4
4	The Menagerie Inside	Midas Fall	2015	4
\.


--
-- TOC entry 2175 (class 0 OID 0)
-- Dependencies: 184
-- Name: track_ids; Type: SEQUENCE SET; Schema: public; Owner: perl
--

SELECT pg_catalog.setval('track_ids', 28, true);


--
-- TOC entry 2165 (class 0 OID 26517)
-- Dependencies: 186
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: perl
--

COPY tracks (id, track, format, image, album_id) FROM stdin;
1	asdas	asdasd	123123	1
2	asdqqqqqqq	qweqwe	xcvxcvd	1
3	Push	ogg	\N	4
4	Counting Colours	ogg	\N	\N
5	Counting Colours	ogg	\N	\N
6	Counting Colours	ogg	\N	\N
7	Counting Colours	ogg	\N	\N
8	Counting Colours	ogg	\N	\N
9	Counting Colours	ogg	\N	\N
10	Counting Colours	ogg	\N	\N
11	Counting Colours	ogg	\N	\N
12	Counting Colours	ogg	\N	\N
13	Counting Colours	ogg	\N	\N
14	Low	ogg	\N	\N
15	Push	ogg	\N	\N
16	Counting Colours	ogg	\N	\N
17	Low	ogg	\N	\N
18	Push	ogg	\N	\N
19	Counting Colours	ogg	\N	\N
20	Low	ogg	\N	4
21	Push	ogg	\N	4
22	Counting Colours	ogg	\N	4
23	Low	ogg	\N	4
24	Push	ogg	\N	4
25	Counting Colours	ogg	\N	4
26	aaaaaaaa	ss	/home/kiryanenko/MusicLibrary/images/1481491532orig.png	1
27	aaaaaaaaaaaaaaadsd	ss	/home/kiryanenko/MusicLibrary/images/1481491775orig.png	1
28	aaaaaaaaaaaaaaadsd	ss	/images/1481491798orig.png	1
\.


--
-- TOC entry 2176 (class 0 OID 0)
-- Dependencies: 182
-- Name: user_ids; Type: SEQUENCE SET; Schema: public; Owner: perl
--

SELECT pg_catalog.setval('user_ids', 4, true);


--
-- TOC entry 2160 (class 0 OID 26482)
-- Dependencies: 181
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: perl
--

COPY users (id, login, password) FROM stdin;
1	asd1                  	123                                                                                                                                                                                                                                                            
2	asd                   	qwe                                                                                                                                                                                                                                                            
3	123asd                	asd                                                                                                                                                                                                                                                            
4	qwerty                	123                                                                                                                                                                                                                                                            
\.


--
-- TOC entry 2041 (class 2606 OID 26510)
-- Name: album_pkey; Type: CONSTRAINT; Schema: public; Owner: perl
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- TOC entry 2043 (class 2606 OID 26524)
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: perl
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- TOC entry 2039 (class 2606 OID 26489)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: perl
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2045 (class 2606 OID 26526)
-- Name: album; Type: FK CONSTRAINT; Schema: public; Owner: perl
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT album FOREIGN KEY (album_id) REFERENCES albums(id);


--
-- TOC entry 2044 (class 2606 OID 26512)
-- Name: user; Type: FK CONSTRAINT; Schema: public; Owner: perl
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT "user" FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2172 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-12-14 14:02:47 MSK

--
-- PostgreSQL database dump complete
--

