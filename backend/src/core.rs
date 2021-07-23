
use std::collections::hash_map::HashMap;

#[derive(Debug)]
pub enum CoreEvent {
    XAxisMoved(f32),
    YAxisMoved(f32),
    ZAxisMoved(f32),
}


struct Hidro {
    pos: Pos,
    zero: Pos,
    trips: HashMap<String, Box<dyn Trip>>
}