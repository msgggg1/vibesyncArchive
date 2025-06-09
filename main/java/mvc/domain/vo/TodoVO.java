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
public class TodoVO {
    private int todo_idx;
    private Timestamp created_at;
    private String text;
    private String todo_group;
    private String color;
    private int ac_idx;
    private int status;
}