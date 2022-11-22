package kr.co.lol.challenger;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChallengerMapper {

	List<ChallengerVO> challengerList(ChallengerVO vo);
	int challengersCount();
	
	List<InGameDataVO> inGameList(String summonerName);
	ChallengerVO challengerInfo(String summonerName);
	List<InGameDataVO> gameIdList(String summonerName);
	
	List<InGameDataVO> inGameIntegration(String summonerName);
	List<InGameDataVO> inGameIntegration5(String summonerName);
	
	List<Map<String, Object>> recentMostChampion(String summonerName);
	List<InGameDataVO> recentMostChampionData(InGameDataVO vo);
	
	String championPortrait(int champion_key);
	
	List<Map> recentChampionCount(String summonerName);
	
	List<InGameDataVO> championRatio(String summonerName);
	
	List<InGameDataVO> duoRatio(String summonerName); // 듀오승률

	List<InGameDataVO> oneGameData(InGameDataVO vo); // 하나의 게임에 대한 데이터
	
	
	List<QueryVO> slist(Long gameId);
	
	String spellList(int spell_key);
	String runeList(int perk_key);
	
	List<Map<String, Object>> itemBuild(Map<String, Object> map);
	String puuid(String summonerName);
	List<Map<String, Object>> skillBuild(Map<String, Object> map);
	List<Map<String, Object>> gameJoinTimeLineData(Map<String, Object> map);
	List<Map<String, Object>> etcList(Map<String, Object> map);
}










