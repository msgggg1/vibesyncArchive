package mvc.command.handler;

import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import mvc.command.service.ScheduleService;
import mvc.domain.dto.CalendarEventDTO;
import mvc.domain.vo.ScheduleVO;
import mvc.domain.vo.UserVO;

public class ScheduleHandler implements CommandHandler {

    private ScheduleService scheduleService = new ScheduleService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession(false);
        UserVO loginUser = (UserVO) session.getAttribute("userInfo");
        int acIdx = loginUser.getAc_idx();

        // ✨ 1. action 파라미터를 받아 어떤 기능인지 확인합니다.
        String action = request.getParameter("action");
        System.out.println("[Handler] Received action parameter: '" + action + "'"); 

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "action 파라미터가 필요합니다.");
            return null;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
        
        try {
            // ✨ 2. action 값에 따라 다른 로직을 실행합니다.
            if ("getMonthlySchedules".equals(action)) {
                // 월별 일정 조회 로직
            	String startParam = request.getParameter("start"); // String 그대로 받음
                String endParam = request.getParameter("end");   // String 그대로 받음
                
             // ✨ FullCalendar가 보낸 ISO 문자열을 Timestamp 객체로 변환합니다.
                Timestamp start = Timestamp.valueOf(startParam.replace("T", " ").substring(0, 19));
                Timestamp end = Timestamp.valueOf(endParam.replace("T", " ").substring(0, 19));

                // ✨ 수정한 서비스 메소드를 호출합니다.
                List<CalendarEventDTO> events = scheduleService.getMonthlySchedules(acIdx, start, end);
                out.print(gson.toJson(events));

            } else if ("getDailySchedules".equals(action)) {
                String dateStr = request.getParameter("date");
                List<ScheduleVO> dailySchedules = scheduleService.getDailySchedules(acIdx, dateStr);
                // ✨ 포맷이 지정된 Gson 객체가 ScheduleVO의 Timestamp 필드를 올바르게 변환해줍니다.
                out.print(gson.toJson(dailySchedules));
            }else if ("addSchedule".equals(action)) {
                    // 1. 요청 파라미터를 VO 객체에 담습니다.
                    ScheduleVO newSchedule = ScheduleVO.builder()
                            .title(request.getParameter("title"))
                            .description(request.getParameter("description"))
                            .start_time(Timestamp.valueOf(request.getParameter("start_time")))
                            .end_time(Timestamp.valueOf(request.getParameter("end_time")))
                            .color(request.getParameter("color"))
                            .ac_idx(acIdx) // 세션에서 가져온 사용자 ID
                            .build();
                    
                    // 2. 서비스를 호출하여 일정을 추가합니다.
                    boolean result = scheduleService.addSchedule(newSchedule);
                    
                    // 3. 성공 여부를 JSON으로 응답합니다.
                    out.print(gson.toJson(Map.of("success", result)));

            } else if ("getDailySchedules".equals(action)) {
                // 일별 일정 조회 로직
                String dateStr = request.getParameter("date");
                List<ScheduleVO> dailySchedules = scheduleService.getDailySchedules(acIdx, dateStr);
                out.print(gson.toJson(dailySchedules));
            }else if ("updateSchedule".equals(action)) {
                ScheduleVO updatedSchedule = ScheduleVO.builder()
                        .schedule_idx(Integer.parseInt(request.getParameter("schedule_idx")))
                        .title(request.getParameter("title"))
                        .description(request.getParameter("description"))
                        .start_time(Timestamp.valueOf(request.getParameter("start_time")))
                        .end_time(Timestamp.valueOf(request.getParameter("end_time")))
                        .color(request.getParameter("color"))
                        .build();
                
                boolean result = scheduleService.updateSchedule(updatedSchedule);
                out.print(gson.toJson(Map.of("success", result)));

            } 
            else if ("deleteSchedule".equals(action)) {
                int scheduleIdx = Integer.parseInt(request.getParameter("schedule_idx"));
                boolean result = scheduleService.deleteSchedule(scheduleIdx);
                out.print(gson.toJson(Map.of("success", result)));
            }else {
                // 알 수 없는 action에 대한 오류 처리
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "알 수 없는 action입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "요청 처리 중 오류가 발생했습니다.");
        } finally {
            if (out != null) out.flush();
        }

        return null;
    }
}