package com.booksajo.dasibom.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.booksajo.dasibom.service.CommentService;
import com.booksajo.dasibom.vo.CommentVO;


@Controller
public class QnaCommentController {

	@Resource(name = "CommentService")
	private CommentService commentService;

	// QnA 댓글 작성 (일반 댓글 / 대댓글 구분)
	@RequestMapping("/writeQnaComment.do")
	public String writeQnaComment(@ModelAttribute CommentVO commentVO, RedirectAttributes redirectAttributes) {
		if (commentVO.getParent_comment_id() == 0) {
			commentService.writeComment(commentVO); // 일반 댓글
		} else {
			commentService.writeReplyComment(commentVO); // 대댓글
		}
		redirectAttributes.addAttribute("post_id", commentVO.getPost_id());
		return "redirect:/showDetailQna.do";
	}

	// QnA 댓글 삭제
	@RequestMapping("/deleteQnaComment.do")
	public String deleteQnaComment(@RequestParam int comment_id, @RequestParam int post_id,
			RedirectAttributes redirectAttributes) {
		try {
			boolean deleted = commentService.deleteComment(comment_id);
			if (deleted) {
				redirectAttributes.addFlashAttribute("message", "댓글을 삭제했습니다.");
			} else {
				redirectAttributes.addFlashAttribute("message", "댓글 삭제에 실패했습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("message", "시스템 오류가 발생했습니다.");
		}
		redirectAttributes.addAttribute("post_id", post_id);
		return "redirect:/showDetailQna.do";
	}

	// QnA 댓글 수정
	@RequestMapping("/updateQnaComment.do")
	public String updateQnaComment(@RequestParam int comment_id, @RequestParam int post_id,
			@RequestParam("edited_content") String editedContent, RedirectAttributes redirectAttributes) {

		String normalizedContent = editedContent.replace("\r\n", "\n");

		CommentVO comment = new CommentVO();
		comment.setComment_id(comment_id);
		comment.setComment_contents(normalizedContent);

		commentService.updateComment(comment);

		redirectAttributes.addAttribute("post_id", post_id);
		return "redirect:/showDetailQna.do";
	}
}