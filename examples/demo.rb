#!/usr/bin/env ruby
require 'rubygems'
require 'gosu'
require 'yaml'
require 'tempfile'
require 'base64'
require 'tween'

module Z
  Background, Graph, Text, Ball = (1..100).to_a
end

class MyWindow < Gosu::Window
  WIDTH = 640
  HEIGHT = 480
  TITLE = "Tween Demo"

  TOP_COLOR = Gosu::Color.new(0xFFF5F5F5)
  BOTTOM_COLOR = Gosu::Color.new(0xFFBEBEBE)
  GRAPH_COLOR = Gosu::Color::BLACK

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = TITLE

    @last_frame = Gosu::milliseconds
    @ball = Gosu::Image.new(self, "#{__dir__}/ball.png", false)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @smallfont = Gosu::Font.new(self, Gosu::default_font_name, 15)

    @x, @y = width / 2, height / 2
    @tween = nil
    @easer = Tween::EASERS[0]

    begin
      require 'gl'

      Gl.glEnable(Gl::GL_LINE_SMOOTH)
      Gl.glHint(Gl::GL_LINE_SMOOTH_HINT, Gl::GL_NICEST)
    rescue LoadError
    end
  end

  def update
    calculate_delta
  end

  def calculate_delta
    @this_frame = Gosu::milliseconds
    @delta = (@this_frame - @last_frame) / 1000.0

    # Update game objects here
    unless @tween.nil? or @tween.done
      @tween.update(@delta)
      @x, @y = @tween.x, @tween.y
    end

    @last_frame = @this_frame
  end

  def draw
    draw_background
    draw_graph
    draw_easer_name
    draw_instructions
    draw_ball
  end

  def draw_ball
    @ball.draw(
      @x - (@ball.width / 2),
      @y - (@ball.height / 2),
      Z::Ball
    )
  end

  def draw_background
    draw_quad(
      0,     0,      TOP_COLOR,
      WIDTH, 0,      TOP_COLOR,
      0,     HEIGHT, BOTTOM_COLOR,
      WIDTH, HEIGHT, BOTTOM_COLOR,
      Z::Background)
  end

  def draw_graph
    left = width * 0.2
    right = left + width * 0.6
    bottom = height * 0.8
    top = bottom - height * 0.6

    draw_line(
      left, top, GRAPH_COLOR,
      left, bottom + 20, GRAPH_COLOR,
      Z::Graph
    )

    draw_line(
      left - 20, bottom, GRAPH_COLOR,
      right, bottom, GRAPH_COLOR,
      Z::Graph
    )

    graph = (0..100).map do |idx|
      @easer.ease(idx, bottom, top - bottom, 100.0)
    end

    (1..99).map do |idx|
      draw_line(
        left + Tween::Linear.ease(idx - 1, 0, right - left, 100),
        graph[idx - 1],
        GRAPH_COLOR,

        left + Tween::Linear.ease(idx, 0, right - left, 100),
        graph[idx],
        GRAPH_COLOR,

        Z::Graph
      )
    end
  end

  def draw_easer_name
    @font.draw(
      @easer.to_s,
      10, 10, Z::Text,
      1.0, 1.0,
      GRAPH_COLOR
    )
  end

  def draw_instructions
    @smallfont.draw(
      "Click to move globe, press left and right to change easer",
      20, height - 20, Z::Text,
      1.0, 1.0,
      GRAPH_COLOR
    )
  end


  def needs_cursor?
    true
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      @tween = Tween.new(
        [@x.to_f, @y.to_f],
        [mouse_x.to_f, mouse_y.to_f],
        @easer,
        1
      )

    when Gosu::KbEscape
      close

    when Gosu::KbRight
      next_easer

    when Gosu::KbLeft
      last_easer
    end
  end


  def next_easer
    idx = Tween::EASERS.index(@easer) + 1

    if idx == Tween::EASERS.length
      idx = 0
    end

    @easer = Tween::EASERS[idx]
  end

  def last_easer
    idx = Tween::EASERS.index(@easer) - 1

    if idx == -1
      idx = Tween::EASERS.length - 1
    end

    @easer = Tween::EASERS[idx]
  end
end

MyWindow.new.show
