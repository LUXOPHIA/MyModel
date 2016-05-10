unit LIB.Model.Wire;

interface //#################################################################### ■

uses System.Types, System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyWireModel

     TMyWireModel = class( TControl3D )
     private
       ///// メソッド
       procedure MakeModel;
     protected
       _Geometry :TMeshData;
       _Material :TMaterialSource;
       _DivN     :Integer;
       ///// アクセス
       procedure SetDivN( const DivN_:Integer );
       ///// メソッド
       procedure Render; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Material :TMaterialSource read _Material write   _Material;
       property DivN     :Integer         read _DivN     write SetDivN    ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.RTLConsts;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyWireModel

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TMyWireModel.MakeModel;
var
   I :Integer;
   T :Single;
begin
     with _Geometry do
     begin
          with VertexBuffer do
          begin
               Length := _DivN{Wire} + 1;

               for I := 0 to _DivN do
               begin
                    T := Pi2 * I / _DivN;

                    Vertices [ I ] := TPoint3D.Create( Cos( 1 * T ), Sin( 2 * T ), Sin( 3 * T ) );

                    TexCoord0[ I ] := TPointF.Create( I / _DivN, 0 );
               end;
          end;

          with IndexBuffer do
          begin
               Length := 2{Poin} * _DivN{Wire};

               for I := 0 to _DivN-1 do
               begin
                    Indices[ 2 * I     ] := I    ;
                    Indices[ 2 * I + 1 ] := I + 1;
               end;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TMyWireModel.SetDivN( const DivN_:Integer );
begin
     _DivN := DivN_;  MakeModel;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyWireModel.Render;
begin
     with Context do
     begin
          SetMatrix( AbsoluteMatrix );

          DrawLines( _Geometry.VertexBuffer                  ,
                     _Geometry.IndexBuffer                   ,
                     TMaterialSource.ValidMaterial(_Material),
                     AbsoluteOpacity                          );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyWireModel.Create( Owner_:TComponent );
begin
     inherited;

     _Geometry := TMeshData.Create;

     _DivN     := 256;

     MakeModel;
end;

destructor TMyWireModel.Destroy;
begin
     _Geometry.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
