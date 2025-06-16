<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="stats-controls">
	<div class="chart-toggles" data-chart-id="userStatsChart_${block.block_id}">
	    <c:forEach var="dataset" items="${block.chartData.datasets}" varStatus="status">
	        <label>
	            <input type="checkbox" class="dataset-toggle-cb" data-dataset-index="${status.index}" checked>
	            ${dataset.label}
	        </label>
	    </c:forEach>
	</div>
	<div class="period-selector">
		<!-- 기간 선택 버튼 -->
		<button class="period-btn ${block.period == 'daily' || empty block.period ? 'active' : ''}" data-period="daily" data-block-id="${block.block_id}">일별</button>
	    <button class="period-btn ${block.period == 'weekly' ? 'active' : ''}" data-period="weekly" data-block-id="${block.block_id}">주별</button>
	    <button class="period-btn ${block.period == 'monthly' ? 'active' : ''}" data-period="monthly" data-block-id="${block.block_id}">월별</button>
	    <button class="period-btn ${block.period == 'yearly' ? 'active' : ''}" data-period="yearly" data-block-id="${block.block_id}">연도별</button>
	    <%-- <button class="period-btn ${block.period == 'all' ? 'active' : ''}" data-period="all" data-block-id="${block.block_id}">전체</button> --%>
	</div>
</div>

<div class="chart-container" style="position: relative; height: 250px;">
    <canvas id="userStatsChart_${block.block_id}"></canvas>
</div>