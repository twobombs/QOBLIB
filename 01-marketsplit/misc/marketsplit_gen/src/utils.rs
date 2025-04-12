use rand::{distributions::Uniform, prelude::Distribution, rngs::StdRng, seq::SliceRandom};

/// Compute the slack (RHS - sum of selected entries) for a given row.
/// The sum of selected entries is where the corresponding position in `solution` is `true`.
pub fn compute_slack(row: &[i32], solution: &[bool], rhs: i32) -> i32 {
    let sum = row
        .iter()
        .zip(solution.iter())
        .map(|(a, b)| if *b { *a } else { 0 })
        .sum::<i32>();
    rhs - sum
}

pub fn check_range(row: &[i32], low: i32, high: i32) -> bool {
    row.iter().all(|&value| value >= low && value <= high)
}

/// Generate a random binary vector of size `size`.
/// Approximately half of its entries are 1, half are 0 (with a small +/- offset).
pub fn random_bin_vector(size: usize, rng: &mut StdRng) -> Vec<bool> {
    let range = Uniform::new_inclusive(0, 4);

    // Randomly pick how many 1's we want, around half of `size`
    let num_ones = (size / 2) + range.sample(rng) - 2;
    let num_zeros = size - num_ones;

    // Fill the vector with `true` for 1's, `false` for 0's
    let mut binary_vector = vec![true; num_ones];
    binary_vector.extend(vec![false; num_zeros]);

    // Shuffle to get random distribution of 1's and 0's
    binary_vector.shuffle(rng);

    binary_vector
}
