package mvc.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@ToString(callSuper = true)
public class UserStatsBlockDTO extends BlockDTO { // workspace.jsp 추가블럭 : 내 활동 통계

    private String title; // 예: "최근 7일간 활동 요약", "2025년 월별 게시글 수"
    private String period;
    private ChartDataDTO chartData; // 차트에 필요한 모든 데이터를 담는 객체
    private String chartDataJson;
	
}
