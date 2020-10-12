import cpp 

from MacroAccess m 
where m.getMacro().getName().regexpMatch("ntoh.*")
select m, "macro"
