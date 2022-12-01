<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
<script>
	$(function(){
		$(".analysis-btn-3").click(function(){
			var idx = $(this).index(".analysis-btn-3");
			var param = { 
					"gameId": $(".gameId").eq(idx).val(), 
					"puuid": $(".profile-puuid").val(),
					"championId" : $(".championId").eq(idx).val()
			};
			$.ajax({
				url: "itemBuild",
				type: "POST",
				contentType:'application/json',
				data: JSON.stringify(param),
				success: function(res){
					var html = '';
					$.each(res, function(i,v){
						html += "<div class='time-item-icon'><img src='"+v['itemIcon']+"'></div>";
						$(".item-build-list").eq(idx).html(html);
						if (i > 0 && res[i]['time'] != res[i-1]['time']) {
							html += "<div style='float:left;'> > </div>";
						}
						if (res[i-1]){
							$(".item-build-list").css("float","none");
						}
					});
				}
			});
			$.ajax({
				url: "skillBuild",
				type: "POST",
				contentType:'application/json',
				data: JSON.stringify(param),
				success: function(res){
					var html = '';
					$.each(res, function(i,v){
						html += "<div class='time-skill-icon'><img src='"+v['skillIcon']+"'></div>";
						$(".skill-build-list").eq(idx).html(html);
					});
				}
			});
		});
	});
	
	$(function(){
		$(".analysis-btn-4").click(function(){
			var idx = $(this).index(".analysis-btn-4");
			var param = { 
					"gameId": $(".gameId").eq(idx).val(), 
					"summonerName": '${data.vo.summonerName}'
			};
			$.ajax({
				url: "etc",
				type: "POST",
				contentType:'application/json',
				data: JSON.stringify(param),
				success: function(res){
					var data = new Array();
					var nameArr = new Array();
					$.each(res,function(participantId_idx, participantId_val){
						var obj = {}
						nameArr.push(participantId_val['summonerName'])
						$.each(participantId_val, function(min_idx, min_val){
							if (min_idx == 'minList') {
								var arr = new Array();
								obj['type'] = "line";
								obj['markerSize'] = 0;
								for (var i in min_val){
									arr.push({ x: Number(i), y: min_val[i]['totalGold']})
								}
								obj['dataPoints'] = arr;
							}
						});
						data.push(obj);
					});
					options={
						legend: {
							cursor: "pointer",
							verticalAlign: "top",
							horizontalAlign: "center",
							dockInsidePlotArea: true,
							itemclick: "toogleDataSeries"
						},
						axisX: {
							suffix :"분"
						},
						axisY: {
							suffix :"K"
						},
						data: data
					}
					$(".etc-gold-chart-"+idx+"").CanvasJSChart(options);
					var html = '';
					var htmlu = '';
					$.each(res, function(i,v){
						html += "<div class='champion-chart-img'><img src='"+v['championIcon']+"'></div>";
						htmlu += "<div class='userName'>"+v['summonerName']+"</div>";
						$(".etc-champion-img").eq(idx).html(html);
						$(".userName-div").eq(idx).html(htmlu);
					})
				}
			});
		});
	});
	
	$(function() { // 전체 챔피언 처치에 대한 원그래피
		CanvasJS.addColorSet("color",["#5383e8","#e84057"])
		var totalKill_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalKill_arr.push({totalTeamKills:${item.totalTeamKills}
					,totalOtherKills:${item.totalOtherKills}});
		</c:forEach>
	    for (var i=0; i<totalKill_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalKill_arr[i].totalOtherKills, x: "상대" },
						{ y: totalKill_arr[i].totalTeamKills, x: "팀"}
					]
			  	}]
		   	};
	    	$("#chartContainer_champ_kill-"+i+"").CanvasJSChart(options);
    	 }
	 });
	 
	$(function() { // 전체 획득 골드에 대한 원그래프
		var totalGold_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalGold_arr.push({stotalGold:${item.stotalGold}
					,ototalGold:${item.ototalGold}});
		</c:forEach>
	    for (var i=0; i<totalGold_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalGold_arr[i].ototalGold, x: "상대"},
						{ y: totalGold_arr[i].stotalGold, x: "팀" }
					]
			  	}]
		   	};
	    	$("#chartContainer_gain_gold-"+i+"").CanvasJSChart(options);
    	 }
	 })
	 
	$(function() { // 전체 적에게 가한 데미지에 대한 원그래프
		var totalDealt_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalDealt_arr.push({totalDamageDealt:${item.totalDamageDealt}
					,totalOtherDealt:${item.totalOtherDealt}});
		</c:forEach>
	    for (var i=0; i<totalDealt_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalDealt_arr[i].totalOtherDealt, x: "상대"},
						{ y: totalDealt_arr[i].totalDamageDealt, x: "팀" },
					]
			  	}]
		   	};
	    	$("#chartContainer_dealt_damage-"+i+"").CanvasJSChart(options);
    	 }
	 });
	
	$(function() { // 전체 설치한 와드에 대한 원그래프
		var totalWard_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalWard_arr.push({stotalWoard:${item.stotalWoard}
					,ototalWoard:${item.ototalWoard}});
		</c:forEach>
	    for (var i=0; i<totalWard_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalWard_arr[i].ototalWoard, x: "상대"},
						{ y: totalWard_arr[i].stotalWoard, x: "팀" },
					]
			  	}]
		   	};
	    	$("#chartContainer_placed_ward-"+i+"").CanvasJSChart(options);
    	 }
	 });
	 
	$(function() { // 전체 받은 피해량에 대한 원그래프
		var totalTaken_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalTaken_arr.push({stotalTaken:${item.stotalTaken}
					,ototalTaken:${item.ototalTaken}});
		</c:forEach>
	    for (var i=0; i<totalTaken_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalTaken_arr[i].ototalTaken, x: "상대"},
						{ y: totalTaken_arr[i].stotalTaken, x: "팀" },
					]
			  	}]
		   	};
	    	$("#chartContainer_total_taken-"+i+"").CanvasJSChart(options);
    	 }
	 });
	 
	$(function() { // 전체 처치한 CS 대한 원그래프
		var totalCS_arr = new Array();
		<c:forEach items="${data.inGameList}" var="item">
			totalCS_arr.push({stotalCs:${item.stotalCs}
					,ototalCs:${item.ototalCs}});
		</c:forEach>
	    for (var i=0; i<totalCS_arr.length; i++) {
	    	options={
			   animationEnabled: false,
			   colorSet: "color",
			   width:125,
			   height:100,	
			   interactivityEnabled:false,
			   creditText:'',
			   creditHref:'',
			   data: [{
				   type: "doughnut",
				   	dataPoints: [
						{ y: totalCS_arr[i].ototalCs, x: "상대"},
						{ y: totalCS_arr[i].stotalCs, x: "팀" },
					]
			  	}]
		   	};
	    	$("#chartContainer_killed_CS-"+i+"").CanvasJSChart(options);
    	 }
	 });
	 
	
	
	$(function() {
		var height = $(document).height();
		$(".info-wrap").height(height);
		$(".detailBtn").click(function() {
			var idx = $(this).index(".detailBtn");
			var btnHeight = $(document).height();
			
			if ($(".inGameList-analysis-box").eq(idx).css('display') == 'none') {
				$(".inGameList-analysis-box").eq(idx).show();
				$(".inGameListOpen").eq(idx).show();
				$(".analysis-btn-box").eq(idx).show();
				$(".detailBtn").eq(idx).css("transform", "rotate(180deg)");
			} else {
				$(".inGameList-analysis-box").eq(idx).hide();
				$(".detailBtn").eq(idx).css("transform", "rotate(0deg)");
			}
		})
	});
	
	$(function(){
		$(".analysis-btn-1").click(function() {
			var idx = $(this).index(".analysis-btn-1");
			if ($(".inGameListOpen").eq(idx).css('display') == 'none') {
				$(".inGameListOpen").eq(idx).show();
				$(".champion-build").eq(idx).hide();
				$(".etc-chart-list").eq(idx).hide();
				$(".game-analysis-list").eq(idx).hide();
			} else {
			}		
		})
	});
	
	$(function(){
		$(".analysis-btn-2").click(function() {
			var idx = $(this).index(".analysis-btn-2");
			if ($(".game-analysis-list").eq(idx).css('display') == 'none') {
				$(".inGameListOpen").eq(idx).hide();
				$(".game-analysis-list").eq(idx).show();
				$(".champion-build").eq(idx).hide();
				$(".etc-chart-list").eq(idx).hide();
			} else {
			}
		})
	});
	
	$(function(){
		$(".analysis-btn-3").click(function() {
			var idx = $(this).index(".analysis-btn-3");
			if ($(".champion-build").eq(idx).css('display') == 'none') {
				$(".champion-build").eq(idx).show();
				$(".game-analysis-list").eq(idx).hide();
				$(".inGameListOpen").eq(idx).hide();
				$(".etc-chart-list").eq(idx).hide();
			} else {
			}
		})
	});
	
	$(function(){
		$(".analysis-btn-4").click(function() {
			var idx = $(this).index(".analysis-btn-4");
			if ($(".etc-chart-list").eq(idx).css('display') == 'none') {
				$(".etc-chart-list").eq(idx).show();
				$(".game-analysis-list").eq(idx).hide();
				$(".inGameListOpen").eq(idx).hide();
				$(".champion-build").eq(idx).hide();
				$(".game-analysis-list").eq(idx).hide();
			} else {
			}
		})
	});
