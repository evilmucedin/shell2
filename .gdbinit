set history filename ~/.gdb_history
set history save
set history size 500
set print static-members off
set print asm-demangle on
define size
  print ($arg0)._M_finish-($arg0)._M_start
end
document size
  Print the size of a given STL vector
end
