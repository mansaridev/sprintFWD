# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:members).dependent(:destroy) }
  end

  describe 'Database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
