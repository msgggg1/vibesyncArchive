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
public class NoteDetailDTO {

    
    private int note_idx;           
    private String title;     
    private String text;     // (CLOB 데이터는 String으로 처리)
    private Timestamp create_at;
    private int view_count;     

    private int ac_idx;       
    private String nickname;
    private String img; // 프로필 사진         

    private boolean followedByCurrentUser;
    private boolean likedByCurrentUser;
    private int like_count; 
}