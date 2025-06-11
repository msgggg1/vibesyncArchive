package mvc.domain.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class UserSummaryVO { // 조회에 필요한 최소한의 정보

	private int ac_idx;
	private String nickname;
	private String profile_img;
	private int category_idx;
	
}
