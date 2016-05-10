unit LIB.Model.Face;

interface //#################################################################### ■

uses System.Types, System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyFaceModel

     TMyFaceModel = class( TControl3D )
     private
       ///// メソッド
       function XYtoI( const X_,Y_:Integer ) :Integer; inline;
       procedure MakeModel;
     protected
       _Geometry :TMeshData;
       _Material :TMaterialSource;
       _DivX     :Integer;
       _DivY     :Integer;
       ///// アクセス
       procedure SetDivX( const DivX_:Integer );
       procedure SetDivY( const DivY_:Integer );
       ///// メソッド
       procedure Render; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Material :TMaterialSource read _Material write   _Material;
       property DivX     :Integer         read _DivX     write SetDivX    ;
       property DivY     :Integer         read _DivY     write SetDivY    ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.RTLConsts;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyFaceModel

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TMyFaceModel.XYtoI( const X_,Y_:Integer ) :Integer;
begin
     Result := ( _DivX + 1 ) * Y_ + X_;
end;

procedure TMyFaceModel.MakeModel;
var
   X ,Y, I :Integer;
begin
     with _Geometry do
     begin
          with VertexBuffer do
          begin
               Length := ( _DivX + 1 ) * ( _DivY + 1 );

               for Y := 0 to _DivY do
               begin
                    for X := 0 to _DivX do
                    begin
                         I := XYtoI( X, Y );

                         Vertices [ I ] := TPoint3D.Create( 2 * X / _DivX - 1, 2 * Y / _DivY - 1, -1 ).Normalize;

                         Normals  [ I ] := Vertices[ I ];

                         TexCoord0[ I ] := TPointF.Create( X / _DivX, Y / _DivY );
                    end;
               end;
          end;

          with IndexBuffer do
          begin
               Length := 3{Poin} * 2{Face} * _DivX * _DivY;

               I := 0;
               for Y := 0 to _DivY - 1 do
               begin
                    for X := 0 to _DivX - 1 do
                    begin
                         Indices[ I ] := XYtoI( X    , Y     );  Inc( I );
                         Indices[ I ] := XYtoI( X + 1, Y     );  Inc( I );
                         Indices[ I ] := XYtoI( X + 1, Y + 1 );  Inc( I );

                         Indices[ I ] := XYtoI( X + 1, Y + 1 );  Inc( I );
                         Indices[ I ] := XYtoI( X    , Y + 1 );  Inc( I );
                         Indices[ I ] := XYtoI( X    , Y     );  Inc( I );
                    end;
               end;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TMyFaceModel.SetDivX( const DivX_:Integer );
begin
     _DivX := DivX_;  MakeModel;
end;

procedure TMyFaceModel.SetDivY( const DivY_:Integer );
begin
     _DivY := DivY_;  MakeModel;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyFaceModel.Render;
begin
     Context.SetMatrix( AbsoluteMatrix);

     _Geometry.Render( Context, TMaterialSource.ValidMaterial(_Material), AbsoluteOpacity );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyFaceModel.Create( Owner_:TComponent );
begin
     inherited;

     _Geometry := TMeshData.Create;

     _DivX := 32;
     _DivY := 32;

     MakeModel;
end;

destructor TMyFaceModel.Destroy;
begin
     _Geometry.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
