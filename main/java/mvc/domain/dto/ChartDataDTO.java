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
public class ChartDataDTO { // Chart.js와 같은 라이브러리 형식에 맞춘 데이터 객체
    // 차트의 X축에 표시될 라벨 리스트
    // 예: ["월", "화", "수", "목", "금", "토", "일"] 또는 ["1월", "2월", "3월"]
    private List<String> labels; // 예: ["06-09", "06-10", "06-11"]

    // 차트에 그려질 데이터 셋 리스트 (조회수, 좋아요 수 등 여러 데이터를 한 차트에 표시 가능)
    private List<DatasetDTO> datasets;
}
