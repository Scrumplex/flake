self: super: rec {
  discord = super.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  discord-canary = super.discord-canary.override {
    withOpenASAR = true;
    withVencord = true;
  };

  glfwUnstable = super.glfw.overrideAttrs (_: {
    src = self.fetchFromGitHub {
      owner = "glfw";
      repo = "GLFW";
      rev = "62e175ef9fae75335575964c845a302447c012c7";
      sha256 = "sha256-GiY4d7xadR0vN5uCQyWaOpoo2o6uMGl1fCcX4uDGnks=";
    };
  });

  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
  };

  prismlauncher = super.prismlauncher.override {
    glfw = glfwUnstable;
  };
}
