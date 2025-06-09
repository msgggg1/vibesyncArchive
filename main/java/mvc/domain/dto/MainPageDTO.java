package mvc.domain.dto;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import mvc.domain.vo.NoteVO;
import mvc.domain.vo.UserVO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class MainPageDTO {

    private List<NoteVO> latestNotes; // 선호 카테고리 최신글
    private List<NoteVO> popularNotes; // 선호 카테고리 인기글
    private List<UserVO> popularUsers; // 선호 카테고리 인기유저
    private Map<Integer, List<NoteVO>> popularNotesNotByMyCategory; // 비선호 카테고리별 인기글
	
}
