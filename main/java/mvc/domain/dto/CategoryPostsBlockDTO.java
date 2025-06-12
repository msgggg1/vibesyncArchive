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
public class CategoryPostsBlockDTO extends BlockDTO { // workspace.jsp 추가블럭 : 카테고리별 인기/최신글

	private int categoryIdx;
	private String categoryName;
	private String sortType;
	private List<NoteSummaryDTO> posts;
	
}
