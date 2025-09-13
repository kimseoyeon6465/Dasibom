package com.booksajo.dasibom.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.booksajo.dasibom.service.ChatService;
import com.booksajo.dasibom.service.dao.ChatMessageDAO;
import com.booksajo.dasibom.service.dao.ChatRoomDAO;
import com.booksajo.dasibom.service.dao.UserDAO;
import com.booksajo.dasibom.vo.ChatMessageVO;
import com.booksajo.dasibom.vo.ChatRoomVO;



@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	private UserDAO userDAO;

    @Autowired
    private ChatMessageDAO chatMessageDAO;
    
    @Autowired
    private ChatRoomDAO chatRoomDAO;

    @Override
    public void saveMessage(ChatMessageVO msg) {
    	chatMessageDAO.insertMessage(msg);
    }

    @Override
    public List<ChatMessageVO> getChatHistory(String user1, String user2) {
        return chatMessageDAO.getMessageBetween(user1, user2);
    }
    
    @Override
    public String createChatRoom(String user1Id, String user2Id) {
        ChatRoomVO existingRoom = chatRoomDAO.selectChatRoomByUsers(user1Id, user2Id);
        if (existingRoom != null) {
            return String.valueOf(existingRoom.getId());
        }

        ChatRoomVO newRoom = new ChatRoomVO();
        newRoom.setUser1_id(user1Id);
        newRoom.setUser2_id(user2Id);
        chatRoomDAO.insertChatRoom(newRoom);

        return String.valueOf(newRoom.getId());
    }

    @Override
    public List<Map<String, Object>> getChatListByUserId(String userId) {
        return chatRoomDAO.selectChatListByUserId(userId);
    }
    
    @Override
    public String getNickname(String name) {
        return userDAO.findNickname(name);
    }

}

