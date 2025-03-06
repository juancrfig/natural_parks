-- DEPARTMENT INSERTS
INSERT INTO
    department (id, name)
VALUES
    (1, 'Antioquia'),
    (2, 'Chocó'),
    (3, 'Valle del Cauca'),
    (4, 'Cundinamarca'),
    (5, 'Boyacá'),
    (6, 'Santander'),
    (7, 'Norte de Santander'),
    (8, 'Bolívar'),
    (9, 'Magdalena'),
    (10, 'Cauca'),
    (11, 'Nariño'),
    (12, 'Amazonas'),
    (13, 'Guainía'),
    (14, 'Vichada'),
    (15, 'Meta'),
    (16, 'Casanare'),
    (17, 'Córdoba'),
    (18, 'Sucre'),
    (19, 'Atlántico'),
    (20, 'La Guajira'),
    (21, 'Cesar'),
    (22, 'Arauca'),
    (23, 'Guaviare'),
    (24, 'Caquetá'),
    (25, 'Putumayo'),
    (26, 'Huila'),
    (27, 'Tolima'),
    (28, 'Caldas'),
    (29, 'Risaralda'),
    (30, 'Quindío'),
    (31, 'San Andrés y Providencia'),
    (32, 'Vaupés'),
    (33, 'Bogotá D.C.'),
    (34, 'Buenaventura'),
    (35, 'Santa Marta'),
    (36, 'Cartagena'),
    (37, 'Barranquilla'),
    (38, 'Medellín'),
    (39, 'Cali'),
    (40, 'Tunja'),
    (41, 'Manizales'),
    (42, 'Pasto'),
    (43, 'Popayán'),
    (44, 'Ibagué'),
    (45, 'Bucaramanga'),
    (46, 'Cúcuta'),
    (47, 'Villavicencio'),
    (48, 'Yopal'),
    (49, 'Montería'),
    (50, 'Riohacha');

-- RESPONSIBLE ENTITY INSERTS
INSERT INTO
    responsible_entity (id, name)
VALUES
    (1, 'Parques Nacionales Naturales de Colombia'),
    (
        2,
        'Ministerio de Ambiente y Desarrollo Sostenible'
    ),
    (
        3,
        'Corporación Autónoma Regional del Centro de Antioquia'
    ),
    (
        4,
        'Corporación Autónoma Regional del Valle del Cauca'
    ),
    (
        5,
        'Corporación Autónoma Regional de Cundinamarca'
    ),
    (6, 'Corporación Autónoma Regional de Boyacá'),
    (7, 'Corporación Autónoma Regional del Magdalena'),
    (8, 'Corporación Autónoma Regional del Cauca'),
    (9, 'Corporación Autónoma Regional del Amazonas'),
    (
        10,
        'Corporación para el Desarrollo Sostenible del Norte y Oriente Amazónico'
    ),
    (
        11,
        'Corporación para el Desarrollo Sostenible del Sur de la Amazonía'
    ),
    (12, 'Secretaría de Medio Ambiente de Antioquia'),
    (13, 'Secretaría de Ambiente de Bogotá'),
    (
        14,
        'Departamento Administrativo de Gestión del Medio Ambiente de Cali'
    ),
    (15, 'Corporación Autónoma Regional de La Guajira'),
    (16, 'Corporación Autónoma Regional del Cesar'),
    (17, 'Corporación Autónoma Regional de Santander'),
    (
        18,
        'Corporación Autónoma Regional de Norte de Santander'
    ),
    (19, 'Corporación Autónoma Regional de Caldas'),
    (20, 'Corporación Autónoma Regional de Risaralda'),
    (21, 'Corporación Autónoma Regional del Quindío'),
    (
        22,
        'Corporación Autónoma Regional del Canal del Dique'
    ),
    (23, 'Corporación Autónoma Regional de Sucre'),
    (
        24,
        'Corporación Autónoma Regional de Los Valles del Sinú y San Jorge'
    ),
    (25, 'Corporación Autónoma Regional del Atlántico'),
    (26, 'Corporación Autónoma Regional del Tolima'),
    (
        27,
        'Corporación Autónoma Regional del Alto Magdalena'
    ),
    (28, 'Corporación Autónoma Regional de Chivor'),
    (
        29,
        'Corporación Autónoma Regional de la Frontera Nororiental'
    ),
    (
        30,
        'Corporación Autónoma Regional de la Orinoquía'
    ),
    (
        31,
        'Corporación para el Desarrollo Sostenible del Archipiélago de San Andrés'
    ),
    (
        32,
        'Corporación para el Desarrollo Sostenible del Urabá'
    ),
    (
        33,
        'Corporación para el Desarrollo Sostenible de La Mojana'
    ),
    (
        34,
        'Secretaría de Ambiente y Desarrollo Sostenible del Meta'
    ),
    (
        35,
        'Secretaría de Ambiente y Desarrollo Sostenible del Casanare'
    ),
    (
        36,
        'Instituto Amazónico de Investigaciones Científicas'
    ),
    (
        37,
        'Instituto de Hidrología, Meteorología y Estudios Ambientales'
    ),
    (
        38,
        'Instituto de Investigaciones Marinas y Costeras'
    ),
    (
        39,
        'Instituto de Investigación de Recursos Biológicos Alexander von Humboldt'
    ),
    (
        40,
        'Dirección Territorial Pacífico de Parques Nacionales Naturales'
    ),
    (
        41,
        'Dirección Territorial Caribe de Parques Nacionales Naturales'
    ),
    (
        42,
        'Dirección Territorial Andes Occidentales de Parques Nacionales Naturales'
    ),
    (
        43,
        'Dirección Territorial Andes Nororientales de Parques Nacionales Naturales'
    ),
    (
        44,
        'Dirección Territorial Amazonía de Parques Nacionales Naturales'
    ),
    (
        45,
        'Dirección Territorial Orinoquía de Parques Nacionales Naturales'
    ),
    (46, 'Fundación ProAves'),
    (47, 'Fondo Mundial para la Naturaleza Colombia'),
    (48, 'The Nature Conservancy Colombia'),
    (49, 'Conservación Internacional Colombia'),
    (
        50,
        'Asociación Colombiana de Reservas Naturales de la Sociedad Civil'
    );

-- DEPARTMENT_ENTITY INSERTS
INSERT INTO
    department_entity (department_id, entity_id)
