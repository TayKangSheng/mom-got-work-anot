if ENV["APP_ENV"] == "production"
  Bundler.require(:default)
else
  Bundler.require(:default, :development)
end

require "yaml"
require "date"

get "/" do
  today = Time.now.getlocal("+08:00").to_date

  dates = get_file(today.year)
  return "No data found." if dates.nil?

  dates["holidays"].each do |d|
    holiday_date = Date.parse(d["date"])

    return "No. Its #{d["name"]}" if holiday_date == today

    if holiday_date.sunday?
      return "No. Its #{d["name"]} in lieu!" if (holiday_date + 1) == today
    end
  end

  return "No. Its Saturday!" if today.saturday?
  return "No. Its Sunday!" if today.sunday?
  "Yes! Go to work!"
end

def get_file(year)
  begin
    YAML.load_file("data/#{year}.yml")
  rescue StandardError
    nil
  end
end
