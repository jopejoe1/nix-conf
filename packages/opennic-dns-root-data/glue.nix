{ lib }:

with lib.combinators;

{
  SOA = {
    nameServer = "ns0";
    adminEmail = "shdwdrgn@sourpuss.net";
    serial = 2019030800;
  };

  NS = [
    "ns0.opennic.glue."
  ];

  subdomains = {
    "ns0.opennic".A = [ "195.201.99.61" "168.119.153.26" ];
  };
}

