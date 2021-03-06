unit uDownload;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  RzPanel, RzRadGrp, Vcl.Buttons, ShellAPI, JvProgressBar;

type
  TF_Download = class(TForm)
    EDTFileResource: TEdit;
    B_Download: TSpeedButton;
    PNL_Center: TPanel;
    Timer: TTimer;
    LBLMsg: TLabel;
    TimerReady: TTimer;
    GBX_Ext: TGroupBox;
    RB_JPG: TRadioButton;
    RB_PNG: TRadioButton;
    procedure B_DownloadClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerTimer(Sender: TObject);
    procedure TimerReadyTimer(Sender: TObject);
  private
    { Private declarations }
    procedure Download(const AResource : String);
    function IsValidURL(const AResource : String): Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses UMensagem;

{ TF_Download }

procedure TF_Download.B_DownloadClick(Sender: TObject);
begin
 if IsValidURL(Trim(EDTFileResource.Text)) then
  begin
   LBLMsg.Caption := 'Downloading photo to your Desktop...';
   Download(Trim(EDTFileResource.Text));
  end;
end;

procedure TF_Download.Download(const AResource: String);
var
   Script : String;
   Path   : String;
   FType  : String;
   LRes   : String;
   F_MSG  : TF_Message;
begin
if RB_JPG.Checked then FType := '.jpg';
if RB_PNG.Checked then FTYpe := '.png';

if not(Trim(EDTFileResource.Text) = EmptyStr) then
 begin
  Try
   Try

    LBLMsg.Visible := True;
    if Pos('?', AResource) > 0 then
     begin
      LRes   := Copy(AResource, 0, Pos('?', AResource) - 1);
      LRes   := StringReplace(LRes, '?', '', [rfReplaceAll]);
      Script := 'Scripts\IGDWNLDR.exe -l ' + LRes + ' -x ' + FType;
     end
    else
    Script := 'Scripts\IGDWNLDR.exe -l ' + AResource + ' -x ' + FType;
    ShellExecute(Application.Handle, 'open', 'cmd', PChar('/c ' + Script), Nil, SW_HIDE);
   Finally
    Timer.Enabled := True;
    TimerReady.Enabled := True;
   End;
  Except ON E: Exception do
   begin
    try
      F_MSG := TF_Message.create(Self, 'Ocorreu um erro ao baixar a imagem: ' + E.Message, msgErro);
    finally
      FreeAndNil(F_MSG);
      Abort;
    end;
   end;
  End;
 end
else
 begin
   try
     F_MSG := TF_Message.create(Self, 'Preencha o campo com o link da imagem para prosseguir.', msgAlerta);
     F_MSG.ShowModal;
   finally
     FreeAndNil(F_MSG);
     Abort;
   end;
 end;
end;

procedure TF_Download.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 Then
     Self.Close;
  If Key = #13 Then
     B_Download.OnClick(Nil);
end;

function TF_Download.IsValidURL(const AResource: String): Boolean;
var
   F_MSG : TF_Message;
begin
  Result := False;
  if not(AResource = EmptyStr) then
  begin
  if Pos('www.instagram.com/p/', AResource) > 0 then
   begin
     Result := True;
   end
  else
   begin
    try
     F_MSG := TF_Message.create(Self, 'URL Inv�lida :(', msgAlerta);
     F_MSG.ShowModal;
   finally
     FreeAndNil(F_MSG);
     Abort;
   end;
   end;
  end;
end;

procedure TF_Download.TimerReadyTimer(Sender: TObject);
begin
  LBLMsg.Caption := 'Photo downloaded to your Desktop!';
  TimerReady.Enabled := False;
end;

procedure TF_Download.TimerTimer(Sender: TObject);
begin
  LBLMsg.Visible := False;
  Timer.Enabled  := False;
end;

end.
