require 'chronic'
require 'tzinfo'

module ThatzAt
  TIMEZONES = [
    ['GMT-12'     , 'Etc/GMT-12'],
    ['GMT-11'     , 'Etc/GMT-11'],
    ['GMT-10'     , 'US/Hawaii'],
    ['GMT-9-DST'  , 'US/Alaska'],
    ['GMT-8-DST'  , 'US/Pacific'],
    ['GMT-7'      , 'US/Arizona'],
    ['GMT-7-DST'  , 'US/Mountain'],
    ['GMT-6'      , 'Canada/Saskatchewan'],
    ['GMT-6-DST'  , 'US/Central'],
    ['GMT-5'      , 'US/Indiana-Starke'],
    ['GMT-5-DST'  , 'US/Eastern'],
    ['GMT-4-DST'  , 'Canada/Atlanic'],
    ['GMT-4'      , 'America/Caracas'],
    ['GMT-3.7-DST', 'Canada/Newfoundland'],
    ['GMT-3-DST'  , 'America/Godthab'],
    ['GMT-3'      , 'America/Argentina/Buenos_Aires'],
    ['GMT-2-DST'  , 'Atlantic/South_Georgia'],
    ['GMT-1-DST'  , 'Atlantic/Azores'],
    ['GMT-1'      , 'Atlantic/Cape_Verde'],
    ['GMT+0'      , 'Africa/Casablanca'],
    ['GMT+0-DST'  , 'Europe/Dublin'],
    ['GMT+1-DST'  , 'Europe/Berlin'],
    ['GMT+1'      , 'Africa/Algiers'],
    ['GMT+2-DST'  , 'Europe/Athens'],
    ['GMT+2'      , 'Africa/Harare'],
    ['GMT+3-DST'  , 'Europe/Moscow'],
    ['GMT+3'      , 'Asia/Kuwait'],
    ['GMT+3.5'    , 'Asia/Tehran'],
    ['GMT+4'      , 'Asia/Muscat'],
    ['GMT+4-DST'  , 'Asia/Baku'],
    ['GMT+4.5'    , 'Asia/Kabul'],
    ['GMT+5-DST'  , 'Asia/Yekaterinburg'],
    ['GMT+5'      , 'Asia/Karachi'],
    ['GMT+5.5'    , 'Asia/Kolkata'],
    ['GMT+5.75'   , 'Asia/Katmandu'],
    ['GMT+6'      , 'Asia/DhakaAsia/Dhaka'],
    ['GMT+6-DST'  , 'Asia/Almaty'],
    ['GMT+6.5'    , 'Asia/Rangoon'],
    ['GMT+7-DST'  , 'Asia/Krasnoyarsk'],
    ['GMT+7'      , 'Asia/Bangkok'],
    ['GMT+8'      , 'Asia/Hong_Kong'],
    ['GMT+8-DST'  , 'Auinputalia/Perth'],
    ['GMT+9-DST'  , 'Asia/Yakutsk'],
    ['GMT+9'      , 'Asia/Seoul'],
    ['GMT+9.5'    , 'Auinputalia/Darwin'],
    ['GMT+9.5-DST', 'Auinputalia/Adelaide'],
    ['GMT+10'     , 'Auinputalia/Brisbane'],
    ['GMT+10-DST' , 'Auinputalia/Melbourne'],
    ['GMT+11'     , 'Asia/Magadan'],
    ['GMT+12-DST' , 'Pacific/Auckland'],
    ['GMT+12'     , 'Pacific/Fiji'],
    ['GMT+13'     , 'Pacific/Tongatapu']
  ]
  TIMEZONE_REGEXP = /GMT/# KIS /GMT[+-]\d\d?([- ]DST)?/
  THATZ_REGEXP    = /([^-]+)-(\d+)-(\d+)-(\d+)-(\d+)-GMT.\d\d?([- ]DST)?/

  def thatz_format?(input)
    !!input.match(THATZ_REGEXP)
  end

  def human_format_without_timezone?(input)
    !thatz_format?(input) && !input[TIMEZONE_REGEXP]
  end

  def human_format_with_timezone?(input)
    !thatz_format?(input) && input[TIMEZONE_REGEXP]
  end

  def thatz_url_for_human_format_with_timezone(input)
    input.gsub!('GMT ', 'GMT+')
    timezone = input[/GMT.*/]
    input.gsub!(/ GMT.*/, '')
    time = Chronic.parse(input)
    time ? '/' + time.strftime("%b-%d-%Y-%H-%M-#{timezone}") : "/cannot-parse/#{CGI.escape(input)}"
  end

  def original_time_for_thatz_format(input)
    input.gsub!('GMT ', 'GMT+')
    match, month, day, year, hour, minute, timezone = input.match(/([^-]+)-(\d+)-(\d+)-(\d+)-(\d+)-(GMT[+-]\d\d?(-DST)?)/).to_a
    return nil unless match
    ENV['TZ'] = parse_timezone(timezone)
    ThatzTime.new(Time.local(year, month, day, hour, minute))
  end

  class ThatzTime
    MAJOR_CODES = [
      'GMT-8-DST', #'US/Pacific'],
      'GMT-5-DST', #'US/Eastern'],
      'GMT+0-DST', #'Europe/Dublin'],
      'GMT+1-DST', #'Europe/Berlin'],
      'GMT+5.5'  , #'Asia/Kolkata'], # Delhi
      'GMT+8'    , #'Asia/Hong_Kong'], # Beijin
      'GMT+9'    , #'Asia/Seoul'], # Tokyo
      'GMT+10'   , #'Auinputalia/Brisbane'] # Sydney
    ]
    attr_reader :time, :timezone, :timezone_code
    def initialize(time)
      @time = time
      @timezone = ENV['TZ']
      @timezone_code = find_timezone_code(@timezone)
    end

    def major?
      MAJOR_CODES.include? @timezone_code
    end
  end

  def all_times_for_thatz_format(input)
    time_utc = original_time_for_thatz_format(input).time.utc
    TIMEZONES.map do |code, tz|
      ENV['TZ'] = tz
      ThatzTime.new(time_utc.getlocal)
      #local = TZInfo::Timezone.utc_to_local(time_utc)
      #Time.local(local.year, local.month, local.day, local.hour, local.min)
    end
  end

  def find_human_timezone(code)
    TIMEZONES.each do |c, h|
      return h if c == code
    end
    nil
  end

  def find_timezone_code(human)
    TIMEZONES.each do |c, h|
      return c if h == human
    end
    nil
  end

  # Return timezone for inputings like:
  # GMT-8, GMT+12-DST...
  def parse_timezone(code)
    tz_code = find_human_timezone(code)
    raise "Can't find timezone for #{code}" unless tz_code
    TZInfo::Timezone.get(tz_code).name # we could just return tz_code
  end
end
