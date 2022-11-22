package kr.co.lol.challenger;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChallengerServiceImpl implements ChallengerService {

	@Autowired
	ChallengerMapper mapper;
	
	@Override
	public List<ChallengerVO> ChallengerList(ChallengerVO vo) {
		int totalCount = mapper.challengersCount();
		vo.pagingProcess(100, totalCount);
		return mapper.challengerList(vo);
	}

	@Override
	public Map<String, Object> inGameList(String summonerName) {
		String puuid = mapper.puuid(summonerName);
		ChallengerVO vo = mapper.challengerInfo(summonerName);
		List<InGameDataVO> inGameList = mapper.inGameList(summonerName);
		List<InGameDataVO> inGameIntegration5 = mapper.inGameIntegration5(summonerName);
		List<Map<String, Object>> recentMostChampion = mapper.recentMostChampion(summonerName);
		
		Date date = new Date();
		long time = date.getTime();
		
		int wins = 0; int losses = 0; int gameCount = 0;
		int kills = 0; int deaths = 0; int assists = 0;
		for (int i=0; i<inGameList.size(); i++) {
			wins += inGameList.get(i).getWin();
			kills += inGameList.get(i).getKills();
			deaths += inGameList.get(i).getDeaths();
			assists += inGameList.get(i).getAssists();
			gameCount += 1;
			long pastTime = 0L;
			pastTime = ((time-inGameList.get(i).getGameEndTimestamp())/86400000);
			inGameList.get(i).setGameEndTimestamp(pastTime);
			inGameList.get(i).setPortrait(mapper.championPortrait(inGameList.get(i).getChampionId()));
			inGameList.get(i).setDivDeaths(inGameList.get(i).getDeaths());
			if(inGameList.get(i).getDeaths() == 0) {
				inGameList.get(i).setDivDeaths(1);
			}
			inGameList.get(i).setKda((((inGameList.get(i).getKills()+inGameList.get(i).getAssists())*100)/inGameList.get(i).getDivDeaths())/100.00);
			InGameDataVO ivo = new InGameDataVO();
			ivo.setGameId(inGameList.get(i).getGameId());
			ivo.setSummonerName(inGameList.get(i).getSummonerName());
			
			int totalTeamkills = 0; int totalOtherKills = 0; int totalTeamDealt = 0; int totalOtherDealt = 0;
			int stotalGold = 0;int ototalGold = 0; int stotalDra_kill = 0; int ototalDra_kill = 0;; 
			int stotalBar_kill = 0;int ototalBar_kill = 0; int stotalTur_kill = 0; int ototalTur_kill = 0; 
			int stotal_ward = 0; int ototal_ward = 0; int stotalTaken = 0; int ototalTaken = 0;
			int stotal_cs = 0; int ototal_cs = 0;
			
			List<QueryVO> sList = mapper.slist(inGameList.get(i).getGameId());
			List<QueryVO> oList = mapper.slist(inGameList.get(i).getGameId());
			List<QueryVO> saList = new ArrayList<QueryVO>();
			List<QueryVO> otList = new ArrayList<QueryVO>();
			for (int j=0; j<sList.size(); j++) {
				if(inGameList.get(i).getTeamId() == sList.get(j).getRedbul()) {
					QueryVO qvo = new QueryVO();
					qvo.setIndex_no(sList.get(j).getIndex_no());
					qvo.setS_name(sList.get(j).getS_name());
					qvo.setKilled(sList.get(j).getKilled());
					qvo.setDeath(sList.get(j).getDeath());
					qvo.setAssist(sList.get(j).getAssist());
					qvo.setLevel(sList.get(j).getLevel());
					qvo.setW_kill(sList.get(j).getW_kill());
					qvo.setW_place(sList.get(j).getW_place());
					qvo.setV_ward(sList.get(j).getV_ward());
					qvo.setDealt(sList.get(j).getDealt());
					qvo.setTaken(sList.get(j).getTaken());
					qvo.setRedbul(sList.get(j).getRedbul());
					qvo.setChampionIcon(sList.get(j).getChampionIcon());
					qvo.setMainPerk0Imgs(sList.get(j).getMainPerk0Imgs());
					qvo.setSubPerk0Imgs(sList.get(j).getSubPerk0Imgs());
					qvo.setSpell1Imgs(sList.get(j).getSpell1Imgs());
					qvo.setSpell2Imgs(sList.get(j).getSpell2Imgs());
					qvo.setItem0Imgs(sList.get(j).getItem0Imgs());
					qvo.setItem1Imgs(sList.get(j).getItem1Imgs());
					qvo.setItem2Imgs(sList.get(j).getItem2Imgs());
					qvo.setItem3Imgs(sList.get(j).getItem3Imgs());
					qvo.setItem4Imgs(sList.get(j).getItem4Imgs());
					qvo.setItem5Imgs(sList.get(j).getItem5Imgs());
					qvo.setItem6Imgs(sList.get(j).getItem6Imgs());
					qvo.setDra_kill(sList.get(j).getDra_kill());
					qvo.setBar_kill(sList.get(j).getBar_kill());
					qvo.setTur_kill(sList.get(j).getTur_kill());
					qvo.setGold(sList.get(j).getGold());
					qvo.setQcs(sList.get(j).getQcs());
					qvo.setMcs(((sList.get(j).getQcs()*10)/(inGameList.get(i).getGameDuration()/60))/10.0);
					double kda = 0;
					int divDeaths = sList.get(j).getDeath();
					try {
						if (sList.get(j).getDeath() == 0) divDeaths = 1;
						kda = ((((sList.get(j).getKilled()+sList.get(j).getAssist())*100)/divDeaths)/100.00);
						qvo.setK_d_a(kda);
					} catch (Exception e) {}
					totalTeamkills += sList.get(j).getKilled();
					totalTeamDealt += sList.get(j).getDealt();
					if (sList.get(j).getKilled() >= inGameList.get(i).getKills()) {
						inGameList.get(i).setSsTopKill(sList.get(j).getKilled());
					}
					if (sList.get(j).getGold() >= inGameList.get(i).getGainGold()) {
						inGameList.get(i).setSsTopGold(sList.get(j).getGold());
					}
					if (sList.get(j).getDealt() >= inGameList.get(i).getTotalDamageDealt()) {
						inGameList.get(i).setSsTopDealt(sList.get(j).getDealt());
					}
					if (sList.get(j).getTaken() >= inGameList.get(i).getTotalDamageTaken()) {
						inGameList.get(i).setSsTopTaken(sList.get(j).getTaken());
					}
					if (sList.get(j).getW_place() >= inGameList.get(i).getWardsPlaced()) {
						inGameList.get(i).setSsTopWard(sList.get(j).getW_place());
					}
					if (sList.get(j).getQcs() >= inGameList.get(i).getCs()) {
						inGameList.get(i).setSsTopCs(sList.get(j).getQcs());
					}
					stotalGold += qvo.getGold();
					stotalDra_kill += qvo.getDra_kill();
					stotalBar_kill += qvo.getBar_kill();
					stotalTur_kill += qvo.getTur_kill();
					stotal_ward += qvo.getW_place();
					stotalTaken += qvo.getTaken();
					stotal_cs += qvo.getQcs();
							
					
					saList.add(qvo);
					inGameList.get(i).setSsList(saList);
				} else {
					
					QueryVO qvo = new QueryVO();
					qvo.setIndex_no(oList.get(j).getIndex_no());
					qvo.setS_name(oList.get(j).getS_name());
					qvo.setKilled(oList.get(j).getKilled());
					qvo.setDeath(oList.get(j).getDeath());
					qvo.setAssist(oList.get(j).getAssist());
					qvo.setLevel(oList.get(j).getLevel());
					qvo.setW_kill(oList.get(j).getW_kill());
					qvo.setW_place(oList.get(j).getW_place());
					qvo.setV_ward(oList.get(j).getV_ward());
					qvo.setDealt(oList.get(j).getDealt());
					qvo.setTaken(oList.get(j).getTaken());
					qvo.setRedbul(oList.get(j).getRedbul());
					qvo.setChampionIcon(oList.get(j).getChampionIcon());
					qvo.setMainPerk0Imgs(oList.get(j).getMainPerk0Imgs());
					qvo.setSubPerk0Imgs(oList.get(j).getSubPerk0Imgs());
					qvo.setSpell1Imgs(oList.get(j).getSpell1Imgs());
					qvo.setSpell2Imgs(oList.get(j).getSpell2Imgs());
					qvo.setItem0Imgs(oList.get(j).getItem0Imgs());
					qvo.setItem1Imgs(oList.get(j).getItem1Imgs());
					qvo.setItem2Imgs(oList.get(j).getItem2Imgs());
					qvo.setItem3Imgs(oList.get(j).getItem3Imgs());
					qvo.setItem4Imgs(oList.get(j).getItem4Imgs());
					qvo.setItem5Imgs(oList.get(j).getItem5Imgs());
					qvo.setItem6Imgs(oList.get(j).getItem6Imgs());
					qvo.setDra_kill(oList.get(j).getDra_kill());
					qvo.setBar_kill(oList.get(j).getBar_kill());
					qvo.setTur_kill(oList.get(j).getTur_kill());
					qvo.setGold(oList.get(j).getGold());
					qvo.setQcs(oList.get(j).getQcs());
					qvo.setMcs(((oList.get(j).getQcs()*10)/(inGameList.get(i).getGameDuration()/60))/10.0);
					double kda = 0;
					int divDeaths = oList.get(j).getDeath();
					try {
						if (oList.get(j).getDeath() == 0) divDeaths = 1;
						kda = ((((oList.get(j).getKilled()+oList.get(j).getAssist())*100)/divDeaths)/100.00);
						qvo.setK_d_a(kda);
					} catch (Exception e) {}
					totalOtherKills += oList.get(j).getKilled();
					totalOtherDealt += oList.get(j).getDealt();
					if (oList.get(j).getKilled() >= inGameList.get(i).getKills()) {
						inGameList.get(i).setOoTopKill(oList.get(j).getKilled());
					}
					if (oList.get(j).getGold() >= inGameList.get(i).getGainGold()) {
						inGameList.get(i).setOoTopGold(oList.get(j).getGold());
					}
					if (oList.get(j).getDealt() >= inGameList.get(i).getTotalDamageDealt()) {
						inGameList.get(i).setOoTopDealt(oList.get(j).getDealt());
					}
					if (oList.get(j).getTaken() >= inGameList.get(i).getTotalDamageTaken()) {
						inGameList.get(i).setOoTopTaken(oList.get(j).getTaken());
					}
					if (oList.get(j).getW_place() >= inGameList.get(i).getWardsPlaced()) {
						inGameList.get(i).setOoTopWard(oList.get(j).getW_place());
					}
					if (oList.get(j).getQcs() >= inGameList.get(i).getCs()) {
						inGameList.get(i).setOoTopCs(oList.get(j).getQcs());
					}
					ototalGold += qvo.getGold();
					ototalDra_kill += qvo.getDra_kill();
					ototalBar_kill += qvo.getBar_kill();
					ototalTur_kill += qvo.getTur_kill();
					ototal_ward += qvo.getW_place();
					ototalTaken += qvo.getTaken();
					ototal_cs += qvo.getQcs();
					
					
					otList.add(qvo);
					inGameList.get(i).setOoList(otList);
				}
			}
			if (inGameList.get(i).getOoTopKill() >= inGameList.get(i).getSsTopKill()) {
				inGameList.get(i).setOsTopKill(inGameList.get(i).getOoTopKill());
			} else {
				inGameList.get(i).setOsTopKill(inGameList.get(i).getSsTopKill());
			}
			
			if (inGameList.get(i).getOoTopGold() >= inGameList.get(i).getSsTopGold()) {
				inGameList.get(i).setOsTopGold(inGameList.get(i).getOoTopGold());
			} else if (inGameList.get(i).getSsTopGold() >= inGameList.get(i).getOoTopGold()) {
				inGameList.get(i).setOsTopGold(inGameList.get(i).getSsTopGold());
			}
			
			if (inGameList.get(i).getOoTopDealt() >= inGameList.get(i).getSsTopDealt()) {
				inGameList.get(i).setOsTopDealt(inGameList.get(i).getOoTopDealt());
			} else {
				inGameList.get(i).setOsTopDealt(inGameList.get(i).getSsTopDealt());
			}
			
			if (inGameList.get(i).getOoTopTaken() >= inGameList.get(i).getSsTopTaken()) {
				inGameList.get(i).setOsTopTaken(inGameList.get(i).getOoTopTaken());
			} else {
				inGameList.get(i).setOsTopTaken(inGameList.get(i).getSsTopTaken());
			}
			
			if (inGameList.get(i).getOoTopWard() >= inGameList.get(i).getSsTopWard()) {
				inGameList.get(i).setOsTopWard(inGameList.get(i).getOoTopWard());
			} else {
				inGameList.get(i).setOsTopWard(inGameList.get(i).getSsTopWard());
			}
			
			if (inGameList.get(i).getOoTopCs() >= inGameList.get(i).getSsTopCs()) {
				inGameList.get(i).setOsTopCs(inGameList.get(i).getOoTopCs());
			} else {
				inGameList.get(i).setOsTopCs(inGameList.get(i).getSsTopCs());
			}
			
			inGameList.get(i).setStotalWoard(stotal_ward);
			inGameList.get(i).setOtotalWoard(ototal_ward);
			inGameList.get(i).setStotalGold(stotalGold);
			inGameList.get(i).setStotalDra_kill(stotalDra_kill);
			inGameList.get(i).setStotalBar_kill(stotalBar_kill);
			inGameList.get(i).setStotalTur_kill(stotalTur_kill);
			inGameList.get(i).setOtotalGold(ototalGold);
			inGameList.get(i).setOtotalDra_kill(ototalDra_kill);
			inGameList.get(i).setOtotalBar_kill(ototalBar_kill);
			inGameList.get(i).setOtotalTur_kill(ototalTur_kill);
			inGameList.get(i).setTotalTeamKills(totalTeamkills);
			inGameList.get(i).setTotalOtherKills(totalOtherKills);
			inGameList.get(i).setTotalDamageDealt(totalTeamDealt);
			inGameList.get(i).setTotalOtherDealt(totalOtherDealt);
			inGameList.get(i).setStotalTaken(stotalTaken);
			inGameList.get(i).setOtotalTaken(ototalTaken);
			inGameList.get(i).setStotalCs(stotal_cs);
			inGameList.get(i).setOtotalCs(ototal_cs);
			
			
			inGameList.get(i).setKillRatio(Math.round((((inGameList.get(i).getKills()+inGameList.get(i).getAssists())*100)/inGameList.get(i).getTotalTeamKills())));
		}
		
		
		
		losses = gameCount - wins;
		int recentWinRate = wins*100/gameCount;
		double meanKills = Math.round(kills/20.0*10)/10.0;
		double meanDeaths = Math.round(deaths/20.0*10)/10.0;
		double meanAssists = Math.round(assists/20.0*10)/10.0;
		double kda = Math.round((kills+assists)*100/deaths)/100.00;
		
		int totalTeamKills = 0;
		for (int i=0; i<inGameIntegration5.size(); i++) {
			totalTeamKills += inGameIntegration5.get(i).getKills();
		}
		int killsRate = Math.round(100*(kills+assists)/totalTeamKills);
		
		List<InGameDataVO> recentvo = new ArrayList<InGameDataVO>();
		for (int i=0; i<recentMostChampion.size()-1; i++) {
			InGameDataVO ivo = new InGameDataVO();
			ivo.setChampionId((Integer)recentMostChampion.get(i).get("championId"));
			ivo.setSummonerName(summonerName);
			for(int j = 0; j<mapper.recentMostChampionData(ivo).size(); j++) {
				recentvo.add(mapper.recentMostChampionData(ivo).get(j));
			}
		}
		
		int mostChamp1Wins = 0; int mostChamp2Wins = 0; int mostChamp3Wins = 0;
		int mostChamp1TotalGame = 0; int mostChamp2TotalGame = 0; int mostChamp3TotalGame = 0;
		int mostChamp1Rate = 0; int mostChamp2Rate = 0; int mostChamp3Rate = 0;
		int mostChamp1Kills = 0; int mostChamp2Kills = 0; int mostChamp3Kills = 0;
		int mostChamp1Deaths = 0; int mostChamp2Deaths = 0; int mostChamp3Deaths= 0;
		int mostChamp1Assists = 0; int mostChamp2Assists= 0; int mostChamp3Assists= 0;
		double mostChamp1KDA = 0; double mostChamp2KDA= 0; double mostChamp3KDA= 0;
		for (int i=0; i<recentMostChampion.size()-1;) {
			for (int j=0; j<recentvo.size(); j++) {
				if((Integer)recentMostChampion.get(0).get("championId") == recentvo.get(j).getChampionId()) {
					mostChamp1TotalGame += 1;
					mostChamp1Wins += recentvo.get(j).getWin();
					mostChamp1Kills += recentvo.get(j).getKills();
					mostChamp1Deaths += recentvo.get(j).getDeaths();
					mostChamp1Assists += recentvo.get(j).getAssists();
				} else if ((Integer)recentMostChampion.get(1).get("championId") == recentvo.get(j).getChampionId()){
					mostChamp2TotalGame += 1;
					mostChamp2Wins += recentvo.get(j).getWin();
					mostChamp2Kills += recentvo.get(j).getKills();
					mostChamp2Deaths += recentvo.get(j).getDeaths();
					mostChamp2Assists += recentvo.get(j).getAssists();
				} else if ((Integer)recentMostChampion.get(2).get("championId") == recentvo.get(j).getChampionId()) {
					mostChamp3TotalGame += 1;
					mostChamp3Wins += recentvo.get(j).getWin();
					mostChamp3Kills += recentvo.get(j).getKills();
					mostChamp3Deaths += recentvo.get(j).getDeaths();
					mostChamp3Assists += recentvo.get(j).getAssists();
				} else {
					break;
				}
			}
			break;
		}
		if(mostChamp1TotalGame == 0 || mostChamp2TotalGame == 0 || mostChamp3TotalGame == 0) {
			mostChamp1TotalGame = 1; mostChamp2TotalGame = 1; mostChamp3TotalGame = 1;
		}
		mostChamp1Rate = Math.round((100 * mostChamp1Wins) / mostChamp1TotalGame);
		mostChamp2Rate = Math.round((100 * mostChamp2Wins) / mostChamp2TotalGame);
		mostChamp3Rate = Math.round((100 * mostChamp3Wins) / mostChamp3TotalGame);
		mostChamp1KDA = Math.round((((mostChamp1Kills+mostChamp1Assists)*100.00) / mostChamp1Deaths) / 100.00);
		mostChamp2KDA = Math.round((((mostChamp2Kills+mostChamp2Assists)*100.00) / mostChamp2Deaths) / 100.00);
		mostChamp3KDA = Math.round((((mostChamp3Kills+mostChamp3Assists)*100.00) / mostChamp3Deaths) / 100.00);
		
		Map mostChamp1Map = new HashMap(); Map mostChamp2Map = new HashMap(); Map mostChamp3Map = new HashMap();
		String portrait1 = mapper.championPortrait((Integer)recentMostChampion.get(0).get("championId"));
		String portrait2 = mapper.championPortrait((Integer)recentMostChampion.get(1).get("championId"));
		String portrait3 = mapper.championPortrait((Integer)recentMostChampion.get(2).get("championId"));
		mostChamp1Map.put("mostChampTotalGame",mostChamp1TotalGame);
		mostChamp1Map.put("mostChampRate",mostChamp1Rate);
		mostChamp1Map.put("mostChampWins",mostChamp1Wins);
		mostChamp1Map.put("mostChampKDA",mostChamp1KDA);
		mostChamp1Map.put("portrait",portrait1);
		mostChamp2Map.put("mostChampTotalGame",mostChamp2TotalGame);
		mostChamp2Map.put("mostChampRate",mostChamp2Rate);
		mostChamp2Map.put("mostChampWins",mostChamp2Wins);
		mostChamp2Map.put("mostChampKDA",mostChamp2KDA);
		mostChamp2Map.put("portrait",portrait2);
		mostChamp3Map.put("mostChampTotalGame",mostChamp3TotalGame);
		mostChamp3Map.put("mostChampRate",mostChamp3Rate);
		mostChamp3Map.put("mostChampWins",mostChamp3Wins);
		mostChamp3Map.put("mostChampKDA",mostChamp3KDA);
		mostChamp3Map.put("portrait",portrait3);
		
		List mostChampList = new ArrayList();
		mostChampList.add(mostChamp1Map);
		mostChampList.add(mostChamp2Map);
		mostChampList.add(mostChamp3Map);
		
		List<Map> recentChampionCount = mapper.recentChampionCount(summonerName); 
		int positionCount = 0;
		List countList = new ArrayList();
		for (int i=0; i<recentChampionCount.size(); i++) {
			positionCount += Math.toIntExact((long) recentChampionCount.get(i).get("champ_count"));
			countList.add(Math.toIntExact((long) recentChampionCount.get(i).get("champ_count")));
		}
		List barRateList = new ArrayList();
		for (int i=0; i<countList.size(); i++) {
			barRateList.add(100*(Integer)countList.get(i)/positionCount);
		}
		List<Map> championRatioList = new ArrayList<Map>();
		List<InGameDataVO> championRatio = mapper.championRatio(summonerName);
		for (int i=0; i<championRatio.size(); i++) {
			Map<String, Object> championRationMap = new HashMap<String, Object>();
			if(championRatio.get(i).getDeaths() == 0) {
				championRatio.get(i).setDeaths(1);
			}
			championRationMap.put("name",championRatio.get(i).getName());
			championRationMap.put("face",championRatio.get(i).getPortrait());
			championRationMap.put("gameCount",championRatio.get(i).getChamp_count());
			championRationMap.put("cs",championRatio.get(i).getCs()*10/championRatio.get(i).getChamp_count()/10.0);
			championRationMap.put("winRate",championRatio.get(i).getWin()*10/championRatio.get(i).getChamp_count()/10.0);
			championRationMap.put("kills",championRatio.get(i).getKills()*10/championRatio.get(i).getChamp_count()/10.0);
			championRationMap.put("deaths",championRatio.get(i).getDeaths()*10/championRatio.get(i).getChamp_count()/10.0);
			championRationMap.put("assists",championRatio.get(i).getAssists()*10/championRatio.get(i).getChamp_count()/10.0);
			championRationMap.put("champKDA",((((championRatio.get(i).getKills()+championRatio.get(i).getAssists())*10)/championRatio.get(i).getDeaths())/10.0));
			championRationMap.put("meanCs",(((championRatio.get(i).getCs()/((championRatio.get(i).getGameDuration()/championRatio.get(i).getChamp_count())/60)*10)/championRatio.get(i).getChamp_count())/10.0));
			championRatioList.add(championRationMap);
		}
		
		
		
		List<Map> duoRatioList = new ArrayList<Map>();
		List<InGameDataVO> duoRatio = mapper.duoRatio(summonerName);
		for (int i=1; i<duoRatio.size(); i++) {
			Map<String, Object> duoRatioMap = new HashMap<String, Object>();
			duoRatioMap.put("name",duoRatio.get(i).getSummonerName());
			duoRatioMap.put("nameCount",duoRatio.get(i).getName_count());
			duoRatioMap.put("win",duoRatio.get(i).getWin());
			if(duoRatio.get(i).getProfileIcon() == null) {
				duoRatio.get(i).setProfileIcon("https://ddragon.leagueoflegends.com/cdn/12.19.1/img/profileicon/"+(1000+(int)(Math.random() * 50))+".png");
			}
			duoRatioMap.put("icon",duoRatio.get(i).getProfileIcon());
			duoRatioList.add(duoRatioMap);
		}
		
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("inGameList", inGameList);
		map.put("vo", vo);
		map.put("wins", wins);
		map.put("losses", losses);
		map.put("gameCount", gameCount);
		map.put("recentWinRate", recentWinRate);
		map.put("meanKills", meanKills);
		map.put("meanDeaths", meanDeaths);
		map.put("meanAssists", meanAssists);
		map.put("kda", kda);
		map.put("killsRate", killsRate);
		map.put("recentMostChampion", recentMostChampion);
		map.put("mostChampList", mostChampList);
		map.put("barRateList", barRateList);
		map.put("championRatioList", championRatioList);
		map.put("duoRatioList", duoRatioList);
		map.put("puuid", puuid);
		return map;
	}

	@Override
	public List<Map<String, Object>> itemBuild(Map<String, Object> userInfo) {
		Long gameId = Long.parseLong(String.valueOf(userInfo.get("gameId")));
		Map<String, Object> pmap = new HashMap<String, Object>();
		pmap.put("puuid", String.valueOf(userInfo.get("puuid")));
		pmap.put("gameId", gameId);
		List<Map<String, Object>> itemBuild = mapper.itemBuild(pmap);
		HashSet<Integer> minList = new HashSet<Integer>();
		for (int i=0; i<itemBuild.size(); i++) {
			minList.add((int) (Long.parseLong(String.valueOf(itemBuild.get(i).get("timestamp")))/60000));
		}
		TreeSet<Integer> treeSet = new TreeSet<Integer>();
		treeSet.addAll(minList);
		
		List<Map<String, Object>> itembuildList = new ArrayList<Map<String, Object>>();
		for (int i :treeSet) {
			for (int j=0; j<itemBuild.size(); j++) {
				if ((Long.parseLong(String.valueOf(itemBuild.get(j).get("timestamp")))/60000) == i) {
					Map<String, Object> itemMap = new HashMap<String, Object>();
					itemMap.put("time",i);
					itemMap.put("itemIcon",itemBuild.get(j).get("icon"));
					itemMap.put("ac_type", itemBuild.get(j).get("action_type"));
					itembuildList.add(itemMap);
				}
			}
		}
		return itembuildList;
	}

	@Override
	public List<Map<String, Object>> skillBuild(Map<String, Object> userInfo) {
		Map<String, Object> pmap = new HashMap<String, Object>();
		pmap.put("puuid", String.valueOf(userInfo.get("puuid")));
		pmap.put("gameId", Long.parseLong(String.valueOf(userInfo.get("gameId"))));
		pmap.put("champion_key", userInfo.get("championId"));
		List<Map<String, Object>> skillBuild = mapper.skillBuild(pmap);
		List<Map<String, Object>> skillBuildList = new ArrayList<Map<String, Object>>();
		for (int i=0; i<skillBuild.size(); i++) {
			Map<String, Object> skillMap = new HashMap<String, Object>();
			if ((int)(skillBuild.get(i).get("skillSlot")) == 1) {
				skillMap.put("skillIcon", skillBuild.get(i).get("qIcon"));
			} else if ((int)(skillBuild.get(i).get("skillSlot")) == 2) {
				skillMap.put("skillIcon", skillBuild.get(i).get("wIcon"));
			} else if ((int)(skillBuild.get(i).get("skillSlot")) == 3) {
				skillMap.put("skillIcon", skillBuild.get(i).get("eIcon"));
			} else {
				skillMap.put("skillIcon", skillBuild.get(i).get("rIcon"));
			}
			skillBuildList.add(skillMap);
		}
		return skillBuildList;
	}

	@Override
	public List<Map<String, Object>> moneyPerMin(Map<String, Object> userInfo) {
		Map<String, Object> pmap = new HashMap<String, Object>();
		pmap.put("summonerName", userInfo.get("summonerName"));
		pmap.put("gameId", Long.parseLong(String.valueOf(userInfo.get("gameId"))));
		List<Map<String, Object>> moneyChart = mapper.gameJoinTimeLineData(pmap);
		List<Map<String, Object>> mcList = new ArrayList<Map<String, Object>>(); 
		for(Map<String, Object> i : moneyChart) {
			Map<String, Object> cmap = new HashMap<String, Object>();
			cmap.put("participantId", i.get("participantId"));
			cmap.put("gameId", i.get("gameId"));
			cmap.put("summonerName", i.get("summonerName"));
			cmap.put("championIcon", mapper.championPortrait((int)i.get("championId")));
			cmap.put("minList", mapper.etcList(cmap)) ;
			mcList.add(cmap);
		}
		return mcList;
	}
}












