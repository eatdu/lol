package kr.co.lol.challenger;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/challenger")
public class ChallengerController {

	@Autowired
	ChallengerService service;
	
	@GetMapping("/rank")
	public String rank(Model model, ChallengerVO vo) {
		List<ChallengerVO> challenger = service.ChallengerList(vo);
		model.addAttribute("challenger", challenger);
		return "challenger/rank";
	}
	
	@GetMapping("/summoners")
	public String summoners(Model model, String summonerName) {
		Map<String, Object> data = service.inGameList(summonerName);
		model.addAttribute("data", data);
		return "challenger/summoners";
	}
	
	
	@ResponseBody
	@RequestMapping(value="/itemBuild",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public List<Map<String, Object>> itemBuild(@RequestBody Map<String, Object> param) {
		return service.itemBuild(param);
	}
	
	@ResponseBody
	@RequestMapping(value="/skillBuild",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public List<Map<String, Object>> skillBuild(@RequestBody Map<String, Object> param) {
		return service.skillBuild(param);
	}
	
	@ResponseBody
	@RequestMapping(value="/etc",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public List<Map<String, Object>> etc(@RequestBody Map<String, Object> param) {
		return service.moneyPerMin(param);
	}
	
}
