require 'rspec'
require_relative '../r2point'

describe R2Point do

  EPS = 1.0e-12

  context "Расстояние dist" do

    it "от точки до самой себя равно нулю" do
      a = R2Point.new(1.0,1.0)
      expect(a.dist(R2Point.new(1.0,1.0))).to be_within(EPS).of(0.0) 
    end

    it "от одной точки до отличной от неё другой положительно" do
      a = R2Point.new(1.0,1.0)
      expect(a.dist(R2Point.new(1.0,0.0))).to be_within(EPS).of(1.0) 
      expect(a.dist(R2Point.new(0.0,0.0))).to be_within(EPS).of(Math.sqrt(2.0)) 
    end

  end

  context "Площадь area" do

    let(:a) { R2Point.new(0.0,0.0)  }
    let(:b) { R2Point.new(1.0,-1.0) }
    let(:c) { R2Point.new(2.0,0.0)  }

    it "равна нулю, если все вершины совпадают" do
      expect(R2Point.area(a,a,a)).to be_within(EPS).of(0.0)
    end

    it "равна нулю, если вершины лежат на одной прямой" do
      b = R2Point.new(1.0,0.0)
      expect(R2Point.area(a,b,c)).to be_within(EPS).of(0.0)
    end

    it "положительна, если обход вершин происходит против часовой стрелки" do
      expect(R2Point.area(a,b,c)).to be_within(EPS).of(1.0)
    end

    it "отрицательна, если обход вершин происходит по часовой стрелки" do
      expect(R2Point.area(a,c,b)).to be_within(EPS).of(-1.0)
    end

  end
  
  context "inside? для прямоугольника с вершинами (0,0) и (2,1) утверждает:" do

    let(:a) { R2Point.new(0.0,0.0) }
    let(:b) { R2Point.new(2.0,1.0) }

    it "точка (1,0.5) внутри" do
      expect(R2Point.new(1.0,0.5).inside?(a,b)).to be true
    end

    it "точка (1,0.5) внутри" do
      expect(R2Point.new(1.0,0.5).inside?(b,a)).to be true
    end

    it "точка (1,1.5) снаружи" do
      expect(R2Point.new(1.0,1.5).inside?(a,b)).to be false
    end

    it "точка (1,1.5) снаружи" do
      expect(R2Point.new(1.0,1.5).inside?(b,a)).to be false
    end

  end

  context "light? для ребра с вершинами (0,0) и (1,0) утверждает:" do

    let(:a) { R2Point.new(0.0,0.0) }
    let(:b) { R2Point.new(1.0,0.0) }

    it "из точки (0.5,0.0) оно не освещено" do
      expect(R2Point.new(0.5,0.0).light?(a,b)).to be false
    end

    it "из точки (0.5,-0.5) оно освещено" do
      expect(R2Point.new(0.5,-0.5).light?(a,b)).to be true
    end

    it "из точки (2.0,0.0) оно освещено" do
      expect(R2Point.new(2.0,0.0).light?(a,b)).to be true
    end

    it "из точки (0.5,0.5) оно не освещено" do
      expect(R2Point.new(0.5,0.5).light?(a,b)).to be false
    end

    it "из точки (-1.0,0.0) оно освещено" do
      expect(R2Point.new(-1.0,0.0).light?(a,b)).to be true
    end

  end

end  
