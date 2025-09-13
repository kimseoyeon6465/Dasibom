package com.booksajo.dasibom.service;

import java.util.List;
import java.util.Map;

import com.booksajo.dasibom.vo.ChatMessageVO;



public interface ChatService {
    void saveMessage(ChatMessageVO msg);
    List<ChatMessageVO> getChatHistory(String user1, String user2);
    String createChatRoom(String user1, String user2);
	List<Map<String, Object>> getChatListByUserId(String userId);
	String getNickname(String name);
}