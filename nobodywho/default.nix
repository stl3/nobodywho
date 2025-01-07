{ fetchurl, rustPlatform, libclang, llvmPackages_12, stdenv, lib, cmake, vulkan-headers, vulkan-loader, vulkan-tools, shaderc, mesa }:


rustPlatform.buildRustPackage {
  pname = "nobody";
  version = "0.0.0";
  src = ./.;
  nativeBuildInputs = [
    llvmPackages_12.bintools
    cmake
    rustPlatform.bindgenHook
    vulkan-headers
    vulkan-loader
    shaderc
    vulkan-tools
    mesa.drivers
  ];
  buildInputs = [
    vulkan-loader
    vulkan-headers
    shaderc
    vulkan-tools
    mesa.drivers
  ];
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "gdextension-api-0.2.1" = "sha256-YkMbzObJGnmQa1XGT4ApRrfqAeOz7CktJrhYks8z0RY=";
      "godot-0.2.2" = "sha256-6q7BcQ/6WvzJdVmyAVGPMtuIDJFYKaRrkv3/JQBi11M=";
      "llama-cpp-2-0.1.86" = "sha256-Fe8WPO1NAISGGDkX5UWM8ubekYbnnAwEcKf0De5x9AQ=";
    };
  };
  env.TEST_MODEL = fetchurl {
    name = "gemma-2-2b-it-Q5_K_M.gguf";
    url = "https://huggingface.co/bartowski/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it-Q5_K_M.gguf";
    sha256 = "1njh254wpsg2j4wi686zabg63n42fmkgdmf9v3cl1zbydybdardy";
  };
  env.TEST_EMBEDDINGS_MODEL = fetchurl {
    name = "bge-small-en-v1.5-q8_0.gguf";
    url = "https://huggingface.co/CompendiumLabs/bge-small-en-v1.5-gguf/resolve/main/bge-small-en-v1.5-q8_0.gguf";
    sha256 = "sha256-7Djo2hQllrqpExJK5QVQ3ihLaRa/WVd+8vDLlmDC9RQ=";
  };

  checkPhase = ''
    cargo test -- --test-threads=1 --nocapture
  '';
  doCheck = true;
}
