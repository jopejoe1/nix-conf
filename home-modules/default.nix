# SPDX-FileCopyrightText: 2026 Jo Jöns <jopejoe1@missing.ninja>
#
# SPDX-License-Identifier: MIT

{ ... }:

{
  imports = [
    ./common
    ./direnv
    ./firefox
    ./git
    ./gpg
    ./nushell
    ./sway
    ./users
    ./niri
    ./jj
    ./helix
  ];
}
