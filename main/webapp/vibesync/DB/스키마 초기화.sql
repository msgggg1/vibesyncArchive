-- 현재 로그인한 사용자(스키마)의 모든 객체 삭제

-- 1. 모든 테이블 삭제
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- 2. 모든 시퀀스 삭제
BEGIN
  FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || s.sequence_name || '"';
  END LOOP;
END;
/

-- 3. 모든 트리거 삭제
BEGIN
  FOR trg IN (SELECT trigger_name FROM user_triggers) LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER "' || trg.trigger_name || '"';
  END LOOP;
END;
/

-- 4. 모든 뷰 삭제
BEGIN
  FOR v IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW "' || v.view_name || '"';
  END LOOP;
END;
/

-------------------------------------------

-- 데이터만 삭제하고 구조는 유지하고 싶을 때
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE "' || t.table_name || '"';
  END LOOP;
END;
/

--------------------------------------------

-- 테이블 확인 : 현재 계정이 가진 테이블 목록 확인
SELECT * FROM user_tables;

-- 시퀀스 확인 : 현재 계정이 가진 시퀀스 목록 확인
SELECT * FROM user_sequences;

-- 트리거 확인 : 현재 계정이 가진 트리거 목록 확인
SELECT * FROM user_triggers;
