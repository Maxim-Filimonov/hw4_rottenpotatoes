Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_title, director|
  movie = Movie.find_by_title movie_title
  movie.director.should == director
end
Given /^the following movies exist:$/ do |table|
  table.hashes.each do |movie|
    Movie.create!(movie)
  end
end
