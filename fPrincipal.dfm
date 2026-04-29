object Principal: TPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Totvs Minha An'#225'lise de Ambiente'
  ClientHeight = 665
  ClientWidth = 876
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 66
    Height = 665
    Align = alLeft
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitHeight = 653
    object SpeedButton1: TSpeedButton
      Left = 5
      Top = 9
      Width = 55
      Height = 50
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 5
      Top = 65
      Width = 55
      Height = 50
    end
    object SpeedButton3: TSpeedButton
      Left = 5
      Top = 120
      Width = 55
      Height = 50
    end
    object SpeedButton4: TSpeedButton
      Left = 5
      Top = 175
      Width = 55
      Height = 50
    end
    object SpeedButton5: TSpeedButton
      Left = 5
      Top = 230
      Width = 55
      Height = 50
    end
    object SpeedButton6: TSpeedButton
      Left = 5
      Top = 286
      Width = 55
      Height = 50
      OnClick = SpeedButton6Click
    end
  end
  object Panel2: TPanel
    Left = 66
    Top = 0
    Width = 810
    Height = 665
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitWidth = 806
    ExplicitHeight = 653
    object pgPrincipal: TPageControl
      Left = 2
      Top = 2
      Width = 806
      Height = 661
      ActivePage = TabAnalise
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 802
      ExplicitHeight = 649
      object TabAnalise: TTabSheet
        Caption = 'tabAnalise'
        object LstPrincipal: TListBox
          Left = 0
          Top = 0
          Width = 800
          Height = 514
          ItemHeight = 13
          TabOrder = 0
          OnDrawItem = LstPrincipalDrawItem
        end
        object MemoResult: TMemo
          Left = 0
          Top = 520
          Width = 800
          Height = 110
          ImeName = 'Portuguese (Brazilian ABNT)'
          Lines.Strings = (
            'MemoResult')
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
      object TabMonitor: TTabSheet
        Caption = 'tabMonitor'
        ImageIndex = 1
      end
      object TabRede: TTabSheet
        Caption = 'Rede'
        ImageIndex = 2
      end
    end
  end
end
