sysCmd:{(0N!"issuing system command: ",;system)@\:x};

genData:{[n;path;symName]
  sysCmd"rm -rf ",1_ string path; / delete existing db
  .Q.ens[path;;symName:`sym^symName] tab:([]time:.z.p+00:05*til n;sym:n?`5;askPx:n?100f;bidPx:n?100f;msg:n?enlist"abc"); / create tab, and sym file
  distinctSyms:distinct tab`sym; tab:update date:`date$time from delete from tab where sym in (count[distinctSyms] div 10)#distinctSyms; / delete 10% of sym domain
  {[x;y;z;sn].Q.dd[x;(`$string z),`tab`] set .Q.ens[x;;sn] delete date from select from y where date=z}[path;tab;;symName] each distinct tab`date; / create partitioned db
 };

/ from dbmaint.q
getPaths:{[path]
  files:key path;
  files:path .Q.dd'files where files like "[0-9]*";
  :raze { x where 20h=(type get@) each x:x .Q.dd'key x } each raze { x .Q.dd'key x } each files;
 };

compactSym:{[path;opt]
  if[not 99h=type opt;opt:()!()];
  opt:(``symName!(::;`sym)),opt;
  / create backup sym file
  symName:opt`symName;
  symFile:.Q.dd[path;symName];
  symFileBk:.Q.dd[path;`$string[symName],"Bk"];
  sysCmd"cp -f ",(1_ string symFile)," ",1_ string symFileBk;
  / get all symbols
  files:getPaths path;
  set[;get symFile]each`sym`oldSym;
  allSym:distinct raze{distinct value get x}peach files; / mem. intensive...
  .Q.gc[]; / ...so gc
  / re-enumrate
  set[;`$()] each `sym,symFile;
  .Q.ens[path;([]allSym);symName];
  / populate tmp sym file with required enums 
  { c:get x;  / file content
    a:attr c; / attributes
    c:oldSym`int$c; / unenumerate using old sym 
    x set a#y$c;    / enumerate using new sym file, add attributes, and write to disk
    0N!"re-enumrated ",string x}[;symName] peach files;
   0N!"old sym count: ",string count oldSym;
   0N!"new sym count: ",string count allSym;
   0N!"compression ratio: ",string count[oldSym]%count allSym;
 };
