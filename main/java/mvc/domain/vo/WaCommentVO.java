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

public class WaCommentVO {
	private int wacIdx;
    private String nickname;
    private String chatting;
    private double timeline;
    private Timestamp createdAt;
    private int watchPartyIdx;
}
