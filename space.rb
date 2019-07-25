require 'gosu'
# do some Zorder constant stuff
module ZOrder
  BACKGROUND, STARS,PLAYER,UI = *0..6
end
# class for the main window
class Tutorial < Gosu::Window
    def initialize
        super 640,580
        
        self.caption = "Carlos in Space Game"
        @background_image = Gosu::Image.new("media/space.png", :tileable => true)

        @player = Player.new
        @player.warp(320, 240)
         
        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        @stars = Array.new
        @font = Gosu::Font.new(30)
        @playing = true
        @start_time = 0
    end
    def update
      if @playing
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
          @player.turn_left
        end

        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
          @player.turn_right
        end

        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
          @player.accelerate
        end

      
        @player.move
        @player.collect_stars(@stars)
        @time_left = (30 - ((Gosu.milliseconds - @start_time) / 1000))
      end
        if rand(100) < 4 and @stars.size < 55
          @stars.push(Star.new(@star_anim))
        end
        
        @playing = false if @time_left < 1
    end
  
    def draw
      @player.draw
      @background_image.draw(0, 0,ZOrder::BACKGROUND)
      @stars.each { |star| star.draw }
      @font.draw("SCORE: #{@player.score}", 10, 520, ZOrder::UI, 1.0, 1.0,)
      @font.draw("TIME: #{@time_left.to_s}", 500, 520, 3)
      unless @playing
        @font.draw("GAME OVER LITTLE FOOT", 150, 150, 3)
        @font.draw("Press Space Bar to Continue", 150, 350, 3)
      end
    end

    def button_down(id)
          
              if id == Gosu::KB_ESCAPE
                close
              else
                super
              end
            end
          
        if @playing
            if id == Gosu::KB_SPACE
                        self.caption = "Carlos in Space Game"
                        @background_image = Gosu::Image.new("media/space.png", :tileable => true)
                
                        @player = Player.new
                        @player.warp(320, 240)
                        
                        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
                        @stars = Array.new
                        @font = Gosu::Font.new(30)
                        @playing = true
                        @start_time = 0
            else
              super
             end
            end 
          # end  
     end

#  Our main player class

class Player
  attr_reader :score
    def initialize
      @image = Gosu::Image.new("media/starfighter.bmp")
      @beep = Gosu::Sample.new("media/beep.wav")
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @score = 0
    end
  
    def warp(x, y)
      @x, @y = x, y
    end
    
    def turn_left
      @angle -= 4.5
    end
    
    def turn_right
      @angle += 4.5
    end
    
    def accelerate
      @vel_x += Gosu.offset_x(@angle, 0.5)
      @vel_y += Gosu.offset_y(@angle, 0.5)
    end
    
    def move
      @x += @vel_x
      @y += @vel_y
      @x %= 640
      @y %= 480
      
      @vel_x *= 0.95
      @vel_y *= 0.95
    end

   
  
    def draw
      @image.draw_rot(@x, @y, 2, @angle)
    end
    def score
      @score
    end
    def collect_stars(stars)
      stars.reject! do |star|
          if Gosu.distance(@x, @y, star.x, star.y) < 35
            @score += 1
            @beep.play
            true
            else
              false
            end
       end
     end
    end
  # end

  #  do some z order constant stuff
 

# add some big star animations
class Star
  attr_reader :x, :y 

    def initialize(animation)
      @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 60) + 20
    @color.green = rand(256 - 50) + 30
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
    end

    def draw
      img = @animation[Gosu.milliseconds / 350 % @animation.size]
    img.draw(@x - img.width / 1.0, @y - img.height / 1.0,
        ZOrder::STARS, 1.1, 1.1, @color, :add)
    end
end



  # module ZOrder
  #   BACKGROUND, STARS,PLAYER,UI = "0..3"
  # end


    Tutorial.new.show
