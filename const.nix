{
  sshKeys = {
    sylvie = {
      godemiche = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIBy1b6An4WzmHWnsUS1OfF/6lYc8bAzEjuFzQ+zFLEMi1Yyr117+7gus8fHvC7bg85R77vB32JbriRClafxmqLXRrAI9LLKWeUoSi28R6SVMiO3R3bGTTyIRpUFqTYa0aNycqfQiUbQVC1IbxeFPc+z3RSaZelKbPQd1EVh0JvcZ2vNwW3ohyj6sAE8utmGvWn6zGRdKAiITswaK+KScpMiZVBDi18A0T5lHbc1yJGsEW6InT+DKvXc4fWe5J56O9+asqztxgx0tXWxeP2+LuryV43LlHlsZ/Iv/YtMbbYI8d9OJh8LByKabr0BCAFd6YS55EZbiRngVJefqjqetD5p7M1fX7kz+MefospLtle2iwu8wj+IXvxkw0c9DGz22iMqCxUSdMKzUvNk6tii2vDYHW8lyT7gGPm1YebQ/TxOlJJr8tHR9YIISWEW7JilBVeUVjI+UzaC4rWTAciUI1P0cM+va7OGY/KLZoK1GQ+89L78TLazHFNkEr3TCe5Jc=";
      tzuyu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4He6HobF5y8+viL1Fz9wWT+1Y3ptgZ6tpVQ+L3c9dq sylvie@tzuyu";
    };
    kbackup = {
      bakapa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFy0rbgaUIMQD1o0eOn80EVVmW3wo5jDaG+swPbbWxz/ kbackup@bakapa";
      # the old one, to be renamed tbh
      kbackup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAPIaMz/QdIAbYSY9U556Igg7ZmPKDuZx7smqvdfMdD kbackup@kbackup";
      karp-zbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvuUVZkGRNLms8wslsf7xUhyTyahuB778PbJrZfYp/L kbackup@karp-zbox";
    };
  };
  hostKeys = {
    kcloud-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGELE5ltBEMgxZV0F14CyE/Fd7k8DkdFNUot3QGmgqLX";
    karp-zbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLvfpJKDDTVZypyN4iDxFHQR7oxquYLgPNbE/G/Mw23";
    bakapa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpY7cEtIVtFSi9noQGcNnKlYk8jZkuLIhzj/9Q/N4UX";
    moo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlOiaIMcXRCVnlr2Z/MjfQfP/DKK16ziYoLmkVcnmpq";
  };
}
