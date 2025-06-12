package mvc.domain.dto;

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
public class DailyStatsDTO { // 일별 게시글 수를 담기 위한 DTO
	
    private String statDate; // 날짜 (예: "2025-06-11")
    private long count;      // 집계된 수
    
}