VALUES
    (1, 3),
    (1, 12),
    (1, 32),
    (1, 42),
    (2, 1),
    (2, 32),
    (2, 40),
    (3, 4),
    (3, 14),
    (3, 42),
    (4, 5),
    (4, 13),
    (4, 43),
    (5, 6),
    (5, 28),
    (5, 43),
    (6, 17),
    (6, 43),
    (7, 18),
    (7, 29),
    (7, 43),
    (8, 22),
    (8, 41),
    (9, 7),
    (9, 41),
    (10, 8),
    (10, 42),
    (11, 1),
    (11, 42),
    (12, 9),
    (12, 44),
    (13, 10),
    (13, 44),
    (14, 30),
    (14, 45),
    (15, 34),
    (15, 45),
    (16, 30),
    (16, 35),
    (16, 45),
    (17, 24),
    (17, 32),
    (18, 23),
    (18, 33),
    (19, 25),
    (20, 15),
    (20, 41),
    (21, 16),
    (21, 41),
    (22, 29),
    (22, 45),
    (23, 11),
    (23, 44),
    (24, 11),
    (24, 44),
    (25, 11),
    (25, 44),
    (26, 27),
    (26, 42),
    (27, 26),
    (28, 19),
    (28, 42),
    (29, 20),
    (29, 42),
    (30, 21),
    (30, 42),
    (31, 31),
    (31, 41),
    (32, 10),
    (32, 44),
    (33, 13),
    (34, 4),
    (35, 7),
    (36, 22),
    (37, 25),
    (38, 3),
    (39, 4),
    (40, 6),
    (41, 19),
    (42, 1),
    (43, 8),
    (44, 26),
    (45, 17),
    (46, 18),
    (47, 34),
    (48, 35),
    (49, 24),
    (50, 15);

-- PARK INSERTS
INSERT INTO
    park (id, name, foundation_date)
VALUES
    (
        1,
        'Parque Nacional Natural Tayrona',
        '1964-04-24'
    ),
    (
        2,
        'Parque Nacional Natural Los Nevados',
        '1973-10-30'
    ),
    (
        3,
        'Parque Nacional Natural Sierra Nevada de Santa Marta',
        '1977-05-15'
    ),
    (
        4,
        'Parque Nacional Natural El Cocuy',
        '1977-06-22'
    ),
    (
        5,
        'Parque Nacional Natural Serranía de Chiribiquete',
        '1989-09-12'
    ),
    (
        6,
        'Parque Nacional Natural Chingaza',
        '1977-05-15'
    ),
    (
        7,
        'Parque Nacional Natural Sumapaz',
        '1977-06-06'
    ),
    (
        8,
        'Parque Nacional Natural Los Katíos',
        '1973-08-07'
    ),
    (9, 'Parque Nacional Natural Tatamá', '1987-10-14'),
    (
        10,
        'Parque Nacional Natural Las Hermosas',
        '1977-12-06'
    ),
    (
        11,
        'Parque Nacional Natural Farallones de Cali',
        '1968-07-18'
    ),
    (
        12,
        'Parque Nacional Natural Puracé',
        '1961-03-29'
    ),
    (
        13,
        'Parque Nacional Natural Munchique',
        '1977-08-25'
    ),
    (
        14,
        'Parque Nacional Natural Las Orquídeas',
        '1973-03-24'
    ),
    (
        15,
        'Parque Nacional Natural Paramillo',
        '1977-03-16'
    ),
    (
        16,
        'Parque Nacional Natural Amacayacu',
        '1975-11-05'
    ),
    (
        17,
        'Parque Nacional Natural Cahuinarí',
        '1986-08-19'
    ),
    (
        18,
        'Parque Nacional Natural La Paya',
        '1984-05-18'
    ),
    (
        19,
        'Parque Nacional Natural Isla Gorgona',
        '1984-12-01'
    ),
    (
        20,
        'Parque Nacional Natural Tuparro',
        '1970-07-21'
    ),
    (
        21,
        'Parque Nacional Natural Sanquianga',
        '1977-08-18'
    ),
    (22, 'Parque Nacional Natural Utría', '1987-08-28'),
    (23, 'Parque Nacional Natural Pisba', '1977-10-03'),
    (
        24,
        'Parque Nacional Natural Catatumbo Barí',
        '1989-01-31'
    ),
    (
        25,
        'Parque Nacional Natural Tinigua',
        '1989-11-30'
    ),
    (
        26,
        'Parque Nacional Natural Old Providence McBean Lagoon',
        '1995-12-14'
    ),
    (
        27,
        'Parque Nacional Natural Uramba Bahía Málaga',
        '2010-08-05'
    ),
    (
        28,
        'Parque Nacional Natural Sierra de la Macarena',
        '1971-11-05'
    ),
    (
        29,
        'Parque Nacional Natural Cordillera de los Picachos',
        '1977-10-15'
    ),
    (
        30,
        'Parque Nacional Natural Río Puré',
        '2002-04-10'
    ),
    (
        31,
        'Parque Nacional Natural Alto Fragua Indi Wasi',
        '2002-02-25'
    ),
    (
        32,
        'Parque Nacional Natural Complejo Volcánico Doña Juana',
        '2007-03-16'
    ),
    (
        33,
        'Parque Nacional Natural Corales del Rosario y San Bernardo',
        '1977-08-31'
    ),
    (
        34,
        'Parque Nacional Natural Los Corales de Profundidad',
        '2013-07-01'
    ),
    (
        35,
        'Parque Nacional Natural Acandí Playón y Playona',
        '2013-10-25'
    ),
    (
        36,
        'Parque Nacional Natural Bahía Portete-Kaurrele',
        '2014-12-19'
    ),
    (
        37,
        'Parque Nacional Natural Cueva de los Guácharos',
        '1960-11-09'
    ),
    (
        38,
        'Parque Nacional Natural El Tuparro',
        '1980-09-05'
    ),
    (39, 'Parque Nacional Natural Tamá', '1977-09-23'),
    (
        40,
        'Parque Nacional Natural Las Hermosas-Gloria Valencia de Castaño',
        '2016-03-18'
    ),
    (
        41,
        'Parque Nacional Natural Serranía de los Yariguíes',
        '2005-12-16'
    ),
    (
        42,
        'Parque Nacional Natural Selva de Florencia',
        '2005-06-10'
    ),
    (
        43,
        'Parque Nacional Natural Río Pure',
        '2002-08-08'
    ),
    (
        44,
        'Parque Nacional Natural Tayrona Norte',
        '2020-01-01'
    ),
    (
        45,
        'Parque Nacional Natural Valle Central',
        '2018-05-22'
    ),
    (
        46,
        'Parque Nacional Natural Altos del Casanare',
        '2019-11-10'
    ),
    (
        47,
        'Parque Nacional Natural Bahía Portete',
        '2014-09-23'
    ),
    (
        48,
        'Parque Nacional Natural Ciénaga Grande',
        '1977-10-25'
    ),
    (
        49,
        'Parque Nacional Natural Sierra Central',
        '2020-04-30'
    ),
    (
        50,
        'Parque Nacional Natural Bosques del Sur',
        '2021-07-12'
    );

