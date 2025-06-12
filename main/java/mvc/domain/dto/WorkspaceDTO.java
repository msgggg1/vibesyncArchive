package mvc.domain.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import mvc.domain.vo.TodoVO;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class WorkspaceDTO {
	
    private List<TodoVO> todolists;
    private List<NoteSummaryDTO> myPosts;
    private List<NoteSummaryDTO> likedPosts;
    private List<MessageListDTO> unreadMessages;
    private List<BlockDTO> blocks;
    
}
