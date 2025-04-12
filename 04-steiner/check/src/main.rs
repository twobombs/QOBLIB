use clap::Parser;
use std::collections::{HashMap, HashSet};
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::PathBuf;

/// Command-line interface definition
#[derive(Parser, Debug)]
#[command(author, version, about)]
struct Cli {
    /// Path to the arcs file (undirected edges)
    #[arg(short, long)]
    arcs: PathBuf,

    /// Path to the terms file
    #[arg(short, long)]
    terms: PathBuf,

    /// Path to the solutions file
    #[arg(short, long)]
    sol: PathBuf,
}

fn main() -> Result<(), String> {
    let cli = Cli::parse();

    // 1. Read input data

    // 1a. Read arcs (edges)
    // arcs_file lines: head_idx tail_idx weight
    //   with possible '#' comments or empty lines
    let arcs_map = read_arcs(&cli.arcs).map_err(|e| format!("Error reading arcs file: {}", e))?;

    // 1b. Read terminals (terms)
    // terms_file lines: node_idx network_id
    //   with possible '#' comments or empty lines
    let network_terminals =
        read_terminals(&cli.terms).map_err(|e| format!("Error reading terminals file: {}", e))?;

    // 1c. Read solutions (the selected edges for each network)
    // solutions_file lines: head_idx tail_idx network_id
    //   with possible '#' comments or empty lines
    let solution_edges = read_solutions(&cli.sol, &arcs_map)
        .map_err(|e| format!("Error reading solution file: {}", e))?;

    // 2. Check connectivity + terminals

    // We'll gather, for each network, the set of edges chosen and then check:
    //   a) all terminals for that network are present in the subgraph
    //   b) the subgraph is connected among those terminals
    // Also track all nodes used by each network, to check node-disjointness later.

    let mut network_nodes_used: HashMap<usize, HashSet<usize>> = HashMap::new();

    for (network_id, edges) in &solution_edges {
        // Build adjacency for the subgraph of this network
        let mut adj: HashMap<usize, Vec<usize>> = HashMap::new();
        let mut nodes_in_subgraph: HashSet<usize> = HashSet::new();

        for &(u, v) in edges {
            adj.entry(u).or_default().push(v);
            adj.entry(v).or_default().push(u);
            nodes_in_subgraph.insert(u);
            nodes_in_subgraph.insert(v);
        }

        // The set of nodes used in the subgraph for the current network
        // let nodes_in_subgraph: HashSet<usize> = adj
        //     .keys()
        //     .cloned()
        //     .chain(adj.values().flatten().cloned())
        //     .collect();

        // Check that all terminals for this network are contained
        let terminals = network_terminals
            .get(network_id)
            .expect("Network has no terminals");

        for term_node in terminals {
            if !nodes_in_subgraph.contains(&term_node) {
                return Err(format!(
                    "Terminal node {} of network {} not present in its subgraph.",
                    term_node, network_id
                ));
            }
        }

        // Check connectivity
        let first_term = terminals[0];
        // BFS/DFS from `first_term` to see which terminals are reachable
        let reachable = bfs(&adj, first_term);

        // Ensure all terminals are reachable from the first terminal
        for &term_node in terminals {
            if !reachable.contains(&term_node) {
                return Err(format!(
                    "Terminal node {} of network {} is not connected to the other terminals.",
                    term_node, network_id
                ));
            }
        }

        // Record the nodes used by this network for the node-disjointness check
        network_nodes_used.insert(*network_id, nodes_in_subgraph);
    }

    // 3. Check node-disjointness
    let network_ids: Vec<usize> = network_nodes_used.keys().cloned().collect();

    for i in 0..network_ids.len() {
        for j in i + 1..network_ids.len() {
            let net_a = network_ids[i];
            let net_b = network_ids[j];

            let set_a = &network_nodes_used[&net_a];
            let set_b = &network_nodes_used[&net_b];

            if !set_a.is_disjoint(set_b) {
                return Err(format!(
                    "Networks {} and {} share at least one node, violating node-disjointness.",
                    net_a, net_b
                ));
            }
        }
    }

    // 4. Compute Steiner tree costs
    // For each network, sum the weights of the edges in the solution
    let mut total_cost = 0;
    for (_, edges) in &solution_edges {
        let cost: usize = edges
            .iter()
            .map(|&(u, v)| arcs_map[&(u.min(v), u.max(v))])
            .sum();
        total_cost += cost;
    }

    println!("Total Cost {}", total_cost);

    println!(
        "Successful: All Steiner trees are valid, connected, contain their terminals, and are node-disjoint!"
    );
    Ok(())
}

