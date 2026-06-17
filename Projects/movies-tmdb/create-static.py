#!/usr/bin/env python3
import os

def getFile(filename: str):
  with open(filename, "r") as stream:
    return stream.read()

def getFileStrip(filename: str):
  return getFile(filename).strip()

def saveFile(filename: str, output: str):
  with open(filename, "w") as stream:
    stream.write(output)

template = getFile("index.html")
template = template.replace('{movies: [], tvs: []}', getFileStrip("movies.json"))

if os.path.exists("providers.json"):
  template = template.replace('const providersDirect = {items: {}};', 'const providersDirect = ' + getFileStrip("providers.json") + ';')

if os.path.exists("config.js"):
  template = template.replace('<script src="config.js"></script>', '<script>' + getFileStrip("config.js") + '</script>')

saveFile("index-static.html", template)