-- DEPARTMENT_PARK INSERTS
INSERT INTO
    department_park (department_id, park_id)
VALUES
    (9, 1),
    (28, 2),
    (29, 2),
    (30, 2),
    (9, 3),
    (20, 3),
    (5, 4),
    (7, 4),
    (12, 5),
    (23, 5),
    (24, 5),
    (4, 6),
    (4, 7),
    (33, 7),
    (2, 8),
    (17, 8),
    (3, 9),
    (29, 9),
    (3, 10),
    (26, 10),
    (27, 10),
    (3, 11),
    (10, 12),
    (26, 12),
    (10, 13),
    (1, 14),
    (1, 15),
    (17, 15),
    (12, 16),
    (12, 17),
    (25, 18),
    (10, 19),
    (14, 20),
    (11, 21),
    (2, 22),
    (5, 23),
    (7, 24),
    (15, 25),
    (31, 26),
    (3, 27),
    (15, 28),
    (24, 29),
    (12, 30),
    (24, 31),
    (11, 32),
    (8, 33),
    (8, 34),
    (2, 35),
    (20, 36),
    (26, 37),
    (14, 38),
    (7, 39),
    (3, 40),
    (27, 40),
    (6, 41),
    (28, 42),
    (12, 43),
    (9, 44),
    (20, 44),
    (15, 45),
    (28, 45),
    (16, 46),
    (20, 47),
    (9, 48),
    (19, 48),
    (1, 49),
    (17, 49),
    (26, 50),
    (27, 50);

-- AREA INSERTS
INSERT INTO
    area (id, name, extent)
VALUES
    (1, 'Zona de Manglares', 1250.75),
    (2, 'Sendero de los Páramos', 3420.25),
    (3, 'Bosque de Niebla', 1870.50),
    (4, 'Valle de las Orquídeas', 980.25),
    (5, 'Cascada del Águila', 540.75),
    (6, 'Laguna Azul', 1120.50),
    (7, 'Mirador del Cóndor', 350.25),
    (8, 'Reserva de Aves', 2430.75),
    (9, 'Sendero del Oso', 1760.25),
    (10, 'Bosque Húmedo Tropical', 5230.50),
    (11, 'Arrecife de Coral', 3450.75),
    (12, 'Zona Arqueológica', 870.25),
    (13, 'Cueva de los Murciélagos', 320.50),
    (14, 'Humedal Central', 1980.75),
    (15, 'Quebrada Los Cristales', 480.25),
    (16, 'Playa Tortuga', 1650.50),
    (17, 'Salto del Tequendama', 750.75),
    (18, 'Sierra Nevada', 6540.25),
    (19, 'Valle del Río Claro', 2340.50),
    (20, 'Laguna de los Cisnes', 890.75),
    (21, 'Bosque Seco Tropical', 3210.25),
    (22, 'Isla de las Aves', 540.50),
    (23, 'Páramo de las Papas', 4320.75),
    (24, 'Cañón del Río Patía', 2980.25),
    (25, 'Cueva de los Guácharos', 410.50),
    (26, 'Cascada La Sirena', 690.75),
    (27, 'Valle de las Brumas', 1540.25),
    (28, 'Mirador del Valle', 320.50),
    (29, 'Ruta de los Venados', 1870.75),
    (30, 'Sendero Ecológico', 980.25),
    (31, 'Bosque de Guaduas', 1450.50),
    (32, 'Lagunas Glaciares', 2670.75),
    (33, 'Jardín de Bromelias', 430.25),
    (34, 'Desembocadura del Río', 2150.50),
    (35, 'Zona de Petroglifos', 780.75),
    (36, 'Sendero de los Monos', 1230.25),
    (37, 'Cascada El Salto', 560.50),
    (38, 'Mirador del Cañón', 310.75),
    (39, 'Bosque de Palmas', 1980.25),
    (40, 'Playa Escondida', 870.50),
    (41, 'Zona de Géiseres', 430.75),
    (42, 'Bosque Petrificado', 650.25),
    (43, 'Cuevas de Sal', 390.50),
    (44, 'Estero Marino', 2150.75),
    (45, 'Zona Árida Protegida', 1280.25),
    (46, 'Ciénaga Grande', 3540.50),
    (47, 'Sendero de las Mariposas', 750.75),
    (48, 'Reserva de Primates', 1320.25),
    (49, 'Valle de Frailejones', 2890.50),
    (50, 'Ruta del Tapir', 1670.75),
    (51, 'Bosque de Robles', 2140.25),
    (52, 'Laguna Negra', 960.50),
    (53, 'Zona de Reproducción de Aves', 1450.75),
    (54, 'Cascada de los Siete Velos', 580.25),
    (55, 'Valle de los Venados', 1930.50),
    (56, 'Canales de Manglares', 2750.75),
    (57, 'Mirador del Nevado', 420.25),
    (58, 'Bosque de Aliso', 1680.50),
    (59, 'Ruta del Jaguar', 2340.75),
    (60, 'Laguna de los Patos', 1120.25);

-- PARK_AREA INSERTS
INSERT INTO
    park_area (park_id, area_id)
