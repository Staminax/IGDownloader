unit UMensagem;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  PngBitBtn, Vcl.Imaging.pngimage, PngSpeedButton;

type TMsgTipos = (msgAlerta, msgCarregando, msgErro, msgInf, msgPerg);
type
  TF_Message = class(TForm)
    imgAler: TImage;
    imgCar: TImage;
    imgErro: TImage;
    imgInf: TImage;
    imgPerg: TImage;
    lblMsg: TLabel;
    B_OK: TPngSpeedButton;
    B_Cancel: TPngSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure B_CancelClick(Sender: TObject);
    procedure B_OKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FgMsgTipos: TMsgTipos;
    procedure SetgMsgTipos(const Value: TMsgTipos);
    { Private declarations }
  public
    { Public declarations }
    property gMsgTipos: TMsgTipos read FgMsgTipos write SetgMsgTipos;
    constructor create(AOwner: TComponent; pMsg: String; pMsgTipos: TMsgTipos); reintroduce;
  end;

const
  CAPTIONAUX = '@eternytx';
  MSGLEFT = 30;
  BTNOKLEFTI = 36;
  BTNOKLEFTII = 18;

implementation

{$R *.dfm}

{ TFrmMensagem }

procedure TF_Message.B_CancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TF_Message.B_OKClick(Sender: TObject);
begin
  ModalResult:= mrOk;
end;

constructor TF_Message.create(AOwner: TComponent; pMsg: String; pMsgTipos: TMsgTipos);
var lPosLeftOk, lPosLeftCancel, lPosLeftLbl: Double;
    lPosTopBtn: Double;
    lDifWidth, lDifHeight: Double;
    lHeight: Integer;
    lAltHeight: Boolean;
begin
  inherited create(AOWner);

  lHeight   := lblMsg.Height;
  lAltHeight:= False;
  SetgMsgTipos(pMsgTipos);

  lblMsg.Caption:= pMsg;
  lblMsg.Hint   := pMsg;

  if lblMsg.Width > Width-lblMsg.Left then
  begin
    lDifWidth:= lblMsg.Width-(Width-lblMsg.Left);
    lDifWidth:= Width+lDifWidth+MSGLEFT;
    Width:= Trunc(lDifWidth);
  end;

  if lblMsg.Height > lHeight then
  begin
    lDifHeight:= lblMsg.Height-lHeight;
    lPosTopBtn:= lDifHeight;
    lDifHeight:= Height+lDifHeight;
    Height    := Trunc(lDifHeight);
    lAltHeight:= True;
  end;

  case gMsgTipos of
    msgAlerta: begin
      imgAler.Visible := True;
      Caption         := Format(CAPTIONAUX,['Alerta']);
    end;

    msgErro: begin
      imgErro.Visible := True;
      Caption         := Format(CAPTIONAUX,['Erro']);
    end;

    msgInf: begin
      imgInf.Visible:= True;
      Caption       := Format(CAPTIONAUX,['Informativo']);
    end;

    msgPerg: begin
      imgPerg.Visible     := True;
      B_Cancel.Visible    := True;
      Caption             := Format(CAPTIONAUX,['Pergunta']);
    end;

    msgCarregando: begin
      imgCar.Visible:= True;
      B_OK.Visible  := False;
      Cursor        := crHourGlass;
      Caption       := Format(CAPTIONAUX,['Carregando']);
    end;
  end;

  lPosLeftLbl:= (Width/2)-(lblMsg.Width/2);

  if gMsgTipos = msgPerg then
  begin
    lPosLeftOk    := (Width/2)-BTNOKLEFTI;
    lPosLeftCancel:= (Width/2);
  end
  else
    lPosLeftOk    := (Width/2)-BTNOKLEFTII;

  if lAltHeight then
  begin
    B_OK.Top        := B_OK.Top + Trunc(lPosTopBtn);
    B_Cancel.Top    := B_OK.Top;
  end;

  B_OK.Left      := Trunc(lPosLeftOk);
  B_Cancel.Left  := Trunc(lPosLeftCancel);
  lblMsg.Left    := Trunc(lPosLeftLbl);
end;

procedure TF_Message.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if gMsgTipos = msgPerg then
     Cursor:= crDefault;
  Action      := caFree;
end;

procedure TF_Message.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Ord(Key) of
    VK_RETURN : B_OK.OnClick(Nil);
    VK_ESCAPE : B_Cancel.OnClick(Nil);
  end;
end;

procedure TF_Message.SetgMsgTipos(const Value: TMsgTipos);
begin
  FgMsgTipos := Value;
end;

end.
