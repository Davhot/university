require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

class R3

  def collinear?(other)
    t = dot(other)/Math.sqrt(x*x+y*y+z*z)/
            Math.sqrt(other.x**2+other.y**2+other.z**2)
    (t-1).abs < EPS
  end

end

class Facet
  # метод для обеспечения вызова private метода center
  def c; center end
end

describe Facet do

  context "vertical" do

    it "эта грань не является вертикальной" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
      expect(f).not_to be_vertical
    end
    
    it "эта грань вертикальна" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,0.0,1.0),
                   R3.new(1.0,0.0,0.0)])
      expect(f).to be_vertical
    end

  end

  context "h_normal" do

    it "нормаль к этой грани направлена вертикально вверх" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
	   expect(f.h_normal).to be_collinear(R3.new(0.0,0.0,1.0))
    end

    it "нормаль к этой грани тоже направлена вертикально вверх!" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(0.0,3.0,0.0),
                   R3.new(3.0,0.0,0.0)])
      expect(f.h_normal).to be_collinear(R3.new(0.0,0.0,1.0))
    end

    it "для нахождения нормали к этой грани рекомендуется нарисовать картинку" do
      f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                   R3.new(0.0,0.0,1.0)])
      expect(f.h_normal).to be_collinear(R3.new(1.0,1.0,1.0))
    end

  end

  context "v_normals" do
    # для каждой из следующих граней сначала "вручную" находятся
    # внешние нормали к вертикальным плоскостям, проходящим через
    # рёбра заданной грани, а затем проверяется, что эти нормали
    # имеют то же направление, что и вычисляемые методом v_normals

    it "нормали для треугольной грани" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),R3.new(0.0,3.0,0.0)])
      normals = [R3.new(-1.0,0.0,0.0), R3.new(0.0,-1.0,0.0),R3.new(1.0,1.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        expect(arr[0]).to be_collinear(arr[1])
      end
    end

    it "нормали для квадратной грани" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      normals = [R3.new(-1.0,0.0,0.0),R3.new(0.0,-1.0,0.0),
                 R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        expect(arr[0]).to be_collinear(arr[1])
      end
    end

    it "нормали для ещё одной треугольной грани" do
      f=Facet.new([R3.new(1.0,0.0,0.0),R3.new(0.0,1.0,0.0),
                   R3.new(0.0,0.0,1.0)])
      normals = [R3.new(0.0,-1.0,0.0), R3.new(1.0,1.0,0.0),R3.new(-1.0,0.0,0.0)]
      f.v_normals.zip(normals) do |arr|
        expect(arr[0]).to be_collinear(arr[1])
      end
    end

  end

  context "center" do

    it "центр квадрата" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      expect(R3.new(1.0,1.0,0.0)).to be_close_to(f.c)
    end

    it "центр треугольника" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
      expect(R3.new(1.0,1.0,0.0)).to be_close_to(f.c)
    end

  end
end
