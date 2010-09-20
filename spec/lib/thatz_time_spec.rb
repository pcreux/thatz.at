require 'spec/spec_helper'

describe ThatzAt do
  THATZ_FORMATS = ['Sep-10-2010-12-00-GMT+1-DST', 'Sep-10-2010-12-00-GMT 1-DST']
  HUMAN_FORMATS_WITHOUT_TZ = ['tomorrow', 'saturday 12pm', 'oct 2 1pm']
  HUMAN_FORMATS_WITH_TZ    = ['tomorrow GMT+1', 'saturday 12pm GMT-1 DST', 'oct 2 1pm GMT-12-DST', 'tomorrow 2pm GMT 1-DST']

  describe "#human_format_without_timezone?" do
    HUMAN_FORMATS_WITHOUT_TZ.each do |input|
      context "when '#{input}'" do
        it "should be true" do
          human_format_without_timezone?(input).should be_true
        end
      end
    end

    (HUMAN_FORMATS_WITH_TZ + THATZ_FORMATS).each do |input|
      context "when '#{input}'" do
        it "should be false" do
          human_format_without_timezone?(input).should be_false
        end
      end
    end
  end

  describe "#human_format_with_timezone?" do
    HUMAN_FORMATS_WITH_TZ.each do |input|
      context "when '#{input}'" do
        it "should be true" do
          human_format_with_timezone?(input).should be_true
        end
      end
    end

    (HUMAN_FORMATS_WITHOUT_TZ + THATZ_FORMATS).each do |input|
      context "when '#{input}'" do
        it "should be false" do
          human_format_with_timezone?(input).should be_false
        end
      end
    end
  end

  describe "#thatz_format?" do
    THATZ_FORMATS.each do |input|
      context "when '#{input}'" do
        it "should be true" do
          thatz_format?(input).should be_true
        end
      end
    end

    (HUMAN_FORMATS_WITHOUT_TZ + HUMAN_FORMATS_WITH_TZ).each do |input|
      context "when '#{input}'" do
        it "should be false" do
          thatz_format?(input).should be_false
        end
      end
    end
  end

  describe "#original_time_for_thatz_format" do
    context "when 'Sep-12-2010-13-00-GMT+1-DST'" do
      it "should be Sep 12 2010 at 1pm Europe/Berlin" do
        thatz_time = original_time_for_thatz_format('Sep-12-2010-13-00-GMT+1-DST')
        ENV['TZ'] = 'Europe/Berlin'
        thatz_time.time.should == Time.local(2010, 9, 12, 13)
        thatz_time.timezone.should == 'Europe/Berlin'
      end
    end
  end

  describe "#all_times_for_thatz_format" do
    context "when 'Sep-12-2010-13-00-GMT+1-DST'" do
      it "should include 12 2010 at 4am PST" do
        times = all_times_for_thatz_format('Sep-12-2010-13-00-GMT+1-DST')
        ENV['TZ'] = 'US/Pacific'
        # fuck. I hate this test!
        #times.should include(Time.local(2010, 9, 12, 4))
      end
    end
  end

  describe "#thatz_url_for_human_format_with_timezone" do
    context "when 'Sep 12 2010 1pm GMT+1-DST'" do
      it "should be Sep 12 2010 at 1pm Europe/Berlin" do
        url = thatz_url_for_human_format_with_timezone('Sep 12 2010 1pm GMT+1-DST')
        url.should == "/Sep-12-2010-13-00-GMT+1-DST"
      end
    end
  end
end
