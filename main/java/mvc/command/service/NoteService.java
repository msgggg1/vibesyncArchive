package mvc.command.service;

import java.sql.Connection;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.time.temporal.TemporalField;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import lombok.Getter;
import lombok.Setter;
import mvc.domain.dto.ChartDataDTO;
import mvc.domain.dto.DailyStatsDTO;
import mvc.domain.dto.DatasetDTO;
import mvc.domain.dto.NoteStatsDTO;
import mvc.domain.dto.NoteSummaryDTO;
import mvc.domain.dto.UserStatsBlockDTO;
import mvc.persistence.dao.LikeDAO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.daoImpl.LikeDAOImpl;
import mvc.persistence.daoImpl.NoteDAOImpl;

public class NoteService {
	

	@Getter @Setter
	private static class DailyStatSummary {
		private long postCount = 0;
		private long viewCount = 0;
		private long likeCount = 0;
	}
	
	 // --- Workspace [내가 작성한 글] 관련 서비스 메소드 ---
    //사용자가 작성한 글 인기순. (위젯 미리보기용)
	public List<NoteSummaryDTO> getMyPostsPreview(int acIdx) throws Exception {
	    Connection conn = null;
	    try {
	        conn = ConnectionProvider.getConnection();
	        NoteDAO noteDAO = new NoteDAOImpl(conn);
	        List<NoteSummaryDTO> posts = noteDAO.findMyPostsByPopularity(acIdx);
	        return posts;
	    } finally {
	        if (conn != null) conn.close();
	    }
	}
	

    
    //사용자가 작성한 글 전체를 인기순 (모달용)
    public List<NoteSummaryDTO> getAllMyPosts(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            return noteDAO.findAllMyPostsByPopularity(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }
    
    // --- [좋아요한 글] 관련 서비스 메소드 ---
    // 좋아요한 글 최신순 7개 (위젯 미리보기용)
    public List<NoteSummaryDTO> getLikedPostsPreview(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            // DAO에 구현할 findLikedPostsByRecent 메소드 호출 (limit: 7)
            return noteDAO.findLikedPostsByRecent(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }

    //좋아요한 글 전체를 최신순
    public List<NoteSummaryDTO> getAllLikedPosts(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            // DAO에 구현할 findAllLikedPostsByRecent 메소드 호출
            return noteDAO.findAllLikedPostsByRecent(acIdx);
        } finally {
            if (conn != null) conn.close();
        }
    }
	
	// 카테고리별 인기/최신글 조회
	public List<NoteSummaryDTO> getPostsByCategory(int categoryIdx, String sortType) {
		List<NoteSummaryDTO> postsByCategory = new ArrayList<NoteSummaryDTO>();
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			
			if (sortType == null) {
				sortType = "";
			}
			
			if (sortType.equals("popular")) {
				postsByCategory = noteDAO.popularNoteByMyCategory(categoryIdx, 5);
				
			} else if (sortType.equals("latest")) {
				postsByCategory = noteDAO.recentNoteByMyCategory(categoryIdx, 5);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return postsByCategory;
	}

	// 내 활동 통계 (구버전) : 일수 설정 불가 (전체 기간), 막대그래프
	public NoteStatsDTO getUserNoteStats(int acIdx) {
		NoteStatsDTO userNoteStats = null;
		
		Connection conn = null;
		
		try {
			conn = ConnectionProvider.getConnection();
			
			// 유저가 작성한 전체 게시글 note_idx
			NoteDAO noteDAO = new NoteDAOImpl(conn);
			List<Integer> noteIdList = noteDAO.getNoteIdxListByUser(acIdx);
			
			// 전체 게시글의 총 좋아요 수
			LikeDAO likeDAO = new LikeDAOImpl(conn);
			int likeCnt = likeDAO.getLikesCountForMultipleNotes(noteIdList);
			
			// 전체 게시글의 조회수
			int viewCnt = noteDAO.getViewCountsForNotesAllByUser(acIdx);
			
			userNoteStats = NoteStatsDTO.builder()
										.totalLikes(likeCnt)
										.totalViews(viewCnt)
										.totalPosts(noteIdList.size())
										.build();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(conn);
		}
		
		return userNoteStats;
	}

	// 내 활동 통계 (구버전) : 일수 7일로 고정
	public UserStatsBlockDTO getUserStatsForChart7Days(int acIdx) {
		UserStatsBlockDTO userStatsBlockDTO = null;
		
        Connection conn = null;
        int days = 7; // 통계 기간 설정

        try {
            conn = ConnectionProvider.getConnection();
            NoteDAO noteDAO = new NoteDAOImpl(conn);
            LikeDAO likeDAO = new LikeDAOImpl(conn);

            // 1. 기준이 될 날짜 라벨 생성 (최근 7일)
            // LinkedHashMap을 사용해 순서를 보장
            Map<String, DailyStatSummary> summaryMap = new LinkedHashMap<String, DailyStatSummary>();
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (int i = 0; i < days; i++) {
                String dateStr = today.minusDays(i).format(formatter);
                summaryMap.put(dateStr, new DailyStatSummary());
            }

            // 2. 각 통계 데이터를 DB에서 가져와 Map에 채우기
            List<DailyStatsDTO> postData = noteDAO.getDailyPostCounts(acIdx, days);
            postData.forEach(stat -> summaryMap.get(stat.getStatDate()).setPostCount(stat.getCount()));

            List<DailyStatsDTO> viewData = noteDAO.getDailyViewCounts(acIdx, days);
            viewData.forEach(stat -> summaryMap.get(stat.getStatDate()).setViewCount(stat.getCount()));

            List<DailyStatsDTO> likeData = likeDAO.getDailyLikeCountsForUserPosts(acIdx, days);
            likeData.forEach(stat -> summaryMap.get(stat.getStatDate()).setLikeCount(stat.getCount()));
            
            // 3. 통합된 Map 데이터를 최종 DTO 형태로 변환
            List<String> labels = new ArrayList<String>();
            List<Long> postCounts = new ArrayList<Long>();
            List<Long> viewCounts = new ArrayList<Long>();
            List<Long> likeCounts = new ArrayList<Long>();

            // 날짜 순서가 최신순으로 되어있으므로, 역순으로 뒤집어 오름차순으로 만듦
            new ArrayList<>(summaryMap.keySet()).stream().sorted().forEach(dateKey -> {
                DailyStatSummary summary = summaryMap.get(dateKey);
                labels.add(dateKey.substring(5));
                postCounts.add(summary.getPostCount());
                viewCounts.add(summary.getViewCount());
                likeCounts.add(summary.getLikeCount());
            });

            // 4. 최종 DTO 조립
            DatasetDTO postDataset = DatasetDTO.builder().label("게시글").data(postCounts).build();
            DatasetDTO viewDataset = DatasetDTO.builder().label("조회수").data(viewCounts).build();
            DatasetDTO likeDataset = DatasetDTO.builder().label("좋아요").data(likeCounts).build();

            ChartDataDTO chartData = ChartDataDTO.builder()
                .labels(labels)
                .datasets(List.of(postDataset, viewDataset, likeDataset))
                .build();
            
            userStatsBlockDTO = UserStatsBlockDTO.builder()
                .title("최근 " + days + "일 활동 통계")
                .chartData(chartData)
                .build();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }

        return userStatsBlockDTO;
		
	}
	
	// 내 활동 통계 (신버전) : 통계 범위 조정 가능
	public UserStatsBlockDTO getUserStatsForChart(int acIdx, String period) {
		if (period == null || period.isEmpty()) {
            period = "daily";
        }
		
		UserStatsBlockDTO userStatsBlockDTO = null;
        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            NoteDAOImpl noteDAO = new NoteDAOImpl(conn);
            LikeDAOImpl likeDAO = new LikeDAOImpl(conn);

            Map<String, DailyStatSummary> summaryMap = new LinkedHashMap<>();
            List<DailyStatsDTO> postData, viewData, likeData;
            String title, labelFormat, xLabelType;

            // 기간(period)에 따라 분기 처리
            switch (period) {
            case "weekly":
                title = "최근 4주 활동 통계 (주별)";
                labelFormat = "yyyy-MM-dd";
                xLabelType = "week";
                int weeks = 4;
                LocalDate mondayOfThisWeek = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                for (int i = 0; i < weeks; i++) {
                    summaryMap.put(mondayOfThisWeek.minusWeeks(i).format(DateTimeFormatter.ofPattern(labelFormat)), new DailyStatSummary());
                }
                postData = noteDAO.getWeeklyPostCounts(acIdx, weeks);
                viewData = noteDAO.getWeeklyViewCounts(acIdx, weeks);
                likeData = likeDAO.getWeeklyLikeCountsForUserPosts(acIdx, weeks);
                break;

            case "monthly":
                title = "최근 1년 활동 통계 (월별)";
                labelFormat = "yyyy-MM";
                xLabelType = "month";
                int months = 12;
                YearMonth currentMonth = YearMonth.now();
                for (int i = 0; i < months; i++) {
                    summaryMap.put(currentMonth.minusMonths(i).format(DateTimeFormatter.ofPattern(labelFormat)), new DailyStatSummary());
                }
                postData = noteDAO.getMonthlyPostCounts(acIdx, months);
                viewData = noteDAO.getMonthlyViewCounts(acIdx, months);
                likeData = likeDAO.getMonthlyLikeCountsForUserPosts(acIdx, months);
                break;

            case "yearly":
                title = "최근 5년 활동 통계 (연도별)";
                xLabelType = "year";
                int years = 5;
                LocalDate currentYear = LocalDate.now();
                for (int i = 0; i < years; i++) {
                    summaryMap.put(String.valueOf(currentYear.minusYears(i).getYear()), new DailyStatSummary());
                }
                postData = noteDAO.getYearlyPostCounts(acIdx, years);
                viewData = noteDAO.getYearlyViewCounts(acIdx, years);
                likeData = likeDAO.getYearlyLikeCountsForUserPosts(acIdx, years);
                break;
                
            case "daily":
            default:
                title = "최근 7일 활동 통계 (일별)";
                labelFormat = "yyyy-MM-dd (E)";
                xLabelType = "day";
                int days = 7;
                LocalDate today = LocalDate.now();
                for (int i = 0; i < days; i++) {
                    summaryMap.put(today.minusDays(i).format(DateTimeFormatter.ofPattern(labelFormat)), new DailyStatSummary());
                }
                postData = noteDAO.getDailyPostCounts(acIdx, days);
                viewData = noteDAO.getDailyViewCounts(acIdx, days);
                likeData = likeDAO.getDailyLikeCountsForUserPosts(acIdx, days);
                break;
            }

            // 가져온 통계 데이터를 Map에 채우기
            postData.forEach(stat -> summaryMap.computeIfPresent(stat.getStatDate(), (k, v) -> { v.setPostCount(stat.getCount()); return v; }));
            viewData.forEach(stat -> summaryMap.computeIfPresent(stat.getStatDate(), (k, v) -> { v.setViewCount(stat.getCount()); return v; }));
            likeData.forEach(stat -> summaryMap.computeIfPresent(stat.getStatDate(), (k, v) -> { v.setLikeCount(stat.getCount()); return v; }));

            // 통합된 Map 데이터를 최종 DTO 형태로 변환
            List<String> labels = new ArrayList<>();
            List<Long> postCounts = new ArrayList<>();
            List<Long> viewCounts = new ArrayList<>();
            List<Long> likeCounts = new ArrayList<>();
            
            // 날짜 순서 오름차순으로 정렬
            new ArrayList<>(summaryMap.keySet()).stream().sorted().forEach(dateKey -> {
                DailyStatSummary summary = summaryMap.get(dateKey);
                
                String label = "";
                switch(xLabelType) {
                case "day":
                	String month = dateKey.substring((dateKey.indexOf("-0") == -1 ? 5 : 6), dateKey.indexOf('-', 6));
                	int monthEnd = dateKey.indexOf('-', 6);
                	int dateHas0 = dateKey.indexOf("-0", monthEnd);
                	String date = dateKey.substring((dateHas0 == -1 ? monthEnd + 1 : dateHas0 + 2), dateKey.indexOf('(')-1);
                	String day = dateKey.substring(dateKey.indexOf("("));
                	label =  String.format("%s월 %s일 %s", month, date, day);
                	break;
                
                case "week": 
                    label = getWeekOfMonthLabel(dateKey);
                    break;
                    
                case "month": label = dateKey.substring(2, 4) + "년 " + (dateKey.indexOf("-0") == -1 ? dateKey.substring(5) : dateKey.substring(6)) + "월" ; break;
                case "year": label = dateKey + "년"; break;
            }
                labels.add(label);
                
                postCounts.add(summary.getPostCount());
                viewCounts.add(summary.getViewCount());
                likeCounts.add(summary.getLikeCount());
            });

            // 최종 DTO 조립
            DatasetDTO postDataset = DatasetDTO.builder().label("게시글").data(postCounts).build();
            DatasetDTO viewDataset = DatasetDTO.builder().label("조회수").data(viewCounts).build();
            DatasetDTO likeDataset = DatasetDTO.builder().label("좋아요").data(likeCounts).build();

            ChartDataDTO chartData = ChartDataDTO.builder()
                .labels(labels)
                .datasets(List.of(postDataset, viewDataset, likeDataset))
                .build();
            
            userStatsBlockDTO = UserStatsBlockDTO.builder()
                .title(title)
                .chartData(chartData)
                .period(period)
                .build();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }

        return userStatsBlockDTO;
    }
	
	// 몇째주인지 반환해주는 메서드
	private String getWeekOfMonthLabel(String yyyyMmDd) {
	    if (yyyyMmDd == null || yyyyMmDd.length() < 10) return "";

	    LocalDate date = LocalDate.parse(yyyyMmDd);
	    int month = date.getMonthValue();
	    TemporalField wof = WeekFields.of(Locale.KOREA).weekOfMonth();
	    int weekOfMonth = date.get(wof);

	    String weekOrdinal;
	    switch (weekOfMonth) {
	        case 1: weekOrdinal = "첫째주"; break;
	        case 2: weekOrdinal = "둘째주"; break;
	        case 3: weekOrdinal = "셋째주"; break;
	        case 4: weekOrdinal = "넷째주"; break;
	        case 5: weekOrdinal = "다섯째주"; break;
	        default: weekOrdinal = String.valueOf(weekOfMonth) + "주차"; break;
	    }
	    
	    return String.format("%d월 %s", month, weekOrdinal);
	}
}
