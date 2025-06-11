package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.util.JdbcUtil;

import mvc.domain.dto.MessageDTO;
import mvc.domain.dto.MessageListDTO;
import mvc.domain.vo.MessageVO;
import mvc.persistence.dao.MessageDAO;

public class MessageDAOImpl implements MessageDAO {

	Connection conn = null;
	
	public MessageDAOImpl(Connection conn) {
		this.conn = conn;
	}

	// 안읽은 메시지 목록
	@Override
	public List<MessageListDTO> selectUnreadMessageList(int acIdx) throws SQLException {
		List<MessageListDTO> unreadMessageList = new ArrayList<MessageListDTO>();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = " SELECT m.* " + 
					 " , u.nickname AS sender_nickname " +
					 " , u.img AS sender_img " +
					 " , unreadCnt " +
					 " FROM message m " +
					 " JOIN ( " + 
					 " 		  SELECT ac_sender, MAX(time) AS latest_time, COUNT(msg_idx) AS unreadCnt " +
					 "		  FROM message " +
					 " 		  WHERE ac_receiver = ? AND chk = 1 " +
					 " 		  GROUP BY ac_sender " +
					 "		) latest_msg " +
					 " ON m.ac_sender = latest_msg.ac_sender AND m.time = latest_msg.latest_time " +
					 " JOIN userAccount u " +
					 " ON m.ac_sender = u.ac_idx " +
					 " ORDER BY m.time DESC ";

		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, acIdx);
		rs = pstmt.executeQuery();
		
		LocalDateTime today = LocalDateTime.now().withHour(0);
		DateTimeFormatter formatter;
		String time, text;
		
		while (rs.next()) {
			int ac_sender = rs.getInt("ac_sender");
			
			// 메시지 내용 길면 ··· 처리
			text = rs.getString("text");
			if (text.length() > 25) {
				text = text.substring(0, 23) + " ···";
			}
			
			// 오전/오후 1:34, 어제, 6월 7일, 1년 전
			Timestamp sqlTime = rs.getTimestamp("time");
			LocalDateTime sentTime = sqlTime.toLocalDateTime();
			int days = (int) ChronoUnit.DAYS.between(sentTime, today);

			if (days == 0) { // 오늘
				formatter = DateTimeFormatter.ofPattern("a h:mm");
				time = sentTime.format(formatter); // 오전/오후 1:34
				
			} else if (days == 1) { // 어제
				time = "어제";
				
			} else if (days > 1 && days < 365) { // 1일 초과, 1년 미만
				formatter = DateTimeFormatter.ofPattern("M월 d일");
				time = sentTime.format(formatter); // 6월 7일
				
			} else { // 1년 이상 전
				time = days/365 + "년 전"; // 1년 전
			}
			
			MessageDTO unreadMessage = MessageDTO.builder()
										 .msg_idx(rs.getInt("msg_idx"))
										 .text(text)
										 .time(sqlTime)
										 .relativeTime(time)
										 .img(rs.getString("img"))
										 .ac_sender(ac_sender)
										 .sender_nickname(rs.getString("sender_nickname"))
										 .sender_img(rs.getString("sender_img"))
										 .build();
			
			MessageListDTO unreadMessageInfo = MessageListDTO.builder()
											   				 .ac_sender(ac_sender)
											   				 .numOfUnreadMessages(rs.getInt("unreadCnt"))
											   				 .latestMessage(unreadMessage)
											   				 .build();
			
			unreadMessageList.add(unreadMessageInfo);
			
		}
		
		JdbcUtil.close(rs);
		JdbcUtil.close(pstmt);
		
