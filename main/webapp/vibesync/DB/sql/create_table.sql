--------------------------------------------------------------------------------
-- 테이블 삭제 (제약조건 순서에 유의)
--------------------------------------------------------------------------------
DROP TABLE schedule;
DROP TABLE commentlist;
DROP TABLE noteAccess;
DROP TABLE likes;
DROP TABLE bookmark;
DROP TABLE notification;
DROP TABLE note;
DROP TABLE follows;
DROP TABLE todolist;
DROP TABLE message;
DROP TABLE setting;
DROP TABLE userPage;
DROP TABLE contents;
DROP TABLE genre;
DROP TABLE wa_sync;
DROP TABLE wa_comment;
DROP TABLE watchParty;
DROP TABLE userAccount;
DROP TABLE category;


--------------------------------------------------------------------------------
-- 1. category (카테고리)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE category (
    category_idx INT PRIMARY KEY,
    c_name VARCHAR2(100) NOT NULL,
    img varchar(255) not null
);

--------------------------------------------------------------------------------
-- 2. userAccount (계정)
--------------------------------------------------------------------------------
CREATE TABLE userAccount (
    ac_idx INT PRIMARY KEY,
    email VARCHAR2(255) NOT NULL UNIQUE,
    pw VARCHAR2(255) NOT NULL,
    salt varchar2(255),
    nickname VARCHAR2(50) NOT NULL,
    img VARCHAR2(255),
    name VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP default sysdate,
    category_idx int not null,
    CONSTRAINT fk_uc FOREIGN KEY (category_idx) REFERENCES category(category_idx) ON DELETE CASCADE
);
--------------------------------------------------------------------------------
-- 3. genre (장르)
--------------------------------------------------------------------------------
CREATE TABLE genre (
    genre_idx INT PRIMARY KEY,
    gen_name VARCHAR2(100) NOT NULL
);

