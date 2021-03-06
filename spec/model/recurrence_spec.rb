require File.dirname(__FILE__) + '/../spec_helper'

describe 'Recurrence' do
  it 'should be invalid without an interval' do
    recurrence = Recurrence.make_unsaved :interval => nil
    recurrence.save
    recurrence.errors.on(:interval).should include('can\'t be blank')
  end

  it 'should be invalid with a negative interval' do
    recurrence = Recurrence.make_unsaved :interval => -7
    recurrence.save
    recurrence.errors.on(:interval).should include('must be greater than zero')
  end
  
  it 'should be invalid without starts_at' do
    recurrence = Recurrence.make_unsaved :starts_at => nil
    recurrence.save
    recurrence.errors.on(:starts_at).should include('can\'t be blank')
  end  
  
  it 'should be valid with a positive non-zero interval and with starts_at' do
    recurrence = Recurrence.make_unsaved :interval => 1, :starts_at => Time.now
    recurrence.should be_valid
  end
  
  describe '[](index) instance method' do
    before(:all) do
      stub_current_time
      x = Time.now + 10.days
      @recurrence = Recurrence.make :interval => 1.day, :starts_at => Time.now.utc, :ends_at => (Time.now + 10.days).utc
    end
    
    it 'should return 1st occurrence if index = 0' do
      @recurrence[0].should == @recurrence.starts_at
    end

    it 'should return 8th occurrence if index = 7' do
      @recurrence[7].should == @recurrence.starts_at + 7 * @recurrence.interval
    end
    
    it 'should return 11th occurrence if index = 10' do
      @recurrence[10].should == @recurrence.starts_at + 10 * @recurrence.interval
    end
    
    it 'should return nil if index < 0' do
      @recurrence[-1].should be_nil
    end

    it 'should return nil if the specified occurrence is past the ends_at date' do
      @recurrence[11].should be_nil
    end

    # TODO: clean up below specs, and be more thorough
    describe 'if updated 2 days later to an interval of 12.hours' do
      it 'should have starts_at + 2.days as its first occurrence' do
        Time.stubs(:now).returns(@recurrence.created_at + 2.days)
        @recurrence.update_attributes(:interval => 12.hours)
        @recurrence[0].should == @recurrence.starts_at + 2.days
      end
    end
    
    describe 'if updated 2 days and a few minutes later to an interval of 12.hours' do
      it 'should have starts_at + 2.days + 12.hours as its first occurrence' do
        Time.stubs(:now).returns(@recurrence.created_at + 2.days + 3.minutes)
        @recurrence.update_attributes(:interval => 12.hours)
        @recurrence[0].should == @recurrence.starts_at + 2.days + 12.hours
      end
    end    
  end
end
