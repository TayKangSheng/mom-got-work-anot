if ENV["APP_ENV"] == "production"
  Bundler.require(:default)
else
  Bundler.require(:default, :development)
end

require "yaml"
require "date"
require "slim"

get "/" do
  today = Time.now.getlocal("+08:00").to_date

  dates = get_file(today.year)
  @message = "No data found." if dates.nil?

  dates["holidays"].each do |d|
    holiday_date = Date.parse(d["date"])

    @message = "No. Its #{d["name"]}" if holiday_date == today

    if holiday_date.sunday?
      @message = "No. Its #{d["name"]} in lieu!" if (holiday_date + 1) == today
    end
  end

  @message = "No. Its Saturday!" if today.saturday?
  @message = "No. Its Sunday!" if today.sunday?

  @message = "Yes! Go to work!" if @message.empty?

  slim :base, layout: false do
    slim :index
  end
end

def get_file(year)
  begin
    YAML.load_file("data/#{year}.yml")
  rescue StandardError
    nil
  end
end
