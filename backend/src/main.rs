extern crate serialport;

use std::sync::mpsc;
use std::thread;
use std::time::Duration;

// serial
use std::io::prelude::*;



fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let mut port = serialport::new("/dev/cu.usbmodem14101", 9600)
            .timeout(Duration::from_millis(100))
            .open()
            .expect("Failed to open port");


        println!("reading bytes");
        loop {
            let mut buf: Vec<u8> = vec![0; 32];
            port.read(buf.as_mut_slice()).expect("Found no data!");
            tx.send(String::from_utf8(buf).unwrap()).unwrap();
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }
}
