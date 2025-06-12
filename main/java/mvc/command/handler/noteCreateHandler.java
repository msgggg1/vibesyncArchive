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
        request.setCharacterEncoding("UTF-8");
        String method = request.getMethod();

        String pageidx = null;

        if ("GET".equalsIgnoreCase(method)) {

            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }

            // 페이지 진입: 카테고리, 장르, 콘텐츠 리스트 조회
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
            // 작성 폼 JSP로 포워드
            return "write.jsp";

        } else if ("POST".equalsIgnoreCase(method)) {
            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }

            // --- 변경된 부분 시작: Base64 이미지 저장 및 content 내 img src 수정 로직 ---
            String title = request.getParameter("title");
            String processedContent = request.getParameter("content");
            String base64Images = request.getParameter("images"); // '|' 구분된 Base64 이미지

            System.out.println("processedContent : " + processedContent);
            System.out.println("base64Images : " + base64Images);

            // 이미지 저장 디렉터리 준비
            String saveDirPath = request.getServletContext().getRealPath("/vibesync/sources/noteImg");
            File saveDir = new File(saveDirPath);
            if (!saveDir.exists()) saveDir.mkdirs();

            System.out.println("title : " + title);
            String safeTitle = title.replaceAll("[^a-zA-Z0-9]", "_");
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

                        String fileName = safeTitle + "_" + imgCounter + "." + imageType;
                        imgCounter++;

                        File outFile = new File(saveDir, fileName);
                        try (FileOutputStream fos = new FileOutputStream(outFile)) {
                            fos.write(imageBytes);
                        }

                        dbRelativePaths.add("sources/noteImg/" + fileName);
                    } catch (IllegalArgumentException | IOException e) {
                        e.printStackTrace();
                    }
                }
            }

            // img src 수정 로직 (패턴 오류 수정 적용)
            String context = request.getContextPath().replaceFirst("^/", "");
            String updated = processedContent;
            Pattern imgPattern = Pattern.compile("<img[^>]*src=\"(?!vibesync/)([^\"]+)\"");
            Matcher matcher = imgPattern.matcher(updated);

            StringBuffer sb = new StringBuffer();
            int replaceIndex = 0;
            while (matcher.find() && replaceIndex < dbRelativePaths.size()) {
                String replacement = "<img src=\"./vibesync/" + dbRelativePaths.get(replaceIndex++) + "\"";
                matcher.appendReplacement(sb, Matcher.quoteReplacement(replacement));
            }
            matcher.appendTail(sb);
            processedContent = sb.toString();

            String imagesForDB = String.join("|", dbRelativePaths);
            // --- 변경된 부분 끝 ---

            int categoryIdx = Integer.parseInt(request.getParameter("category_idx"));
            int genreIdx    = Integer.parseInt(request.getParameter("genre_idx"));
            int contentIdx  = Integer.parseInt(request.getParameter("content_idx"));
            int userPgIdx   = Integer.parseInt(request.getParameter("pageidx"));

            NoteVO note = NoteVO.builder()
                .title(title)
                .text(processedContent)
                .img(imagesForDB)
                .category_idx(categoryIdx)
                .genre_idx(genreIdx)
                .content_idx(contentIdx)
                .userPg_idx(userPgIdx)
                .build();

            Connection conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            dao.createNote(note);

            response.sendRedirect(request.getContextPath() + "/vibesync/page.do");
            return null;
        }
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }
}


