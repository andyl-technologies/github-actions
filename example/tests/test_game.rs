use andyl_action_example::{coin_flip, roll_die};
use rand::{SeedableRng, rngs::StdRng};

#[test]
fn test_coin_flip() {
    let mut rng = StdRng::seed_from_u64(42);
    assert_eq!(coin_flip(&mut rng), "tails");
}

#[test]
fn test_roll_die_range() {
    let mut rng = StdRng::seed_from_u64(42);

    let first = roll_die(&mut rng);
    let second = roll_die(&mut rng);

    assert_eq!(first, 2);
    assert_eq!(second, 6);
}
