# CatcherInTheToilet

## 概要
iOS アプリ開発の練習に、うんこをキャッチするゲームを３日で作る。

## 環境
- Swift 4.2
- Xcode 10.0

## 目的
- SpriteKit の習得
- ゲームの設計パターンについて考えるため

## 気をつける点
- クオリティが低くてもいいので、３日でできるところまで作る
- ゲーム開発の設計パターンに慣れていないため、悩んだらまずは実装を書いてみて、後からリファクタリングする
- 今回はあまり時間をとれないので、３日でできなかったら４日に伸ばす

## タスクリスト
### Day1
- 背景画像の設定
- ゲーム状態クラスの定義
- キャッチャーの Node クラスの定義
- ユーザー入力クラスの実装
- ユーザー入力をゲーム内の動きに変換するプロトコル・クラスの定義
- タップで動くクラスを作る
- キャッチャーの動きに結びつける
- うんこの Node クラスの定義
- うんこの状態を enum で定義
- .falling と .dropped と .disappearing

### Day2
- うんこがランダムに落ちてくる処理を実装
- レベル別に処理を変えれるように、うんこジェネレーターを作っておく
- うんことキャッチャーの衝突処理
- うんこと地面の衝突処理

### Day3
- うんこ消滅のアニメーションの実装
- スコアクラスの定義と表示
- 実況コメントを流す

### できなかったこと
- 効果音・BGM
- うんこキャッチ時のエフェクト
- うんこ消滅時のエフェクト
- ライフクラスの定義と表示
- BEST SCORE の記録と表示
- ゲーム開始/リスタートのシーンの実装
- タップではなく tilt でキャッチャーを動かすクラスの実装
- レベル概念の導入
- Lv.2 でうんこの落ちてくる頻度が上がる
- Lv.3 で風が吹いてくる
- 各レベルの実装

## 総括
- 3日で作るには少し無理があった
- 優先順位のアジールな変更は、比較的にできた
- SKNode 系のカスタムクラスにロジックを書くとクラスが肥大化し、テスタビリティがなくなるため、できるだけロジックを別クラスに分離するのがよいということを学んだ
- SKNode 系統のカスタムクラスになんでも書いてしまうと、 Rails で model にDB操作とビジネスロジックが混合状態になっているのを見たときのような気持ちになってしまう
- 理想的にはそうだが、実際には分離できていない部分が多々あるため、理想状態に近づけるためには、さらなるリファクタリングが必要である
- SKNode 系のオブジェクトをそのまま別クラスに参照渡ししている箇所が多々残っているが、すべてプロトコルに変更すべきである
- オブジェクトを大量生成する箇所ではオブジェクトプールに変更する必要がある
- また、メモリ溢れ出しを防ぐためのテストも必要である
- うんことコメントを生成する処理に関しては、さらなる分離と、ゴミが残らないか検証するテストが必須である。配列からの削除を忘れると悲惨なことになる。
- 開発しながら、テレビドラマ『逃げるは恥だが役に立つ』を見てたら、面白すぎてなかなか開発に集中できなくなった
