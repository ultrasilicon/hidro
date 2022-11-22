use crate::core::CoreEvent;

use tungstenite::accept;

use std::net::TcpListener;
use std::sync::mpsc;
use std::thread::spawn;

struct Server {
    ip: String,
    port: i32,
    event_rx: mpsc::Receiver<CoreEvent>,
}

impl Server {
    pub fn new(ip: String, port: i32, rx: mpsc::Receiver<CoreEvent>) -> Server {
        return Server {
            ip: ip,
            port: port,
            event_rx: rx,
        };
    }

    pub fn start() {
        let server = TcpListener::bind("127.0.0.1:9001").unwrap();
        for stream in server.incoming() {
            spawn(move || {
                let mut websocket = accept(stream.unwrap()).unwrap();
                loop {
                    let msg = websocket.read_message().unwrap();

                    // We do not want to send back ping/pong messages.
                    if msg.is_binary() || msg.is_text() {
                        websocket.write_message(msg).unwrap();
                    }
                }
            });
        }
    }
}
