-- Netflix ����Ŭ ���� (ID: netflix, PW: 1234)
CREATE TABLE board (
    id           int not null PRIMARY KEY,
    title        VARCHAR2(200) NOT NULL,
    content      CLOB             NOT NULL,
    images       VARCHAR2(2000),           -- �̹��� ��θ� ������(;)�� �̾���� ���ڿ�
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