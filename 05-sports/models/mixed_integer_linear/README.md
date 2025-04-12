# Mixed Integer Programming Formulation

There are different ways to model and solve the double round-robin tournament given above.
In this repository, we include exemplary [MIP models](/05-sports/exemplary-models/mixed_integer_linear) of the given [instances](/05-sports/instances) in `lp` format (.lp.gz) as well as in `zimpl` format (.tbl.gz).
The MIPs follow the modeling as given in [this paper](/05-sports/info/MILP_Try_Repeat.pdf) and were created from the .xml based [instances](/05-sports/instances) using this [converter](/05-sports/misc/convert_xml2lp.sh).

To generate the LP and MPS files, run \`gen_archive.sh\` on a Linux machine.
