package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.dto.NoteDetailDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.vo.NoteVO;
import mvc.persistence.dao.NoteDAO;

public class NoteDAOImpl implements NoteDAO {

	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
	
	public NoteDAOImpl(Connection conn) {
		this.conn = conn;
	}
	
	@Override
	// 전체 카테고리 - 인기글
	public Map<Integer, List<NoteVO>> popularNoteByAllCategory(int limit) throws SQLException {
		Map<Integer, List<NoteVO>> map = new LinkedHashMap<Integer, List<NoteVO>>();
		
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
		// 전체 글 중 (좋아요 수 + 조회수) 합산 점수 높은 순, 동점 시 최신순
		String sql = " SELECT " +
				"        n.note_idx, " + 
				" 		  n.title, " + 
				" 		  n.text, " + 
				"		  n.img, " + 
				"		  n.create_at, " + 
				"		  n.edit_at, " + 
				"		  n.view_count, " + 
				"		  n.content_idx, " + 
				"		  n.genre_idx, " +
				"		  n.category_idx, " + 
				"		  n.userPg_idx " +
				" FROM ( " +
				"    SELECT " +
				"        n.note_idx, " + 
			    "        n.category_idx, " + 
				"        ROW_NUMBER() OVER ( " +
				"				PARTITION BY n.category_idx " +
				" 				ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC " + 
				" 		) AS rn " +
				"    FROM note n " + 
				" 	 LEFT JOIN likes l ON n.note_idx = l.note_idx " +
				"    GROUP BY n.note_idx, n.view_count, n.create_at, n.category_idx " +
				" ) rnk " +
				" JOIN note n ON rnk.note_idx = n.note_idx " +
				" WHERE rnk.rn <= ? " + 
				" ORDER BY rnk.category_idx, rnk.rn ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, limit); 
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				do {
					int categoryId = rs.getInt("category_idx");
					NoteVO note = NoteVO.builder()
							.note_idx(rs.getInt("note_idx"))
							.title(rs.getString("title"))
							.text(rs.getString("text"))
							.img(rs.getString("img"))
							.create_at(rs.getDate("create_at"))
							.edit_at(rs.getDate("edit_at"))
							.view_count(rs.getInt("view_count"))
							.content_idx(rs.getInt("content_idx"))
							.genre_idx(rs.getInt("genre_idx"))
							.category_idx(categoryId)
							.userPg_idx(rs.getInt("userPg_idx"))
							.build();
					
					if(!map.containsKey(categoryId)) {
						ArrayList<NoteVO> list = new ArrayList<NoteVO>();
						list.add(note);
						map.put(categoryId, list);
					} else {
						map.get(categoryId).add(note);
					}
					
				} while (rs.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
		}
		
		return map;
	}

	// 선호 카테고리 - 최신글
	@Override
	public List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException {

	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
	    List<NoteVO> posts = new ArrayList<>();
	    String sql = "SELECT note_idx, title, img " +
                   "FROM ( " +
                   "    SELECT note_idx, title, img, ROW_NUMBER() OVER (ORDER BY create_at DESC) as rn " +
                   "    FROM note " +
                   "    WHERE category_idx = ? " +
                   ") " +
                   "WHERE rn <= ?";

	     try {
	    	 	pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, categoryIdx);
	            pstmt.setInt(2, limit);
	            rs = pstmt.executeQuery();

	            while (rs.next()) {
	            	NoteVO post = new NoteVO();
	                post.setNote_idx(rs.getInt("note_idx"));
	                post.setTitle(rs.getString("title"));
	                post.setImg(rs.getString("img")); // CLOB에서 문자열로 읽는다고 가정
	                posts.add(post);
	            }
	     } catch (Exception e) {
				e.printStackTrace();
		 } finally {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
	     }
	     
	     return posts;
	 }

	// 선호 카테고리 - 인기글
	@Override
	public List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		List<NoteVO> posts = new ArrayList<>();
		
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		
		String sql = "SELECT " +
	             "    rnk.note_idx, n_orig.title, rnk.popularity_score, n_orig.img " + 
	             " FROM ( " +
	             "    SELECT " +
	             "        n.note_idx, " +
	             "        (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) AS popularity_score, " +
	             "        ROW_NUMBER() OVER (ORDER BY (COALESCE(COUNT(l.likes_idx), 0) + n.view_count) DESC, n.create_at DESC) as rn " +
	             "    FROM note n LEFT JOIN likes l ON n.note_idx = l.note_idx " +
	             "    WHERE n.category_idx = ? " + 
	             "    GROUP BY n.note_idx, n.view_count, n.create_at " +
	             "		) rnk " +
	             " JOIN note n_orig ON rnk.note_idx = n_orig.note_idx " +
	             " WHERE rnk.rn <= ? " + 
	             " ORDER BY rnk.rn ";

        try {
        	pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryIdx);
            pstmt.setInt(2, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	NoteVO post = new NoteVO();
                post.setNote_idx(rs.getInt("note_idx"));
                post.setTitle(rs.getString("title"));
                post.setImg(rs.getString("img"));
                posts.add(post);
            }
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
        }
        
        return posts;
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
                 + "    ua.img, " 
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

      PreparedStatement pstmt = null;
      ResultSet rs = null;
      NoteDetailDTO dto = null; // NoteDetailDTO 타입으로 변경, null로 초기화

      try {
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
      } finally {
          try {
              if (rs != null) rs.close();
              if (pstmt != null) pstmt.close();
          } catch (SQLException e) { e.printStackTrace(); }
          
      }
      return dto; 
  }

	// 조회수 증가 메서드
	@Override
	public void increaseViewCount(int noteIdx) throws SQLException {
		    String sql = "UPDATE note SET view_count = view_count + 1 WHERE note_idx = ?";
		    PreparedStatement pstmt = null;

		    try {
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, noteIdx);
		        pstmt.executeUpdate();
		    } catch (SQLException e) {
		        e.printStackTrace(); 
		        throw e; 
		    } finally {
		        try {
		            if (pstmt != null) pstmt.close();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }
		}
	
	@Override
  public List<NoteSummaryDTO> getPostsByUser(int userAcIdx, int offset, int limit) throws SQLException {
      List<NoteSummaryDTO> posts = new ArrayList<>();
      PreparedStatement pstmt = null;
      ResultSet rs = null;

      // ROWNUM 사용 
      String sql = "SELECT note_idx, title, thumbnail_img " +
                   "FROM ( " +
                   "    SELECT r.*, ROWNUM RNUM " + 
                   "    FROM ( " +
                   "        SELECT n.note_idx, n.title, n.img AS thumbnail_img " + // 실제 가져올 컬럼
                   "        FROM note n " +
                   "        JOIN userPage up ON n.userPg_idx = up.userPg_idx " +
                   "        WHERE up.ac_idx = ? " + // 조건: 특정 사용자
                   "        ORDER BY n.create_at DESC " + // 정렬 기준 (가장 안쪽에서 정렬해야 ROWNUM이 의미 있음)
                   "    ) r " +
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

}