VALUES
    (1, 1),
    (1, 16),
    (1, 40),
    (2, 2),
    (2, 32),
    (2, 57),
    (3, 18),
    (3, 29),
    (3, 49),
    (4, 23),
    (4, 32),
    (4, 49),
    (5, 10),
    (5, 36),
    (5, 48),
    (6, 2),
    (6, 7),
    (6, 49),
    (7, 2),
    (7, 23),
    (7, 49),
    (8, 1),
    (8, 10),
    (8, 56),
    (9, 3),
    (9, 27),
    (9, 33),
    (10, 7),
    (10, 38),
    (10, 55),
    (11, 3),
    (11, 10),
    (11, 39),
    (12, 23),
    (12, 41),
    (12, 42),
    (13, 3),
    (13, 9),
    (13, 31),
    (14, 4),
    (14, 33),
    (14, 47),
    (15, 9),
    (15, 50),
    (15, 59),
    (16, 10),
    (16, 36),
    (16, 48),
    (17, 10),
    (17, 44),
    (17, 56),
    (18, 10),
    (18, 19),
    (18, 36),
    (19, 11),
    (19, 22),
    (19, 44),
    (20, 14),
    (20, 45),
    (20, 46),
    (21, 1),
    (21, 44),
    (21, 56),
    (22, 1),
    (22, 10),
    (22, 11),
    (23, 2),
    (23, 23),
    (23, 49),
    (24, 3),
    (24, 10),
    (24, 39),
    (25, 9),
    (25, 19),
    (25, 50),
    (26, 11),
    (26, 22),
    (26, 53),
    (27, 1),
    (27, 11),
    (27, 44),
    (28, 9),
    (28, 19),
    (28, 59),
    (29, 9),
    (29, 10),
    (29, 36),
    (30, 10),
    (30, 48),
    (30, 50),
    (31, 10),
    (31, 25),
    (31, 36),
    (32, 23),
    (32, 41),
    (32, 42),
    (33, 11),
    (33, 22),
    (33, 44),
    (34, 11),
    (34, 22),
    (34, 44),
    (35, 1),
    (35, 16),
    (35, 40),
    (36, 1),
    (36, 16),
    (36, 40),
    (37, 13),
    (37, 25),
    (37, 43),
    (38, 14),
    (38, 45),
    (38, 46),
    (39, 3),
    (39, 9),
    (39, 58),
    (40, 7),
    (40, 38),
    (40, 55),
    (41, 3),
    (41, 51),
    (41, 58),
    (42, 3),
    (42, 33),
    (42, 51),
    (43, 10),
    (43, 36),
    (43, 48),
    (44, 16),
    (44, 40),
    (44, 53),
    (45, 15),
    (45, 19),
    (45, 20),
    (46, 14),
    (46, 46),
    (46, 60),
    (47, 1),
    (47, 16),
    (47, 40),
    (48, 14),
    (48, 46),
    (48, 60),
    (49, 9),
    (49, 50),
    (49, 59),
    (50, 3),
    (50, 27),
    (50, 31);

-- SPECIES INSERTS
INSERT INTO
    species (id, type, common_name, scientific_name)
VALUES
    (1, 'animal', 'Jaguar', 'Panthera onca'),
    (
        2,
        'animal',
        'Oso de anteojos',
        'Tremarctos ornatus'
    ),
    (3, 'animal', 'Cóndor andino', 'Vultur gryphus'),
    (4, 'animal', 'Danta', 'Tapirus terrestris'),
    (5, 'animal', 'Águila harpía', 'Harpia harpyja'),
    (
        6,
        'animal',
        'Mono aullador',
        'Alouatta seniculus'
    ),
    (
        7,
        'animal',
        'Tortuga carey',
        'Eretmochelys imbricata'
    ),
    (
        8,
        'animal',
        'Cocodrilo del Orinoco',
        'Crocodylus intermedius'
    ),
    (
        9,
        'animal',
        'Manatí del Caribe',
        'Trichechus manatus'
    ),
    (
        10,
        'animal',
        'Venado cola blanca',
        'Odocoileus virginianus'
    ),
    (11, 'animal', 'Tigrillo', 'Leopardus tigrinus'),
    (
        12,
        'animal',
        'Rana dorada',
        'Phyllobates terribilis'
    ),
    (
        13,
        'animal',
        'Nutria gigante',
        'Pteronura brasiliensis'
    ),
    (14, 'animal', 'Puma', 'Puma concolor'),
    (15, 'animal', 'Guacamaya roja', 'Ara macao'),
    (
        16,
        'animal',
        'Colibrí esmeralda',
        'Chlorostilbon melanorhynchus'
    ),
    (
        17,
        'animal',
        'Rana de cristal',
        'Hyalinobatrachium fleischmanni'
    ),
    (
        18,
        'animal',
        'Perezoso de tres dedos',
        'Bradypus variegatus'
    ),
    (19, 'animal', 'Delfín rosado', 'Inia geoffrensis'),
    (
        20,
        'animal',
        'Armadillo gigante',
        'Priodontes maximus'
    ),
    (
        21,
        'vegetable',
        'Frailejón',
        'Espeletia grandiflora'
    ),
    (
        22,
        'vegetable',
        'Orquídea cattleya',
        'Cattleya trianae'
    ),
    (
        23,
        'vegetable',
        'Palma de cera',
        'Ceroxylon quindiuense'
    ),
    (
        24,
        'vegetable',
        'Roble andino',
        'Quercus humboldtii'
    ),
    (
        25,
        'vegetable',
        'Mangle rojo',
        'Rhizophora mangle'
    ),
    (
        26,
        'vegetable',
        'Árbol de caucho',
        'Hevea brasiliensis'
    ),
    (27, 'vegetable', 'Ceiba', 'Ceiba pentandra'),
    (
        28,
        'vegetable',
        'Bromelias',
        'Tillandsia usneoides'
    ),
    (29, 'vegetable', 'Guadua', 'Guadua angustifolia'),
    (30, 'vegetable', 'Heliconia', 'Heliconia bihai'),
    (
        31,
        'vegetable',
        'Victoria amazónica',
        'Victoria amazonica'
    ),
    (
        32,
        'vegetable',
        'Árbol de tagua',
        'Phytelephas macrocarpa'
    ),
    (
        33,
        'vegetable',
        'Algarrobo',
        'Hymenaea courbaril'
    ),
    (34, 'vegetable', 'Nogal', 'Juglans neotropica'),
    (35, 'vegetable', 'Abarco', 'Cariniana pyriformis'),
    (36, 'vegetable', 'Cedro', 'Cedrela odorata'),
    (
        37,
        'vegetable',
        'Chaquiro',
        'Podocarpus oleifolius'
    ),
    (
        38,
        'vegetable',
        'Anturio negro',
        'Anthurium crystallinum'
    ),
    (39, 'vegetable', 'Yarumo', 'Cecropia peltata'),
    (
        40,
        'vegetable',
        'Guayacán',
        'Tabebuia chrysantha'
    ),
    (41, 'mineral', 'Cuarzo rosa', 'Sílice'),
    (42, 'mineral', 'Esmeralda', 'Berilo'),
    (43, 'mineral', 'Calcita', 'Carbonato de calcio'),
    (44, 'mineral', 'Pirita', 'Sulfuro de hierro'),
    (45, 'mineral', 'Amatista', 'Cuarzo violeta'),
    (
        46,
        'mineral',
        'Mármol',
        'Carbonato de calcio metamórfico'
    ),
    (
        47,
        'mineral',
        'Carbón',
        'Carbono orgánico sedimentario'
    ),
    (
        48,
        'mineral',
        'Arcilla roja',
        'Silicato de aluminio hidratado'
    ),
    (49, 'mineral', 'Sal gema', 'Cloruro de sodio'),
    (50, 'mineral', 'Ágata', 'Calcedonia'),
    (
        51,
        'animal',
        'Pez dorado',
        'Brachyplatystoma rousseauxii'
    ),
    (52, 'animal', 'Tucán', 'Ramphastos swainsonii'),
    (
        53,
        'animal',
        'Guacharos',
        'Steatornis caripensis'
    ),
    (54, 'animal', 'Pato cuchara', 'Spatula clypeata'),
    (
        55,
        'animal',
        'Boa constrictor',
        'Boa constrictor'
    ),
    (56, 'vegetable', 'Bambú', 'Bambusa vulgaris'),
    (
        57,
        'vegetable',
        'Lirio acuático',
        'Nymphaea alba'
    ),
    (58, 'vegetable', 'Caimo', 'Pouteria caimito'),
    (
        59,
        'vegetable',
        'Cacao silvestre',
        'Theobroma cacao'
    ),
    (
        60,
        'mineral',
        'Hierro nativo',
        'Hierro elemental'
    );

