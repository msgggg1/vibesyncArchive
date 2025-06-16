package mvc.persistence.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import mvc.domain.vo.BlockVO;

public interface BlockDAO {

	// 특정 사용자의 모든 블록 설정을 순서대로 가져오기
	public List<BlockVO> findBlocksByAcIdx(int acIdx) throws SQLException;
	
	// 특정 ID의 블록 정보만 가져오기 : 부분 새로고침용
	public BlockVO findBlockById(int blockId) throws SQLException;
	
	// 새로운 블록 추가
	public int insertBlock(BlockVO block) throws SQLException;
	
	// 블록 삭제
	public boolean deleteBlock(int ac_idx,int blockId) throws SQLException;

	// 블록 순서 변경
	public boolean updateBlockOrder(int acIdx, List<Map<String, Object>> orders);
	
}
