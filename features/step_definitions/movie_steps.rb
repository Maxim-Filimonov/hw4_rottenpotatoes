Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_title, director|
  movie = Movie.find_by_title movie_title
  movie.director.should == director
end
# Add a declarative step here for populating the DB with movies.

When /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  movies = get_movies_from_page
  index_of_e1 = movies.find_index(e1)
  index_of_e2 = movies.find_index(e2)
  index_of_e2.should be > index_of_e1
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rate|
    unless uncheck
      step %Q{I check "ratings_#{rate}"}
    else
      step %Q{I uncheck "ratings_#{rate}"}
    end
  end
end
Then /^I should see (\d+|all) movies?$/ do |number_of_movies|
  number_of_movies = Movie.count if number_of_movies == "all"
  movies_displayed = get_movies_from_page
  movies_displayed.should have(number_of_movies).movies,"But got #{movies_displayed}"
end
def get_movies_from_page
  all("#movies tbody tr td:eq(1)").map {|m| m.text}
end
