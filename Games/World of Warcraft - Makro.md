# World of Warcraft

## Macros

```text
/run if(GetCVar("autoLootDefault") == "1") then t="Aus"; SetCVar("autoLootDefault", 0); else t="An"; SetCVar("autoLootDefault", 1); end; DEFAULT_CHAT_FRAME:AddMessage("[Cyb] Autoloot "..t);
```

```text
/run if(LOCK_ACTIONBAR == 1) then o=false; LOCK_ACTIONBAR=0; else o=true; LOCK_ACTIONBAR=1;end;m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n) then EditMacro(i,n,o and 550 or 561,b,l,_);end;end;
```

Blue:

```text
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,533,b,l,_);end;end;
```

Green:

```text
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,550,b,l,_);end;end;
```

Red:

```text
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,561,b,l,_);end;end;
```
