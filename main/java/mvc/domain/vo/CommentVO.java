package mvc.domain.vo;

import java.io.Serializable;
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
public class CommentVO implements Serializable {
    private int commentlist_idx;
    private String text;
    private int like_count;
    private Timestamp create_at;
    private int re_commentlist_idx;
    private int note_idx;
    private int ac_idx;
    
    // userAccount 테이블과 JOIN하여 가져오는 닉네임
    private String nickname; 
    
    // [추가] 계층형 쿼리에서 사용할 댓글의 깊이
    private int depth;
}