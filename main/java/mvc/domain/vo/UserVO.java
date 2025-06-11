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
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class UserVO { // 세션에 담을 최소한의 사용자 정보
	// 로그인 성공 시 세션에 저장되는 객체
	// UI에 표시하거나 권한 판단 등에 필요한 정보만 포함
	// 절대 비밀번호나 민감한 데이터는 포함하지 않음

	private int ac_idx;
	private String email;
	private String nickname;
	private String img;
	private String name;
	private Timestamp created_at;
	private int category_idx;
	
}
