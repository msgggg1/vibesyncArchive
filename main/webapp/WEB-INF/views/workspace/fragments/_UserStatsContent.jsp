<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="chart-toggles" data-chart-id="userStatsChart_${block.block_id}">
    <c:forEach var="dataset" items="${block.chartData.datasets}" varStatus="status">
        <label>
            <input type="checkbox" class="dataset-toggle-cb" data-dataset-index="${status.index}" <c:if test="${dataset.label != '게시글'}">checked</c:if>>
            ${dataset.label}
        </label>
    </c:forEach>
</div>
<div style="position: relative; height: 200px;">
    <canvas id="userStatsChart_${block.block_id}"></canvas>
</div>

<c:if test="${not empty block.chartDataJson}">
    <script>
        (function() {
            const chartData = JSON.parse('<c:out value="${block.chartDataJson}" escapeXml="false"/>');
            
            createOrUpdateChart(${block.block_id}, chartData);
        })();
    </script>
</c:if>