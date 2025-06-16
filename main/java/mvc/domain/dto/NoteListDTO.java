package mvc.domain.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class NoteListDTO {
    private int note_idx;
    private String title;
    private String author_name;
}