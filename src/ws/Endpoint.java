package ws;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/ws")
public class Endpoint {
	private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<Session>());

		public static void sendRefresh() {
			for (Session s :  sessions) {
				try {
					s.getBasicRemote().sendText("{\"action\": \"refresh\"}");
				} catch (IOException e) { /* logging */ }
			}
		}

		public Endpoint() { }

		@OnOpen
		public void open(Session session) {
			sessions.add(session);
		}

		@OnError
		public void error(Throwable e) {

		}

		@OnClose
		public void close(Session session) {
			sessions.remove(session);
		}


}
