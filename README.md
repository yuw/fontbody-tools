fontbody-tools
==============

- afm2eps.rb
  - AFMファイルから各文字の
    baseline付きバウンディングボックスを表現したEPSファイルを生成
- afm2bbox.rb
  - FontForgeを利用して，作成したEPSを配置し，
    AFM/TFMからカーニング情報を与える

- afm2veps.rb
  - AFMファイルから各文字の
    baseline付き仮想ボディを表現したEPSファイルを生成
- afm2vbody.rb
  - FontForgeを利用して，作成したEPSを配置し，
    AFM/TFMからカーニング情報を与える

- PFB/PFA/PFM -> AFM: pf2afmは例えばghostscriptのスクリプトがある
