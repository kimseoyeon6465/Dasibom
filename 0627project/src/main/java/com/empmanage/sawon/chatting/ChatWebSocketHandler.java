package com.empmanage.sawon.chatting;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.booksajo.dasibom.service.ChatService;
import com.booksajo.dasibom.vo.ChatMessageVO;

//update
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private final Map<String, WebSocketSession> userSessions = new ConcurrentHashMap<>();

    @Autowired
    private ChatService chatService;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String query = session.getUri().getQuery(); // userId=user01&targetId=user02&chatRoomId=1
        String[] parts = query.split("&");
        String userId = null;
        String chatRoomId = null;

        for (String part : parts) {
            String[] keyValue = part.split("=");
            if (keyValue[0].equals("userId")) {
                userId = keyValue[1];
            } else if (keyValue[0].equals("chatRoomId")) {
                chatRoomId = keyValue[1];
            }
        }

        session.getAttributes().put("userId", userId);
        session.getAttributes().put("chatRoomId", chatRoomId); // �씠 以� 異붽�!
        userSessions.put(userId, session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String sender_Id = (String) session.getAttributes().get("userId");
        String chat_room_Id = (String) session.getAttributes().get("chatRoomId");
        String payload = message.getPayload(); // "receiverId:messageContent"
        String[] parts = payload.split(":", 2);
        String receiver_Id = parts[0];
        String content = parts[1];

        
        // DB ���옣
        ChatMessageVO msg = new ChatMessageVO();
        msg.setSender_id(sender_Id);
        msg.setReceiver_id(receiver_Id);
        msg.setMessage(content);
        msg.setChat_room_id(chat_room_Id);
        chatService.saveMessage(msg);

        // 諛쒖떊�옄�뿉寃�
        session.sendMessage(new TextMessage("ME:" + content));

        // �닔�떊�옄�뿉寃�
        WebSocketSession targetSession = userSessions.get(receiver_Id);
        if (targetSession != null && targetSession.isOpen()) {
            targetSession.sendMessage(new TextMessage("OTHER:" + content));
        }
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}
