package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;

import mvc.domain.dto.MessageDTO;
import mvc.domain.dto.MessageListDTO;

public interface MessageDAO {

    // 안읽은 메시지 목록
	public List<MessageListDTO> selectUnreadMessageList(int acIdx) throws SQLException;
	
	// 전체 메시지 목록 조회
	public List<MessageListDTO> selectMessageListAll(int acIdx) throws SQLException;

	// 채팅 내역 조회
	public List<MessageDTO> selectChatHistory(int ac_idx, int sender_idx) throws SQLException;

	// 채팅 확인한 경우, 읽음 처리
	public boolean updateChkMessage(int myIdx, List<Integer> msg_idxList) throws SQLException;
	
	// 채팅방 메시지 보내기
	public boolean insertMessage(int senderIdx, int receiverIdx, String text) throws SQLException;

}
