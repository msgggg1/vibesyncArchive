package mvc.persistence.dao;

import mvc.domain.vo.NoteVO;
import mvc.domain.vo.UserNoteVO;

public interface UserNoteDAO {
	
	UserNoteVO getUserNoteById(int noteIdx);
	// 추가
	void updateViewCount(int noteIdx);
	
	void addLike(int userIdx, int noteIdx);
	
	void deleteLike(int userIdx, int noteIdx);
	
	boolean isLiked(int userIdx, int noteIdx);
	
	boolean isFollowing(int userIdx, int writerIdx);
	
	void addFollow(int userIdx, int writerIdx);
	
	void deleteFollow(int userIdx, int writerIdx);

	/** 노트 생성 */
    void createNote(NoteVO note);
    
    /** 노트 수정 */
    void updateNote(NoteVO note);
    
    /** 노트 삭제 */
    void deleteNote(int noteIdx);
    
    NoteVO getNote(int noteIdx);
}