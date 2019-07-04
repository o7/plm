-module(kvs_adm).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("kvs/include/cursors.hrl").

event(init)      -> [ begin nitro:clear(X), self() ! {direct,X} end || X <- [writers,session,enode,disc,ram] ];
event(ram)       -> nitro:update(ram,     #span{body = ram(os:type())});
event(session)   -> nitro:update(session, #span{body = n2o:sid()});
event(enode)     -> nitro:update(enode,   #span{body = lists:concat([node()])});
event(disc)      -> nitro:update(disc,    #span{body = hd(string:tokens(os:cmd("du -hs rocksdb"),"\t"))});
event({link,Id}) -> nitro:clear(feeds), lists:map(fun(T)-> nitro:insert_bottom(feeds, #panel{body=nitro:compact(T)}) end,kvs:feed(Id));
event(writers)   -> [ nitro:insert_bottom(writers,
                      #panel{body = [#link{body = Id, postback = {link,Id}}," (" ++ nitro:to_list(C) ++ ")"]})
                   || #writer{id = Id, count = C} <- kvs:all(writer) ];
event(_) -> [].

ram({_,darwin}) ->
   Mem = os:cmd("top -l 1 -s 0 | grep PhysMem"),
   [_,L,C,R]=string:tokens(lists:filter(fun(X) -> lists:member(X,"0123456789MG ") end, Mem)," "),
   lists:concat([nitro:meg(nitro:num(L)),"/",nitro:meg(nitro:num(L)+nitro:num(R)),""]);
ram({_,linux}) ->
   [T,U,_,_,B,C] = lists:sublist(string:tokens(os:cmd("free")," \n"),8,6),
   Mem = (nitro:to_integer(U)-(nitro:to_integer(B)+nitro:to_integer(C))) div 1000,
   lists:concat([Mem,"/",nitro:to_integer(T) div 1000,"M"]);
ram(OS) -> nitro:compact(OS).
