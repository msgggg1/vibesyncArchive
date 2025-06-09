package com.util;

import java.sql.*;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordMigrator {

    // 이전에 제공된 hashPassword 메소드 (SHA-256 버전)
    public static String hashPassword(String plainTextPassword, String base64Salt) {
        // [SHA-256 해싱 로직]
        // Null 또는 빈 문자열일 경우 예외 처리 또는 특정 값 반환
        if (plainTextPassword == null || plainTextPassword.isEmpty() || base64Salt == null || base64Salt.isEmpty()) {
            // 적절한 오류 처리 또는 빈 문자열 반환 등
        }
        	if (plainTextPassword == null || plainTextPassword.isEmpty()) {
                throw new IllegalArgumentException("비밀번호는 null이거나 비어있을 수 없습니다.");
            }
            if (base64Salt == null || base64Salt.isEmpty()) {
                throw new IllegalArgumentException("Salt는 null이거나 비어있을 수 없습니다.");
            }
            
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] saltBytes = Base64.getDecoder().decode(base64Salt);
            md.update(saltBytes);
            byte[] hashedBytes = md.digest(plainTextPassword.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // 이 예외는 일반적으로 발생하기 어렵지만, 발생하면 심각한 시스템 설정 문제입니다.
            throw new PasswordHashingException("비밀번호 해싱 중 심각한 오류 발생 (알고리즘 없음)", e);
        } catch (UnsupportedEncodingException e) {
            // 이 예외 역시 일반적으로 발생하기 어렵습니다.
            throw new PasswordHashingException("비밀번호 해싱 중 심각한 오류 발생 (인코딩 지원 안함)", e);
        } catch (IllegalArgumentException e) { // Base64 디코딩 실패 시
            throw new PasswordHashingException("잘못된 Salt 형식으로 인해 비밀번호 해싱에 실패했습니다.", e);
        	}
        }

    public static String generateSalt() throws Exception {
        SecureRandom sr = SecureRandom.getInstanceStrong();
        byte[] saltBytes = new byte[16];
        sr.nextBytes(saltBytes);
        return Base64.getEncoder().encodeToString(saltBytes);
    }

    // 기존 더미데이터 해시값 생성 위한 main 함수 입니다. 
    public static void main(String[] args) {
        String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe"; 
        String dbUser = "vibesync";
        String dbPassword = "ss123$";

        Connection conn = null;
        Statement stmtSelect = null;
        PreparedStatement pstmtUpdate = null;
        ResultSet rs = null;

        try {
            // Oracle JDBC 드라이버 로드 (필요한 경우)
            // Class.forName("oracle.jdbc.driver.OracleDriver");
            // conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            conn = ConnectionProvider.getConnection(); // 기존 DBConn 유틸리티 사용

            // 1. 기존 평문 비밀번호를 가진 사용자들 조회 (salt가 NULL인 경우 등으로 구분 가능)
            String selectSql = "SELECT ac_idx, pw FROM userAccount WHERE salt IS NULL"; // 예시 조건
            stmtSelect = conn.createStatement();
            rs = stmtSelect.executeQuery(selectSql);

            String updateSql = "UPDATE userAccount SET pw = ?, salt = ? WHERE ac_idx = ?";
            pstmtUpdate = conn.prepareStatement(updateSql);

            while (rs.next()) {
                int acIdx = rs.getInt("ac_idx");
                String plainPassword = rs.getString("pw"); // 현재 이 컬럼에는 평문 비밀번호가 있다고 가정

                if (plainPassword == null || plainPassword.trim().isEmpty()) {
                    System.out.println("Skipping ac_idx " + acIdx + " due to empty password.");
                    continue;
                }

                String salt = generateSalt();
                String hashedPassword = hashPassword(plainPassword, salt);

                if (hashedPassword != null) {
                    pstmtUpdate.setString(1, hashedPassword);
                    pstmtUpdate.setString(2, salt);
                    pstmtUpdate.setInt(3, acIdx);
                    pstmtUpdate.addBatch(); // 배치 처리
                    System.out.println("Processed ac_idx: " + acIdx);
                } else {
                    System.out.println("Failed to hash password for ac_idx: " + acIdx);
                }
            }
            pstmtUpdate.executeBatch(); // 배치 실행
            System.out.println("Password migration completed.");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmtSelect != null) stmtSelect.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtUpdate != null) pstmtUpdate.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
