##ボウリングのスコアを管理するクラス
class Bowling
  def initialize
    #スコアの合計
    @total_score=0
    #全体のスコアを格納する配列
    @scores=[]
    #一時保存用の配列
    @temp=[]
  end

  #スコアの合計を返す
  def total_score
    @total_score
  end

  #スコアを追加する
  def add_score(pins)
    #一時保存用のスコアに、倒したピンの数を追加する
    @temp << pins
    #2投分のデータが入っていれば、１フレーム分のスコアとして全体に追加する。１投目がストライクの場合１フレーム分のスコアとして全体に参加します
    if @temp.size == 2 || strike?(@temp)
      @scores << @temp
      @temp = []
    end
  end

  #スコアの合計を計算
  def calc_score
    @scores.each.with_index(1) do |score,index|
      #最終フレーム以外のストライクなら、スコアにボーナスを含めて計算する
      if strike?(score) && not_last_frame?(index)
        @total_score += calc_strike_bonus(index)
        #最終フレーム以外のスペアなら、スコアにボーナスを含めて合計する
      elsif spare?(score) && not_last_frame?(index)
        @total_score += calc_spare_bonus(index)
      else
        @total_score += score.inject(:+)
      end
    end
  end

  private
  #スペアか判別
  def spare?(score)
    score.inject(:+) == 10
  end
  #最終フレームか判別する
  def not_last_frame?(index)
    index < 10
  end

  def strike?(score)
    score.first == 10
  end

  #スペアボーナスを含んだ値でスコアを計算するa
  def calc_spare_bonus(index)
    10 + @scores[index].first
  end
  #ストライクボーナスを含んだ値でスコアを計算す
  def calc_strike_bonus(index)
    #次のフレームもストライクで、なおかつ最終フレーム以外なら
    #もう一つ次のフレームの１投目をボーナスの対象にする
    if strike?(@scores[index]) && not_last_frame?(index+1)
      20 + @scores[index + 1].first
    else
      10+ @scores[index].inject(:+)
    end
  end
end
