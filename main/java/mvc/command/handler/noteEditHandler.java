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

public class noteEditHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        String method = request.getMethod();

        String pageidx = null;
        int noteIdx = -1; // 기본값 설정

        if ("GET".equalsIgnoreCase(method)) {
            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }
            if (request.getParameter("noteidx") != null && !"".equals(request.getParameter("noteidx"))) {
                noteIdx = Integer.parseInt(request.getParameter("noteidx"));
            }

            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                CategoryDAO cDao = new CategoryDAOImpl(conn);
                GenreDAO gDao = new GenreDAOImpl(conn);
                ContentsDAO ctDao = new ContentsDAOImpl(conn);
                UserNoteDAO unDao = new UserNoteDAOImpl(conn);

                List<CategoryVO> categoryList = cDao.CategoryAll();
                List<GenreVO> genreList = gDao.GenreAll();
                List<ContentsVO> contentList = ctDao.ContentsAll();
                NoteVO note = null;
                if (noteIdx != -1) {
                    note = unDao.getNote(noteIdx); // getNote로 노트 정보 조회

                    // --- 추가된 부분: img src에 /vibesync 제거 ---
                    if (note != null && note.getText() != null) {
                        String text = note.getText();
                        // 여러 개의 img 태그에 대해 src="/vibesync/..." 부분을 제거
                        text = text.replaceAll("(<img[^>]*src=\")./vibesync/", "$1");
                        note.setText(text);
                        System.out.println(note.getText());
                    }
                    // --- 추가된 부분 끝 ---
                }

                request.setAttribute("pageidx", pageidx);
                request.setAttribute("categoryList", categoryList);
                request.setAttribute("genreList", genreList);
                request.setAttribute("contentList", contentList);
                request.setAttribute("note", note);

            } catch (NamingException | java.sql.SQLException e) {
                throw new RuntimeException("리스트 조회 오류", e);
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
            // 작성 폼 JSP로 포워드
            return "edit.jsp"; // 수정: "write.jsp" → "noteedit.jsp"

        } else if ("POST".equalsIgnoreCase(method)) {
            if (request.getParameter("pageidx") != null && !"".equals(request.getParameter("pageidx"))) {
                pageidx = request.getParameter("pageidx");
            }
            if (request.getParameter("noteidx") != null && !"".equals(request.getParameter("noteidx"))) {
                noteIdx = Integer.parseInt(request.getParameter("noteidx"));
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

            // --- 수정된 부분: 모든 <img src="...">를 ./vibesync로 교체 ---
            Pattern imgPattern = Pattern.compile("<img([^>]*?)src=\"(?!\\./vibesync/)(sources/noteImg/[^\"]+)\"");
            Matcher matcher = imgPattern.matcher(processedContent);

            StringBuffer sb = new StringBuffer();
            while (matcher.find()) {
                String attributes = matcher.group(1);
                String originalSrc = matcher.group(2);
                String replacement = "<img" + attributes + "src=\"./vibesync/" + originalSrc + "\"";
                matcher.appendReplacement(sb, Matcher.quoteReplacement(replacement));
            }
            matcher.appendTail(sb);
            processedContent = sb.toString();
            // --- 수정된 부분 끝 ---

            String imagesForDB = String.join("|", dbRelativePaths);
            // --- 변경된 부분 끝 ---

            int categoryIdx = Integer.parseInt(request.getParameter("category_idx"));
            int genreIdx    = Integer.parseInt(request.getParameter("genre_idx"));
            int contentIdx  = Integer.parseInt(request.getParameter("content_idx"));

            NoteVO note = NoteVO.builder()
                .note_idx(noteIdx) // 수정: noteIdx가 있으면 updateNote 호출
                .title(title)
                .text(processedContent)
                .img(imagesForDB)
                .category_idx(categoryIdx)
                .genre_idx(genreIdx)
                .content_idx(contentIdx)
                .build();

            Connection conn = ConnectionProvider.getConnection();
            UserNoteDAO dao = new UserNoteDAOImpl(conn);
            if (noteIdx != -1) {
                dao.updateNote(note); // 수정: noteIdx가 있으면 updateNote 호출
            } else {
                dao.createNote(note);
            }

            response.sendRedirect(request.getContextPath() + "/vibesync/page.do");
            return null;
        }
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return null;
    }
}
