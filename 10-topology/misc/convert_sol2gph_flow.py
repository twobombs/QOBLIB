from argparse import ArgumentParser
from pathlib import Path
import re
from typing import List, Tuple


def parse_flow_solution_file(filename: Path):
    edges = []
    nodes = set()
    diameter = None

    # parse every line: extract diameter, aspl, edge
    with open(filename, 'r') as file:
        lines = file.readlines()

        for line in lines:
            if line.startswith("diameter"):
                diameter = int(line.split()[1])
            elif match := re.match(r"^z#(\d+)#(\d+) 1$", line): # matches lines like "z#4#58 1"
                node1 = int(match.group(1))
                node2 = int(match.group(2))
                
                edges.append((node1, node2))
                nodes.add(node1)
                nodes.add(node2)  

    return edges, diameter, len(nodes)

def print_adj_list(out_file: Path, edges: List[Tuple[int, int]], diameter: int, num_nodes: int):
    with open(out_file, 'w') as file:
        # write information about the graph
        file.write(f"c Undirected Graph with Diameter {diameter}\n")
        file.write(f"p edge {num_nodes} {len(edges)}\n")
        
        # sort edges for prettier .gph files
        edges.sort()
        for edge in edges:
            # Nodes should be 1-indexed
            file.write(f"e {edge[0] + 1} {edge[1] + 1}\n")
    
if __name__ == "__main__":
    # read solution_file path from command line
    parser = ArgumentParser()
    parser.add_argument("-f", "--file", dest="filename",
                    help="File to convert", metavar="FILE", required=True)
    
    args = parser.parse_args()
    
    input_file = Path(args.filename)
    output_file = input_file.with_suffix('.gph')
    
    edges, diameter, num_nodes = parse_flow_solution_file(input_file)
    print_adj_list(output_file, edges, diameter, num_nodes)
    
    print(f"Written {input_file} in '.gph' format to {output_file}.")

