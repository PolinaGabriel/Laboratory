-- DROP SCHEMA laboratory;

CREATE SCHEMA laboratory AUTHORIZATION user02;

-- DROP SEQUENCE laboratory.patient_pat_id_seq;

CREATE SEQUENCE laboratory.patient_pat_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- laboratory.insurance_company definition

-- Drop table

-- DROP TABLE laboratory.insurance_company;

CREATE TABLE laboratory.insurance_company (
	ins_comp_id int4 NOT NULL,
	ins_comp_name varchar NOT NULL,
	ins_comp_addr varchar NOT NULL,
	ins_comp_inn varchar NOT NULL,
	ins_comp_rs varchar NOT NULL,
	ins_comp_bik varchar NOT NULL,
	CONSTRAINT insurance_company_pk PRIMARY KEY (ins_comp_id)
);


-- laboratory."order" definition

-- Drop table

-- DROP TABLE laboratory."order";

CREATE TABLE laboratory."order" (
	ord_id int4 NOT NULL,
	ord_date date NOT NULL,
	stat_id int4 NOT NULL,
	CONSTRAINT order_pk PRIMARY KEY (ord_id)
);


-- laboratory.policy_type definition

-- Drop table

-- DROP TABLE laboratory.policy_type;

CREATE TABLE laboratory.policy_type (
	pol_type_id int4 NOT NULL,
	"pol_type-name" varchar NOT NULL,
	CONSTRAINT policy_type_pk PRIMARY KEY (pol_type_id)
);


-- laboratory."role" definition

-- Drop table

-- DROP TABLE laboratory."role";

CREATE TABLE laboratory."role" (
	role_id int4 NOT NULL,
	role_name varchar NOT NULL,
	CONSTRAINT role_pk PRIMARY KEY (role_id)
);


-- laboratory.service definition

-- Drop table

-- DROP TABLE laboratory.service;

CREATE TABLE laboratory.service (
	serv_id int4 NOT NULL,
	serv_name varchar NOT NULL,
	serv_code varchar NOT NULL,
	serv_price money NOT NULL,
	CONSTRAINT service_pk PRIMARY KEY (serv_id)
);


-- laboratory.status definition

-- Drop table

-- DROP TABLE laboratory.status;

CREATE TABLE laboratory.status (
	stat_id int4 NOT NULL,
	stat_name varchar NOT NULL,
	CONSTRAINT status_pk PRIMARY KEY (stat_id)
);


-- laboratory.order_service definition

-- Drop table

-- DROP TABLE laboratory.order_service;

CREATE TABLE laboratory.order_service (
	ord_serv_id int4 NOT NULL,
	serv_id int4 NOT NULL,
	ord_id int4 NOT NULL,
	stat_id int4 NOT NULL,
	CONSTRAINT order_service_pk PRIMARY KEY (ord_serv_id),
	CONSTRAINT order_service_fk FOREIGN KEY (serv_id) REFERENCES laboratory.service(serv_id),
	CONSTRAINT order_service_fk_1 FOREIGN KEY (ord_id) REFERENCES laboratory."order"(ord_id)
);


-- laboratory."user" definition

-- Drop table

-- DROP TABLE laboratory."user";

CREATE TABLE laboratory."user" (
	user_id int4 NOT NULL,
	user_name varchar NOT NULL,
	user_login varchar NOT NULL,
	user_password varchar NOT NULL,
	role_id int4 NOT NULL,
	user_last_dt varchar NOT NULL,
	user_ip varchar NOT NULL,
	CONSTRAINT user_pk PRIMARY KEY (user_id),
	CONSTRAINT user_fk FOREIGN KEY (role_id) REFERENCES laboratory."role"(role_id)
);


-- laboratory.accountant definition

-- Drop table

-- DROP TABLE laboratory.accountant;

CREATE TABLE laboratory.accountant (
	acc_id int4 NOT NULL,
	user_id int4 NOT NULL,
	CONSTRAINT accountant_pk PRIMARY KEY (acc_id),
	CONSTRAINT accountant_fk FOREIGN KEY (user_id) REFERENCES laboratory."user"(user_id)
);


-- laboratory.laboratoryassistant definition

-- Drop table

-- DROP TABLE laboratory.laboratoryassistant;

CREATE TABLE laboratory.laboratoryassistant (
	lab_id int4 NOT NULL,
	user_id int4 NULL,
	CONSTRAINT laboratoryassistant_pk PRIMARY KEY (lab_id),
	CONSTRAINT laboratoryassistant_fk FOREIGN KEY (user_id) REFERENCES laboratory."user"(user_id)
);


-- laboratory.laboratoryassistant_service definition

-- Drop table

-- DROP TABLE laboratory.laboratoryassistant_service;

CREATE TABLE laboratory.laboratoryassistant_service (
	lab_serv_id int4 NOT NULL,
	serv_id int4 NOT NULL,
	lab_id int4 NOT NULL,
	CONSTRAINT laboratoryassistant_service_pk PRIMARY KEY (lab_serv_id),
	CONSTRAINT laboratoryassistant_service_fk FOREIGN KEY (serv_id) REFERENCES laboratory.service(serv_id),
	CONSTRAINT laboratoryassistant_service_fk1 FOREIGN KEY (lab_id) REFERENCES laboratory.laboratoryassistant(lab_id)
);


-- laboratory.patient definition

-- Drop table

-- DROP TABLE laboratory.patient;

