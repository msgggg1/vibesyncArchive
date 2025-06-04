package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.dto.NoteDTO;
import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.persistence.dao.NoteDAO;

public class NoteDAOImpl implements NoteDAO {

	// 선호 카테고리 - 최신글
	@Override
	public List<NoteDTO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		
	       List<NoteDTO> posts = new ArrayList<>();
	       String sql = "SELECT note_idx, title, img " +
                   "FROM ( " +
                   "    SELECT note_idx, title, img, ROW_NUMBER() OVER (ORDER BY create_at DESC) as rn " +
                   "    FROM note " +
                   "    WHERE category_idx = ? " +
                   ") " +
                   "WHERE rn <= ?";
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            conn = ConnectionProvider.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, categoryIdx);
	            pstmt.setInt(2, limit);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	NoteDTO post = new NoteDTO();
	                post.setNote_idx(rs.getInt("note_idx"));
	                post.setTitle(rs.getString("title"));
	                post.setImg(rs.getString("img")); // CLOB에서 문자열로 읽는다고 가정
	                posts.add(post);
	            }
	        } catch (NamingException e) {
				e.printStackTrace();
			} finally {
	        	rs.close();
	        	pstmt.close();
	        	conn.close();
	        }
	        return posts;
	    }

	// 선호 카테고리 - 인기글
	@Override
	public List<NoteDTO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		List<NoteDTO> posts = new ArrayList<>();
		String sql = "SELECT " +
	             "    rnk.note_idx, n_orig.title, rnk.popularity_score, n_orig.img " +
	             "FROM ( " +
	             "    SELECT " +
	             "        n.note_idx, " +
	             "        (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularity_score, " +
	             "        ROW_NUMBER() OVER (ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC) as rn " +
	             "    FROM note n LEFT JOIN likes l ON n.note_idx = l.note_idx " +
	             "    WHERE n.category_idx = ? " + 
	             "    GROUP BY n.note_idx, n.view_count, n.create_at " +
	             "		) rnk " +
	             "JOIN note n_orig ON rnk.note_idx = n_orig.note_idx " +
	             "WHERE rnk.rn <= ? " + 
	             "ORDER BY rnk.rn";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryIdx);
            pstmt.setInt(2, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	NoteDTO post = new NoteDTO();
                post.setNote_idx(rs.getInt("note_idx"));
                post.setTitle(rs.getString("title"));
                post.setImg(rs.getString("img"));
                posts.add(post);
            }
        } catch (NamingException e) {
			e.printStackTrace();
		} finally {
        	conn.close();
        }
        return posts;
    }

	// 전체 카테고리 - 인기글
	@Override
	public List<NoteDTO> popularNoteByAllCategory(int limit) throws SQLException {
		 List<NoteDTO> notes = new ArrayList<>();
	        // 전체 글 중 (좋아요 수 + 조회수) 합산 점수 높은 순, 동점 시 최신순
	        String sql = "SELECT " +
		             "    rnk.note_idx, n_orig.title, rnk.popularity_score, n_orig.img " +
		             "FROM ( " +
		             "    SELECT " +
		             "        n.note_idx, " +
		             "        (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularity_score, " +
		             "        ROW_NUMBER() OVER (ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC) as rn " +
		             "    FROM note n LEFT JOIN likes l ON n.note_idx = l.note_idx " +
		             "    GROUP BY n.note_idx, n.view_count, n.create_at " +
		             "		) rnk " +
		             "JOIN note n_orig ON rnk.note_idx = n_orig.note_idx " +
		             "WHERE rnk.rn <= ? " + 
		             "ORDER BY rnk.rn"; 
	
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	        	conn = ConnectionProvider.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, limit); 
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	                NoteDTO note = new NoteDTO();
	                note.setNote_idx(rs.getInt("note_idx")); 
	                note.setTitle(rs.getString("title"));    
	                note.setImg(rs.getString("img")); 
	                notes.add(note);
	            }
	        } catch (NamingException e) {
				e.printStackTrace();
			} finally {
	        	conn.close();
	        }
	        return notes;
	}

	@Override
	  public NoteDetailDTO printNote(int noteIdx) { 
        String sql = "SELECT "
                   + "    n.note_idx, "
                   + "    n.title, "
                   + "    n.text, "
                   + "    n.create_at, "
                   + "    n.view_count, "
                   + "    ua.ac_idx, "
                   + "    ua.nickname, "
                   + "    ua.img, " // 이 값으로 DTO의 img (프로필 사진) 필드를 채웁니다.
                   + "    ( "
                   + "        SELECT COUNT(*) "
                   + "        FROM likes l "
                   + "        WHERE l.note_idx = n.note_idx "
                   + "    ) AS like_sum "
                   + "FROM "
                   + "    note n "
                   + "JOIN "
                   + "    userPage up ON n.userPg_idx = up.userPg_idx "
                   + "JOIN "
                   + "    userAccount ua ON up.ac_idx = ua.ac_idx "
                   + "WHERE "
                   + "    n.note_idx = ? ";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        NoteDetailDTO dto = null; // NoteDetailDTO 타입으로 변경, null로 초기화

        try {
            conn = ConnectionProvider.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) { // 단일 결과를 예상하므로 if 사용
            	dto = new NoteDetailDTO(); // NoteDetailDTO 객체 생성

                // DTO 필드명에 맞춰 SQL 별칭을 사용해 값 설정
                dto.setNote_idx(rs.getInt("note_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setText(rs.getString("text"));
                dto.setCreate_at(rs.getTimestamp("create_at"));
                dto.setView_count(rs.getInt("view_count"));
                
                dto.setAc_idx(rs.getInt("ac_idx"));
                dto.setNickname(rs.getString("nickname"));
                dto.setImg(rs.getString("img")); 
            
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        } catch (NamingException e) {
            e.printStackTrace();
        } finally {
            // 
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
            
        }
        return dto; 
    }

	@Override
	public void increaseViewCount(int noteIdx) throws SQLException {
		    String sql = "UPDATE note SET view_count = view_count + 1 WHERE note_idx = ?";
		    Connection conn = null;
		    PreparedStatement pstmt = null;

		    try {
		        conn = ConnectionProvider.getConnection(); 
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, noteIdx);
		        pstmt.executeUpdate();
		    } catch (NamingException e) { 
		        e.printStackTrace(); 
		        throw new SQLException("DB 연결 또는 조회수 증가 중 오류 발생 (Naming)", e);
		    } catch (SQLException e) {
		        e.printStackTrace(); 
		        throw e; 
		    } finally {
		        try {
		            if (pstmt != null) pstmt.close();
		            if (conn != null) conn.close();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }
		}
	
	@Override
    public List<NoteSummaryDTO> getPostsByUser(Connection conn, int userAcIdx, int offset, int limit) throws SQLException {
        List<NoteSummaryDTO> posts = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Oracle 11g 이하: ROWNUM 사용 (OFFSET FETCH 미사용)
        String sql = "SELECT note_idx, title, thumbnail_img " +
                     "FROM ( " +
                     "    SELECT r_.*, ROWNUM RNUM " + // 안쪽 쿼리 결과에 ROWNUM 별칭 부여
                     "    FROM ( " +
                     "        SELECT n.note_idx, n.title, n.img AS thumbnail_img " + // 실제 가져올 컬럼
                     "        FROM note n " +
                     "        JOIN userPage up ON n.userPg_idx = up.userPg_idx " +
                     "        WHERE up.ac_idx = ? " + // 조건: 특정 사용자
                     "        ORDER BY n.create_at DESC " + // 정렬 기준 (가장 안쪽에서 정렬해야 ROWNUM이 의미 있음)
                     "    ) r_ " +
                     "    WHERE ROWNUM <= ? " + // 페이징 조건 1: (offset + limit) -> 가져올 마지막 행 번호
                     ") " +
                     "WHERE RNUM > ?"; // 페이징 조건 2: offset -> 가져올 시작 행 번호 다음부터

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userAcIdx);          // WHERE up.ac_idx = ?
            pstmt.setInt(2, offset + limit);     // WHERE ROWNUM <= ?
            pstmt.setInt(3, offset);             // WHERE RNUM > ?
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                NoteSummaryDTO post = NoteSummaryDTO.builder()
                        .note_idx(rs.getInt("note_idx"))
                        .title(rs.getString("title"))
                        .thumbnail_img(rs.getString("thumbnail_img")) 
                        .build();
                posts.add(post);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        return posts;
    }
		
	}//class



