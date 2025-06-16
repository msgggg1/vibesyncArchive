package mvc.command.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mvc.command.service.ListService;
import mvc.domain.dto.NotePageResultDTO;

public class ListHandler implements CommandHandler {
    private ListService listService = new ListService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 파라미터 수신 및 기본값 설정
        String categoryParam = request.getParameter("category_idx");
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");

        int categoryIdx = (categoryParam != null && !categoryParam.isEmpty()) ? Integer.parseInt(categoryParam) : 0; // 0: 전체
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int size = (sizeParam != null && !sizeParam.isEmpty()) ? Integer.parseInt(sizeParam) : 10; // 페이지 당 10개

        // 2. 서비스 호출
        NotePageResultDTO resultDTO = listService.getNoteListPage(categoryIdx, page, size, searchType, keyword);

        // 3. 결과(Model)를 request에 저장
        request.setAttribute("result", resultDTO);
        request.setAttribute("searchType", searchType);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category_idx", categoryIdx);
        
        // 4. 뷰 경로 반환
        return "list.jsp";
    }
}