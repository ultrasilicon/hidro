// use std::collections::HashMap;
// use config::Config;

// use std::env;
use std::time::Duration;
// use const_format::formatcp;


// static CONFIG_PATH: str = home::home_dir()""
// static APP_NAME: &str = "hidro-backend";
// static APP_ENV_VAR_PREFIX: &str = "HIDRO";
// static HOME_DIR: &str = env!("HOME");
// static CONFIG_DIR: &str = formatcp!("{HOME_DIR}/.config/{APP_NAME}");
// static CONFIG_FILE: &str = formatcp!("{}/config.json", CONFIG_DIR);

pub const TIMEOUT: Duration = Duration::from_millis(100);
pub const BAUD_RATE: u32 = 9600;

// struct Settings {
//     settings: HashMap<String, String>,
// }

// impl Settings {
//     fn new() -> Self {
//         let config_map = Config::builder()
//             // Add in `./Settings.toml`
//             .add_source(config::File::with_name("examples/simple/Settings"))
//             // Add in settings from the environment (with a prefix of APP)
//             // Eg.. `APP_DEBUG=1 ./target/app` would set the `debug` key
//             .add_source(config::Environment::with_prefix("APP"))
//             .build()
//             .unwrap();

//         Settings(
//             settings: config_map,
//         )
//     }
// }
