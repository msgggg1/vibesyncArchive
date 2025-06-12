-- 1. category 테이블 데이터 삽입
INSERT INTO category (category_idx, c_name, img) VALUES (1, '영화', '/sources/button_bg/movie.jpg');
INSERT INTO category (category_idx, c_name, img) VALUES (2, '드라마', '/sources/button_bg/drama.jpg');
INSERT INTO category (category_idx, c_name, img) VALUES (3, '음악', '/sources/button_bg/music.jpg');
INSERT INTO category (category_idx, c_name, img) VALUES (4, '애니메이션', '/sources/button_bg/anime.jpg');
INSERT INTO category (category_idx, c_name, img) VALUES (5, '일상', '/sources/button_bg/daily.jpg');


-- 2. genre 테이블 데이터 삽입 (사용자 제공 데이터 기준으로 수정)
INSERT INTO genre (genre_idx, gen_name) VALUES (1, '액션');
INSERT INTO genre (genre_idx, gen_name) VALUES (2, '로맨스');
INSERT INTO genre (genre_idx, gen_name) VALUES (3, '코미디');
INSERT INTO genre (genre_idx, gen_name) VALUES (4, '스릴러');
INSERT INTO genre (genre_idx, gen_name) VALUES (5, 'K-POP');
INSERT INTO genre (genre_idx, gen_name) VALUES (6, '발라드');
INSERT INTO genre (genre_idx, gen_name) VALUES (7, '판타지');
INSERT INTO genre (genre_idx, gen_name) VALUES (8, '일상');
INSERT INTO genre (genre_idx, gen_name) VALUES (9, 'SF');
INSERT INTO genre (genre_idx, gen_name) VALUES (10, '힙합');
INSERT INTO genre (genre_idx, gen_name) VALUES (11, '전쟁');

