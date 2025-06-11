package mvc.domain.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoteSummaryDTO {
    private int note_idx;           // 게시글 ID (postView로 링크 시 필요)
    private String title;           // 게시글 제목
    private String thumbnail_img;   // 게시글 썸네일 이미지 경로 (note 테이블의 img 필드 등)
    private int view_count;
    private int like_count;
    private String author_name;
}