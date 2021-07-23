
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

use backend::serial::SerialParser;
use backend::serial::SerialEvent;



fn main() {
    let (tx, rx) : (mpsc::Sender<SerialEvent>, mpsc::Receiver<SerialEvent>) = mpsc::channel();

    thread::spawn(move || {
        let mut parser = SerialParser::new(tx);
        parser.start("/dev/cu.SLAB_USBtoUART", 9600, Duration::from_millis(100));
    });

    for received in rx {
        println!("Got: {:?}", received);
    }
}
