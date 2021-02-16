require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it {should belong_to :pet}
    it {should belong_to :application}
    it {should validate_presence_of :application}
    it {should validate_presence_of :pet}
  end
end