package mvc.domain.vo;

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
public class MessageVO {
	
	private int msg_idx;
	private String text;
	private Timestamp time;
	private String img;
	private int chk;
	private int ac_receiver;
	private int ac_sender;
	
}