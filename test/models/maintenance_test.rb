require 'test_helper'

class MaintenanceTest < ActiveSupport::TestCase
  let(:path) { Rails.root.join('config/maintenance.enabled') }
  let(:custom_message) { '' }
  subject { Goodguide::Health::Maintenance.instance }

  describe 'enabled' do
    let(:enabled) { true }

    describe 'with a message' do
      let(:custom_message) { 'The message' }

      it 'should have the right message' do
        with_stubs do
          subject.message.must_equal custom_message
        end
      end

      it 'should be enabled' do
        with_stubs do
          subject.enabled?.must_equal true
        end
      end

      it 'should remove a file when disabling' do
        File.expects(:delete).with(path)
        with_stubs do
          subject.disable!
        end
      end
    end

    describe 'without a message' do
      it 'should have a blank message' do
        with_stubs do
          subject.message.must_equal false
        end
      end

      it 'should be enabled' do
        with_stubs do
          subject.enabled?.must_equal true
        end
      end
    end
  end

  describe 'disabled' do
    let(:enabled) { false }

    it 'should be disabled' do
      with_stubs do
        subject.enabled?.must_equal false
      end
    end

    it 'should enable with a message' do
      file = mock()
      File.expects(:open).with(path, 'w').returns(file)
      file.expects(:<<).with('message')
      file.expects(:close)

      subject.enable!('message')
    end

    it 'should enable with no' do
      file = mock()
      File.expects(:open).with(path, 'w').returns(file)
      file.expects(:<<).with(nil)
      file.expects(:close)

      subject.enable!
    end

  end

  private

  # There are other uses of File.read and File.exist? in the framework,
  # so we can only stub them out around our specific use case.
  def with_stubs
    File.stubs(:read).with(path).returns(custom_message)
    File.stubs(:exist?).with(path).returns(enabled)

    yield

    File.unstub(:read)
    File.unstub(:exist?)
  end
end
