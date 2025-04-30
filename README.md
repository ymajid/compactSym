# compactSym

```
q)\l compactSym.q
q)path:hsym`$"/Users/ymajid/Work/git/db"
q)genData[1000000;path]
"issuing system command: rm -rf /Users/ymajid/Work/git/db"
q)compactSym path
"issuing system command: cp -f /Users/ymajid/Work/git/db/sym /Users/ymajid/Work/git/db/symBk"
"re-enumrated :/Users/ymajid/Work/git/db/2025.04.06/tab/sym"
...
"re-enumrated :/Users/ymajid/Work/git/db/2025.05.25/tab/sym"
"old sym count: 644385"
"new sym count: 579947"
"compression ratio: 1.11111"
q)compactSym path
"issuing system command: cp -f /Users/ymajid/Work/git/db/sym /Users/ymajid/Work/git/db/symBk"
"re-enumrated :/Users/ymajid/Work/git/db/2025.04.06/tab/sym"
...
"re-enumrated :/Users/ymajid/Work/git/db/2025.05.25/tab/sym"
"old sym count: 579947"
"new sym count: 579947"
"compression ratio: 1"
```