CREATE TABLE laboratory.patient (
	pat_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	pat_birth date NULL,
	pat_pass_s int4 NULL,
	pat_pass_n int4 NULL,
	pat_tel_num int4 NULL,
	pat_email varchar NULL,
	user_id int4 NOT NULL,
	CONSTRAINT patient_pk PRIMARY KEY (pat_id),
	CONSTRAINT patient_fk FOREIGN KEY (user_id) REFERENCES laboratory."user"(user_id)
);


-- laboratory."policy" definition

-- Drop table

-- DROP TABLE laboratory."policy";

CREATE TABLE laboratory."policy" (
	pol_id int4 NOT NULL,
	pat_id int4 NOT NULL,
	ins_comp_id int4 NOT NULL,
	pol_num int4 NOT NULL,
	pol_type_id int4 NOT NULL,
	CONSTRAINT policy_pk PRIMARY KEY (pol_id),
	CONSTRAINT policy_fk FOREIGN KEY (pat_id) REFERENCES laboratory.patient(pat_id),
	CONSTRAINT policy_fk_1 FOREIGN KEY (ins_comp_id) REFERENCES laboratory.insurance_company(ins_comp_id),
	CONSTRAINT policy_fk_2 FOREIGN KEY (pol_type_id) REFERENCES laboratory.policy_type(pol_type_id)
);


-- laboratory.completed_services definition

-- Drop table

-- DROP TABLE laboratory.completed_services;

CREATE TABLE laboratory.completed_services (
	comp_serv_id int4 NOT NULL,
	serv_id int4 NOT NULL,
	lab_id int4 NOT NULL,
	pat_id int4 NOT NULL,
	analyzer int4 NULL,
	ord_serv_id int4 NULL,
	CONSTRAINT completed_services_pk PRIMARY KEY (comp_serv_id),
	CONSTRAINT completed_services_fk FOREIGN KEY (serv_id) REFERENCES laboratory.service(serv_id),
	CONSTRAINT completed_services_fk_1 FOREIGN KEY (lab_id) REFERENCES laboratory.laboratoryassistant(lab_id),
	CONSTRAINT completed_services_fk_2 FOREIGN KEY (pat_id) REFERENCES laboratory.patient(pat_id),
	CONSTRAINT completed_services_fk_3 FOREIGN KEY (ord_serv_id) REFERENCES laboratory.order_service(ord_serv_id)
);


-- laboratory.account definition

-- Drop table

-- DROP TABLE laboratory.account;

CREATE TABLE laboratory.account (
	account_id int4 NOT NULL,
	acc_id int4 NOT NULL,
	comp_serv_id int4 NOT NULL,
	ins_comp_id int4 NOT NULL,
	CONSTRAINT account_pk PRIMARY KEY (account_id),
	CONSTRAINT account_fk FOREIGN KEY (acc_id) REFERENCES laboratory.accountant(acc_id),
	CONSTRAINT account_fk_1 FOREIGN KEY (comp_serv_id) REFERENCES laboratory.completed_services(comp_serv_id),
	CONSTRAINT account_fk_2 FOREIGN KEY (ins_comp_id) REFERENCES laboratory.insurance_company(ins_comp_id)
);


INSERT INTO laboratory.service (serv_id,serv_name,serv_code,serv_price) VALUES
	 (1,'TSH','619',$262.71),
	 (2,'Амилаза','311',$361.88),
	 (3,'Альбумин','548',$234.09),
	 (4,'Креатинин','258',$143.22),
	 (5,'Билирубин общий','176',$102.85),
	 (6,'Гепатит В','501',$176.83),
	 (7,'Гепатит С','543',$289.99),
	 (8,'ВИЧ','557',$490.77),
	 (9,'СПИД','229',$341.78),
	 (10,'Кальций общий','415',$419.90);
INSERT INTO laboratory.service (serv_id,serv_name,serv_code,serv_price) VALUES
	 (11,'Глюкоза','323',$447.65),
	 (12,'Ковид IgM','855',$209.78),
	 (13,'Общий белок','346',$396.03),
	 (14,'Железо','836',$105.32),
	 (15,'Сифилис RPR','659',$443.66),
	 (16,'АТ и АГ к ВИЧ 1/2','797',$370.62),
	 (17,'Волчаночный антикоагулянт','287',$290.00);


INSERT INTO laboratory."role" (role_id,role_name) VALUES
	 (1,'user');


INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (1,'Clareta Hacking','chacking0','4tzqHdkqzo4',1,'02.10.2020','147.231.50.234'),
	 (2,'Northrop Mably','nmably1','ukM0e6',1,'20.062020','22.32.15.211'),
	 (3,'Fabian Rolf','frolf2','7QpCwac0yi',1,'19.052020','113.92.142.29'),
	 (4,'Lauree Raden','lraden3','5Ydp2mz',1,'22.062020','39.24.146.52'),
	 (5,'Barby Follos','bfollos4','ckmAJPQV',1,'18.03.2020','87.232.97.3'),
	 (6,'Mile Enterle','menterle5','0PRom6i',1,'07.04.2020','85.121.209.6'),
	 (7,'Midge Peaker','mpeaker6','0Tc5oRc',1,'09.03.2020','196.39.132.128'),
	 (8,'Manon Robichon','mrobichon7','LEwEjMlmE5X',1,'31.08.2020','143.159.207.105'),
	 (9,'Stavro Robken','srobken8','Cbmj3Yi',1,'22.05.2020','12.154.73.196'),
	 (10,'Bryan Tidmas','btidmas9','dYDHbBQfK',1,'06.06.2020','24.42.134.21');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (11,'Jeannette Fussie','jfussiea','EGxXuLQ9',1,'21.08.2020','98.194.112.137'),
	 (12,'Stephen Antonacci','santonaccib','YcXAhY3Pja',1,'10.03.2019','198.146.255.15'),
	 (13,'Niccolo Bountiff','nbountiffc','5xfyjS9ZULGA',1,'22.01.2020','231.78.246.229'),
	 (14,'Clemente Benjefield','cbenjefieldd','tQOsP0ei9TuD',1,'07.09.2020','88.126.93.246'),
	 (15,'Orlan Corbyn','ocorbyne','bG1ZIzwIoU',1,'24.04.2020','232.175.48.179'),
	 (16,'Coreen Stickins','cstickinsf','QRYADbgNj',1,'20.04.2020','64.30.175.158'),
	 (17,'Daveta Clarage','dclarageg','Yp59ZIDnWe',1,'06.09.2020','139.88.229.111'),
	 (18,'Javier McCawley','jmccawleyh','g58zLcmCYON',1,'20.04.2020','14.199.67.32'),
	 (19,'Daile Band','dbandi','yFAaYuVW',1,'12.02.2019','206.105.148.56'),
	 (20,'Angil Buttery','abutteryj','ttOFbWWGtD',1,'21.06.2020','192.158.7.138');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (21,'Kyla Kinman','kkinmank','qUr6fdWP6L5G',1,'11.08.2019','134.99.243.113'),
	 (22,'Selena Skepper','sskepperl','jHYN0v3',1,'28.04.2020','52.90.89.126'),
	 (23,'Alyson Yeoland','ayeolandm','QQezRBV9',1,'31.05.2020','239.7.55.187'),
	 (24,'Claudie Speeding','cspeedingn','UCLYITfw2Vo',1,'15.11.2019','127.37.194.127'),
	 (25,'Alaric Scarisbrick','ascarisbricko','fzBcv6GbyCp',1,'19.02.2020','97.227.15.172'),
	 (26,'Marie Thurby','mthurbyp','wg0uIskqei',1,'18.09.2019','94.70.148.135'),
	 (27,'Cloe Roxbrough','croxbroughq','67CVVym',1,'01.11.2020','185.110.201.36'),
	 (28,'Pegeen McCotter','pmccotterr','QG5tdzRpGZJ2',1,'22.03.2020','22.179.187.229'),
	 (29,'Iggie Calleja','icallejas','aeDvZk8o9',1,'19.07.2020','67.237.123.227'),
	 (30,'Nelle Brosch','nbroscht','DmPJt2',1,'17.12.2019','251.1.59.65');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (31,'Shae Allsepp','sallseppu','t0ko0854Cpvv',1,'08.09.2020','88.20.74.85'),
	 (32,'Eldridge Abbatucci','eabbatucciv','gUtNdsDu',1,'29.03.2020','52.44.134.126'),
	 (33,'Skip Garnham','sgarnhamw','eml6RqbK',1,'29.01.2020','100.17.131.54'),
	 (34,'Ric Kitchenside','rkitchensidex','xaa7miQ7yB',1,'14.12.2019','29.100.76.146'),
	 (35,'Urbanus Di Meo','udiy','dHqu78cU6NOP',1,'25.12.2019','90.30.202.251'),
	 (36,'Monty Beidebeke','mbeidebekez','F5T5spAU9A4O',1,'02.05.2020','3.32.202.92'),
	 (37,'Byrann Savins','bsavins10','l6sYf29NLN',1,'23.01.2020','123.187.14.103'),
	 (38,'Sonnie Riby','sriby11','Va34LYqFh',1,'17.062020','16.81.16.23'),
	 (39,'Sherill Birney','sbirney12','Ggygo2ePsETs',1,'27.12.2019','144.76.193.237'),
	 (40,'Indira Kleanthous','ikleanthous13','3H0GS7a',1,'29.12.2019','169.108.108.88');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (41,'Maison Skerme','mskerme14','wy1HWA',1,'02.10.2020','143.177.136.232'),
	 (42,'Hanan Cahey','hcahey15','NSXcG9khd',1,'13.06.2020','18.127.87.158'),
	 (43,'Tore Rusling','trusling16','abol9dYC8e',1,'19.03.2020','142.216.95.251'),
	 (44,'Jeddy De Souza','jde17','gK6Hsl8Q',1,'17.10.2019','229.104.255.175'),
	 (45,'Flossi McLeoid','fmcleoid18','B9zr0N7cJw',1,'26.01.2020','90.207.38.179'),
	 (46,'Nikoletta Megainey','nmegainey19','gph7QurFf',1,'22.05.2020','172.249.218.50'),
	 (47,'Adan Bliven','abliven1a','vVxlf94KpeX',1,'17.06.2020','49.101.94.118'),
	 (48,'Mohandis Rossoni','mrossoni1b','nLXj2lS',1,'16.11.2019','161.5.132.42'),
	 (49,'Nappie Redington','nredington1c','DCbOb1SX',1,'05.06.2020','174.42.8.3'),
	 (50,'Lenka Francie','lfrancie1d','DoGeHWuAAM',1,'30.03.2020','182.2.128.34');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (51,'Ashley Blowin','ablowin1e','aQygVtMjN',1,'24.06.2020','73.212.243.168'),
	 (52,'Vale Goroni','vgoroni1f','bWr0QU',1,'19.08.2020','93.126.120.134'),
	 (53,'Suki Grafom','sgrafom1g','JcNcVDAouYzA',1,'17.12.2019','9.26.5.107'),
	 (54,'Justis Gianneschi','jgianneschi1h','oieX5u3sUfpD',1,'14.03.2020','139.241.156.87'),
	 (55,'Emilie Collett','ecollett1i','Y0uMyKB0W',1,'10.07.2019','47.0.240.7'),
	 (56,'Byrom Terrell','bterrell1j','hswseW',1,'25.02.2020','157.21.33.53'),
	 (57,'Daphne Bifield','dbifield1k','oYAQ4URihIA',1,'29.07.2020','24.185.229.169'),
	 (58,'Blanca Staig','bstaig1l','MygqEtjMtUbC',1,'19.02.2020','171.78.28.229'),
	 (59,'Adriaens Kennsley','akennsley1m','CTUdBfJsy6qF',1,'15.07.2020','208.81.128.179'),
	 (60,'Emlyn Bartak','ebartak1n','y3t4H1',1,'20.12.2019','130.247.20.138');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (61,'Victoria Willshire','vwillshire1o','VFSLc2t',1,'09.03.2020','243.230.165.161'),
	 (62,'Egon Savin','esavin1p','axnJY9s',1,'31.012020','40.140.160.210'),
	 (63,'Phillie Elsom','pelsom1q','OXzMECG',1,'01.01.2020','253.7.8.82'),
	 (64,'Adan Semaine','asemaine1r','MdJRkHor5SP',1,'10.05.2019','76.252.15.218'),
	 (65,'Constantino Northrop','cnorthrop1s','UIwCvTA7MRS0',1,'10.12.2019','119.130.24.85'),
	 (66,'Rodie Easson','reasson1t','3J0jgg9RWlXs',1,'14.08.2020','212.248.119.232'),
	 (67,'Alida Boleyn','aboleyn1u','3q2mQdDRmtr',1,'26.05.2020','181.14.56.184'),
	 (68,'Hill Scholfield','hscholfield1v','1Pbs3K6qXYB',1,'23.02.2020','15.7.205.224'),
	 (69,'Cordell Cowpe','ccowpe1w','VHr417Ft0',1,'17.06.2020','237.236.173.63'),
	 (70,'Alexandro Eldon','aeldon1x','rrywOQRmFKyh',1,'12.04.2019','4.174.11.210');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (71,'Kayle Collin','kcollin1y','Q0ZV21vew0',1,'30.06.2020','52.19.142.168'),
	 (72,'Inesita Larkins','ilarkins1z','DEFNpHtU',1,'12.05.2019','3.26.42.188'),
	 (73,'Waylin Lound','wlound20','a2G4Ihh2o',1,'26.01.2020','31.243.68.215'),
	 (74,'Mechelle Gillogley','mgillogley21','EjUHfCUFqF',1,'05.01.2020','79.38.53.53'),
	 (75,'Donal Muccino','dmuccino22','E4okVgx',1,'04.02.2020','109.138.101.234'),
	 (76,'Joye Leadbetter','jleadbetter23','ZNsaKdgb',1,'05.02.2020','51.245.190.167'),
	 (77,'Gianina Trump','gtrump24','6XXY7IS26Ci',1,'08.03.2020','11.191.37.17'),
	 (78,'Read LeEstut','rleestut25','zq3C4rUR',1,'09.11.2020','119.247.100.162'),
	 (79,'Jill Anscott','janscott26','5maCRrCZLu',1,'28.04.2020','104.85.178.46'),
	 (80,'Bud Douch','bdouch27','KAkwrli',1,'02.06.2020','72.132.101.188');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (81,'Cicily Ossenna','cossenna28','vfKJkCeohOzZ',1,'01.06.2020','230.85.180.186'),
	 (82,'Hew Izzat','hizzat29','Uifdtu',1,'20.01.2020','143.246.125.169'),
	 (83,'Eddie Gimeno','egimeno2a','oF1hbmKlZ',1,'18.03.2020','60.57.115.125'),
	 (84,'Sybyl Fierro','sfierro2b','VjUrQ2',1,'22.01.2020','250.233.247.215'),
	 (85,'Nicol Troup','ntroup2c','KmDDYf1Pu',1,'25.06.2020','121.7.142.165'),
	 (86,'Bondy Pattenden','bpattenden2d','IOUkHpOn',1,'15.06.2020','45.121.26.90'),
	 (87,'Angus Cockman','acockman2e','fDKhK7OK',1,'01.06.2020','167.9.255.77'),
	 (88,'Mord Hanscome','mhanscome2f','xBHzpa7eP0u',1,'07.10.2020','121.181.10.230'),
	 (89,'Susy Leblanc','sleblanc2g','T2et1U5M',1,'16.06.2020','118.164.120.202'),
	 (90,'Gerard Ciccoloi','gciccoloi2h','w4dZ3hxiCiAg',1,'02.03.2020','71.235.27.27');
