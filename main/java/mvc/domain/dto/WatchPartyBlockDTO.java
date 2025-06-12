package mvc.domain.dto;

import java.util.List;

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
public class WatchPartyBlockDTO extends BlockDTO { // workspace.jsp 추가블럭 : 구독 계정들의 워치파티 진행목록

	private List<WatchPartyDTO> watchParties;
	
}
