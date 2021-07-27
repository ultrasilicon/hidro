
use std::collections::hash_map::HashMap;


pub struct Pos {
    x: f32,
    y: f32,
    z: f32
}

pub struct Itinerary {
    zeros: HashMap<String, Pos>,
    cur_zero: String,
    stops: HashMap<String, Pos>,
    cur_stop: String,
}

pub trait Trip {
    fn next(&self);
    fn accident(&self);
    fn exit(&self);
}
