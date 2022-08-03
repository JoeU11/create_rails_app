#This file is an attempt to create some sort of automation for creating a new app

#Upcoming goals to include: 
# 1) modify seeds.rb file to include format to add instances based on model input. 
# 2) input at beginning to pick directory to create app.
# 3) option to select additional gems to bundle with app.
# 4) make RESTful
# 5) add support for decimal class in database model


#use - place this in the file where you want to create your app and run

p "Enter the name of your app"
app_name = gets.chomp

model = false
controller = false
sample_route = false

while true
  p "Would you like to create a controller? (y/n)"
  response = gets.chomp.downcase
  if response == 'y'
    p "What would you like to name your controller? (plural please)"
    controller_name = gets.chomp.downcase
    controller = true

    while true
      p "Would you like to generate sample 'show' method and route? (y/n)"
      response = gets.chomp.downcase
      if response == "y"
        sample_route = true
        break
      elsif response == "n"
        break
      end
    end
    break
  elsif response == 'n'
    break
  end
end

while true
  p "Would you like to generate a database model?(y/n)"
  response = gets.chomp.downcase
  if response == 'y'
    model_vars = []
    p "What would you like to name your model?"
    model_name = gets.chomp #make initial cap (or "camal case")
    p "How many variables would you like to include?"
    var_num = gets.chomp.to_i
    count = 1
    var_num.times do
      p "What is the name of variable ##{count} (singular please. do not spaces nor ':')" #can add replacement of spaces with "_" and chomp off : and 's' if included
      var1_name = gets.chomp.downcase
      p "What type of class is variable ##{count}? (e.g. integer, string)" #can add conditional to ensure type is correct - add array of all possible classes and run .includes?
      var1_type = gets.chomp.downcase
      variable = [var1_name, var1_type]
      model_vars << variable
      count += 1
    end
    p "is the following correct? (y/n)"
    p model_vars
    correct = gets.chomp.downcase
    if correct == "y"
      model = true
      break
    elsif correct == "n"
    end
  elsif response == 'n'
    break
  end
end  
model_command = "rails generate model #{model_name}"
model_vars.each do |v|
  model_command = "#{model_command} #{v[0]}:#{v[1]} "
  p v
end


system "rails new #{app_name}"
Dir.chdir "#{app_name}/"
system "rails db:create"
if controller
  system "rails generate controller #{controller_name}"
end
if sample_route
  File.write("requests.http", "GET HTTP:localhost:3000/path.json")
  File.open("config/routes.rb", "r+") do |file|
    lines = file.each_line.to_a
    lines[5] = "  get '/path' => '#{controller_name}#method_name'\n" + lines[5]
    file.rewind
    file.write(lines.join)
  end
  File.open("app/controllers/#{controller_name}_controller.rb", "r+") do |file|
    lines = file.each_line.to_a
    lines[1] = "  def method_name\n     render json: {message: 'Hello World'}\n  end\n" + lines[1]
    file.rewind
    file.write(lines.join)
  end
end
if model
  system model_command
  system "rails db:migrate"
end