-- AREA_SPECIES INSERTS
INSERT INTO area_species (area_id, species_id, population) VALUES
-- Area 1: Zona de Manglares (Mangrove Zone)
(1, 25, 15000), -- Mangle rojo (red mangrove)
(1, 9, 45),     -- Manatí del Caribe (Caribbean manatee)
(1, 19, 120),   -- Delfín rosado (pink dolphin)
(1, 7, 250),    -- Tortuga carey (hawksbill turtle)
(1, 56, 850),   -- Bambú (bamboo)

-- Area 2: Sendero de los Páramos (Paramo Trail)
(2, 21, 12500), -- Frailejón (frailejon plant)
(2, 3, 35),     -- Cóndor andino (Andean condor)
(2, 10, 180),   -- Venado cola blanca (white-tailed deer)
(2, 16, 320),   -- Colibrí esmeralda (emerald hummingbird)
(2, 54, 85),    -- Pato cuchara (shoveler duck)

-- Area 3: Bosque de Niebla (Cloud Forest)
(3, 24, 8700),  -- Roble (oak)
(3, 2, 28),     -- Oso de anteojos (spectacled bear)
(3, 11, 65),    -- Tigrillo (oncilla)
(3, 14, 42),    -- Puma (cougar)
(3, 36, 2300),  -- Guayacán (guaiacum tree)

-- Area 4: Valle de las Orquídeas (Orchid Valley)
(4, 22, 3500),  -- Orquídea (orchid)
(4, 16, 280),   -- Colibrí esmeralda (emerald hummingbird)
(4, 28, 7800),  -- Bromelias (bromeliads)
(4, 30, 4200),  -- Heliconia (heliconia)
(4, 38, 1500),  -- Anturio (anthurium)

-- Area 5: Cascada del Águila (Eagle Waterfall)
(5, 37, 1800),  -- Chaquiro (golden chaquiro tree)
(5, 3, 22),     -- Cóndor andino (Andean condor)
(5, 5, 18),     -- Águila harpía (harpy eagle)
(5, 14, 35),    -- Puma (cougar)
(5, 16, 240),   -- Colibrí esmeralda (emerald hummingbird)

-- Area 6: Laguna Azul (Blue Lagoon)
(6, 31, 780),   -- Victoria amazónica (Amazon water lily)
(6, 13, 56),    -- Nutria gigante (giant otter)
(6, 19, 85),    -- Delfín rosado (pink dolphin)
(6, 51, 1200),  -- Pez dorado (golden fish)
(6, 54, 150),   -- Pato cuchara (shoveler duck)

-- Area 7: Mirador del Cóndor (Condor Lookout)
(7, 3, 10),     -- Cóndor andino (Andean condor)
(7, 2, 15),     -- Oso de anteojos (spectacled bear)
(7, 21, 5000),  -- Frailejón (frailejon plant)
(7, 16, 200),   -- Colibrí esmeralda (emerald hummingbird)
(7, 24, 3000),  -- Roble (oak)

-- Area 8: Reserva de Aves (Bird Reserve)
(8, 15, 50),    -- Loro orejiamarillo (yellow-eared parrot)
(8, 52, 80),    -- Tucán (toucan)
(8, 16, 300),   -- Colibrí esmeralda (emerald hummingbird)
(8, 54, 120),   -- Pato cuchara (shoveler duck)
(8, 30, 1000),  -- Heliconia (heliconia)

-- Area 9: Sendero del Oso (Bear Trail)
(9, 2, 20),     -- Oso de anteojos (spectacled bear)
(9, 6, 50),     -- Mono aullador (howler monkey)
(9, 10, 100),   -- Venado cola blanca (white-tailed deer)
(9, 14, 15),    -- Puma (cougar)
(9, 24, 2500),  -- Roble (oak)

-- Area 10: Bosque Húmedo Tropical (Tropical Rainforest)
(10, 1, 10),    -- Jaguar (jaguar)
(10, 6, 200),   -- Mono aullador (howler monkey)
(10, 52, 150),  -- Tucán (toucan)
(10, 22, 5000), -- Orquídea (orchid)
(10, 27, 300),  -- Ceiba (ceiba tree)

-- Area 11: Arrecife de Coral (Coral Reef)
(11, 7, 100),   -- Tortuga carey (hawksbill turtle)
(11, 9, 20),    -- Manatí del Caribe (Caribbean manatee)
(11, 19, 50),   -- Delfín rosado (pink dolphin)
(11, 51, 2000), -- Pez dorado (golden fish)
(11, 25, 5000), -- Mangle rojo (red mangrove)

