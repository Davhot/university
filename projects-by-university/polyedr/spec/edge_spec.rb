require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

describe Edge do

  context "r3" do

    it "одномерной координате 0.0 соответствует начало ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      expect(s.beg).to be_close_to(s.r3(0.0))
    end
    
    it "одномерной координате 1.0 соответствует конец ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      expect(s.fin).to be_close_to(s.r3(1.0))
    end
    
    it "одномерной координате 0.5 соответствует середина ребра" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      expect(R3.new(0.5,0.0,-1.0)).to be_close_to(s.r3(0.5))
    end
    
  end

  context "intersect_edge_with_normal" do
    # метод intersect_edge_with_normal всегда возвращает одномерный отрезок!

    it "если ребро принадлежит полупространству, то пересечение - весь отрезок" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      expect(s.send(:intersect_edge_with_normal, a,n)).to be_close_to(Segment.new(0.0,1.0))
    end

    it "если ребро лежит вне полупространства, то пересечение пусто" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,1.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      expect(s.send(:intersect_edge_with_normal,a,n)).to be_degenerate
    end

    it "если ребро принадлежит плоскости, ограничивающей полупространство, то пересечение пусто" do
      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,0.0,0.0))
      a = R3.new(0.0,0.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      expect(s.send(:intersect_edge_with_normal,a,n)).to be_degenerate
    end

    it "здесь только первая половина отрезка принадлежит полупространству" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,1.0))
      a = R3.new(1.0,1.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      expect(s.send(:intersect_edge_with_normal,a,n)).to be_close_to(Segment.new(0.0,0.5))
    end

    it "здесь только вторая половина отрезка принадлежит полупространству" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,0.0,-1.0))
      a = R3.new(1.0,1.0,0.0)
      n = R3.new(0.0,0.0,1.0)
      expect(s.send(:intersect_edge_with_normal,a,n)).to be_close_to(Segment.new(0.5,1.0))
    end

  end

  context "shadow" do

    it "грань не затеняет ребра, принадлежащего этой же грани" do
      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      expect(s.gaps.size).to be(1)
    end

    it "грань не затеняет ребра, расположенного выше грани" do
      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      expect(s.gaps.size).to be(1)
    end

    it "грань полностью затеняет ребро, расположенное ниже грани" do
      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      expect(s.gaps.size).to be(0)
    end

    it "на большом и длинном ребре, лежащем ниже грани, образуется ровно два просвета" do
      s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      s.shadow(f)
      expect(s.gaps.size).to be(2)
    end

  end
end
