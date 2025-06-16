
--------------------------------------------------------------------------------
-- 시퀀스 삭제
--------------------------------------------------------------------------------
DROP SEQUENCE schedule_seq;
DROP SEQUENCE workspace_blocks_seq;
DROP SEQUENCE commentlist_seq;
DROP SEQUENCE noteAccess_seq;
DROP SEQUENCE likes_seq;
DROP SEQUENCE bookmark_seq;
DROP SEQUENCE notification_seq;
DROP SEQUENCE note_seq;
DROP SEQUENCE follows_seq;
DROP SEQUENCE todolist_seq;
DROP SEQUENCE message_seq;
DROP SEQUENCE watchParty_seq;
DROP SEQUENCE setting_seq;
DROP SEQUENCE userPage_seq;
DROP SEQUENCE contents_seq;
DROP SEQUENCE genre_seq;
DROP SEQUENCE useraccount_seq;
DROP SEQUENCE category_seq;
DROP SEQUENCE seq_watchparty;
DROP SEQUENCE seq_wa_sync;
DROP SEQUENCE seq_wa_comment;

--------------------------------------------------------------------------------
-- 시퀀스 생성
--------------------------------------------------------------------------------
-- 1. category
CREATE SEQUENCE category_seq
  START WITH 6      -- 이후 실제 MAX(category_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 2. userAccount
CREATE SEQUENCE useraccount_seq
  START WITH 26      -- 이후 실제 MAX(ac_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 3. genre
CREATE SEQUENCE genre_seq
  START WITH 12      -- 이후 실제 MAX(genre_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 4. contents
CREATE SEQUENCE contents_seq
  START WITH 26      -- 이후 실제 MAX(content_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 5. userPage
CREATE SEQUENCE userPage_seq
  START WITH 28      -- 이후 실제 MAX(userPg_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 6. setting
CREATE SEQUENCE setting_seq
  START WITH 26      -- 이후 실제 MAX(setting_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 7. watchParty
CREATE SEQUENCE watchParty_seq
  START WITH 1      -- 이후 실제 MAX(watchParty_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 8. message
CREATE SEQUENCE message_seq
  START WITH 49      -- 이후 실제 MAX(msg_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 9. todolist
CREATE SEQUENCE todolist_seq
  START WITH 31      -- 이후 실제 MAX(todo_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 10. follows
CREATE SEQUENCE follows_seq
  START WITH 51      -- 이후 실제 MAX(follows_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 11. note
CREATE SEQUENCE note_seq
  START WITH 36      -- 이후 실제 MAX(note_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 12. notification
CREATE SEQUENCE notification_seq
  START WITH 31      -- 이후 실제 MAX(notifi_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 13. bookmark
CREATE SEQUENCE bookmark_seq
  START WITH 51      -- 이후 실제 MAX(bkmark_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 14. likes
CREATE SEQUENCE likes_seq
  START WITH 51      -- 이후 실제 MAX(likes_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 15. noteAccess
CREATE SEQUENCE noteAccess_seq
  START WITH 31      -- 이후 실제 MAX(ntGrant_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 16. commentlist
CREATE SEQUENCE commentlist_seq
  START WITH 51      -- 이후 실제 MAX(commentlist_idx)+1 로 조정
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
  -- 1) watchParty 시퀀스
CREATE SEQUENCE seq_watchparty
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 2) wa_sync 시퀀스
CREATE SEQUENCE seq_wa_sync
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 3) wa_comment 시퀀스
CREATE SEQUENCE seq_wa_comment
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
-- 19. schedule 시퀀스
CREATE SEQUENCE schedule_seq 
	START WITH 31
    INCREMENT BY 1
	NOCACHE
    NOCYCLE;
 
-- workspace_blocks
CREATE SEQUENCE workspace_blocks_seq
    START WITH 6     -- 이후 실제 MAX(block_id)+1 로 조정
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

SELECT COUNT(*) AS sequence_count FROM user_sequences;

--------------------------------------------------------------------------------
-- 트리거 삭제 => userAccount테이블 제외
--------------------------------------------------------------------------------
DROP TRIGGER trg_schedule_bi;
DROP TRIGGER trg_commentlist_bi;
DROP TRIGGER trg_noteAccess_bi;
DROP TRIGGER trg_likes_bi;
DROP TRIGGER trg_bookmark_bi;
DROP TRIGGER trg_notification_bi;
DROP TRIGGER trg_note_bi;
DROP TRIGGER trg_follows_bi;
DROP TRIGGER trg_todolist_bi;
DROP TRIGGER trg_message_bi;
DROP TRIGGER trg_watchParty_bi;
DROP TRIGGER trg_setting_bi;
DROP TRIGGER trg_userPage_bi;
DROP TRIGGER trg_contents_bi;
DROP TRIGGER trg_genre_bi;
DROP TRIGGER trg_category_bi;
DROP TRIGGER trg_watchParty_pk;
DROP TRIGGER trg_wa_sync_pk;
DROP TRIGGER trg_wa_comment_pk;

--------------------------------------------------------------------------------
-- 트리거 생성
--------------------------------------------------------------------------------
-- category
CREATE OR REPLACE TRIGGER trg_category_bi
BEFORE INSERT ON category
FOR EACH ROW
BEGIN
  SELECT category_seq.NEXTVAL INTO :NEW.category_idx FROM dual;
END;
/

-- genre
CREATE OR REPLACE TRIGGER trg_genre_bi
BEFORE INSERT ON genre
FOR EACH ROW
BEGIN
  SELECT genre_seq.NEXTVAL INTO :NEW.genre_idx FROM dual;
END;
/

-- contents
CREATE OR REPLACE TRIGGER trg_contents_bi
BEFORE INSERT ON contents
FOR EACH ROW
BEGIN
  SELECT contents_seq.NEXTVAL INTO :NEW.content_idx FROM dual;
END;
/

-- userPage
CREATE OR REPLACE TRIGGER trg_userPage_bi
BEFORE INSERT ON userPage
FOR EACH ROW
BEGIN
  SELECT userPage_seq.NEXTVAL INTO :NEW.userPg_idx FROM dual;
END;
/

-- setting
CREATE OR REPLACE TRIGGER trg_setting_bi
BEFORE INSERT ON setting
FOR EACH ROW
BEGIN
  SELECT setting_seq.NEXTVAL INTO :NEW.setting_idx FROM dual;
END;
/

-- watchParty
CREATE OR REPLACE TRIGGER trg_watchParty_bi
BEFORE INSERT ON watchParty
FOR EACH ROW
BEGIN
  SELECT watchParty_seq.NEXTVAL INTO :NEW.watchParty_idx FROM dual;
END;
/

-- message
CREATE OR REPLACE TRIGGER trg_message_bi
BEFORE INSERT ON message
FOR EACH ROW
BEGIN
  SELECT message_seq.NEXTVAL INTO :NEW.msg_idx FROM dual;
END;
/

-- todolist
CREATE OR REPLACE TRIGGER trg_todolist_bi
BEFORE INSERT ON todolist
FOR EACH ROW
BEGIN
  SELECT todolist_seq.NEXTVAL INTO :NEW.todo_idx FROM dual;
END;
/

-- follows
CREATE OR REPLACE TRIGGER trg_follows_bi
BEFORE INSERT ON follows
FOR EACH ROW
BEGIN
  SELECT follows_seq.NEXTVAL INTO :NEW.follows_idx FROM dual;
END;
/

-- note
CREATE OR REPLACE TRIGGER trg_note_bi
BEFORE INSERT ON note
FOR EACH ROW
BEGIN
  SELECT note_seq.NEXTVAL INTO :NEW.note_idx FROM dual;
END;
/

-- notification
CREATE OR REPLACE TRIGGER trg_notification_bi
BEFORE INSERT ON notification
FOR EACH ROW
BEGIN
  SELECT notification_seq.NEXTVAL INTO :NEW.notifi_idx FROM dual;
END;
/

-- bookmark
CREATE OR REPLACE TRIGGER trg_bookmark_bi
BEFORE INSERT ON bookmark
FOR EACH ROW
BEGIN
  SELECT bookmark_seq.NEXTVAL INTO :NEW.bkmark_idx FROM dual;
END;
/

-- likes
CREATE OR REPLACE TRIGGER trg_likes_bi
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
  SELECT likes_seq.NEXTVAL INTO :NEW.likes_idx FROM dual;
END;
/

-- noteAccess
CREATE OR REPLACE TRIGGER trg_noteAccess_bi
BEFORE INSERT ON noteAccess
FOR EACH ROW
BEGIN
  SELECT noteAccess_seq.NEXTVAL INTO :NEW.ntGrant_idx FROM dual;
END;
/

-- commentlist
CREATE OR REPLACE TRIGGER trg_commentlist_bi
BEFORE INSERT ON commentlist
FOR EACH ROW
BEGIN
  SELECT commentlist_seq.NEXTVAL INTO :NEW.commentlist_idx FROM dual;
END;
/

-- watchParty IDX 자동 증가 트리거
CREATE OR REPLACE TRIGGER trg_watchParty_pk
  BEFORE INSERT ON watchParty
  FOR EACH ROW
BEGIN
  IF :NEW.watchParty_idx IS NULL THEN
    SELECT seq_watchparty.NEXTVAL 
      INTO :NEW.watchParty_idx 
      FROM dual;
  END IF;
END;
/
-- wa_sync IDX 자동 증가 트리거
CREATE OR REPLACE TRIGGER trg_wa_sync_pk
  BEFORE INSERT ON wa_sync
  FOR EACH ROW
BEGIN
  IF :NEW.sync_idx IS NULL THEN
    SELECT seq_wa_sync.NEXTVAL 
      INTO :NEW.sync_idx 
      FROM dual;
  END IF;
END;
/
-- wa_comment IDX 자동 증가 트리거
CREATE OR REPLACE TRIGGER trg_wa_comment_pk
  BEFORE INSERT ON wa_comment
  FOR EACH ROW
BEGIN
  IF :NEW.wac_idx IS NULL THEN
    SELECT seq_wa_comment.NEXTVAL 
      INTO :NEW.wac_idx 
      FROM dual;
  END IF;
END;
/
-- schedule IDX 자동 증가 트리거
CREATE OR REPLACE TRIGGER trg_schedule_bi
  BEFORE INSERT ON schedule
  FOR EACH ROW
BEGIN
    SELECT schedule_seq.NEXTVAL 
      INTO :NEW.schedule_idx 
      FROM dual;
END;
/

SELECT COUNT(*) AS trigger_count FROM user_triggers;

commit;

select *
from useraccount;