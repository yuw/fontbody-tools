fontbody-tools
==============

- afm2eps
  - AFMファイルから各文字のbaseline付きバウンディングボックスを表現
  - AFMの在る既存の文字からバウンディングのみのfont fileを作成したい
  - AFM/TFMを利用し，カーニング情報を与えれば，
    ボディ情報を視覚化したfont fileを作成可能
  - PFB/PFA/PFM -> AFM: pf2afm (ghostscript)
  - AFM -> EPS: afm2eps
- afm2bbox
  - FontForgeを利用して，作成したEPSを配置し，
    AFM/TFMからカーニング情報を与える
