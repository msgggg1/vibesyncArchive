package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.DBConn_vibesync;

import mvc.domain.vo.UserNoteVO;
import mvc.persistence.dao.UserNoteDAO;


public class UserNoteDAOImpl implements UserNoteDAO {
	
	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    
    public UserNoteDAOImpl() {
        
    }

    
	public UserNoteDAOImpl(Connection conn) {
		this.conn = conn;
	}
	

    /**
     * 주어진 note_idx로부터 노트, 작성자, 좋아요 수 정보를
     * 조인하여 UserNoteVO에 담아 반환한다.
     *
     * @param noteIdx 조회할 note의 PK
     * @return        UserNoteVO 객체 (없으면 null)
     */
    public UserNoteVO getUserNoteById(int noteIdx) {
        UserNoteVO vo = null;

        String sql =
            "SELECT "
          + "  n.note_idx, n.title, n.text, "
          + "  TO_CHAR(n.create_at,'YYYY-MM-DD HH24:MI:SS') AS create_at, "
          + "  n.view_count, n.content_idx, n.genre_idx, "
          + "  n.category_idx AS note_category_idx, n.userPg_idx, "
          + "  u.ac_idx, u.email, u.pw, u.nickname, u.img, u.name, "
          + "  u.category_idx AS ac_category_idx, "
          + "  NVL(l.cnt,0) AS like_num,"
          + "  up.ac_idx AS upac_idx "
          + "FROM note n "
          + "JOIN userPage up ON n.userPg_idx = up.userPg_idx "
          + "JOIN userAccount u ON up.ac_idx = u.ac_idx "
          + "LEFT JOIN ("
          + "  SELECT note_idx, COUNT(*) AS cnt "
          + "    FROM likes "
          + "   GROUP BY note_idx"
          + ") l ON n.note_idx = l.note_idx "
          + "WHERE n.note_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                vo = UserNoteVO.builder()
                    .note_idx(         rs.getInt("note_idx"))
                    .title(            rs.getString("title"))
                    .text(             rs.getString("text"))
                    .create_at(        rs.getString("create_at"))
                    .view_count(       rs.getInt("view_count"))
                    .content_idx(      rs.getInt("content_idx"))
                    .genre_idx(        rs.getInt("genre_idx"))
                    .note_category_idx(rs.getInt("note_category_idx"))
                    .userPg_idx(       rs.getInt("userPg_idx"))
                    .ac_idx(           rs.getInt("ac_idx"))
                    .email(            rs.getString("email"))
                    .pw(               rs.getString("pw"))
                    .nickname(         rs.getString("nickname"))
                    .img(              rs.getString("img"))
                    .name(             rs.getString("name"))
                    .ac_category_idx(  rs.getInt("ac_category_idx"))
                    .like_num(         rs.getInt("like_num"))
                    .upac_idx(         rs.getInt("upac_idx"))
                    .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // ResultSet, PreparedStatement만 닫고 Connection은 닫지 않음
            if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }

        return vo;
    }
    
    /**
     * likes 테이블에 새로운 좋아요 레코드를 추가한다.
     *
     * @param userIdx 좋아요를 누른 사용자 ac_idx
     * @param noteIdx 좋아요 대상 노트 note_idx
     */
    public void addLike(int userIdx, int noteIdx) {

        String sql =
            "INSERT INTO likes (created_at, note_idx, ac_idx) " +
            "VALUES (SYSDATE, ?, ?)";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            pstmt.setInt(2, userIdx);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }
    }

    /**
     * likes 테이블에서 특정 사용자의 좋아요 레코드를 삭제한다.
     *
     * @param userIdx 좋아요를 취소하는 사용자 ac_idx
     * @param noteIdx 좋아요 대상 노트 note_idx
     */
    public void deleteLike(int userIdx, int noteIdx) {
        String sql =
            "DELETE FROM likes WHERE note_idx = ? AND ac_idx = ?";

        try {
            conn = DBConn_vibesync.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            pstmt.setInt(2, userIdx);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }
    }
    
    /**
     * 특정 사용자와 노트에 대한 좋아요 존재 여부를 확인한다.
     *
     * @param userIdx 확인할 사용자 ac_idx
     * @param noteIdx 확인할 노트 note_idx
     * @return        좋아요가 존재하면 true, 그렇지 않으면 false
     */
    public boolean isLiked(int userIdx, int noteIdx) {
        boolean liked = false;

        String sql =
            "SELECT 1 FROM likes WHERE note_idx = ? AND ac_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noteIdx);
            pstmt.setInt(2, userIdx);
            rs = pstmt.executeQuery();
            liked = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null)    try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }

        return liked;
    }
    
    /**
     * 특정 사용자가 다른 사용자를 팔로우하고 있는지 여부를 확인한다.
     *
     * @param userIdx   팔로우를 시도하는 사용자 ac_idx
     * @param writerIdx 팔로우 대상(글 작성자) ac_idx
     * @return          이미 팔로우 중이면 true, 아니면 false
     */
    public boolean isFollowing(int userIdx, int writerIdx) {
        boolean following = false;

        String sql =
            "SELECT 1 FROM follows WHERE ac_follow = ? AND ac_following = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            pstmt.setInt(2, writerIdx);
            rs = pstmt.executeQuery();
            following = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs    != null) try { rs.close();    } catch (Exception ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            // Connection은 닫지 않음
        }

        return following;
    }

    /**s
     * follows 테이블에 새로운 팔로우 레코드를 추가한다.
     *
     * @param userIdx   팔로우를 시도하는 사용자 ac_idx
     * @param writerIdx 팔로우 대상(글 작성자) ac_idx
     */
    public void addFollow(int userIdx, int writerIdx) {
        String sql =
            "INSERT INTO follows (ac_follow, ac_following) " +
            "VALUES (?, ?)";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            pstmt.setInt(2, writerIdx);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }
    }

    /**
     * follows 테이블에서 특정 팔로우 레코드를 삭제한다.
     *
     * @param userIdx   팔로우를 취소하는 사용자 ac_idx
     * @param writerIdx 팔로우 대상(글 작성자) ac_idx
     */
    public void deleteFollow(int userIdx, int writerIdx) {
        String sql =
            "DELETE FROM follows WHERE ac_follow = ? AND ac_following = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userIdx);
            pstmt.setInt(2, writerIdx);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
        }
    }
    
}