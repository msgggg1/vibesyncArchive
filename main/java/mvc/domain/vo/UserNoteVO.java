package mvc.domain.vo;

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
public class UserNoteVO {
	
	private int note_idx;
	private String title;
	private String text;
	private String create_at;
	private int view_count;
	private int content_idx;
	private int genre_idx;
	private int note_category_idx;
	private int userPg_idx;
	
	private int ac_idx;
	private String email;
	private String pw;
	private String nickname;
	private String img;
	private String name;
	private int ac_category_idx;
	
	private int like_num;
	
	private int upac_idx;
}