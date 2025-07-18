PGDMP  +    9                 }         
   project_sw    16.8    16.8 W    /           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            0           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            1           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            2           1262    24027 
   project_sw    DATABASE     p   CREATE DATABASE project_sw WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-CO';
    DROP DATABASE project_sw;
                postgres    false                        3079    24028    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false            3           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
                        false    2            �            1259    25341    administradores_parqueadero    TABLE     x   CREATE TABLE public.administradores_parqueadero (
    admin_id integer NOT NULL,
    parqueadero_id integer NOT NULL
);
 /   DROP TABLE public.administradores_parqueadero;
       public         heap    postgres    false            �            1259    25233    barrios    TABLE     m   CREATE TABLE public.barrios (
    id integer NOT NULL,
    nombre text NOT NULL,
    geom public.geometry
);
    DROP TABLE public.barrios;
       public         heap    postgres    false    2    2    2    2    2    2    2    2            �            1259    25232    barrios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.barrios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.barrios_id_seq;
       public          postgres    false    224            4           0    0    barrios_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.barrios_id_seq OWNED BY public.barrios.id;
          public          postgres    false    223            �            1259    25242 	   contactos    TABLE     k   CREATE TABLE public.contactos (
    id integer NOT NULL,
    telefono text,
    imagen_parqueadero text
);
    DROP TABLE public.contactos;
       public         heap    postgres    false            �            1259    25241    contactos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contactos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.contactos_id_seq;
       public          postgres    false    226            5           0    0    contactos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.contactos_id_seq OWNED BY public.contactos.id;
          public          postgres    false    225            �            1259    25270    horarios_parqueadero    TABLE       CREATE TABLE public.horarios_parqueadero (
    id integer NOT NULL,
    parqueadero_id integer NOT NULL,
    dia_semana text NOT NULL,
    horario_apertura time without time zone,
    horario_cierre time without time zone,
    CONSTRAINT horarios_parqueadero_check CHECK ((((dia_semana = 'Todos'::text) AND (horario_apertura IS NULL) AND (horario_cierre IS NULL)) OR ((dia_semana <> 'Todos'::text) AND (((horario_apertura IS NOT NULL) AND (horario_cierre IS NOT NULL) AND (horario_apertura < horario_cierre)) OR ((horario_apertura IS NULL) AND (horario_cierre IS NULL)))))),
    CONSTRAINT horarios_parqueadero_dia_semana_check CHECK ((dia_semana = ANY (ARRAY['Lunes'::text, 'Martes'::text, 'Miércoles'::text, 'Jueves'::text, 'Viernes'::text, 'Sábado'::text, 'Domingo'::text, 'Todos'::text])))
);
 (   DROP TABLE public.horarios_parqueadero;
       public         heap    postgres    false            �            1259    25269    horarios_parqueadero_id_seq    SEQUENCE     �   CREATE SEQUENCE public.horarios_parqueadero_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.horarios_parqueadero_id_seq;
       public          postgres    false    230            6           0    0    horarios_parqueadero_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.horarios_parqueadero_id_seq OWNED BY public.horarios_parqueadero.id;
          public          postgres    false    229            �            1259    25286    informacion_parqueadero    TABLE     f  CREATE TABLE public.informacion_parqueadero (
    id integer NOT NULL,
    parqueadero_id integer NOT NULL,
    tipo_vehiculo text NOT NULL,
    tarifa numeric(8,2),
    capacidad integer,
    CONSTRAINT informacion_parqueadero_capacidad_check CHECK ((capacidad >= 0)),
    CONSTRAINT informacion_parqueadero_tarifa_check CHECK ((tarifa >= (0)::numeric))
);
 +   DROP TABLE public.informacion_parqueadero;
       public         heap    postgres    false            �            1259    25285    informacion_parqueadero_id_seq    SEQUENCE     �   CREATE SEQUENCE public.informacion_parqueadero_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.informacion_parqueadero_id_seq;
       public          postgres    false    232            7           0    0    informacion_parqueadero_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.informacion_parqueadero_id_seq OWNED BY public.informacion_parqueadero.id;
          public          postgres    false    231            �            1259    25357    movimientos    TABLE     v  CREATE TABLE public.movimientos (
    id integer NOT NULL,
    parqueadero_id integer NOT NULL,
    usuario_cedula text NOT NULL,
    tipo_vehiculo text NOT NULL,
    placa text,
    ingreso timestamp without time zone DEFAULT now() NOT NULL,
    salida timestamp without time zone,
    costo numeric(8,2),
    CONSTRAINT movimientos_tipo_vehiculo_check CHECK ((tipo_vehiculo = ANY (ARRAY['carro'::text, 'moto'::text, 'bicicleta'::text]))),
    CONSTRAINT placa_required CHECK ((((tipo_vehiculo = ANY (ARRAY['carro'::text, 'moto'::text])) AND (placa IS NOT NULL)) OR ((tipo_vehiculo = 'bicicleta'::text) AND (placa IS NULL))))
);
    DROP TABLE public.movimientos;
       public         heap    postgres    false            �            1259    25356    movimientos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.movimientos_id_seq;
       public          postgres    false    239            8           0    0    movimientos_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.movimientos_id_seq OWNED BY public.movimientos.id;
          public          postgres    false    238            �            1259    25251    parqueaderos    TABLE     �   CREATE TABLE public.parqueaderos (
    id integer NOT NULL,
    nombre text NOT NULL,
    direccion text,
    barrio_id integer,
    contacto_id integer,
    geom public.geometry,
    imagen_url text
);
     DROP TABLE public.parqueaderos;
       public         heap    postgres    false    2    2    2    2    2    2    2    2            �            1259    25250    parqueaderos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.parqueaderos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.parqueaderos_id_seq;
       public          postgres    false    228            9           0    0    parqueaderos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.parqueaderos_id_seq OWNED BY public.parqueaderos.id;
          public          postgres    false    227            �            1259    25318    reservas_parqueadero    TABLE     �  CREATE TABLE public.reservas_parqueadero (
    id integer NOT NULL,
    parqueadero_id integer NOT NULL,
    usuario_id integer NOT NULL,
    tipo_vehiculo text NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    costo_estimado numeric(8,2),
    estado text DEFAULT 'pendiente'::text,
    CONSTRAINT reservas_parqueadero_check CHECK ((fecha_inicio < fecha_fin)),
    CONSTRAINT reservas_parqueadero_costo_estimado_check CHECK ((costo_estimado >= (0)::numeric)),
    CONSTRAINT reservas_parqueadero_estado_check CHECK ((estado = ANY (ARRAY['pendiente'::text, 'confirmada'::text, 'cancelada'::text, 'completada'::text])))
);
 (   DROP TABLE public.reservas_parqueadero;
       public         heap    postgres    false            �            1259    25317    reservas_parqueadero_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reservas_parqueadero_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.reservas_parqueadero_id_seq;
       public          postgres    false    236            :           0    0    reservas_parqueadero_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.reservas_parqueadero_id_seq OWNED BY public.reservas_parqueadero.id;
          public          postgres    false    235            �            1259    25304    rutas    TABLE     z   CREATE TABLE public.rutas (
    id integer NOT NULL,
    id_usuario integer,
    nombre text,
    geom public.geometry
);
    DROP TABLE public.rutas;
       public         heap    postgres    false    2    2    2    2    2    2    2    2            �            1259    25303    rutas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rutas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rutas_id_seq;
       public          postgres    false    234            ;           0    0    rutas_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rutas_id_seq OWNED BY public.rutas.id;
          public          postgres    false    233            �            1259    25216    usuarios    TABLE     �  CREATE TABLE public.usuarios (
    id integer NOT NULL,
    usuario text NOT NULL,
    correo text NOT NULL,
    nombre text,
    apellidos text,
    cedula text,
    "contraseña" text NOT NULL,
    rol text NOT NULL,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT usuarios_rol_check CHECK ((rol = ANY (ARRAY['admin'::text, 'usuario'::text])))
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false            �            1259    25215    usuarios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public          postgres    false    222            <           0    0    usuarios_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;
          public          postgres    false    221            I           2604    25236 
   barrios id    DEFAULT     h   ALTER TABLE ONLY public.barrios ALTER COLUMN id SET DEFAULT nextval('public.barrios_id_seq'::regclass);
 9   ALTER TABLE public.barrios ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    224    224            J           2604    25245    contactos id    DEFAULT     l   ALTER TABLE ONLY public.contactos ALTER COLUMN id SET DEFAULT nextval('public.contactos_id_seq'::regclass);
 ;   ALTER TABLE public.contactos ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    226    226            L           2604    25273    horarios_parqueadero id    DEFAULT     �   ALTER TABLE ONLY public.horarios_parqueadero ALTER COLUMN id SET DEFAULT nextval('public.horarios_parqueadero_id_seq'::regclass);
 F   ALTER TABLE public.horarios_parqueadero ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    230    230            M           2604    25289    informacion_parqueadero id    DEFAULT     �   ALTER TABLE ONLY public.informacion_parqueadero ALTER COLUMN id SET DEFAULT nextval('public.informacion_parqueadero_id_seq'::regclass);
 I   ALTER TABLE public.informacion_parqueadero ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231    232            Q           2604    25360    movimientos id    DEFAULT     p   ALTER TABLE ONLY public.movimientos ALTER COLUMN id SET DEFAULT nextval('public.movimientos_id_seq'::regclass);
 =   ALTER TABLE public.movimientos ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    239    239            K           2604    25254    parqueaderos id    DEFAULT     r   ALTER TABLE ONLY public.parqueaderos ALTER COLUMN id SET DEFAULT nextval('public.parqueaderos_id_seq'::regclass);
 >   ALTER TABLE public.parqueaderos ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    228    228            O           2604    25321    reservas_parqueadero id    DEFAULT     �   ALTER TABLE ONLY public.reservas_parqueadero ALTER COLUMN id SET DEFAULT nextval('public.reservas_parqueadero_id_seq'::regclass);
 F   ALTER TABLE public.reservas_parqueadero ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235    236            N           2604    25307    rutas id    DEFAULT     d   ALTER TABLE ONLY public.rutas ALTER COLUMN id SET DEFAULT nextval('public.rutas_id_seq'::regclass);
 7   ALTER TABLE public.rutas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    234    234            G           2604    25219    usuarios id    DEFAULT     j   ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
 :   ALTER TABLE public.usuarios ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221    222            *          0    25341    administradores_parqueadero 
   TABLE DATA           O   COPY public.administradores_parqueadero (admin_id, parqueadero_id) FROM stdin;
    public          postgres    false    237   �q                 0    25233    barrios 
   TABLE DATA           3   COPY public.barrios (id, nombre, geom) FROM stdin;
    public          postgres    false    224   �q                 0    25242 	   contactos 
   TABLE DATA           E   COPY public.contactos (id, telefono, imagen_parqueadero) FROM stdin;
    public          postgres    false    226   q      #          0    25270    horarios_parqueadero 
   TABLE DATA           p   COPY public.horarios_parqueadero (id, parqueadero_id, dia_semana, horario_apertura, horario_cierre) FROM stdin;
    public          postgres    false    230   6      %          0    25286    informacion_parqueadero 
   TABLE DATA           g   COPY public.informacion_parqueadero (id, parqueadero_id, tipo_vehiculo, tarifa, capacidad) FROM stdin;
    public          postgres    false    232   �      ,          0    25357    movimientos 
   TABLE DATA           w   COPY public.movimientos (id, parqueadero_id, usuario_cedula, tipo_vehiculo, placa, ingreso, salida, costo) FROM stdin;
    public          postgres    false    239   y	      !          0    25251    parqueaderos 
   TABLE DATA           g   COPY public.parqueaderos (id, nombre, direccion, barrio_id, contacto_id, geom, imagen_url) FROM stdin;
    public          postgres    false    228   �	      )          0    25318    reservas_parqueadero 
   TABLE DATA           �   COPY public.reservas_parqueadero (id, parqueadero_id, usuario_id, tipo_vehiculo, fecha_inicio, fecha_fin, costo_estimado, estado) FROM stdin;
    public          postgres    false    236   �
      '          0    25304    rutas 
   TABLE DATA           =   COPY public.rutas (id, id_usuario, nombre, geom) FROM stdin;
    public          postgres    false    234   �
      F          0    24346    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          postgres    false    217   ,                0    25216    usuarios 
   TABLE DATA           q   COPY public.usuarios (id, usuario, correo, nombre, apellidos, cedula, "contraseña", rol, creado_en) FROM stdin;
    public          postgres    false    222   I      =           0    0    barrios_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.barrios_id_seq', 1, false);
          public          postgres    false    223            >           0    0    contactos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.contactos_id_seq', 20, true);
          public          postgres    false    225            ?           0    0    horarios_parqueadero_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.horarios_parqueadero_id_seq', 42, true);
          public          postgres    false    229            @           0    0    informacion_parqueadero_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.informacion_parqueadero_id_seq', 24, true);
          public          postgres    false    231            A           0    0    movimientos_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.movimientos_id_seq', 5, true);
          public          postgres    false    238            B           0    0    parqueaderos_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.parqueaderos_id_seq', 16, true);
          public          postgres    false    227            C           0    0    reservas_parqueadero_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.reservas_parqueadero_id_seq', 1, false);
          public          postgres    false    235            D           0    0    rutas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.rutas_id_seq', 4, true);
          public          postgres    false    233            E           0    0    usuarios_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.usuarios_id_seq', 14, true);
          public          postgres    false    221            y           2606    25345 <   administradores_parqueadero administradores_parqueadero_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.administradores_parqueadero
    ADD CONSTRAINT administradores_parqueadero_pkey PRIMARY KEY (admin_id, parqueadero_id);
 f   ALTER TABLE ONLY public.administradores_parqueadero DROP CONSTRAINT administradores_parqueadero_pkey;
       public            postgres    false    237    237            i           2606    25240    barrios barrios_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.barrios
    ADD CONSTRAINT barrios_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.barrios DROP CONSTRAINT barrios_pkey;
       public            postgres    false    224            k           2606    25249    contactos contactos_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.contactos
    ADD CONSTRAINT contactos_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.contactos DROP CONSTRAINT contactos_pkey;
       public            postgres    false    226            o           2606    25279 .   horarios_parqueadero horarios_parqueadero_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.horarios_parqueadero
    ADD CONSTRAINT horarios_parqueadero_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.horarios_parqueadero DROP CONSTRAINT horarios_parqueadero_pkey;
       public            postgres    false    230            q           2606    25297 P   informacion_parqueadero informacion_parqueadero_parqueadero_id_tipo_vehiculo_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.informacion_parqueadero
    ADD CONSTRAINT informacion_parqueadero_parqueadero_id_tipo_vehiculo_key UNIQUE (parqueadero_id, tipo_vehiculo);
 z   ALTER TABLE ONLY public.informacion_parqueadero DROP CONSTRAINT informacion_parqueadero_parqueadero_id_tipo_vehiculo_key;
       public            postgres    false    232    232            s           2606    25295 4   informacion_parqueadero informacion_parqueadero_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.informacion_parqueadero
    ADD CONSTRAINT informacion_parqueadero_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.informacion_parqueadero DROP CONSTRAINT informacion_parqueadero_pkey;
       public            postgres    false    232            {           2606    25367    movimientos movimientos_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT movimientos_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.movimientos DROP CONSTRAINT movimientos_pkey;
       public            postgres    false    239            m           2606    25258    parqueaderos parqueaderos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.parqueaderos
    ADD CONSTRAINT parqueaderos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.parqueaderos DROP CONSTRAINT parqueaderos_pkey;
       public            postgres    false    228            w           2606    25329 .   reservas_parqueadero reservas_parqueadero_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.reservas_parqueadero
    ADD CONSTRAINT reservas_parqueadero_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.reservas_parqueadero DROP CONSTRAINT reservas_parqueadero_pkey;
       public            postgres    false    236            u           2606    25311    rutas rutas_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rutas
    ADD CONSTRAINT rutas_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.rutas DROP CONSTRAINT rutas_pkey;
       public            postgres    false    234            a           2606    25231    usuarios usuarios_cedula_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_cedula_key UNIQUE (cedula);
 F   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_cedula_key;
       public            postgres    false    222            c           2606    25229    usuarios usuarios_correo_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);
 F   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_correo_key;
       public            postgres    false    222            e           2606    25225    usuarios usuarios_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public            postgres    false    222            g           2606    25227    usuarios usuarios_usuario_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_usuario_key UNIQUE (usuario);
 G   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_usuario_key;
       public            postgres    false    222            �           2606    25346 E   administradores_parqueadero administradores_parqueadero_admin_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.administradores_parqueadero
    ADD CONSTRAINT administradores_parqueadero_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.usuarios(id);
 o   ALTER TABLE ONLY public.administradores_parqueadero DROP CONSTRAINT administradores_parqueadero_admin_id_fkey;
       public          postgres    false    5733    222    237            �           2606    25351 K   administradores_parqueadero administradores_parqueadero_parqueadero_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.administradores_parqueadero
    ADD CONSTRAINT administradores_parqueadero_parqueadero_id_fkey FOREIGN KEY (parqueadero_id) REFERENCES public.parqueaderos(id);
 u   ALTER TABLE ONLY public.administradores_parqueadero DROP CONSTRAINT administradores_parqueadero_parqueadero_id_fkey;
       public          postgres    false    5741    237    228            ~           2606    25280 =   horarios_parqueadero horarios_parqueadero_parqueadero_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.horarios_parqueadero
    ADD CONSTRAINT horarios_parqueadero_parqueadero_id_fkey FOREIGN KEY (parqueadero_id) REFERENCES public.parqueaderos(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.horarios_parqueadero DROP CONSTRAINT horarios_parqueadero_parqueadero_id_fkey;
       public          postgres    false    228    230    5741                       2606    25298 C   informacion_parqueadero informacion_parqueadero_parqueadero_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.informacion_parqueadero
    ADD CONSTRAINT informacion_parqueadero_parqueadero_id_fkey FOREIGN KEY (parqueadero_id) REFERENCES public.parqueaderos(id) ON DELETE CASCADE;
 m   ALTER TABLE ONLY public.informacion_parqueadero DROP CONSTRAINT informacion_parqueadero_parqueadero_id_fkey;
       public          postgres    false    5741    232    228            �           2606    25368 +   movimientos movimientos_parqueadero_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT movimientos_parqueadero_id_fkey FOREIGN KEY (parqueadero_id) REFERENCES public.parqueaderos(id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.movimientos DROP CONSTRAINT movimientos_parqueadero_id_fkey;
       public          postgres    false    228    5741    239            |           2606    25259 (   parqueaderos parqueaderos_barrio_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.parqueaderos
    ADD CONSTRAINT parqueaderos_barrio_id_fkey FOREIGN KEY (barrio_id) REFERENCES public.barrios(id);
 R   ALTER TABLE ONLY public.parqueaderos DROP CONSTRAINT parqueaderos_barrio_id_fkey;
       public          postgres    false    228    224    5737            }           2606    25264 *   parqueaderos parqueaderos_contacto_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.parqueaderos
    ADD CONSTRAINT parqueaderos_contacto_id_fkey FOREIGN KEY (contacto_id) REFERENCES public.contactos(id);
 T   ALTER TABLE ONLY public.parqueaderos DROP CONSTRAINT parqueaderos_contacto_id_fkey;
       public          postgres    false    226    5739    228            �           2606    25330 =   reservas_parqueadero reservas_parqueadero_parqueadero_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_parqueadero
    ADD CONSTRAINT reservas_parqueadero_parqueadero_id_fkey FOREIGN KEY (parqueadero_id) REFERENCES public.parqueaderos(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.reservas_parqueadero DROP CONSTRAINT reservas_parqueadero_parqueadero_id_fkey;
       public          postgres    false    228    5741    236            �           2606    25335 9   reservas_parqueadero reservas_parqueadero_usuario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas_parqueadero
    ADD CONSTRAINT reservas_parqueadero_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);
 c   ALTER TABLE ONLY public.reservas_parqueadero DROP CONSTRAINT reservas_parqueadero_usuario_id_fkey;
       public          postgres    false    5733    222    236            �           2606    25312    rutas rutas_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rutas
    ADD CONSTRAINT rutas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);
 E   ALTER TABLE ONLY public.rutas DROP CONSTRAINT rutas_id_usuario_fkey;
       public          postgres    false    5733    222    234            *      x�34�44�2��`Ҍ+F��� )8@            x��}Y�(�q�w{�9�9��!ذ�̶� Eڤ$@���1�S9D�Ul��w_ܪ�!2�̈H���w?~��?���?)�����A����i�_�����c�&Wm��M%�z�M�0�*N5�ZwE�R9OT7K���3�(��L-}.yJ)L�����H��8�����K+���y�l2�Z��J;�C���DO?r�Fi#8��Y�iGޒ��k�I�ރN$M����5I������E%Sb���ڷ�G�IC��{L}������媎���j�}*ڌb�<r�G�)�%w��a�*��Kl��Ԗ<��Z����j������{��Βv�Z�s�Tڑ7]L��<��!������������IɸR���Rh��Z���V%���)�c�w�S��5U���^U�}��
��P��?��c�OT�՘uq�?����_�C~��T(����]�1�;��E��y�*�_�w#��O�LD{fQG>��1��?ۂ���|�7瞃��}3�����o@k��g|[�.x+r�������a<0���oL���T�y�p���Ŝ�h�-�iuD_s�G�{��۸�YM_c9��#V��K^�@�Ry4n��˒[����w�-l
�����g����W�詹��?琯~�^lwg��4L2V�ο�A����n��l�裡��v,�nV�R�<�K������5�k��I����1avJ�o�\�
�K�U�J�'���Hm�u����E�-�B��P>��s��a�d���ʶ�I��_+�z��%OԐ6����'T���}����?�����_���������ǿ�����X�<�U�'C�`k��>�6E�i�e$��
�`�%z�g1zk
>��Kn�R3TmˋX��aYڊ��RK�蓼��y�m��R�=��.�����R����-BO<}ض4�G�f��w,�Vt��4��۬�yݫ�)׶/Ob��F�q��ӑW������i-����~,���%I=`��%w	��\Vb	{�Ze󳒚�%�]_Kf������v�F��[�1VW��9|�{��]iA��о�����r��wW=�2�6���Vs��}ɡ
�غ���y��wp��)��nض�6��_�E
Ѫԭ5[�E�g(F,	��no�$����<�ٓ�ݦ���3j{W��wP�%j�y�K<�ٔ����K�{�?�`����u�gd|m-����kJ��'7������9�����!g�=r:jGݺ�"���m�a�f�����:��q�fP������� H�j��w���m��轕ܸ��Ι���_�F�[w�������m���2V�&��`IX���#V傻��|�C��Z�0t.����Рan#L8�Ѷ��\̎>��s�ث�x�ef<�xB]���pt�u����6�[�����߯�k�@_/y�	�f�5~��r{=��.G���������g�o�}�L� MS`��}��[�}��@.b},�@���z!AB%����_������~������/��s��?������������p����S�`�c�4zա��c���k����w�p�ﰶX�[>ᔢ���G;����jhx����u��	�l_�� -l9�[#���0��~H4�b���5'�Β�r@�Y��>)d4z���Q|���N"�<�
[���n��_Ǳ�CX:��uv�0����Mn^g����]�2iX'lr䩘֊�K^�_ �������b;�����;Ʉ���;�0�y�9��?ۊ�sw�#mc�f����mF��@sgN?cp�Ώm���}f��(r��8� w^�h!`` 5�Ԗ<���I�`��r���6���x���Z�x�����G 	|�Y�Ѐ�[����k�Rx�)��dwL��vѶm���_ @X��m8,���I&X�Z7�u$�C?���y�G�0v V�yx�Jl�亅��[�0�&8|f��0��)�w̼b�G?R+A�Пb[�y.yqE��Ty^���C=`���<샆�(K��	f��},� �s���6t���ѽ��'k?��/ZK��-��F����ѡ���,��΍Z�[̶i���~>��$���*�#Ǐ���2��ka_�Z�|\�p�(p-G`���4���?����|�#����G���#��Z�~Z=m�~�-P���w��#����(@������L��	k��G���ތ��Ok����~z@m�ߴ�C$�����3��.9<w .^����K�?����;�(cޖ<�?�k�|Ɋ�2���%��m5�)r�p%�Avc�Į~ �Y�ּ��a��"Tm"��� L����7N��	�/rS]yN`�:�t�Xe�5���d[t��7y��$��Ԯ}�MS��K��S��� R/v�]�`\�����:��d`�����6aZ��ݿ�aj���Om �\r��j�:����Ws�o��1~�|���{����ډ�5��|�ә�?�W�_��F/��t���`0o�
` "	~�4�j	X��t��4@���SK��l�%��Z��F�����.��EΥ�\�ȡjl@��_,d˧����"d�2H��쳫q��U#�f�4sWޱ�D���'�k?��<���^9x	��[�ދ��mu�l�m*�
y7e@K��t�¦�x�_��@ �=~h2���D�n��h�7���.Xm�g}�tc�Ea���\�]Kq�x��܏}���S��d �>��_`����>�韃;��C:l 6��� �4�_�ܦ��,��`�y�c��¿��*����1Г�=�$�����ܙ�P���~@2�7��?������������v���B�OG���5P�]��_�,����q��7P�C�j� ���cj�܃��4np��� �o����vX�1͒?jh��<�ʜn�����ޣ[����=��xn�x�;�@��Zw���ݛ>e���6Q�p��_����½Xǚ^r�|7/9��(�s�{W�v�G^:�<?� ��n��	e�>�)Wl�nKν�	l������cğ��kݍ����7�g]��������U7���3� �@�)ܽ]�1����-�8ڐ��[S��΄{g��/�p�qx�^j9<�iQ�� �>G�Mٻ�Z� �-8 6b�9�<� ��䠷���%�*�=�M'i8a!��>��x��,I�Q��[0nFP���Õ�1�AN�0|��Pko��b�n�S�I��`r��XS��hD޽W�.�͡Վ�"����-t|�}�l`����p�����6�ʥ���	@m0�j�q�Cm��=9�*��~?|�nj����5���@j��P�|��
�Xʖ'Urw��N��;����<��^�q��Z򊾁�o��V;�r.�����i���s��֨�-���,9L�4��ґ�5��s���[�ۼp�۞�C?T��$��XՔ��W����_��0� �~?�,���)�w���ڮ{����֡Q�ҟ �	Բ,�)n�/�����/\tؽ��a����D��%P��G,�_�:;�>!wK��~麉v`��Z��}� I��B�R�)����~F8I��5�#�^�yX�����]@���k�6�<�e�L���\��^�;�E� �NEf��|��^m���\�]�'�����C�n`[����/�Q��5 !?���~gΘ�ǅ�kM�9���l ��:.�zNc��q�������P��$&J:.]S�P�4�倅?B���i���D(~�� '�r�������훽��i�4O�3�.�d����� �$�@��������PV�B9�&/�vXYt���fii���z1x������"[����3��c>�n��X�عa	ǻHa��|N�ovp�ql90�,~��?RX�<�8f9�O �C\��u(�v�OǹH��a���0�k�ZV�n?|Z�1k�7�1���>��<Y
{Sa���_
��·j8ͻ�!h��TĪտ�0�D�a[a��[�<�i_��@ӯ��%������?ڷ<@    ��tɇ�ّ�I�"��mKn�>�[��}����@��>T�"(w�^��-.�E�������ieH1�q�^��Q����Yw��:;��]�Y;7ź��4R�p|�U������pKh���ʀ��
S�3MZ�)z�3�~��+�7�M-��9��4(8��N7Lcy�s�~?�R���g���}c��<�-��9�Y�0+�.� 4A�ǳQ���Mp���>��-��@YKJ�I_��X��B$�6�G��\1�`��<�6P!L��~�	��O��=r،� ���^�&��<�)���[_��4 ���~���9��4ύ[Si�����5��<��Bq��p����b���/�^�Iu��~�߸������a�`r�������O-�fɽ-��E���������I�"��V]r�� +���%M��I{����^�j�Ro��.v�+��f�8Ќ�������Tj�N�������ÿ��;�Uw�",��ս��}2��.�1m�"��@C��ץ� NG�c� 7��m��a:��	��@�k��LG�|# ��5~�kS�d�P�g�����(:��>���T`�f%B�NX���6]� ��E �S�}��E�x���A��y����VX��S��ۇ6����>?j���eɧ��Fi�o�{ �a�C��i�������ߏ��B����6`.�3���%vꂸ���7x��ݴ
��K�1�<�h�v[JÇ�l��̄�,ys�:�&��RA'��p��'T�4��9�]��x�kXdS>����e����b|�m��8lt�(�4r?t��e-��9z�d��DH�t�����]�u,��w���4�y:���>�Y�9����^���P �.r�'��.��$�r�Z�&��T�Q�"�M������B�tYY�x��[?aa��C���]��نu��|���w%9uT"�V��CN�.�X����to5�m?�͌5����4��K^�"h���%,Xs-ͺ�������'<	J����ld�D?@����e�2(� d?,��$���9`W��=t�Z��a~V�	�On�e�t�i0fe�b許ܧ�{�A�Xr �NƢ�������m�o��]_~B�1��r��Y�܅i�6�1���܂����7!� .�>1 �F�l�� 7��.TֱU������b�.�^�̎��@K��.�w�N'-��"��?�?��o���?�������������ߚ>`����U]�llՠ�m��*��z�8]�๳��Ђ���Y�H�S�Tv��â�	j��p�v-)��{�W�9P�I��,�z�J��t��Z����@A�%zc�`��r�-1��YA�r���?���r�f�r���.䁅��q\n��=\�:���2)si����^�c�&�� ��ʙ�͎s�7<P(Wd8�ڐ���M�q���u�+�Jx4(fV��F��c�fA���2^CZnP[Ő�������nc�_��ĝ<���_0�օi�ql�|!1�����%D5��&��2A腄��^6N�v�r��7�T���1H�]�r̎6�.�P.3Q͆�'�N¯A��-�:BD��P�afO�$�~��T��w�[e�X��&a-�zM
8�f�ڒ�2A�����4�����P�^�2��·h͚_���f���xr��oZӀ�/% �3C��od<{��nG����I�\�^����dͰ�%O�ˌ2�b��_��&1�T�����O�������c[��X~�P�`k�W`�nox�m��'Ė��JuWS*)��,�'5�y�6~�4J�7@��02>`��ڞ��<�W��̒	7�l�4 Dn�k�f{`��ڽ�a�L��v��c�S���r�c�k��`rG]ږ[`M��o\�e˚.ؔ+ଌ��'Y�$r�>Kث��cq:�.��mb��鿅`|�O��A���A�"x_�`~�/��E����x�� <H��+ꔩYL�d�����:� 4>:IƂ�|��p!W��a!��Q�#�j2��uL�X�ζ�y��uAB��v���ć;~��x�򷠁/4�F����BS_h��}��/4��F�R$�R,>S4>R<�RD�RL�RT�R\�Rd�Rl�Rt�R|�R��R�>S�>�3р��߃�����w?��������oBss#�8�(��6��]1����D�NmXy���<SeEs�$�K��V� r�i�����k >Ƌ��"4�/y��c�hSq�-��ڭ�%((����#7�eM}�� 8��w��u6���z_��6���,�Y�����GJ՛�������Yƀ��y�df�,���{�׽�@�����;&���ͧ�����Ұ8СkM}� ���5@�'r�,a)�����jԖ�<���w`$����vX�������P�ȍM������>e~�kP�-����>��F��=�%���y�9jjG?7/	�%�9���<��������a��epe���1��G�ۛ@��Be�4�M|5K�w[��X�����݄J_�L�߃M�σ��� ��-oc�^^�;92�bm'������4�tv���A�I(r����K� l/r�W�g��>9A�^���}?�TQ�����w����$Ǳ���X��
~ [�=�9�sv�8/Р&5=��w9Ј��X�O@�<��Q�7��_k�ceN��BSw�����_��>�� �u�*��K?��x��MŶy�7�a�_ ƃ�'�B;b�[�����̽ձ�<?�o�K`�p��� >�z���*���y�@��O�q�z�8 �QwC�N�D�� n�/;��2�*��X����l��}5�:�T��7��^���'�xr$�mms#9�]@��~���X{-{?��qt���0~���6���R��c��I����$x�aD>4�$�x����$���r�Ӓ��������s�Mmyl��C����<Vm��ʘ.��3��!�Z�V�>��t���m�A ����E�9�o{�&u��v||wpg�t�\6?�2п�M�ŀ*9�k����jZ�f�\4�#���%]���-���%oi��y�C�I�r���$�,Ɍ�n6�'}���0��0�w������r�6�[b���d�%��A�;�2����.߇���q�A�`ѳ<?�7�����'5ͯp,���y?s+_���'��%�	`�&�%h7�3�q�=�J��/���n?�ͬANp�g�+��~6��|�c��97e=)���wH���� �k?R�,{�<�#�:��7ܙOP��7i]��
]��u�&��i+mt>A���'���Y
�v�>�y�|�g+��G;h�*�<���q�}��_�[y�{���2vPh ժ g��%�0�y�z�|Xy��M �j�n%틠�b�*�����qTޖ%��V��~[f�s��L:��.��L�=,yr���<�l��X�6�?��9����h�Y_�� z �¿�zn��ݳ[���\������c�a��}�15#���e8R.�_`�l��"�;�}O��{6��BX�,m�¥���	M¦+��o�s9n��*r�L���a���>���8�.���*Kǈ�M]Cg�7&<�K�G�7�}��R�2�nIb���+h�`6��N7�n��`<�¿Uo���fe�wLC�E��5{xL�����D��0�yɣ��Α�}@�x�n�S�g�w�G������ej���}&We���MnO��_�k~ي|����p��
 p��E�������ft�s+F�<�򲂞]�h�e7�=��>�1����)��p;�s��������G8��(�J��p4�vRCn��,t�KN���yn53>��g�`J�j�Mj�G����%:�I�
ijgë4Vd���o�h|�"�������o���� ��Y3@u���I'�k������>g��"w�z ����*��s"Ə��k�    ���y�:���p�k���6y�c����`�_�����͞_�Lx���?s0��� �^�o���i�1����$uL��
���������Lp���X��w�8���g� ��"7��?)����"r�n�P���>���%W���m?�C�,�@6A����m�"�D�oy���^����~쳹@�J�� �15~�'���9D�Mł��+���9[nE�c dc'%t��Ji+?b	����0w��2��.M�q?����\m��W����em��:wR���D��>�X�R��5��|��_�L�.}�����6�����g: ��vÜF[n�����R�,x����?�����زKa'u`}����_������<.
Rz�ch�ܿ���W鶯�o_��J�}���*}�U:���W龯���?J~�.�*}�U:���W�Ưҏ_�#�JO~���*}�U:���W���ҟ�C�J�~�.�*}�Ҫ^/���c��~@m�q��eE|�������U�#�e�3L%�����6�:� U����g�X�b�z����a�7\|Y��5��}d�D7�f8'Ȝm���>1{aA���S��6��*ڿ��G�ǚM
Nf����S��2�䌯�U�N�!:4��؝���NR%L7Lh{�w��Z�ٟ���%�
/Y�p�C��'�'@����0�#������>v�/�x����d��y�/�ߺg��� ��R��q�Y�-���xR����X~ �_����q��<f�~�*�k���=ɏ
�������������h���Y���w�����z����2�t�� hP��O V�dj��/P���Y���HK�S3���6�ɚ"}�}���&�kFe*A�K�`�uS�����©���s�|�G@kA'w(�����l�G �,	�kH��
A�}�7n��%�;�*� �M5�����_����\_��w?�������`�ӵ�X�r~a0��n�??{�&���I�j�_5��b�F��>�������'<���3ƈK|�<�j�����-�-/��z^�����-�������}�����k���K�Y��b����<��r�rUg3`�Kn�`�J��,~p�x�/Ml��Ϗ����̃�b��K|�Ϲ������=Y��|���4��?v����A5�I���Co�����<�?��O��������_��������������m��ǯ����������������������������ďƯ�D�+�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_�_���__ ��>���`��#7��/���'f��t�d�Z���2u��ZrӸ+7�'3�B��`{ˈ%�N׾U�fL��P�\�+�V8@�%g�k*��1A��(�.;�P:=�ז��f�0���/9 C$�J�=;���0�tw[o8������B5�s,�kOvg@�����˖ ���4y�m��%�{xo�΀�`l��2?p�^iWHp,�ǂ����J@h��O�z:�W:�W:�W:�W:�W:�W:�W:�W:�W:�W:�W:�W:�W �W �W �W �W �W �W �W �W �W��W��W��W��W��W��W��W��W��W��W��W���
_
��=)E��������?���M)�0�ӏ���_~[��ɺ��7,`&nq���u���q\������-eН��B�����i.G�i7��PO��`����0J�X�7�� �>Y�}�V�5r�b�am������0��W҆���c�ub���/^p�*�y��t��dڏǪޓ���Z�jW�m=�/U�6�T�5�ɍ��}?��-�M�%�@5�$�9X�e�*?`�X^���d�ż��i>	c��:71�`7i�-Z��޴h�Uex��@diA/�W���>Q���n�b���S����"@��R�}�d��fw�nWo-�doqG>C��Mk7�/̖�Q��w
��q��T,)��;	}ƛ�'c��\Y�~�g��M'�\(���K�?q�G� �ڸ䌹�}�Wn=1lg-���H��� @�]|���W�)~6�kZ�Y_�hPR����-��du���馥k}�����vX�H�U�Aá�K�=D�K���ד�}���_e��|�M�,��Q����w3H�2�)�X�2���<���i�����z�ibB��#�cq�w�HSoܮ��X'o`�ʳ>o�(�I�^�(�s�G�=a����h��;Y�7+s�ϛ	ҷ/�	�|x�*r�����e?-�,2��k_AY���]+�'�}��j��Q��|���Uj�W���?�c���o�=�`�"q����S�ɺeș�x�ܱZ�c���6Z-�F�A�|ǟ����n��3H
���/ d8�n펓��~F���M�0��=�
�Q��� �ߊSW�f�(�en#�G�;��Jd}�/)p(���[��d����A���� ���?yl�������e	�Ro�����$�J�@�P�p�0�%���v(�oTڷ����k��ة穧s�oR�/%�P�E𵈾��"�2_F��}�/#�U;���W힯�?_���R��R��R��R��R��R��Gj�Wj�Wj�Wj�Wj�Wj�Wj�Wj�Wj���j_��}���u;���r_��}�n�u;H�e@� ;307�- ��_9o�B�}�އ}�������d�	y~�O�ׅ:��n��;�	���tr!�,M�b-����X.�}FWx��z�G=��raP��Ao�a}��k�hG$\r�Ӻ\H��W����	 ����,07N�Y�s=��c���u��c+�h��2b���Ij�1���ofz�+@I����tq�#gI��Ư�?��ov�]��*,0H,t���-��	i4�͟�&���O��Am[��@RNHZ�09��ݿ��`��}>0��]����V.,a�@ْ�����Y�?������Q/Hs5L�Ͳ��0AV��������?֡�2���zx��Lm��pW�S�0��f`�d���𒵉�`\e���'\��<r�Ê��H@��s�[�"�����_���dv`痼53�����q�w�]z�4�Bo�~x8��V*{�w�Y����'{��u-lue?���]�ig�@�*fH���s�E�pm�g�wLg��ث�܉w��+30�L�<z�v��>�bK���om���q�'s����BcY��G�ѳ9��E>�4��������Q���N���yh��o�d��~��E��W��d=�5�){���\A�1?۾�v�����6iF���3@�5ػ~aY�B���U��g2��Uu����]D�y9���g-;��r�6���㟛��H��r���rs��s�g�@G����my�䫃[ps˓~6�T0O4��앑��yˁsl�-,e�H?��h���CS�B.�m��ݞ��3�K�1�'C~�?u��j_�63����j�F.|r����y�#V#������w_�<�7"�	�����b^rV�Of�O�����\���(N���<���䝇�}��0� �~s�G��ō��`@��~Wx�λ�7Ʌv�X͵ߣ�8Y�'�Ɯ�_w��6P�����c�D�84�So��B����� bhy���\��T�OF,o�ߐ���j_�>Ŭ�<�Z�`������������<��%������*��}>���6~��[*���:[y�չ����I�ǜ�l9�vL;E��\���>�#����3��F��9�kG6��3?���8��2��r��O�=��ɻ��.��;|����~u������������G��e�w��� lj�#���s=-7(���r��k|c�#Z����&Xs����~��[�b�+Z1q
��ڤ p��כ_������O�s�#/��`4��PD8��+���|�zo����)N���"h˖���r�ؚ�V�����IߵO�0>d���U���I��~�?:x��� .~WO1����������F���W^C����    -F���#/�Cw�?�Y�F���P������rhK�6y%�2�&b��E��K�}��v=�(���x�
�"�C�y�J��1.ܷ�\���c^���*���2������e�lk���=��ZrnbZ H`;���3�~�a7���V�j;�p5?_rg�x�^����l���3]�~{�k��]����a�Z�][�7��a�#'��~���C*,�p���0 �ǟa} P�������P���,�y��
M�����5G��E�?�]�6d�,{�p0�Wwl���9�g��&�0�w���$?��$'C�c�gR�c��=��l�X�o�����ޥ��[���Hؖ�f��Ů�������1��Qi�#���9�ˮ�K��`��t� �!��������f���<�s�#]K���~)�%4��<�`+��w��o�A}�W��^��]���a鐽�`ꢃ���5ë��s-� �!�;@?������.��h?���q��sfZR����K-a?���l��?=��)f�s^+��W�[n�_�����;�) �(�z*���d��yv��*���]��6Y��e_R����w}%эօ��$����X��/�n���jW:�X��V��
�E�~fS��/di3��~�MsOp؎��m��Dn�~��]l� �w�W�{.\��C����0��W�ۓ;E?�X� (�7�֖E�x���G����7ԩ&�gc9�y���OI���3S��V��Ҁ����%�Ce�w27F��"�)��Р��z�2���q�c�ty�����\(=ӆtw���D\s�c���,;����U���+2�1������0ԝ,�߀��k��$m_8mx}cct��0f˃	�,lx��i��]�k@3*���o���X�V�*��i�q;�>&�_�B,$�k}��a+��N������^�x�7 ���w�����]׿q��Ý� X;��tsjf�b.�o��E^xE�(K*��!�SC}h��]��"/�W&O�d'F��E>C��G���� ���2����#Bi>���{..���ر䰳�������b5�3������H��tl�?$�&��]d��ɧ������r��Þ�?t��?`y�Z��#|�'��
�O*����_����Y���M���U~��b5<�z�':3[k�X�R_�Z7��b+��*�!r�L}#�j��z~��f�-��pؘ���_��c��b����^�_yp�߷L&�W�=K[�t��`x0�����<F?70��_y�'��������0"���w����{y��0��B���q�"O�<s#S+�[���aQ��z[�K�;�@��;�L<�y��^t��bH�y����O�뭼��t��7-����n�]�}a2�-��_.��SǕّ�p�_�o��1-���J��a-k[�.��/|���9=r���L���xt��L]�J�(Ly�,M%�t�d*��n���j��gU3��<<�!AB�<vɳ÷�gqӳ?� ���w��e�����:LWS;��KR��F������1 �x~��]xϳq���K�,��џbt#��I�֬pϤt�|�AM���#OF��bu.3"H�cZ�:�bt�?K�F	��i����u~�x��I��s������1�oHr>�xgᑳ8 &��i�<���c�����y��$ݺK�����}�#��^�����������S��Ww���{x�Sl�����:�>����@<��S�>'z��!�Xn"獝`_u�b����kfo����'�I6�u�o�b���v��Qy`"�/��4�j�>3���'r�������b`l�r�O�h�1�r���%�?�mV������G��(?Bs��K��l��/Yk �z���aI1{{�Әn }���b��ƿX�����a�z��v�q���S�������'�H&� rP�rz�@��uw�M�)&/����}�Gd������&f ���/�Ra8�j?oϱQ��x�!���z�ټ��j������Oi�H@��g������Rw���祘RY_��v�3��eW��x�M�c�+๙�s��Ш����O<���5������ǃ�5.�s��I��F���a��s�|p|G��܊9�GYgL� h��&�n{��)�Π0ּX�7@�}� b����}���Hy�}�u8���m�'^Μz���7Ñ�y�$H����
�3O4K�i�g��F�㗂}����x���ܙ=U۵����_s8�˳��65��W����
�#���~Ư���pME8��>�O��?=Ӭ���3�h����1�����0�@�������/L�	"��o����E��M� �u����m/p/r�X��@x{��ze�����r;�>K��,�6�ɞ�f9 ��qB� 0��_Ls�D<��'ˡL������d��y�R�܀p��v���cK/|�
����?E��[�������������7�Y/�i�_�G�~��~&�����X�)����<W�ŇW��ԭ����� �m��1�KƟ��N?������2��0����cU�{�O�E��Ʒ�0-\�����_��Aҭ�����^�{�y"��M��#Vu�_�t��bz������d��G%r�$���b������*m�
t��x�g<���yV~<s�l�i?����U��Y���PV�X�lM佳V�g~��g@w����g[?z#87U�O%��b;��,��A��7L��s���Q� �X�|�g����*W�|�c>̏��	�4F�$�w������2�;�O���7�NX����Ռ>�����-����s���92�~�+�?%���F�ŋ_@��S=�à�}t�>b@��4<���߷��}>����w������f���$W^i]�9?�`f#����~�~�?�&B��?M����AW�<?a�]S�| �ԧ�W�f{J���Ogr"������3}�c����p��ם��f�Zi�z"J<��>_h�� ��}Ϭ<��I׭ZƇ�n`����O2�<���!���WPGU��?"r���_e�/�c������sW���ӵ�s�ùA�IHj['���7Nw`�x�����b����Q0Qn���A���C�+����O��t���{����:Q��gA������u~���$�(p��y�۵$9�*��Ϳ�˙�]Dgt����|q�*�$	Vv�q�wb����ŇX_`�<e��`�r����([;�	��hJ�w���칛/��1��o��J�C��8����J��ItA����DV��A�=�7 N� �mp"/�V�N��e@]�6\���վ�����^�9��$���n��h���w|hz���##�ü���`�b_=~�'>���k4H��3���dY��J�������-��ɵ��'��h�uV+>r� s�����G���;��F7�����_��#����'�����\�O��,�����1B��o2�1���i#��ćiߛ�¯ ��-��V���W`�>Ο���>������\&����M���M{�lE������ͽ#6����ÿ��T��39H����Ŀ�*˔�q�>�?�X,� ��?�����:-S�� |'D>�ր#4�_��l����~���%����v�Wq�r/�"�U��c=�R�B�7>��T/����#ף�,+6�1w��s8?�+e@�������ݿb1}������F�Ο�6���7`x�܀���O/�9����a�e:ͻw)I�p酧��2X����<�s�O���}��������%O����R�� �a��1� ���^����Gb��u"7��w��q��eefj�8�,��J4���o�<��xٟ3�����Q��C��z�Rd��@w��0i���s��y��W~�7�O������~ƹ=���/��v��:�a�̆څ���t~?jjЭ���B����,m�~�%�7�^�C��A    #�Z� w�u<�a:|��
Q�u|:�q���ui��]x�M�6I׮j7r|G�?�ڒ[ś���oX�zךmc�o��T�Ʃe��9���c������ �sOz�?:�LVu���g��D��u��8��U�>����̟�=����~>t[Ƭ��x1c@^�W@X  E�;�r�����9%.9��/�=��t�D�������P�}��u�1�'��%�
os(<>BCz������ų�{� KwF��72��:�K�5hiL�ș�f���#�V�g�X{7���~b��T}j-���Nr�kY�MK�����\���Xn2���w��Wx��tb���
��>>ǲX�;��������_Vf�Ӡݭp���],-k��K�ӳ��Z�~����o�vI���XP3aU?���D ����V��Yrf8��X�?���G�y��:�g�~�� ˗�o�'�O�y���g����eڒ��%f ���f�X��9���$�lm�QPKx�9n�k�/�S��9к��K�'�Jz����b�Ƶ��{��\y��D�r^���"Xkb��s5O�n�
�;r������"�ʕ�X"��l͑��채7�B�o��]7��V�I;���q;���<��=?OH��g���Nx��o���cY4Ƹ���SswM��Q�ݾ�n���k��`g�ܹ�x7ܔ�(@͡�n���y���t��o0�jH��i5�v��~�rX�&r���x�3��d���4o��~?�c»�{��ј��������w��v�M�Y�����������s�s�>��}�+����J�u�g�VV���磦3�}X{�S��S�n���q��r\9�wg���߬ݬS��e�z�=��(��:?ox,�(�DSK>@��ݼ�͘����1|�ϣt�u��&4Cp��Li�sɹ;
.=E�10~�a�1W> 
\�y�d��W�w}R�����
O�ǵ�Z�����w}{V�g|��K����"[j�7��I���55��+���<��M�[?yS�S>�>�o6�~�;e����~05d0�j�?�sg$<����*�c�]�_�;"R��g!-V6�ϳrK�ڗ�����nxVˉ[\۾���ҥ�T��m���������ų�ɕ.��Mq����I�T�Jp������5�<Y���W�M�����S�t������`pYz~�O��Y�K�����^_0�L��"o	 ��J���]V,)��>F��~�d�E_V'����#*gٮ�������7��ү<�A���a5^��=�&����S����2�ѯ�{�N�g"j���-�Q�ó����~�����e}𦘜��UŊDb?r �my��yiV��|��3>m��wx�y��y���ފ���.��������� ;ޯ:�t���������\��`�XJO��4���{�`	B��1�����ś^�����Xm��w,	Z�=����Ɨ}v����ӊ��A��� v��?�P}��D^/5�?ؾ���>��2ڻ��Z@{���ێ<5`=�B��Q�K�ߵ�x/r��p���ƫ<_ro\��} k�������r������I��,���/��Jj|���>�~+,��+�#����l,K�JxB&(��ynl:�A��coy���>]�f>��yxÀ�վ��������%�J�<�y�����G��=0x��=�1.�m~���\X�![������� �	�^u��_�)ݰ"�@�@li�=Ǘ����a��˻�l�����q{���r�ǝ����ʪ�*�����^�z�ה��ڟ@VfN�~��Lθ���X���~˚S��g�o��R�`��[�Ͷ��]a���L�c��y?��}�k��mϔ�_<}6I��4���/�5�e��A���ՠ�S�ߑy�=~������)xȵ=���Yֿв~x�g�0��))��W�x���!y����U��,��S�k�c��a:���������L�~^}��Gnږ���u����o.^�)r`� `W�@}X������&3���U�����y}�w^�P�2W��� y�f.9���]����,8�~P$u�����o���W��C2#T���,}��H�x0��1�}�fg)�����w���%���?��λ}�)������y�}.�Y�7xx-�3��Ѹ{�X`�B�qg�ߏ̕�Q�?���6��<F~J!Y������ WcEN{�]��WV�]����{���3X�LǗ�S�� �ϛ�y�]��]`�ص�û�/yͼ�-,�M�~�H�����u�[ue����� s���,|��������>�u�+�&��[+l�[r6Kd]�3�0�m��7qv�}�X;�!���P����W��`�y��^r�������<��Q��;<�	s��Eؠ�����S����5?��RY�o��<��D>�a���ppo)�Wzx�Eh0�Kβ׾ey���x�?�.��M����~��DPLV�����
���>��E��>������l4Sn���f�ϳ�"u���ׯ���|H~�G�0�M71����6�a�} G�^?���)ir�����ߏ�{�������y����[fW��<<�`
�~���8&����0O�r|��L��>O��)��0z����q�Ƃ�{��I��}�?o�!����x�ٷ��zP�%������Wy�|���_�yێ�M���?1\KRK���E�-9�c�ϗ��`e�W�*�3&�(�*%�j�հ���+������{�rw~C�i�v�A��]��@��\I3U_�S3��=���\.2~��#���O*�%ad~1��i����lP��2�q�ً�>�����L�(l|	�� ($�����<oY>�j�%��Iܑ������+/�5�|�`ܧ��џ\{��|��r���|d�Mt������_��+�=>�$���B۰6������/��1%S��XB�9o&��;��L�=���u��;�� h�~nX0����6������s����"/���?O 0��g������ �,�s�g�$�q�����O�&�P�H?Iϭ�x�O����� P(Ǖ�x���,'�d��`��e�W+����yf3�(�y>�E����ln+��3�W�(r�Ch}�o��칼��x��zƗ��.��{���<rϷ��^�2�y��s���R�E{n��s�ಌ/��a�荏j���y?^?�ub��i�NZL:��Wg/��c�8��c���K�jfL����_�Be��̚߶���
9KAp��8dy��+X���gϫ(uQ��-a}�ӿ ���E�s�OB��o�D'���:��� 7����.�*��?ާ2X����Kx��λ�'������$�.~��_9k�:&�.~ ��i)����W�_를�)�?��=
���3N?W�^� !r��3B���h��	������?���O�{�wخX\�?+�^���~� ��Ȭ����d'rRuO���KgB�^�瑙���gOU���a��<�%�8zo����F�.|��&ͻ>��m���g�^j��O&D���r�ݮ��Y��h�A��F��/ZZ���^�	���y��>w�y��x�����$�B)o�T���9��%�a�U �y�� L��W�:�v���4�H�eF�N�A��~���U�K"FN�c�Z��� �q?��Aɣ�u��z�Ψ��@��R����Z՜��[j��w~2���sL}�� v�w�;�X!X��;,j��j�5��?=�n�GPx��_�w�̻~�n?D�ȗ�ڟ �H�w�_�u����a@���7�K����2��<����u��V���SǿL^�kECix���w7��_�40��y���Hy��@7f,���~(���4�]��Q]����,��;�#�����8�pz���W��W���
����m�"�mH=�q��(r���9C��j0��*�țЏ�x��"��N����i���|m �=    �h_+�U���(�l~�~nVU��������|�1��p�Q3{���\?|���{��Ol�K����xB����|�y�������+�}�7�Jz[��?6��j�� +>��}^\_�y�|��>���9�<ߙ����w����Apb���i=���|�P�x�[�P��� ���f�����#OF3��O-���{�y~�ۗXl��$K�����p��~������.��-�O���g��E^�0�<f�=��]��u�`�^�1��L9�)�ޫ*�� �S�:jD��|(���
ʇW��l�>��{�#@������z�w��>ҫ�j
Ֆ���8��6)�Kf���
�Wy[�J�n��Â-V�	`Xs���L����=��At��|���EO|Bc}�����U4✯��W�_���s����r�9E�� �@�^�i�z?�Oez�J#�hf&�o�DR�x�	�}��X����5 ��yO|��P��v�w\�������������k��ʌ,�����vٔ��5��w�8[���a2������c��=qG���oZG��|�{������S)_mys�:����9��r�\����IƂHb_L��|�!����-o[`@��_
�%a��_�1�z��Z�j���������/�������l��㓁`��	���[��]u+�w`�G;�!7��H�rhgx����(V�LF��H��?P)�|��'���!�哷iTY���ė�6���:��y�䍟$uV�q�w'~�eLf 	�X	�g�'�o��sk�7���
���o&����:��x����	{b����gR>�����|}0�H��ĳ:ˎOɌ��"���G��4�Ò���*֏Wg�yg�����Y��}����������`��yώ�?�K;��9����/v Mߡ�r=����O�4:��]��$��E6�`EN|�%7O|��}y���֟f��.�g��3����b����=ө]�w�X�1�����/��d���k�\7G��A��z������/`�������0�~��?a��^F���/ 8 ���������j��>�X �N�Dʌ�pr=�u�2����)��D�4Xg���� �_�+X��_֧�i�
�����nmr������/��a޵o ���<��w.��_�SY弿5��b_�_������OL�x]�S�����w��^�M����Y��s����Z:�쟃��$�atQa��?�����+�ڲ|�9�������9��>N�
2T�۰�Ũ��0�������I��g�D�:_��3�~�7x�����i�΀�е���1�{|-�|J���~\�m;fH� ��?�yT	o�*��M�ķ8�a@ �[�+-c;���Iҧ|ĀCŏ~��kUN�'Vs�EΟ �|wb?������� �&�[6E&ԟ�.��A�c�@nZ<��:���|��y��9_ ��~���xc꬏\bh7��wL�9���B]}0�����*����C��g;x��9�{XkmI�����1��ߍ9Y����58��7~x%4I���>cڻ����'r৘���U�I���d��v����p��WA8���񂞩���jb���ll��_��{Ғ��c�t¼�ʃ�,�����=�M�,����O����?��4`�_�f#/���ł]�Ƃ��d�������}@���o���cI�ު�?�c�xuΧ)�-F�������L��EӘR�����9×��`*޹� ����2|+B�w�4e��_���y�2]���:�ks{��g�wt����<�W�)X��[u��0�?��~o�)�����+�S��g@���n_a��b�+}�������]b�Kέe��v��Z�)��u<�x�Ƈ��0�"��e��z���_�R�\�7>���vѢiy���f�� ��0�,�x����YI�~2�J��Ra0�������?QO�$=��\�>O�Z4&D��-� 7�N���_�<�$���~W��*"��q���� ��H�<\I��� xK{)r�X�!��<)�~��Ix'�pp�?��rv���X�%g-tS��@����	��>E�=D9���5���}^���cyD�كo�{
1�Қ[�DEۿx؋�y<�A��Of�{��h��?��]����Iz2�+�9�-�����`-��Sٷ�`�#ǭG���(��%��-d�y�[3���#�_KG��Q|�7��~���U�̌$3"�������큌|7����q�"<�/#9
��G�21��Hvl��7>���,�ʃ��z�f�OL(��+?2ȧ@Ju�'"���ØZ����&_y��3�}���}���X����؎�~�S�Zٻp�c6�ʙ_Ju�|m��>Hϓ�W~'q3����#���mx�c7�T��W����a�����G�������M%�ko���OQ)����w�2����Xɫ͕�B,����7�}X���ʋ`" <'?�>�g~vw�ͯ��';�p�����h�ו�l�/��� �����^����<3��e� r�[����>�]vp7���ڑ̊�Yv�A���F <�D�y�g���"Y�pKn�~���Ϟ�H�=*x(���k��""?��u,/�ؑN,~�G*�#�V��.�������'8� ������߱'���I�[�+�ЫǼׇW�
_ӎ��=�R<�+���N~tT�[��[�3J��4ӎ<Ͻ������~�X����5�h��_���S^�g�p
&��/��Z��_
�a��iO�<?�O�3�D��3�t����4��=����?[��O{{^��~��`���g��O~0	ȕ��w&t��s~��n���+ǆ���H�egp{��n�w���v�/��<5>o}��/;ې6�.\y!�xx�������y��ռ������M������v�6�ko�� ~�_�C��Nw�
�������>F_Ϸ����|�)�����������a�\;�S��/���n��k�� ��k}�S&��{ۏ����U��r���1��R���o�n���H��")|�߰���/0$���mp��ߖ��?���m0a��6��Ė�{}#�A�S��\�����4���U�Y�T��9�͞c��!�a���ߠ�q��O} �!�os�{*��<�o��1��؀H!3�	|U��m��b�0?i��_|��H�D�|?���O�u�p̚੏�18	�O:��T5�G�ߠ{�D��D��c�W���_����j�o�-4�>��:go�ԗ0�#=���ךH��ԷPX=#�<����C���W��8���U�x:���ƌ�l0��|9rW2^�|�$.ɧK��|{��%�xI~^�����%}���?�������/��_�����������������	���w [�JcW��B���֭~�܌�:�0v9��@7�~HՁ�.�yO.QM;KX���ûz�DsS�"V�r��퀪���#}�5�"�SOS�\��f���W^/���H�j_���������������>rB\Q0j-؊�Na�12u���c׍?ZM�z�~�T\:��~594i
����t���)���8��:�ޑ�w�~2�;�$wƏ�!lz2�/��t2�zdd����~���y��P,[pLA!�|/�Pc]�:{�U�����aW��}ұ���׭�=vD���\�{�-{W`y�ӏ�r��!�ˡ ��<�n�h�,&xҩ'�I�-��ų���9~��I��O_)�U�n=9�=���i����d�qJ���X���]��0v}8ޏ�bI�y�4�f����Ѩ��L;Ry��`_O!qU��>�W:���]�
8~>���<>g��	�2�\�vC��=ϟ�\�ĝ���F��;��ŭ	(�9�? 4E-���n�r����l��n)����2xw���5Qn:<��ֳ `]���G��,Z5uہ*O�V��������l�kݜ_�M(��9��� ��/�ҿ�Ҹ�ow��\?����x��}5)Q!f�cj/�m���\��e�_M�	2L���    �}x%�g���y�\����C����T# �g}vJ���~���a�y~�/��P�=�Q1��y��AF��o.�t>���Q"b�w)>  E�����Ͽ���Q���~i�헿������~�]1IM�G��4�<3F����(��"�=�%��3��<`ee�����Ř<����!Ij�U&=U��S�Y��9���=���EK��I#���7����j��=��p���}���4��������E!y���L������=to�'����B��CBY�i)*����VYP� � 4��ǎ_��i��1����|��x^>��� �rbR7d�ig�*����1��둽�Ə�U������R��>#I�����Y妯�u.��!Ozt
����zA�ҖF5b|�x�3~|�W�KU!�׎�k��-�)8][�K��SYb�4L+Ù�&��	.��&%SÑE]ч���(>��aW7&�Q#�o�8=�|81?緍�Z?��N����O���/��?���}�r����l&8'�v����O�cgw8v��vw7��ƍgE*I�݃RM>�ҁ_��Ew�j�3S���$�g����-��1�A�5�KPa�ΑD&�p��E�h�-9G��}�����5�]�����mI��[Ì��P��#�WY����g7aܕ����B���8+�ro�^F��<K���K���Q��	_�����������<{�+�z���׮=�9�����m�r�g:S,mV�?����y��HV7�m��4
`z5�1���c����������"�b,��S�S�hFGxy�1O���|�|�����8&��V�^�_{z�\i��	�y���G�A��nV7K�3�?�31+ �݃yL	��L`,~5��ѕP���P�-�^(�I�ؙ��������s9�z�o�s�Rە}Ybת�'F�u�/Ӯl��' ��.J{���+Ydr6����٣�]�];�젼�w�z��s�8��nч9�H�_��r�o���a~��8V|���4��y=1���{�Aձ�*�c�u��� �;����i�^�@;�6��_�Ӑ�4�"I@��M�:O��D��i��z��g,�^�|4�p����]{�R �4��)t| ���& A�n$�X��af���t��i �:�c��}��<���L)�H�����g�Q���~��?��/��/����F����U�6���(+�x�9e�#<)���@$���Ͷi���0�O�h3�*�jK"@W�V�hVնf��&�A�֛p���Ԫ�ɴ?��h�[�m)�z���6�qp��x�%��<7��ar�gC6DI�}��Lf�;���)�~n���=F�+��FT}����)�Boo�.�t�)�����	$�Q�ץ��j����l<��=O`d�׎yX��7O�2+7���oe
]ͅ�%~�ƽM-ʴ�UY����4Xd�N]c},]�4������?0fĽ��m�1�S�X?�����BVP��5�O��kצ�	6�U�;������X�4��m��(��;\�I�O#�>w|}�9���e�����a��<w�Gd��c��P���.KE���$Lk[��Q���ෳvc]o�<����� �_I��;)3%\H����u�s�Q ���&@~�;�o �gO����1����Q���9�L�-oLϴxN�tm	�oX�׾ʰ�n��J�N;R�[��@*bz����5`����i�Z3�.6@���a�n���n6��!��'�`Ⱥ6$���l��s\ 9iiګ��!+w~���Cb�<Nc��D-��᧝:Չң7%KXL���s}��ẁ�g�mp�Ke�8��3?�VI)�]���Z>��&}@��fJ!9�؃Tj^�7D
{�����R�vzov�Lw��h�}������(Ð�z�A^JE@�@1�4X��@�k��^��0eݴ#�S�ܧ���gհ��4�M��s ��o��ѽ��������o�g�Sm>}Rު�j�yb���t�K�S�܆��Y����)b�ӎp����6�7)m{KZ�v���g���S�n�7@�:��+���;@��s��>, V�6��A�`*?��#�.p�g���b�xV�wR��ن��	� �_������S��<����如�w���p꺿��SM������T5�!�Z�!~�jS���,��?P��Ʈ�|�����f1Դ;�!Pw}$%Y����%��f���W�%���#��r�/Oy<����c'o�����WXB�mB�����'��\;2o����>�{�G�f��1�9~|�O�͢V_��X,�c�	a�k (���6f�,���Ҝ��	������B����@"�}~�D����ޑ�RE��M�$ً��Wr��1�g�$��O{e�]c��z�3�n��À4�y��{y[_M�Ӏ �?{Ĕbݶ[����(�]��p�����.����\����q��Ь;x�1ޕ�x��?hԝ��< ���"�ik�����c�DVn�'>���\ݯ�g-"�=f�΃���������:pEj�����-h2�Q�s�
� �]�b��6�J�s��'�!��tnDi>_�v�S�E�i���cK�l���3��/�����/�7���-=��1�sL@��&v}�#b9����XOD���;��޻>����k�l������x�{~��bb�o
�x��Qu#u���F��1��.��x�;�/y-�����H�^YN?�C�?t;�W�i�F��in��E JǕ�pÑ�\׮�^����2�*��w�b�c=�l�jʍ�R�i�ܨc[j2����pv�����2�o�l��ͳ�&�O|v6G�:�@�{7�����{����	�>~�/�<o�ۜ�p�5}��=���W�[�����A]��W~�oIɽ>S�]Q��ÝU��=\೎�����[a��k�B����9"B���s��;}��r�ʏ_AK*q;9�o=\��J9���~Z�L��go�"���s�� ���W�f�����v�����v��B
�/~��~�\׳ ���?"X�.�L���W����wMjh������^o@�l��������F.U�sYϧ,>}a����U4�4%t��h�E�ζg�[f ǈ���G���͟���8|��f�S:���m�>�$�U�� ��,��JYX,����f��W�S�{=�[<�޾\;�F�5~�8����F6�_a=7r������	�jkKU6��)|'�����߶L7�����h���L&�}V�_7��t��l|�'r]�ZS)���)K~��y�	�o|#�R�������:����M��N�h��$�vT%B���U
��x�=�0�zV�]D3��kWȾr�y���9�ǳ�������X�Mo��5�y�w��!��_��TC�mMɢQo]�?��Y� d���*{r���lY�C��  S+��3���N��Q5E���vU��ew���p�����mP?�� #v�'~�4:^{�d��u=����{?��P ���M���N�~��e�;;��7�}6ݳ�~6�I��ه�TB�mK�3H��>��w�-{~;����Q��/;C�����Ϙ��ݾ�/�PM_��vv�e'�
��y?~[��1�)Z����2#,8�w����m���ݟD~�9eWTjt���B�����v�.�#e#n~��gnr��y�U��-����%ܨ����@<��N]d8�c�A�*�Ym{,/8�*$D��|�t=��2����0������}�(�:�7�?e7n���]k|����.���$�^Xm;�Ɵkύp��e�-����#q���`�����/�Ϻ>L8�H���z����ϯZ{8��#O\S�ed�?�a��)#������Q�y�`#+a�f��L�jKY�����}z�$7����}��@�rh]���ܽ�Mޒ�7�:��9�W��H���:�ǧ��7�y�_m5�?d�\�2<梜��O������\#    {eL����c�vV�P�mڛe�a���xd-��| a�J5���3�_�kH�W�m�����"�g��+*j8����Q����
d3i:�m�}%]õvu5j�?'G�l�s�/;݇}��jA����2ӈk|[|U��/>����衰�&����@����Ԩ�)i�j< �z�T1�-0�ş)&B��W���2׎Џ����y$	���5�c},;�/�T}���]�k|�A�^C����_���8��0���U�������:y������T���R���z�'�9��-�}���G��kvΝe���Ѐ�wV���~�9��-�1t��c�լ���3��#)�M���ǂ���_X�ô#�!?MX�g�5ʪ�����'Z������o��������o�����~�/������W�����ĥ��8�{,o���e˅_Q�^gH��A�Pk|r�Y���'���Z1ܵ?�#fCy�{i9m��p�^f%���I���t����m������Hx�@���Z���1�����0�³��-��C�Z �^Ȼ��2��מ(vӶV$�z[y^-3؋�m-G��<��)�lL�A�{tŷt�:�RѲ�����v�` 0<FY\.R��S��M�1�)r�lpOi�?!e��9��oA�;��>�iqy0������>��8]�gNU�Qc�\߁�-P��a"=��z�����!%<8\�6�?|�Ջ�5,˞��C*Ș�[�X�U<4<\4Ϩ�����y�EF�撔f�Vv���w�ק�=`���5$C�u�4�i����`r�<��
!�\�eG���r�Bl�R��n�E�-�3jUp�L.R��a���	t��5ϔ����ڇ�f_r����!��piطa5�^��b�R9��Maצ�Z�%`�ާ�^hes�\(���3������� ���s�1�Z�t=|	����eO.=��������- �<qr�(=����B�Ȩ\\vj` �+�p�4��ލ�����k[�N���E��t�|_MSStiQi��_.�CD�@��`i��<\�J�.�c{�RLxk߮Vu���Xg���d��:\W���}��������z��(��:s�B0Aw�$��5O{�	9O���2ɫ~e��;F��]�B&#&�;������9v��1�2Ȉ�W5�F�֙\&+6P-�p���	sf��j*��O�z�ms��s{�_;�0:2�e��f��5�l��V/r[�A�`���-]�a֞i�a`ҝ�+R>x�'Zko�)\�M �˴S3���^.t���i��Jخ^.��� ��z�Q����
�ެ=�h�E�׿$�m�ͮ�m�z��Z�.P گ=W�W���\M���n�Ş����w�׉a`�?�B9{�0�K�9AaimHW�-��j��]�t��"���Y7�O�*J\G�+)q-%��������T�J\W�++qm%��������X�*K\g�+-q�%��������\�K\w�+/q����ԣ������׿��$�-"�$���I?Na#�r�.l�b�,�����t�p� �� �E��]�S����_�"��ʭ�Q�"D�J~c���,Ո��c�=��d��$:S�������{���	���u*)>N��,xH���k�� 2r������%,�I�c�<�����&)Q��z��͎t@�E�^�iG�q+�I������X᎗= �_�_���uk�"
ȼ�z���ˍzN������ד~�/~�{'��G�e
±�龟��<��X&Uj 'Ju���}��
O^����0?�]
RR����d� -y$ C)ȑ@��2���'/Ȭܦa[�y}�OK��<A�VdIq]����H��g�<�����1��g~��� ���y�Ƒf�R���")���:�i/$�����#�[�m=_�t%ռ.���4�`�bi��>�]F��k�"����}f������N�-L�9Q���	�-����E�yu�f�#)b��s0�4|�X�:�
��|��_"H�icN�ؓ6- \��v6���s
5��ʈ��+مkc��{0N�WӴ��IB⽾����ޘ�Η��}<Q.=ӎ��m@v��:dD�L;w)������Z���n(H���v6�BV��� �¹���,� ��W_��;ד����qK�g%��~K�����+'{S��*O��P3�3�_�g>�p!�;?�����~x�ց�?׏G���ig�A��ʟ�_d����'&w~V
������d�?�|�������^�۲s=b�CW��J��_���U!�G�9�^}��S�*�spCg�p�����:���+ ��3�|p�?/��Q��s�Z@�����4O��g4RH���~n"����9��Y�?����&�v�-\k(��??�/5g�����O嵐���& F��°�����x�K׎���z��r��c{d�ޟPC�v�A|&*��������l�����5�l�g��/ך��ٲ������s��{|��!#v�_r����ls���(qx�~>J��ӽ��ܵ�k���f��r��{"s~��fV�������O{f�]����k�����xr�Շ�g���{��=�͇XH������N���0��I���/�J��xi�+2�{=۝�G��O�vS�z�4�E�&�kP&~�2w��������7E��_�)~Ο�d�\�!,S���kf��ڄ�@�s=w����H����9 �+�T�~��#\@,��݁�o�B�`���>�/q,c9��w|������2+�P��0��c����]4ͮ�c���_���-�[���1�����8<T}���q���Q�z?�v�C�؅`1���?}a��!n喫���Qs;R�{ 	�Q�f�2%�c=�ϝ��3��쒣����S�H��/*뮽X[�Ke_?:��^�V�ew����q���d�����(0��>�iN%��6H�<�>���1I_ߏ2:9�k�)���+���ԍo!w�\o;K��w|��5)��~��X��Ŀ�c��끌���bRcZ��ףhr���� w������������<�v���w��}���!�u��S�m|@5Y�v�'�y���e���`r���Gd�7u�i��X'���I�D�vE�L��/|/y�8�"�N	�����>w�+ft:�����^{b?{oV�(���r�E�Lr؎oH�(Bu�_�XB�/�|���?��X ��|�p���Ui\���.DDt��eǥ���I�W��gt`�m�p/a|������_ �������b���ҭB�����H:�v��j����������~����~��x�x����ڝj��z�ҕ�,��%ď�����D���χ����/{���~�י{=+>+���7�5�lً����;����'�B�SCi��=G[���5{�57B>^����ƃ�3�4�;R�5>���-dnaY��Ѷ�e�F��Rqd�����,�^�pQ������ک����Y���Ć�!�3\�K���"���6�c����>���{}Fp�?�T�O�;��%�G$3�^���u���Od�:s�J@�'f⿆���n����N{���k2�� ��
�<e)�% �P�{��ͤ�];���v�ݶ��aC�nuګ��3��R� ��"����^bfc)���n��?��X�g0��)�Up�2�Ęs=�ɄkD���u=��	c������J/��U�@�Q� ��F$GC��_����3B�=O|@2Hfɴ���3>v�~�i�#�����>bb���V�_���7�����'2�x��߈6�ok��}��m�ZHȘ2��~~�&�����͗�ݯ�{ /���^;��ǚ_���.=��;`)�50H|�����P�0�lx	�moa?Vd�o�8G���7W!�V,7�"�Qr:<���� ���j���s/3<zv�����u��.�tS�ا�M׎\�4|��|��&s�>X����Z?xV��H-����]G��u��n�kL��,���{��l�כD�    U���G240~W��KD�,{�c�v�y��X��1T��v
%4VCoba�aC���u�ϵ����ܮ� _6��1� TEs�[�����W�r�]b����|��{����?��vc�"v"V'��s�{�l�j)���So��b��_��"W͵����� ˄s��p�e�k���-���"&�˧=R�J����=b��כ�庫� �f�z�/+���|�v����GAߐ���n�*�����-��4J	u�����a���@_�~e����Ab6f߱3~�����1�0��gb���/����0 W?�!��u�)��{=����X�'*�,��Ux����*0�F�ŇU��e���.�]e?��~�����7��@�i��G�je�����!�C�<��-j���>:H�;����읥/�)]�B����}���`W?�U:��13Hܑ�����|O�z��q����/�b� Q��]���-�/�ޯ�?���>@@˪�igECgU��ӥ���\I�d�ɍ���pc45h��v�|����7�!E64?��N�P(j�U����� C��#r��.>���)����[���~B@���|�A%����l��^�� ����HX0�O{�������NE,̟�O�5'�Y��^���|+ӥ��V&��	jia9a�3��:e����_sn�l�߇ek�����S��z����wk����l���=��Ev���'���8��m4�����mwp�Eq�����	����6�i�,�w�W����D��p�C�Ċ[�sI,9v=���G�vB�SU�g�f�h�>*�����cW��)�H�ԻD]��y93?�����[�8�����';FW����l�w�ߛ�E-�[�r��z�b�0����g�(gM��iG�b��^��"G>�Rp4�Diu�o(!���R{���Q�G˴���Ѐ~>e)@�HR��[*s����ۦV*y�+�j}"7#m�	f,�u���:���JuɆ�xׇv<����"�i%��T ��V���s_;��FBΰz#�R ��}�����V��{���S&���K�T���*2I����P����Ӳ?P���"]G�4[k6e6мߧ�����a�����s-�?��|X����tP�o���Z@v[̝?����Y�%�}�����.������<�&�Z����������f��;�S'��A�1�Vo A��GY����3�
�u��3wg�ޮEx�t�/7���}���2��ɍM���i���^���l���ߓ%n��1&�M�m�~�'<�X�~ž���y��.��H $N�����{�Cɹs=K�+�[���(����6�C2�ħ� ��=��Ü�Z�p6�=`^�ެ�aמ��o��m���z�Y�@���>�ǐ%H'�d@�Z���a;؟�{-��?E���s��V������n�F��s�Z���'0_|Y
�YG*���*޸=g�DL���/l��O؞�(��A��P�!�\�C�68�}=[�i���/����"�*�K}��	)�Z_Lx<en��S����0��'�����~�ۙ�>,�V�>g�׷}�zv��u.�7�Y��ΜGB�>p<ٗq�2�V�Ϫ�V����* 뷰��5 ��qR	,m��Ȼ4�N�`�����R��̸E�Hw����L �q꣐oa�m�����x���������q��{���;7L�S�eKG�xV�ݻ� =N}^ �vf?ŭ\��qHB>r������Pay?��<�]������~Z2�w}b�����4��?�Ґ��~�_9$�I�������OCd_��K�\�J|n�m��d�"��M���|?���Q�q���"�?����3�^���a��y��҇��Tͧ~�%��P����Y���3���=>%!�K���2��jOFQe�}�'�t�wRC�8d9g~�ЭW����ԪgFvH$p�׮�>= z�����*?��>EȊ�ڞ5~@h8��y��Gue7��.��5�A��c��`�݆�V�á����tI4�n��Wl ����B�ּ���ԕ�����/W�.��]?���%����B��؃��߀�3�~L���{
ݼc��ų�%�`���c����L��N���)��\묯T�>�7o��燃r��~�����=7�۩/�7x[�/���Q�ĺ�}_�ﻗ�9
�7����ƞ� o��9�C7 ?���dKG��S��.�?�ܵ�1r��&���p�>9�{~wgrH풴�Vv�5����d����4^��p�M�?So}�������ȒP��{,(�����q��sH(�9����T�pS�~uP�n�o�Y�y>L8M�ן��d[/�$��0;�gS'd>$	�G��+@�~���F[��U�I͚�S�ꖰ�a`�40A=񋝷��n���r�<g~b9Rg�A2�f��y��l�>��VA��0W$&>a��b�ѹ�aʜ�����;"�mH��`����`�J=�S��5~��l�q��/��̀���,����"+��!|y�_;����ա,E���݆��W/+�0FW�����myoN~���y~��k��ɺHe�K�.R���%.m���y̸�䯭���ew����_GJW:�g��_��?���׎��e.�y=Ы[t�}$<@^�����h�ޚ'�6�ߧP`����-�a�g
�����)�0��%,���\�نg?>`6����7ιy��7Lİ���H�`������|쵳;����w~Tn�E��?ۮH��|U!�ڿ@��(oK=����-�?����Kv��/C������b������c}�3><+�����H�s�~�)�Y���TN�U��6F�yIP-���e���e�ˉ��Cx�V��.*�r�g��?0�Z��g5ᵿZ�vۑX%�z��_�9;��Ɨ+3��'�py��ޯR������M[����B��߃k�����-0��p��͝�g��������0���s(���r���Ϻ������\���S�y���=�������P�c�?2,k��������X�BJv���t�[���v�j`=w~yG9���cX����/�o���x�gt�|�h<����[�h���Kr��5�Y���e�|�YT���;���{������B~4�� ��Y��pE
�WMx�/ۯ�2q����o�:����iR��j�(���|�r ��k|���_9��߱���C`Ȁ���0h<e��T��t��3�Gx�� 5|������\j6��lб���ݚ�?�D��c�"�%�i���˕�2n~l*�E�����@����������_�}�+t��yK'�%��RJjI%���ZbI-�Ė\BK/�%��RLjI�#ۼ�v�����UN$��m"n8�ܠ��h�H��#F��ݶ7��(�l#:n;Rzf�YLsv��׳A%��<&y B�W��邼y��
�d�l��xC���1�y�,�m� tcl����"ͺeZH��u �aJl_�s�����}�����g}?O��V�����'������0�����<�b
U���TU����T��8ݗ��i#1�����*���-�)�� *����ˡ�20�I�[���b ���t��c���*����U=����Q�ӫ�� Ӽ�X��%1�ī��H�ct�tR�u� ���O#�F�WV�g��no0����9N?��o��̔�.�2�������Z����Tۍ���?~����������}�n������RE�#E�0y��Ad��bK���C�PA:��5�C�PE:��u�C!�PI<���C1�PM:����CA�PQ:��5�CQ�PU:��u�Ca�PY:����Cq�P]:���Ţ ��@*J������B*ʐ�:����D*J��Z����F*ʑ�z�� ��H*J�����(��J.��yQ�T&�IEiRQ�T'�IEyRQ�T(JE�RQ�T)U��(S*ꔊB��R�(U*j��b��Z�(W,�����b�(Y*j�����j�([*ꖊ¥�r�(]*j��⥢z�(_*�H�@$%� s  �!�*R�D�H!�D"�H��#�j$R�L��9)H"I�$��$��$R�DʒH])L"�I�4��&��DR��Iy�O"J�B��(�%R�D��H��S"�J�R��*�Z%R�D��H��W"K�b��,��%R�D��H��["�K�r��.��%R�H�H��_EQI�@E�D$QI�A�D%$Q
I�BŐD5dQI��� ���$J"��H�(���$�"��Ȣ0?��Di$QIGՑDy$QIH�D�$Q#IIU�D�$Q'IJ��D�$Q+IK���(�$�%��I�b�(�$j&��I�j�(�$�&��I�r�(�$j'��I�z�(�$�'�J���(�$j(�"
���(�$�(�BJ���(�$j)�bJ���(�$�)��J���(�$j*��J���(�$�*��J���(�$j+��J��H��]�ݺ��>`w�z��rI��a �3�[�7��u��V�������y�;o���]�����
��;��c���E�B��T��ҭ���Ќ��z��y{��;�͛4BR�z���W��M��y��=���?�������/��?���]��ο7˶=1�T��]q�,-1l������,"_Z�3�ۂ/}�ΰ�Y:,O�j�����#���I���?
��l��A%*�
��½��/)�K
��¿�!@�0 u(�:H�R��Ã�!B� �*P�
V�V���*p�
^�X� �*��
�W@K�R�T�-U���?�@�*إ
x��^���*�%�� ��Ab@H
��!18$�� �9Eb�H�A#1p$�� �DIb0I(�A%1�$�� �d"Mb�	8�A'1�$�� ��Qb0JH�A)10%�� ��Ub�JX�A+0p%�� �Yb0Kh�A-3������\b�Kv�/1�%���� $I�@R0�$I�ARp� $	I�BR��0$I�CR�@$I�DR0�P$I�ERp�`$I�FR��p$I�GR��!I�HR0��$%I�IRp��$)I�JR��D��+pI
^��� &)�I
f����&)�I
n�K"�Id���p&��-r�'4����ڽvO��A����8�;���yu�+��?χ̜J�b$8W���\� �հ�������g�v�2�z�~���>�[j�gCbz8s�ռ 'cQ'�M�	>�)VHl�Զ����E�m��e��'>B�מ�@�z�Z�����%�zC'$�����&n=y,�z��L��EE4������i���br�``���?��ﳊ	�{>���g�6��wR���?mH��gfQ3+buL���"?G��5� ��F�����������ǿ�����>�         �   x�}�Q
� D��0���z�� -�4$R��W�Oӏ�e|3K
P�)��i��u�oi ��A1Ӻ/{L��-�f�NP���S�_�ǶT�/�w�x?v�j0l��6��R¡e1��\&�����`��4l>L�d�Ɋ�t������Z��j��yE�2/"U
�P,�4JL��E/Z�/ݡ�q      #   �   x�mн
�0��9��O�4���N��K�"m!Z������SM-|�<gx��Lflӷ��	[1>&|�qp��*<ҜO��p��Ǥ��g�� �:��d��<�S���
�(�yt�a�(�G}�=�Q�y��yt�1�y�3��K�nx�s�r_w�������x�a�9� >�yQ      %   n   x�m�=
�0��9=LI�����\Jq�B��1�Q\�/y�򰦒�:D����x�% �=�L�NK�9A5�I~�aT�in��(������w��ҧ!앟H�ެ1�=�+�      ,      x������ � �      !     x���MN�@�דS�����y��Y����DJ:�M�sq.ƨP�J]ۋg���d��!l?�1,�6�&}}��Q�a�4�[��L:�H�k?�/Go���0�u����P �ܹ��Q �o+n�D"�j(kc+S�lV��4mv7���p��RZqޥq1���뗷���F�C[�9����)�_xT�(�O��z�/�WK�?��UȮ$MW�&ϤA#�r�x��g�c��N>��.���!�x��<
�!J�Be=Ys
�+` ����x�E����      )      x������ � �      '   <  x���n%7����I�K�"�b6Y�&�I� ��u�2���m�ʀ�k�C��P� }��˷����߾(X��\
�ׯ�^�h�1�Z�E��jD�2�XqS���	o 2P7-E�CR�xթ+`�|��ڌ��O�I���d]�ڀ�ɱYA�y業mV�uT�ç������������J�ͭL\8rI�c��Z`کyPc���R%�W՛���n�����ʊQ���\:N��M�<���+��X��*<yd������
E��\<;�z��˦z��01bes6�^�!��Fcs�0�S@�w#^u��`��� ��U���5����y~�^HS)��~�?�������z��y~r�,��͛���W��D>n���V��Cs�5�px3Y���2����Ek�����?���N��h�(A���XT�|Ћ�j�/�n�.�����cNl%6�*�����)S���}/4�1[���Z����چ�y��w�\rK��8�K�^>��sH��F魮��_�%�c~��{nuU� �_����eq�#����n>i��4�O�z��	ly��^<�]3R5�|yi�dK7��չ������"�y5��o=��fW��>6���޿�8�D�ӟtjE��~|��(�w��7�\mNr�Ş��Ȃ��py��/�\��ᴖ�ޛ�[�r�V}s��9O�J�Q�;��WΚJ��<���۸�y��R���a1��3���o���W����9��e��g��!�[u��my����#a�G͇zIͧ����Hp9��y�4 cg�|2�����<\�0>�SKty;�V5�N_n^��_�>�i�v���FT�y�kՀ����9��?�bֶ���^�5������F�}�9dק�W�[��������o�3%p�+fSё��w���o�	9���M@�g�;K�Ho�t�����Q>������_�
z��	Sj
E� o���~�.�	/<��#8����ק5���e��#�n� $Ʋ��z�_��������'�=)�IaO
{Rؓ�~`
�+����??!�	aO{B����'�=!�ǅ������� QH      F      x������ � �         �   x�M��n�@E��W�`���830����6DR��4�Le$�HE��__�1��������*8`V�+����F����E��&�m�f1k?�� ���ٔ�Y��=���E+��>�]&��18c�#t<@%�.8 ,�$/MQ�1M�gE��=]����n.
DpC%��P��O+Y_j�|�~�u��S�t��B��G��3���u�jҝ��������롢BHd�z��e� kAM�     