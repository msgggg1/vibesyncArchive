package mvc.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import mvc.domain.vo.UserSummaryVO;
import mvc.domain.vo.WatchPartyVO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class WatchPartyDTO {
	
	private WatchPartyVO watchparty;
	private int current_num;
	private int max_num;
	private UserSummaryVO host;

}
