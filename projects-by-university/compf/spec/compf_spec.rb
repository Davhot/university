require 'rspec'
require_relative '../compf'

describe 'Компилятор формул' do
  let(:compf) { Compf.new }
  
  context 'один символ' do
    it 'a -> a' do
      expect(compf.compile('a')).to eq 'a'
    end
    
    it '+ -> +' do
      expect(compf.compile('+')).to eq '+'
    end
  end
  
  context 'допустимые операции' do
    it 'a+b -> a b +' do
      expect(compf.compile('a+b')).to eq 'a b +'
    end
    it 'a-b -> a b -' do
      expect(compf.compile('a-b')).to eq 'a b -'
    end
    it 'a*b -> a b *' do
      expect(compf.compile('a*b')).to eq 'a b *'
    end
    it 'a/b -> a b /' do
      expect(compf.compile('a/b')).to eq 'a b /'
    end
  end

  context 'порядок операций' do
    it 'a+c*b -> a c b * +' do
      expect(compf.compile('a+c*b')).to eq 'a c b * +'
    end

    it 'a*b/c -> a b * c /' do
      expect(compf.compile('a*b/c')).to eq 'a b * c /'
    end

    it 'a*(b/c) -> a c b / *' do
      expect(compf.compile('a*(b/c)')).to eq 'a b c / *' 
    end
  end

  context 'скобки' do
    it '(a) -> a' do
      expect(compf.compile('(a)')).to eq 'a'
    end

    it '(((((a)))) -> a' do 
      expect(compf.compile('(((((a))))')).to eq 'a'
    end

    it '(((((a+b)))) -> a b +' do
      expect(compf.compile('(((((a+b))))')).to eq 'a b +'
    end

    it '(((((((a+b)*((a+b))))))) -> a b + a b + *' do
      expect(compf.compile('(((((((a+b)*((a+b)))))))')).to eq 'a b + a b + *'
    end
  end

  context 'выражения' do
    it '(a+b)*c+(d-e)/f -> a b + c * d e - f / +' do
      expect(compf.compile('(a+b)*c+(d-e)/f')).to eq 'a b + c * d e - f / +'
    end

    it 'c*(c+c+c+c/(c-c-c-c)) -> c c c + c + c c c - c c - / *' do
      expect(compf.compile('c*(c+c+c+c/(c-c-c-c))')).to eq 'c c c + c + c c c - c - c - / + *'
    end
    
    it 'a/b*c+d*e/(f+g) -> a b / c * d e * f g + / +' do
      expect(compf.compile('a/b*c+d*e/(f+g)')).to eq 'a b / c * d e * f g + / +'
    end

    it 'a/b*(c+d*e)/(f+g) -> a b / c d e * + * f g + /' do
      expect(compf.compile('a/b*(c+d*e)/(f+g)')).to eq 'a b / c d e * + * f g + /'
    end

    it 'a+b*(c-d)*(c+(d-e)/a)/a -> a b c d - * c d e - a / + * a / +' do
      expect(compf.compile('a+b*(c-d)*(c+(d-e)/a)/a')).to eq 'a b c d - * c d e - a / + * a / +'
    end

    it '(c+(c*(c+(c+c/c))))/(c+c) -> c c c c c c/ + + * + c c + /' do
      expect(compf.compile('((c+(c*(c+(c+c/c)))))/(c+c)')).to eq 'c c c c c c / + + * + c c + /'
    end

    it 'c+(c+(c*(c+(c/(c*(c+c)))))) -> c c c c c c c + * / + * + +' do
      expect(compf.compile('c+(c+(c*(c+(c/(c*(c+c))))))')).to eq 'c c c c c c c c + * / + * + +'
    end
  end

end