fontbody-tools
==============

- afm2eps
  - AFMファイルから各文字のbaseline付きboxを生成する
  - 金属活字のボディを表現することになる
  - AFMの在る既存の文字から活字ボディのみのfont fileを作成したい
  - AFM/TFMを利用し，カーニング情報を与えれば，
    ボディ情報を視覚化したfont fileを作成可能
  - PFB/PFA/PFM -> AFM: pf2afm (exist in ghostscript)
  - AFM -> EPS: afm2eps (target!)
- afm2body
  - FontForgeを利用して，作成したEPSを配置し，
    AFM/TFMからカーニング情報を与える
