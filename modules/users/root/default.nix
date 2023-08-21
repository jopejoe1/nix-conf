{ ... }:

{
  imports = [
    ./home.nix
  ];

  users.users.root = {
    initialPassword = "password";
  };
}

