package kr.co.lol;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import kr.co.lol.challenger.ChallengerMapper;
import kr.co.lol.champion.ChampionMapper;
import lombok.extern.log4j.Log4j;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/resources/config/servlet-context.xml")
@Log4j
public class MysqlTest {
	
	@Autowired
	private ChampionMapper cimapper;
	
	@Autowired
	private ChallengerMapper clmapper;
	
	//@Test
	public void test1() {
		log.info(cimapper);
	}
	
	//@Test
	public void test2() { 
		log.info(cimapper.championInfo());
	}
	
	//@Test
	public void test3() {
		Map map = new HashMap();
		map.put("puuid", "rW0ZAeKFsucY8et6H9ZPtag5osbGrIK7FrS4-Z_sn-rxn4yO-AeOmpAkS8F8ANIWVxkIYr4LarDOUw");
		map.put("gameId", 6147885018L);
		log.info(clmapper.itemBuild(map));
	}
	
	@Test
	public void test4() {
		Map map = new HashMap();
		map.put("summonerName", "냥똥벌레");
		map.put("gameId", 6148041226L);
		log.info(clmapper.gameJoinTimeLineData(map));
	}
	

}
