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
import com.booksajo.dasibom.vo.CommentVO;
import com.booksajo.dasibom.vo.PostsVO;
import com.booksajo.dasibom.vo.UserVO;

@Controller
public class QnaController {

	@Resource(name = "postService")
	private PostService postService;

	@Resource(name = "CommentService")
	private CommentService commentService;

	@Resource(name = "UserService")
	private UserService userService;

	@RequestMapping("/goQna.do")
	public String goQna(@RequestParam(value = "spage", required = false, defaultValue = "1") int spage, Model model) {
		int postsPerPage = 20;

		int totalQnaCount = postService.getPostCountByCategory("Q&A");
		int totalPages = (int) Math.ceil((double) totalQnaCount / postsPerPage);

		if (spage < 1)
			spage = 1;
		else if (spage > totalPages && totalPages != 0)
			spage = totalPages;

		int startIndex = (spage - 1) * postsPerPage;
		ArrayList<PostsVO> qnaPosts = postService.getPostsByCategoryPaged("Q&A", startIndex, postsPerPage);

		for (PostsVO post : qnaPosts) {
			int commentCount = postService.getCommentCountForPost(post.getPost_id());
			post.setCommentCount(commentCount);
			post.setHasImageInContent(post.getPost_contents() != null && post.getPost_contents().contains("<img"));
		}

		model.addAttribute("qnaPosts", qnaPosts);
		model.addAttribute("currentPage", spage);
		model.addAttribute("totalPages", totalPages);
		return "qna";
	}

	@RequestMapping("/showDetailQna.do")
	public String showDetailQna(@RequestParam("post_id") Integer postId, Model model, HttpSession session)
			throws Exception {
		PostsVO post = postService.getContent(postId);
		model.addAttribute("post", post);

		Integer userSeq = (Integer) session.getAttribute("user_seq");
		if (userSeq != null) {
			UserVO user = userService.getUserBySeq(userSeq);
			model.addAttribute("user", user);
		}

		int commentCount = postService.getCommentCountForPost(postId);
		model.addAttribute("commentCount", commentCount);
		ArrayList<CommentVO> comments = commentService.getAllCommentsForPost(postId);
		model.addAttribute("comments", comments);
		return "showDetailQna";
	}

	@RequestMapping("/goWriteQna.do")
	public String goWriteQna(@RequestParam(value = "post_id", required = false) Integer postId, Model model,
			HttpSession session) {
		Integer userSeq = (Integer) session.getAttribute("user_seq");
		UserVO user = userService.getUserBySeq(userSeq);
		model.addAttribute("user", user);

		if (postId != null) {
			PostsVO post = postService.getContent(postId);
			model.addAttribute("post", post);
		}
		return "goWriteQna";
	}

	@RequestMapping("/insertQna.do")
	public String insertQna(@RequestParam("title") String title, @RequestParam("user_id") String userId,
			@RequestParam("content") String content, @RequestParam("image_path") String imagePath,
			RedirectAttributes redirectAttributes, Model model) {

		PostsVO post = new PostsVO();
		post.setCategory("Q&A");
		post.setTitle(title);
		post.setUser_id(userId);
		post.setPost_contents(content);
		post.setImage_path(imagePath);
		model.addAttribute("post", post);

		if (title == null || title.trim().isEmpty() || userId == null || userId.trim().isEmpty() || content == null
				|| content.trim().isEmpty()) {
			model.addAttribute("message", "紐⑤뱺 �븘�뱶瑜� �엯�젰�빐二쇱꽭�슂");
			return "/common/alertBack";
		}

		boolean isSuccess = postService.insertPost("Q&A", title, content, userId, imagePath);
		if (isSuccess) {
			redirectAttributes.addFlashAttribute("message", "�옉�꽦�쓣 �셿猷뚰뻽�뒿�땲�떎");
			return "redirect:/goQna.do";
		} else {
			model.addAttribute("message", "�옉�꽦�씠 �떎�뙣�뻽�뒿�땲�떎");
			return "/common/alertBack";
		}
	}

	@RequestMapping(value = "/searchQna.do", method = RequestMethod.GET)
	public String searchPost(@RequestParam("keyword") String keyword,
			@RequestParam(value = "spage", required = false, defaultValue = "1") int spage, Model model) {

		// 寃��깋�뼱媛� �뾾�쑝硫� goPost濡� 由щ떎�씠�젆�듃
		if (keyword == null || keyword.trim().isEmpty()) {
			return "redirect:/goQna.do?spage=" + spage;
		}

		int pageSize = 10;
		int startIndex = (spage - 1) * pageSize;

		int searchCount = postService.getSearchPostCount("%" + keyword + "%");

		ArrayList<PostsVO> searchResults = postService.searchPostsByKeywordPaged(keyword, startIndex, pageSize);

		int totalPages = (int) Math.ceil((double) searchCount / pageSize);

		model.addAttribute("qnaPosts", searchResults);
		model.addAttribute("currentPage", spage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("keyword", keyword);

		return "qna";
	}
}
