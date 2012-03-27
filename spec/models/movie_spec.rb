require 'spec_helper'

describe Movie,"find_with_same_director" do
  before :each do 
    @simular_to_movie = FactoryGirl.create(:movie)
    FactoryGirl.create(:movie,:title => 'Indiana Jones')
    FactoryGirl.create(:movie, :title => 'Filmmaker')
    @non_lucas_movies = FactoryGirl.create(:movie,:director => 'John Howard')
  end
  describe "find with existing director" do
    before :each do 
      @movies_with_same_director = Movie.find_with_same_director(@simular_to_movie)
    end
    it "returns movies with same director" do
      @movies_with_same_director.should have(2).movies
    end
    it "does not return movies with different director" do
      @movies_with_same_director.should_not include @non_lucas_movies
    end
    it "does not return the actualy movie used for search" do
      @movies_with_same_director.should_not include @simular_to_movie
    end
  end
  describe "find with non existing director" do
    it "returns nil if no director information on current movie" do
      movie_without_director = FactoryGirl.create(:movie, :director => nil)
      movies = Movie.find_with_same_director(movie_without_director)
      movies.should == nil
    end
  end
end
