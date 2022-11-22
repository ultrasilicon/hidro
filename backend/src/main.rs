use clap::Parser;

use std::sync::mpsc;
use std::time::Duration;

use hydrod::serial::Serial;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Path to the serial device
    #[arg(short, long)]
    device: String,

    /// Baud rate
    #[arg(short, long, default_value_t = 9600)]
    baud: u32,

    /// Serial timeout in millisecond
    #[arg(short, long, default_value_t = 100)]
    timeout: u64,
}


// Example: target/debug/hydrod -d /dev/ttyACM0
fn main() {
    let args = Args::parse();

    let (serial_tx, serial_rx) = mpsc::channel();

    Serial::start(
        args.device,
        args.baud,
        Duration::from_millis(args.timeout),
        serial_tx
    );

    for event in serial_rx {
        println!("Got: {:?}", event);
    }
}
