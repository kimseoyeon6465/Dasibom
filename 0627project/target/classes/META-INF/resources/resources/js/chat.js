/**
 * 
 */
let ws;

//update
function connect() {
    const userId = document.getElementById("userId").value;
    const sellerId = document.getElementById("id").value;
    const chatRoomId = document.getElementById("chatRoomId").value;
    
    window.open(
        `chat.do?id=${encodeURIComponent(sellerId)}`,  // sellerId 변수 값으로 전달
        'chatPopup',
        'width=600,height=700,scrollbars=yes,resizable=yes'
    );

    ws = new WebSocket("ws://" + location.host + contextPath + 
        `/chat-socket?userId=${encodeURIComponent(userId)}&targetId=${encodeURIComponent(sellerId)}&chatRoomId=${encodeURIComponent(chatRoomId)}`);

    ws.onmessage = function(event) {
        const raw = event.data;
        if (raw.startsWith("ME:")) {
            appendMessage(raw.substring(3), "me");
        } else if (raw.startsWith("OTHER:")) {
            appendMessage(raw.substring(6), "other");
        }
    };
}

function sendMessage() {
    const msgInput = document.getElementById("msgInput");
    const msg = msgInput.value.trim();
    if (!msg) return;
    
    const targetId = document.getElementById("id").value;
    ws.send(targetId + ":" + msg);
    msgInput.value = "";
}
// --------------------------------------------------------------

let lastMessageTime = null;
let lastMessageSender = null;

function formatToHourMinute(date) {
  return date.getHours().toString().padStart(2, '0') + ":" + date.getMinutes().toString().padStart(2, '0');
}

function appendMessage(msg, sender) {
  const chatBox = document.getElementById("chatBox");
  const now = new Date();
  const nowHM = formatToHourMinute(now); // 현재 시:분만 추출

  const messageDiv = document.createElement("div");
  messageDiv.className = "message " + (sender === "me" ? "me" : "other");
  messageDiv.textContent = msg;
  chatBox.appendChild(messageDiv);

  let showTime = false;
  let removePrevTime = false;

  if (!lastMessageTime || !lastMessageSender) {
    showTime = true; // 첫 메시지
  } else {
    const lastHM = formatToHourMinute(lastMessageTime);

    if (sender === lastMessageSender) {
      if (lastHM !== nowHM) {
        // 시:분이 달라졌으면 1분 이상 경과
        showTime = true; // 기존 시간 유지
      } else {
        // 시:분 같으면 1분 이내 → 기존 시간 삭제 후 새 시간 표시
        showTime = true;
        removePrevTime = true;
      }
    } else {
      // 보낸 사람 바뀜
      showTime = true;
    }
  }

  if (showTime) {
    if (removePrevTime) {
      const times = chatBox.querySelectorAll(".time-stamp." + sender);
      if (times.length > 0) {
        times[times.length - 1].remove();
      }
    }

    const timeDiv = document.createElement("div");
    timeDiv.className = "time-stamp " + (sender === "me" ? "me" : "other");
    timeDiv.textContent = now.toLocaleTimeString('ko-KR', {
      hour: '2-digit',
      minute: '2-digit'
    });
    chatBox.appendChild(timeDiv);
  }

  lastMessageTime = now;
  lastMessageSender = sender;

  chatBox.scrollTop = chatBox.scrollHeight;
}

window.onload = connect;