INSERT INTO laboratory."user" (user_id,user_name,user_login,user_password,role_id,user_last_dt,user_ip) VALUES
	 (91,'Seamus Sayburn','ssayburn2i','1hTM7EVKaS',1,'24.012020','75.194.92.114'),
	 (92,'Washington Gentiry','wgentiry2j','z2X9UH5',1,'04.10.2020','188.49.78.185'),
	 (93,'Rebekkah Westall','rwestall2k','xLgunbO9x6',1,'02.02.2020','212.150.81.93'),
	 (94,'Court Kulic','ckulic2l','FLHYRN',1,'26.06.2020','154.121.193.131'),
	 (95,'Lorilee Roux','lroux2m','98cCxHeeK31',1,'06.12.2020','229.187.60.106'),
	 (96,'Modestine Rolinson','mrolinson2n','faGzyW8hEca',1,'30.10.2019','9.203.185.188'),
	 (97,'Shelbi Ellgood','sellgood2o','3do5MME',1,'31.08.2020','199.226.26.7'),
	 (98,'Barbabra Retchless','bretchless2p','WraGihh',1,'11.09.2019','86.66.23.203'),
	 (99,'Robinetta Jerzak','rjerzak2q','hAp8jki',1,'12.11.2019','205.158.144.210'),
	 (100,'Vance Boots','vboots2r','bgJfSDEVEQm6',1,'09.07.2020','91.73.40.29');


INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',1),
	 (NULL,NULL,NULL,NULL,'',2),
	 (NULL,NULL,NULL,NULL,'',3),
	 (NULL,NULL,NULL,NULL,'',4),
	 (NULL,NULL,NULL,NULL,'',5),
	 (NULL,NULL,NULL,NULL,'',6),
	 (NULL,NULL,NULL,NULL,'',7),
	 (NULL,NULL,NULL,NULL,'',8),
	 (NULL,NULL,NULL,NULL,'',9),
	 (NULL,NULL,NULL,NULL,'',10);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',11),
	 (NULL,NULL,NULL,NULL,'',12),
	 (NULL,NULL,NULL,NULL,'',13),
	 (NULL,NULL,NULL,NULL,'',14),
	 (NULL,NULL,NULL,NULL,'',15),
	 (NULL,NULL,NULL,NULL,'',16),
	 (NULL,NULL,NULL,NULL,'',17),
	 (NULL,NULL,NULL,NULL,'',18),
	 (NULL,NULL,NULL,NULL,'',19),
	 (NULL,NULL,NULL,NULL,'',20);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',21),
	 (NULL,NULL,NULL,NULL,'',22),
	 (NULL,NULL,NULL,NULL,'',23),
	 (NULL,NULL,NULL,NULL,'',24),
	 (NULL,NULL,NULL,NULL,'',25),
	 (NULL,NULL,NULL,NULL,'',26),
	 (NULL,NULL,NULL,NULL,'',27),
	 (NULL,NULL,NULL,NULL,'',28),
	 (NULL,NULL,NULL,NULL,'',29),
	 (NULL,NULL,NULL,NULL,'',30);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',31),
	 (NULL,NULL,NULL,NULL,'',32),
	 (NULL,NULL,NULL,NULL,'',33),
	 (NULL,NULL,NULL,NULL,'',34),
	 (NULL,NULL,NULL,NULL,'',35),
	 (NULL,NULL,NULL,NULL,'',36),
	 (NULL,NULL,NULL,NULL,'',37),
	 (NULL,NULL,NULL,NULL,'',38),
	 (NULL,NULL,NULL,NULL,'',39),
	 (NULL,NULL,NULL,NULL,'',40);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',41),
	 (NULL,NULL,NULL,NULL,'',42),
	 (NULL,NULL,NULL,NULL,'',43),
	 (NULL,NULL,NULL,NULL,'',44),
	 (NULL,NULL,NULL,NULL,'',45),
	 (NULL,NULL,NULL,NULL,'',46),
	 (NULL,NULL,NULL,NULL,'',47),
	 (NULL,NULL,NULL,NULL,'',48),
	 (NULL,NULL,NULL,NULL,'',49),
	 (NULL,NULL,NULL,NULL,'',50);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',51),
	 (NULL,NULL,NULL,NULL,'',52),
	 (NULL,NULL,NULL,NULL,'',53),
	 (NULL,NULL,NULL,NULL,'',54),
	 (NULL,NULL,NULL,NULL,'',55),
	 (NULL,NULL,NULL,NULL,'',56),
	 (NULL,NULL,NULL,NULL,'',57),
	 (NULL,NULL,NULL,NULL,'',58),
	 (NULL,NULL,NULL,NULL,'',59),
	 (NULL,NULL,NULL,NULL,'',60);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',61),
	 (NULL,NULL,NULL,NULL,'',62),
	 (NULL,NULL,NULL,NULL,'',63),
	 (NULL,NULL,NULL,NULL,'',64),
	 (NULL,NULL,NULL,NULL,'',65),
	 (NULL,NULL,NULL,NULL,'',66),
	 (NULL,NULL,NULL,NULL,'',67),
	 (NULL,NULL,NULL,NULL,'',68),
	 (NULL,NULL,NULL,NULL,'',69),
	 (NULL,NULL,NULL,NULL,'',70);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',71),
	 (NULL,NULL,NULL,NULL,'',72),
	 (NULL,NULL,NULL,NULL,'',73),
	 (NULL,NULL,NULL,NULL,'',74),
	 (NULL,NULL,NULL,NULL,'',75),
	 (NULL,NULL,NULL,NULL,'',76),
	 (NULL,NULL,NULL,NULL,'',77),
	 (NULL,NULL,NULL,NULL,'',78),
	 (NULL,NULL,NULL,NULL,'',79),
	 (NULL,NULL,NULL,NULL,'',80);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',81),
	 (NULL,NULL,NULL,NULL,'',82),
	 (NULL,NULL,NULL,NULL,'',83),
	 (NULL,NULL,NULL,NULL,'',84),
	 (NULL,NULL,NULL,NULL,'',85),
	 (NULL,NULL,NULL,NULL,'',86),
	 (NULL,NULL,NULL,NULL,'',87),
	 (NULL,NULL,NULL,NULL,'',88),
	 (NULL,NULL,NULL,NULL,'',89),
	 (NULL,NULL,NULL,NULL,'',90);
