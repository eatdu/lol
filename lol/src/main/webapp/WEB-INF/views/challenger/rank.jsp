<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
function challengers(page){
	$.ajax({
		url: '/lol/challenger/rank',
		type: 'get',
		dataType : 'JSON',
		data : {
			page: page
		},
		success: function(res){
			$("#content").html(res);
		}
	});
}
</script>
<style>
	.icon {width:32px; height:32px; border-radius: 50%;}
	#winRateColor {width:160px; height:20px; background-color:#E84057;}
	#winRateBox div{float:left;}
	#win {height:20px; width:; background-color:#5383E8;}	
</style>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="wrap">
		<div id="challengerList">
			<table>
				<tr>
					<td>순위</td>
					<td>소환사아이콘</td>
					<td>소환사이름</td>
					<td>티어</td>
					<td>점수</td>
					<td>레벨</td>
					<td>승률</td>
				</tr>
				<c:forEach var="rank" items="${challenger}">
					<tr id="${rank.no}">
						<td id="ranking">${rank.ranking}</td>
						<td id="rankerIcon"><img src="${rank.profileIcon}" class="icon"/></td>
						<td id="rankerName"><a href="/lol/challenger/summoners?summonerName=${rank.summonerName}&rank=${rank.ranking}">${rank.summonerName}</a></td>
						<td id="tier">${rank.tier}</td>
						<td id="LP"><fmt:formatNumber value="${rank.leaguePoints}" pattern="#,###"></fmt:formatNumber>LP</td>
						<td id="tier">${rank.summonerLevel}</td>
						<td id="tier">
							<div id="winRateBox">
								<fmt:parseNumber var="winRate" integerOnly="true" value="${rank.wins / (rank.wins+rank.losses) * 100}"/>
								<c:set var="winBox" value="${winRate}"/>
								<div id="winRateColor">
									<div id="win" style="width:${winRate}%;background-color:#5383E8;">${rank.wins}W</div>
									<div id="lose">${rank.losses}L</div>
								</div>
								<div id="winRate">${winRate}%</div>
							</div>
						</td>
<!-- 					</tr> -->
				</c:forEach>
			</table>
		</div>
		<!-- 페이징 처리 -->
		<div id="content">
			<div class="pagenate clear">
				<ul class="paging">
					<c:if test="${challengerVO.prev == true }">
						<li><a href="javascript:challengers(${challengerVO.startPage-1})">prev</a>
					</c:if>
					<c:forEach var="num" begin="${challengerVO.startPage}" end="${challengerVO.endPage}">
						<li><a href="/lol/challenger/rank?page=${num}">
						<c:if test="javascript:challengers(${empty challengerVO.page})">class='current'</c:if>
						<c:if test="javascript:challengers(${challengerVO.page == num})">class='current'</c:if>${num}</a></li>
					</c:forEach>
					<c:if test="${challengerVO.next == true}">
						<li><a href="javascript:challengers(${challengerVO.endPage+1})">next</a>
					</c:if>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>








