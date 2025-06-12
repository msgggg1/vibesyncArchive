// File: mvc/domain/dto/PageResultDTO.java
package mvc.domain.dto;

import java.util.List;
import lombok.Getter;
import mvc.domain.vo.PageVO;

@Getter
public class PageResultDTO {
	private final List<PageVO> list;
    private final int totalCount;
    private final List<PageVO> fulllist;

    public PageResultDTO(List<PageVO> list, int totalCount, List<PageVO> fulllist) {
        this.list = list;
        this.totalCount = totalCount;
        this.fulllist = fulllist;
    }
}
