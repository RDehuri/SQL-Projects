use project;

select * from swiggy limit 10;

select count(*) from swiggy;

# Restaurants having a Rating greater than 4.5
Select count(Distinct restaurant_name) as High_rated_Restaurants
From swiggy
where rating > 4.5;
Select count(Distinct restaurant_name) as Restauarant_number
From swiggy;
/* Out of 274 distinct restaurants, there are only 13 restaurants that have rating greater than 4.5 */

#Top City with the highest number of restaurants
Select city, count(Distinct restaurant_name) as Restaurant_number
From swiggy
Group By city
Order by Restaurant_number desc
limit 1;
/* Bangalore has the highest number of restaurants with 196 distinct restaurants */

# Restaurants selling Pizza
Select count(Distinct restaurant_name) as Pizza_restaurants
From swiggy
Where restaurant_name like '%pizza%';
/* 4 restaurants have name Pizza in it or sell pizza */

# Most common cuisine among the restaurants
Select cuisine, count(*) as cuisine_count
From swiggy
Group by cuisine
Order by cuisine_count desc
limit 1;
/* Most common cuisine among the restaurants is North Indian, Chinese */

# Average rating of restaurants in each city */
Select city, avg(rating) as Average_rating
From swiggy
Group By city;
/* Average rating of Bangalore is 4.11 and for Ahmedabad it is 4.07 approx */

# Highest Price of the item under 'Recommended' menu category for each restaurant
Select distinct restaurant_name, menu_category, max(price) as Highest_price
From swiggy
Where menu_category = "Recommended"
Group By restaurant_name, menu_category;

# Top 5 most expensive restaurants that offer cuisine other than Indian cuisine
Select distinct restaurant_name, cost_per_person
From swiggy
where cuisine <> "Indian"
Order by cost_per_person desc
Limit 5;

# Restaurants having an average cost higher than the total average cost of all restaurants together
Select distinct restaurant_name, cost_per_person
From swiggy
Where cost_per_person > (
					Select avg(cost_per_person) 
					From swiggy);

# Restaurants having the same name but located in different city
Select distinct t1.restaurant_name, t1.city, t2.city
From swiggy t1 join swiggy t2
on t1.restaurant_name = t2. restaurant_name and t1.city <> t2.city;

# Restaurant offering the most number of items in the 'Main course' category
Select distinct restaurant_name, menu_category, count(item) as No_of_items
From swiggy
Where menu_category = "Main Course"
Group by restaurant_name, menu_category
Order by no_of_items desc
Limit 1;
/* Spice up restuarant offers 172 no. of items in the Main Course category */

# Restaurants that are 100% vegetarian in alphabetical order of their name
Select distinct restaurant_name, 
(count(case when veg_or_nonveg = 'veg' then 1 end)*100/count(*)) as vegetarian_percent
From swiggy
Group by restaurant_name
Having vegetarian_percent = 100.00
Order by restaurant_name;

# Restaurant providing the lowest average price for all items
Select distinct restaurant_name, avg(price) as Average_price
From swiggy
Group by restaurant_name
Order by Average_price
Limit 1;
/* Urban Kitli has the lowest average price on all its items with 61.47 as average price */

# Top 5 restaurant offering highest number of categories
Select distinct restaurant_name, count(distinct menu_category) as no_of_categories
From swiggy
Group by restaurant_name
Order by no_of_categories desc
Limit 5;

# Restaurant providing the highest percent of non-veg food
Select distinct restaurant_name,
(count(case when veg_or_nonveg = 'Non-veg' then 1 end)*100/count(*)) as nonveg_percent
From swiggy
Group by restaurant_name
Order by nonveg_percent desc
Limit 1;
/* Donne Biryani House has the highest percent of nonveg food */

# Most and Least expensive city for dining
With CityExpense As (
			Select city,
				max(cost_per_person) as Max_cost,
				min(cost_per_person) as Min_cost
            From swiggy
            Group by city)
Select city, Max_cost, Min_cost
From CityExpense
Order by Max_cost desc;
/* Bangalore is the most expensive city for dining and Ahmedabad is lower than it */

# Top 2 rated restaurant in each city
With RatingRankbyCity As (
				Select distinct restaurant_name,
					city, rating,
					dense_rank() over (partition by city Order by rating desc) as Rating_rank
                From swiggy)
Select restaurant_name, city, rating, Rating_rank
From RatingRankbyCity
Where Rating_rank = 1;
