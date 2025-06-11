package mvc.command.service;

import java.time.LocalDate;
import java.util.List;

import mvc.domain.dto.MessageListDTO;
import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.dto.WorkspaceDTO;
import mvc.domain.vo.MessageVO;
import mvc.domain.vo.TodoVO;

public class WorkspaceService {

    private TodoService todoService = new TodoService();
    private NoteService noteService = new NoteService();
    private MessageService messageService = new MessageService();
    private WatchPartyService watchPartyService = new WatchPartyService();

    public WorkspaceDTO getInitialData(int acIdx) throws Exception {
        WorkspaceDTO dto = null;
        
        List<TodoVO> todolists = todoService.getTodoListByUser(acIdx);
        List<NoteSummaryDTO> myPosts = noteService.getMyPostsPreview(acIdx);
        List<NoteSummaryDTO> myAllPosts = noteService.getAllMyPosts(acIdx);
        List<NoteSummaryDTO> likedPosts = noteService.getLikedPostsPreview(acIdx);
        List<NoteSummaryDTO> likedAllPosts = noteService.getAllLikedPosts(acIdx);
        List<MessageListDTO> unreadMessages = messageService.getUnreadMessageList(acIdx);
        // List<NoteSummaryDTO> postsByCategory = noteService.getPostsByCategory(acIdx, null);
        // List<WatchPartyDTO> followingWatchParties = watchPartyService.getFollowingWatchParties(acIdx);
        // NoteStatsDTO userNoteStats = noteService.getUserNoteStats(acIdx);
        
        dto = new WorkspaceDTO().builder()
        					    .todolists(todolists)
        					    .myPosts(myPosts)
        					    .likedPosts(likedPosts)
        					    .unreadMessages(unreadMessages)
        					    // .postsByCategory(postsByCategory)
        					    // .followingWatchParties(followingWatchParties)
        					    // .userNoteStats(userNoteStats)
        					    .build();

        return dto;
    }
}

