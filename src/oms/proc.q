.servers.startup[]
hbtt: .servers.gethandlebytype[`bttickerplant;`any]
hportfolio: .servers.gethandlebytype[`portfolio;`any]
hswitch: .servers.gethandlebytype[`btswitch;`any]
hfill: .servers.gethandlebytype[`market;`any]
btt: .sub.getsubscriptionhandles[`bttickerplant;();()!()]
subinfo:.sub.subscribe[`targetsz`targetw;`;1b;0b;first btt]