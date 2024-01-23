import std/strutils, os


type
  PathStatus = enum
    pDir, pFile, pNone

const
  signosValidos = "abcdefghijklmnopqrstuvwxyz0123456789-._"
  signoNormal = '_'
  signosDeReemplazo = [("á", "a"),
                       ("é", "e"),
                       ("í", "i"),
                       ("ó", "o"),
                       ("ú", "u")]

proc mostrarAyuda =
  echo """
fname_normalize renombra archivos y directorios restringiendo
la variedad de signos disponibles en ellos.

Requiere que se le pase un lista de rutas de archivos o carpetas.
Nota: Usarlo con precaución, porque no pide confirmación antes de proceder a renombrar.

Ejemplo de uso:
fname_normalize ./documentos_a_renombrar/*
"""

proc normalizar(tex: string): string =
  ## Devuelve un texto normalizado según las especificaciones de:
  ## `signosValidos`, `signoNormal`, `signosDeReemplazo`

  var tmp = tex.toLower().multiReplace(signosDeReemplazo)
  for s in tmp[0..^1]:
    if s in signosValidos:
      result &= s
    else:
      result &= signoNormal
  let sn2 = $signoNormal & $signoNormal
  while sn2 in result:
    result = result.multiReplace([(sn2, $signoNormal)])
  result = result.strip(chars={signoNormal})


proc pathStatus(p: string): PathStatus =
  ## Determina si el path es: directorio, archivo o no existe.

  result = pNone
  if p.fileExists:
    result = pFile
  elif p.dirExists:
    result = pDir


proc renombrar(pa: string, isDir: bool) =
  ## Si puede, renombra el archivo o directorio del path asignado,
  ## sino avisa.

  var (fdir, fnom, fext) = splitFile(pa)
  if fdir == "": fdir = "."

  var
    (nfnom, nfext) = (fnom.normalizar, fext.normalizar)
    npa = fdir & "/" & nfnom  & nfext

  if pa == npa:
    echo "Bien: ", pa

  else:
    var cver = 1
    while npa.fileExists:
      # previene que se sobreescriba un archivo que tenga el mismo
      # path que el normalizado
      npa = fdir & "/" & fnom.normalizar & "-" & $cver & fext.normalizar
      cver.inc

    echo "Renombrar: $1\ncomo: $2" % [pa, npa]
    try:
      if isDir:
        pa.moveDir npa
      else:
        pa.moveFile npa
    except:
      echo "ERROR! No se pudo renombrar: ", pa


when isMainModule:
  if paramCount() == 0:
    mostrar_ayuda()


  for pa in commandLineParams():
    echo "-".repeat(10)
    case pa.pathStatus:
      of pNone:
        echo "No existe: ", pa
      of pDir:
        pa.renombrar true
      of pFile:
        pa.renombrar false
