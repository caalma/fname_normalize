# Package

version       = "0.1.0"
author        = "caalma"
description   = "Normalizador de nombres de archivos."
license       = "MIT"
srcDir        = "src"
bin           = @["fname_normalize"]


# Tareas

task test, "Probar el ejecutable con parámetros seleccionados":
  exec "nimble build"
  exec "rm -rf ./tmp-test/"
  exec "cp -r ./tmp-test-base/ ./tmp-test/"
  exec "./fname_normalize ./tmp-test/*"
  exec "./fname_normalize './tmp-test/algo-que no existe'"

task release, "Crear la versión final.":
  exec "nimble build -d:release"

task clear, "Eliminar archivos temporales de tests y binarios.":
  exec "rm -rf ./tmp-test/"
  exec "rm ./fname_normalize"

task install_bin_local, "Instala el binario en '$HOME/.local/bin/'. Para sistema operativo tipo Linux.":
  exec "cp ./fname_normalize $HOME/.local/bin/"


# Dependencies

requires "nim >= 2.0.2"
