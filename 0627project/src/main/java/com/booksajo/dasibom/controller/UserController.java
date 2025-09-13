package com.booksajo.dasibom.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.booksajo.dasibom.encoder.SHA256PasswordEncoder;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.vo.UserVO;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	/*
	 * 회占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙
	 */
	@RequestMapping(value = "insertUser.do", method = RequestMethod.POST)
	public String insertUser(@RequestParam("tel1") String tel1, @RequestParam("tel2") String tel2,
			@RequestParam("tel3") String tel3, UserVO userVO, Model model) {
		// 占쏙옙화占쏙옙호(input 3칸짜占쏙옙 占쏙옙占쏙옙) -> 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占싹놂옙占쏙옙 占쏙옙占쌘울옙占쏙옙
		userVO.setTel(tel1 + "-" + tel2 + "-" + tel3);

		// 비밀번호 암호화 SHA-256
		SHA256PasswordEncoder encoder = new SHA256PasswordEncoder();

		String plainText = userVO.getPw(); // SHA-256으로 변환
		userVO.setPw(encoder.encode(plainText)); // 암호화된 비밀번호로 설정

		boolean isSuccessed = userService.insertUser(userVO);

		if (isSuccessed) {
			model.addAttribute("signupSuccess", "회占쏙옙占쏙옙占쏙옙 占싹뤄옙! 占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占싣곤옙占싹댐옙.");
		} else {
			model.addAttribute("signupFail", "회占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙. Err: ${errmsg}");
		}

		return "signupSuccess"; // 회占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 -> alert占쏙옙占� 占쏙옙 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙 redirect占싹댐옙 jsp
	}

	/*
	 * 占쏙옙占싱듸옙 占쌩븝옙 확占쏙옙
	 */
	@ResponseBody
	@RequestMapping(value = "validateUserId.do", method = RequestMethod.POST)
	public String validateDuplicateByUserId(UserVO userVO) {
		try {
			userService.validateDuplicateByUserId(userVO);
			return "available";
		} catch (IllegalStateException e) {
			return e.getMessage(); // 占쏙옙占쏙옙 占쌨쏙옙占쏙옙 占쌓댐옙占� 占쏙옙환
		}
	}

	/*
	 * 占싻놂옙占쏙옙 占쌩븝옙 확占쏙옙
	 */
	@ResponseBody
	@RequestMapping(value = "validateName.do", method = RequestMethod.POST)
	public String validateDuplicateByName(UserVO userVO) {
		try {
			userService.validateDuplicateByName(userVO);
			return "available";
		} catch (IllegalStateException e) {
			return e.getMessage(); // 占쏙옙占쏙옙 占쌨쏙옙占쏙옙 占쌓댐옙占� 占쏙옙환
		}
	}

}
