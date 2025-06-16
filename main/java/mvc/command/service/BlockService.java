package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.util.BlockAction;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.dto.BlockDTO;
import mvc.domain.dto.CategoryPostsBlockDTO;
import mvc.domain.dto.CategoryPostsConfigDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.WatchPartyBlockDTO;
import mvc.domain.dto.WatchPartyDTO;
import mvc.domain.vo.BlockVO;
import mvc.persistence.dao.BlockDAO;
import mvc.persistence.daoImpl.BlockDAOImpl;

public class BlockService {
	
	// BlockService 안에서만 사용할 private 메서드
	private BlockDTO convertVoToDto (BlockVO blockVO, int acIdx, String period) {
		
		BlockAction blockType = BlockAction.valueOf(blockVO.getBlock_type());
		BlockDTO blockDTO = null;
		
		switch (blockType) {
			case CategoryPosts:
				// config JSON 문자열을 파싱하여 category_idx, sort_type 얻어오기
				String configJson = blockVO.getConfig();
				int categoryIdx = 0;
				String categoryName = "", sortType = "";
				 
				if (configJson == null || configJson.trim().isEmpty()) {
				    // ... 설정값 없는 경우 처리
				}
				 
				Gson gson = new Gson();
				try {
					// fromJson 메서드로 JSON 문자열을 DTO 객체로 한번에 변환
					CategoryPostsConfigDTO config = gson.fromJson(configJson, CategoryPostsConfigDTO.class);
					 
					categoryIdx = config.getCategory_idx();
					categoryName = config.getCategory_name();
				    sortType = config.getSort_type();
					 
				} catch (JsonSyntaxException e) {
					System.err.println("JSON 파싱 중 오류 발생: " + e.getMessage());
				}
				
				// NoteService를 호출하여 해당 조건에 맞는 게시글 목록 가져오기
				NoteService noteServiceForCategoryPosts = new NoteService();
				List<NoteSummaryDTO> posts = noteServiceForCategoryPosts.getPostsByCategory(categoryIdx, sortType);
				
				blockDTO = CategoryPostsBlockDTO.builder()
												.block_id(blockVO.getBlock_id())
												.block_type(blockVO.getBlock_type())
												.block_order(blockVO.getBlock_order())
												.categoryIdx(categoryIdx)
												.categoryName(categoryName)
												.sortType(sortType)
												.posts(posts)
												.build();
				
				break;
				
			case WatchParties:
				// WatchPartyService를 호출하여 진행 중인 워치파티 목록을 가져오기
				WatchPartyService watchPartyService = new WatchPartyService();
				List<WatchPartyDTO> watchParties = watchPartyService.getFollowingWatchPartyList(acIdx);
				
				blockDTO = WatchPartyBlockDTO.builder()
											 .block_id(blockVO.getBlock_id())
											 .block_type(blockVO.getBlock_type())
											 .block_order(blockVO.getBlock_order())
											 .watchParties(watchParties)
											 .build();
				
				break;
				
			case UserStats:
				// NoteService를 호출하여 사용자 통계 가져오기
				NoteService noteServiceForUserStats = new NoteService();
				
				// 가져온 데이터로 UserStatsBlockDTO를 생성하여 리스트에 추가
				blockDTO = noteServiceForUserStats.getUserStatsForChart(acIdx, period);
				blockDTO.setBlock_id(blockVO.getBlock_id());
				blockDTO.setBlock_type(blockVO.getBlock_type());
				blockDTO.setBlock_order(blockVO.getBlock_order());
				
				break;

			default:
				break;
		}
		
		return blockDTO;
		
	}
	
	// 유저별로 개인화된 추가블록 불러오기
	public List<BlockDTO> getBlocksForUser(int acIdx, String period) {
		List<BlockDTO> blockDTOList = new ArrayList<BlockDTO>();
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			BlockDAO blockDAO = new BlockDAOImpl(conn);
			List<BlockVO> blockVOList = blockDAO.findBlocksByAcIdx(acIdx);
			
			for (int i = 0; i < blockVOList.size(); i++) {
				BlockVO blockVO = blockVOList.get(i);
				
				BlockDTO blockDTO = this.convertVoToDto(blockVO, acIdx, period);
			
				blockDTOList.add(blockDTO);
			}
			
		} catch (NamingException e) {
			e.printStackTrace();
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return blockDTOList;
		
	};
	
	// 특정 블록 ID에 대한 DTO만 생성해서 반환하는 메서드 (특정 블록 새로고침용)
	public BlockDTO getBlockContentAsDto(int acIdx, int blockId, String period) {
		BlockDTO blockDTO = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			BlockDAO blockDAO = new BlockDAOImpl(conn);
			BlockVO blockVO = blockDAO.findBlockById(blockId);
		    if (blockVO == null) {
		    	JdbcUtil.close(conn);
		    	return null;
		    }
		    
		    blockDTO = this.convertVoToDto(blockVO, acIdx, period);
			
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return blockDTO;
		
	}
	
	// 블록 추가
	public int addBlock(int acIdx, String blockType, String configJson) {
		int addedBlockId = 0;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			conn.setAutoCommit(false);
			
			BlockVO blockVO = BlockVO.builder()
									 .ac_idx(acIdx)
									 .block_type(blockType)
									 .config(configJson)
									 .build();
			
			BlockDAO blockDAO = new BlockDAOImpl(conn);
			addedBlockId = blockDAO.insertBlock(blockVO);
			
			if (addedBlockId != 0) {
				conn.commit();
			} else {
				JdbcUtil.rollback(conn);
			}
			
			if (addedBlockId != 0) {
				conn.commit();
			} else {
				JdbcUtil.rollback(conn);
			}
			
		} catch (NamingException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			JdbcUtil.rollback(conn);
		} catch (SQLException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			JdbcUtil.rollback(conn);
		} finally {
			JdbcUtil.close(conn);
		}
		
		return addedBlockId;
	}

	// 블록 삭제
	public boolean removeBlock(int ac_idx, int blockId) {
		boolean isRemoved = false;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			conn.setAutoCommit(false);
			
			BlockDAO blockDAO = new BlockDAOImpl(conn);
			isRemoved = blockDAO.deleteBlock(ac_idx, blockId);
			
			if (isRemoved) {
				conn.commit();
			} else {
				JdbcUtil.rollback(conn);
			}
			
			if (isRemoved) {
				conn.commit();
			} else {
				JdbcUtil.rollback(conn);
			}
			
		} catch (NamingException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			JdbcUtil.rollback(conn);
		} catch (SQLException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
			JdbcUtil.rollback(conn);
		} finally {
			JdbcUtil.close(conn);
		}
		
		return isRemoved;
	}
	
	// 블록 순서 변경
    public boolean changeBlockOrder(int acIdx, List<Map<String, Object>> orders) {
    	boolean isReordered = false;
    	Connection conn = null;
    	
    	try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			
			BlockDAO blockDAO = new BlockDAOImpl(conn);
			isReordered = blockDAO.updateBlockOrder(acIdx, orders);
			
			if (isReordered) {
				conn.commit();
			} else {
				JdbcUtil.rollback(conn);
			}
			
		} catch (NamingException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
		} catch (SQLException e) {
			e.printStackTrace();
			JdbcUtil.rollback(conn);
		} finally {
			JdbcUtil.close(conn);
		}
    	
    	return isReordered;
    }
}
