__precompile__(true)
module WinPath

import WinReg
import JSON
import Base

export in, out, getConfig

const BASE = WinReg.HKEY_LOCAL_MACHINE
const PATH = "System\\ControlSet001\\Control\\Session Manager\\Environment"
const VALUENAME = "Path"
const CONFIG_PATH = "C:\\WinPath\\config.json"

struct Config
    root::AbstractString
    outPath::AbstractString
    inPath::AbstractString
    function Config(root::AbstractString, outPath::AbstractString, inPath::AbstractString)
        new(root, outPath, inPath)
    end
    function Config(jsonDict::Dict{String, Any})
        root = jsonDict["root"]
        outPath = jsonDict["outPath"]
        inPath = jsonDict["inPath"]
        new(root, outPath, inPath)
    end
end

function Base.show(io::IO, config::Config)
    print(io, string("root: ", config.root, "\n",
                     "outPath: ", config.outPath, "\n",
                     "inPath: ", config.inPath))
end

function config()
    jsonDict = JSON.parsefile(CONFIG_PATH)
    config = Config(jsonDict)
    if !isdir(config.root)
        mkdir(config.root)
    end
    return config
end

function getPath()
    return WinReg.querykey(BASE, PATH, VALUENAME)
end

function out()
    path = getPath()
    list = split(path, ";")
    list = filter!(x -> x != "", list)
    list = sort(list)
    outData = join(list, "\n")
    open(CONFIG.outPath, "w+") do file
        write(file, outData)
    end
    return nothing
end

function in()
    list = String[]
    open(CONFIG.outPath, "r") do outfile
        for ln in readlines(outfile)
            push!(list, ln)
        end
        list = sort(list)
        list = join(list, ";")
        open(CONFIG.inPath, "w+") do infile
            write(infile, list)
        end
    end
    return nothing
end

function getConfig()
    println(CONFIG)
end

const CONFIG = config()

end
