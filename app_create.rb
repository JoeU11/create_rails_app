#This file is an attempt to create some sort of automation for creating a new app
#Upcoming goals to include: 
# 1) option to generate db method and modify seeds.rb file to include format to add instances. 
# 2) option at beginning to pick directory to create app.
# 3) option to select additional gems to bundle with app.

#current use - place this in the file where you want to create your app and run


p "Enter the name of your app"
app_name = gets.chomp


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


system "rails new #{app_name}"
Dir.chdir "#{app_name}/"
system "rails db:create"
system "rails db:migrate"
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


