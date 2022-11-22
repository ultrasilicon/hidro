extern crate serialport;

use std::{str, thread};
use std::sync::mpsc;
use std::time::Duration;

#[derive(Debug)]
pub enum SerialEvent {
    XAxisMoved(f32),
    YAxisMoved(f32),
    ZAxisMoved(f32),
}

pub struct SerialParser {
    tx: mpsc::Sender<SerialEvent>,
    buf: String,
    x_prev: f32,
    y_prev: f32,
    z_prev: f32,
}

pub struct Serial {
}

impl Serial {
    pub fn start(path: String, baud: u32, timeout: Duration, tx: mpsc::Sender<SerialEvent>) {
        thread::spawn(move || {
            let mut parser = SerialParser::new(tx);
            parser.start(path, baud, timeout);
        });        
    }
}

impl SerialParser {
    pub fn new(tx: mpsc::Sender<SerialEvent>) -> Self {
        SerialParser {
            tx: tx,
            buf: String::with_capacity(32),
            x_prev: 0.0,
            y_prev: 0.0,
            z_prev: 0.0,
        }
    }

    fn read(port: &mut Box<dyn serialport::SerialPort>) -> String {
        let mut buf: Vec<u8> = vec![0; 32];
        port.read(buf.as_mut_slice()).expect("Found no data!");
        return String::from_utf8(buf).unwrap();
    }

    /// Begin open, read, align, parse 
    pub fn start(&mut self, path: String, baud: u32, timeout: Duration) {
        let mut port = serialport::new(path, baud)
            .timeout(timeout)
            .open()
            .expect("Failed to open port");

        println!("reading bytes");

        self.align(&mut port);
        
        loop {
            self.parse(&mut port);
        }
    }

    /// Align buffer by discarding the first line
    fn align(&mut self, port: &mut Box<dyn serialport::SerialPort>) {
        loop {
            let raw = SerialParser::read(port);
            match raw.rfind('\n') {
                Some(pos) => {
                    self.buf = raw[pos + 1..raw.len()].to_string();
                    break;
                }
                None => {}
            }
        }
    }

    /// Parses aligned serial stream and send axis updates via channel
    fn parse(&mut self, port: &mut Box<dyn serialport::SerialPort>) {
        loop {
            let raw = SerialParser::read(port);
            self.buf += raw.as_str();
            match self.buf.find('\n') {
                Some(pos) => {
                    let line: String = self.buf[..pos].to_string().replace("\u{0}", "");
                    let split: Vec<&str> = line.split_whitespace().collect();
                    match split[..] {
                        [x, y, z] => {
                            // println!("x: {}, y: {}, z: {}", x,y,z);
                            let x_val: f32 = x.parse().unwrap();
                            // send axis updates only when they change
                            if self.x_prev != x_val {
                                self.x_prev = x_val;
                                self.tx.send(SerialEvent::XAxisMoved(x_val)).unwrap();
                            }
                            let y_val: f32 = y.parse().unwrap();
                            if self.y_prev != y_val {
                                self.y_prev = y_val;
                                self.tx.send(SerialEvent::YAxisMoved(y_val)).unwrap();
                            }
                            let z_val: f32 = z.parse().unwrap();
                            if self.z_prev != z_val {
                                self.z_prev = z_val;
                                self.tx.send(SerialEvent::ZAxisMoved(z_val)).unwrap();
                            }
                            self.buf.replace_range(..pos + 1, "");
                        }
                        _ => self.align(port),
                    }
                }
                None => {}
            }
        }
    }
}
