package mvc.command.handler;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

public class noteCreateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String method = request.getMethod();

        String pageidx = null;

        if ("GET".equalsIgnoreCase(method)) {
            // ... 기존 GET 로직과 동일 ...
            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }
            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                CategoryDAO cDao = new CategoryDAOImpl(conn);
                GenreDAO gDao = new GenreDAOImpl(conn);
                ContentsDAO ctDao = new ContentsDAOImpl(conn);

                List<CategoryVO> categoryList = cDao.CategoryAll();
                List<GenreVO> genreList = gDao.GenreAll();
                List<ContentsVO> contentList = ctDao.ContentsAll();

                request.setAttribute("pageidx", pageidx);
                request.setAttribute("categoryList", categoryList);
                request.setAttribute("genreList", genreList);
                request.setAttribute("contentList", contentList);

            } catch (NamingException | java.sql.SQLException e) {
                throw new RuntimeException("리스트 조회 오류", e);
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
            return "write.jsp";

        } else if ("POST".equalsIgnoreCase(method)) {
            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }

            // --- 썸네일 및 Summernote 이미지 처리 로직 ---
            String title = request.getParameter("title");
            String processedContent = request.getParameter("content");
            String base64Images = request.getParameter("images");
            
            // [추가] 썸네일 파라미터 받기
            String thumbnailBase64 = request.getParameter("thumbnail_base64");
            String thumbnailExt = request.getParameter("thumbnail_ext");
            String thumbnailDbPath = null;
            
            String saveDirPath = request.getServletContext().getRealPath("/sources/noteImg");
            File saveDir = new File(saveDirPath);
            if (!saveDir.exists()) saveDir.mkdirs();

            String safeTitle = title.replaceAll("[^a-zA-Z0-9가-힣]", "_");

            // [추가] 썸네일 이미지 저장 로직
            if (thumbnailBase64 != null && !thumbnailBase64.isEmpty() && thumbnailExt != null) {
                try {
                    String[] parts = thumbnailBase64.split(",");
                    if (parts.length == 2) {
                        byte[] imageBytes = Base64.getDecoder().decode(parts[1]);
                        String thumbnailFileName = "title_" + safeTitle + "." + thumbnailExt;
                        File outFile = new File(saveDir, thumbnailFileName);
                        try (FileOutputStream fos = new FileOutputStream(outFile)) {
                            fos.write(imageBytes);
                        }
                        thumbnailDbPath = "sources/noteImg/" + thumbnailFileName;
                    }
                } catch (Exception e) {
                    e.printStackTrace(); // 썸네일 저장 실패 시 에러 로깅
                }
            }
            
            // Summernote 본문 이미지 저장 로직
            int imgCounter = 1;
            List<String> dbRelativePaths = new ArrayList<>();
            if (base64Images != null && !base64Images.isEmpty()) {
                String[] imageDataArray = base64Images.split("\\|");
                for (String base64Data : imageDataArray) {
                    if (base64Data == null || base64Data.isEmpty()) continue;
                    try {
                        String[] parts = base64Data.split(",");
                        if (parts.length != 2 || !parts[0].startsWith("data:image/")) continue;

                        String imageType = parts[0].substring("data:image/".length(), parts[0].indexOf(";base64"));
                        byte[] imageBytes = Base64.getDecoder().decode(parts[1]);

                        // 본문 이미지는 원래 이름 규칙 유지
                        String fileName = safeTitle + "_" + imgCounter + "." + imageType;
                        imgCounter++;

                        File outFile = new File(saveDir, fileName);
                        try (FileOutputStream fos = new FileOutputStream(outFile)) {
                            fos.write(imageBytes);
                        }
                        
                        String relativePath = "sources/noteImg/" + fileName;
                        dbRelativePaths.add(relativePath);
                        // content 내의 base64 src를 실제 경로로 교체
                        processedContent = processedContent.replace(base64Data, "./" + relativePath);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
            
            String imagesForDB = String.join("|", dbRelativePaths);

            int categoryIdx = Integer.parseInt(request.getParameter("category_idx"));
            int genreIdx    = Integer.parseInt(request.getParameter("genre_idx"));
            int contentIdx  = Integer.parseInt(request.getParameter("content_idx"));
            int userPgIdx   = Integer.parseInt(request.getParameter("pageidx"));

            NoteVO note = NoteVO.builder()
                .title(title)
                .text(processedContent)
                .img(imagesForDB)
                .titleImg(thumbnailDbPath) // [추가] 썸네일 경로 설정
                .category_idx(categoryIdx)
                .genre_idx(genreIdx)
                .content_idx(contentIdx)
                .userPg_idx(userPgIdx)
                .build();

            Connection conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            dao.createNote(note);

            if(conn != null) conn.close();

            response.sendRedirect(request.getContextPath() + "/vibesync/page.do");
            return null;
        }
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }
}
