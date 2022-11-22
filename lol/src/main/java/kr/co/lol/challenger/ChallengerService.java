package kr.co.lol.challenger;

import java.util.List;
import java.util.Map;

public interface ChallengerService {

	List<ChallengerVO> ChallengerList(ChallengerVO vo);
	Map<String, Object> inGameList(String summonerName);
	List<Map<String, Object>> itemBuild(Map<String, Object> map);
	List<Map<String, Object>> skillBuild(Map<String, Object> map);
	List<Map<String, Object>> moneyPerMin(Map<String, Object> map);
}
