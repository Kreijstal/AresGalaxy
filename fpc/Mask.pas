{ Delphi "Mask" unit compatibility for the LCL, which keeps TMaskEdit in MaskEdit. }
unit Mask;

{$mode delphi}

interface

uses
  MaskEdit;

type
  TCustomMaskEdit = MaskEdit.TCustomMaskEdit;
  TMaskEdit = MaskEdit.TMaskEdit;

implementation

end.