/// Read arcs from file, storing them in a map for easy existence checks.
/// Each line has "head tail weight", ignoring lines starting with '#' or empty lines.
/// We store (head, tail) -> weight, with (u < v) so it's undirected.
fn read_arcs(path: &PathBuf) -> Result<HashMap<(usize, usize), usize>, String> {
    let file = File::open(path).map_err(|e| e.to_string())?;
    let reader = BufReader::new(file);

    let mut arcs_map = HashMap::new();
    for (line_idx, line_result) in reader.lines().enumerate() {
        let line = line_result.map_err(|e| e.to_string())?;
        let trimmed = line.trim();

        if trimmed.is_empty() || trimmed.starts_with('#') {
            // Ignore comments or empty lines
            continue;
        }

        let parts: Vec<&str> = trimmed.split_whitespace().collect();

        if parts.len() < 3 {
            return Err(format!(
                "Arcs file line {} malformed: '{}'",
                line_idx + 1,
                line
            ));
        }

        let head = parts[0].parse::<usize>().map_err(|e| e.to_string())?;
        let tail = parts[1].parse::<usize>().map_err(|e| e.to_string())?;
        let weight = parts[2].parse::<usize>().map_err(|e| e.to_string())?;

        let (min_node, max_node) = if head < tail {
            (head, tail)
        } else {
            (tail, head)
        };

        arcs_map.insert((min_node, max_node), weight);
    }

    Ok(arcs_map)
}

/// Read terminals from file, ignoring '#' comments and empty lines.
/// Each valid line: "node_idx network_id"
/// Returns a mapping: network_id -> Vec<node_idx>
fn read_terminals(path: &PathBuf) -> Result<HashMap<usize, Vec<usize>>, String> {
    let file = File::open(path).map_err(|e| e.to_string())?;
    let reader = BufReader::new(file);

    let mut network_terminals: HashMap<usize, Vec<usize>> = HashMap::new();

    for (line_idx, line_result) in reader.lines().enumerate() {
        let line = line_result.map_err(|e| e.to_string())?;
        let trimmed = line.trim();

        if trimmed.is_empty() || trimmed.starts_with('#') {
            // Ignore comments or empty lines
            continue;
        }

        let parts: Vec<&str> = trimmed.split_whitespace().collect();

        if parts.len() < 2 {
            return Err(format!(
                "Terms file line {} malformed: '{}'",
                line_idx + 1,
                line
            ));
        }

        let node = parts[0].parse::<usize>().map_err(|e| e.to_string())?;
        let network = parts[1].parse::<usize>().map_err(|e| e.to_string())?;

        network_terminals.entry(network).or_default().push(node);
    }
    Ok(network_terminals)
}

/// Read the solution edges from file, ignoring '#' comments and empty lines.
/// Each valid line: "head tail network".
/// For each solution line, ensure the edge exists in arcs_map.
/// We store them in a map: network -> Vec<(head, tail)> (undirected).
fn read_solutions(
    path: &PathBuf,
    arcs_map: &HashMap<(usize, usize), usize>,
) -> Result<HashMap<usize, Vec<(usize, usize)>>, String> {
    let file = File::open(path).map_err(|e| e.to_string())?;
    let reader = BufReader::new(file);

    let mut solution: HashMap<usize, Vec<(usize, usize)>> = HashMap::new();
    for (line_idx, line_result) in reader.lines().enumerate() {
        let line = line_result.map_err(|e| e.to_string())?;
        let trimmed = line.trim();

        if trimmed.is_empty() || trimmed.starts_with('#') {
            // Ignore comments or empty lines
            continue;
        }

        let parts: Vec<&str> = trimmed.split_whitespace().collect();

        if parts.len() < 3 {
            return Err(format!(
                "Solutions file line {} malformed: '{}'",
                line_idx + 1,
                line
            ));
        }

        let head = parts[0].parse::<usize>().map_err(|e| e.to_string())?;
        let tail = parts[1].parse::<usize>().map_err(|e| e.to_string())?;
        let network = parts[2].parse::<usize>().map_err(|e| e.to_string())?;

        let (min_node, max_node) = if head < tail {
            (head, tail)
        } else {
            (tail, head)
        };

        // Check that this edge actually exists in the arcs map
        if !arcs_map.contains_key(&(min_node, max_node)) {
            return Err(format!(
                "Solutions file line {} references edge ({}, {}) not in arcs.",
                line_idx + 1,
                head,
                tail
            ));
        }

        solution.entry(network).or_default().push((head, tail));
    }
    Ok(solution)
}

/// Simple BFS to find reachable nodes from `start` in the adjacency list `adj`.
fn bfs(adj: &HashMap<usize, Vec<usize>>, start: usize) -> HashSet<usize> {
    let mut visited = HashSet::new();
    let mut queue = vec![start];
    visited.insert(start);

    while let Some(u) = queue.pop() {
        if let Some(neighbors) = adj.get(&u) {
            for &v in neighbors {
                if visited.insert(v) {
                    queue.push(v);
                }
            }
        }
    }
    visited
}
