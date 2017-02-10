require 'rails_helper'

describe Division do
  let(:valid_attributes) { FactoryGirl.attributes_for(:division) }
  
  describe "Translation" do
    it "should default to assigning values for locale :en" do
      @division = Division.create!(valid_attributes)
      
      I18n.with_locale(:en) do
        expect(@division.name).to be_truthy
        expect(@division.short_name).to be_truthy
      end
      
      I18n.with_locale(:es) do
        expect(@division.name).to be_nil
        expect(@division.short_name).to be_nil
      end
    end
    
    it "should allow assignment in other locales" do
      I18n.with_locale(:es) { @division = Division.create!(valid_attributes) }

      I18n.with_locale(:en) do
        expect(@division.name).to be_nil
        expect(@division.short_name).to be_nil
      end
      
      I18n.with_locale(:es) do
        expect(@division.name).to be_truthy
        expect(@division.short_name).to be_truthy
      end
    end
    
    it "should allow differing assignments in differing locales" do
      @division = Division.create!(colour1: "red", colour2: "white", name: "International Union of Food, Agricultural, Hotel, Restaurant, Catering, Tobacco and Allied Workers' Associations", short_name: "IUF")
      @division.attributes = { locale: :es, name: "Unión Internacional de Trabajadores de la Alimentación, Agrícolas, Hoteles, Restaurantes, Tabaco y Afines", short_name: "UITA" }
      
      I18n.with_locale(:en) { expect(@division.short_name).to eq("IUF") }
      I18n.with_locale(:es) { expect(@division.short_name).to eq("UITA") }
    end
  end
end
