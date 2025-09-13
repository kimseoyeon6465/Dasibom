package com.booksajo.dasibom.controller;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.booksajo.dasibom.service.CommentService;
import com.booksajo.dasibom.service.PostService;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.vo.PostsVO;
import com.booksajo.dasibom.vo.UserVO;

@Controller
public class NotificationController {

	@Resource(name = "postService")
	private PostService postService;

	@Resource(name = "CommentService")
	private CommentService commentService;

	@Resource(name = "UserService")
	private UserService userService;

	@RequestMapping("/goNotification.do")
	public String goNotification(@RequestParam(value = "spage", required = false, defaultValue = "1") int spage,
			Model model, HttpSession session) {

		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		int isAdmin = 0;
		if (loginUser != null) {
			isAdmin = loginUser.getIsAdmin();
		}

		int postsPerPage = 10;

		// 怨듭� 移댄뀒怨좊━ 湲� 媛쒖닔 媛��졇�삤湲�
		int totalNotificationCount = postService.getPostCountByCategory("怨듭�");

		int totalPages = (int) Math.ceil((double) totalNotificationCount / postsPerPage);
		if (totalPages == 0)
			totalPages = 1;

		if (spage < 1)
			spage = 1;
		else if (spage > totalPages)
			spage = totalPages;

		int startRow = (spage - 1) * postsPerPage + 1;
		int endRow = startRow + postsPerPage - 1;

		// 怨듭� 移댄뀒怨좊━ 寃뚯떆湲�留� �럹�씠吏� 議고쉶
		ArrayList<PostsVO> notificationPosts = postService.getPostsByCategoryPaged("怨듭�", startRow, endRow);

		// �뙎湲��닔 諛� �씠誘몄� �룷�븿 �뿬遺� �꽭�똿
		for (PostsVO post : notificationPosts) {
			int commentCount = postService.getCommentCountForPost(post.getPost_id());
			post.setCommentCount(commentCount);
			post.setHasImageInContent(post.getPost_contents() != null && post.getPost_contents().contains("<img"));
		}

		model.addAttribute("notificationPosts", notificationPosts);
		model.addAttribute("currentPage", spage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("isAdmin", isAdmin);

		return "notification";
	}

	@RequestMapping(value = "/showDetailNotification.do")
	public String showDetailNotification(@RequestParam("post_id") Integer postId, Model model, HttpSession session)
			throws Exception {
		PostsVO post = postService.getContent(postId);
		model.addAttribute("post", post);

		Integer userSeq = (Integer) session.getAttribute("user_seq");

		if (userSeq != null) {
			UserVO user = userService.getUserBySeq(userSeq);
			model.addAttribute("user", user);
		}

		return "showDetailNotification";
	}

	@RequestMapping(value = "/goWriteNotification.do")
	public String goWritePost(@RequestParam(value = "post_id", required = false) Integer postId, Model model,
			HttpSession session) {

		Integer userSeq = (Integer) session.getAttribute("user_seq");
		UserVO user = userService.getUserBySeq(userSeq);
		model.addAttribute("user", user);

		if (postId != null) {
			PostsVO post = postService.getContent(postId);
			model.addAttribute("post", post);
		}
		return "goWriteNotification";
	}

	@RequestMapping(value = "/insertNotification.do")
	public String insertNotification(@RequestParam("category") String category, @RequestParam("title") String title,
			@RequestParam("user_id") String userId, @RequestParam("content") String content,
			@RequestParam("image_path") String imagePath, RedirectAttributes redirectAttributes, Model model) {

		PostsVO post = new PostsVO(); // VO, �꽌鍮꾩뒪�뒗 湲곗〈 洹몃�濡� �쑀吏�
		post.setCategory(category);
		post.setTitle(title);
		post.setUser_id(userId);
		post.setPost_contents(content);
		post.setImage_path(imagePath);

		model.addAttribute("post", post);

		if (title == null || title.trim().isEmpty()) {
			model.addAttribute("message", "�젣紐⑹쓣 �엯�젰�빐二쇱꽭�슂");
			return "/common/alertBack";
		}
		if (content == null || content.trim().isEmpty()) {
			model.addAttribute("message", "�궡�슜�쓣 �엯�젰�빐二쇱꽭�슂");
			return "/common/alertBack";
		}

		boolean isSuccess = postService.insertPost(category, title, content, userId, imagePath);

		if (isSuccess) {
			redirectAttributes.addFlashAttribute("message", "�씠踰ㅽ듃 �옉�꽦�쓣 �셿猷뚰뻽�뒿�땲�떎");
			return "redirect:/goNotification.do"; // URL留� �씠踰ㅽ듃�슜�쑝濡� 蹂�寃�
		} else {
			model.addAttribute("message", "怨듭� �옉�꽦�뿉 �떎�뙣�뻽�뒿�땲�떎");
			return "/common/alertBack";
		}
	}

	@RequestMapping(value = "/updateNotification.do")
	public String updateNotification(@RequestParam("post_id") int postId, @RequestParam("category") String category,
			@RequestParam("title") String title, @RequestParam("user_id") String userId,
			@RequestParam("content") String content, @RequestParam("image_path") String imagePath,
			RedirectAttributes redirectAttributes, Model model) {

		PostsVO post = new PostsVO();
		post.setPost_id(postId);
		post.setCategory(category);
		post.setTitle(title);
		post.setUser_id(userId);
		post.setPost_contents(content);
		post.setImage_path(imagePath);

		model.addAttribute("post", post);
		if (title == null || title.trim().isEmpty()) {
			model.addAttribute("message", "�젣紐⑹쓣 �엯�젰�빐二쇱꽭�슂");
			return "/common/alertBack";
		}
		if (content == null || content.trim().isEmpty()) {
			model.addAttribute("message", "�궡�슜�쓣 �엯�젰�빐二쇱꽭�슂");
			return "/common/alertBack";
		}

		boolean isSuccess = postService.updatePost(postId, category, title, content, userId, imagePath);

		if (isSuccess) {
			redirectAttributes.addFlashAttribute("message", "怨듭� �닔�젙�쓣 �셿猷뚰뻽�뒿�땲�떎");
			return "redirect:/showDetailNotification.do?post_id=" + postId;
		} else {
			model.addAttribute("message", "怨듭� �닔�젙�뿉 �떎�뙣�뻽�뒿�땲�떎");
			return "/common/alertBack";
		}
	}

	@RequestMapping(value = "/deleteNotification.do")
	public String deleteNotification(@RequestParam("post_id") int postId, RedirectAttributes redirectAttributes,
			Model model) {
		try {
			boolean isDeleted = postService.deletePost(postId);

			if (isDeleted) {
				redirectAttributes.addFlashAttribute("message", "�씠踰ㅽ듃瑜� �궘�젣�뻽�뒿�땲�떎");
				return "redirect:/goNotification.do";
			} else {
				model.addAttribute("message", "�씠踰ㅽ듃 �궘�젣�뿉 �떎�뙣�뻽�뒿�땲�떎");
				return "/common/alertBack";
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("message", "�떆�뒪�뀥 �삤瑜섍� 諛쒖깮�뻽�뒿�땲�떎");
			return "/common/alertBack";
		}
	}

	@RequestMapping(value = "/searchNotification.do", method = RequestMethod.GET)
	public String searchPost(@RequestParam("keyword") String keyword,
			@RequestParam(value = "spage", required = false, defaultValue = "1") int spage, Model model) {

		// 寃��깋�뼱媛� �뾾�쑝硫� goPost濡� 由щ떎�씠�젆�듃
		if (keyword == null || keyword.trim().isEmpty()) {
			return "redirect:/goNotification.do?spage=" + spage;
		}

		int pageSize = 10;
		int startIndex = (spage - 1) * pageSize;

		int searchCount = postService.getSearchPostCount("%" + keyword + "%");

		ArrayList<PostsVO> searchResults = postService.searchPostsByKeywordPaged(keyword, startIndex, pageSize);

		int totalPages = (int) Math.ceil((double) searchCount / pageSize);

		model.addAttribute("notificationPosts", searchResults);
		model.addAttribute("currentPage", spage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("keyword", keyword);

		return "notification";
	}
}
