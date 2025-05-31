package mvc.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;

import mvc.domain.NoteVO;

public class NoteDAOImpl implements NoteDAO {

	@Override
	public List<NoteVO> recentNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		
	       List<NoteVO> posts = new ArrayList<>();
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
	            	NoteVO post = new NoteVO();
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

	@Override
	public List<NoteVO> popularNoteByMyCategory(int categoryIdx, int limit) throws SQLException {
		List<NoteVO> posts = new ArrayList<>();
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
            	NoteVO post = new NoteVO();
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

	@Override
	public List<NoteVO> recentAllNotes(int limit) throws SQLException {
		 List<NoteVO> notes = new ArrayList<>();
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
	                NoteVO note = new NoteVO();
	                note.setNote_idx(rs.getInt("note_idx")); 
	                note.setTitle(rs.getString("title"));    
	                note.setImg(rs.getString("img"));        
	                note.setPopularityScore(rs.getInt("popularity_score"));
	                notes.add(note);
	            }
	        } catch (NamingException e) {
				e.printStackTrace();
			} finally {
	        	conn.close();
	        }
	        return notes;
	}

}
