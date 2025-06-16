package mvc.persistence.daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.util.JdbcUtil;

import mvc.domain.vo.BlockVO;
import mvc.persistence.dao.BlockDAO;

public class BlockDAOImpl implements BlockDAO {

	Connection conn = null;
	
	public BlockDAOImpl(Connection conn) {
		this.conn = conn;
	}

	// 특정 사용자의 모든 블록 설정을 순서대로 가져오기
	@Override
	public List<BlockVO> findBlocksByAcIdx(int acIdx) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<BlockVO> blocks = new ArrayList<BlockVO>();
        String sql = " SELECT block_id, block_type, block_order, config "
        		   + " FROM workspace_blocks "
        		   + " WHERE ac_idx = ? "
        		   + " ORDER BY block_order ASC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, acIdx);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                BlockVO block = new BlockVO();
                block.setBlock_id(rs.getInt("block_id"));
                block.setAc_idx(acIdx);
                block.setBlock_type(rs.getString("block_type"));
                block.setBlock_order(rs.getInt("block_order"));
                block.setConfig(rs.getString("config"));
                blocks.add(block);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return blocks;
	}
	
	// 특정 ID의 블록 정보만 가져오기 : 부분 새로고침용
	@Override
	public BlockVO findBlockById(int blockId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BlockVO block = null;
        String sql = " SELECT ac_idx, block_type, block_order, config "
        		   + " FROM workspace_blocks "
        		   + " WHERE block_id = ? ";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, blockId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                block = new BlockVO();
                block.setBlock_id(blockId);
                block.setAc_idx(rs.getInt("ac_idx"));
                block.setBlock_type(rs.getString("block_type"));
                block.setBlock_order(rs.getInt("block_order"));
                block.setConfig(rs.getString("config"));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return block;
	}

	// 새로운 블록 추가
	@Override
	public int insertBlock(BlockVO block) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int insertedBlockId = 0;
        int block_order = 1;
        
        String sequenceSql = " SELECT workspace_blocks_seq.NEXTVAL FROM DUAL ";
        String blockOrderSql = " SELECT MAX(block_order) FROM workspace_blocks WHERE ac_idx = ? ";
        String insertSql = " INSERT INTO workspace_blocks (block_id, ac_idx, block_type, block_order, config) "
        				 + " VALUES (?, ?, ?, ?, ?) ";

        // 시퀀스 값 가져오기
        pstmt = conn.prepareStatement(sequenceSql);
        rs = pstmt.executeQuery();
        if (rs.next()) {
        	insertedBlockId = rs.getInt(1);
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
        
        // block_order 값 가져오기 (이후 + 1)
        pstmt = conn.prepareStatement(blockOrderSql);
        pstmt.setInt(1, block.getAc_idx());
        rs = pstmt.executeQuery();
        if (rs.next()) {
        	block_order = rs.getInt(1) + 1;
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);

        // 가져온 시퀀스 값과 block_order 값을 사용하여 INSERT
        if (insertedBlockId > 0) {
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, insertedBlockId); // 조회해온 시퀀스 값을 PK로 사용
            pstmt.setInt(2, block.getAc_idx());
            pstmt.setString(3, block.getBlock_type());
            pstmt.setInt(4, block_order);
            pstmt.setString(5, block.getConfig());
            
            pstmt.executeUpdate();
            
            JdbcUtil.close(pstmt);
        }
        
        return insertedBlockId;
	}

	// 블록 삭제
	@Override
	public boolean deleteBlock(int acIdx, int block_id) throws SQLException {
        boolean isDeleted = false;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String selectOrderSql = " SELECT block_order FROM workspace_blocks WHERE block_id = ? ";
		int block_order = 0;
		
		String selectMaxSql = " SELECT MAX(block_order) FROM workspace_blocks WHERE ac_idx = ? ";
		int max_block_order = 0;
		
        String deleteSql = "DELETE FROM workspace_blocks "
        		   + " WHERE block_id = ? AND ac_idx = ?";
        
        String reorganizeSql = " UPDATE workspace_blocks "
        					 + " SET block_order = block_order - 1 "
        					 + " WHERE ac_idx = ? AND block_order > ? ";
        int rowsAffected = 0;
        
    	pstmt = conn.prepareStatement(selectOrderSql);
    	pstmt.setInt(1, block_id);
    	rs = pstmt.executeQuery();
        if (rs.next()) {
        	block_order = rs.getInt(1);
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
        
    	pstmt = conn.prepareStatement(selectMaxSql);
    	pstmt.setInt(1, acIdx);
    	rs = pstmt.executeQuery();
        if (rs.next()) {
        	max_block_order = rs.getInt(1);
        }
        
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
    	
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, block_id);
        pstmt.setInt(2, acIdx);
        rowsAffected = pstmt.executeUpdate();
        isDeleted = rowsAffected == 1;
        
        JdbcUtil.close(pstmt);
        
        if (isDeleted && (block_order < max_block_order)) {
        	pstmt = conn.prepareStatement(reorganizeSql);
            pstmt.setInt(1, acIdx);
            pstmt.setInt(2, block_order);
            rowsAffected = pstmt.executeUpdate();
            isDeleted = isDeleted && (rowsAffected > 0);
            
            JdbcUtil.close(pstmt);
		}
        
        return isDeleted;
	}

	// 블록 순서 변경
	@Override
	public boolean updateBlockOrder(int acIdx, List<Map<String, Object>> orders) {
		boolean isUpdated = false;
		
		PreparedStatement pstmt = null;
        String sql = "UPDATE workspace_blocks SET block_order = ? WHERE block_id = ? AND ac_idx = ?";
        int[] result;

        try {
            pstmt = conn.prepareStatement(sql);

            for (Map<String, Object> order : orders) {
                // GSON이 숫자를 Double로 읽을 수 있으므로 Number로 받고 intValue() 사용
                int blockOrder = ((Number) order.get("block_order")).intValue();
                int blockId = ((Number) order.get("block_id")).intValue();

                pstmt.setInt(1, blockOrder);
                pstmt.setInt(2, blockId);
                pstmt.setInt(3, acIdx);
                
                pstmt.addBatch();
            }

            result = pstmt.executeBatch();
            JdbcUtil.close(pstmt);

            // 모든 배치 작업이 성공했는지 간단히 확인
            for (int i : result) {
                if (i == PreparedStatement.EXECUTE_FAILED) {
                    throw new SQLException("배치 업데이트 중 일부 실패");
                }
            }
            isUpdated = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return isUpdated;
    }
	
}