-- Area 12: Zona Arqueológica (Archaeological Zone)
(12, 10, 150),  -- Venado cola blanca (white-tailed deer)
(12, 27, 200),  -- Ceiba (ceiba tree)
(12, 6, 100),   -- Mono aullador (howler monkey)
(12, 59, 500),  -- Cacao silvestre (wild cacao)
(12, 16, 300),  -- Colibrí esmeralda (emerald hummingbird)

-- Area 13: Cueva de los Murciélagos (Bat Cave)
(13, 53, 500),  -- Guacharos (oilbirds)
(13, 17, 200),  -- Rana de cristal (glass frog)
(13, 28, 1000), -- Bromelias (bromeliads)
(13, 43, 5000), -- Calcita (calcite)
(13, 12, 300),  -- Rana dorada (golden poison frog)

-- Area 14: Humedal Central (Central Wetland)
(14, 13, 30),   -- Nutria gigante (giant otter)
(14, 54, 200),  -- Pato cuchara (shoveler duck)
(14, 31, 500),  -- Victoria amazónica (Amazon water lily)
(14, 8, 15),    -- Cocodrilo del Orinoco (Orinoco crocodile)
(14, 57, 2000), -- Lirio acuático (water lily)

-- Area 15: Quebrada Los Cristales (Crystal Creek)
(15, 51, 1000), -- Pez dorado (golden fish)
(15, 17, 150),  -- Rana de cristal (glass frog)
(15, 30, 800),  -- Heliconia (heliconia)
(15, 13, 25),   -- Nutria gigante (giant otter)
(15, 29, 3000), -- Guadua (guadua bamboo)

-- Area 16: Playa Tortuga (Turtle Beach)
(16, 7, 200),   -- Tortuga carey (hawksbill turtle)
(16, 9, 30),    -- Manatí del Caribe (Caribbean manatee)
(16, 19, 40),   -- Delfín rosado (pink dolphin)
(16, 25, 4000), -- Mangle rojo (red mangrove)
(16, 56, 1000), -- Bambú (bamboo)

-- Area 17: Salto del Tequendama (Tequendama Falls)
(17, 5, 10),    -- Águila harpía (harpy eagle)
(17, 16, 250),  -- Colibrí esmeralda (emerald hummingbird)
(17, 37, 1500), -- Chaquiro (golden chaquiro tree)
(17, 3, 15),    -- Cóndor andino (Andean condor)
(17, 21, 3000), -- Frailejón (frailejon plant)

-- Area 18: Sierra Nevada (Snowy Mountain Range)
(18, 3, 20),    -- Cóndor andino (Andean condor)
(18, 2, 25),    -- Oso de anteojos (spectacled bear)
(18, 21, 10000),-- Frailejón (frailejon plant)
(18, 24, 2000), -- Roble (oak)
(18, 16, 300),  -- Colibrí esmeralda (emerald hummingbird)

-- Area 19: Valle del Río Claro (Clear River Valley)
(19, 51, 1500), -- Pez dorado (golden fish)
(19, 13, 40),   -- Nutria gigante (giant otter)
(19, 6, 80),    -- Mono aullador (howler monkey)
(19, 30, 1200), -- Heliconia (heliconia)
(19, 39, 2500), -- Yarumos (yarumo tree)

-- Area 20: Laguna de los Cisnes (Swan Lagoon)
(20, 54, 180),  -- Pato cuchara (shoveler duck)
(20, 31, 600),  -- Victoria amazónica (Amazon water lily)
(20, 19, 30),   -- Delfín rosado (pink dolphin)
(20, 51, 1800), -- Pez dorado (golden fish)
(20, 57, 1500), -- Lirio acuático (water lily)

-- Area 21: Bosque Seco Tropical (Tropical Dry Forest)
(21, 14, 20),   -- Puma (cougar)
(21, 10, 120),  -- Venado cola blanca (white-tailed deer)
(21, 23, 800),  -- Palma de cera (wax palm)
(21, 33, 600),  -- Algarrobo (carob tree)
(21, 40, 400),  -- Samán (saman tree)

-- Area 22: Isla de las Aves (Bird Island)
(22, 15, 60),   -- Loro orejiamarillo (yellow-eared parrot)
(22, 52, 90),   -- Tucán (toucan)
(22, 54, 150),  -- Pato cuchara (shoveler duck)
(22, 22, 3000), -- Orquídea (orchid)
(22, 30, 800),  -- Heliconia (heliconia)

-- Area 23: Páramo de las Papas (Potato Paramo)
(23, 21, 12000),-- Frailejón (frailejon plant)
(23, 3, 30),    -- Cóndor andino (Andean condor)
(23, 16, 280),  -- Colibrí esmeralda (emerald hummingbird)
(23, 24, 1800), -- Roble (oak)
(23, 2, 18),    -- Oso de anteojos (spectacled bear)

-- Area 24: Cañón del Río Patía (Patia River Canyon)
(24, 5, 12),    -- Águila harpía (harpy eagle)
(24, 14, 25),   -- Puma (cougar)
(24, 37, 1200), -- Chaquiro (golden chaquiro tree)
(24, 16, 220),  -- Colibrí esmeralda (emerald hummingbird)
(24, 21, 2500), -- Frailejón (frailejon plant)

-- Area 25: Cueva de los Guácharos (Guacharo Cave)
(25, 53, 600),  -- Guacharos (oilbirds)
(25, 17, 180),  -- Rana de cristal (glass frog)
(25, 28, 900),  -- Bromelias (bromeliads)
(25, 43, 4000), -- Calcita (calcite)
(25, 12, 250),  -- Rana dorada (golden poison frog)

-- Area 26: Cascada La Sirena (Siren Waterfall)
(26, 16, 260),  -- Colibrí esmeralda (emerald hummingbird)
(26, 37, 1600), -- Chaquiro (golden chaquiro tree)
(26, 3, 18),    -- Cóndor andino (Andean condor)
(26, 5, 15),    -- Águila harpía (harpy eagle)
(26, 21, 2800), -- Frailejón (frailejon plant)

-- Area 27: Valle de las Brumas (Misty Valley)
(27, 24, 6000), -- Roble (oak)
(27, 2, 22),    -- Oso de anteojos (spectacled bear)
(27, 11, 55),   -- Tigrillo (oncilla)
(27, 14, 38),   -- Puma (cougar)
(27, 36, 2000), -- Guayacán (guaiacum tree)

