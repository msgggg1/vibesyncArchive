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
public class PageVO {
	
	private int userpg_idx;
	private String subject;
	private String thumbnail;
	private Timestamp created_at;
	private int ac_idx;
	private int re_userpg_idx;
}
