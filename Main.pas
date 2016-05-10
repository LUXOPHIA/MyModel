unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors,
  FMX.Types3D, FMX.Viewport3D, FMX.Controls3D, FMX.Objects3D, FMX.MaterialSources,
  LUX,
  LIB.Model.Poin, LIB.Model.Wire, LIB.Model.Face;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Dummy1: TDummy;
    Dummy2: TDummy;
    Camera1: TCamera;
    Light1: TLight;
    ColorMaterialSource1: TColorMaterialSource;
    TextureMaterialSource1: TTextureMaterialSource;
    LightMaterialSource1: TLightMaterialSource;
    Grid3D1: TGrid3D;
    procedure FormCreate(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { private 宣言 }
    _MouseS :TShiftState;
    _MouseP :TPointF;
  public
    { public 宣言 }
    _PoinModel :TMyPoinModel;
    _WireModel :TMyWireModel;
    _FaceModel :TMyFaceModel;
  end;

var
  Form1: TForm1;

implementation //################################################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseS := [];

     _PoinModel := TMyPoinModel.Create( Self );
     _WireModel := TMyWireModel.Create( Self );
     _FaceModel := TMyFaceModel.Create( Self );

     with _PoinModel do
     begin
          Parent   := Viewport3D1;
          Material := ColorMaterialSource1;
          HitTest  := False;
     end;

     with _WireModel do
     begin
          Parent   := Viewport3D1;
          Material := TextureMaterialSource1;
          HitTest  := False;
     end;

     with _FaceModel do
     begin
          Parent   := Viewport3D1;
          Material := LightMaterialSource1;
          HitTest  := False;
     end;

     TextureMaterialSource1.Texture.LoadFromFile( '../../_DATA/Rainbow_512.png' );
     LightMaterialSource1  .Texture.LoadFromFile( '../../_DATA/Lena_512.png'    );
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     _MouseS := Shift;
     _MouseP := TPointF.Create( X, Y );
end;

procedure TForm1.Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
   P :TPointF;
begin
     if ssLeft in _MouseS then
     begin
          P := TPointF.Create( X, Y );

          with Dummy1.RotationAngle do Y := Y + ( P.X - _MouseP.X ) / 2;
          with Dummy2.RotationAngle do X := X - ( P.Y - _MouseP.Y ) / 2;

          _MouseP := P;
     end;
end;

procedure TForm1.Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     Viewport3D1MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

end. //######################################################################### ■
