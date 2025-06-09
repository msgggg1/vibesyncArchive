package mvc.domain.vo;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class ScheduleVO {
    private int schedule_idx;
    private String title;
    private String description;
    private Timestamp start_time;
    private Timestamp end_time;
    private String color;
    private int ac_idx;
}