-- Area 28: Mirador del Valle (Valley Lookout)
(28, 3, 25),    -- Cóndor andino (Andean condor)
(28, 16, 310),  -- Colibrí esmeralda (emerald hummingbird)
(28, 21, 5500), -- Frailejón (frailejon plant)
(28, 24, 3200), -- Roble (oak)
(28, 10, 90),   -- Venado cola blanca (white-tailed deer)

-- Area 29: Ruta de los Venados (Deer Route)
(29, 10, 200),  -- Venado cola blanca (white-tailed deer)
(29, 14, 30),   -- Puma (cougar)
(29, 1, 8),     -- Jaguar (jaguar)
(29, 26, 400),  -- Caucho (rubber tree)
(29, 33, 700),  -- Algarrobo (carob tree)

-- Area 30: Sendero Ecológico (Ecological Trail)
(30, 6, 120),   -- Mono aullador (howler monkey)
(30, 16, 330),  -- Colibrí esmeralda (emerald hummingbird)
(30, 22, 4000), -- Orquídea (orchid)
(30, 30, 1100), -- Heliconia (heliconia)
(30, 38, 900),  -- Anturio (anthurium)

-- Area 31: Bosque de Guaduas (Guadua Forest)
(31, 29, 5000), -- Guadua (guadua bamboo)
(31, 24, 2800), -- Roble (oak)
(31, 2, 24),    -- Oso de anteojos (spectacled bear)
(31, 6, 110),   -- Mono aullador (howler monkey)
(31, 10, 130),  -- Venado cola blanca (white-tailed deer)

-- Area 32: Lagunas Glaciares (Glacial Lagoons)
(32, 21, 8000), -- Frailejón (frailejon plant)
(32, 3, 28),    -- Cóndor andino (Andean condor)
(32, 16, 290),  -- Colibrí esmeralda (emerald hummingbird)
(32, 54, 160),  -- Pato cuchara (shoveler duck)
(32, 31, 700),  -- Victoria amazónica (Amazon water lily)

-- Area 33: Jardín de Bromelias (Bromeliad Garden)
(33, 28, 10000),-- Bromelias (bromeliads)
(33, 22, 4500), -- Orquídea (orchid)
(33, 30, 1300), -- Heliconia (heliconia)
(33, 38, 1200), -- Anturio (anthurium)
(33, 16, 340),  -- Colibrí esmeralda (emerald hummingbird)

-- Area 34: Desembocadura del Río (River Mouth)
(34, 25, 6000), -- Mangle rojo (red mangrove)
(34, 9, 35),    -- Manatí del Caribe (Caribbean manatee)
(34, 19, 45),   -- Delfín rosado (pink dolphin)
(34, 51, 2200), -- Pez dorado (golden fish)
(34, 57, 1800), -- Lirio acuático (water lily)

-- Area 35: Zona de Petroglifos (Petroglyph Zone)
(35, 10, 140),  -- Venado cola blanca (white-tailed deer)
(35, 27, 180),  -- Ceiba (ceiba tree)
(35, 6, 90),    -- Mono aullador (howler monkey)
(35, 59, 450),  -- Cacao silvestre (wild cacao)
(35, 16, 280),  -- Colibrí esmeralda (emerald hummingbird)

-- Area 36: Sendero de los Monos (Monkey Trail)
(36, 6, 180),   -- Mono aullador (howler monkey)
(36, 18, 50),   -- Perezoso (sloth)
(36, 2, 15),    -- Oso de anteojos (spectacled bear)
(36, 27, 250),  -- Ceiba (ceiba tree)
(36, 39, 2800), -- Yarumos (yarumo tree)

-- Area 37: Cascada El Salto (The Leap Waterfall)
(37, 16, 270),  -- Colibrí esmeralda (emerald hummingbird)
(37, 37, 1700), -- Chaquiro (golden chaquiro tree)
(37, 3, 20),    -- Cóndor andino (Andean condor)
(37, 5, 16),    -- Águila harpía (harpy eagle)
(37, 21, 2900), -- Frailejón (frailejon plant)

-- Area 38: Mirador del Cañón (Canyon Lookout)
(38, 3, 23),    -- Cóndor andino (Andean condor)
(38, 16, 320),  -- Colibrí esmeralda (emerald hummingbird)
(38, 21, 5200), -- Frailejón (frailejon plant)
(38, 24, 3100), -- Roble (oak)
(38, 10, 95),   -- Venado cola blanca (white-tailed deer)

-- Area 39: Bosque de Palmas (Palm Forest)
(39, 23, 4000), -- Palma de cera (wax palm)
(39, 24, 2600), -- Roble (oak)
(39, 2, 26),    -- Oso de anteojos (spectacled bear)
(39, 6, 115),   -- Mono aullador (howler monkey)
(39, 10, 125),  -- Venado cola blanca (white-tailed deer)

-- Area 40: Playa Escondida (Hidden Beach)
(40, 7, 180),   -- Tortuga carey (hawksbill turtle)
(40, 9, 28),    -- Manatí del Caribe (Caribbean manatee)
(40, 19, 38),   -- Delfín rosado (pink dolphin)
(40, 25, 3800), -- Mangle rojo (red mangrove)
(40, 56, 950),  -- Bambú (bamboo)

-- Area 41: Zona de Géiseres (Geyser Zone)
(41, 41, 2000), -- Cuarzo rosa (rose quartz)
(41, 44, 1500), -- Pirita (pyrite)
(41, 28, 500),  -- Bromelias (bromeliads)
(41, 12, 100),  -- Rana dorada (golden poison frog)
(41, 16, 50),   -- Colibrí esmeralda (emerald hummingbird)

-- Area 42: Bosque Petrificado (Petrified Forest)
(42, 50, 1000), -- Ágata (agate)
(42, 41, 800),  -- Cuarzo rosa (rose quartz)
(42, 23, 300),  -- Palma de cera (wax palm)
(42, 10, 50),   -- Venado cola blanca (white-tailed deer)
(42, 11, 10),   -- Tigrillo (oncilla)

-- Area 43: Cuevas de Sal (Salt Caves)
(43, 49, 3000), -- Sal gema (rock salt)
(43, 43, 4500), -- Calcita (calcite)
(43, 53, 400),  -- Guacharos (oilbirds)
(43, 17, 160),  -- Rana de cristal (glass frog)
(43, 28, 800),  -- Bromelias (bromeliads)

-- Area 44: Estero Marino (Marine Estuary)
(44, 25, 5500), -- Mangle rojo (red mangrove)
(44, 9, 32),    -- Manatí del Caribe (Caribbean manatee)
(44, 19, 42),   -- Delfín rosado (pink dolphin)
(44, 51, 2100), -- Pez dorado (golden fish)
(44, 57, 1700), -- Lirio acuático (water lily)

