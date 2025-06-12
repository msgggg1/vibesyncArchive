package mvc.domain.vo;

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
public class BlockVO {
	
    private int block_id;
    private int ac_idx;
    private String block_type;
    private int block_order;
    private String config; // JSON 문자열 그대로 저장
    
}