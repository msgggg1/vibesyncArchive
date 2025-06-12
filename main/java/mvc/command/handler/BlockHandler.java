package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.BlockService;
import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.CategoryPostsConfigDTO;
import mvc.domain.dto.UserStatsBlockDTO;
import mvc.domain.vo.CategoryVO;
import mvc.domain.vo.UserVO;

public class BlockHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 요청 메소드에 따라 적절한 private 메소드 호출
        String method = request.getMethod();
        
        if ("GET".equalsIgnoreCase(method)) {
            doGet(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            doPost(request, response);
        } else if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else {
            // 허용되지 않은 메소드에 대한 처리
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
        
        return null;
    }
	
    // GET 요청 처리 : 블록 새로고침
    private void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        int acIdx = userInfo.getAc_idx();
        
        int block_id = Integer.parseInt(request.getParameter("block_id"));
        
        // 블록 내용 조회
        BlockService blockService = new BlockService();
        BlockDTO blockData = blockService.getBlockContentAsDto(acIdx, block_id);

        if (blockData == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "블록 정보를 찾을 수 없거나 접근 권한이 없습니다.");
            return;
        }
        
        // gson
        if (blockData instanceof UserStatsBlockDTO) {
            Gson gson = new Gson();
            String chartDataJsonString = gson.toJson(((UserStatsBlockDTO) blockData).getChartData());
            request.setAttribute("chartDataJson", chartDataJsonString);
        }

        // HTML 프래그먼트 반환
        response.setContentType("text/html; charset=UTF-8");
        request.setAttribute("block", blockData);
        String forwardPath = "/WEB-INF/views/workspace/fragments/_" + blockData.getBlock_type().toString() + "Content.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(forwardPath);
        dispatcher.forward(request, response);
    }
    
    // POST 요청 처리 : 블록 추가
    private void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        int acIdx = userInfo.getAc_idx();

        String block_type = request.getParameter("block_type");
        
        // 블록 추가
        // 설정값(config) JSON 문자열 생성
        String configJson = createConfigJson(request);

        // 서비스 호출하여 DB에 블록 추가 후, 새로 생성된 block_id 획득
        BlockService blockService = new BlockService();
        int newblock_id = blockService.addBlock(acIdx, block_type, configJson);

        // 새로 추가된 블록의 내용을 다시 조회 (doGet 로직 재활용)
        BlockDTO newBlockData = blockService.getBlockContentAsDto(acIdx, newblock_id);
        
        // gson
        if (newBlockData instanceof UserStatsBlockDTO) {
            Gson gson = new Gson();
            String chartDataJsonString = gson.toJson(((UserStatsBlockDTO) newBlockData).getChartData());
            request.setAttribute("chartDataJson", chartDataJsonString);
        }

        // HTML 프래그먼트 반환
        response.setContentType("text/html; charset=UTF-8");
        request.setAttribute("block", newBlockData);
        String forwardPath = "/WEB-INF/views/workspace/fragments/_" + newBlockData.getBlock_type().toString() + "Content.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(forwardPath);
        dispatcher.forward(request, response);
    }
    
    // DELETE 요청 : 블록 삭제
    private void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
            return;
        }
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        int acIdx = userInfo.getAc_idx();

        int block_id = Integer.parseInt(request.getParameter("block_id"));

        // 블록 삭제
        BlockService blockService = new BlockService();
        boolean isSuccess = blockService.removeBlock(acIdx, block_id);

        // JSON 결과 반환
        if (isSuccess) {
            out.print(gson.toJson(Map.of("success", true, "message", "블록이 삭제되었습니다.")));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "블록 삭제에 실패했거나 권한이 없습니다.")));
        }
    }
    
    // 요청 파라미터를 기반으로 config JSON 문자열을 생성하는 헬퍼 메소드
    private String createConfigJson(HttpServletRequest request) {
        String block_type = request.getParameter("block_type");
        Gson gson = new Gson();
        
        if ("CategoryPosts".equals(block_type)) {
            try {
                int category_idx = Integer.parseInt(request.getParameter("category_idx"));
                String sort_type = request.getParameter("sort_type");
                CategoryPostsConfigDTO config = 
                		new CategoryPostsConfigDTO(category_idx, ((List<CategoryVO>) request.getSession().getAttribute("categoryVOList")).get(category_idx).getC_name(), sort_type);
                return gson.toJson(config);
            } catch (NumberFormatException e) {
                return "{}";
            }
        }
        
        return "{}"; // 기본값
    }

}
