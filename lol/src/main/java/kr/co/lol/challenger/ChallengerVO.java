package kr.co.lol.challenger;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import util.Paging;

@Getter
@Setter
@ToString
public class ChallengerVO extends Paging {

	private int no;
	private int ranking;
	private String tier;
	private String summonerName;
	private int leaguePoints;
	private int wins;
	private int losses;
	private int summonerLevel;
	private String profileIcon;
	private String summonerId;
	private String puuid;
	
	
}
