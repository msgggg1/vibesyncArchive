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
public class LikeDTO {
	   private int likes_idx;
	    private Timestamp created_at;
	    private int note_idx;
	    private int ac_idx; // 좋아요를 누른 사용자의 ID
}
