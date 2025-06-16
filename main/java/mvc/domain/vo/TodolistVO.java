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
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TodolistVO {
	
	private int todo_idx;
	private Timestamp created_at;
    private String text;
    private String todo_group;
    private int color;
    private int ac_idx;
    
}