--------------------------------------------------------------------------------
-- 4. contents (콘텐츠)
--------------------------------------------------------------------------------
CREATE TABLE contents (
    content_idx INT PRIMARY KEY,
    title VARCHAR2(255),
    img VARCHAR2(255),
    dsc CLOB,
    category_idx INT NOT NULL,
    CONSTRAINT FK_contents_TO_category FOREIGN KEY (category_idx) REFERENCES category(category_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 5. userPage (페이지)
--------------------------------------------------------------------------------
CREATE TABLE userPage (
    userPg_idx INT PRIMARY KEY,
    subject VARCHAR2(100),
    thumbnail VARCHAR2(255),
    created_at TIMESTAMP DEFAULT SYSDATE,
    ac_idx INT NOT NULL,
    re_userPg_idx INT,
    CONSTRAINT FK_userPage_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_userPage_TO_userPage FOREIGN KEY (re_userPg_idx) REFERENCES userPage(userPg_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 6. setting (설정)
--------------------------------------------------------------------------------
CREATE TABLE setting (
    setting_idx INT PRIMARY KEY,
    font VARCHAR2(100) NOT NULL,
    theme VARCHAR2(50) NOT NULL,
    noti VARCHAR2(50) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_setting_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 8. message (메시지)
--------------------------------------------------------------------------------
CREATE TABLE message (
    msg_idx INT PRIMARY KEY,
    text CLOB not null,
    time TIMESTAMP NOT NULL,
    img VARCHAR2(255),
    chk NUMBER(1) NOT NULL,
    ac_receiver INT NOT NULL,
    ac_sender INT NOT NULL,
    CONSTRAINT FK_message_TO_userAccount_rcvr FOREIGN KEY (ac_receiver) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_message_TO_userAccount_sndr FOREIGN KEY (ac_sender) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 9. todolist (투두리스트)
--------------------------------------------------------------------------------
CREATE TABLE todolist (
    todo_idx INT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    text CLOB not null,
    todo_group VARCHAR2(100) NOT NULL,
    color VARCHAR2(100) NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_todolist_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 10. follows (팔로우목록)
--------------------------------------------------------------------------------
CREATE TABLE follows (
    follows_idx INT PRIMARY KEY,
    ac_follow INT NOT NULL,
    ac_following INT NOT NULL,
    CONSTRAINT FK_follows_TO_userAccountFw FOREIGN KEY (ac_follow) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_follows_TO_userAccountFwing FOREIGN KEY (ac_following) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 11. note (글)
--------------------------------------------------------------------------------
CREATE TABLE note (
    note_idx INT PRIMARY KEY,
    title varchar2(2000),
    text CLOB not null,
    img CLOB,
    create_at TIMESTAMP,
    edit_at TIMESTAMP,
    view_count INT DEFAULT 0,
    titleimg clob,
    content_idx INT NOT NULL,
    genre_idx INT NOT NULL,
    category_idx int not null,
    userPg_idx int not null,
    CONSTRAINT FK_note_TO_contents FOREIGN KEY (content_idx) REFERENCES contents(content_idx) ON DELETE CASCADE,
    CONSTRAINT FK_note_TO_genre FOREIGN KEY (genre_idx) REFERENCES genre(genre_idx) ON DELETE CASCADE,
    CONSTRAINT FK_nc FOREIGN KEY (category_idx) REFERENCES category(category_idx) ON DELETE CASCADE,
    CONSTRAINT FK_np FOREIGN KEY (userPg_idx) REFERENCES userPage(userPg_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 12. notification (알람)
--------------------------------------------------------------------------------
CREATE TABLE notification (
    notifi_idx INT PRIMARY KEY,
    time TIMESTAMP NOT NULL,
    text CLOB not null,
    chk NUMBER(1) NOT NULL,
    ac_idx INT NOT NULL,
    setting_idx INT,
    CONSTRAINT FK_notification_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE,
    CONSTRAINT FK_notification_TO_setting FOREIGN KEY (setting_idx) REFERENCES setting(setting_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 13. bookmark (북마크)
--------------------------------------------------------------------------------
CREATE TABLE bookmark (
    bkmark_idx INT PRIMARY KEY,
    userPg_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT FK_bookmark_TO_userPage FOREIGN KEY (userPg_idx) REFERENCES userPage(userPg_idx) ON DELETE CASCADE,
    CONSTRAINT FK_bookmark_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 14. likes (좋아요)
--------------------------------------------------------------------------------
CREATE TABLE likes (
    likes_idx INT PRIMARY KEY,
    created_at TIMESTAMP default sysdate,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_likes_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_likes_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 15. noteAccess (노트 권한 리스트)
--------------------------------------------------------------------------------
CREATE TABLE noteAccess (
    ntGrant_idx INT PRIMARY KEY,
    ntGrant CHAR(3),
    created_at TIMESTAMP,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    CONSTRAINT FK_noteAccess_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_noteAccess_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 16. commentlist (댓글)
--------------------------------------------------------------------------------
CREATE TABLE commentlist (
    commentlist_idx INT PRIMARY KEY,
    text CLOB NOT NULL,
    like_count INT,
    create_at TIMESTAMP DEFAULT SYSDATE,
    re_commentlist_idx INT,
    note_idx INT NOT NULL,
    ac_idx INT NOT NULL,
    depth INT DEFAULT 1 NOT NULL, -- [추가] 댓글 깊이 컬럼
    CONSTRAINT FK_comment_TO_comment FOREIGN KEY (re_commentlist_idx) REFERENCES commentlist(commentlist_idx) ON DELETE CASCADE,
    CONSTRAINT FK_comment_TO_note FOREIGN KEY (note_idx) REFERENCES note(note_idx) ON DELETE CASCADE,
    CONSTRAINT FK_comment_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 7. watchParty (워치파티)
--------------------------------------------------------------------------------
CREATE TABLE watchParty (
    watchParty_idx INT PRIMARY KEY,
    title varchar2(1000),
    video_id VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSDATE,
    host INT NOT NULL,
    CONSTRAINT FK_wu FOREIGN KEY (host) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

CREATE TABLE wa_sync (
    sync_idx INT PRIMARY KEY,
    timeline number(10, 3),
    play VARCHAR2(10),
    watchParty_idx int NOT NULL,
    CONSTRAINT FK_sw FOREIGN KEY (watchParty_idx) REFERENCES watchParty(watchParty_idx) ON DELETE CASCADE
);

CREATE TABLE wa_comment (
    wac_idx INT PRIMARY KEY,
    nickname varchar(100),
    chatting CLOB,
    timeline number(10, 3),
    create_at TIMESTAMP default sysdate,
    watchParty_idx int NOT NULL,
    CONSTRAINT FK_cw FOREIGN KEY (watchParty_idx) REFERENCES watchParty(watchParty_idx) ON DELETE CASCADE
);
--------------------------------------------------------------------------------
-- (추가) schedule (일정 관리) 테이블
--------------------------------------------------------------------------------
CREATE TABLE schedule (
    schedule_idx    INT             PRIMARY KEY,
    title           VARCHAR2(255)   NOT NULL,         -- 일정 제목
    description     CLOB,                             -- 상세 내용
    start_time      TIMESTAMP       NOT NULL,         -- 시작 시간
    end_time        TIMESTAMP       NOT NULL,         -- 종료 시간
    color           VARCHAR2(100),                    -- 캘린더에 표시될 색상 (선택 사항)
    ac_idx          INT             NOT NULL,         -- 일정을 등록한 사용자 ID
    CONSTRAINT FK_schedule_TO_userAccount FOREIGN KEY (ac_idx) REFERENCES userAccount(ac_idx) ON DELETE CASCADE
);

SELECT COUNT(*)
FROM USER_TABLES;