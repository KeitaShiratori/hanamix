class BallsController < ApplicationController
  def create
    north = params[:north]
    south = params[:south]
    east  = params[:east]
    west  = params[:west]
    
    puts "north ~ south: #{south} ~ #{north}"
    puts "west  ~ east : #{west} ~ #{east}"

    # ボールの座標をランダムに生成し、DBに登録する。
    for i in 1..7
      Ball.new do |b|
        b.title       = NAME[i][1]
        b.description = NAME[i][2]
        b.latitude    = random_pos(north, south)
        b.longitude   = random_pos(east, west)
  
        # b.save!
        puts b.inspect
      end
    end
  end

  def edit
  end

  def delete
  end

  def show
  end
  
private 
  def random_pos(a1, a2)
    r = rand()
    ret = a1.to_f * r + a2.to_f * (1 - r)
  end


end
