{ dns }:

with dns.lib.combinators;

{
  SOA = {
    nameServer = "ns2";
    adminEmail = "shdwdrgn@sourpuss.net";
    serial = 2019030800;
  };

  NS = [
    "ns2.opennic.glue."
  ];
}