</script>
<style>
	.profile-container{height:150px;}
	.profile-icon-image{width:100px;height:100px;border-radius: 10%;}
	.position-bar{width: 16px;height:64px;background-color:#ebeef1;}
	.position-bar-warp div{float:left;}
	.position-bar-icon div{float:left;}
	.challenger-profile-info div{float:left;}
	.position-icon {width:16px;height:16px;}
	.recentData-stats div{display:flex;}
	.recentData-champions > div{float:left;}
	/* .recentData-champions::after {clear:both;display:block;} */
	.recentData-stats ul{display:flex;justify-content:space-around;margin-bottom:-10px;list-style:none;}
	.position-bar{display:flex;flex-direction:column-reverse;justify-content:space-between;top:0;margin:0;padding:0;color:#4a4a4a;}
	.recent-container-wrap > .recent-container {float:left;}
	.face img{display: inline-block;width: 32px;height: 32px;border-radius: 50%;}
	.duo-ratio-tr img{width: 24px;height: 24px;border-radius: 50%;margin-right: 8px;}
	.champion-raito{width:330px;}.rank-info{height:100px;}.tier-info{float: left;}
	.bar{width:48px;height:1px;margin:8px 0 4px;background-color:#FFD8D9;}
	.spell img{display: block;border-radius: 4px;}
	.items ul > li{float:left;}
	.items ul li img{border-radius: 4px;line-style:none;}.items ul li div{border-radius: 4px;}
	.stats{float: left;width: 125px;height:100px}
	li {line-style:none;} ul {list-style: none;}
	.count{margin-left: 250px;}
	.same-info {withd} 
	.slist-box {float: left;width: 200px;margin-top: -16px;}
	.olist-box {float: left;width: 200px;margin-top: -16px;}
	.inGameData-box {margin-left: 310px;width: 926px;}
	.inGameData-list {height:130px;width:1000px;}
	.info-wrap {width: 355px;height:100%;}
	.inGameListOpen {display:none;margin-left: 100px;margin-top:-50px;}
	.inGameListOpen ul > li {float:left;} .inGameListOpen ul {height:10px;}
	.spells img {width: 16px;height:16px;border-radius: 4px;}
	tr .runes img {border-radius: 50%;width:24px;}
	.same-team-items div img{border-radius:4px;float:left;} .same-team-items div{float:left;}
	.graph{background-color:#5383E8;width:400px;height:22px;margin-left:100px;margin-top:10px;position:relative}
	.graph div{position:absolute;height: 22px;color:#FFF}
	.graph .title{width:400px;height:22px;position:absolute;text-align:center;z-index:3;}
	.analysis-btn-box li button{width:180px;height:28px;}
	.team-analysis-boxList li button{width:180px;height:28px;float:left}
	.game-analysis-list{display:none;margin-left: 100px;margin-top:-10px;width:700px;margin-left:100px}
	.analysis-btn-box button{float:left;}
	.analysis-btn-box{margin-left:100px;margin-top:-15px;display:none;}
	#chartContainer canvas{width:125px;height:100px;}
	.one-graph div div a{display:none;}
	.time-item-icon{float:left;}
	.item-build-container div:last-child{float:none;} 
	.item-build-container div img{border: 0;vertical-align: middle;max-width: 100%;border-radius: 4px;width:25px;}
	.time-skill-icon img {width:24px;height:24px;border-radius:4px;}
	.time-skill-icon  {float:left;}
	.skill-build-container div:last-child{float:none;} 
	.main-rune-build-list img{filter: grayscale(1);width:40px;height:40px;border-radius:50%;}
	.sub-rune-build-list img{filter: grayscale(1);width:40px;height:40px;border-radius:50%;}
	.subPerk1-wrap{height:50px;}.subPerk2-wrap{height:50px;}.subPerk3-wrap{height:50px;}
	.mainPerk1-wrap img{width:45px;height:45px;}.mainPerk2-wrap img{width:35px;height:35px;}.mainPerk3-wrap img{width:35px;height:35px;}.mainPerk4-wrap img{width:35px;height:35px;}
	.subPerk1-wrap img{width:35px;height:35px;}.subPerk2-wrap img{width:35px;height:35px;}.subPerk3-wrap img{width:35px;height:35px;}
	.basic-stats-area img{width:30px;height:30px;background-color:#333333;}
	.etc-chart-list {display:flex;width:700px;margin-left:50px;justify-content:space-evenly}	
	.champion-chart-img img{width:32px;height:32px;border-radius:4px;}
	.champion-build {display:none;width: 700px;margin-left: 150px;}
	.etc-chart-list {display:none;width: 700px;margin-left: 150px;}
	.etc-champion-img {display: flex;justify-content: space-evenly;}
	.userName-div {display: flex;font-size:5px;flex-direction: row;justify-content: space-evenly;}
	.inGameList-analysis-box{display:none;}
	/* .team-analysis-list{width: 700px;height: 610px;margin-left: -11px;} */
</style>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="wrapper">
	<!-- 유저 기본정보 -->
	<div class="profile-container">
		<div class="challenger-profile-info">
			<div class="profile-icon"><img class="profile-icon-image" src="${data.vo.profileIcon}"></div>
			<div class="profile-level"><span>${data.vo.summonerLevel}</span></div>
			<div class="profile-name">${data.vo.summonerName}</div>
			<input class="profile-puuid" type="hidden" value="${data.puuid}">
			<div class="profile-rank">래더 랭킹 ${param.rank} 위</div>
		</div>
	</div>
	<div>
		<div class="info-wrap" style="float:left;">
			<!-- 랭크정보 -->
			<div class="rank-info">
			    <div class="header">솔로랭크</div>
			    <div class="content">
			        <div style="position:relative;" class=""><img src="/lol/img/challenger.webp" style="border-radius:50%;width:72px;float:left;"></div>
			        <div class="tier-info">
			            <div class="tier">${data.vo.tier}</div>
			            <div class="lp">${data.vo.leaguePoints}LP</div>
			        </div>
			        <div class="win-lose-container">
			            <div class="win-lose">${data.vo.wins}승 ${data.vo.losses}패</div>
			            <div class="ratio"><fmt:formatNumber value="${data.vo.wins / (data.vo.wins+data.vo.losses)}" type="percent"/></div>
			        </div>
			    </div>
			</div>
			<!-- 챔피언 사용비율 및 종합지표 -->
			<div class="champion-raito">
				<c:forEach var="list" items="${data.championRatioList}">
					<div class="champion-box">
					    <div class="face" style="float:left;"><a href="" ><img src="${list.face}" width="32"></a></div>
					    <div class="info" style="float:left;">
					        <div class="name"><a href=""></a>${list.name}</div>
					        <div class="cs">CS ${list.cs} (${list.meanCs})</div>
					    </div>
					    <div class="kda" style="float:left;">
				            <div class="kda">${list.champKDA} 평점</div>
					        <div class="detail">${list.kills} / ${list.deaths} / ${list.assists}</div>
					    </div>
					    <div class="played">
				            <div class="champion-win-rate"><fmt:formatNumber value="${list.winRate}" type="percent"/></div>
					        <div class="count">${list.gameCount} 게임</div>
					    </div>
					</div>	
					<div style="clear:both;"></div>			
				</c:forEach>
			</div>
			
			<!-- 듀오승률 -->
			<div class="duo-ratio">
				<table>
					<c:forEach var="list" items="${data.duoRatioList}">
						<tr class="duo-ratio-tr">
							<td><img src="${list.icon}"></td>
							<td>${list.name}</td>
							<td>${list.nameCount}</td>
							<td>${list.win}-${list.nameCount-list.win}</td>
							<td><fmt:formatNumber value="${list.win/list.nameCount}" type="percent"/></td>
						</tr>		
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- 유저 최근정보 -->
			<div class="right-box">
				<div class="recent-container-wrap" style="height:140px;">
					<!-- 최근 전적 -->
					<div class="recent-container">
						<div class="recentData-stats">
							<div class="recent-total">${data.gameCount}전 ${data.wins}승 ${data.losses}패</div>
							<div class="recent-rate">${data.recentWinRate}%</div>
							<div class="recent-K-D-A">${data.meanKills} / ${data.meanDeaths} / ${data.meanAssists}</div>
							<div class="recent-kda">${data.kda}:1</div>
							<div class="recent-killsRate">킬관여율 ${data.killsRate}%</div>
						</div>
					</div>
					<!-- 최근 플레이한 챔피언 -->
					<div class="recent-container">
						<div class="recentData-champions-wrap" >	
							<div class="title">플레이한 챔피언 (최근 20게임)</div>
							<div class="recentData-champions">
								<c:forEach var="most" items="${data.mostChampList}">
									<c:if test="${!empty most.portrait}">
										<div><img src="${most.portrait}" style="width:24px;height:24px;border-radius:50%" class="most-portrait"></div>
									</c:if>
									<c:if test="${empty most.portrait}">
										<div>원챔충입니다.</div>
									</c:if>
									<div class="most-rate">${most.mostChampRate}%</div>
									<div class="most-win-lose">(${most.mostChampWins}승 ${most.mostChampTotalGame-most.mostChampWins}패)</div>
									<div class="most-kda">${most.mostChampKDA} 평점</div>
									<div style="clear:both;"></div>	
								</c:forEach>
							</div>
							<div style="clear:both;"></div>	
						</div>
					</div>
					<!-- 최근 플레이한 포지션 -->
					<div class="recent-container">
						<div class="recentData-stats">	
							<div class="title">선호 포지션(랭크)</div>
							<ul>
								<c:forEach var="bar" items="${data.barRateList}">
									<li class="position-bar">
										<div id="win" style="height:${bar}%;background-color:#5383E8;"></div>
									</li>
								</c:forEach>
							</ul>
						</div>
						<div class="recentData-stats">
							<ul>		
								<li><img src="/lol/img/Position_Challenger-Top.png" class="position-icon"></li>
								<li><img src="/lol/img/Position_Challenger-Jungle.png" class="position-icon"></li>
								<li><img src="/lol/img/Position_Challenger-Mid.png" class="position-icon"></li>
								<li><img src="/lol/img/Position_Challenger-Bot.png" class="position-icon"></li>
								<li><img src="/lol/img/Position_Challenger-Support.png" class="position-icon"></li>
							</ul>
						</div>
					</div>
				</div>
				
			<!-- 인게임 데이터 -->
			<div class="inGameData-box">
				<c:forEach var="list" items="${data.inGameList}" varStatus="idx">
					<input type="hidden" class="gameId" value="${list.gameId}">
					<input type="hidden" class="championId" value="${list.championId}">
				    <div class="inGameData-list" <c:if test="${list.win == 0}">style="background:#FFF1F3"</c:if><c:if test="${list.win == 1}">style="background:#ECF2FF"</c:if>>
				        <div class="game" style="float:left;">
				            <div class="type">솔랭</div>
					            <div class="time-stamp">
					                <div style="position:relative" class="">${list.gameEndTimestamp} 일 전</div>
					            </div>
				            <div class="bar"></div>
					            <c:if test="${list.win == 0}">
					            	<div class="output">패배</div>
					            </c:if>
					            <c:if test="${list.win == 1}">
					            	<div class="output">승리</div>
					            </c:if>
				            <div class="length">
				            	<fmt:parseNumber var="min" integerOnly="true" value="${list.gameDuration/60}"/>${min}분 ${list.gameDuration%60} 초
				            </div>
				        </div>
				        <div class="info">
				            <div class="champ-info" style="float:left;width:250px;">
				                <div class="champion" style="float:left;">
				                    <div class="icon" style="float: left;">
				                    	<img src="${list.portrait}" style="width:48px;height:48px;border-radius:50%;">
				                    	<span class="champion-level" style="z-index:2;margin-left:-17px;background-color: black;border-radius: 50%;color: #fff;font-size: 14px;">${list.champLevel}</span>
				                    </div>
				                    <div class="spells" style="float:left;margin-top: 3px;margin-left: 4px;">
				                        <div class="spell">
				                            <div style="position:relative" class=""><img src="${list.spell1Img}" style="width:22px;height:22px;"></div>
				                            <div style="position:relative" class="" ><img src="${list.spell2Img}" style="width:22px;height:22px;"></div>
				                        </div>
				                    </div>
				                    <div class="runes" style="both:clear;float:left;">
				                        <div class="rune">
				                            <div style="position:relative" class=""><img src="${list.mainPerk0Img}" width="22" height="22"></div>
				                            <div style="position:relative" class=""><img src="${list.subPerk0Img}" width="22" height="22"></div>
				                        </div>
				                    </div>
				                </div>
				                <div class="kda">
				                    <div class="k-d-a"><span>${list.kills}</span> / <span class="d">${list.deaths}</span> / <span>${list.assists}</span></div>
				                    <div class="ratio"><span></span>${list.kda}:1 평점</div>
				                </div>
				                <div class="items">
				                    <ul >
				                    	<c:if test="${list.item0Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item0Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item0Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item1Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item1Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item1Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item2Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item2Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item2Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item3Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item3Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item3Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item4Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item4Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item4Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item5Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item5Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item5Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item6Img == null}">
				                    		<li><div style="width:22px;height:22px;background-color: #B3CDFF;"></div></li>
				                    	</c:if>
				                    	<c:if test="${list.item6Img != null}">
				                    		<li><div style="position:relative" class=""><img src="${list.item6Img}" width="22"  height="22"></div></li>
				                    	</c:if>
				                    </ul>
					                <div class="multi-kill-box">
						                <c:if test="${list.doubleKills==1}">	
						                	<div class="multi-kill">더블킬</div>
						                </c:if>
						                <c:if test="${list.tripleKills==1}">	
						                	<div class="multi-kill">트리플킬</div>
						                </c:if>
						                <c:if test="${list.quadraKills==1}">	
						                	<div class="multi-kill">쿼드라킬</div>
						                </c:if>
						                <c:if test="${list.pentaKills==1}">	
						                	<div class="multi-kill">펜타킬</div>
						                </c:if>
					                </div>
				                </div>
				            </div>
				            <div class="stats-box">
				                <div class="stats">
				                    <div class="p-kill">
				                        <div style="position:relative" class="">킬관여 <fmt:formatNumber value="${(list.kills+list.assists) / list.totalTeamKills}" type="percent"/></div>
				                        
				                    </div>
				                    <div class="ward">제어 와드 ${list.visionWards}</div>
				                    <div class="cs">
				                        <div style="position:relative" class="">${list.cs} (<fmt:formatNumber  value="${list.cs / min}" pattern=".0"/>)</div>
				                    </div>
				                    <div class="average-tier">
				                        <div style="position:relative" class="">challenger</div>
				                    </div>
				                </div>
				            </div>
				        </div>
				        <div >
					        <div class="participants">
					        	<div class="slist-box" style="">
						            <ul>
						            	<c:forEach var="slist" items="${list.ssList}">
							                <li class="sameTeam-info">
							                    <div style="position:relative;float:left;" class="icon">
							                    	<img src="${slist.championIcon}" width="16" height="16">
							                    </div>
							                    <div class="name">${slist.s_name}</div>
							                </li>
							            </c:forEach>
						            </ul>
						        </div>
						        <div class="olist-box">
						            <ul>
						            	<c:forEach var="olist" items="${list.ooList}">
							                <li class="sameTeam-info">
							                    <div style="position:relative;float:left;" class="icon">
							                    	<img src="${olist.championIcon}" width="16" height="16">
							                    </div>
							                    <div class="name">${olist.s_name}</div>
							                </li>
							            </c:forEach>
						            </ul>
						    	</div>
					        </div>
					        <div class="action">
					        	<button class="detailBtn">
					        		<img src="https://s-lol-web.op.gg/images/icon/icon-arrow-down-blue.svg?v=1667466672190" width="24" height="24">
					        	</button>
					       		
					        </div>
				        </div>
				    </div>
				    <div class="inGameList-analysis-box">
		       			<ul class="analysis-btn-box">
						    <li class="synthesis-analysis"><button class="analysis-btn-1">종합</button></li>
						    <li class="team-analysis"><button class="analysis-btn-2">팀 분석</button></li>
						    <li class="build-analysis"><button class="analysis-btn-3">빌드</button></li>
						    <li class="etc-analysis"><button style="float:none;" class="analysis-btn-4">etc</button></li>
						</ul>
				    	<div class="inGameListOpen">
							<div class="synthesis-wrap" style="margin-bottom: 15px;">
							    <table class="css-8keylx e15ptgz10">
							        <colgroup>
							            <col width="44">
							            <col width="18">
							            <col width="18">
							            <col>
							            <col width="68">
							            <col width="98">
							            <col width="120">
							            <col width="48">
							            <col width="56">
							            <col width="175">
							        </colgroup>
							        <thead>
							            <tr>
							                <th colspan="4"><span class="result">패배</span>(레드팀)</th>
							                <th>OP Score</th>
							                <th>KDA</th>
							                <th>피해량</th>
							                <th>와드</th>
							                <th>CS</th>
							                <th>아이템</th>
							            </tr>
							        </thead>
							        <tbody>
							        	<c:forEach var="slist" items="${list.ssList}">
								            <tr class="css-1lb4d66 e1j3rwa94">
								                <td class="champion">
							                        <div class="" style="position: relative;">
							                        	<img src="${slist.championIcon}" style="width: 32px;height:32px;border-radius:50%;">
							                            <div class="level">${slist.level}</div>
							                        </div>
								                </td>
								                <td class="spells">
								                    <div class="" style="position: relative;"><img src="${slist.spell1Imgs}"></div>
								                    <div class="" style="position: relative;"><img src="${slist.spell2Imgs}"></div>
								                </td>
								                <td class="runes">
								                    <div class="" style="position: relative;"><img src="${slist.mainPerk0Imgs}"></div>
								                    <div class="" style="position: relative;"><img src="${slist.subPerk0Imgs}"></div>
								                </td>
								                <td class="name">${slist.s_name}
								                    <div class="tier">
								                        <div class="" style="position: relative;">challenger</div>
								                    </div>
								                </td>
								                <td class="op-score">
								                    <div class="wrapper">
								                        <div class="score">미정</div>
								                        <div class="rank">
								                            <div class="op-rank">미정</div>
								                        </div>
								                    </div>
								                </td>
								                <td class="kda">
								                    <div class="k-d-a">${slist.killed} / ${slist.death} / ${slist.assist}
								                    	<div class="" style="position: relative;">
															<fmt:formatNumber value="${(slist.killed+slist.assist) / list.totalTeamKills}" type="percent"/>										                    	
								                    	</div>
								                    </div>
							                    	<div class="k+s/d">
							                    		<c:if test="${slist.k_d_a == null}">
							                    			0.00:1
							                    		</c:if>
							                    		<c:if test="${slist.k_d_a != null}">
							                    			${slist.k_d_a}:1
							                    		</c:if>
							                    	</div>
								                </td>
								                <td class="damage">
								                    <div>
								                        <div class="" style="position: relative;">
								                            <div class="dealt"><fmt:formatNumber value="${slist.dealt}" pattern="#,###"></fmt:formatNumber></div>
								                            
								                            <div class="progress">
								                                <div class="fill" style="width: 54%;"></div>
								                            </div>
								                        </div>
								                        <div class="" style="position: relative;">
								                            <div class="taken"><fmt:formatNumber value="${slist.taken}" pattern="#,###"></fmt:formatNumber></div>
								                            <div class="progress--taken">
								                                <div class="fill" style="width: 77%;"></div>
								                            </div>
								                        </div>
								                    </div>
								                </td>
								                <td class="ward">
								                    <div class="" style="position: relative;">
								                        <div>${slist.v_ward}</div>
								                        <div>${slist.w_place} / ${slist.w_kill}</div>
								                    </div>
								                </td>
								                <td class="cs">
								                    <div>${slist.qcs}</div>
								                    <div>분당 ${slist.mcs}</div>
								                </td>
								                <td class="same-team-items">
								                	<c:if test="${slist.item0Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item0Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item0Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item1Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item1Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item1Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item2Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item2Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item2Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item3Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item3Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item3Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item4Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item4Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item4Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item5Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item5Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item5Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item6Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item6Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item6Imgs}" width="22" ></div>
							                    	</c:if>
								                    
								                </td>
								            </tr>
								    	</c:forEach>
							        </tbody>
							    </table>
							    <div class="summary" style="height:70px;">
							        <div class="team">
							            <div class="object" style="float:left;">
							                <div class="" style="position: relative;">
							                	<img src="https://s-lol-web.op.gg/images/icon/icon-baron-r.svg?v=1667466671992">
							                	<span>${list.stotalBar_kill}</span>
							                </div>
							            </div>
							            <div class="object" style="float:left;">
							                <div class="" style="position: relative;">
							                	<img src="https://s-lol-web.op.gg/images/icon/icon-dragon-r.svg?v=1667466671992">
							                	<span>${list.stotalDra_kill}</span>
							                </div>
							            </div>
							            <div class="object" style="float:left;">
							                <div class="" style="position: relative;">
								                <img src="https://s-lol-web.op.gg/images/icon/icon-tower-r.svg?v=1667466671992">
								                <span>${list.stotalTur_kill}</span>
							             	</div>
							            </div>
							        </div>
							        <div class="summary-graph" style="float:left">
							            <div>
							                <div class="graph">
							                    <div class="title">Total Kill</div>
							                    <div class="data-left" style="width:${(list.totalTeamKills/(list.totalTeamKills+list.totalOtherKills))*100}%;background-color:#E84057;position:absolute;">${list.totalTeamKills}</div>
							                    <div class="data-right" style="width:400px;position:absolute;text-align:right;">${list.totalOtherKills}</div>
							                </div>
							            </div>
							            <div>
							                <div class="graph">
							                    <div class="title">Total Gold</div>
							                    <div class="data-left" style="width:${(list.stotalGold/(list.stotalGold+list.ototalGold))*100}%;background-color:#E84057;position:absolute;"><fmt:formatNumber value="${list.stotalGold}" pattern="#,###"></fmt:formatNumber></div>
							                    <div class="data-right" style="width:400px;position:absolute;text-align:right;"><fmt:formatNumber value="${list.ototalGold}" pattern="#,###"></fmt:formatNumber></div>
							                </div>
							            </div>
							        </div>
							        <div class="team" style="margin-left:100px;margin-left: 685px;width: 100px;height: 100px;">
							            <div class="object" style="float:left">
							                <div class="" style="position: relative;">
							                	<img src="https://s-lol-web.op.gg/images/icon/icon-baron.svg?v=1667466671992">
							                	<span>${list.ototalBar_kill}</span>
							                </div>
							            </div>
							            <div class="object" style="float:left">
							                <div class="" style="position: relative;">
								                <img src="https://s-lol-web.op.gg/images/icon/icon-dragon.svg?v=1667466671992">
								                <span>${list.ototalDra_kill}</span>
							                </div>
							            </div>
							            <div class="object">
							                <div class="" style="position: relative;">
								                <img src="https://s-lol-web.op.gg/images/icon/icon-tower.svg?v=1667466671992">
								                <span>${list.ototalTur_kill}</span>
							                </div>
							            </div>
							        </div>
							    </div>
							    <table class="css-1478wry e15ptgz10">
							        <colgroup>
							            <col width="44">
							            <col width="18">
							            <col width="18">
							            <col>
							            <col width="68">
							            <col width="98">
							            <col width="120">
							            <col width="48">
							            <col width="56">
							            <col width="175">
							        </colgroup>
							        <thead>
							            <tr>
							                <th colspan="4"><span class="result">승리</span>(블루팀)</th>
							                <th>OP Score</th>
							                <th>KDA</th>
							                <th>피해량</th>
							                <th>와드</th>
							                <th>CS</th>
							                <th>아이템</th>
							            </tr>
							        </thead>
							        <c:forEach var="slist" items="${list.ooList}">
								            <tr class="css-1lb4d66 e1j3rwa94">
								                <td class="champion">
							                        <div class="" style="position: relative;">
							                        	<img src="${slist.championIcon}" style="width: 32px;height:32px;border-radius:50%;">
							                            <div class="level">${slist.level}</div>
							                        </div>
								                </td>
								                <td class="spells">
								                    <div class="" style="position: relative;"><img src="${slist.spell1Imgs}"></div>
								                    <div class="" style="position: relative;"><img src="${slist.spell2Imgs}"></div>
								                </td>
								                <td class="runes">
								                    <div class="" style="position: relative;"><img src="${slist.mainPerk0Imgs}"></div>
								                    <div class="" style="position: relative;"><img src="${slist.subPerk0Imgs}"></div>
								                </td>
								                <td class="name">${slist.s_name}
								                    <div class="tier">
								                        <div class="" style="position: relative;">challenger</div>
								                    </div>
								                </td>
								                <td class="op-score">
								                    <div class="wrapper">
								                        <div class="score">미정</div>
								                        <div class="rank">
								                            <div class="op-rank">미정</div>
								                        </div>
								                    </div>
								                </td>
								                <td class="kda">
								                    <div class="k-d-a">${slist.killed} / ${slist.death} / ${slist.assist}
								                    	<div class="" style="position: relative;">
															<fmt:formatNumber value="${(slist.killed+slist.assist) / list.totalTeamKills}" type="percent"/>										                    	
								                    	</div>
								                    </div>
							                    	<div class="k+s/d">
							                    		<c:if test="${slist.k_d_a == null}">
							                    			0.00:1
							                    		</c:if>
							                    		<c:if test="${slist.k_d_a != null}">
							                    			${slist.k_d_a}:1
							                    		</c:if>
							                    	</div>
								                </td>
								                <td class="damage">
								                    <div>
								                        <div class="" style="position: relative;">
								                            <div class="dealt"><fmt:formatNumber value="${slist.dealt}" pattern="#,###"></fmt:formatNumber></div>
								                            
								                            <div class="progress">
								                                <div class="fill" style="width: 54%;"></div>
								                            </div>
								                        </div>
								                        <div class="" style="position: relative;">
								                            <div class="taken"><fmt:formatNumber value="${slist.taken}" pattern="#,###"></fmt:formatNumber></div>
								                            <div class="progress--taken">
								                                <div class="fill" style="width: 77%;"></div>
								                            </div>
								                        </div>
								                    </div>
								                </td>
								                <td class="ward">
								                    <div class="" style="position: relative;">
								                        <div>${slist.v_ward}</div>
								                        <div>${slist.w_place} / ${slist.w_kill}</div>
								                    </div>
								                </td>
								                <td class="cs">
								                    <div>${slist.qcs}</div>
								                    <div>분당 ${slist.mcs}</div>
								                </td>
								                <td class="same-team-items">
								                	<c:if test="${slist.item0Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item0Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item0Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item1Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item1Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item1Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item2Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item2Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item2Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item3Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item3Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item3Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item4Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item4Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item4Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item5Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item5Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item5Imgs}" width="22" ></div>
							                    	</c:if>
								                	<c:if test="${slist.item6Imgs == null}">
							                    		<div style="width:22px;height:22px;background-color: #B3CDFF;"></div>
							                    	</c:if>
								                	<c:if test="${slist.item6Imgs != null}">
							                    		<div class="" style="position: relative;"><img src="${slist.item6Imgs}" width="22" ></div>
							                    	</c:if>
								                </td>
								            </tr>
								    	</c:forEach>
							        </tbody>
							    </table>
							</div>			
			       		</div>	
						    <!-- <ul class="team-analysis-boxList">
						        <li><button class="game-analysis-btn1">경기 분석</button></li>
						        <li><button class="game-analysis-btn2">골드 &amp; 킬</button></li>
						        <li><button class="game-analysis-btn3">킬 맵</button></li>
						        <li><button class="game-analysis-btn4" style="float:none;">타임라인</button></li>
						    </ul> -->
						    <div class="game-analysis-left"></div>
						    <div class="game-analysis-list" style="margin-left: 200px;">
						        <div class="legend" style="width:100%;margin-left:13px;">
						            <ul style="position: relative;width: 50px;height: 4px;left: 354px;margin-left: -103px;">
						                <li style="position: absolute;left: -20px;"><span style="color:#e84057">유저팀</span></li>
						                <li><span style="position: absolute;right:-20px;color:#5383E8">상대팀</span></li>
						            </ul>
						        </div>
						        <ul style="display: flex;flex-wrap: wrap;width:100%;">
						            <li class="champ-kill-analysis-li" style="flex:1 1 40%">
						                <div>
						                    <h4 style="margin-left:35px;">챔피언 처치</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.killed/list.osTopKill)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;">${slist.killed}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left:148px;margin-top: 15px;">
						                            <div>
						                                <div id="chartContainer_champ_kill-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left: 54px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;">${list.totalTeamKills}</div>
						                                    <div class="lose" style="color:#5383E8;">${list.totalOtherKills}</div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.killed/list.osTopKill)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;">${olist.killed}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						            <li class="gold-gain-analysis-li" style="flex:1 1 30%">
						                <div>
						                    <h4 style="margin-left:35px;">골드 획득량</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.gold/list.osTopGold)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:34px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${slist.gold}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left:148px;margin-top:15px;">
						                            <div>
						                                <div id="chartContainer_gain_gold-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left:40px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;"><fmt:formatNumber value="${list.stotalGold}" pattern="#,###"></fmt:formatNumber></div>
						                                    <div class="lose" style="color:#5383E8;"><fmt:formatNumber value="${list.ototalGold}" pattern="#,###"></fmt:formatNumber></div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.gold/list.osTopGold)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:34px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${olist.gold}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						            <li class="champ-dealt-analysis-li" style="flex:1 1 40%">
						                <div>
						                    <h4>챔피언에게 가한 피해량</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.dealt/list.osTopDealt)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${slist.dealt}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left:150px;margin-top: 15px;">
						                            <div>
						                                <div id="chartContainer_dealt_damage-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left: 40px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;"><fmt:formatNumber value="${list.totalDamageDealt}" pattern="#,###"></fmt:formatNumber></div>
						                                    <div class="lose" style="color:#5383E8;"><fmt:formatNumber value="${list.totalOtherDealt}" pattern="#,###"></fmt:formatNumber></div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.dealt/list.osTopDealt)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${olist.dealt}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						            <li class="ward-place-analysis-li" style="flex:1 1 30%">
						                <div>
						                    <h4 style="margin-left:45px;">와드 설치</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.w_place/list.osTopWard)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;">${slist.w_place}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left:148px;margin-top:15px;">
						                            <div>
						                                <div id="chartContainer_placed_ward-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left: 54px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;">${list.stotalWoard}</div>
						                                    <div class="lose" style="color:#5383E8;">${list.ototalWoard}</div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.w_place/list.osTopWard)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;">${olist.w_place}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						            <li class="champ-taken-analysis-li" style="flex:1 1 40%">
						                <div>
						                    <h4 style="margin-left:35px;">받은 피해량</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.taken/list.osTopTaken)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${slist.taken}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left:148px;margin-top: 15px;">
						                            <div>
						                                <div id="chartContainer_total_taken-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left:40px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;"><fmt:formatNumber value="${list.stotalTaken}" pattern="#,###"></fmt:formatNumber></div>
						                                    <div class="lose" style="color:#5383E8;"><fmt:formatNumber value="${list.ototalTaken}" pattern="#,###"></fmt:formatNumber></div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.taken/list.osTopTaken)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;"><fmt:formatNumber value="${olist.taken}" pattern="#,###"></fmt:formatNumber></span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						            <li class="cs-kill-analysis-li" style="flex:1 1 30%">
						                <div>
						                    <h4 style="margin-left:75px;">CS</h4>
						                    <div class="table" style="width:370px;height: 133px;margin-left:-130px;">
						                        <div class="team" style="float:left;position: absolute;width:110px;height: 105px;">
						                            <ul>
						                            	<c:forEach var="slist" items="${list.ssList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${slist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(slist.qcs/list.osTopCs)*100}%;height:16px;background-color:#e84057;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px;">${slist.qcs}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                        <div class="one-graph" style="float:left;margin-left: 149px;margin-top: 15px;">
						                            <div>
						                                <div id="chartContainer_killed_CS-${idx.index}"></div>
						                                <div class="value" style="z-index: 10;position: absolute;width: 52px;height: 62px;color: black;margin-left: 51px;margin-top: 27px;">
						                                    <div class="win" style="color:#e84057;">${list.stotalCs}</div>
						                                    <div class="lose" style="color:#5383E8;">${list.ototalCs}</div>
						                                </div>
						                            </div>
						                        </div>
						                        <div class="team" style="position: absolute;width:110px;height: 105px;margin-left:240px;">
						                            <ul>
						                                <c:forEach var="olist" items="${list.ooList}">
							                                <li style="width:110px;height:16px;position:relative;">
							                                    <div class="icon" style="float:left;"><img src="${olist.championIcon}" style="width:16px;height:16px;border-radius:5%;position:absolute;"></div>
							                                    <div class="progress" style="width:80px;height:16px;margin-bottom:2px;background-color:#DBE0E4;margin-left: 20px;position:relative">
							                                        <div class="bar" style="width:${(olist.qcs/list.osTopCs)*100}%;height:16px;background-color:#5383E8;"></div>
							                                        <span style="z-index:3;position: absolute;margin-left:63px;margin-top: -23px;font-size:15px;right:3px">${olist.qcs}</span>
							                                    </div>
							                                </li>
						                                </c:forEach>
						                            </ul>
						                        </div>
						                    </div>
						                </div>
						            </li>
						        </ul>
						    </div>
						    <div class="champion-build">
							    <h2 class="item-build-title">아이템 빌드</h2>
						        <div class="item-build-container">
						            <div class="item-build-list"></div>
					            </div>
							    <h2 class="skill-build-title">스킬 빌드</h2>
						        <div class="skill-build-container">
						            <div class="skill-build-list"></div>
					            </div>
							    <h2 class="rune-build-title">룬 빌드</h2>
						        <div class="rune-build-container" style="display: flex;align-items: flex-end;">
						            <div class="main-rune-build-list">
						            	<c:if test="${list.mainPerk0 == 8000}">
							            	<div class="main-perk-area" style="width:200px;">
							            		<h5>정밀</h5>
							            		<div class="mainPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="mainPerk0" style="text-align:center;width:100%;"><img src="/lol/img/정밀.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="mainPerk1-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="mainPerk1"><img src="/lol/img/집중 공격.png"<c:if test='${list.mainPerk1 == 8005}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/기민한 발놀림.png"<c:if test='${list.mainPerk1 == 8008}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/치명적 속도.png"<c:if test='${list.mainPerk1 == 8021}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/정복자.png"<c:if test='${list.mainPerk1 == 8010}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk2-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="mainPerk2"><img src="/lol/img/과다치유.png"<c:if test='${list.mainPerk2 == 9101}'>style="filter: grayscale(0);"</c:if>></div>
							            	 		<div class="mainPerk2"><img src="/lol/img/승전보.png"<c:if test='${list.mainPerk2 == 9111}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/침착.png"<c:if test='${list.mainPerk2 == 8009}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk3-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="mainPerk3"><img src="/lol/img/전설 민첩함.png"<c:if test='${list.mainPerk3 == 9104}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/전설 강인함.png"<c:if test='${list.mainPerk3 == 9105}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/전설 핏빛길.png"<c:if test='${list.mainPerk3 == 9103}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk4-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="mainPerk4"><img src="/lol/img/최후의 일격.png"<c:if test='${list.mainPerk4 == 8014}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/체력차 극복.png"<c:if test='${list.mainPerk4 == 8017}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/최후의 저항.png"<c:if test='${list.mainPerk4 == 8299}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.mainPerk0 == 8100}">
							            	<div class="main-perk-area" style="width:200px;">
							            		<h5>지배</h5>
							            		<div class="mainPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="mainPerk0" style="text-align:center;width:100%;"><img src="/lol/img/지배.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="mainPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk1"><img src="/lol/img/감전.png"<c:if test='${list.mainPerk1 == 8112}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/포식자.png"<c:if test='${list.mainPerk1 == 8124}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/어둠의 수확.png"<c:if test='${list.mainPerk1 == 8128}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/칼날비.png"<c:if test='${list.mainPerk1 == 9923}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk2"><img src="/lol/img/비열한 한 방.png"<c:if test='${list.mainPerk2 == 8126}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/피의 맛.png"<c:if test='${list.mainPerk2 == 8139}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/돌발 일격.png"<c:if test='${list.mainPerk2 == 8143}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk3"><img src="/lol/img/좀비 와드.png"<c:if test='${list.mainPerk3 == 8136}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/유령 포로.png"<c:if test='${list.mainPerk3 == 8120}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/사냥의 증표.png"<c:if test='${list.mainPerk3 == 8120}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk4-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk4"><img src="/lol/img/보물 사냥꾼.png"<c:if test='${list.mainPerk4 == 8135}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/영리한 사냥꾼.png"<c:if test='${list.mainPerk4 == 8134}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/끈질긴 사냥꾼.png"<c:if test='${list.mainPerk4 == 8105}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/궁극의 사냥꾼.png"<c:if test='${list.mainPerk4 == 8106}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.mainPerk0 == 8200}">
							            	<div class="main-perk-area" style="width:200px;">
							            		<h5>마법</h5>
							            		<div class="mainPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="mainPerk0" style="text-align:center;width:100%;"><img src="/lol/img/마법.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="mainPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk1"><img src="/lol/img/콩콩이 소환.png"<c:if test='${list.mainPerk1 == 8214}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/신비로운 유성.png"<c:if test='${list.mainPerk1 == 8229}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/난입.png"<c:if test='${list.mainPerk1 == 8230}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk2"><img src="/lol/img/무효화 구체.png"<c:if test='${list.mainPerk2 == 8224}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/마나순환 팔찌.png"<c:if test='${list.mainPerk2 == 8226}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/빛의 망토.png"<c:if test='${list.mainPerk2 == 8275}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk3"><img src="/lol/img/깨달음.png"<c:if test='${list.mainPerk3 == 8210}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/기민함.png"<c:if test='${list.mainPerk3 == 8234}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/절대 집중.png"<c:if test='${list.mainPerk3 == 8233}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk4-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk4"><img src="/lol/img/주문 작열.png"<c:if test='${list.mainPerk4 == 8237}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/물 위를 걷는 자.png"<c:if test='${list.mainPerk4 == 8232}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/폭풍의 결집.png"<c:if test='${list.mainPerk4 == 8236}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.mainPerk0 == 8300}">
							            	<div class="main-perk-area" style="width:200px;">
							            		<h5>영감</h5>
							            		<div class="mainPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="mainPerk0" style="text-align:center;width:100%;"><img src="/lol/img/영감.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="mainPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk1"><img src="/lol/img/빙결 강화.png"<c:if test='${list.mainPerk1 == 8351}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/봉인 풀린 주문서.png"<c:if test='${list.mainPerk1 == 8360}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/선제공격.png"<c:if test='${list.mainPerk1 == 8369}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk2"><img src="/lol/img/마법공학 점멸기.png"<c:if test='${list.mainPerk2 == 8306}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/마법의 신발.png"<c:if test='${list.mainPerk2 == 8304}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/완벽한 타이밍.png"<c:if test='${list.mainPerk2 == 8313}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk3"><img src="/lol/img/외상.png"<c:if test='${list.mainPerk3 == 8321}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/미니언 해체분석기.png"<c:if test='${list.mainPerk3 == 8316}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/비스킷 배달.png"<c:if test='${list.mainPerk3 == 8345}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk4-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk4"><img src="/lol/img/우주적 통찰력.png"<c:if test='${list.mainPerk4 == 8347}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/쾌속 접근.png"<c:if test='${list.mainPerk4 == 8410}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/시간 왜곡 물약.png"<c:if test='${list.mainPerk4 == 8352}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.mainPerk0 == 8400}">
							            	<div class="main-perk-area" style="width:200px;">
							            		<h5>결의</h5>
							            		<div class="mainPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="mainPerk0" style="text-align:center;width:100%;"><img src="/lol/img/결의.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="mainPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk1"><img src="/lol/img/착취의 손아귀.png"<c:if test='${list.mainPerk1 == 8437}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/여진.png"<c:if test='${list.mainPerk1 == 8439}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk1"><img src="/lol/img/수호자.png"<c:if test='${list.mainPerk1 == 8465}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk2"><img src="/lol/img/철거.png"<c:if test='${list.mainPerk2 == 8446}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/생명의 샘.png"<c:if test='${list.mainPerk2 == 8463}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk2"><img src="/lol/img/보호막 강타.png"<c:if test='${list.mainPerk2 == 8401}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk3"><img src="/lol/img/사전 준비.png"<c:if test='${list.mainPerk3 == 8429}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/재생의 바람.png"<c:if test='${list.mainPerk3 == 8444}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk3"><img src="/lol/img/뼈 방패.png"<c:if test='${list.mainPerk3 == 8473}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="mainPerk4-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="mainPerk4"><img src="/lol/img/과잉성장.png"<c:if test='${list.mainPerk4 == 8451}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/소생.png"<c:if test='${list.mainPerk4 == 8453}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="mainPerk4"><img src="/lol/img/불굴의 의지.png"<c:if test='${list.mainPerk4 == 8242}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            </div>
						            <!-- 보조룬 -->
						            <div class="sub-rune-build-list">
						            	<c:if test="${list.subPerk0 == 8000}">
							            	<div class="sub-perk-area" style="width:200px;">
							            		<div class="subPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="subPerk0" style="text-align:center;width:100%;"><img src="/lol/img/정밀.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="subPerk1-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="subPerk1"><img src="/lol/img/과다치유.png"<c:if test='${list.subPerk1 == 9101}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 9101}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/승전보.png"<c:if test='${list.subPerk1 == 9111}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 9111}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/침착.png"<c:if test='${list.subPerk1 == 8009}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8009}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk2-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="subPerk2"><img src="/lol/img/전설 민첩함.png"<c:if test='${list.subPerk1 == 9104}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 9104}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/전설 강인함.png"<c:if test='${list.subPerk1 == 9105}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 9105}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/전설 핏빛길.png"<c:if test='${list.subPerk1 == 9103}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 9103}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk3-wrap" style="display:flex;width:100%;justify-content: space-around;">
							            			<div class="subPerk3"><img src="/lol/img/최후의 일격.png"<c:if test='${list.subPerk1 == 8014}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8014}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/체력차 극복.png"<c:if test='${list.subPerk1 == 8017}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8017}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/최후의 저항.png"<c:if test='${list.subPerk1 == 8299}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8299}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.subPerk0 == 8100}">
							            	<div class="sub-perk-area" style="width:200px;">
							            		<h5>지배</h5>
							            		<div class="subPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="subPerk0" style="text-align:center;width:100%;"><img src="/lol/img/지배.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="subPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk1"><img src="/lol/img/비열한 한 방.png"<c:if test='${list.subPerk1 == 8126}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8126}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/피의 맛.png"<c:if test='${list.subPerk1 == 8139}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8139}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/돌발 일격.png"<c:if test='${list.subPerk1 == 8143}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8143}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk2"><img src="/lol/img/좀비 와드.png"<c:if test='${list.subPerk1 == 8136}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8136}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/유령 포로.png"<c:if test='${list.subPerk1 == 8120}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8120}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/사냥의 증표.png"<c:if test='${list.subPerk1 == 8120}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8120}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk4-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk3"><img src="/lol/img/보물 사냥꾼.png"<c:if test='${list.subPerk1 == 8135}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8135}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/영리한 사냥꾼.png"<c:if test='${list.subPerk1 == 8134}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8134}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/끈질긴 사냥꾼.png"<c:if test='${list.subPerk1 == 8105}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8105}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/궁극의 사냥꾼.png"<c:if test='${list.subPerk1 == 8106}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8106}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.subPerk0 == 8200}">
							            	<div class="sub-perk-area" style="width:200px;">
							            		<h5>마법</h5>
							            		<div class="subPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="subPerk1" style="text-align:center;width:100%;"><img src="/lol/img/마법.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="subPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk1"><img src="/lol/img/무효화 구체.png"<c:if test='${list.subPerk1 == 8224}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8224}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/마나순환 팔찌.png"<c:if test='${list.subPerk1 == 8226}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8226}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/빛의 망토.png"<c:if test='${list.subPerk1 == 8275}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8275}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk2"><img src="/lol/img/깨달음.png"<c:if test='${list.subPerk1 == 8210}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8210}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/기민함.png"<c:if test='${list.subPerk1 == 8234}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8234}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/절대 집중.png"<c:if test='${list.subPerk1 == 8233}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8233}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk3"><img src="/lol/img/주문 작열.png"<c:if test='${list.subPerk1 == 8237}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8237}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/물 위를 걷는 자.png"<c:if test='${list.subPerk1 == 8232}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8232}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/폭풍의 결집.png"<c:if test='${list.subPerk1 == 8236}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8236}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.subPerk0 == 8300}">
							            	<div class="sub-perk-area" style="width:200px;">
							            		<h5>영감</h5>
							            		<div class="subPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="subPerk0" style="text-align:center;width:100%;"><img src="/lol/img/영감.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="subPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk1"><img src="/lol/img/마법공학 점멸기.png"<c:if test='${list.subPerk1 == 8306}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8306}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/마법의 신발.png"<c:if test='${list.subPerk1 == 8304}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8304}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/완벽한 타이밍.png"<c:if test='${list.subPerk1 == 8313}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8313}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk2"><img src="/lol/img/외상.png"<c:if test='${list.subPerk1 == 8321}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8321}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/미니언 해체분석기.png"<c:if test='${list.subPerk1 == 8316}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8316}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/비스킷 배달.png"<c:if test='${list.subPerk1 == 8345}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8345}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk3"><img src="/lol/img/우주적 통찰력.png"<c:if test='${list.subPerk1 == 8347}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8347}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/쾌속 접근.png"<c:if test='${list.subPerk1 == 8410}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8410}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/시간 왜곡 물약.png"<c:if test='${list.subPerk1 == 8352}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8352}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            	<c:if test="${list.subPerk0 == 8400}">
							            	<div class="sub-perk-area" style="width:200px;">
							            		<h5>결의</h5>
							            		<div class="subPerk0-wrap" style="margin: 0 auto;width:100%;">
							            			<div class="subPerk0" style="text-align:center;width:100%;"><img src="/lol/img/결의.png" style="filter: grayscale(0);"></div>
							            		</div>
							            		<div class="subPerk1-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk1"><img src="/lol/img/철거.png"<c:if test='${list.subPerk1 == 8446}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8446}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/생명의 샘.png"<c:if test='${list.subPerk1 == 8463}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8463}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk1"><img src="/lol/img/보호막 강타.png"<c:if test='${list.subPerk1 == 8401}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8401}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk2-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk2"><img src="/lol/img/사전 준비.png"<c:if test='${list.subPerk1 == 8429}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8429}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/재생의 바람.png"<c:if test='${list.subPerk1 == 8444}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8444}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk2"><img src="/lol/img/뼈 방패.png"<c:if test='${list.subPerk1 == 8473}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk2 == 8473}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            		<div class="subPerk3-wrap" style="display:flex;width:100%;height:50px;justify-content: space-around;">
							            			<div class="subPerk3"><img src="/lol/img/과잉성장.png"<c:if test='${list.subPerk2 == 8451}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk1 == 8451}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/소생.png"<c:if test='${list.subPerk2 == 8453}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk1 == 8453}'>style="filter: grayscale(0);"</c:if>></div>
							            			<div class="subPerk3"><img src="/lol/img/불굴의 의지.png"<c:if test='${list.subPerk2 == 8242}'>style="filter: grayscale(0);"</c:if><c:if test='${list.subPerk1 == 8242}'>style="filter: grayscale(0);"</c:if>></div>
							            		</div>
							            	</div>
						            	</c:if>
						            </div>
						            <!-- 적응형 능력치 -->
						            <div class="sub-rune-build-list">
						            	<div class="basic-stats-area" style="width:200px;margin-bottom:11px;">
						            		<div class="basic-stats1-wrap" style="display:flex;width:100%;justify-content: space-around;">
						            			<div class="offenseStat"><img src="/lol/img/5008.webp"<c:if test='${list.offenseStat == 5008}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="offenseStat"><img src="/lol/img/5005.webp"<c:if test='${list.offenseStat == 5005}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="offenseStat"><img src="/lol/img/5007.webp"<c:if test='${list.offenseStat == 5007}'>style="filter: grayscale(0);"</c:if>></div>
						            		</div>
						            		<div class="basic-stats2-wrap" style="display:flex;width:100%;justify-content: space-around;">
						            			<div class="flexStat"><img src="/lol/img/5008.webp"<c:if test='${list.flexStat == 5008}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="flexStat"><img src="/lol/img/5002.webp"<c:if test='${list.flexStat == 5002}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="flexStat"><img src="/lol/img/5003.webp"<c:if test='${list.flexStat == 5003}'>style="filter: grayscale(0);"</c:if>></div>
						            		</div>
						            		<div class="basic-stats3-wrap" style="display:flex;width:100%;justify-content: space-around;">
						            			<div class="defenseStat"><img src="/lol/img/5001.webp"<c:if test='${list.defenseStat == 5001}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="defenseStat"><img src="/lol/img/5002.webp"<c:if test='${list.defenseStat == 5002}'>style="filter: grayscale(0);"</c:if>></div>
						            			<div class="defenseStat"><img src="/lol/img/5003.webp"<c:if test='${list.defenseStat == 5003}'>style="filter: grayscale(0);"</c:if>></div>
						            		</div>
						            	</div>
						            </div>
					            </div>
					        </div>
					        <div class="etc-chart-list">
					        	<div class="etc-champion-img"></div>
					        	<div class="userName-div"></div>
					        	<div class="etc-gold-chart-${idx.index}" style="width:700px;height:400px;"></div>
					        </div>
				    </div>
				</c:forEach>
			</div>
		</div>
	</div>
</div>
</body>
</html>