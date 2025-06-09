package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import mvc.domain.dto.CalendarEventDTO;
import mvc.domain.vo.ScheduleVO;
import mvc.persistence.dao.ScheduleDAO;

public class ScheduleDAOImpl implements ScheduleDAO {

    private final Connection conn;

    public ScheduleDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<ScheduleVO> findSchedulesByRange(int acIdx, Timestamp start, Timestamp end) throws SQLException {
        List<ScheduleVO> schedules = new ArrayList<>();
        // FullCalendar는 보이는 영역보다 조금 더 넓게 요청하므로, start_time이 end보다 작고, end_time이 start보다 큰 모든 일정을 가져옵니다.
        String sql = "SELECT schedule_idx, title, description, start_time, end_time, color, ac_idx "
                   + "FROM schedule WHERE ac_idx = ? AND start_time < ? AND end_time > ? ORDER BY start_time ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, acIdx);
            pstmt.setTimestamp(2, end);   // start_time < end
            pstmt.setTimestamp(3, start); // end_time > start

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    // DB 데이터를 VO 객체에만 매핑합니다. (DTO 생성 X)
                    ScheduleVO schedule = ScheduleVO.builder()
                            .schedule_idx(rs.getInt("schedule_idx"))
                            .title(rs.getString("title"))
                            .description(rs.getString("description"))
                            .start_time(rs.getTimestamp("start_time"))
                            .end_time(rs.getTimestamp("end_time"))
                            .color(rs.getString("color"))
                            .ac_idx(rs.getInt("ac_idx"))
                            .build();
                    schedules.add(schedule);
                }
            }
        }
        return schedules;
    }
    
    @Override
    public List<ScheduleVO> findSchedulesByDate(int acIdx, String dateStr) throws SQLException {
        List<ScheduleVO> schedules = new ArrayList<>();
        // TRUNC(start_time)을 사용하여 start_time의 시간 부분을 제거하고 날짜만으로 비교
        String sql = "SELECT schedule_idx, title, description, start_time, end_time, color, ac_idx "
                   + "FROM schedule WHERE ac_idx = ? AND TRUNC(start_time) = TO_DATE(?, 'YYYY-MM-DD') "
                   + "ORDER BY start_time ASC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            pstmt.setString(2, dateStr);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ScheduleVO schedule = ScheduleVO.builder()
                        .schedule_idx(rs.getInt("schedule_idx"))
                        .title(rs.getString("title"))
                        .description(rs.getString("description"))
                        .start_time(rs.getTimestamp("start_time"))
                        .end_time(rs.getTimestamp("end_time"))
                        .color(rs.getString("color"))
                        .ac_idx(rs.getInt("ac_idx"))
                        .build();
                schedules.add(schedule);
            }
        } finally {
        	 if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
             if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return schedules;
    }
    
    @Override
    public int addSchedule(ScheduleVO schedule) throws SQLException {
        String sql = "INSERT INTO schedule (schedule_idx, title, description, start_time, end_time, color, ac_idx) "
                   + "VALUES (schedule_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, schedule.getTitle());
            pstmt.setString(2, schedule.getDescription());
            pstmt.setTimestamp(3, schedule.getStart_time());
            pstmt.setTimestamp(4, schedule.getEnd_time());
            pstmt.setString(5, schedule.getColor());
            pstmt.setInt(6, schedule.getAc_idx());
            
            return pstmt.executeUpdate();
        }
    }
	
    @Override
    public int updateSchedule(ScheduleVO schedule) throws SQLException {
        String sql = "UPDATE schedule SET title = ?, description = ?, start_time = ?, end_time = ?, color = ? "
                   + "WHERE schedule_idx = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, schedule.getTitle());
            pstmt.setString(2, schedule.getDescription());
            pstmt.setTimestamp(3, schedule.getStart_time());
            pstmt.setTimestamp(4, schedule.getEnd_time());
            pstmt.setString(5, schedule.getColor());
            pstmt.setInt(6, schedule.getSchedule_idx());
            
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int deleteSchedule(int scheduleIdx) throws SQLException {
        String sql = "DELETE FROM schedule WHERE schedule_idx = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, scheduleIdx);
            return pstmt.executeUpdate();
        }
    }
}