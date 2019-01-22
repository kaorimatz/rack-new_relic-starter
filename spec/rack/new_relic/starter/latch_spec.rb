# frozen_string_literal: true

RSpec.describe Rack::NewRelic::Starter::Latch do
  describe '#open!' do
    it 'opens the latch' do
      latch = described_class.new
      pid = Process.fork do
        latch.open!
      end
      Process.wait(pid)
      expect(latch).to be_opened
    end
  end

  describe '#opened?' do
    it 'returns true if the latch is opened' do
      latch = described_class.new
      expect(latch).not_to be_opened
      latch.open!
      expect(latch).to be_opened
    end
  end
end
