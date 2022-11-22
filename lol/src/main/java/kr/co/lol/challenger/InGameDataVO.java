package kr.co.lol.challenger;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class InGameDataVO {

	private int no;
	private Long gameId;
	private int kills;
	private int deaths;
	private int assists;
	private int champLevel;
	private int gainGold;
	private int wardsKilled;
	private int wardsPlaced;
	private int visionWards;
	private int cs;
	private int dragonKills;
	private int baronKills;
	private int turretKills;
	private int inhibitorKills;
	private int totalDamageDealt;
	private int totalDamageTaken;
	private int defenseStat;
	private int flexStat;
	private int offenseStat;
	private int mainPerk0;
	private int mainPerk1;
	private int mainPerk2;
	private int mainPerk3;
	private int mainPerk4;
	private int subPerk0;
	private int subPerk1;
	private int subPerk2;
	private int item0;
	private int item1;
	private int item2;
	private int item3;
	private int item4;
	private int item5;
	private int item6;
	private int summoner1Id;
	private int summoner2Id;
	private int doubleKills;
	private int tripleKills;
	private int quadraKills;
	private int pentaKills;
	private int championId;
	private String summonerName;
	private int teamId;
	private String puuid;
	private String teamPosition;
	private int win;
	private int gameDuration;
	private Long gameEndTimestamp;
	private int ban;
	
	private int stotalGold;
	private int ototalGold;
	private int osTopGold;
	private int ssTopGold;
	private int ooTopGold;
	
	private int stotalDra_kill;
	private int ototalDra_kill;
	private int stotalBar_kill;
	private int ototalBar_kill;
	private int stotalTur_kill;
	private int ototalTur_kill;
	
	private int ranking;
	
	private int champ_count;
	private int name_count;
	
	private String name;
	private String portrait;
	private String profileIcon;
	private String spell1Img;
	private String spell2Img;
	private String mainPerk0Img;
	private String subPerk0Img;
	private String item0Img;
	private String item1Img;
	private String item2Img;
	private String item3Img;
	private String item4Img;
	private String item5Img;
	private String item6Img;
	private double kda;
	private int divDeaths;
	private int totalTeamKills;
	private int totalOtherKills;
	private int totalOtherDealt;
	private int ssTopKill;
	private int ooTopKill;
	
	private int ssTopDealt;
	private int ooTopDealt;
	private int osTopDealt;
	
	private int stotalTaken;
	private int ototalTaken;
	private int ssTopTaken;
	private int ooTopTaken;
	private int osTopTaken;
	
	private int stotalWoard;
	private int ototalWoard;
	private int ssTopWard;
	private int ooTopWard;
	private int osTopWard;
	
	private int stotalCs;
	private int ototalCs;
	private int ssTopCs;
	private int ooTopCs;
	private int osTopCs;
	
	
	
	
	
	private int osTopKill;
	
	private double killRatio;
	
	private List<Map<String, Object>> sameTeamList;
	private List<Map<String, Object>> otherTeamList;
	private List<QueryVO> ssList;
	private List<QueryVO> ooList;
	
	private String sameTeamName;
	private String otherTeamName;
	private int sameTeamChampId;
	private int otherTeamChampId;
	
}
