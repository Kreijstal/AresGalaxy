{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.
 }

{
Description:
supernode election (leaf -> supernode upgrade).

The original node_upgrade.pas was never part of the published Ares Galaxy
sources (it is missing from the official 2.4.6 source archive as well), so
this replacement keeps the client a plain leaf node: it never promotes
itself to a supernode.
}

unit node_upgrade;

interface

procedure can_become_supernode;

implementation

procedure can_become_supernode;
begin
end;

end.
