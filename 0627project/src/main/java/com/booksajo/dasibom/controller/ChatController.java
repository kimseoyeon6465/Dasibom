package com.booksajo.dasibom.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.booksajo.dasibom.service.ChatService;
import com.booksajo.dasibom.vo.ChatMessageVO;



@Controller
public class ChatController {

    @Autowired
    private ChatService chatService;
    //update
    @GetMapping("/chat.do")
    public String chatPage(@RequestParam String id,
                           @RequestParam(required = false) String chatRoomId,
                           HttpSession session, Model model) {

        String userId = (String) session.getAttribute("user_Id");
        Integer userSeq = (Integer) session.getAttribute("user_seq");

        if (userId == null || userSeq == null) {
            model.addAttribute("loginRequired", true);
            return "chat";
        }

        if (chatRoomId == null || chatRoomId.trim().isEmpty()) {
            chatRoomId = chatService.createChatRoom(userId, id);
            return "redirect:/chat.do?id=" + id + "&chatRoomId=" + chatRoomId;
        }

        List<ChatMessageVO> messages = chatService.getChatHistory(userId, id);

        // ?üí? ?ó¨Í∏? Ï∂îÍ?: ?ãâ?Ñ§?ûÑ Ï°∞Ìöå?ï¥?Ñú Î™®Îç∏?óê ?ã¥Í∏?
        String partnerNickname = chatService.getNickname(id);

        model.addAttribute("id", id);
        model.addAttribute("partnerNickname", partnerNickname); // ?ãâ?Ñ§?ûÑ ?†Ñ?ã¨
        model.addAttribute("chatHistory", messages);
        model.addAttribute("chatRoomId", chatRoomId);

        return "chat";
    }

    
    @GetMapping("/chat_list.do")
    public String chatList(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            model.addAttribute("loginRequired", true);
            return "chat_list";
        }

        List<Map<String, Object>> chatList = chatService.getChatListByUserId(userId);

        // chatList Í∞? ?öî?Üå?óê ?ÉÅ?? ?ãâ?Ñ§?ûÑ Ï∂îÍ?
        for (Map<String, Object> chat : chatList) {
            String otherUserId = (String) chat.get("OTHERUSERID");
            String otherUserNickname = chatService.getNickname(otherUserId);
            chat.put("OTHERNICKNAME", otherUserNickname);
        }

        model.addAttribute("chatList", chatList);
        return "chat_list";
    }
    //!!!!!!!!!!!!!!!!!!!
}
