package mvc.domain.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import mvc.domain.vo.UserSummaryVO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class SidebarDTO {

	private List<UserSummaryVO> followingList; // 유저가 팔로우하고 있는 계정 목록
	
}
