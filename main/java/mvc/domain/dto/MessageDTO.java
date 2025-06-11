package mvc.domain.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageDTO {

	private int msg_idx;
	private String text;
	private Timestamp time;
	private String relativeTime;
	private String date;
	private String img;
	private int chk;
	private int ac_receiver;
	private int ac_sender;
	private String sender_nickname;
	private String sender_img;
	private boolean isMine;
	
}
