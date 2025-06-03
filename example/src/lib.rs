use rand::Rng;

pub fn coin_flip<R: Rng>(rng: &mut R) -> &'static str {
    if rng.random_bool(0.5) {
        "heads"
    } else {
        "tails"
    }
}

pub fn roll_die<R: Rng>(rng: &mut R) -> u8 {
    rng.random_range(1..=10)
}