		return unreadMessageList;
	}

	
	// 전체 메시지 목록 조회
	@Override
	public List<MessageListDTO> selectMessageListAll(int acIdx) throws SQLException {
		List<MessageListDTO> messageList = new ArrayList<MessageListDTO>();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = " SELECT m.* " + 
					 " , u.nickname AS sender_nickname " +
					 " , u.img AS sender_img " +
					 " , unreadCnt " +
					 " FROM message m " +
					 " JOIN ( " + 
					 " 		  SELECT ac_sender, MAX(time) AS latest_time, SUM(chk) AS unreadCnt " +
					 "		  FROM message " +
					 " 		  WHERE ac_receiver = ? " +
					 " 		  GROUP BY ac_sender " +
					 "		) latest_msg " +
					 " ON m.ac_sender = latest_msg.ac_sender AND m.time = latest_msg.latest_time " +
					 " JOIN userAccount u " +
					 " ON m.ac_sender = u.ac_idx " +
					 " ORDER BY m.time DESC ";

		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, acIdx);
		rs = pstmt.executeQuery();
		
		LocalDateTime today = LocalDateTime.now().withHour(0);
		DateTimeFormatter formatter;
		String time, text;
		
		while (rs.next()) {
			int ac_sender = rs.getInt("ac_sender");
			
			// 메시지 내용 길면 ··· 처리
			text = rs.getString("text");
			if (text.length() > 25) {
				text = text.substring(0, 23) + " ···";
			}
			
			// 오전/오후 1:34, 어제, 6월 7일, 1년 전
			Timestamp sqlTime = rs.getTimestamp("time");
			LocalDateTime sentTime = sqlTime.toLocalDateTime();
			int days = (int) ChronoUnit.DAYS.between(sentTime, today);

			if (days == 0) { // 오늘
				formatter = DateTimeFormatter.ofPattern("a h:mm");
				time = sentTime.format(formatter); // 오전/오후 1:34
				
			} else if (days == 1) { // 어제
				time = "어제";
				
			} else if (days > 1 && days < 365) { // 1일 초과, 1년 미만
				formatter = DateTimeFormatter.ofPattern("M월 d일");
				time = sentTime.format(formatter); // 6월 7일
				
			} else { // 1년 이상 전
				time = days/365 + "년 전"; // 1년 전
			}
			
			MessageDTO unreadMessage = MessageDTO.builder()
										 .msg_idx(rs.getInt("msg_idx"))
										 .text(text)
										 .time(sqlTime)
										 .relativeTime(time)
										 .img(rs.getString("img"))
										 .ac_sender(ac_sender)
										 .sender_nickname(rs.getString("sender_nickname"))
										 .sender_img(rs.getString("sender_img"))
										 .build();
			
			MessageListDTO messageInfo = MessageListDTO.builder()
											   			.ac_sender(ac_sender)
											   			.numOfUnreadMessages(rs.getInt("unreadCnt"))
											   			.latestMessage(unreadMessage)
											   			.build();
			
			messageList.add(messageInfo);
			
		}
		
		JdbcUtil.close(rs);
		JdbcUtil.close(pstmt);
		
		return messageList;
	}
	
	
	// 채팅 내역 조회
	@Override
	public List<MessageDTO> selectChatHistory(int ac_idx, int sender_idx) throws SQLException {
		List<MessageDTO> chatHistory = null;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = " SELECT " +
					  " msg_idx, text, time, m.img AS sender_img, ac_sender, nickname AS sender_nickname " +
					  " FROM message m " +
					  " JOIN useraccount u ON m.ac_sender = u.ac_idx " +
					  " WHERE (ac_receiver = ? AND ac_sender = ?) " +
					  " 	  OR (ac_sender = ? AND ac_receiver = ?) " +
					  " ORDER BY time ASC ";
		
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, ac_idx);
		pstmt.setInt(2, sender_idx);
		pstmt.setInt(3, ac_idx);
		pstmt.setInt(4, sender_idx);
		rs = pstmt.executeQuery();
		
		if (rs.next()) {
			chatHistory = new ArrayList<MessageDTO>();
			do {
				Timestamp sqlTime = rs.getTimestamp("time");
				String time = sqlTime.toLocalDateTime().format(DateTimeFormatter.ofPattern("a h:mm"));
				String date = sqlTime.toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy년 M월 d일"));
				
				MessageDTO message = MessageDTO.builder()
											   .msg_idx(rs.getInt("msg_idx"))
											   .text(rs.getString("text"))
											   .time(sqlTime)
											   .relativeTime(time)
											   .date(date)
											   .img(rs.getString("sender_img"))
											   .ac_sender(sender_idx)
											   .sender_nickname(rs.getString("sender_nickname"))
											   .sender_img(rs.getString("sender_img"))
											   .isMine(rs.getInt("ac_sender") == ac_idx)
											   .build();
				
				chatHistory.add(message);
				
			} while (rs.next());
		}
		
		JdbcUtil.close(rs);
		JdbcUtil.close(pstmt);
		
		return chatHistory;
	}

	
	// 채팅 확인한 경우, 읽음 처리
	@Override
	public boolean updateChkMessage(int my_idx, List<Integer> msg_idxList) throws SQLException {
		boolean isChecked = false;
		
		PreparedStatement pstmt = null;
		
		StringBuffer sql = new StringBuffer(" UPDATE message " +
					 					  	" SET chk = 0 " +
					 						" WHERE msg_idx IN ( ");
		
		for (int i = 0; i < msg_idxList.size(); i++) {
			sql.append(msg_idxList.get(i));
			if (i != msg_idxList.size() - 1) {
				sql.append(", ");
			} else {
				sql.append(" ) ");
			}
		}
		
		sql.append(" AND chk = 1 AND ac_receiver = ? ");
		
		pstmt = conn. prepareStatement(sql.toString());
		pstmt.setInt(1, my_idx);
		int result = pstmt.executeUpdate();
		
		isChecked = result >= 1 ? true : false;
		
		JdbcUtil.close(pstmt);
		
		return isChecked;
	}


	// 채팅방 메시지 보내기
	@Override
	public boolean insertMessage(int senderIdx, int receiverIdx, String text) throws SQLException {
		boolean isSent = false;
		
		PreparedStatement pstmt = null;
		
		String sql = " INSERT INTO message "
				   + " (msg_idx, text, time, chk, ac_receiver, ac_sender) "
				   + " VALUES (message_seq.nextval, ?, SYSTIMESTAMP, 1, ?, ?) ";
		
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, text);
		pstmt.setInt(2, receiverIdx);
		pstmt.setInt(3, senderIdx);
		
		int result = pstmt.executeUpdate();
		isSent = result >= 1 ? true : false;
		
		return isSent;
	}
	
}
