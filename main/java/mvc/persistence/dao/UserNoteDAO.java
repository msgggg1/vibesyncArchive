package mvc.persistence.dao;

import mvc.domain.vo.UserNoteVO;

public interface UserNoteDAO {
	
	UserNoteVO getUserNoteById(int noteIdx);
	
	void addLike(int userIdx, int noteIdx);
	
	void deleteLike(int userIdx, int noteIdx);
	
	boolean isLiked(int userIdx, int noteIdx);
	
	boolean isFollowing(int userIdx, int writerIdx);
	
	void addFollow(int userIdx, int writerIdx);
	
	void deleteFollow(int userIdx, int writerIdx);
}