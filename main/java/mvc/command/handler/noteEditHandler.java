package mvc.command.handler;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.ConnectionProvider;

import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.ContentsVO;
import mvc.domain.vo.GenreVO;
import mvc.domain.vo.NoteVO;
import mvc.persistence.dao.CategoryDAO;
import mvc.persistence.dao.ContentsDAO;
import mvc.persistence.dao.GenreDAO;
import mvc.persistence.dao.UserNoteDAO;
import mvc.persistence.daoImpl.CategoryDAOImpl;
import mvc.persistence.daoImpl.ContentsDAOImpl;
import mvc.persistence.daoImpl.GenreDAOImpl;
import mvc.persistence.daoImpl.UserNoteDAOImpl;

public class noteEditHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String method = request.getMethod();

        String pageidx = null;
        int noteIdx = -1; 

        if ("GET".equalsIgnoreCase(method)) {
            // --- GET 요청 처리 (수정 페이지 진입) ---
            pageidx = request.getParameter("pageidx");
            noteIdx = Integer.parseInt(request.getParameter("noteidx"));

            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                UserNoteDAO unDao = new UserNoteDAOImpl(conn);
                NoteVO note = unDao.getNote(noteIdx);

                // [수정] DB에 저장된 이미지의 상대 경로를 절대 경로로 변환하여 에디터에 전달
                if (note != null && note.getText() != null) {
                    String text = note.getText();
                    String contextPath = request.getContextPath();
                    text = text.replaceAll("src=\"\\./", "src=\"" + contextPath + "/");
                    note.setText(text);
                }
                
                // 기타 카테고리, 장르 등 정보 조회
                CategoryDAO cDao = new CategoryDAOImpl(conn);
                GenreDAO gDao = new GenreDAOImpl(conn);
                ContentsDAO ctDao = new ContentsDAOImpl(conn);
                request.setAttribute("categoryList", cDao.CategoryAll());
                request.setAttribute("genreList", gDao.GenreAll());
                request.setAttribute("contentList", ctDao.ContentsAll());
                
                request.setAttribute("pageidx", pageidx);
                request.setAttribute("note", note);

            } catch (Exception e) {
                throw new RuntimeException("수정 페이지 로드 오류", e);
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
            return "edit.jsp"; 

        } else if ("POST".equalsIgnoreCase(method)) {
            // --- POST 요청 처리 (수정 내용 저장) ---
            noteIdx = Integer.parseInt(request.getParameter("noteidx"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String base64Images = request.getParameter("images");

            String saveDirPath = request.getServletContext().getRealPath("/sources/noteImg");
            File saveDir = new File(saveDirPath);
            if (!saveDir.exists()) saveDir.mkdirs();

            String safeTitle = title.replaceAll("[^a-zA-Z0-9가-힣]", "_");
            
            // [수정] noteCreateHandler와 동일한 이미지 처리 로직 적용
            if (base64Images != null && !base64Images.isEmpty()) {
                String[] imageDataArray = base64Images.split("\\|");
                int imgCounter = (int) (System.currentTimeMillis() / 1000); // 파일명 중복 방지를 위해 시간 사용

                for (String base64Data : imageDataArray) {
                    if (base64Data == null || base64Data.isEmpty()) continue;
                    try {
                        String[] parts = base64Data.split(",");
                        if (parts.length != 2) continue;

                        String imageType = parts[0].substring("data:image/".length(), parts[0].indexOf(";base64"));
                        byte[] imageBytes = Base64.getDecoder().decode(parts[1]);
                        String fileName = safeTitle + "_" + imgCounter++ + "." + imageType;
                        
                        File outFile = new File(saveDir, fileName);
                        try (FileOutputStream fos = new FileOutputStream(outFile)) {
                            fos.write(imageBytes);
                        }

                        // content 안의 Base64 데이터를 실제 파일의 상대 경로로 교체
                        String relativePath = "./sources/noteImg/" + fileName;
                        content = content.replace(base64Data, relativePath);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            // DB에 저장할 VO 객체 생성
            int categoryIdx = Integer.parseInt(request.getParameter("category_idx"));
            int genreIdx    = Integer.parseInt(request.getParameter("genre_idx"));
            int contentIdx  = Integer.parseInt(request.getParameter("content_idx"));

            NoteVO note = NoteVO.builder()
                .note_idx(noteIdx)
                .title(title)
                .text(content)
                //.img(imagesForDB) // img 필드는 본문에 포함되므로 별도 저장은 필요 없을 수 있음 (필요 시 로직 추가)
                .category_idx(categoryIdx)
                .genre_idx(genreIdx)
                .content_idx(contentIdx)
                .build();

            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                UserNoteDAO dao = new UserNoteDAOImpl(conn);
                dao.updateNote(note);
            } catch (Exception e) {
                throw new RuntimeException("노트 업데이트 오류", e);
            } finally {
                if (conn != null) conn.close();
            }

            // 수정 완료 후 해당 게시글 보기 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/vibesync/postView.do?nidx=" + noteIdx);
            return null;
        }
        
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }
}
