package mvc.command.service;

import java.time.LocalDate;
import java.util.List;

import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.MessageListDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.MessageVO;
import mvc.domain.vo.TodoVO;

public class WorkspaceService {

    private TodoService todoService = new TodoService();
    private NoteService noteService = new NoteService();
    private MessageService messageService = new MessageService();
    private BlockService blockService = new BlockService();
    

    public WorkspaceDTO getInitialData(int acIdx) throws Exception {
        WorkspaceDTO dto = null;
        
        List<TodoVO> todolists = todoService.getTodoListByUser(acIdx);
        List<NoteSummaryDTO> myPosts = noteService.getMyPostsPreview(acIdx);
        List<NoteSummaryDTO> myAllPosts = noteService.getAllMyPosts(acIdx);
        List<NoteSummaryDTO> likedPosts = noteService.getLikedPostsPreview(acIdx);
        List<NoteSummaryDTO> likedAllPosts = noteService.getAllLikedPosts(acIdx);
        List<MessageListDTO> unreadMessages = messageService.getUnreadMessageList(acIdx);
        List<BlockDTO> blocks = blockService.getBlocksForUser(acIdx, null);
        
        System.out.println("MessageService가 반환한 안읽은 메시지 개수: " + (unreadMessages != null ? unreadMessages.size() : "null"));
        
        System.out.println("MessageService가 반환한 안읽은 메시지 개수: " + (unreadMessages != null ? unreadMessages.size() : "null"));
        
        dto = new WorkspaceDTO().builder()
        					    .todolists(todolists)
        					    .myPosts(myPosts)
        					    .likedPosts(likedPosts)
        					    .unreadMessages(unreadMessages)
        					    .blocks(blocks)
        					    .build();

        return dto;
    }
}

