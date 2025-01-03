let
  consts = import ../const.nix;
  inherit (consts.sshKeys.sylvie) godemiche tzuyu;
  # sylvie-godemiche = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIBy1b6An4WzmHWnsUS1OfF/6lYc8bAzEjuFzQ+zFLEMi1Yyr117+7gus8fHvC7bg85R77vB32JbriRClafxmqLXRrAI9LLKWeUoSi28R6SVMiO3R3bGTTyIRpUFqTYa0aNycqfQiUbQVC1IbxeFPc+z3RSaZelKbPQd1EVh0JvcZ2vNwW3ohyj6sAE8utmGvWn6zGRdKAiITswaK+KScpMiZVBDi18A0T5lHbc1yJGsEW6InT+DKvXc4fWe5J56O9+asqztxgx0tXWxeP2+LuryV43LlHlsZ/Iv/YtMbbYI8d9OJh8LByKabr0BCAFd6YS55EZbiRngVJefqjqetD5p7M1fX7kz+MefospLtle2iwu8wj+IXvxkw0c9DGz22iMqCxUSdMKzUvNk6tii2vDYHW8lyT7gGPm1YebQ/TxOlJJr8tHR9YIISWEW7JilBVeUVjI+UzaC4rWTAciUI1P0cM+va7OGY/KLZoK1GQ+89L78TLazHFNkEr3TCe5Jc=";
  # sylvie-tzuyu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4He6HobF5y8+viL1Fz9wWT+1Y3ptgZ6tpVQ+L3c9dq sylvie@tzuyu";
  local-keys = [ godemiche tzuyu ];

  # kcloud-nix = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIQJ47ZITJ1RprEgapWK6+a0KHqF83h14koa6n00aFcxxHfPw2bnURyHgDY2oy1TFyDUz+z4D0m13Yf0sLrkXg38AmrO7qq3jy5/14AZuKIQxwcK3wzmbVmikaPjJGiw+dqlP5W3muWWlyArb6vQ8vUKYNZrIE7Uz9LDbFaiSlK7jp3kJTPKCi/QzjlmNLGCBI4Vsqn4JxSSy0s6ypF1Y9gq0GKSptzuCs1YUUcbQT0p5YBNvr0pr+4Txh4NAkBg4vW5Qa0VaEsXywujYqRINyCmZXE6EKoIpEXFOA43HTkU6eTTay9r8Fs/UaINAIfRKgjDlmZhjXg37UIr8mBcv7oqplUcqXlyEDcEwCHJrgzxrbBe5XVVeWT9zmkx+lFhWgyk7PFhWLnSyGjfnw5mlOIiUJ8oAl7om+9WzqPuKvDuEhTjtvBmwZ6U36XkiG6W5QVZbm5hj9BfsIAsDw63PYKHuj1gWwU7xsKdYuHqMBywu5mQqDL1x4VTJuHXbrZFBdmBmVJs1OfD2xBhmrMMOGNe3z3hv2Mv1UzBPoQAmB5m5Nj+vSGM4c8ZU7kgNdEUS3HHwId8KQvWchFlBZFPQA4lwVvbuOcW3nnL1RpkUIKUGwWnX5R8k2JcFxU+2/r0D0UKYo8EDiIbmU+LhLYq0tjB4q6CUgLE/SYraOoTOXPQ==";
  # karp-zbox = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtrtVbG2XwiprrBB5K/qvPE9Kd1E/Kta2YnjENG+Gu6XlaTQagfT4qtvl3YGHbSVzH1mqFadaYJeMW4sA1gVITDRts0gn9qFHNZRELTz4C7I6eZpNKAb266TqtAZfcL8ZRLTynl2Dc/Wizr8hrHt6vqY62wxD+Bvb9FIzqh/OwTn5ZtH8gbtBYjtDM6Ed/Xq+y9dT0ebodzVy1RhqnioV4U8tUyIcYboN8p+WQygEbVnPNdqV5sNtBumkpTyZ4VCir0AjdwnSHTPFDBpDtVCF8vjeT4PoAkmJJA/dTxXzYjb2OK6ubccp/ffnZMWHFFWIzuVK/gu7TkD87AKPlmoOXaN8xnjVYeYO1JD2NfTKlq7fcgmejmQkCasnc+8nzXm17TXE9nZagub+15l8BbvuOVA9/kNPY2EmOa+9nOxw93ouyNFDOHKNo2OBplSkLSJTetFPE0u0n5tu029iDMYx5CBy619tz3jS7jdvOTD7TH9EHzOjlTelTAhDxoTRGv0Td5WfZ5sJrFfXYVDOMV31ATWnKWb0m/Ndg/oGV3V940ETrakR64nN9vg8n+vK5FdD9kAa/t3xr8twkOz7aRTir1G5bfeyZCJKkXF9sYZtYP0KXf05pCz/5N7i1Q5tMCADfZbqpjDOAq4RtGX6eMBtm4GI4/IZZeswlgMwInSPeMw==";
  # bakapa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpY7cEtIVtFSi9noQGcNnKlYk8jZkuLIhzj/9Q/N4UX";
  inherit (consts.hostKeys) kcloud-nix karp-zbox bakapa;

  kcloud-keys = local-keys ++ [ kcloud-nix ];
  zbox-keys = local-keys ++ [ karp-zbox ];
  bakapa-keys = local-keys ++ [ bakapa ];
in {
  # main service keys for kcloud
  "vaultwarden.age".publicKeys = kcloud-keys;
  "gts.age".publicKeys = kcloud-keys;
  "nextcloud.age".publicKeys = kcloud-keys;

  # telegram bots running on the little zbox
  "godfish.age".publicKeys = zbox-keys;
  "uwu.age".publicKeys = zbox-keys;
  "ytdl.age".publicKeys = zbox-keys;
  # wifi networks the zbox connects to
  "wifi.age".publicKeys = zbox-keys;

  # bakapa
  "kbackup-bakapa-privkey.age".publicKeys = bakapa-keys;
}
