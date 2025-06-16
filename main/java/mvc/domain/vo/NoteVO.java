package mvc.domain.vo;

import java.util.Date;

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
public class NoteVO {
	
	private int note_idx;
	private String title;
	private String text;
	private String img;
	private Date create_at;
	private Date edit_at;
	private int view_count;
	private String titleImg;
	private int content_idx;
	private int genre_idx;
	private int category_idx;
	private int userPg_idx;
}
