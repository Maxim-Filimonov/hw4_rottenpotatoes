require 'spec_helper'

describe MoviesController do
  describe 'find movies with same director' do
    before :each do 
      @mock_movie = FactoryGirl.build(:movie)
      Movie.stub(:find).and_return(@mock_movie)
      @fake_results = [mock('Movie'),mock('Movie')]
    end
    it 'should call the model method to find movies with same director' do
      Movie.should_receive(:find_with_same_director).with(@mock_movie)
      get :with_same_director, :id => 10
    end 
    describe 'when model returned nil' do
      before :each do
        Movie.stub(:find_with_same_director).and_return(nil)
      end
      it 'should redirect to home page if nil returned' do
        get :with_same_director, :id => 10
        response.should redirect_to(movies_path)
      end
      it 'should display notice to a user' do
        movie = Movie.new :title => 'title'
        Movie.stub(:find).and_return(movie)
        get :with_same_director, :id => 10
        flash[:warning].should == "'title' has no director info"
      end
    end
    describe 'after same director movie founds' do
      before :each do 
        Movie.stub(:find_with_same_director).with(anything).and_return(@fake_results)
        get :with_same_director, :id => 10
      end
      it 'should select with same director view for rendering' do
        response.should render_template 'with_same_director'
      end
      it 'should make movies available to the view' do
        assigns(:movies).should == @fake_results
      end
    end
  end
  describe 'movie creation' do
    before :each do
      post :create, :movie => {:title => 'test'}
    end
    it "should create new movie in database" do
      Movie.find(1).title.should == 'test'
    end
    it "should put notice for a user" do
      flash[:notice].should == "test was successfully created."
    end
    it "should redirect to movies list" do
      response.should redirect_to movies_path
    end
  end
  describe 'movies removal' do
    it 'should destory a movie' do 
      movie = FactoryGirl.build(:movie)
      Movie.stub(:find).and_return(movie)
      movie.should_receive(:destroy)
      delete :destroy, :id => 1
    end
  end
end