-- 3. userAccount 테이블 데이터 삽입 (ac_idx: 1 ~ 25)
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (1,'teen_hero@example.com','d40c714f98d1972faa30b68084fb7ed477422b4f983b4ef6aba2d13849a24c08','날쎈돌이16','profile001.jpg','김철수',to_timestamp('24/01/15 10:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'/NeVrALedLbRoz5R7KW3GQ==',1);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (2,'movie_lover@example.com','d64bb596a4ad5d4fb324d3e877ba2392ba7b5ecccbf3dd3cc1146939d5cd162b','영화광팬','profile002.jpg','이영희',to_timestamp('24/01/20 11:30:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'CV/Ralxff+th0mDzJrPHDg==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (3,'music_holic@example.com','51347b11baaa66e167dfde4d6092ecb24a6d9244595da78b1fdae7ab8738e6c8','음악없인못살아','profile003.jpg','박민준',to_timestamp('24/02/01 14:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'peo8jL14gUgAGks4f8YOQg==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (4,'webtoon_master@example.com','fe87f870c5f85c162741a81d0a7dd2d25def1654b3e94f347b1dc3dc1c664843','웹툰장인17','profile004.jpg','최유리',to_timestamp('24/02/10 16:45:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'JZMcZo31L6YA2uAJXlXW8g==',4);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (5,'drama_addict@example.com','d0609d8d674e0629e1124d41d227f3c9f464e35f135c3bb9f464c17f7c5fad5e','드라마덕후','profile005.jpg','정수민',to_timestamp('24/02/15 09:30:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'1Vrr9NbOvyZ2xEkacbgEYg==',5);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (6,'sf_fanatic@example.com','f01a60f82163530f9186f9133ac63e90fd57d2e44b590151b6da92b0cb0d69c5','SF매니아','profile006.jpg','강지훈',to_timestamp('24/03/01 13:10:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'AQybt5Ys0V7uVf5V5YFCnQ==',1);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (7,'hiphop_teen@example.com','26560f2e2b98ee02b1668409596df4f80da99a446a4c9c2a5238ce200d190814','힙합꿈나무18','profile007.jpg','윤서아',to_timestamp('24/03/05 17:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'kAd+197xLcGWLd0NInGrFA==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (8,'action_junkie@example.com','835e9c5526bb34c9aa31b3ec863380f091273bf603d72e3100394d591d7a9818','액션중독자','profile008.jpg','임도현',to_timestamp('24/03/10 10:20:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'TRuOtJV/ofg5bgqZmR6/0g==',5);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (9,'romance_dreamer@example.com','e4e925faaae0ab22c2b16459dd104813e7e9495f348cbbd3f0b428b511e105e6','로맨스빌런','profile009.jpg','황보라',to_timestamp('24/03/15 12:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'TtTqgCPL+9id6eDc9xxOvA==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (10,'kpop_stan@example.com','a352d43b583d78f51cff9fc1fab17b97b30761a9014959b4c14efab56cf21c32','K팝지킴이','profile010.jpg','서예준',to_timestamp('24/03/20 15:50:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'JWS93+Xnl++IpZV/MhJ7wg==',4);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (11,'user11_teen@example.com','0ef6e57d2c7dcd752e0bb0e3427276cee1ee17fe6208127e2d59767781d832b4','새싹개발자15','profile011.jpg','박현우',to_timestamp('24/04/01 09:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'1AHNmf26nF2PvX21IziVQQ==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (12,'user12@example.com','769bc8b5fcf9cfc42b7ac5e587582ebdd022765b8741380098e46785c5b0ceb6','고독한미식가','profile012.jpg','이지은',to_timestamp('24/04/02 10:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'aUgINdE9KAuKIKXm+4eg4A==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (13,'user13_teen@example.com','a82e6c18ce4b41a48e1e3d3c8471332167363def5f2abdfbd03c4338861523d7','게임스트리머19','profile013.jpg','최민식',to_timestamp('24/04/03 11:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'G/n5p1hkBpEmpyxE9tuWiQ==',1);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (14,'user14@example.com','2b066b103ae740e3ce1bddf27401809d5ff102a5fbe087654850804acef4636e','여행가고싶다','profile014.jpg','한지민',to_timestamp('24/04/04 12:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'KhH9pdxZypve9cW2e98ouw==',5);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (15,'user15_teen@example.com','6ad529d6c01ef874177512bc0f961d773ebd0185660f24edf7af7cee214d1583','댄스신동14','profile015.jpg','김민서',to_timestamp('24/04/05 13:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'uJyrHJCnC4paStPAQyKJnA==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (16,'user16@example.com','81381020e335af528c226ba7494126e5d7b7ac845f5dbc2e2579e3e6c56bc6e7','냥집사그램','profile016.jpg','송강호',to_timestamp('24/04/06 14:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'qbf4l9IzDpBg6xupvJYe5A==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (17,'user17_teen@example.com','1e12af2cf391d2fc8c9431109dd7df0b26fb4c64381bb232c666bc9d5d5ca094','코딩천재17','profile017.jpg','배수지',to_timestamp('24/04/07 15:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'2l+LAB1Nw2x8alPRBg+zCw==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (18,'user18@example.com','cd08710f8e12f418396049019112876bfccebeb16a18aace6dd53502f691de5f','패피의일상','profile018.jpg','유해진',to_timestamp('24/04/08 16:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'U5RcmjqGejMbtU7tLeu6VA==',5);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (19,'user19_teen@example.com','1c61e0983875ea89975ffce5b01fdb8f4538f5c1c5785c0fa3c356bb28df4f28','인싸의삶16','profile019.jpg','전지현',to_timestamp('24/04/09 17:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'rp6eiTLOgp99KxqUEUkawg==',4);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (20,'user20@example.com','bc83159ba180647e862187b2c86c5e7ec89121c2d06d21e1aba2a4a228596f4b','독서왕김독서','profile020.jpg','이병헌',to_timestamp('24/04/10 18:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'yH571Hz7qV9IaSMKeCPl5w==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (21,'user21_teen@example.com','3f97b2dc1913a802971328ca3dffb98a98e7254cccadf858be1b913f4a226dac','뷰티유튜버18','profile021.jpg','김고은',to_timestamp('24/04/11 10:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'eJxInYbjMlTPSwpRJngGKA==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (22,'user22@example.com','f8c40a3bcd79999ca310bd6629d6fd5ce69e77def6d7498b3194f67e7c852d69','요리하는남자','profile022.jpg','박보검',to_timestamp('24/04/12 11:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'EZEDy+1tN6G3gND+h2j4lg==',2);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (23,'user23_teen@example.com','e1018e0b1f911e44638fa546eba6f021c07400248dddc65ef4deaaefcfc83c95','축구광팬15','profile023.jpg','손예진',to_timestamp('24/04/13 12:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'fRA2pF2VPregrOoHR4GnsQ==',3);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (24,'user24@example.com','87f1788cbb5192b41eedcadd0a3175b57d5722f1a7abd8a739c097fb552a3a03','자전거라이더','profile024.jpg','정우성',to_timestamp('24/04/14 13:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'mteqR3kyVQz6ZBGciKCQ5w==',1);
Insert into USERACCOUNT (AC_IDX,EMAIL,PW,NICKNAME,IMG,NAME,CREATED_AT,SALT,category_idx) values (25,'user25@example.com','07a8e6a49548883dae484de48633d130116fbea3ae93915b05ecc1b2921d4d8b','프로캠핑러','profile025.jpg','김혜수',to_timestamp('24/04/15 14:00:00.000000000','RR/MM/DD HH24:MI:SSXFF'),'EVJbvbEROivmjSvbW+exDg==',1);

-- 해시 전
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (1, 'teen_hero@example.com', 'Pw123!!!', '날쎈돌이16', 'profile001.jpg', '김철수', TO_TIMESTAMP('2024-01-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS')); --Pw123!!!
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (2, 'movie_lover@example.com', 'Pw456!!!', '영화광팬', 'profile002.jpg', '이영희', TO_TIMESTAMP('2024-01-20 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (3, 'music_holic@example.com', 'Pw789!!!', '음악없인못살아', 'profile003.jpg', '박민준', TO_TIMESTAMP('2024-02-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (4, 'webtoon_master@example.com', 'Pw101!!!', '웹툰장인17', 'profile004.jpg', '최유리', TO_TIMESTAMP('2024-02-10 16:45:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (5, 'drama_addict@example.com', 'Pw112!!!', '드라마덕후', 'profile005.jpg', '정수민', TO_TIMESTAMP('2024-02-15 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (6, 'sf_fanatic@example.com', 'Pw131!!!', 'SF매니아', 'profile006.jpg', '강지훈', TO_TIMESTAMP('2024-03-01 13:10:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (7, 'hiphop_teen@example.com', 'Pw415!!!', '힙합꿈나무18', 'profile007.jpg', '윤서아', TO_TIMESTAMP('2024-03-05 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (8, 'action_junkie@example.com', 'Pw617!!!', '액션중독자', 'profile008.jpg', '임도현', TO_TIMESTAMP('2024-03-10 10:20:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (9, 'romance_dreamer@example.com', 'Pw819!!!', '로맨스빌런', 'profile009.jpg', '황보라', TO_TIMESTAMP('2024-03-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (10, 'kpop_stan@example.com', 'Pw202!!!', 'K팝지킴이', 'profile010.jpg', '서예준', TO_TIMESTAMP('2024-03-20 15:50:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (11, 'user11_teen@example.com', 'Pw_new1!!!', '새싹개발자15', 'profile011.jpg', '박현우', TO_TIMESTAMP('2024-04-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (12, 'user12@example.com', 'Pw_new2!!!', '고독한미식가', 'profile012.jpg', '이지은', TO_TIMESTAMP('2024-04-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (13, 'user13_teen@example.com', 'Pw_new3!!!', '게임스트리머19', 'profile013.jpg', '최민식', TO_TIMESTAMP('2024-04-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (14, 'user14@example.com', 'Pw_new4!!!', '여행가고싶다', 'profile014.jpg', '한지민', TO_TIMESTAMP('2024-04-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (15, 'user15_teen@example.com', 'Pw_new5!!!', '댄스신동14', 'profile015.jpg', '김민서', TO_TIMESTAMP('2024-04-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (16, 'user16@example.com', 'Pw_new6!!!', '냥집사그램', 'profile016.jpg', '송강호', TO_TIMESTAMP('2024-04-06 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (17, 'user17_teen@example.com', 'Pw_new7!!!', '코딩천재17', 'profile017.jpg', '배수지', TO_TIMESTAMP('2024-04-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (18, 'user18@example.com', 'Pw_new8!!!', '패피의일상', 'profile018.jpg', '유해진', TO_TIMESTAMP('2024-04-08 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (19, 'user19_teen@example.com', 'Pw_new9!!!', '인싸의삶16', 'profile019.jpg', '전지현', TO_TIMESTAMP('2024-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (20, 'user20@example.com', 'Pw_new10!!!', '독서왕김독서', 'profile020.jpg', '이병헌', TO_TIMESTAMP('2024-04-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (21, 'user21_teen@example.com', 'Pw_new11!!!', '뷰티유튜버18', 'profile021.jpg', '김고은', TO_TIMESTAMP('2024-04-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (22, 'user22@example.com', 'Pw_new12!!!', '요리하는남자', 'profile022.jpg', '박보검', TO_TIMESTAMP('2024-04-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (23, 'user23_teen@example.com', 'Pw_new13!!!', '축구광팬15', 'profile023.jpg', '손예진', TO_TIMESTAMP('2024-04-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (24, 'user24@example.com', 'Pw_new14!!!', '자전거라이더', 'profile024.jpg', '정우성', TO_TIMESTAMP('2024-04-14 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
-- INSERT INTO userAccount (ac_idx, email, pw, nickname, img, name, created_at) VALUES (25, 'user25@example.com', 'Pw_new15!!!', '프로캠핑러', 'profile025.jpg', '김혜수', TO_TIMESTAMP('2024-04-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- 4. contents 테이블 데이터 삽입 (content_idx: 1 ~ 25)
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (1, '우주 대전쟁: 새로운 희망', 'content_img001.jpg', '은하계를 지키기 위한 최후의 전투가 시작된다!', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (2, '심장이 멎을 듯한 로맨스', 'content_img002.jpg', '두 남녀의 운명적인 사랑 이야기', 2);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (3, '오늘 밤, K-POP에 취하다', 'content_img003.jpg', '최신 인기 K-POP 논스톱 리믹스', 3);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (4, '시간여행자의 웹툰 어드벤처', 'content_img004.jpg', '과거와 미래를 넘나드는 상상 초월 모험담', 4);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (5, '마법학교 아르카나', 'content_img005.jpg', '평범한 소녀가 마법 세계에 발을 들이다!', 5);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (6, '블록버스터 SF: 인공지능의 역습', 'content_img006.jpg', '인류의 미래를 건 AI와의 대결', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (7, '힙합 서바이벌: 쇼미더비트', 'content_img007.jpg', '최고의 래퍼를 가리는 치열한 경쟁', 3);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (8, '일상 코믹 시트콤: 옆집 사람들', 'content_img008.jpg', '평범한 이웃들의 배꼽 빠지는 일상', 2);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (9, '미스터리 스릴러: 사라진 기억', 'content_img009.jpg', '기억을 잃은 주인공, 그 뒤에 숨겨진 진실은?', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (10, '판타지 애니: 드래곤 슬레이어', 'content_img010.jpg', '용을 물리치고 세상을 구원할 영웅의 여정', 5);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (11, '미래 도시의 그림자', 'content_img011.jpg', '네온사인 아래 숨겨진 거대 음모', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (12, '캠퍼스 청춘 로맨틱 코미디', 'content_img012.jpg', '풋풋한 대학생들의 사랑과 우정', 2);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (13, '인디 밴드의 숨은 명곡', 'content_img013.jpg', '당신만 알고 싶은 감성 플레이리스트', 3);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (14, '무협 액션 웹툰: 절대고수', 'content_img014.jpg', '강호를 평정할 절대자의 귀환!', 4);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (15, '이세계 전생 판타지 애니', 'content_img015.jpg', '평범했던 내가 이세계에서는 최강?!', 5);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (16, '사이버펑크 스릴러: 코드 제로', 'content_img016.jpg', '가상현실 속에서 펼쳐지는 두뇌 싸움', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (17, '감성 발라드 모음: 새벽 감성', 'content_img017.jpg', '밤에 듣기 좋은 잔잔한 발라드곡들', 3);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (18, '육아 일상 드라마: 슈퍼맘 다이어리', 'content_img018.jpg', '초보 엄마의 고군분투 육아 일기', 2);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (19, '학원 미스터리 웹툰: 학교의 비밀', 'content_img019.jpg', '평범한 학교에 숨겨진 소름끼치는 비밀', 4);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (20, '로봇 대전 애니메이션: 메카 워리어즈', 'content_img020.jpg', '거대 로봇들의 화려한 전투 액션!', 5);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (21, '첩보 액션: 코드네임 바이퍼', 'content_img021.jpg', '세계를 위협하는 테러 조직을 막아라!', 1);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (22, '타임슬립 로맨스: 시간을 건너온 연인', 'content_img022.jpg', '과거와 현재를 잇는 애틋한 사랑', 2);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (23, '월드투어 라이브 K-POP', 'content_img023.jpg', '글로벌 아이돌의 뜨거운 콘서트 현장', 3);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (24, '일상 힐링 웹툰: 작은 행복', 'content_img024.jpg', '소소하지만 확실한 행복을 찾아서', 4);
INSERT INTO contents (content_idx, title, img, dsc, category_idx) VALUES (25, '스포츠 성장 애니: 코트 위의 에이스', 'content_img025.jpg', '최고를 향한 소년들의 뜨거운 열정', 5);

-- 5. userPage 테이블 데이터 삽입 (userPg_idx: 1 ~ 27)
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (1, '나의 첫 페이지! 반갑습니다!', 'page_thumb001.jpg', TO_TIMESTAMP('2024-01-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (2, '영화 이야기 나눠요~', 'page_thumb002.jpg', TO_TIMESTAMP('2024-01-21 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (3, '음악 추천 받습니다!', 'page_thumb003.jpg', TO_TIMESTAMP('2024-02-02 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (4, '오늘의 웹툰 감상 😀', 'page_thumb004.jpg', TO_TIMESTAMP('2024-02-11 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 2);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (5, '최애 드라마 캐릭터는?', 'page_thumb005.jpg', TO_TIMESTAMP('2024-02-16 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 5, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (6, 'SF 영화 토론장', 'page_thumb006.jpg', TO_TIMESTAMP('2024-03-02 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (7, '힙합 비트 공유합니다 🔥', 'page_thumb007.jpg', TO_TIMESTAMP('2024-03-06 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (8, '액션 명장면 BEST', 'page_thumb008.jpg', TO_TIMESTAMP('2024-03-11 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 8, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (9, '로맨스 영화 속 명대사', 'page_thumb009.jpg', TO_TIMESTAMP('2024-03-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (10, 'K-POP 최신 동향 🚀', 'page_thumb010.jpg', TO_TIMESTAMP('2024-03-21 15:50:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 9);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (11, '영화 이야기 너무 좋아요!', 'reply_thumb001.jpg', TO_TIMESTAMP('2024-01-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 2);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (12, '힙합 비트 잘 들었습니다! 👍', 'reply_thumb002.jpg', TO_TIMESTAMP('2024-03-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 7);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (13, '개발 일지 #1', 'page_thumb011.jpg', TO_TIMESTAMP('2024-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (14, '오늘의 맛집 탐방 후기', 'page_thumb012.jpg', TO_TIMESTAMP('2024-04-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (15, '신작 게임 리뷰 🔥', 'page_thumb013.jpg', TO_TIMESTAMP('2024-04-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 13, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (16, '나만의 여행 버킷리스트', 'page_thumb014.jpg', TO_TIMESTAMP('2024-04-04 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 14, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (17, '댄스 커버 영상 올렸어요! 🤩', 'page_thumb015.jpg', TO_TIMESTAMP('2024-04-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 15, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (18, '우리집 고양이 자랑 🐾', 'page_thumb016.jpg', TO_TIMESTAMP('2024-04-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 16, 1);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (19, '코딩 꿀팁 대방출! ✨', 'page_thumb017.jpg', TO_TIMESTAMP('2024-04-07 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 17, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (20, '오늘의 OOTD 룩북', 'page_thumb018.jpg', TO_TIMESTAMP('2024-04-08 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 18, 5);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (21, '인싸템 소개합니다 🚀', 'page_thumb019.jpg', TO_TIMESTAMP('2024-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 19, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (22, '요즘 읽고 있는 책 추천', 'page_thumb020.jpg', TO_TIMESTAMP('2024-04-10 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 20, 9);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (23, '데일리 메이크업 튜토리얼 💖', 'page_thumb021.jpg', TO_TIMESTAMP('2024-04-11 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 21, 15);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (24, '간단 자취 요리 레시피', 'page_thumb022.jpg', TO_TIMESTAMP('2024-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 22, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (25, '주말 축구 경기 직관 후기! ⚽', 'page_thumb023.jpg', TO_TIMESTAMP('2024-04-13 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 23, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (26, '한강 자전거 라이딩 코스 추천', 'page_thumb024.jpg', TO_TIMESTAMP('2024-04-14 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 24, NULL);
INSERT INTO userPage (userPg_idx, subject, thumbnail, created_at, ac_idx, re_userPg_idx) VALUES (27, '캠핑 장비 리뷰 (내돈내산)', 'page_thumb025.jpg', TO_TIMESTAMP('2024-04-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 25, NULL);

-- 6. setting 테이블 데이터 삽입 (setting_idx: 1 ~ 25)
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (1, '나눔고딕', '다크', '활성화', 1);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (2, 'Roboto', '라이트', '중요알림만', 2);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (3, 'Pretendard', '시스템기본', '비활성화', 3);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (4, 'AppleSDGothicNeo', '다크', '활성화', 4);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (5, 'NotoSansKR', '라이트', '활성화', 5);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (6, '본고딕', '다크', '중요알림만', 6);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (7, 'G마켓산스', '라이트', '비활성화', 7);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (8, '여기어때잘난체', '다크', '활성화', 8);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (9, '산돌고딕Neo', '라이트', '중요알림만', 9);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (10, '네이버클로바', '시스템기본', '활성화', 10);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (11, '함초롬돋움', '다크', '비활성화', 11);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (12, '맑은 고딕', '라이트', '활성화', 12);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (13, '궁서체', '다크', '중요알림만', 13);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (14, '굴림체', '라이트', '활성화', 14);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (15, '바탕체', '시스템기본', '비활성화', 15);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (16, '돋움체', '다크', '활성화', 16);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (17, 'Arial', '라이트', '중요알림만', 17);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (18, 'Times New Roman', '다크', '활성화', 18);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (19, 'Verdana', '라이트', '비활성화', 19);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (20, 'Courier New', '시스템기본', '활성화', 20);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (21, 'Georgia', '다크', '중요알림만', 21);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (22, 'Impact', '라이트', '활성화', 22);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (23, 'Comic Sans MS', '다크', '비활성화', 23);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (24, 'Lobster', '라이트', '활성화', 24);
INSERT INTO setting (setting_idx, font, theme, noti, ac_idx) VALUES (25, 'Pacifico', '시스템기본', '중요알림만', 25);


-- 7. message 테이블 데이터 삽입 (msg_idx: 1 ~ 48)
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (1,   '주말에 뭐 재미있는 거 없을까? 🤔 영화라도 보러 갈까?',  TO_TIMESTAMP('2024-06-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 2, 1);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (2,   '오 좋아! 액션 영화 새로 나온 거 있던데 그거 어때? 🚀',     TO_TIMESTAMP('2024-06-01 10:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 1, 2);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (3,   '완전 콜! 👍 예매는 내가 할게! 몇 시쯤 볼까?',   TO_TIMESTAMP('2024-06-01 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 2, 1);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (4,   '나는 오후 2시쯤 괜찮을 것 같아! 😄', TO_TIMESTAMP('2024-06-01 10:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 1, 2);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (5,   '오늘 점심 메뉴 뭐 먹지? 추천 좀! 배고프다 😭',  TO_TIMESTAMP('2024-06-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 5, 4);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (6,   '회사 앞에 새로 생긴 파스타집 맛있대! 거기 가볼래? 🍝', TO_TIMESTAMP('2024-06-01 11:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 4, 5);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (7,   '오오 파스타 완전 좋아! ✨ 그럼 거기서 보자! 언제쯤 갈까?',     TO_TIMESTAMP('2024-06-01 11:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 5, 4);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (8,   '12시 반 어때? 사람 너무 많기 전에 가자!', TO_TIMESTAMP('2024-06-01 11:04:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 4, 5);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (9,   '이번 K-POP 신곡 들어봤어? 안무가 진짜 대박이야! 🤩 나도 배워보고 싶다!', TO_TIMESTAMP('2024-06-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 10, 7);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (10,  '헐! 어떤 노랜데? 나도 요즘 춤 배우고 싶었는데! 같이 연습할래? 😉',    TO_TIMESTAMP('2024-06-01 14:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 7, 10);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (11,  '진짜? 완전 좋지! 🔥 주말에 연습실 잡아서 같이 연습하자!',    TO_TIMESTAMP('2024-06-01 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 10, 7);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (12,  '오케이! 내가 연습실 알아볼게! 기대된다! 🚀',     TO_TIMESTAMP('2024-06-01 14:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 7, 10);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (13,  '새로 나온 게임 같이 할 사람? 🎮 완전 내 취향일 것 같아! 💖',TO_TIMESTAMP('2024-06-02 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 13, 11);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (14,  '무슨 게임인데? 나도 요즘 할 게임 찾고 있었는데! 🤔',     TO_TIMESTAMP('2024-06-02 09:32:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 11, 13);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (15,  '판타지 RPG인데 그래픽이 엄청 예쁘대! ✨ 오늘 저녁에 같이 해볼래?', TO_TIMESTAMP('2024-06-02 09:35:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 13, 11);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (16,  '콜! 저녁에 접속할게! 캐릭터 뭐 할지 고민해봐야겠다! 😎',   TO_TIMESTAMP('2024-06-02 09:37:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 11, 13);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (17,  '오늘 날씨 너무 좋은데, 자전거 타러 갈래? 🚴‍♀️',TO_TIMESTAMP('2024-06-02 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 14, 3);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (18,  '좋지! 어디로 갈까? 한강 쪽 코스 괜찮아?',    TO_TIMESTAMP('2024-06-02 13:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 3, 14);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (19,  '응! 그럼 오후 3시에 한강 공원에서 만나자!',  TO_TIMESTAMP('2024-06-02 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 14, 3);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (20,  '오케이! 헬멧 꼭 챙겨와~',  TO_TIMESTAMP('2024-06-02 13:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 3, 14);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (21,  '최근에 본 웹툰 중에 뭐 재밌는 거 있어? 추천 좀! 🙏',     TO_TIMESTAMP('2024-06-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 17, 15);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (22,  '''시간을 달리는 소녀''라는 웹툰 봤어? 그림체도 예쁘고 스토리도 탄탄해! 👍', TO_TIMESTAMP('2024-06-02 15:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 15, 17);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (23,  '오! 제목부터 끌리는데? ✨ 바로 검색해봐야겠다! 고마워! 💯', TO_TIMESTAMP('2024-06-02 15:06:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 17, 15);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (24,  '재밌게 봐! 다 보면 후기도 알려줘! 😄',TO_TIMESTAMP('2024-06-02 15:08:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 15, 17);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (25,  '우리집 고양이가 또 사고쳤어 ㅠㅠ 사진 보내줄까? 🤣',     TO_TIMESTAMP('2024-06-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 18, 16);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (26,  'ㅋㅋㅋ 뭔데 뭔데? 빨리 보내줘! 궁금하다!',TO_TIMESTAMP('2024-06-03 10:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 16, 18);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (27,  '휴지 다 풀어헤쳐놨어... 완전 난장판이야 😭 (사진)',    TO_TIMESTAMP('2024-06-03 10:03:00', 'YYYY-MM-DD HH24:MI:SS'), 'http://example.com/img/cat_mess.png', 0, 18, 16);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (28,  '아이고 ㅋㅋㅋ 그래도 귀엽다! 우리집 냥이도 맨날 그래!',  TO_TIMESTAMP('2024-06-03 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 16, 18);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (29,  '이번 주말에 뭐 특별한 계획 있어? 😊',     TO_TIMESTAMP('2024-06-03 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 20, 19);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (30,  '글쎄... 아직 딱히 없는데... 같이 맛집 탐방이나 할까? 🍕🌮🍣',  TO_TIMESTAMP('2024-06-03 11:32:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 19, 20);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (31,  '좋아! 어디 가고 싶은데 있어? 아니면 내가 찾아볼까? 😎', TO_TIMESTAMP('2024-06-03 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 20, 19);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (32,  '음... 요즘 핫하다는 성수동 쪽 가보는 거 어때? 맛집 많다던데! ✨', TO_TIMESTAMP('2024-06-03 11:37:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 19, 20);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (33,  '새로 나온 뷰티 유튜버 영상 봤어? 💖 이번 메이크업 진짜 예쁘더라!', TO_TIMESTAMP('2024-06-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 23, 21);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (34,  '어떤 채널인데? 나도 구독해야겠다! 😉 요즘 화장품 뭐 살지 고민이었는데!', TO_TIMESTAMP('2024-06-03 15:02:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 21, 23);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (35,  '''뷰티뿜뿜'' 채널이야! 이번에 웜톤 쿨톤 다 어울리는 팔레트 소개했더라! 👍', TO_TIMESTAMP('2024-06-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 23, 21);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (36,  '오! 정보 고마워! ✨ 당장 보러 가야지! 🚀',  TO_TIMESTAMP('2024-06-03 15:07:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 21, 23);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (37,  '혹시 내일 시간 괜찮으면 같이 저녁 먹을래? 😊', TO_TIMESTAMP('2024-06-04 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 25, 6);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (38,  '좋지! 뭐 먹고 싶은 거 있어?',     TO_TIMESTAMP('2024-06-04 16:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 6, 25);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (39,  '음... 오랜만에 매콤한 쭈꾸미 어때? 스트레스 풀리게! 🔥',TO_TIMESTAMP('2024-06-04 16:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 25, 6);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (40,  '완전 좋아! 그럼 내일 저녁 7시에 회사 앞에서 보자!',   TO_TIMESTAMP('2024-06-04 16:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 6, 25);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (41,  '오늘 너무 피곤하다... 😴 퇴근하고 바로 자야지...',   TO_TIMESTAMP('2024-06-04 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 8, 12);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (42,  '고생했어 ㅠㅠ 푹 쉬고 내일 보자!',TO_TIMESTAMP('2024-06-04 19:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 12, 8);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (43,  '오늘 저녁은 내가 요리해줄게! ✨ 뭐 먹고 싶어? 😉',    TO_TIMESTAMP('2024-06-04 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 22, 1);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (44,  '헐 진짜? 😮 그럼 나는... 크림 파스타! 🍝 완전 기대된다! 💯', TO_TIMESTAMP('2024-06-04 19:32:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 1, 22);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (45,  '오늘 축구 경기 결과 봤어? ⚽️ 완전 대박이었는데!',  TO_TIMESTAMP('2024-06-05 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 24, 23);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (46,  '아니 못 봤어! ㅠㅠ 누가 이겼어? 스포해줘!', TO_TIMESTAMP('2024-06-05 08:01:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 23, 24);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (47,  '우리 팀이 3:0으로 이겼지롱! ㅋㅋㅋ 완전 명경기였어! 🔥',      TO_TIMESTAMP('2024-06-05 08:03:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 0, 24, 23);
INSERT INTO message (msg_idx, text, time, img, chk, ac_receiver, ac_sender) VALUES (48,  '와 대박! 😮 하이라이트 영상 찾아봐야겠다! 알려줘서 고마워! 👍', TO_TIMESTAMP('2024-06-05 08:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 23, 24);

-- 8. todolist 테이블 데이터 삽입 (todo_idx: 1 ~ 30)
-- 회원가입 후 
commit;


-- 9. follows 테이블 데이터 삽입 (follows_idx: 1 ~ 50)
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (1,  1, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (2,  1, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (3,  1, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (4,  1, 5);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (5,  2, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (6,  2, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (7,  2, 5);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (8,  2, 6);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (9,  3, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (10, 3, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (11, 3, 5);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (12, 3, 6);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (13, 4, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (14, 4, 5);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (15, 4, 6);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (16, 4, 7);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (17, 5, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (18, 5, 6);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (19, 5, 7);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (20, 5, 8);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (21, 6, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (22, 6, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (23, 6, 7);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (24, 6, 8);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (25, 7, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (26, 7, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (27, 7, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (28, 7, 8);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (29, 8, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (30, 8, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (31, 8, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (32, 8, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (33, 9, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (34, 9, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (35, 9, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (36, 9, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (37, 10, 1);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (38, 10, 2);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (39, 10, 3);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (40, 10, 4);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (41, 11, 12);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (42, 11, 13);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (43, 12, 14);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (44, 12, 15);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (45, 13, 16);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (46, 13, 17);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (47, 14, 18);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (48, 14, 19);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (49, 15, 20);
INSERT INTO follows (follows_idx, ac_follow, ac_following) VALUES (50, 15, 21);


-- 10. note 테이블 데이터 삽입
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (1, '영화 ''우주 대전쟁'' 감상평입니다. 스케일이 정말 엄청나고, 시각효과가 압권이었어요. 주인공의 성장 서사도 인상 깊었습니다. 강력 추천! 👍', 'note_img_301.jpg', '우주 대전쟁 감상 후기', TO_TIMESTAMP('2024-05-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-20 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 152, 1, 1, 1, 2);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (2, '드라마 ''심장이 멎을 듯한 로맨스'' 정주행 완료! 두 주인공의 케미가 너무 좋아서 시간 가는 줄 몰랐네요. OST도 최고! 🥰', 'note_img_302.jpg', '로맨스 드라마 정주행 후기', TO_TIMESTAMP('2024-05-20 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 88, 2, 2, 2, 5);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (3, 'K-POP 아이돌 ''VVSync''의 신곡 ''Vibration'' 스트리밍 인증! 멜로디 중독성 최고! 🔥', 'note_img_303.jpg', 'VVSync 신곡 스트리밍!', TO_TIMESTAMP('2024-05-21 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 250, 3, 5, 3, 3);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (4, '애니메이션 ''시간여행자의 애니 어드벤처'' 보고 왔어요. 상상력이 정말 대단한 작품이네요. 다음 시즌 기대됩니다! 🤔', 'note_img_304.jpg', '시간여행자 애니 후기', TO_TIMESTAMP('2024-05-21 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 120, 4, 7, 4, 1);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (5, '요즘 저의 소소한 일상 기록입니다. 오늘은 예쁜 카페에 가서 맛있는 커피를 마셨어요. 이런 게 행복이죠! 😊☕', 'note_img_305.jpg', '나의 소소한 일상 #1', TO_TIMESTAMP('2024-05-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-21 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 95, 24, 8, 5, 4);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (6, '영화 ''인공지능의 역습''은 생각할 거리를 많이 던져주는 영화였어요. AI와 인간의 미래에 대해 고민하게 되네요. 🤖', NULL, 'SF 영화 감상 - AI의 미래', TO_TIMESTAMP('2024-05-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 77, 6, 9, 1, 6);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (7, '''쇼미더비트'' 파이널 무대 직관 후기! 현장의 열기가 정말 뜨거웠습니다. 우승자 너무 멋져요! 💯🎤', 'note_img_307.jpg', '힙합 서바이벌 파이널 직관!', TO_TIMESTAMP('2024-05-22 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 180, 7, 10 ,3, 7);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (8, '''옆집 사람들'' 시트콤 보면서 오랜만에 실컷 웃었네요. 캐릭터들 다 너무 매력적이에요. 🤣', NULL, '오늘의 힐링 시트콤', TO_TIMESTAMP('2024-05-22 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 65, 8, 3, 2, 8);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (9, '스릴러 영화 ''사라진 기억''은 반전의 반전을 거듭해서 끝까지 긴장을 놓을 수 없었어요. 추천합니다. 🎬', 'note_img_309.jpg', '스릴러 영화 추천 - 사라진 기억', TO_TIMESTAMP('2024-05-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-23 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 102, 9, 4, 1, 9);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (10, '판타지 애니 ''드래곤 슬레이어''의 화려한 액션씬 모음.gif (용량주의) 🐉💥', 'note_img_310.gif', '드래곤 슬레이어 액션 모음', TO_TIMESTAMP('2024-05-23 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 140, 10, 7, 4, 10);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (11, '''미래 도시의 그림자'', 디스토피아적 세계관이 인상적인 SF 영화였습니다. 영상미가 특히 돋보였어요. ✨', NULL, 'SF 영화 리뷰 - 미래 도시', TO_TIMESTAMP('2024-05-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 92, 11, 9, 1, 11);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (12, '풋풋한 설렘이 가득했던 ''캠퍼스 청춘 로맨틱 코미디''! 대학 시절 추억이 새록새록 떠오르네요. 😊', 'note_img_312.jpg', '캠퍼스 로코 감상평', TO_TIMESTAMP('2024-05-24 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 130, 12, 2, 2, 12);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (13, '요즘 꽂힌 인디 밴드 ''새벽공방''의 노래 ''밤편지'' 추천합니다. 가사가 너무 아름다워요. 🎶', NULL, '나만 알고 싶은 인디음악', TO_TIMESTAMP('2024-05-24 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 75, 13, 6, 3, 13);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (14, '무협 액션 영화 ''절대고수''의 명장면 다시 보기. 주인공의 검술은 언제 봐도 멋있네요. 👍', NULL, '무협 영화 명장면', TO_TIMESTAMP('2024-05-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-24 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 110, 14, 1, 1, 14);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (15, '''이세계 전생 판타지 애니''는 클리셰 범벅이지만 그래서 더 재미있는 것 같아요. 가볍게 보기 좋습니다. 🚀', 'note_img_315.jpg', '요즘 보는 이세계 애니', TO_TIMESTAMP('2024-05-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 60, 15, 7, 4, 15);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (16, '영화 ''사이버펑크 스릴러: 코드 제로'' 후기. 가상현실과 현실의 경계가 모호해지는 느낌이 인상적. 🌃', NULL, '코드 제로 감상', TO_TIMESTAMP('2024-05-25 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 85, 16, 4, 1, 16);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (17, '오늘 같은 날씨엔 역시 감성 발라드죠. 플레이리스트 공유합니다. 🎧', 'note_img_317.jpg', '비 오는 날 듣기 좋은 발라드', TO_TIMESTAMP('2024-05-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 98, 17, 6, 3, 17);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (18, '''슈퍼맘 다이어리'' 보면서 우리 엄마 생각이 많이 났어요. 세상 모든 엄마들 화이팅! 💪', NULL, '''슈퍼맘 다이어리'' 공감 후기', TO_TIMESTAMP('2024-05-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 50, 18, 8, 5, 18);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (19, '애니메이션 ''학교의 비밀'' 최종화 해석. 범인은 역시 그 사람이었네요. (스포주의) 😱', 'note_img_319.jpg', '학교의 비밀 최종화 해석 (스포)', TO_TIMESTAMP('2024-05-26 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 105, 19, 4, 4, 19);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (20, '''메카 워리어즈'' 로봇 조립 완성! 인증샷 올립니다. 뿌듯하네요. 😎🤖', 'note_img_320.jpg', '메카 워리어즈 조립 인증', TO_TIMESTAMP('2024-05-26 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 70, 20, 9, 5, 20);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (21, '''코드네임 바이퍼'', 오랜만에 정통 첩보 액션을 봐서 즐거웠습니다. 시리즈로 계속 나왔으면! 🕵️‍♂️', 'note_img_321.jpg', '첩보 액션 영화는 역시!', TO_TIMESTAMP('2024-05-27 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 115, 21, 1, 1, 21);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (22, '''시간을 건너온 연인'', 애절한 사랑 이야기에 눈물을 훔쳤네요. 여운이 깊게 남는 영화입니다. 😢', NULL, '타임슬립 로맨스 추천', TO_TIMESTAMP('2024-05-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 80, 22, 2, 1, 22);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (23, '''월드투어 라이브 K-POP'' 공연 실황 VOD 구매 완료! 집에서 편하게 즐겨야겠어요. 🥳', 'note_img_323.jpg', '콘서트 VOD 구매 인증', TO_TIMESTAMP('2024-05-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 150, 23, 5, 5, 23);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (24, '오늘의 소확행: 퇴근길에 발견한 예쁜 꽃 한 송이. 기분이 좋아지네요. 🌸', 'note_img_324.jpg', '나의 소소한 일상 #2', TO_TIMESTAMP('2024-05-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 65, 24, 8, 5, 24);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (25, '애니 ''코트 위의 에이스'' 주인공의 성장에 매번 감동받습니다. 다음 경기도 화이팅! 🔥🏀', NULL, '''코트 위의 에이스'' 응원글', TO_TIMESTAMP('2024-05-28 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 90, 25, 7, 4, 25);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (26, '주말에 본 영화 ''우주 대전쟁'' 속편 예고편 분석. 떡밥이 어마어마하네요! 😮', 'note_img_326.jpg', '''우주 대전쟁'' 속편 분석', TO_TIMESTAMP('2024-05-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 45, 1, 1, 1, 26);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (27, '드라마 ''심장이 멎을 듯한 로맨스'' 촬영지 성지순례 다녀왔습니다. 너무 예뻐요! 💖', 'note_img_327.jpg', '드라마 촬영지 방문 후기', TO_TIMESTAMP('2024-05-29 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-29 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 78, 2, 2, 2, 26);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (28, '최애 K-POP 그룹 컴백! 이번 앨범 컨셉 포토 모음입니다. 다들 비주얼 무슨 일이야... ✨🎉', 'note_img_328.jpg', '최애 그룹 컴백!', TO_TIMESTAMP('2024-05-29 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 210, 3, 5, 3, 25);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (29, '애니메이션 ''시간여행자의 애니 어드벤처'' 명대사 정리. 다시 봐도 감동적이네요. 🤔 "시간은 기다려주지 않아!"', NULL, '시간여행자 애니 명대사', TO_TIMESTAMP('2024-05-30 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 99, 4, 7, 4, 10);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (30, '오늘의 일상: 집에서 뒹굴거리며 밀린 예능 보기. 이게 바로 천국이죠! 😌', 'note_img_330.jpg', '나의 소소한 일상 #3', TO_TIMESTAMP('2024-05-30 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 80, 24, 8, 5, 8);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (31, 'SF 영화 ''인공지능의 역습''에 등장하는 미래 기술들, 과연 현실이 될까요? 🧐', NULL, '''인공지능의 역습'' 미래 기술', TO_TIMESTAMP('2024-05-30 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-30 17:45:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 6, 9, 1, 4);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (32, '''쇼미더비트'' 레전드 무대 영상 공유. 이 비트와 랩은 정말 미쳤어요. 💯', 'note_img_332.jpg', '힙합 레전드 무대', TO_TIMESTAMP('2024-05-31 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 150, 7, 10, 3, 15);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (33, '''옆집 사람들'' 시즌2 제작 소취! 제발 만들어주세요 현기증 난단 말이에요. 😂🙏', NULL, '시트콤 시즌2 소취!', TO_TIMESTAMP('2024-05-31 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 55, 8, 3, 2, 17);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (34, '영화 ''사라진 기억'' 결말에 대한 다양한 해석들. 여러분의 생각은 어떤가요? 🤔', 'note_img_334.jpg', '''사라진 기억'' 결말 해석', TO_TIMESTAMP('2024-05-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 110, 9, 4, 1, 12);
INSERT INTO note (note_idx, text, img, title, create_at, edit_at, view_count, content_idx, genre_idx, category_idx, userPg_idx) VALUES (35, '애니 ''드래곤 슬레이어'' 주인공 최애 기술 투표! 저는 역시 이거죠! 🔥', 'note_img_335.jpg', '''드래곤 슬레이어'' 최애 기술', TO_TIMESTAMP('2024-06-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 120, 10, 7, 4, 25);



-- 11. notification 테이블 데이터 삽입
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (2, TO_TIMESTAMP('2024-06-01 10:05:00','YYYY-MM-DD HH24:MI:SS'), '영화광팬(이영희)님이 회원님의 일상 #1 페이지를 북마크했습니다.', 1, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (3, TO_TIMESTAMP('2024-06-01 11:00:00','YYYY-MM-DD HH24:MI:SS'), '웹툰장인17(최유리)님이 회원님을 팔로우하기 시작했습니다. 🎉', 0, 3, 3);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (4, TO_TIMESTAMP('2024-06-01 11:30:00','YYYY-MM-DD HH24:MI:SS'), '음악없인못살아(박민준)님이 회원님의 K-POP은 사랑입니다 노트를 좋아합니다.', 1, 7, 7);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (5, TO_TIMESTAMP('2024-06-01 14:00:00','YYYY-MM-DD HH24:MI:SS'), '힙합꿈나무18(윤서아)님으로부터 새 메시지가 도착했습니다: "주말에 비트 작업 같이 할래? 😎', 0, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (6, TO_TIMESTAMP('2024-06-02 09:00:00','YYYY-MM-DD HH24:MI:SS'), '드라마덕후(정수민)님이 회원님의 로맨스 드라마 정주행 후기 노트에 댓글을 남겼습니다: "저도 이 드라마 인생작이에요!"', 0, 2, 2);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (7, TO_TIMESTAMP('2024-06-02 09:30:00','YYYY-MM-DD HH24:MI:SS'), 'SF매니아(강지훈)님이 SF 영화 토론장 페이지에 새 글을 작성했습니다.', 1, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (8, TO_TIMESTAMP('2024-06-02 10:00:00','YYYY-MM-DD HH24:MI:SS'), '날쎈돌이16(김철수)님이 회원님의 댓글을 좋아합니다. 👍', 0, 4, 4);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (9, TO_TIMESTAMP('2024-06-02 13:00:00','YYYY-MM-DD HH24:MI:SS'), '액션중독자(임도현)님이 회원님의 우주 대전쟁 감상 후기 노트를 좋아합니다.', 1, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (10, TO_TIMESTAMP('2024-06-02 15:00:00','YYYY-MM-DD HH24:MI:SS'), 'K팝지킴이(서예준)님이 K-POP 최신 동향 🚀 페이지를 북마크했습니다.', 0, 7, 7);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (11, TO_TIMESTAMP('2024-06-03 10:00:00','YYYY-MM-DD HH24:MI:SS'), '새싹개발자15(박현우)님이 회원님을 팔로우하기 시작했습니다. ✨', 0, 2, 2);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (12, TO_TIMESTAMP('2024-06-03 11:00:00','YYYY-MM-DD HH24:MI:SS'), '게임스트리머19(최민식)님으로부터 새 메시지가 도착했습니다: "오늘 저녁 게임 같이 하실래요? 🎮"', 1, 11, 11);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (13, TO_TIMESTAMP('2024-06-03 14:00:00','YYYY-MM-DD HH24:MI:SS'), '고독한미식가(이지은)님이 회원님의 나의 소소한 일상 #1 노트에 댓글을 남겼습니다: "카페 분위기 너무 좋아 보이네요!"', 0, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (14, TO_TIMESTAMP('2024-06-03 16:00:00','YYYY-MM-DD HH24:MI:SS'), '댄스신동14(김민서)님이 회원님의 힙합 서바이벌 파이널 직관! 노트를 좋아합니다. 🔥', 0, 7, 7);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (15, TO_TIMESTAMP('2024-06-03 18:00:00','YYYY-MM-DD HH24:MI:SS'), '여행가고싶다(한지민)님이 나만의 여행 버킷리스트 페이지에 새 글을 작성했습니다.', 1, 5, 5);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (16, TO_TIMESTAMP('2024-06-04 09:00:00','YYYY-MM-DD HH24:MI:SS'), '코딩천재17(배수지)님이 회원님의 개발 일지 #1 노트를 좋아합니다. 💻', 0, 11, 11);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (17, TO_TIMESTAMP('2024-06-04 10:30:00','YYYY-MM-DD HH24:MI:SS'), '냥집사그램(송강호)님이 회원님을 팔로우하기 시작했습니다.', 0, 15, 15);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (18, TO_TIMESTAMP('2024-06-04 11:30:00','YYYY-MM-DD HH24:MI:SS'), '패피의일상(유해진)님으로부터 새 메시지가 도착했습니다: "이번 주말에 쇼핑 같이 갈래요?"', 1, 17, 17);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (19, TO_TIMESTAMP('2024-06-04 14:30:00','YYYY-MM-DD HH24:MI:SS'), '인싸의삶16(전지현)님이 회원님의 데일리 메이크업 튜토리얼 💖 노트에 댓글을 남겼습니다: "색감 너무 예뻐요! 🤩"', 0, 21, 21);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (20, TO_TIMESTAMP('2024-06-04 17:00:00','YYYY-MM-DD HH24:MI:SS'), '독서왕김독서(이병헌)님이 요즘 읽고 있는 책 추천 페이지를 북마크했습니다.', 1, 14, 14);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (21, TO_TIMESTAMP('2024-06-05 09:00:00','YYYY-MM-DD HH24:MI:SS'), '뷰티유튜버18(김고은)님이 회원님을 팔로우하기 시작했습니다. ✨', 0, 19, 19);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (22, TO_TIMESTAMP('2024-06-05 10:00:00','YYYY-MM-DD HH24:MI:SS'), '요리하는남자(박보검)님으로부터 새 메시지가 도착했습니다: "파스타 레시피 공유 감사합니다!"', 0, 12, 12);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (23, TO_TIMESTAMP('2024-06-05 11:00:00','YYYY-MM-DD HH24:MI:SS'), '축구광팬15(손예진)님이 회원님의 주말 축구 경기 직관 후기! ⚽ 노트를 좋아합니다. 👍', 1, 23, 23);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (24, TO_TIMESTAMP('2024-06-05 14:00:00','YYYY-MM-DD HH24:MI:SS'), '자전거라이더(정우성)님이 한강 자전거 라이딩 코스 추천 페이지에 새 글을 작성했습니다.', 0, 14, 14);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (25, TO_TIMESTAMP('2024-06-05 16:00:00','YYYY-MM-DD HH24:MI:SS'), '프로캠핑러(김혜수)님이 회원님의 캠핑 장비 리뷰 (내돈내산) 노트에 댓글을 남겼습니다: "이 텐트 정말 좋아 보이네요!"', 0, 25, 25);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (26, TO_TIMESTAMP('2024-06-05 18:00:00','YYYY-MM-DD HH24:MI:SS'), '날쎈돌이16(김철수)님이 회원님의 SF 영화 토론장 페이지 글을 좋아합니다.🚀', 1, 6, 6);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (27, TO_TIMESTAMP('2024-06-06 09:30:00','YYYY-MM-DD HH24:MI:SS'), '웹툰장인17(최유리)님으로부터 새 메시지가 도착했습니다: "신작 웹툰 같이 봐요! 😉"', 0, 1, 1);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (28, TO_TIMESTAMP('2024-06-06 11:00:00','YYYY-MM-DD HH24:MI:SS'), '힙합꿈나무18(윤서아)님이 회원님의 댓글을 좋아합니다. 💯', 0, 4, 4);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (29, TO_TIMESTAMP('2024-06-06 14:30:00','YYYY-MM-DD HH24:MI:SS'), '새싹개발자15(박현우)님이 회원님의 코딩 꿀팁 대방출! ✨ 노트를 북마크했습니다.', 1, 17, 17);
INSERT INTO notification (notifi_idx, time, text, chk, ac_idx, setting_idx) VALUES (30, TO_TIMESTAMP('2024-06-06 17:00:00','YYYY-MM-DD HH24:MI:SS'), '게임스트리머19(최민식)님이 새로운 워치파티 신작 게임 함께 달려요! 🔥를 생성했습니다.', 0, 11, 11);

-- 12. bookmark 테이블 데이터 삽입 (bkmark_idx: 301 ~ 350)
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (1, 1, 3, TO_TIMESTAMP('2024-06-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (2, 2, 1, TO_TIMESTAMP('2024-06-01 09:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (3, 3, 5, TO_TIMESTAMP('2024-06-01 09:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (4, 4, 2, TO_TIMESTAMP('2024-06-01 09:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (5, 5, 4, TO_TIMESTAMP('2024-06-01 09:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (6, 6, 6, TO_TIMESTAMP('2024-06-01 09:25:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (7, 7, 8, TO_TIMESTAMP('2024-06-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (8, 8, 7, TO_TIMESTAMP('2024-06-01 09:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (9, 9, 9, TO_TIMESTAMP('2024-06-01 09:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (10, 10, 10, TO_TIMESTAMP('2024-06-01 09:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (11, 11, 01, TO_TIMESTAMP('2024-06-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (12, 12, 04, TO_TIMESTAMP('2024-06-02 10:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (13, 13, 06, TO_TIMESTAMP('2024-06-02 10:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (14, 14, 08, TO_TIMESTAMP('2024-06-02 10:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (15, 15, 10, TO_TIMESTAMP('2024-06-02 10:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (16, 16, 11, TO_TIMESTAMP('2024-06-02 10:25:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (17, 17, 13, TO_TIMESTAMP('2024-06-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (18, 8, 15, TO_TIMESTAMP('2024-06-02 10:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (19, 19, 17, TO_TIMESTAMP('2024-06-02 10:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (20, 20, 19, TO_TIMESTAMP('2024-06-02 10:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (21, 21, 21, TO_TIMESTAMP('2024-06-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (22, 22, 23, TO_TIMESTAMP('2024-06-03 11:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (23, 23, 25, TO_TIMESTAMP('2024-06-03 11:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (24, 24, 2, TO_TIMESTAMP('2024-06-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (25, 25, 5, TO_TIMESTAMP('2024-06-03 11:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (26, 26, 7, TO_TIMESTAMP('2024-06-03 11:25:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (27, 27, 9, TO_TIMESTAMP('2024-06-03 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (28, 1, 12, TO_TIMESTAMP('2024-06-03 11:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (29, 2, 14, TO_TIMESTAMP('2024-06-03 11:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (30, 3, 16, TO_TIMESTAMP('2024-06-03 11:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (31, 4, 18, TO_TIMESTAMP('2024-06-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (32, 5, 20, TO_TIMESTAMP('2024-06-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (33, 6, 22, TO_TIMESTAMP('2024-06-04 12:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (34, 7, 24, TO_TIMESTAMP('2024-06-04 12:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (35, 8, 1, TO_TIMESTAMP('2024-06-04 12:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (36, 9, 3, TO_TIMESTAMP('2024-06-04 12:25:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (37, 10, 5, TO_TIMESTAMP('2024-06-04 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (38, 11, 7, TO_TIMESTAMP('2024-06-04 12:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (39, 12, 9, TO_TIMESTAMP('2024-06-04 12:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (40, 13, 11, TO_TIMESTAMP('2024-06-04 12:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (41, 14, 13, TO_TIMESTAMP('2024-06-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (42, 15, 15, TO_TIMESTAMP('2024-06-05 13:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (43, 16, 17, TO_TIMESTAMP('2024-06-05 13:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (44, 17, 19, TO_TIMESTAMP('2024-06-05 13:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (45, 18, 21, TO_TIMESTAMP('2024-06-05 13:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (46, 19, 23, TO_TIMESTAMP('2024-06-05 13:25:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (47, 20, 25, TO_TIMESTAMP('2024-06-05 13:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (48, 21, 2, TO_TIMESTAMP('2024-06-05 13:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (49, 22, 4, TO_TIMESTAMP('2024-06-05 13:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO bookmark (bkmark_idx, userPg_idx, ac_idx, created_at) VALUES (50, 23, 6, TO_TIMESTAMP('2024-06-05 13:45:00', 'YYYY-MM-DD HH24:MI:SS'));


-- 13. likes 테이블 데이터 삽입
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (1, TO_TIMESTAMP('2024-05-20 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 2);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (2, TO_TIMESTAMP('2024-05-20 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (3, TO_TIMESTAMP('2024-05-21 09:35:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 4);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (4, TO_TIMESTAMP('2024-05-21 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (5, TO_TIMESTAMP('2024-05-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (6, TO_TIMESTAMP('2024-05-22 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (7, TO_TIMESTAMP('2024-05-22 14:35:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (8, TO_TIMESTAMP('2024-05-22 19:05:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 9);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (9, TO_TIMESTAMP('2024-05-23 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 6);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (10, TO_TIMESTAMP('2024-05-23 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 6);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (11, TO_TIMESTAMP('2024-05-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 4);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (12, TO_TIMESTAMP('2024-03-31 20:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (13, TO_TIMESTAMP('2024-04-01 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 8);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (14, TO_TIMESTAMP('2024-04-02 09:55:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (15, TO_TIMESTAMP('2024-04-03 21:05:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (16, TO_TIMESTAMP('2024-04-10 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (17, TO_TIMESTAMP('2024-04-11 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (18, TO_TIMESTAMP('2024-04-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (19, TO_TIMESTAMP('2024-04-13 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (20, TO_TIMESTAMP('2024-04-14 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 2);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (21, TO_TIMESTAMP('2024-04-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 25, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (22, TO_TIMESTAMP('2024-04-16 16:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 2);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (23, TO_TIMESTAMP('2024-04-17 17:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (24, TO_TIMESTAMP('2024-04-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 31, 4);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (25, TO_TIMESTAMP('2024-04-19 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 25, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (26, TO_TIMESTAMP('2024-04-20 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 35, 6);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (27, TO_TIMESTAMP('2024-04-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (28, TO_TIMESTAMP('2024-04-22 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 8);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (29, TO_TIMESTAMP('2024-04-23 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 27, 9);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (30, TO_TIMESTAMP('2024-04-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 20);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (31, TO_TIMESTAMP('2024-04-25 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 25, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (32, TO_TIMESTAMP('2024-04-25 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (33, TO_TIMESTAMP('2024-04-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 4);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (34, TO_TIMESTAMP('2024-04-25 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), 23, 4);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (35, TO_TIMESTAMP('2024-04-25 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), 25, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (36, TO_TIMESTAMP('2024-05-20 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 6);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (37, TO_TIMESTAMP('2024-05-20 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 8);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (38, TO_TIMESTAMP('2024-05-21 09:40:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (39, TO_TIMESTAMP('2024-05-21 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (40, TO_TIMESTAMP('2024-05-21 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (41, TO_TIMESTAMP('2024-05-22 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 7);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (42, TO_TIMESTAMP('2024-05-22 14:40:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 9);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (43, TO_TIMESTAMP('2024-05-22 19:10:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (44, TO_TIMESTAMP('2024-05-23 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (45, TO_TIMESTAMP('2024-05-23 11:40:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (46, TO_TIMESTAMP('2024-05-23 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (47, TO_TIMESTAMP('2024-03-31 20:10:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 3);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (48, TO_TIMESTAMP('2024-04-01 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 5);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (49, TO_TIMESTAMP('2024-04-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 9);
INSERT INTO likes (likes_idx, created_at, note_idx, ac_idx) VALUES  (50, TO_TIMESTAMP('2024-04-03 21:10:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2);

-- 14. noteAccess 테이블 데이터 삽입
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (1, 'R', TO_TIMESTAMP('2024-06-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (2, 'RW', TO_TIMESTAMP('2024-06-01 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 2);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (3, 'R', TO_TIMESTAMP('2024-06-01 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 3);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (4, 'RWX', TO_TIMESTAMP('2024-06-01 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 4);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (5, 'R', TO_TIMESTAMP('2024-06-01 09:20:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 5);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (6, 'RW', TO_TIMESTAMP('2024-06-01 09:25:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 6);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (7, 'RWX', TO_TIMESTAMP('2024-06-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 7);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (8, 'R', TO_TIMESTAMP('2024-06-01 09:35:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 8);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (9, 'RW', TO_TIMESTAMP('2024-06-01 09:40:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 9);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (10, 'R', TO_TIMESTAMP('2024-06-01 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 10);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (11, 'RWX', TO_TIMESTAMP('2024-06-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 1);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (12, 'R', TO_TIMESTAMP('2024-06-02 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (13, 'RW', TO_TIMESTAMP('2024-06-02 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (14, 'RWX', TO_TIMESTAMP('2024-06-02 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (15, 'R', TO_TIMESTAMP('2024-06-02 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (16, 'RW', TO_TIMESTAMP('2024-06-02 10:25:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 6);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (17, 'RWX', TO_TIMESTAMP('2024-06-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 7);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (18, 'R', TO_TIMESTAMP('2024-06-02 10:35:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 8);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (19, 'RW', TO_TIMESTAMP('2024-06-02 10:40:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 9);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (20, 'RWX', TO_TIMESTAMP('2024-06-02 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 10);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (21, 'R', TO_TIMESTAMP('2024-06-03 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 11);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (22, 'RW', TO_TIMESTAMP('2024-06-03 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 12);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (23, 'RWX', TO_TIMESTAMP('2024-06-03 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 13);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (24, 'R', TO_TIMESTAMP('2024-06-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 14);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (25, 'RW', TO_TIMESTAMP('2024-06-03 11:20:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 15);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (26, 'RWX', TO_TIMESTAMP('2024-06-03 11:25:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 16);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (27, 'R', TO_TIMESTAMP('2024-06-03 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 14, 17);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (28, 'RW', TO_TIMESTAMP('2024-06-03 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), 14, 18);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (29, 'RWX', TO_TIMESTAMP('2024-06-03 11:40:00', 'YYYY-MM-DD HH24:MI:SS'), 15, 19);
INSERT INTO noteAccess (ntGrant_idx, ntGrant, created_at, note_idx, ac_idx) VALUES  (30, 'R', TO_TIMESTAMP('2024-06-03 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), 15, 20);


-- 15. commentlist 테이블 데이터 삽입
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (1, '이 영화 정말 최고예요! 👍 N차 관람 각입니다!', 25, TO_TIMESTAMP('2024-05-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 1, 8);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (2, '저도 그렇게 생각해요! 특히 마지막 장면이 인상 깊었어요.', 15, TO_TIMESTAMP('2024-05-25 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 6);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (3, '이 드라마 완전 내 스타일! 주인공 너무 멋있다 ㅠㅠ🥰', 30, TO_TIMESTAMP('2024-05-25 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 2, 4);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (4, '맞아요! 다음 화 너무 기대돼요!', 12, TO_TIMESTAMP('2024-05-25 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 2, 10);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (5, 'K-POP 신곡 나왔다! 🎧 다들 들어보셨나요? 완전 좋아요!', 40, TO_TIMESTAMP('2024-05-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 3, 12);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (6, '노래 너무 좋아서 계속 반복 재생 중이에요!', 18, TO_TIMESTAMP('2024-05-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 3, 3);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (7, '이 애니메이션 캐릭터 너무 귀여워요! 굿즈 사고 싶다 ✨', 22, TO_TIMESTAMP('2024-05-25 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 4, 11);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (8, '맞아요! 저도 그 캐릭터 제일 좋아해요!', 10, TO_TIMESTAMP('2024-05-25 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 18);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (9, '오늘 날씨 진짜 좋다! 이런 날엔 역시 산책이지~ 🚶‍♀️', 17, TO_TIMESTAMP('2024-05-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 5, 15);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (10, 'SF 영화는 역시 극장에서 봐야 제맛이죠! 웅장함이 달라요.', 28, TO_TIMESTAMP('2024-05-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 6, 6);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (11, '이 힙합 비트 중독성 장난 아니네요! 🤘 저도 랩 배우고 싶어요!', 33, TO_TIMESTAMP('2024-05-25 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 7, 22);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (12, '시트콤 보면서 엄청 웃었네 ㅋㅋㅋ 스트레스 확 풀린다!', 19, TO_TIMESTAMP('2024-05-25 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 8, 9);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (13, '스릴러 영화 반전 대박! 😮 전혀 예상 못 했어요!', 26, TO_TIMESTAMP('2024-05-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 9, 24);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (14, '판타지 애니메이션은 역시 세계관 보는 재미죠! 다음 내용 궁금해 🤔', 14, TO_TIMESTAMP('2024-05-25 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 10, 1);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (15, '저도 이 영화 N차 찍었습니다! 볼 때마다 새로운 감동이 있어요.', 20, TO_TIMESTAMP('2024-05-25 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1,12);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (16, '이 드라마 명대사 너무 많아요... 필사하고 싶을 정도!', 11, TO_TIMESTAMP('2024-05-25 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 2, 8);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (17, '오늘 이 노래 무한 반복 각입니다! 🎶 너무 신나요!', 35, TO_TIMESTAMP('2024-05-25 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 3, 4);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (18, '이 캐릭터 피규어 나오면 바로 살 거예요! 💖 제발 만들어주세요!', 23, TO_TIMESTAMP('2024-05-25 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 15);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (19, '오늘 같은 날씨엔 공원에서 치맥인데... 같이 갈 사람? 🍻', 16, TO_TIMESTAMP('2024-05-25 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 5, 7);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (20, '영화의 영상미가 정말 아름다웠어요. 한 장면 한 장면이 그림 같아요.', 27, TO_TIMESTAMP('2024-05-25 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 6, 14);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (21, '저도 랩 메이킹 도전해보고 싶네요! 이 비트에 가사 써봐야지! 🔥', 31, TO_TIMESTAMP('2024-05-25 16:10:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 7, 1);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (22, '이 시트콤은 모든 캐릭터가 다 사랑스러워요! 시즌2 갑시다!', 17, TO_TIMESTAMP('2024-05-25 17:10:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 8, 18);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (23, '마지막 반전 때문에 소름 돋았어요! 😱 친구한테도 추천해야지!', 24, TO_TIMESTAMP('2024-05-25 18:10:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 9, 11);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (24, '이 애니메이션은 작화가 정말 예술이에요. 프레임 단위로 보고 싶을 정도.', 13, TO_TIMESTAMP('2024-05-25 19:10:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 10, 19);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (25, '저도요! 특히 전투씬 연출이 대박이었어요! 💥', 10, TO_TIMESTAMP('2024-05-25 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 24, 10, 4);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (26, '이 영화는 두 번, 세 번 봐도 질리지 않을 것 같아요. 👍', 22, TO_TIMESTAMP('2024-05-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 11, 6);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (27, '주인공들의 감정선이 너무 섬세해서 몰입해서 봤습니다.', 12, TO_TIMESTAMP('2024-05-26 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 13, 8);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (28, '요즘 이 노래 안 듣는 사람 없죠? 멜론 TOP100 진입 기원! 🙏', 38, TO_TIMESTAMP('2024-05-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 18, 13);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (29, '이 웹툰 인생작 등극! 🎉 그림체, 스토리, 캐릭터 다 완벽해요!', 29, TO_TIMESTAMP('2024-05-26 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 14, 15);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (30, '오늘 하루도 수고했어요! 😌 이 애니 보면서 힐링해야지~', 18, TO_TIMESTAMP('2024-05-26 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 15, 17);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (31, '영화 속 미래 기술들이 정말 현실이 될까요? 🤔 상상만 해도 신기하네요.', 21, TO_TIMESTAMP('2024-05-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 16, 2);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (32, '이 힙합 트랙 비트가 너무 좋아요! 저절로 몸이 움직여지네요! 🎶', 36, TO_TIMESTAMP('2024-05-26 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 20, 7);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (33, '일상툰은 역시 공감 백배! ㅋㅋㅋ 완전 내 얘기 같아 😂', 15, TO_TIMESTAMP('2024-05-26 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 8, 21);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (34, '영화의 결말, 당신의 선택은? 저는 해피엔딩이 좋아요!', 20, TO_TIMESTAMP('2024-05-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 21, 23);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (35, '이 애니메이션 덕분에 판타지 장르에 입문했어요! ✨ 다른 작품도 추천해주세요!', 11, TO_TIMESTAMP('2024-05-26 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 25, 1);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (36, '대댓글입니다! 영화 너무 재밌었어요! 🚀', 8, TO_TIMESTAMP('2024-05-25 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 4);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (37, '완전 공감! OST 매일 듣고 있어요!', 9, TO_TIMESTAMP('2024-05-25 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 2, 4);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (38, '저도 이 노래 챌린지 참여했어요! ㅋㅋㅋ 생각보다 어렵더라구요 😅', 20, TO_TIMESTAMP('2024-05-25 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 3, 5);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (39, '이 캐릭터 때문에 애니 정주행 시작합니다! 너무 귀여워요! 💖', 13, TO_TIMESTAMP('2024-05-25 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 7);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (40, '일상툰 보면서 오늘 하루 피로가 싹 가셨어요! 감사해요 작가님! 😊', 10, TO_TIMESTAMP('2024-05-25 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 5, 1);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (41, '영화의 메시지가 정말 깊이 와닿았어요. 여운이 오래가네요.', 17, TO_TIMESTAMP('2024-05-25 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 6, 24);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (42, '저도 이 비트에 랩 한번 써봤는데... 역시 어렵네요 ㅠㅠ 대단해요! 👍', 25, TO_TIMESTAMP('2024-05-25 16:15:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 7, 13);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (43, '이 시트콤은 웃음과 감동을 동시에 주는 것 같아요! 😄', 12, TO_TIMESTAMP('2024-05-25 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 8, 5);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (44, '저는 다른 결말을 상상해봤는데... 그것도 괜찮을 것 같아요! 🤔', 18, TO_TIMESTAMP('2024-05-25 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 9, 8);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (45, '판타지 세계관은 정말 무궁무진한 것 같아요! 작가님 상상력 최고! ✨', 9, TO_TIMESTAMP('2024-05-25 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 24, 10, 17);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (46, '이 영화 보고 나서 액션 배우가 되고 싶어졌어요! 🔥 너무 멋져요!', 14, TO_TIMESTAMP('2024-05-26 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 11, 19);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (47, '드라마 속 명대사 때문에 밤새 설렜어요... 💖', 10, TO_TIMESTAMP('2024-05-26 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 13, 21);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (48, '역시 믿고 듣는 아이돌! 이번 앨범도 전곡 다 좋아요! 💯', 30, TO_TIMESTAMP('2024-05-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 18, 23);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (49, '이 웹툰 완결나면 한번에 정주행 하려고 기다리고 있어요! 너무 기대돼요! 🎉', 20, TO_TIMESTAMP('2024-05-26 13:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 14, 25);
INSERT INTO commentlist (commentlist_idx, text, like_count, create_at, re_commentlist_idx, note_idx, ac_idx) VALUES (50, '이런 애니메이션 더 많이 나왔으면 좋겠어요! 힐링 그 자체! 😌', 12, TO_TIMESTAMP('2024-05-26 14:05:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 15, 2);

commit;

-- 16. watchParty 테이블 데이터 삽입 (watchParty_idx: 1 ~ 20)
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 1, '우주 대전쟁 시청 파티',            'vid001', TO_TIMESTAMP('2024-06-01 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  1);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 2, '심장이 멎을 듯한 로맨스 감상',      'vid002', TO_TIMESTAMP('2024-06-02 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  2);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 3, 'K-POP 논스톱 리믹스 파티',          'vid003', TO_TIMESTAMP('2024-06-03 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  3);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 4, '시간여행자 애니 어드벤처 정주행',   'vid004', TO_TIMESTAMP('2024-06-04 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  4);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 5, '일상 브이로그 감상 모임',            'vid005', TO_TIMESTAMP('2024-06-05 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  5);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 6, 'AI 대결 SF 토론 파티',              'vid006', TO_TIMESTAMP('2024-06-06 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  6);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 7, '쇼미더비트 파이널 직관 회고',        'vid007', TO_TIMESTAMP('2024-06-07 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  7);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 8, '일상 코믹 시트콤 옆집 사람들 함께 보기', 'vid008', TO_TIMESTAMP('2024-06-08 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  8);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES ( 9, '스릴러 사라진 기억 분석회',          'vid009', TO_TIMESTAMP('2024-06-09 20:00:00', 'YYYY-MM-DD HH24:MI:SS'),  9);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (10, '판타지 드래곤 슬레이어 액션 모음',    'vid010', TO_TIMESTAMP('2024-06-10 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (11, '미래 도시의 그림자 리뷰',            'vid011', TO_TIMESTAMP('2024-06-11 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (12, '캠퍼스 로맨틱 코미디 정주행',       'vid012', TO_TIMESTAMP('2024-06-12 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (13, '인디 밴드 명곡 플레이리스트 감상',     'vid013', TO_TIMESTAMP('2024-06-13 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 13);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (14, '무협 액션 절대고수 하이라이트',        'vid014', TO_TIMESTAMP('2024-06-14 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 14);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (15, '판타지 애니 이세계 전생 파티',        'vid015', TO_TIMESTAMP('2024-06-15 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 15);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (16, '사이버펑크 코드 제로 토론',           'vid016', TO_TIMESTAMP('2024-06-16 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 16);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (17, '감성 발라드 새벽 감성 플레이리스트',   'vid017', TO_TIMESTAMP('2024-06-17 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 17);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (18, '육아 드라마 슈퍼맘 다이어리 공감회',   'vid018', TO_TIMESTAMP('2024-06-18 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 18);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (19, '학원 미스터리 학교의 비밀 탐구',      'vid019', TO_TIMESTAMP('2024-06-19 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 19);
INSERT INTO watchParty (watchParty_idx, title, video_id, created_at, host) VALUES (20, '메카 워리어즈 로봇 액션 토크',        'vid020', TO_TIMESTAMP('2024-06-20 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 20);

COMMIT;

INSERT ALL
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  1,  0.000, 'PLAY',  1)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  2, 15.000, 'PAUSE', 1)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  3, 30.000, 'PLAY',  1)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  4, 45.000, 'PAUSE', 1)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  5, 60.000, 'PLAY',  1)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  6,  0.000, 'PLAY',  2)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  7, 15.000, 'PAUSE', 2)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  8, 30.000, 'PLAY',  2)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES (  9, 45.000, 'PAUSE', 2)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 10, 60.000, 'PLAY',  2)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 11,  0.000, 'PLAY',  3)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 12, 15.000, 'PAUSE', 3)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 13, 30.000, 'PLAY',  3)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 14, 45.000, 'PAUSE', 3)
  INTO wa_sync (sync_idx, timeline, play, watchParty_idx) VALUES ( 15, 60.000, 'PLAY',  3)
SELECT * FROM dual;


-- 16-2. wa_comment 테이블 데이터 삽입 (wac_idx: 1 ~ 40, 각 watchParty에 2개씩)
INSERT ALL
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 1, '날쎈돌이16',    '시작부터 재미있네요!',      5.000,  1)
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 2, '영화광팬',      '이 부분이 특히 인상적이에요!', 55.000, 1)
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 3, '음악없인못살아','시작부터 재미있네요!',      5.000,  2)
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 4, '웹툰장인17',    '이 부분이 특히 인상적이에요!', 55.000, 2)
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 5, '드라마덕후',    '시작부터 재미있네요!',      5.000,  3)
  INTO wa_comment (wac_idx, nickname, chatting, timeline, watchParty_idx) VALUES ( 6, 'SF매니아',      '이 부분이 특히 인상적이에요!', 55.000, 3)
SELECT * FROM dual;

COMMIT;

-- 17. workspace_blocks 테이블 데이터 삽입
-- 사용자 1번의 블록 데이터
-- 1. 카테고리 인기글 (카테고리 ID: 1, 이름: 영화)
INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config)
VALUES (1, 1, 'CategoryPosts', 1, '{"category_idx":1,"category_name":"영화","sort_type":"popular"}');

-- 2. 사용자 활동 통계
INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config)
VALUES (2, 1, 'UserStats', 2, '{}');

-- 3. 구독 워치파티
INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config)
VALUES (3, 1, 'WatchParties', 3, '{}');


-- 사용자 2번의 블록 데이터
-- 1. 구독 워치파티
INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config)
VALUES (4, 2, 'WatchParties', 1, '{}');

-- 2. 카테고리 최신글 (카테고리 ID: 3, 이름: 음악)
INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config)
VALUES (5, 2, 'CategoryPosts', 2, '{"category_idx":3,"category_name":"음악","sort_type":"latest"}');

-- 커밋
COMMIT;