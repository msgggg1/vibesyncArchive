-- Netflix 오라클 계정 (ID: netflix, PW: 1234)
CREATE TABLE board (
    id           int not null PRIMARY KEY,
    title        VARCHAR2(200) NOT NULL,
    content      CLOB             NOT NULL,
    images       VARCHAR2(2000),           -- 이미지 경로를 구분자(;)로 이어붙인 문자열
    created_at   TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
/
CREATE OR REPLACE TRIGGER board_bir
BEFORE INSERT ON board
FOR EACH ROW
BEGIN
  SELECT board_seq.NEXTVAL
  INTO :new.id
  FROM dual;
END;
/