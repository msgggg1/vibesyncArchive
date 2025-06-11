package mvc.domain.dto; 

import lombok.Getter;
import lombok.Setter;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.UserVO;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPageInfoDTO {
    
	private int ac_idx;                 // 사용자 ID
    private String nickname;            // 닉네임 (또는 name)
    private String img;                 // 프로필 이미지 경로
    private int postCount;              // 작성한 게시글 수
    private int followerCount;          // 팔로워 수
    private int followingCount;         // 팔로잉 수
    private boolean followedByCurrentUser; // 현재 로그인한 사용자가 이 프로필 사용자를 팔로우하는지 여부
    
    public UserPageInfoDTO(UserSummaryVO basicUserInfo) {
    	if (basicUserInfo != null) {
    		this.ac_idx = basicUserInfo.getAc_idx();
    		this.nickname = basicUserInfo.getNickname();
    		this.img = basicUserInfo.getProfile_img();
		}
    }
    
}
