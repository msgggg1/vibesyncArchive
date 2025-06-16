package mvc.command.handler;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import mvc.command.service.BlockService;
import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.CategoryPostsConfigDTO;
import mvc.domain.dto.UserStatsBlockDTO;
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
        } else {
            // 허용되지 않은 메소드에 대한 처리
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
        
        return null;
    }
	
    // GET 요청 처리 : 블록 새로고침
    private void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int acIdx = getLoginedAcIdx(request);
        if(acIdx == -1) {
        	response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
        	return;
        }

        int block_id = Integer.parseInt(request.getParameter("block_id"));
        String period = request.getParameter("period");

        // 1. 서비스 호출하여 블록 데이터 조회
        BlockService blockService = new BlockService();
        BlockDTO blockData = blockService.getBlockContentAsDto(acIdx, block_id, period);

        if (blockData == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "블록 정보를 찾을 수 없거나 접근 권한이 없습니다.");
            return;
        }

        // 2. JSP 프래그먼트를 HTML 문자열로 렌더링
        request.setAttribute("block", blockData);
        // UserStatsBlock인 경우, chartDataJson을 request에 담음

        if (blockData instanceof UserStatsBlockDTO) {
             Gson gson = new Gson();
             String chartDataJsonString = gson.toJson(((UserStatsBlockDTO) blockData).getChartData());
             request.setAttribute("chartDataJson", chartDataJsonString);
        }
        String forwardPath = "/WEB-INF/views/workspace/fragments/_" + blockData.getBlock_type().toString() + "Content.jsp";
        String htmlContent = renderJspToString(request, response, forwardPath);

        // 3. 클라이언트에 보낼 JSON 데이터 구성
        Map<String, Object> jsonResponse = new java.util.HashMap<>();
        jsonResponse.put("html", htmlContent);
        jsonResponse.put("block_type", blockData.getBlock_type().toString());

        // 4. 차트 블록인 경우, 차트 데이터도 JSON에 추가
        if (blockData instanceof UserStatsBlockDTO) {
            // DTO에서 차트 데이터를 직접 가져와 Map에 추가
            jsonResponse.put("chart_data", ((UserStatsBlockDTO) blockData).getChartData());
            jsonResponse.put("title", ((UserStatsBlockDTO) blockData).getTitle());
        }

        // 5. JSON 응답 전송
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(jsonResponse));
        out.flush();
    }
    
    // POST 요청 처리 : 블록 추가, 블록 삭제, 블록 순서 편집 (ADD, DELETE, EDIT)
    private void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String methodOverride = request.getParameter("_method");

        if ("ADD".equalsIgnoreCase(methodOverride)) {
        	doAdd(request, response);
        	return;
        } else if ("DELETE".equalsIgnoreCase(methodOverride)) {
            doDelete(request, response);
            return;
        } else if ("EDIT".equalsIgnoreCase(methodOverride)) {
            doEdit(request, response);
            return;
        }

    }
    
    // ADD 요청 : 블록 추가
    private void doAdd(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int acIdx = getLoginedAcIdx(request);
        if(acIdx == -1) {
        	response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
        	return;
        }

        String block_type = request.getParameter("block_type");
        String configJson = createConfigJson(request);
        String period = request.getParameter("period");

        // DB에 블록 추가 후, 새로 생성된 block_id 획득
        BlockService blockService = new BlockService();
        int newblock_id = blockService.addBlock(acIdx, block_type, configJson);
        
        if (newblock_id > 0) {
            BlockDTO newBlockData = blockService.getBlockContentAsDto(acIdx, newblock_id, period);

            // JSP 프래그먼트를 HTML 문자열로 렌더링하기 위해 request에 데이터 설정
            request.setAttribute("block", newBlockData);
            if (newBlockData instanceof UserStatsBlockDTO) {
                Gson gson = new Gson();
                String chartDataJsonString = gson.toJson(((UserStatsBlockDTO) newBlockData).getChartData());
                request.setAttribute("chartDataJson", chartDataJsonString);
            }
            String forwardPath = "/WEB-INF/views/workspace/fragments/_blockWrapper.jsp";
            String htmlContent = renderJspToString(request, response, forwardPath);

            // 클라이언트에 보낼 JSON 데이터 구성
            Map<String, Object> jsonResponse = new java.util.HashMap<>();
            jsonResponse.put("html", htmlContent);
            jsonResponse.put("block_type", newBlockData.getBlock_type().toString());
            jsonResponse.put("block_id", newBlockData.getBlock_id());

            // 차트 블록인 경우, 차트 데이터도 JSON에 추가
            if (newBlockData instanceof UserStatsBlockDTO) {
                jsonResponse.put("chart_data", ((UserStatsBlockDTO) newBlockData).getChartData());
            }
            
            // JSON 응답 전송
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(jsonResponse));
            out.flush();

        } else {
            // DB 추가 실패 시 에러 응답
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "블록 추가에 실패했습니다.");
        }
    }
    
    // DELETE 요청 : 블록 삭제
    private void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        int acIdx = getLoginedAcIdx(request);
        if(acIdx == -1) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
            return;
        }

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
    
    // EDIT 요청 : 블록 순서 편집
    private void doEdit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        int acIdx = getLoginedAcIdx(request);
        if(acIdx == -1) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(Map.of("success", false, "message", "로그인이 필요합니다.")));
            return;
        }

        String ordersJson = request.getParameter("orders");
        if (ordersJson == null || ordersJson.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("success", false, "message", "순서 데이터가 없습니다.")));
            return;
        }

        try {
            List<Map<String, Object>> orders = gson.fromJson(ordersJson, new TypeToken<List<Map<String, Object>>>(){}.getType());
            
            BlockService blockService = new BlockService();
            boolean isSuccess = blockService.changeBlockOrder(acIdx, orders);

            if (isSuccess) {
                out.print(gson.toJson(Map.of("success", true)));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(Map.of("success", false, "message", "블록 순서 업데이트에 실패했습니다.")));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Map.of("success", false, "message", "서버 오류가 발생했습니다.")));
        }
    }
    
    // 로그인 상태 확인 후 사용자 아이디를 반환하는 메소드
    private int getLoginedAcIdx(HttpServletRequest request) throws IOException {
    	int acIdx = -1;
    	
    	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userInfo") == null) {
            return acIdx;
        }
        UserVO userInfo = (UserVO) session.getAttribute("userInfo");
        acIdx = userInfo.getAc_idx();
        
        return acIdx;
    }
    
    
    // 요청 파라미터를 기반으로 config JSON 문자열을 생성하는 헬퍼 메소드
    private String createConfigJson(HttpServletRequest request) {
        String block_type = request.getParameter("block_type");
        Gson gson = new Gson();
        
        if ("CategoryPosts".equals(block_type)) {
            try {
                int category_idx = Integer.parseInt(request.getParameter("category_idx"));
                String sort_type = request.getParameter("sort_type");
                String category_name = request.getParameter("category_name");
                CategoryPostsConfigDTO config = 
                		new CategoryPostsConfigDTO(category_idx, sort_type, category_name);
                return gson.toJson(config);
            } catch (NumberFormatException e) {
                return "{}";
            }
        }
        
        return "{}"; // 기본값
    }
    
    // JSP 파일을 실행하여 그 결과를 HTML 문자열로 반환하는 헬퍼 메소드
    private String renderJspToString(HttpServletRequest request, HttpServletResponse response, String jspPath) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        
        // 응답을 가로채기 위한 StringWriter와 Wrapper 생성
        StringWriter stringWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(stringWriter);
        
        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            @Override
            public PrintWriter getWriter() {
                return printWriter;
            }
        };

        // forward 대신 include를 사용하여 JSP의 실행 결과를 Wrapper에 담음
        dispatcher.include(request, responseWrapper);
        printWriter.flush();
        
        return stringWriter.toString();
    }

}
