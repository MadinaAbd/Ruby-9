require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'validate'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

MENU = [
  { index: 1, title: 'Создать новую стануию', action: :new_station },
  { index: 2, title: 'Создать новый поезд', action: :new_train },
  { index: 3, title: 'Создать новый вагон', action: :new_wagon },
  { index: 4, title: 'Задать маршрут', action: :new_route },
  { index: 5, title: 'Задать маршрут поезду', action: :set_route_train },
  { index: 6, title: 'Добавить вагон', action: :add_wagon_train },
  { index: 7, title: 'Удалить вагон', action: :remove_wagon },
  { index: 8, title: 'Менять станцию', action: :change_station },
  { index: 9, title: 'Показать станции', action: :view_station_and_trains },
  { index: 10, title: 'Добавить количество места в грузовом вагоне', action: :get_volume! },
  { index: 11, title: 'Добавить количество сидений в вагоне', action: :get_place! }
].freeze

def new_station
  puts 'Введите название нового класса:'
  class_station_name = gets.chomp.to_sym
  begin
    puts 'Введите новую станцию:'
    station_name = gets.chomp.to_sym
    class_station_name = Station.new(station_name)
    puts "Станция #{class_station_name} создана."
  rescue StandardError
    puts 'Ошибка в названии - неверный формат.'
    retry
  end
end

def new_train
  type = type_train
  number = train_number
  create_train(type, number)
end

def type_train
  puts 'Введите 1 для создания поезда типа "passenger" '
  puts 'Введите 2 для создания поезда типа "cargo" '
  gets.chomp.to_i
rescue RuntimeError => e
  puts e
  retry
end

def train_number
  puts 'Введите номер поезда'
  number = gets.chomp.to_s
  puts 'Ошибка, номер поезда не соответствует формату "...-.." попробуйте еще раз!' if number !~ Train::NUMBER
rescue RuntimeError => e
  puts e
  retry
end

def create_train(type, number)
  case type
  when 1
    @trains << PassengerTrain.new(number)

  when 2
    @trains << CargoTrain.new(number)
  end
  puts "Создан поезд с номером #{number}"
end

def new_wagon
  type = wagon_type
  number = wagon_number
  volume = get_volume(type)
  create_wagon(type, number, volume)
end

def wogon_number
  puts 'Введите номер нового вагона'
  number = gets.chomp.to_s
  puts 'Ошибка, номер вагона не соответствует формату "...-.." попробуйте еще раз!' if number !~ Train::NUMBER

  number
rescue RuntimeError => e
  puts e
  retry
end

def get_volume!(type)
  case type
  when 1
    get_place!
  when 2
    gets_volume!
  end
end

def place!
  puts 'Введите количество'
  place = gets.chomp.to_i
  raise 'Ошибка' if place < 1

  place
rescue RuntimeError => e
  puts e
  retry
end

def volume!
  puts 'Введите количество'
  volume = gets.chomp.to_f
  raise 'Ошибка' if volume <= 0

  volume
rescue RuntimeError => e
  puts e
  retry
end

def create_carriage(type, number, volume)
  case type
  when 1
    carriage = PassengerCarriage.new(number, volume)
  when 2
    carriage = CargoCarriage.new(number, volume)
  end
  puts "Создан новый вагон: #{carriage}"
end

def new_route
  puts "Введите 'new' для создания нового маршрута"
  puts "Введите'manage' для управления станцией "
  user_choise = gets.chomp.to_sym

  case user_choise
  when :new
    puts 'Введите название нового класса:'
    class_route_name = gets.chomp
    puts 'Добавить первую станцию маршрута'
    first_station = gets.chomp.to_sym
    puts 'Добавить последнюю станцию маршрута'
    last_station = gets.chomp.to_sym
    class_route_name = Route.new(first_station, last_station)
    puts class_route_name

  when :manage
    puts "Введите 'add' для добавления станции в маршрут"
    puts "Введите 'delete' для удаления станции"
    user_choise = gets.chomp.to_sym

    case user_choise
    when :add
      puts 'Введите название класса новой станции на маршруте'
      class_station_name = gets.chomp
      puts 'Введите маршрут для добавления станции'
      changed_route = gets.chomp
      changed_route.add_station(class_station_name)

    when :delete
      puts 'Введите название класса станции для удаления'
      class_station_name = gets.chomp
      puts 'Введите маршрут для удаления станции'
      changed_route = gets.chomp
      changed_route.delete_station(class_station_name)

    else puts 'Ошибка'
    end
  end
end

def set_route_train
  puts 'Введите название класса маршрута:'
  name_class_train = gets.chomp
  puts 'Введите название класса маршрута для поезда'
  route_for_set = gets.chomp
  name_class_train.set_route(route_for_set)
end

def add_wagon_train
  puts 'Введите названиe класса поезда для добавления вагонов'
  class_train_name = gets.chomp
  puts 'Введите название класса вагона для добавления в поезд'
  class_wagon_name = gets.chomp
  class_train_name.add_wagon(class_wagon_name)
  puts 'Ошибка, поезд еще не остановился' unless speed.zero?
  puts 'Ошибка типа вагона' unless name_class_train.type_train == class_wagon_name.type
end

def remove_wagon
  uts 'Введите названиe класса поезда для удаления вагоноa'
  class_train_name = gets.chomp
  puts 'Введите название класса вагона для удаления'
  class_wagon_name = gets.chomp
  class_train_name.del_wagon(class_wagon_name)
  puts 'Ошибка, поезд еще не остановился' unless speed.zero?
  puts 'Ошибка типа вагона' unless name_class_train.type_train == class_wagon_name.type
end

def change_station
  puts "Введите 'next' для перехода на следующую станцию"
    .puts "Введите 'back' для перехода на предыдущию станцию."
  user_choise = gets.chomp.to_sym

  case user_choise
  when :next
    puts 'Введите название класса поезда для перехода на следующую станцию'
    class_train_name = gets.chomp
    class_train_name.move_forward

  when :back
    puts 'Введите название класса поезда для перехода на предыдущую станцию'
    class_train_name = gets.chomp
    class_train_name.move_back

  else
    puts 'Ошибка'
  end
end

def view_station_and_trains
  puts 'Введите название класса маршрута для просмотра списка станций'
  class_route_name = gets.chomp
  class_route_name.way
  puts 'Введите название класса станции для просмотра списка поездов на ней'
  class_station_name = gets.chomp
  class_station_name.trains
end

loop do
  puts 'Введите свой выбор'
  MENU.each { |item| puts "#{item [:index]}: #{item[:title]}" }
  choice = gets.chomp.to_i
  need_item = MENU.find { |item| item[:index] == choice }
  send(need_item[:action])
  puts "Введите любую клавишу для продолжения или 'exit' для выхода"
  break if gets.chomp.to_sym == :exit
end
