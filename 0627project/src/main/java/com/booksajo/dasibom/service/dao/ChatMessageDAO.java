package com.booksajo.dasibom.service.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.booksajo.dasibom.vo.ChatMessageVO;
import com.booksajo.dasibom.vo.ChatRoomVO;



public interface ChatMessageDAO {
	void insertMessage(ChatMessageVO message);
    List<ChatMessageVO> getMessageBetween(@Param("user1") String user1, @Param("user2") String user2);
	void insertChatRoom(ChatRoomVO room);
}
