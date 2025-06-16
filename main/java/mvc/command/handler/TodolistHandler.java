package mvc.command.handler;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import mvc.command.service.TodoService;
import mvc.domain.vo.TodoVO;
import mvc.domain.vo.UserVO;

public class TodolistHandler implements CommandHandler {

    private TodoService todoService = new TodoService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 세션에서 로그인한 사용자 정보 확인
        HttpSession session = request.getSession(false);        
        UserVO loginUser = (UserVO) session.getAttribute("userInfo");
        int acIdx = loginUser.getAc_idx();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        String action = request.getParameter("action"); 

        // --- 할 일 목록 조회 ---
        if (action == null || "getTodoList".equals(action)) { // action 파라미터가 없거나 "getTodoList"일 경우
            List<TodoVO> todoList = todoService.getTodoListByUser(acIdx);
            String jsonResponse = gson.toJson(todoList);
            out.print(jsonResponse);
            out.flush();
            return null; // AJAX 응답이므로 null 반환
        } else if ("addTodo".equals(action)) {
            // 1. 요청 파라미터로 VO 객체 생성
            TodoVO newTodo = TodoVO.builder()
                    .text(request.getParameter("text"))
                    .todo_group(request.getParameter("todo_group"))
                    .color(request.getParameter("color"))
                    .ac_idx(acIdx) // 핸들러 초반에 세션에서 가져온 사용자 ID
                    .build();
            
            // 2. 서비스를 호출하여 할 일 추가
            boolean result = todoService.addTodo(newTodo);
            
            // 3. 성공 여부를 JSON으로 응답
            out.print(gson.toJson(Map.of("success", result)));
            
            return null; // AJAX 응답이었으므로 null 반환
        } else if ("updateStatus".equals(action) || "delete".equals(action) || "updateTodo".equals(action)) {
            // 자바스크립트가 보낸 이름 그대로 파라미터를 받습니다.
            String todoIdxStr = request.getParameter("todoIdx");

            // 안전을 위한 null 체크
            if (todoIdxStr == null || todoIdxStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Required parameters are missing.");
                return null;
            }

            try {
                int todoIdx = Integer.parseInt(todoIdxStr);
                boolean result = false;
                
                if ("updateStatus".equals(action)) {
                    String statusStr = request.getParameter("status");
                    boolean isCompleted = "1".equals(statusStr);
                    result = todoService.updateTodoStatus(todoIdx, isCompleted);
                    
                } else if ("delete".equals(action)) {
                    result = todoService.deleteTodo(todoIdx);

                } else if ("updateTodo".equals(action)) {
                    TodoVO updatedTodo = TodoVO.builder()
                            .todo_idx(todoIdx) 
                            .text(request.getParameter("text"))
                            .todo_group(request.getParameter("todo_group"))
                            .color(request.getParameter("color"))
                            .build();
                    result = todoService.updateTodo(updatedTodo);
                }
                
                // 성공 여부를 JSON으로 응답
                out.print(gson.toJson(Map.of("success", result)));
                out.flush();

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format for parameters.");
            }
            return null; // AJAX 응답이므로 null 반환
        }
        else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 action 파라미터입니다.");
            return null;
        }
    }
}
