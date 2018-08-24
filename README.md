# WinPath.jl
Registry Path r/w

### Env
Julia v1.0

### Sample Handler
```
import WinPath

if ARGS[1] == "in"
    WinPath.in()
elseif ARGS[1] == "out"
    WinPath.out()
else
    println("not recognized ARGS: ", ARGS)
end
```
