package mvc.command.Handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.command.Service.NoteService;
import mvc.domain.dto.NoteDetailDTO;



public class NoteViewHandler implements CommandHandler { // CommandHandler 인터페이스를 구현한다고 가정

    private NoteService noteService; // 서비스 계층 의존성

    public NoteViewHandler() {
        this.noteService = new NoteService(); 
    }

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 요청 파라미터에서 noteIdx 가져오기
        String noteIdxParam = request.getParameter("noteIdx"); 
        if (noteIdxParam == null || noteIdxParam.isEmpty()) {
            request.setAttribute("error", "유효하지 않은 게시글 접근입니다.");
            return "/WEB-INF/view/errorPage.jsp"; // 예시 에러 페이지
        }

        int noteIdx;
        try {
            noteIdx = Integer.parseInt(noteIdxParam);
        } catch (NumberFormatException e) {
            // 숫자로 변환할 수 없는 경우 에러 처리
            request.setAttribute("error", "게시글 ID 형식이 올바르지 않습니다.");
            return "/WEB-INF/view/errorPage.jsp"; // 예시 에러 페이지
        }

        // 2. 서비스 호출하여 게시글 상세 정보 가져오기
        NoteDetailDTO noteDetail = noteService.getNoteDetailById(noteIdx);
        
     // --- 디버깅 로그 추가 ---
        if (noteDetail != null) {
            System.out.println("[NoteViewHandler] 조회된 noteDetail DTO: " + noteDetail.toString()); // Lombok @ToString이 있다면
            // 또는 주요 필드 몇 개를 직접 출력:
            // System.out.println("[NoteViewHandler] DTO Title: " + noteDetail.getTitle());
            // System.out.println("[NoteViewHandler] DTO Nickname: " + noteDetail.getNickname());
        } else {
            System.out.println("[NoteViewHandler] noteService.getNoteDetailById(" + noteIdx + ") 가 null을 반환했습니다.");
        }
        // --- 디버깅 로그 끝 ---

        // 3. 결과 처리 및 뷰에 데이터 전달
        if (noteDetail == null) {
            // 해당 ID의 게시글이 없는 경우
            request.setAttribute("message", "요청하신 게시글을 찾을 수 없습니다.");
            return "/WEB-INF/view/messagePage.jsp"; // 예시
        } else {
            request.setAttribute("note", noteDetail); 

            // 4. 보여줄 JSP 페이지 경로 반환
            return "/vibesync/noteView.jsp"; 
        }
    }
}