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
- **<- 今ここ**
- ライフクラスの定義と表示
- ゲーム開始/リスタートのシーンの実装
- タップではなく tilt でキャッチャーを動かすクラスの実装
- レベル概念の導入
- Lv.2 でうんこの落ちてくる頻度が上がる
- Lv.3 で風が吹いてくる
- 各レベルの実装

## Memo
- SKSpriteNode の custom class を作る際のイニシャライザについて 
- ``init(texture: SKTexture!, color: UIColor!, size: CGSize)`` is the only designated initializer in the SKSpriteNode class, the rest are all convenience initializers, so you can't call super on them.
- Answer: Should call the designated initializer above in your custom init(), with overriding the init?(coder) which is required for NSCoder protocol.
- See also ``ShitNode.swift``
- 例: 
```swift
init() {
let texture = SKTexture(imageNamed: "shit")
super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
}
```
- escaping closure の相互参照について調べる
