package mvc.domain.dto;

import java.util.List;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class NotePageResultDTO {

    private List<NoteListDTO> list;
    private int totalCount;
    private int currentPage;
    private int pageSize;
    private int totalPages;
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;

    public NotePageResultDTO(int totalCount, int currentPage, int pageSize, List<NoteListDTO> list) {
        this.totalCount = totalCount;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.list = list;

        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
        int pageBlock = 10; // 페이지 블록에 표시할 페이지 수
        this.startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
        this.endPage = Math.min(startPage + pageBlock - 1, totalPages);
        
        this.prev = this.startPage > 1;
        this.next = this.endPage < totalPages;
    }
}