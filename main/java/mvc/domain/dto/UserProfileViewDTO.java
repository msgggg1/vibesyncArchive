package mvc.domain.dto; 

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
public class UserProfileViewDTO {
    private int ac_idx;             
    private String nickname;       
    private String img;         
    private int postCount;          
    private int followerCount;     
    private int followingCount;     
    
}