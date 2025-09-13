package com.booksajo.dasibom.service.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.booksajo.dasibom.vo.ChatRoomVO;



public interface ChatRoomDAO {
    void insertChatRoom(ChatRoomVO chatRoom);
    ChatRoomVO selectChatRoomByUsers(@Param("user1_id") String user1_id, @Param("user2_id") String user2_id);
    List<Map<String, Object>> selectChatListByUserId(String userId);
}
