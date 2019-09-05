require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'


describe Segment do

  context "degenerate?" do

    it "отрезок [0,1] является невырожденным" do
      expect(Segment.new(0.0, 1.0)).not_to be_degenerate
    end

    it "отрезок [0,0] является вырожденным" do
      expect(Segment.new(0.0, 0.0)).to be_degenerate
    end

    it "отрезок [0,-1] является вырожденным" do
      expect(Segment.new(0.0, -1.0)).to be_degenerate
    end

  end

  context "intersect!" do
    
    it "пересечение отрезка с самим собой даёт его же" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 1.0)
      c = Segment.new(0.0, 1.0)
      expect(a.intersect!(b)).to be_close_to(c)
    end
    
    it "пересечение меньшего отрезка с большим даёт меньший" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 2.0)
      c = Segment.new(0.0, 1.0)
      expect(a.intersect!(b)).to be_close_to(c)

      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 2.0)
      expect(b.intersect!(a)).to be_close_to(c)
    end

    it "пересечение коммутативно" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 2.0)
      c = Segment.new(0.0, 1.0)
      d = Segment.new(0.0, 2.0)
      expect(a.intersect!(b)).to be_close_to(d.intersect!(c))

      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.5, 1.0)
      c = Segment.new(0.0, 1.0)
      d = Segment.new(0.5, 1.0)
      expect(a.intersect!(b)).to be_close_to(d.intersect!(c))

      a = Segment.new(0.0, 1.0)
      b = Segment.new(-0.5, 0.0)
      c = Segment.new(0.0, 1.0)
      d = Segment.new(-0.5, 0.0)
      expect(a.intersect!(b)).to be_close_to(d.intersect!(c))

      a = Segment.new(0.0, 1.0)
      b = Segment.new(-0.5, -0.1)
      c = Segment.new(0.0, 1.0)
      d = Segment.new(-0.5, -0.1)
      expect(a.intersect!(b)).to be_close_to(d.intersect!(c))
    end

  end

  context "subtraction" do
    # разность двух отрезков всегда массив из двух отрезков!

    it "разность отрезка с самим собой - два вырожденных отрезка" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 1.0)
      expect(a.subtraction(b).all?{|s| s.degenerate?}).to be true
    end

    it "для двух отрезков с совпадающим началом вычитание из большего отрезка меньшего порождает один вырожденный и один невырожденный отрезок" do
      a = Segment.new(0.0, 2.0)
      b = Segment.new(0.0, 1.0)
      expect(a.subtraction(b).any?{|s| s.degenerate?}).to be true
      expect(a.subtraction(b).any?{|s| !s.degenerate?}).to be true
    end

    it "для двух отрезков с различными концами таких, что один из них содержится внутри другого, вычитание из большего отрезка меньшего порождает два невырожденных отрезка" do
      a = Segment.new(-1.0, 2.0)
      b = Segment.new(0.0, 1.0)
      expect(a.subtraction(b).all?{|s| !s.degenerate?}).to be true
    end

    it "для двух отрезков с различными концами таких, что один из них содержится внутри другого, вычитание из меньшего отрезка большего порождает два вырожденных отрезка" do
      a = Segment.new(-1.0, 2.0)
      b = Segment.new(0.0, 1.0)
      expect(b.subtraction(a).all?{|s| s.degenerate?}).to be true
    end

    it "если из отрезка вычесть две его половинки, то получатся только вырожденные отрезки" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 0.5)
      c = Segment.new(0.5, 1.0)
      expect(a.subtraction(b).map{|s| s.subtraction(c)}.flatten.all? do |s|
        s.degenerate?
      end).to be true
    end

    it "если из отрезка вычесть его половинку, а затем ещё один небольшой отрезочек, то невырожденным будет только один из итоговых отрезков" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.0, 0.5)
      c = Segment.new(0.6, 1.0)
      expect(a.subtraction(b).map{|s| s.subtraction(c)}.flatten.find_all do |s|
        !s.degenerate?
      end.size).to be(1)
    end

    it "если из отрезка вычесть два небольших отрезочка, то невырожденными будут все три итоговых отрезка" do
      a = Segment.new(0.0, 1.0)
      b = Segment.new(0.1, 0.2)
      c = Segment.new(0.4, 0.8)
      expect(a.subtraction(b).map{|s| s.subtraction(c)}.flatten.find_all do |s|
        !s.degenerate?
      end.size).to be(3)
    end

  end
end    
