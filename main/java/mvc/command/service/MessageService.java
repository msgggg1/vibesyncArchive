package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.MessageDTO;
import mvc.domain.dto.MessageListDTO;
import mvc.persistence.dao.MessageDAO;
import mvc.persistence.daoImpl.MessageDAOImpl;

public class MessageService {
	
	// 안읽은 메시지 목록
	public List<MessageListDTO> getUnreadMessageList(int acIdx) {
		List<MessageListDTO> unreadMessageList = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			unreadMessageList = messageDAO.selectUnreadMessageList(acIdx);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return unreadMessageList;
	}

	// 전체 메시지 목록
	public List<MessageListDTO> getMessageListAll(int acIdx) {
		List<MessageListDTO> messageList = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			messageList = messageDAO.selectMessageListAll(acIdx);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return messageList;
	}
	
	// 채팅방 채팅 내역 열람
	public List<MessageDTO> getChatHistory(int myIdx, int otherIdx) {
		List<MessageDTO> chatHistory = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			chatHistory = messageDAO.selectChatHistory(myIdx, otherIdx);
			if (chatHistory != null) {
				List<Integer> msg_idxList = new ArrayList<Integer>();
				Iterator<MessageDTO> ir = chatHistory.iterator();
				while (ir.hasNext()) {
					MessageDTO messageDTO = ir.next();
					msg_idxList.add(messageDTO.getMsg_idx());
				}
				
				if (messageDAO.updateChkMessage(myIdx, msg_idxList)) {
					conn.commit();
				} else {
					conn.rollback();
				}
			}
			
		} catch (NamingException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} catch (SQLException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return chatHistory;
	}
	
	// 채팅방 메시지 보내기
    public boolean sendMessage(int senderIdx, int receiverIdx, String text) {
        boolean isSent = false;
    	
        Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			
			MessageDAO messageDAO = new MessageDAOImpl(conn);
			isSent = messageDAO.insertMessage(senderIdx, receiverIdx, text);
			
			if (isSent) {
				conn.commit();
			} else {
				conn.rollback();
			}
			
		} catch (NamingException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} catch (SQLException e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
    	
        return isSent;
    }

}
