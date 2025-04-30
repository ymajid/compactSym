sysCmd:{ (0N!"issuing system command: ",;system)@\:x };

genData:{[n;path]
  sysCmd "rm -rf ",1_ string path;                                                                                                       / delete existing db
  .Q.en[path;] tab:([]time:.z.p+00:05*til n;sym:n?`5;askPx:n?100f;bidPx:n?100f;msg:n?enlist"abc");                                       / create tab, and sym file
  distinctSyms:distinct tab`sym; tab:update date:`date$time from delete from tab where sym in (count[distinctSyms] div 10)#distinctSyms; / delete 10% of sym domain
  {.Q.dd[x;(`$string z),`tab`] set .Q.en[x;] delete date from select from y where date=z}[path;tab;] each distinct tab`date;             / create partitioned db
 };

/ from dbmaint.q
getPaths:{[path]
  files:key path;
  files:path .Q.dd'files where files like "[0-9]*";
  raze { x where 20h=(type get@) each x:x .Q.dd'key x } each raze { x .Q.dd'key x } each files / todo: handle 21-77h
 };

compactSym:{[path]
  / create backup sym file
  symFile:.Q.dd[path;`sym];
  symFileBk:.Q.dd[path;`symBk];
  sysCmd "cp -f ",(1_ string symFile)," ",1_ string symFileBk;
  / get all symbols
  files:getPaths path;
  set[;get symFile] each `sym`oldSym;
  allSym:distinct raze {distinct value get x} peach files; / mem. intensive...
  .Q.gc[]; / ...so gc
  / re-enumrate
  set[;`$()] each `sym,symFile;
  .Q.en[path;([]allSym)];
  / populate tmp sym file with required enums 
  { c:get x; / file content
    a:attr c; / attributes
    c:oldSym`int$c; / unenumerate using old sym 
    x set a#`sym$c; / enumerate using new sym file, add attributes, and write to disk
    0N!"re-enumrated ",string x} peach files;
   0N!"old sym count: ",string count oldSym;
   0N!"new sym count: ",string count allSym;
   0N!"compression ratio: ",string count[oldSym]%count allSym;
 };
