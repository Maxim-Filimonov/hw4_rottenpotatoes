class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.find_with_same_director(id)
    current_movie = Movie.find(id)
    if current_movie.director.blank? 
      return nil
    end
    self.where("director = ? AND id != ?", current_movie.director,current_movie.id)
  end
end
