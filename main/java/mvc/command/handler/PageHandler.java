package mvc.command.handler;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.command.service.PageService;
import mvc.domain.dto.PageResultDTO;
import mvc.domain.vo.NoteVO;
import mvc.domain.vo.PageVO;

public class PageHandler implements CommandHandler {
    private static final int DEFAULT_PAGE_SIZE = 10;
    private PageService service = new PageService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 페이징·검색 파라미터
        String pageParam   = request.getParameter("page");
        String sizeParam   = request.getParameter("size");
        String searchType  = request.getParameter("searchType");
        String keyword     = request.getParameter("keyword");

        int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
        int size = sizeParam != null ? Integer.parseInt(sizeParam) : DEFAULT_PAGE_SIZE;

        // 게시물 리스트 조회
        PageResultDTO dto = service.getPageResult(page, size, searchType, keyword);
        request.setAttribute("list", dto.getList());
        request.setAttribute("totalCount", dto.getFulllist().size());
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("searchType", searchType);
        request.setAttribute("keyword", keyword);

        // 만약 userPgIdx 파라미터가 있으면, 해당 노트들 조회
        String noteParam = request.getParameter("userPgIdx");
        if (noteParam != null) {
        	int upidx = Integer.parseInt(noteParam);
        	String title = null;
        	List<PageVO> pageList = dto.getList();
        	for (int i = 0; i < pageList.size(); i++) {
        		if (pageList.get(i).getAc_idx() == upidx) {
        			title = pageList.get(i).getSubject();
        		}
			}
        	
            int userPgIdx = Integer.parseInt(noteParam);
            List<NoteVO> notes = service.getNotesByPage(userPgIdx);
            request.setAttribute("notes", notes);
            request.setAttribute("pagetitle", title);
            request.setAttribute("selectedUserPgIdx", userPgIdx);
        }
        // 항상 page.jsp 로 포워딩
        return "page.jsp";
    }
}
