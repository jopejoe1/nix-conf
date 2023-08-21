{ ... }:

{
  imports = [
    ./home.nix
  ];

  users.users.root = {
    description = "root";
    initialPassword = "password";
  };
}