-- Area 45: Zona Árida Protegida (Protected Arid Zone)
(45, 14, 18),   -- Puma (cougar)
(45, 10, 110),  -- Venado cola blanca (white-tailed deer)
(45, 23, 750),  -- Palma de cera (wax palm)
(45, 33, 550),  -- Algarrobo (carob tree)
(45, 40, 350),  -- Samán (saman tree)

-- Area 46: Ciénaga Grande (Great Swamp)
(46, 9, 25),    -- Manatí del Caribe (Caribbean manatee)
(46, 13, 35),   -- Nutria gigante (giant otter)
(46, 25, 8000), -- Mangle rojo (red mangrove)
(46, 54, 250),  -- Pato cuchara (shoveler duck)
(46, 57, 3000), -- Lirio acuático (water lily)

-- Area 47: Sendero de las Mariposas (Butterfly Trail)
(47, 16, 400),  -- Colibrí esmeralda (emerald hummingbird)
(47, 22, 2000), -- Orquídea (orchid)
(47, 30, 1500), -- Heliconia (heliconia)
(47, 38, 1000), -- Anturio (anthurium)
(47, 6, 60),    -- Mono aullador (howler monkey)

-- Area 48: Reserva de Primates (Primate Reserve)
(48, 6, 150),   -- Mono aullador (howler monkey)
(48, 18, 40),   -- Perezoso (sloth)
(48, 2, 10),    -- Oso de anteojos (spectacled bear)
(48, 27, 200),  -- Ceiba (ceiba tree)
(48, 39, 3000), -- Yarumos (yarumo tree)

-- Area 49: Valle de Frailejones (Frailejon Valley)
(49, 21, 15000),-- Frailejón (frailejon plant)
(49, 3, 15),    -- Cóndor andino (Andean condor)
(49, 10, 80),   -- Venado cola blanca (white-tailed deer)
(49, 16, 250),  -- Colibrí esmeralda (emerald hummingbird)
(49, 24, 1000), -- Roble (oak)

-- Area 50: Ruta del Tapir (Tapir Route)
(50, 4, 20),    -- Danta (tapir)
(50, 1, 5),     -- Jaguar (jaguar)
(50, 14, 8),    -- Puma (cougar)
(50, 26, 500),  -- Caucho (rubber tree)
(50, 33, 800),  -- Algarrobo (carob tree)

-- Area 51: Bosque de Robles (Oak Forest)
(51, 24, 9000), -- Roble (oak)
(51, 2, 30),    -- Oso de anteojos (spectacled bear)
(51, 11, 70),   -- Tigrillo (oncilla)
(51, 14, 45),   -- Puma (cougar)
(51, 36, 2500), -- Guayacán (guaiacum tree)

-- Area 52: Laguna Negra (Black Lagoon)
(52, 31, 850),  -- Victoria amazónica (Amazon water lily)
(52, 13, 60),   -- Nutria gigante (giant otter)
(52, 19, 90),   -- Delfín rosado (pink dolphin)
(52, 51, 1300), -- Pez dorado (golden fish)
(52, 54, 170),  -- Pato cuchara (shoveler duck)

-- Area 53: Zona de Reproducción de Aves (Bird Breeding Zone)
(53, 15, 70),   -- Loro orejiamarillo (yellow-eared parrot)
(53, 52, 100),  -- Tucán (toucan)
(53, 54, 180),  -- Pato cuchara (shoveler duck)
(53, 22, 3500), -- Orquídea (orchid)
(53, 30, 900),  -- Heliconia (heliconia)

-- Area 54: Cascada de los Siete Velos (Seven Veils Waterfall)
(54, 16, 280),  -- Colibrí esmeralda (emerald hummingbird)
(54, 37, 1800), -- Chaquiro (golden chaquiro tree)
(54, 3, 21),    -- Cóndor andino (Andean condor)
(54, 5, 17),    -- Águila harpía (harpy eagle)
(54, 21, 3100), -- Frailejón (frailejon plant)

-- Area 55: Valle de los Venados (Deer Valley)
(55, 10, 220),  -- Venado cola blanca (white-tailed deer)
(55, 14, 32),   -- Puma (cougar)
(55, 1, 9),     -- Jaguar (jaguar)
(55, 26, 450),  -- Caucho (rubber tree)
(55, 33, 750),  -- Algarrobo (carob tree)

-- Area 56: Canales de Manglares (Mangrove Channels)
(56, 25, 16000),-- Mangle rojo (red mangrove)
(56, 9, 50),    -- Manatí del Caribe (Caribbean manatee)
(56, 19, 130),  -- Delfín rosado (pink dolphin)
(56, 7, 260),   -- Tortuga carey (hawksbill turtle)
(56, 56, 900),  -- Bambú (bamboo)

-- Area 57: Mirador del Nevado (Snowy Peak Lookout)
(57, 3, 12),    -- Cóndor andino (Andean condor)
(57, 2, 17),    -- Oso de anteojos (spectacled bear)
(57, 21, 5200), -- Frailejón (frailejon plant)
(57, 16, 210),  -- Colibrí esmeralda (emerald hummingbird)
(57, 24, 3100), -- Roble (oak)

-- Area 58: Bosque de Aliso (Alder Forest)
(58, 24, 8800), -- Roble (oak)
(58, 2, 27),    -- Oso de anteojos (spectacled bear)
(58, 11, 60),   -- Tigrillo (oncilla)
(58, 14, 40),   -- Puma (cougar)
(58, 36, 2400), -- Guayacán (guaiacum tree)

-- Area 59: Ruta del Jaguar (Jaguar Route)
(59, 1, 15),    -- Jaguar (jaguar)
(59, 4, 25),    -- Danta (tapir)
(59, 14, 20),   -- Puma (cougar)
(59, 26, 550),  -- Caucho (rubber tree)
(59, 33, 850),  -- Algarrobo (carob tree)

-- Area 60: Laguna de los Patos (Duck Lagoon)
(60, 54, 190),  -- Pato cuchara (shoveler duck)
(60, 31, 650),  -- Victoria amazónica (Amazon water lily)
(60, 19, 32),   -- Delfín rosado (pink dolphin)
(60, 51, 1900), -- Pez dorado (golden fish)
(60, 57, 1600); -- Lirio acuático (water lily)

