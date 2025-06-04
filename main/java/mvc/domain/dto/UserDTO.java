package mvc.domain.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
	 private int ac_idx;
	    private String email;
	    private String pw; // 실제 사용 시에는 DTO에 비밀번호를 담지 않거나, 응답 시 제외
	    private String salt; // 위와 동일
	    private String nickname;
	    private String img;
	    private String name;
	    private Timestamp created_at;
	    private int category_idx;
}
