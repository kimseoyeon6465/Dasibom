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
import com.booksajo.dasibom.service.EventService;
import com.booksajo.dasibom.service.PostService;
import com.booksajo.dasibom.service.UserService;
import com.booksajo.dasibom.vo.EventVO;
import com.booksajo.dasibom.vo.PostsVO;
import com.booksajo.dasibom.vo.UserVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class EventController {
	
	@Resource(name = "eventService")
	private EventService eventService;
	
		// �씠踰ㅽ듃 紐⑸줉 �럹�씠吏�
	    @RequestMapping("/event_list.do")
	    public String eventList(Model model) {
	        
	        ArrayList<EventVO> eventList = eventService.getAllEvent();
	        model.addAttribute("eventList", eventList);
	
	        return "event_list";   // �넂 goods_list.jsp 濡� �씠�룞
	    }
		
	 // �씠踰ㅽ듃 �긽�꽭 �럹�씠吏�
	    @RequestMapping("/event_detail.do")
	    public String eventDetail(EventVO eventVO, Model model) {
	    	EventVO oneevent = eventService.getOneevent(eventVO);
	        if (oneevent == null) {
	            return "redirect:/MainPage.do";
	        }
	        model.addAttribute("event", oneevent);
	        return "event_detail";   // �넂 goods_detail.jsp 濡� �씠�룞
	    }
	    @Resource(name = "postService")
		private PostService postService;

		@Resource(name = "CommentService")
		private CommentService commentService;

		@Resource(name = "UserService")
		private UserService userService;

		@RequestMapping("/goEvent.do")
		public String goEvent(@RequestParam(value = "spage", required = false, defaultValue = "1") int spage, Model model,
				HttpSession session) {

			UserVO loginUser = (UserVO) session.getAttribute("loginUser");
			int isAdmin = 0;
			if (loginUser != null) {
				isAdmin = loginUser.getIsAdmin();
			}

			int postsPerPage = 10;

			// 이벤트 카테고리 게시글 수만 계산
			int totalEventCount = postService.getPostCountByCategory("이벤트");
			int totalPages = (int) Math.ceil((double) totalEventCount / postsPerPage);

			if (spage < 1)
				spage = 1;
			else if (spage > totalPages && totalPages != 0)
				spage = totalPages;

			int startRow = (spage - 1) * postsPerPage;

			// 이벤트 게시글만 페이징해서 가져오기
			ArrayList<PostsVO> eventPosts = postService.getPostsByCategoryPaged("이벤트", startRow, postsPerPage);

			// 댓글 수, 이미지 여부 세팅
			for (PostsVO post : eventPosts) {
				int commentCount = postService.getCommentCountForPost(post.getPost_id());
				post.setCommentCount(commentCount);
				post.setHasImageInContent(post.getPost_contents() != null && post.getPost_contents().contains("<img"));
			}

			model.addAttribute("eventPosts", eventPosts);
			model.addAttribute("currentPage", spage);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("isAdmin", isAdmin);

			return "event";
		}

		@RequestMapping(value = "/showDetailEvent.do")
		public String showDetailEvent(@RequestParam("post_id") Integer postId, Model model, HttpSession session)
				throws Exception {
			PostsVO post = postService.getContent(postId);
			model.addAttribute("post", post);

			Integer userSeq = (Integer) session.getAttribute("user_seq");

			if (userSeq != null) {
				UserVO user = userService.getUserBySeq(userSeq);
				model.addAttribute("user", user);
			}

			return "showDetailEvent";
		}

		@RequestMapping(value = "/goWriteEvent.do")
		public String goWritePost(@RequestParam(value = "post_id", required = false) Integer postId, Model model,
				HttpSession session) {

			Integer userSeq = (Integer) session.getAttribute("user_seq");
			UserVO user = userService.getUserBySeq(userSeq);
			model.addAttribute("user", user);

			if (postId != null) {
				PostsVO post = postService.getContent(postId);
				model.addAttribute("post", post);
			}
			return "goWriteEvent";
		}

		@RequestMapping(value = "/insertEvent.do")
		public String insertEvent(@RequestParam("category") String category, @RequestParam("title") String title,
				@RequestParam("user_id") String userId, @RequestParam("content") String content,
				@RequestParam("image_path") String imagePath, RedirectAttributes redirectAttributes, Model model) {

			PostsVO post = new PostsVO(); // VO, 서비스는 기존 그대로 유지
			post.setCategory(category);
			post.setTitle(title);
			post.setUser_id(userId);
			post.setPost_contents(content);
			post.setImage_path(imagePath);

			model.addAttribute("post", post);

			if (category == null || category.trim().isEmpty()) {
				model.addAttribute("message", "말머리를 선택해주세요");
				return "/common/alertBack";
			}
			if (title == null || title.trim().isEmpty()) {
				model.addAttribute("message", "제목을 입력해주세요");
				return "/common/alertBack";
			}
			if (userId == null || userId.trim().isEmpty()) {
				model.addAttribute("message", "작성자 성명을 입력해주세요");
				return "/common/alertBack";
			}
			if (content == null || content.trim().isEmpty()) {
				model.addAttribute("message", "내용을 입력해주세요");
				return "/common/alertBack";
			}

			boolean isSuccess = postService.insertPost(category, title, content, userId, imagePath);

			if (isSuccess) {
				redirectAttributes.addFlashAttribute("message", "이벤트 작성을 완료했습니다");
				return "redirect:/goEvent.do"; // URL만 이벤트용으로 변경
			} else {
				model.addAttribute("message", "이벤트 작성에 실패했습니다");
				return "/common/alertBack";
			}
		}

		@RequestMapping(value = "/updateEvent.do")
		public String updateEvent(@RequestParam("post_id") int postId, @RequestParam("category") String category,
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
				model.addAttribute("message", "제목을 입력해주세요");
				return "/common/alertBack";
			}
			if (content == null || content.trim().isEmpty()) {
				model.addAttribute("message", "내용을 입력해주세요");
				return "/common/alertBack";
			}

			boolean isSuccess = postService.updatePost(postId, category, title, content, userId, imagePath);

			if (isSuccess) {
				redirectAttributes.addFlashAttribute("message", "이벤트 수정을 완료했습니다");
				return "redirect:/showDetailEvent.do?post_id=" + postId;
			} else {
				model.addAttribute("message", "이벤트 수정에 실패했습니다");
				return "/common/alertBack";
			}
		}

		@RequestMapping(value = "/deleteEvent.do")
		public String deleteEvent(@RequestParam("post_id") int postId, RedirectAttributes redirectAttributes, Model model) {
			try {
				boolean isDeleted = postService.deletePost(postId);

				if (isDeleted) {
					redirectAttributes.addFlashAttribute("message", "이벤트를 삭제했습니다");
					return "redirect:/goEvent.do";
				} else {
					model.addAttribute("message", "이벤트 삭제에 실패했습니다");
					return "/common/alertBack";
				}
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("message", "시스템 오류가 발생했습니다");
				return "/common/alertBack";
			}
		}

		@RequestMapping(value = "/searchEvent.do", method = RequestMethod.GET)
		public String searchPost(@RequestParam("keyword") String keyword,
				@RequestParam(value = "spage", required = false, defaultValue = "1") int spage, Model model) {

			// 검색어가 없으면 goPost로 리다이렉트
			if (keyword == null || keyword.trim().isEmpty()) {
				return "redirect:/goEvent.do?spage=" + spage;
			}

			int pageSize = 10;
			int startIndex = (spage - 1) * pageSize;

			int searchCount = postService.getSearchPostCount("%" + keyword + "%");

			ArrayList<PostsVO> searchResults = postService.searchPostsByKeywordPaged(keyword, startIndex, pageSize);

			int totalPages = (int) Math.ceil((double) searchCount / pageSize);

			model.addAttribute("eventPosts", searchResults);
			model.addAttribute("currentPage", spage);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("keyword", keyword);

			return "event";
		}
	    
	    
	}


