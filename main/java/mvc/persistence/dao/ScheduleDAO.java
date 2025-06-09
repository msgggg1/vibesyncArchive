package mvc.persistence.dao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import mvc.domain.dto.CalendarEventDTO;
import mvc.domain.vo.ScheduleVO;

public interface ScheduleDAO {

    /*
     * 특정 연도와 월에 해당하는 모든 일정을 조회하는 메소드
     * @param year 조회할 연도
     * @param month 조회할 월
     * @return 해당 월의 일정 목록 (List<ScheduleVO>)
     * @throws SQLException
     */
	List<ScheduleVO> findSchedulesByRange(int acIdx, Timestamp  start, Timestamp  end) throws SQLException;
    
 // ✨ 일별 조회 
    List<ScheduleVO> findSchedulesByDate(int acIdx, String dateStr) throws SQLException;
    
    int addSchedule(ScheduleVO schedule) throws SQLException;
    
    int updateSchedule(ScheduleVO schedule) throws SQLException;
    
    int deleteSchedule(int scheduleIdx) throws SQLException;

    // 앞으로 일정 CRUD(생성, 수정, 삭제, 상세조회)에 필요한 메소드들을 여기에 추가하게 됩니다.
    // public void insert(ScheduleVO schedule);
    // public ScheduleVO findById(int scheduleId);
    // public void update(ScheduleVO schedule);
    // public void delete(int scheduleId);
}