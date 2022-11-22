package kr.co.lol.champion;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChampionMapper {

	List<ChampionVO> championInfo();
}
