package mvc.domain.dto;

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
public class NoteDTO {
	private int note_idx;
	private String title;
    private String text;
    private String img;
    private int popularityScore;
    private int content_idx;
    private int genre_idx;
    private int category_idx;
}