unit uCommEvents;

interface

type
  TBooleanFunc = function(): boolean of object;
  TGetStrProc2 = procedure(const S, S2: string) of object;
  TBoolOfStrProc = function(const S: string):boolean of object;

implementation

end.

