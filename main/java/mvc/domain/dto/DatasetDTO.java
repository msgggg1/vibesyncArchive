package mvc.domain.dto;

import java.util.List;

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
public class DatasetDTO { // 실제 데이터 셋을 담는 객체
    // 데이터 셋의 이름 (차트 범례에 표시됨)
    // 예: "조회수", "게시글 수"
    private String label; 

    // 라벨에 해당하는 실제 숫자 데이터 리스트
    // 예: [10, 25, 40, 33, 52, 48, 60]
    private List<Long> data;
}
