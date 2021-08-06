require "bowling"

describe "ボリングのスコア計算" do
  #インスタンスの生成を共通化
  before do
    @game = Bowling.new
  end
  describe "全体の合計" do
    context "全ての投球がガターだった場合" do
      it "0になること" do
        add_many_scores(20,0)
        expect(@game.total_score).to eq 0
      end
    end
    context "全ての投球で1ピンずつ倒した場合" do
      it "20になること" do
        add_many_scores(20, 1)
        #ごうけい計算
        @game.calc_score
        expect(@game.total_score).to eq 20
      end
    end
    context "スペアを取った場合" do
      it "スペアボーナスが加算されること" do
        #第一フレームで３点、７点のスペア
        @game.add_score(3)
        @game.add_score(7)
        #第二フレームの一投目で４点
        @game.add_score(4)
        #以降は全てガター
        add_many_scores(17,0)
        #合計を計算
        @game.calc_score
        #期待する合計値※()内はボーナス点
        #3+7+4+(4)=18
        expect(@game.total_score).to eq 18
      end
    end
    context "フレーム違いでスペアを取った場合" do
      it "スペアボーナスが加算されないこと" do
        #第一フレームで３点、５点
        @game.add_score(3)
        @game.add_score(5)
        #第二フレームで５点、４点
        @game.add_score(5)
        @game.add_score(4)
        #以降は全てガター
        add_many_scores(16,0)
        #合計を計算
        @game.calc_score
        #期待する合計
        #3 + 5 + 5 + 4 =17
        expect(@game.total_score).to eq 17
      end
    end
    context "最終フレームでスペアをとった場合"do
      it"スペアボーナスが加算されない事" do
        #第一フレームで3点7点のスペア
        @game.add_score(3)
        @game.add_score(7)
        #第二フレームの一投目で４点
        @game.add_score(4)
        #15投は全てガター
        add_many_scores(15,0)
        #最終フレームで3点、７点のスペア
        @game.add_score(3)
        @game.add_score(7)
        #合計を計算
        @game.calc_score
        #期待する合計値※()内はボーナス
        #3+7+4+(4)+3+7=28
        expect(@game.total_score).to eq 28
      end
    end
    context "ストライクをとった場合"do
       it"ストライクボーナスが加算されない事" do
         #第一フレームでストライク
         @game.add_score(10)
         #第二フレームので４四点
         @game.add_score(5)
         @game.add_score(4)
         #以降は全てガタ-
         add_many_scores(16,0)
         #合計を計算
         @game.calc_score
         #期待する合計値※()内はボーナス
         #10+5+(5)+4+(4)=28
         expect(@game.total_score).to eq 28
       end
    end
    context "ダブルを取った場合" do
       it"それぞれのストライクボーナスが加算されること"do
         #第一フレームでストライク
         @game.add_score(10)
         ##第二フレームもストライク
         @game.add_score(10)
         #第二フレームので54
         @game.add_score(5)
         @game.add_score(4)
         #以降は全てガタ-
         add_many_scores(16,0)
         #合計を計算
         @game.calc_score
         #期待する合計値※()内はボーナス
         #10+10+10+5+5+5+4+4=53
         expect(@game.total_score).to eq 53
       end
    end

    context "ターキーを取った場合" do
       it"それぞれのストライクボーナスが加算されること"do
         #第一フレームでストライク
         @game.add_score(10)
         ##第二フレームもストライク
         @game.add_score(10)
         ##第二フレームもストライく
         @game.add_score(10)

         #第二フレームので54
         @game.add_score(5)
         @game.add_score(4)
         #以降は全てガタ-
         add_many_scores(12,0)
         #合計を計算
         @game.calc_score
         #期待する合計値※()内はボーナス
         #10+10+10+5+5+5+4+4=53
         expect(@game.total_score).to eq 83
       end
    end

    context "最終フレームでストライクを取った場合" do
      it "ストライクボーナスが加算されないこと" do
         #第一フレームでストライク
         @game.add_score(10)
         #第二フレームので４四点
         @game.add_score(5)
         @game.add_score(4)
         #以降はガタ-
         add_many_scores(14,0)
         #最終フレームでストライク
         @game.add_score(10)
         #合計を計算
         @game.calc_score
         #予想値：３８
         expect(@game.total_score).to eq 38
      end
    end
  end
end
private
# 複数回のスコア追加をまとめて実行する
def add_many_scores(count, pins)
    count.times do
      @game.add_score(pins)
    end
end