INSERT INTO laboratory.patient (pat_birth,pat_pass_s,pat_pass_n,pat_tel_num,pat_email,user_id) VALUES
	 (NULL,NULL,NULL,NULL,'',91),
	 (NULL,NULL,NULL,NULL,'',92),
	 (NULL,NULL,NULL,NULL,'',93),
	 (NULL,NULL,NULL,NULL,'',94),
	 (NULL,NULL,NULL,NULL,'',95),
	 (NULL,NULL,NULL,NULL,'',96),
	 (NULL,NULL,NULL,NULL,'',97),
	 (NULL,NULL,NULL,NULL,'',98),
	 (NULL,NULL,NULL,NULL,'',99),
	 (NULL,NULL,NULL,NULL,'',100);


INSERT INTO laboratory.laboratoryassistant (lab_id,user_id) VALUES
	 (1,NULL),
	 (2,NULL),
	 (3,NULL);


INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (1,8,1,1,NULL,NULL),
	 (2,14,1,1,NULL,NULL),
	 (3,17,1,1,NULL,NULL),
	 (4,12,2,2,NULL,NULL),
	 (5,1,2,2,NULL,NULL),
	 (6,8,2,2,NULL,NULL),
	 (7,14,2,2,NULL,NULL),
	 (8,3,2,2,NULL,NULL),
	 (9,7,1,3,NULL,NULL),
	 (10,14,1,3,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (11,12,1,4,NULL,NULL),
	 (12,4,1,4,NULL,NULL),
	 (13,7,1,5,NULL,NULL),
	 (14,10,1,5,NULL,NULL),
	 (15,1,1,5,NULL,NULL),
	 (16,8,1,5,NULL,NULL),
	 (17,8,2,6,NULL,NULL),
	 (18,14,2,6,NULL,NULL),
	 (19,9,2,6,NULL,NULL),
	 (20,17,2,7,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (21,1,2,7,NULL,NULL),
	 (22,3,2,7,NULL,NULL),
	 (23,13,2,7,NULL,NULL),
	 (24,10,2,8,NULL,NULL),
	 (25,2,2,8,NULL,NULL),
	 (26,5,2,8,NULL,NULL),
	 (27,12,2,8,NULL,NULL),
	 (28,11,3,9,NULL,NULL),
	 (29,3,3,9,NULL,NULL),
	 (30,13,3,9,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (31,9,3,10,NULL,NULL),
	 (32,13,3,10,NULL,NULL),
	 (33,6,3,10,NULL,NULL),
	 (34,3,3,10,NULL,NULL),
	 (35,17,2,11,NULL,NULL),
	 (36,1,2,12,NULL,NULL),
	 (37,4,2,12,NULL,NULL),
	 (38,9,2,12,NULL,NULL),
	 (39,8,2,12,NULL,NULL),
	 (40,16,2,12,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (41,11,1,13,NULL,NULL),
	 (42,2,1,13,NULL,NULL),
	 (43,8,1,13,NULL,NULL),
	 (44,12,3,14,NULL,NULL),
	 (45,5,3,14,NULL,NULL),
	 (46,5,3,14,NULL,NULL),
	 (47,12,3,14,NULL,NULL),
	 (48,9,3,15,NULL,NULL),
	 (49,14,3,15,NULL,NULL),
	 (50,17,3,15,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (51,1,3,15,NULL,NULL),
	 (52,8,1,16,NULL,NULL),
	 (53,13,3,17,NULL,NULL),
	 (54,14,3,17,NULL,NULL),
	 (55,13,3,17,NULL,NULL),
	 (56,1,3,18,NULL,NULL),
	 (57,4,3,18,NULL,NULL),
	 (58,5,3,19,NULL,NULL),
	 (59,7,3,19,NULL,NULL),
	 (60,12,3,19,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (61,4,3,19,NULL,NULL),
	 (62,11,2,20,NULL,NULL),
	 (63,12,2,20,NULL,NULL),
	 (64,15,2,20,NULL,NULL),
	 (65,17,2,20,NULL,NULL),
	 (66,13,1,21,NULL,NULL),
	 (67,12,1,21,NULL,NULL),
	 (68,11,1,21,NULL,NULL),
	 (69,8,1,21,NULL,NULL),
	 (70,6,1,21,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (71,12,3,22,NULL,NULL),
	 (72,17,3,22,NULL,NULL),
	 (73,14,3,23,NULL,NULL),
	 (74,14,3,23,NULL,NULL),
	 (75,9,3,23,NULL,NULL),
	 (76,4,3,23,NULL,NULL),
	 (77,14,3,23,NULL,NULL),
	 (78,3,2,24,NULL,NULL),
	 (79,8,2,24,NULL,NULL),
	 (80,5,2,24,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (81,7,3,25,NULL,NULL),
	 (82,14,3,25,NULL,NULL),
	 (83,3,1,26,NULL,NULL),
	 (84,12,1,26,NULL,NULL),
	 (85,6,2,27,NULL,NULL),
	 (86,16,2,27,NULL,NULL),
	 (87,16,2,27,NULL,NULL),
	 (88,5,3,28,NULL,NULL),
	 (89,12,3,28,NULL,NULL),
	 (90,14,2,29,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (91,5,2,29,NULL,NULL),
	 (92,1,2,29,NULL,NULL),
	 (93,4,2,29,NULL,NULL),
	 (94,13,3,30,NULL,NULL),
	 (95,3,2,31,NULL,NULL),
	 (96,9,2,31,NULL,NULL),
	 (97,4,2,31,NULL,NULL),
	 (98,1,2,31,NULL,NULL),
	 (99,14,2,32,NULL,NULL),
	 (100,14,2,32,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (101,16,2,32,NULL,NULL),
	 (102,3,2,33,NULL,NULL),
	 (103,6,2,34,NULL,NULL),
	 (104,4,2,34,NULL,NULL),
	 (105,15,2,34,NULL,NULL),
	 (106,6,2,34,NULL,NULL),
	 (107,15,2,34,NULL,NULL),
	 (108,16,2,35,NULL,NULL),
	 (109,17,2,35,NULL,NULL),
	 (110,12,2,35,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (111,13,2,35,NULL,NULL),
	 (112,10,2,36,NULL,NULL),
	 (113,7,2,36,NULL,NULL),
	 (114,14,2,36,NULL,NULL),
	 (115,14,2,37,NULL,NULL),
	 (116,6,1,38,NULL,NULL),
	 (117,14,2,39,NULL,NULL),
	 (118,4,2,39,NULL,NULL),
	 (119,1,2,39,NULL,NULL),
	 (120,16,2,40,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (121,13,2,40,NULL,NULL),
	 (122,7,2,40,NULL,NULL),
	 (123,6,2,40,NULL,NULL),
	 (124,4,2,40,NULL,NULL),
	 (125,5,2,41,NULL,NULL),
	 (126,1,2,41,NULL,NULL),
	 (127,6,3,42,NULL,NULL),
	 (128,4,3,42,NULL,NULL),
	 (129,1,2,43,NULL,NULL),
	 (130,10,2,44,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (131,1,2,44,NULL,NULL),
	 (132,7,2,45,NULL,NULL),
	 (133,10,2,46,NULL,NULL),
	 (134,11,3,47,NULL,NULL),
	 (135,3,3,47,NULL,NULL),
	 (136,5,3,48,NULL,NULL),
	 (137,15,3,48,NULL,NULL),
	 (138,17,3,48,NULL,NULL),
	 (139,3,2,49,NULL,NULL),
	 (140,15,2,50,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (141,6,2,50,NULL,NULL),
	 (142,10,2,50,NULL,NULL),
	 (143,5,2,51,NULL,NULL),
	 (144,2,2,51,NULL,NULL),
	 (145,12,2,51,NULL,NULL),
	 (146,5,2,51,NULL,NULL),
	 (147,17,3,52,NULL,NULL),
	 (148,17,3,52,NULL,NULL),
	 (149,15,3,52,NULL,NULL),
	 (150,16,3,53,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (151,11,3,53,NULL,NULL),
	 (152,3,3,53,NULL,NULL),
	 (153,14,3,54,NULL,NULL),
	 (154,7,3,54,NULL,NULL),
	 (155,3,3,54,NULL,NULL),
	 (156,2,3,54,NULL,NULL),
	 (157,7,2,55,NULL,NULL),
	 (158,17,2,55,NULL,NULL),
	 (159,4,2,55,NULL,NULL),
	 (160,17,1,56,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (161,8,1,56,NULL,NULL),
	 (162,7,1,56,NULL,NULL),
	 (163,1,1,57,NULL,NULL),
	 (164,11,1,57,NULL,NULL),
	 (165,12,1,57,NULL,NULL),
	 (166,9,1,57,NULL,NULL),
	 (167,5,3,58,NULL,NULL),
	 (168,12,3,58,NULL,NULL),
	 (169,14,3,59,NULL,NULL),
	 (170,3,3,59,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (171,7,1,60,NULL,NULL),
	 (172,8,1,61,NULL,NULL),
	 (173,17,1,61,NULL,NULL),
	 (174,14,1,61,NULL,NULL),
	 (175,17,1,61,NULL,NULL),
	 (176,13,2,62,NULL,NULL),
	 (177,4,2,62,NULL,NULL),
	 (178,7,2,62,NULL,NULL),
	 (179,11,2,62,NULL,NULL),
	 (180,5,2,62,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (181,11,2,63,NULL,NULL),
	 (182,6,2,63,NULL,NULL),
	 (183,6,2,63,NULL,NULL),
	 (184,4,2,64,NULL,NULL),
	 (185,5,1,65,NULL,NULL),
	 (186,9,1,65,NULL,NULL),
	 (187,12,2,66,NULL,NULL),
	 (188,17,2,66,NULL,NULL),
	 (189,16,2,66,NULL,NULL),
	 (190,9,3,67,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (191,11,3,67,NULL,NULL),
	 (192,6,3,67,NULL,NULL),
	 (193,4,3,67,NULL,NULL),
	 (194,10,3,67,NULL,NULL),
	 (195,1,2,68,NULL,NULL),
	 (196,4,2,68,NULL,NULL),
	 (197,6,2,68,NULL,NULL),
	 (198,17,2,68,NULL,NULL),
	 (199,13,3,69,NULL,NULL),
	 (200,2,3,69,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (201,13,3,69,NULL,NULL),
	 (202,5,3,69,NULL,NULL),
	 (203,14,1,70,NULL,NULL),
	 (204,13,1,70,NULL,NULL),
	 (205,14,1,70,NULL,NULL),
	 (206,13,1,71,NULL,NULL),
	 (207,3,1,72,NULL,NULL),
	 (208,4,1,72,NULL,NULL),
	 (209,2,1,72,NULL,NULL),
	 (210,9,1,72,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (211,1,1,73,NULL,NULL),
	 (212,15,1,73,NULL,NULL),
	 (213,13,1,73,NULL,NULL),
	 (214,13,2,74,NULL,NULL),
	 (215,5,2,74,NULL,NULL),
	 (216,5,2,74,NULL,NULL),
	 (217,10,2,74,NULL,NULL),
	 (218,10,2,74,NULL,NULL),
	 (219,5,3,75,NULL,NULL),
	 (220,1,3,75,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (221,17,3,75,NULL,NULL),
	 (222,2,3,75,NULL,NULL),
	 (223,1,3,75,NULL,NULL),
	 (224,3,2,76,NULL,NULL),
	 (225,7,2,76,NULL,NULL),
	 (226,3,2,76,NULL,NULL),
	 (227,12,2,76,NULL,NULL),
	 (228,4,3,77,NULL,NULL),
	 (229,11,1,78,NULL,NULL),
	 (230,17,1,78,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (231,15,1,78,NULL,NULL),
	 (232,5,1,78,NULL,NULL),
	 (233,17,3,79,NULL,NULL),
	 (234,17,1,80,NULL,NULL),
	 (235,6,3,81,NULL,NULL),
	 (236,5,3,81,NULL,NULL),
	 (237,5,3,81,NULL,NULL),
	 (238,17,1,82,NULL,NULL),
	 (239,6,1,82,NULL,NULL),
	 (240,17,1,82,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (241,2,1,82,NULL,NULL),
	 (242,15,3,83,NULL,NULL),
	 (243,7,3,83,NULL,NULL),
	 (244,6,3,83,NULL,NULL),
	 (245,15,3,83,NULL,NULL),
	 (246,3,3,83,NULL,NULL),
	 (247,10,2,84,NULL,NULL),
	 (248,11,2,84,NULL,NULL),
	 (249,13,2,84,NULL,NULL),
	 (250,2,2,84,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (251,10,2,85,NULL,NULL),
	 (252,5,2,85,NULL,NULL),
	 (253,14,2,85,NULL,NULL),
	 (254,17,2,85,NULL,NULL),
	 (255,14,1,86,NULL,NULL),
	 (256,9,1,86,NULL,NULL),
	 (257,13,1,86,NULL,NULL),
	 (258,13,1,86,NULL,NULL),
	 (259,11,1,87,NULL,NULL),
	 (260,9,1,87,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (261,4,1,87,NULL,NULL),
	 (262,4,1,87,NULL,NULL),
	 (263,10,1,87,NULL,NULL),
	 (264,13,2,88,NULL,NULL),
	 (265,3,2,88,NULL,NULL),
	 (266,3,2,88,NULL,NULL),
	 (267,12,2,89,NULL,NULL),
	 (268,1,2,89,NULL,NULL),
	 (269,3,1,90,NULL,NULL),
	 (270,2,1,90,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (271,13,1,90,NULL,NULL),
	 (272,2,1,90,NULL,NULL),
	 (273,8,2,91,NULL,NULL),
	 (274,3,2,91,NULL,NULL),
	 (275,8,2,91,NULL,NULL),
	 (276,11,2,91,NULL,NULL),
	 (277,8,2,91,NULL,NULL),
	 (278,11,1,92,NULL,NULL),
	 (279,12,1,92,NULL,NULL),
	 (280,9,1,92,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (281,6,2,93,NULL,NULL),
	 (282,6,2,93,NULL,NULL),
	 (283,12,2,93,NULL,NULL),
	 (284,16,2,93,NULL,NULL),
	 (285,6,2,93,NULL,NULL),
	 (286,11,1,94,NULL,NULL),
	 (287,10,3,95,NULL,NULL),
	 (288,7,3,95,NULL,NULL),
	 (289,2,1,96,NULL,NULL),
	 (290,12,1,96,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (291,16,1,96,NULL,NULL),
	 (292,12,1,96,NULL,NULL),
	 (293,5,3,97,NULL,NULL),
	 (294,14,3,97,NULL,NULL),
	 (295,13,3,97,NULL,NULL),
	 (296,6,3,97,NULL,NULL),
	 (297,5,3,97,NULL,NULL),
	 (298,9,2,98,NULL,NULL),
	 (299,10,2,98,NULL,NULL),
	 (300,4,2,98,NULL,NULL);
INSERT INTO laboratory.completed_services (comp_serv_id,serv_id,lab_id,pat_id,analyzer,ord_serv_id) VALUES
	 (301,1,2,98,NULL,NULL),
	 (302,15,2,99,NULL,NULL),
	 (303,3,2,100,NULL,NULL),
	 (304,13,2,100,NULL,NULL),
	 (305,2,2,100,NULL,NULL);
