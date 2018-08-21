__precompile__(true)
module WinPath

using WinReg

export in, out

const BASE = WinReg.HKEY_LOCAL_MACHINE
const PATH = "System\\ControlSet001\\Control\\Session Manager\\Environment"
const VALUENAME = "Path"

function getPath()
    return querykey(BASE, PATH, VALUENAME)
end

function out()
    path = getPath()
    list = split(path, ";")
    list = filter!(x -> x != "", list)
    list = sort(list)
    outData = join(list, "\n")
    return outData
end

function in()
    list = String[]
    for ln in readlines()
        push!(list, ln)
    end
    list = join(list, ";")
    return list
end

end
