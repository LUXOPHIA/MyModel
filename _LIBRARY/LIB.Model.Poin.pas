unit LIB.Model.Poin;

interface //#################################################################### ■

uses System.Types, System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyPoinModel

     TMyPoinModel = class( TControl3D )
     private
       ///// メソッド
       procedure MakeModel;
     protected
       _Geometry :TMeshData;
       _Material :TMaterialSource;
       _Count    :Integer;
       ///// アクセス
       procedure SetCount( const Count_:Integer );
       ///// メソッド
       procedure Render; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Material :TMaterialSource read _Material write   _Material;
       property Count    :Integer         read _Count    write SetCount   ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.RTLConsts, System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyPoinModel

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TMyPoinModel.MakeModel;
var
   I :Integer;
begin
     with _Geometry do
     begin
          with VertexBuffer do
          begin
               Length := _Count{Poin};

               for I := 0 to _Count-1 do
               begin
                    Vertices [ I ] := TPoint3D.Create( RandG( 0, 0.5 ), RandG( 0, 0.5 ), RandG( 0, 0.5 ) );

                    TexCoord0[ I ] := TPointF.Create( I / ( _Count - 1 ), 0 );
               end;
          end;

          with IndexBuffer do
          begin
               Length := _Count{Poin};

               for I := 0 to _Count-1 do Indices[ I ] := I;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TMyPoinModel.SetCount( const Count_:Integer );
begin
     _Count := Count_;  MakeModel;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TMyPoinModel.Render;
begin
     with Context do
     begin
          SetMatrix( AbsoluteMatrix );

          DrawPoints( _Geometry.VertexBuffer                  ,
                      _Geometry.IndexBuffer                   ,
                      TMaterialSource.ValidMaterial(_Material),
                      AbsoluteOpacity                          );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyPoinModel.Create( Owner_:TComponent );
begin
     inherited;

     _Geometry := TMeshData.Create;

     _Count    := 4096;

     MakeModel;
end;

destructor TMyPoinModel.Destroy;
begin
     _Geometry.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
